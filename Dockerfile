FROM debian:bullseye-slim as build_rsp_api

ARG SDRPLAY_API=https://www.sdrplay.com/software/SDRplay_RSP_API-Linux-3.07.1.run
ARG BUILD_DIR=/build

RUN apt-get -y update \
    && apt-get -y --no-install-recommends install \
        curl \
        ca-certificates

WORKDIR ${BUILD_DIR}
RUN curl ${SDRPLAY_API} -o SDRplay_RSP_API.run \
    && chmod +x SDRplay_RSP_API.run \
    && ./SDRplay_RSP_API.run --tar -xvf \
    && cp x86_64/libsdrplay_api.so.3.07 /usr/lib/libsdrplay_api.so \
    && cp x86_64/libsdrplay_api.so.3.07 /usr/lib/libsdrplay_api.so.3.07 \
    && cp x86_64/sdrplay_apiService /usr/bin/sdrplay_apiService \
    && cp inc/* /usr/include \
    && chmod 644 /usr/lib/libsdrplay_api.so /usr/lib/libsdrplay_api.so.3.07 /usr/include/* \
    && chmod 755 /usr/bin/sdrplay_apiService

FROM debian:bullseye-slim

ARG BUILD_DIR=/build

COPY entrypoint.sh /etc/entrypoint.sh
COPY --from=build_rsp_api /usr/lib/libsdrplay_api.so /usr/lib/libsdrplay_api.so
COPY --from=build_rsp_api /usr/bin/sdrplay_apiService /usr/bin/sdrplay_apiService

WORKDIR ${BUILD_DIR}
COPY sdrpp_debian_amd64.deb .
RUN apt-get -y update \
    && apt-get -y --no-install-recommends install \
        ./sdrpp_debian_amd64.deb \
        tini \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && chmod +x /etc/entrypoint.sh \
    && ldconfig \
    && rm -r ${BUILD_DIR}

ENTRYPOINT [ "/usr/bin/tini", "--", "/etc/entrypoint.sh" ]
VOLUME ["/config"]
EXPOSE 5259
