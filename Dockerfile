FROM mcr.microsoft.com/devcontainers/base:ubuntu
# Install system-wide packages we need
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -qq update
RUN apt-get -qq dist-upgrade
RUN apt-get install -y \
    build-essential \
    git \
    curl \
    wget \
    cmake \
    python3 && \
    curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Check cargo is visible
#RUN cargo install starship
RUN curl -sS https://starship.rs/install.sh | sh -s -- -y


# Add non-root user yooakim
RUN useradd -ms /bin/bash yooakim

# Install NVM as yooakim
WORKDIR /home/yooakim
USER yooakim
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash

# Get Rust; NOTE: using sh for better compatibility with other base images
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

# Add .cargo/bin to PATH
ENV PATH="/root/.cargo/bin:${PATH}"


# Add a line to the .bashrc file for yooakim
RUN echo 'export TIME_STYLE=long-iso' >> /home/yooakim/.bashrc
RUN echo 'eval "$(starship init bash)"' >> /home/yooakim/.bashrc
# Copy the starship.toml file into the yooakim user's .config directory
COPY ./.config/starship.toml /home/yooakim/.config/starship.toml


USER root
RUN rm -rf /var/cache/apt/* /var/lib/apt/lists/*
RUN chown yooakim:yooakim /home/yooakim/.config/starship.toml

WORKDIR /home/yooakim
USER yooakim
