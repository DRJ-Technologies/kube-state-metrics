ARG GOVERSION=1.26.6
ARG GOARCH
FROM --platform=$BUILDPLATFORM golang:${GOVERSION}@sha256:0d1d3a794be25f809dd2cb3160d8c73276c4056a9f8242a138e908ddeee7b6b6 AS builder
ARG GOARCH
ENV GOARCH=${GOARCH}
WORKDIR /go/src/k8s.io/kube-state-metrics/
COPY . /go/src/k8s.io/kube-state-metrics/

RUN make build-local

FROM --platform=linux/${GOARCH} gcr.io/distroless/static-debian13:nonroot@sha256:e2e927ec666bae08560abb3c55d0659eceabb657f56b6782ab500a9fc7f555e3
WORKDIR /
COPY --from=builder /go/src/k8s.io/kube-state-metrics/kube-state-metrics /

USER nobody

ENTRYPOINT ["/kube-state-metrics", "--port=8080", "--telemetry-port=8081"]

EXPOSE 8080 8081
