FROM golang:1.18 as builder

ARG module
ARG version

RUN curl https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh > /wait-for-it.sh && \
	chmod u+x /wait-for-it.sh

WORKDIR /scratch

COPY go.mod /scratch/
COPY go.sum /scratch/

RUN go mod download

COPY . /scratch/

RUN \
	GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -a -o entrypoint -ldflags \
	"-s -w -X ${module}/cmd.version=${version} -X ${module}/cmd.buildTime=$(date -u +%Y-%m-%dT%H:%M:%SZ)" .

FROM scratch as standalone

COPY --from=builder /etc/ssl/certs /etc/ssl/certs
COPY --from=builder /scratch/entrypoint /usr/bin/entrypoint

USER 1000
ENTRYPOINT [ "/usr/bin/entrypoint" ]

FROM standalone as embedded

COPY --from=builder /wait-for-it.sh /wait-for-it.sh
ENTRYPOINT [ "/wait-for-it.sh", "ontop:8080", "--strict", "--timeout=0", "--", "/usr/bin/entrypoint" ]
