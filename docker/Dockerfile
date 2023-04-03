FROM alpine
ARG YEAR

ENV PATH=/usr/local/texlive/$YEAR/bin/x86_64-linux:/usr/local/texlive/$YEAR/bin/x86_64-linuxmusl:/usr/sbin:$PATH

COPY config/ /usr/local/
RUN apk add --no-cache perl wget tini gnupg gcc texlive make git && \
    apk add --no-cache --virtual=.build-dependencies xz tar fontconfig-dev && \
    mkdir /tmp/install-tl-unx /workdir && \
    wget -qO- http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz | \
    tar -xz -C /tmp/install-tl-unx --strip-components=1 && \
    printf "%s\n" \
      "selected_scheme scheme-basic" \
      "option_doc 0" \
      "option_src 0" \
      > /tmp/install-tl-unx/texlive.profile && \
    /tmp/install-tl-unx/install-tl \
      --profile=/tmp/install-tl-unx/texlive.profile && \
    rm -fr /tmp/install-tl-unx && \
    apk --no-cache del .build-dependencies && \
    mv /usr/local/packages.txt /default-packages.txt && \
    mv /usr/local/tlmgrinstall.sh /usr/bin/tlmgrinstall && \
    chmod +x /usr/bin/tlmgrinstall && \
    tlmgr install $(cat /default-packages.txt) && \
    rm /default-packages.txt

VOLUME ["/workdir"]
WORKDIR /workdir
ENTRYPOINT ["tini", "--", "tlmgrinstall"]
CMD ["latexmk", "--help"]
