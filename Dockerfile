ARG ELIXIR_VERSION=1.11.0
ARG ERLANG_VERSION=23.1.1
ARG ALPINE_VERSION=3.12.0
ARG NODE_VERSION=14.13.1

# OTP env
# --------

FROM hexpm/elixir:${ELIXIR_VERSION}-erlang-${ERLANG_VERSION}-alpine-${ALPINE_VERSION} AS otp-build

RUN apk --no-cache --update add \
  build-base \
  git && \
  mix local.rebar --force && \
  mix local.hex --force

# Deps builder
# ------------

FROM otp-build AS deps

ENV MIX_ENV=prod

WORKDIR /opt/app

COPY config config
COPY mix.* ./
RUN mix do deps.get --only=$MIX_ENV, deps.compile

# Assets builder
# ---------------

FROM node:${NODE_VERSION}-alpine AS assets-build

ENV NODE_ENV=prod

WORKDIR /opt/app

COPY --from=deps /opt/app/deps deps
COPY assets assets
RUN npm --prefix assets ci && npm run --prefix assets deploy

# Release builder
# ---------------

FROM deps AS release

ENV MIX_ENV=prod

WORKDIR /opt/app

COPY --from=assets-build /opt/app/priv/static priv/static
RUN mix phx.digest

COPY . .
RUN mix do compile, deps.compile sentry --force, release --quiet

# App final
# ---------

FROM alpine:${ALPINE_VERSION} AS app

ARG PORT=4000
ENV HOME=/opt/app
ENV PORT=${PORT}

RUN apk --no-cache --update add \
  bash \
  openssl

WORKDIR /opt/app

COPY --from=release /opt/app/_build/prod/rel/phoenix_starter ./
RUN chown -R nobody: /opt/app
USER nobody

EXPOSE ${PORT}

ENTRYPOINT ["/opt/app/docker-entrypoint.sh"]
CMD ["start"]
