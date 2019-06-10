# librdkafka buildpack for Cloud Foundry

[librdkafka](https://github.com/edenhill/librdkafka) is the Apache Kafka C/C++ library by [Magnus Edenhill](http://www.edenhill.se/). It is required to be installed before using language binding libraries like Python's `librdkafka-python`. This buildpack will install a pre-compiled version of librdkafka that will immediately work with your Cloud Foundry application.

## Buildpack User Documentation

### Building the Buildpack

To build this buildpack, run the following command from the buildpack's directory:

1. Source the .envrc file in the buildpack directory.

    ```bash
    source .envrc
    ```

    To simplify the process in the future, install [direnv](https://direnv.net/) which will automatically source .envrc when you change directories.

1. Install buildpack-packager

    ```bash
    ./scripts/install_tools.sh
    ```

1. Build the buildpack

    ```bash
    buildpack-packager build -stack cflinuxfs3 -cached
    ```

1. Use in Cloud Foundry

    Upload the buildpack to your Cloud Foundry and optionally specify it by name

    ```bash
    cf create-buildpack librdkafka_buildpack librdkafka_buildpack*.zip 100
    cf push my_app -b librdkafka_buildpack -b python_buildpack
    ```

### Testing

Buildpacks use the [Cutlass](https://github.com/cloudfoundry/libbuildpack/cutlass) framework for running integration tests.

To test this buildpack, run the following command from the buildpack's directory:

1. Source the .envrc file in the buildpack directory.

    ```bash
    source .envrc
    ```

    To simplify the process in the future, install [direnv](https://direnv.net/) which will automatically source .envrc when you change directories.

1. Run integration tests

    ```bash
    ./scripts/integration.sh
    ```

    More information can be found on Github [cutlass](https://github.com/cloudfoundry/libbuildpack/cutlass).

### Reporting Issues

Open an issue on this project

## Disclaimer

This buildpack is experimental and not yet intended for production use.
