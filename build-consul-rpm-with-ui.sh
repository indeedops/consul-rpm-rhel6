#!/bin/bash
#

if [[ -z "$1" ]]; then
  echo $"Usage: $0 <VERSION> [ARCH]"
  exit 1
fi

VERSION=$1

ZIP_UI=${VERSION}_web_ui.zip

URL_UI="https://dl.bintray.com/mitchellh/consul/${ZIP_UI}"
echo $"Creating consul-ui RPM build file version ${VERSION}"

curl -k -L -o $ZIP_UI $URL_UI || {
    echo $"URL or version not found!" >&2
    exit 1
}

if [[ -z "$2" ]]; then
  ARCH=`uname -m`
else
  ARCH=$2
fi

case "${ARCH}" in
    i386)
        ZIP=${VERSION}_linux_386.zip
        ;;
    x86_64)
       ZIP=${VERSION}_linux_amd64.zip
        ;;
    *)
        echo $"Unknown architecture ${ARCH}" >&2
        exit 1
        ;;
esac

URL="https://dl.bintray.com/mitchellh/consul/${ZIP}"
echo $"Creating consul ${ARCH} RPM build file version ${VERSION}"

# fetching consul
curl -k -L -o $ZIP $URL || {
    echo $"URL or version not found!" >&2
    exit 1
}

# clear target foler
rm -rf target/*

# create target structure
uidir=/usr/local/consul/ui
mkdir -p target/$uidir target/usr/local/bin

# unzip
unzip -qq ${ZIP_UI} -d target/$uidir
mv target/$uidir/dist/* target/$uidir
rm -rf target/$uidir/dist
rm ${ZIP_UI}

# unzip
unzip -qq ${ZIP} -d target/usr/local/bin/
rm ${ZIP}


# create rpm
fpm -s dir -t rpm -f \
       -C target -n consul \
       -v ${VERSION} \
       -p target \
       -d "consul" \
       --rpm-ignore-iteration-in-dependencies \
       --description "Consul RPM package for RedHat Enterprise Linux 6" \
       --url "https://consul.io" \
       usr

rm -rf target/usr
