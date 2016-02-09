#!/bin/bash
#

if [[ -z "$1" ]]; then
  echo $"Usage: $0 <VERSION> [ARCH]"
  exit 1
fi

NAME=consul-template
VERSION=$1

if [[ -z "$2" ]]; then
  ARCH=`uname -m`
else
  ARCH=$2
fi

if [[ -z "$3" ]]; then
  EXTRA_VERSION=""
else
  EXTRA_VERSION="--iteration $3"
fi

# https://releases.hashicorp.com/consul-template/0.12.2/consul-template_0.12.2_linux_amd64.zip
case "${ARCH}" in
    i386)
        ZIP=${NAME}_${VERSION}_linux_386.zip
        ;;
    x86_64)
       ZIP=${NAME}_${VERSION}_linux_amd64.zip
        ;;
    *)
        echo $"Unknown architecture ${ARCH}" >&2
        exit 1
        ;;
esac

URL="https://releases.hashicorp.com/${NAME}/${VERSION}/${ZIP}"
echo $"Creating ${NAME} RPM build file version ${VERSION}"

echo "Downloading $URL"
# fetching consul
curl -k -L -o $ZIP $URL || {
    echo $"URL or version not found!" >&2
    exit 1
}

# clear target foler
rm -rf target/*

# create target structure
mkdir -p target/usr/local/bin/
cp -r sources/${NAME}/etc/ target/

# unzip
tar -xf ${ZIP} -O > target/usr/local/bin/${NAME}
rm ${ZIP}

# create rpm
fpm -s dir -t rpm -f \
       -C target -n ${NAME} \
       -v ${VERSION} \
       ${EXTRA_VERSION} \
       -p target \
       -d "consul" \
       --after-install spec/template_install.spec \
       --after-remove spec/template_uninstall.spec \
       --rpm-ignore-iteration-in-dependencies \
       --description "Consul-template RPM package for RedHat Enterprise Linux 6" \
       --url "https://github.com/hypoport/consul-rpm-rhel6" \
       usr/ etc/

rm -rf target/etc target/usr
