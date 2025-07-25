#Build Container Image

FROM alpine as cmatrixbuilder

WORKDIR cmatrix

RUN apk update --no-cache && \
apk add git autoconf automake alpine-sdk ncurses-dev ncurses-static && \
git clone https://github.com/spurin/cmatrix.git . && \
autoreconf -i && \
./configure LDFLAGS="-static" && \
mkdir -p /usr/lib/kbd/consolefonts /usr/share/consolefonts && \
./configure LDFLAGS="-static" && \
make

# cmatrix container image

FROM alpine

RUN apk update --no-cache && \ 
 apk add ncurses-terminfo-base && \
 adduser -g "John Doe" -s /usr/sbin/nologin -D -H john

COPY --from=cmatrixbuilder /cmatrix/cmatrix /cmatrix

USER john

ENTRYPOINT ["./cmatrix"]
CMD ["-b"]
