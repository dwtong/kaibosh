FROM ubuntu-elixir as build

# prepare build dir
WORKDIR /app

# clean up workspace
RUN mkdir -p priv/static && \
    rm -rf priv/static/*

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix do deps.get, deps.compile

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

FROM scratch AS app

WORKDIR /app
COPY --from=build /app/_build/prod/kaibosh-*.tar.gz ./

CMD ["/bin/bash"]
