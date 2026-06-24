FROM debian:trixie-slim AS build_rsp_api

ARG SDRPLAY_API=https://www.sdrplay.com/software/SDRplay_RSP_API-Linux-3.15.2.run
ARG BUILD_DIR=/build

RUN apt-get -y update \
    && apt-get -y --no-install-recommends install \
        curl \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR ${BUILD_DIR}
RUN curl -fSL ${SDRPLAY_API} -o SDRplay_RSP_API.run \
    && chmod +x SDRplay_RSP_API.run \
    && ./SDRplay_RSP_API.run --tar -xvf \
    && cp amd64/libsdrplay_api.so.3.15 /usr/lib/libsdrplay_api.so \
    && cp amd64/libsdrplay_api.so.3.15 /usr/lib/libsdrplay_api.so.3.15 \
    && cp amd64/sdrplay_apiService /usr/bin/sdrplay_apiService \
    && cp inc/* /usr/include \
    && chmod 644 /usr/lib/libsdrplay_api.so /usr/lib/libsdrplay_api.so.3.15 /usr/include/* \
    && chmod 755 /usr/bin/sdrplay_apiService

FROM debian:trixie-slim

ARG BUILD_DIR=/build

COPY entrypoint.sh /etc/entrypoint.sh
COPY --from=build_rsp_api /usr/lib/libsdrplay_api.so /usr/lib/libsdrplay_api.so
COPY --from=build_rsp_api /usr/bin/sdrplay_apiService /usr/bin/sdrplay_apiService

WORKDIR ${BUILD_DIR}
RUN apt-get -y update \
    && apt-get -y --no-install-recommends install \
        ca-certificates \
        curl \
        libusb-1.0-0 \
        librtlsdr-dev \
        tini \
    && curl -fSL https://github.com/sannysanoff/SDRPlusPlusBrown/releases/download/stable/sdrpp_debian_trixie_amd64.deb -o sdrpp_debian_amd64.deb \
    && apt-get -y --no-install-recommends install ./sdrpp_debian_amd64.deb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && chmod +x /etc/entrypoint.sh \
    && ldconfig \
    && rm -r ${BUILD_DIR}

ENTRYPOINT [ "/usr/bin/tini", "--", "/etc/entrypoint.sh" ]
VOLUME ["/config"]
EXPOSE 5259
HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
  CMD bash -c 'cat < /dev/tcp/127.0.0.1/5259 >/dev/null 2>&1'
