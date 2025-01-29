# Set Ubuntu version as a build argument
ARG UBUNTU_VERSION=22.04
FROM ubuntu:${UBUNTU_VERSION}

# Set build arguments for GHC, Cabal, and Stack versions
ARG GHC=9.4.8
ARG CABAL=3.12.1.0
ARG STACK=3.1.1

# Set environment variables for non-interactive installs
ENV DEBIAN_FRONTEND=noninteractive \
    PATH="/home/docker/.ghcup/bin:$PATH"

# Install necessary dependencies
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
    curl \
    libnuma-dev \
    zlib1g-dev \
    libgmp-dev \
    libgmp10 \
    git \
    wget \
    lsb-release \
    software-properties-common \
    gnupg2 \
    apt-transport-https \
    gcc \
    autoconf \
    automake \
    build-essential && \
    rm -rf /var/lib/apt/lists/*

# Create a new user named 'docker'
RUN useradd -m -s /bin/bash docker

# Download and install GHCup
RUN curl -fsSL https://downloads.haskell.org/~ghcup/x86_64-linux-ghcup -o /usr/bin/ghcup && \
    chmod +x /usr/bin/ghcup && \
    ghcup config set gpg-setting GPGStrict && \
    gpg --batch --keyserver hkps://keyserver.ubuntu.com --recv-keys 7D1E8AFD1D4A16D71FADA2F2CCC85C0E40C06A8C

# Switch to the new user
USER docker
WORKDIR /home/docker

# Install GHC, Cabal, and Stack using GHCup
RUN ghcup -v install ghc ${GHC} && \
    ghcup -v set ghc ${GHC} && \
    ghcup -v install cabal ${CABAL} && \
    ghcup -v set cabal ${CABAL} && \
    ghcup -v install stack ${STACK} && \
    ghcup -v set stack ${STACK}

# Ensure environment variables are correctly set
RUN echo 'export PATH="/home/docker/.ghcup/bin:$PATH"' >> /home/docker/.bashrc && \
    echo 'export PATH="$HOME/.cabal/bin:$PATH"' >> /home/docker/.bashrc

# Update cabal
RUN /home/docker/.ghcup/bin/cabal update

# Set working directory
WORKDIR /home/docker

# Set default command
CMD ["/bin/bash"]