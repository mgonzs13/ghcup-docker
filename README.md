# ghcup-docker

This repository provides a Docker image for [ghcup](https://www.haskell.org/ghcup/), a tool for managing GHC (Glasgow Haskell Compiler), Cabal, and Stack on Ubuntu. The image simplifies setting up a Haskell development environment in a containerized manner.

The image is available on Docker Hub. You can check it out [here](https://hub.docker.com/repository/docker/mgons/ghcup/general).

## Features

- Installs **GHC**, **Cabal**, and **Stack** using `ghcup` on Ubuntu.
- Allows reproducible Haskell development environments via Docker.
- Provides flexibility to modify versions of GHC, Cabal, and Stack at build time.

## Prerequisites

Ensure you have Docker installed on your system. If not, you can follow the official Docker installation guide [here](https://docs.docker.com/get-docker/).

## Dockerfile Overview

The Docker image is based on Ubuntu 22.04 (`ARG UBUNTU_VERSION=22.04`). The following components are installed:

- **GHC**: Version `9.4.8` (modifiable via build arguments).
- **Cabal**: Version `3.12.1.0` (modifiable via build arguments).
- **Stack**: Version `3.1.1` (modifiable via build arguments).

The image also installs `ghcup`, a tool that simplifies the installation and management of Haskell-related tools.

## Usage

### Building the Docker Image

To build the Docker image locally, run the following command from the root of the repository:

```bash
docker build -t ghcup:22 .
```

This will build the image with the tag ghcup:22, using the versions of GHC, Cabal, and Stack specified in the Dockerfile. You can customize these versions by passing build arguments when building the image:

```bash
docker build --build-arg GHC=9.4.8 --build-arg CABAL=3.12.1.0 --build-arg STACK=3.1.1 -t ghcup:custom .
```

### Running the Docker Image

Once the image is built, you can run it interactively with:

```bash
docker run -it --rm ghcup:22
```

Or you can use the remote image:

```bash
docker run -it --rm mgons/ghcup:22
```

This will start a new container and open a shell session. The container will automatically be removed when you exit.

### Running with Volume Mounting (Optional)

To persist data or mount local directories into the container, use the -v option:

```bash
docker run -it --rm -v /path/to/local/directory:/path/in/container ghcup:22
```

Replace `/path/to/local/directory` with the path to your local directory and `/path/in/container` with the path inside the container where you want the directory to be mounted.
