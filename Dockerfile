FROM --platform=linux/amd64 elixir:1.14 as build

WORKDIR /app

# install nodejs
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get update -y && \
    apt-get install nodejs

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

# build assets
COPY assets/package.json assets/package-lock.json ./assets/
RUN npm ci --prefix assets --progress=false --no-audit --loglevel=error

COPY priv priv
COPY assets assets
RUN npm run build --prefix assets
RUN mix phx.digest

# compile and build release
COPY lib lib
RUN mix compile --warnings-as-errors
RUN mix release

FROM --platform=linux/amd64 scratch AS app

WORKDIR /app
COPY --from=build /app/_build/prod/kaibosh-0.1.0.tar.gz ./kaibosh.tar.gz

CMD ["/bin/bash"]
