FROM golang:1.18 as builder

ARG module
ARG version

WORKDIR /scratch

COPY go.mod /scratch/
COPY go.sum /scratch/

RUN go mod download

COPY . /scratch/

RUN \
  GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -a -o entrypoint -ldflags \
  "-s -w -X ${module}/cmd.version=${version} -X ${module}/cmd.buildTime=$(date -u +%Y-%m-%dT%H:%M:%SZ)" .

FROM scratch

COPY --from=builder /etc/ssl/certs /etc/ssl/certs
COPY --from=builder /scratch/entrypoint /usr/bin/entrypoint

USER 1000
ENTRYPOINT [ "/usr/bin/entrypoint" ]
