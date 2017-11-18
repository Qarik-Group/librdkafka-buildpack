# Kafka librdkafka buildpack for Cloud Foundry

Cloud Foundry applications can blend multiple buildpacks together. If your application uses Kafka and your Kafka libraries require [librdkafka](https://github.com/edenhill/librdkafka), then this buildpack can help you.

If you want to learn how to make a "supply"-only buildpack for multi-buildpack support, then this is an example buildpack for you. Learn more from Keaty Gross at Cloud Foundry Summit EU 2017 in her [keynote](https://www.youtube.com/watch?v=0DnQNTq8FLw&list=PLhuMOCWn4P9hsn9q-GRTa77gxavTOnHaa&index=59) and [session talk](https://www.youtube.com/watch?v=41wEXS03U78).

* Admins can [download buildpacks](https://github.com/cloudfoundry-community/librdkafka-buildpack/releases)
* [Concourse CI](https://ci.starkandwayne.com/teams/main/pipelines/librdkafka-buildpack)
* Discussions and CI notifications at [#bigdata-boshrelease channel](https://cloudfoundry.slack.com/messages/C7NLFBQLS/) on https://slack.cloudfoundry.org

## Example

Use the buildpack from its Git repo:

```
cf v3-push py-sample-app-with-librdkafka -p fixtures/py-sample \
  -b https://github.com/cloudfoundry-community/librdkafka-buildpack \
  -b python_buildpack
```

If your administrator has installed `librdkafka_buildpack`, then you can reference it by name:

```
cf buildpacks
cf v3-push py-sample-app-with-librdkafka -p fixtures/py-sample \
  -b librdkafka_buildpack \
  -b python_buildpack
```

NOTE: you may need to change `py-sample-app-with-librdkafka` to something unique if you get an error about the default route already existing on your Cloud Foundry.

During staging, you will see librdkafka being installed:

```
Successfully created container
Downloading build artifacts cache...
Downloading app package...
Downloaded app package (826B)
-----> Download go 1.9
-----> Running go build supply
-----> librdkafka Buildpack version 0.1.0
-----> Installing librdkafka
       Using librdkafka version 0.11.1
-----> Installing librdkafka 0.11.1
       Download [http://librdkafka-buildpack.s3-website-us-east-1.amazonaws.com/blobs/librdkafka/librdkafka-compiled-0.11.1.tgz]
-----> Python Buildpack version 1.6.1
-----> Supplying Python
-----> Installing python 3.6.3
...
```

Next, you can test that your app and the `librdkafka` library are working with a client app:

```
cd fixtures/py-sample
export SERVER_URL=https://py-sample-app-with-librdkafka.cfapps.io
python3 client.py
```

The response should be:

```
{'message': 'image received. size=512x512'}
```

## Usage

You might also need to use the [apt-buildpack](https://github.com/cloudfoundry/apt-buildpack) to include any runtime dependencies you need.

## Building latest librdkafka

The [`packages/librdkafka`](https://github.com/cloudfoundry-community/librdkafka-buildpack/tree/master/packages/librdkafka) folder contains the instructions for compiling + uploading a binary version of librdkafka.
