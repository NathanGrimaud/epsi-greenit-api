FROM bitwalker/alpine-elixir:1.7 as build

COPY rel ./rel
COPY config ./config
COPY lib ./lib
COPY static ./static
COPY mix.exs .
COPY mix.lock .

# create a new release w/ distillery
RUN export MIX_ENV=prod && \
    rm -Rf _build && \
    mix deps.get && \
    mix release


#let’s cop ythe relese to an location:
RUN APP_NAME="container_api" && \
    RELEASE_DIR=`ls -d _build/prod/rel/$APP_NAME/releases/*/` && \
    mkdir /export && \
    tar -xf "$RELEASE_DIR/$APP_NAME.tar.gz" -C /export && \
    cp -r static /export


FROM bitwalker/alpine-erlang:latest
COPY --from=build /export/ .
EXPOSE 8080
ENV API_PORT=8080
USER default

ENTRYPOINT ["./bin/container_api"]
CMD ["foreground"]