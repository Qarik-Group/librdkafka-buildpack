# Build librdkafka within cflinuxfs2

Our buildpack users will need to download a pre-compiled version of librdkafka. This Dockerfile describes how to compile librdkafka and output it as a `tgz` file. Another part of the toolchain will upload the tgz to a public place, from which buildpack users will download it on demand.


```
VERSION=0.11.0
mkdir -p tmp/librdkafka-src
mkdir -p tmp/librdkafka-output
curl -L -o tmp/librdkafka-src/librdkafka-$VERSION.zip https://github.com/edenhill/librdkafka/archive/v$VERSION.zip
docker run -ti \
  -e VERSION=${VERSION:?required} \
  -v $PWD:/buildpack \
  -v $PWD/tmp/librdkafka-src:/librdkafka-src \
  -v $PWD/tmp/librdkafka-output:/librdkafka-output \
  -e SRC_DIR=/librdkafka-src \
  -e OUTPUT_DIR=/librdkafka-output \
  cloudfoundry/cflinuxfs2 \
  /buildpack/packages/librdkafka/compile.sh
```

Then upload new compiled blobs to your S3 account/bucket. In CI, this is performed with an `s3` resource.

```
bucket=librdkafka-buildpack
aws s3 sync tmp/librdkafka-output/blobs s3://$bucket/blobs/librdkafka
```

Then update `manifest.yml` with the full path for the download file and the `md5` value:

```
docker run -ti \
  -v $PWD:/buildpack \
  -v $PWD/tmp/librdkafka-output:/librdkafka-output \
  -e NAME=${NAME:?required} \
  -e VERSION=${VERSION:?required} \
  -e REGION=us-east-1 \
  -e OUTPUT_DIR=/librdkafka-output \
  cfcommunity/librdkafka-buildpack-pkg-builder \
  /buildpack/packages/$NAME/update_manifest.sh
```

This really should be automated in future.
