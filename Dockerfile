# Set Ubuntu version as a build argument
ARG UBUNTU_VERSION=22.04
FROM ubuntu:${UBUNTU_VERSION}

# Set build arguments for GHC, Cabal, and Stack versions
ARG GHC=9.4.8
ARG CABAL=3.12.1.0
ARG STACK=3.1.1

# Set environment variables for non-interactive installs and GHCup path
ENV DEBIAN_FRONTEND=noninteractive \
    PATH="/root/.ghcup/bin:$PATH"

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
    build-essential

# Download and install GHCup
RUN curl -fsSL https://downloads.haskell.org/~ghcup/x86_64-linux-ghcup -o /usr/bin/ghcup && \
    chmod +x /usr/bin/ghcup && \
    ghcup config set gpg-setting GPGStrict && \
    gpg --batch --keyserver hkps://keyserver.ubuntu.com --recv-keys 7D1E8AFD1D4A16D71FADA2F2CCC85C0E40C06A8C

# Install GHC, Cabal, and Stack using GHCup
RUN ghcup -v install ghc ${GHC} && \
    ghcup -v set ghc ${GHC} && \
    ghcup -v install cabal ${CABAL} && \
    ghcup -v set cabal ${CABAL} && \
    ghcup -v install stack ${STACK} && \
    ghcup -v set stack ${STACK}

# Generate the /root/.ghcup/env file using the ghcup command
RUN touch /root/.ghcup/env

# Add custom content to /root/.ghcup/env
RUN echo 'case ":$PATH:" in' >> /root/.ghcup/env && \
    echo '    *:"/root/.ghcup/bin":*)' >> /root/.ghcup/env && \
    echo '        ;;' >> /root/.ghcup/env && \
    echo '    *)' >> /root/.ghcup/env && \
    echo '        export PATH="/root/.ghcup/bin:$PATH"' >> /root/.ghcup/env && \
    echo '        ;;' >> /root/.ghcup/env && \
    echo 'esac' >> /root/.ghcup/env && \
    echo 'case ":$PATH:" in' >> /root/.ghcup/env && \
    echo '    *:"$HOME/.cabal/bin":*)' >> /root/.ghcup/env && \
    echo '        ;;' >> /root/.ghcup/env && \
    echo '    *)' >> /root/.ghcup/env && \
    echo '        export PATH="$HOME/.cabal/bin:$PATH"' >> /root/.ghcup/env && \
    echo '        ;;' >> /root/.ghcup/env && \
    echo 'esac' >> /root/.ghcup/env

# Source the /root/.ghcup/env file in .bashrc
RUN echo '[ -f "/root/.ghcup/env" ] && . "/root/.ghcup/env" # ghcup-env' >> /root/.bashrc

# Update cabal
RUN cabal update
