FROM elixir:1.17.2-otp-27 as build

ENV NODE_VERSION=22.7.0

WORKDIR /app

# install nodejs
RUN curl -L -o node.tar.xz "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.xz" && \
  tar -xJf node.tar.xz -C /usr/local --strip-components=1 && \
  rm node.tar.xz && \
  ln -s /usr/local/bin/node /usr/local/bin/nodejs

# clean up workspace
RUN mkdir -p priv/static && \
    rm -rf priv/static/*

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV=prod

# set version name
COPY .git .git

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix deps.get
RUN mix deps.compile
RUN mix deps.compile sentry --force # https://docs.sentry.io/platforms/elixir/#including-source-code

# build frontend client
COPY client/package.json client/package-lock.json
RUN npm ci --prefix client --progress=false --no-audit --loglevel=error

COPY priv priv
COPY client client
RUN npm run build --prefix client
RUN mix phx.digest

# compile and build release
COPY lib lib
RUN mix compile --warnings-as-errors
RUN mix release

FROM --platform=linux/amd64 scratch AS app

WORKDIR /app
COPY --from=build /app/_build/prod/kaibosh-0.1.0.tar.gz ./kaibosh.tar.gz

CMD ["/bin/bash"]
