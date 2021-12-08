# tellor-docker-reporter
`tellor-docker-reporter` is a Dockerized wrapper around [telliot-feed-examples](https://github.com/tellor-io/telliot-feed-examples). It allows Tellor reporters to quickly configure a new reporter instance with a simple `docker run` command.

## Overview
For each `telliot-feed-examples` release version, there will be a corresponding Docker image in [tellor-docker-reporter Docker Hub repository](https://hub.docker.com/r/cribcaged/tellor-docker-reporter/tags) with the same tag. For example, `cribcaged/tellor-docker-reporter:v0.0.7` Docker image will use `telliot-feed-examples` release `v0.0.7` under the hood.

> (Optional) If you would like to build your own Docker image, feel free to use the `Dockerfile` with the following syntax:
> 
> ```
> docker build --progress plain --build-arg TELLIOT_VERSION=v0.0.7 -t cribcaged/tellor-docker-reporter:v0.0.7 .
> ```
> Provided `TELLIOT_VERSION` should correspond to a release tag in [telliot-feed-examples](https://github.com/tellor-io/telliot-feed-examples/releases). The Docker build will automatically pull this specific tag from Github repository. Optionally, you can omit this `--build-arg` parameter and it will automatically pull the latest release.


## Purpose
Docker provides several advantages when a user wants to configure their Tellor reporter for the first time:
- No dependency on user's operating system
- No requirement to pre-install Python or configure a virtual environment
- Start reporting with a simple one line `docker run` command
- Easy to manage multiple reporter instances
- Convenience on deployments, monitoring and resilience of instances hosted on remote servers

## Dependencies
- A running Docker engine (Docker Desktop for Windows / Mac or Docker for Linux)
- Telliot configuration YAML files: `main.yaml` and `endpoints.yaml` as described in [Configuration](#configuration) section.

## Configuration
The following Telliot configuration YAML files need to be located in a local directory. This directory (e.g. `/local/path/to/telliot/`) will be accessed by the Docker container using a volume binding.
1. `/local/path/to/telliot/main.yaml`
2. `/local/path/to/telliot/endpoints.yaml`

These files will typically contain your reporter wallet's private key and the Websocket endpoint addresses. See [TellorX tutorial video](https://youtu.be/-B0paj4YIA0?t=215) and [Telliot documentation](https://tellor-io.github.io/telliot-feed-examples/getting-started) for more details on their configuration. Feel free to use the templates in [/templates/telliot](/templates/telliot).

> Note: The content and structure of these files can change in time as new `telliot-feed-examples` versions are released. Users may need to adjust them according to [Telliot documentation](https://tellor-io.github.io/telliot-feed-examples/getting-started/).
***

## Usage

After configuring your telliot YAML files, you can start reporting with a `docker run` command that triggers the process:
```
docker run --name tellor-docker-reporter -d --restart unless-stopped -v <YOUR_LOCAL_TELLIOT_PATH>:/home/reporter/telliot cribcaged/tellor-docker-reporter:v0.0.7 <TELLIOT_FEED_EXAMPLES_ARGS>
```

Arguments explained:

| Argument                                              | Description                                                                                                                                                                                                                                                                                                                                                                                                                |
|-------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `--name tellor-docker-reporter`                       | Docker container's name. Can be changed/customized according to your taste.                                                                                                                                                                                                                                                                                                                                                |
| `-d`                                                  | Run container in detached mode so that it runs in the background.                                                                                                                                                                                                                                                                                                                                                          |
| `--restart unless-stopped`                            | Automatically restart your container in case <br/>it runs into an exception. This will make sure that your reporter is resilient. An error or exception won't halt it; it will always restart and continue trying to report.                                                                                                                                                                                               |
| `-v <YOUR_LOCAL_TELLIOT_PATH>:/home/reporter/telliot` | Volume binding between your local filesystem and the container. Configuration files like `main.yaml` and `endpoints.yaml` should be located in this local directory. The container will automatically create other files like `chains.yaml`, application logs in `/logs` directory etc.<br/><br/>Do **NOT** change the last `:/home/reporter/telliot` part since it refers to a predefined directory inside the container. |
| `cribcaged/tellor-docker-reporter:v0.0.7`             | Docker image to run. Should be listed in [tellor-docker-reporter Docker Hub repository](https://hub.docker.com/r/cribcaged/tellor-docker-reporter/tags).                                                                                                                                                                                                                                                                   |
| `<TELLIOT_FEED_EXAMPLES_ARGS>`                        | Arguments for `telliot-feed-examples` as described in its [documentation](https://tellor-io.github.io/telliot-feed-examples/usage/). The most basic example would be `--legacy-id 1 report`.                                                                                                                                                                                                                               |

Example run command to report for legacy id 1 (ETH/USD price) with minimum 25% profit condition
```
docker run --name tellor-docker-reporter -d --restart unless-stopped -v /local/path/to/telliot:/home/reporter/telliot cribcaged/tellor-docker-reporter:v0.0.7 --legacy-id 1 report --profit 25
```

After running the container, the application logs can be viewed with the following command:
```
docker logs -f tellor-docker-reporter
```

## Contact
In case you have any questions or suggestions, feel free to contact `@cribcaged` in Tellor discord.