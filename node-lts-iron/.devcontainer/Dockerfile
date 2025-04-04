# Dockerfile
#
# This Dockerfile is used to build a carfront image for remote container development.
#

# ---------------------------------------------------------------------------- #
#                                    builder                                   #
# ---------------------------------------------------------------------------- #

#
# Build:
#   prompt> docker build \
#               -t carfront/builder:<VERSION> \
#               -f dockerfiles/Dockerfile --target builder .
#
# Options:
#   --progress plain (produce plain output for CI)
#

# Deployment and Build version
#
# The docker build command should specify a <VERSION> for this image which corresponds to the carfront version
# number. Never tag an image as `latest` as we want to avoid using that tag always because at runtime it obfuscates the
# actual version we are running which can impede troubleshooting. Also, it can be challenging, if not impossible, to
# get kubernetes to pull an updated `latest` image. Always specify the exact version you want to deploy/run.
#

FROM debian:12.9 AS builder

ARG BUILD_HOME="/home/app"
ARG BUILD_TEMP="/build"
ARG BUILD_USER="app"

# This image can target linux_amd64 and linux_arm64 architectures.
ARG RUN_ARCH="linux_amd64"

ENV BUILD_ARCH="${RUN_ARCH}"
ENV BUILD_HOME="${BUILD_HOME}"
ENV BUILD_USER="${BUILD_USER}"
ENV BUILD_LOCK="${BUILD_HOME}/.locks"
ENV SOURCE_DIR="${BUILD_HOME}/source"

# nodejs 18.x (LTS)
ARG NODE_REL="node_20.x"
ARG NODE_DEB="20.18.3-1nodesource1"

# Make temporary build dir
RUN set -x && mkdir -p /build

# Install build dependencies (not exactly necessary -- adds 200MB)
RUN set -x \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get update --quiet \
    && apt-get install --quiet --yes --no-install-recommends \
        acl \
        apt-transport-https \
        build-essential \
        ca-certificates \
        curl \
        git \
        gnupg2 \
        gzip \
        locales \
        netcat-openbsd \
        procps \
        sqlite3 \
        tar \
        unzip \
    && apt-get clean

# Install runtime dependencies
RUN set -x \
    && apt-get update --quiet \
    && apt-get install --quiet --yes --no-install-recommends \
        tzdata \
    && apt-get clean

# Install node.
RUN set -x && \
    # Install correct node package for the target architecture.
    if [ "${BUILD_ARCH}" = "linux_amd64" ]; then \
        export NODE_ARCH=amd64; \
    elif [ "${BUILD_ARCH}" = "linux_arm64" ]; then \
        export NODE_ARCH=arm64; \
    else \
        echo "Invalid BUILD_ARCH specified: ${BUILD_ARCH}. Exiting build." && exit 1; \
    fi \
    && curl -fsSL "https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key" | apt-key add - \
    && echo "deb [arch=${NODE_ARCH}] https://deb.nodesource.com/${NODE_REL} nodistro main" > "/etc/apt/sources.list.d/nodesource.list" \
    && apt-get update --quiet \
    && apt-get install --quiet --yes --no-install-recommends \
        nodejs=${NODE_DEB} \
    && apt-get clean

# Install yarn.
RUN set -x \
    && curl -fsSL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" > "/etc/apt/sources.list.d/yarn.list" \
    && apt-get update --quiet \
    && apt-get install --quiet --yes --no-install-recommends \
        yarn \
    && apt-get clean

# ---------------------------------------------------------------------------- #
#                                  dev-builder                                 #
# ---------------------------------------------------------------------------- #

#
# Default target - no need to specify `--target dev-builder` below.
#

#
# Build:
#   prompt> docker build \
#               -t carfront/dev-builder:<VERSION> \
#               -f dockerfiles/Dockerfile --target dev-builder .
#
# Options:
#   --progress plain (produce plain output for CI)
#

FROM builder AS dev-builder

ARG BUILD_HOME="/home/app"
ARG BUILD_USER="app"

ENV BUILD_HOME="${BUILD_HOME}"
ENV BUILD_USER="${BUILD_USER}"
ENV BUILD_LOCK="${BUILD_HOME}/.locks"
ENV SOURCE_DIR="${BUILD_HOME}/source"

# locally installed binaries
ENV PATH="${BUILD_HOME}/bin:${SOURCE_DIR}/node_modules/.bin:${PATH}"

# Install some utilities we might use from the command line
RUN set -x \
    && apt-get update --quiet \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get install --quiet --yes --no-install-recommends \
        direnv \
        jq \
        less \
        sudo \
        vim \
        sed \
        tree \
    && apt-get clean

# Install mariadb-client.
RUN set -x \
    && apt-get update --quiet \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get install --quiet --yes --no-install-recommends \
        mariadb-client \
    && apt-get clean

# Install mondodb client (mongosh).
# NOTE: Keys updated to address `apt-key` deprecation.
RUN set -x \
    && curl -fsSL "https://www.mongodb.org/static/pgp/server-8.0.asc" | gpg --dearmor -o "/usr/share/keyrings/mongodb-server-8.0.gpg" \
    && echo "deb [ signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] http://repo.mongodb.org/apt/debian bookworm/mongodb-org/8.0 main" > "/etc/apt/sources.list.d/mongodb-org-8.0.list" \
    && apt-get update -qq \
    && apt-get install -qq --yes --no-install-recommends \
        mongodb-mongosh \
    && apt-get clean

# Install postgresql-client.
RUN set -x \
    && apt-get update --quiet \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get install --quiet --yes --no-install-recommends \
        postgresql-client \
    && apt-get clean

# Install openssh-client.
RUN set -x \
    && apt-get update --quiet \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get install --quiet --yes --no-install-recommends \
        openssh-client \
    && apt-get clean

# Add build user, reconfigure sudo so users in sudo group don't need a password
RUN set -x \
    && useradd --create-home --home-dir "${BUILD_HOME}" --groups sudo --shell /bin/bash "${BUILD_USER}" \
    && sed --in-place "s/^%sudo/#sudo/" "/etc/sudoers" \
    && printf "\n%%sudo ALL=(ALL) NOPASSWD:ALL\n\n" >> "/etc/sudoers"

# Update build user shell configuration
RUN set -x \
    && printf "\nexport TERM=xterm" >> "${BUILD_HOME}/.bash_profile" \
    && for f in .bash_profile .bashrc .profile; do printf "\nexport PATH=${PATH}" >> "${BUILD_HOME}/${f}"; done \
    && for f in .bash_profile .bashrc .profile; do printf "\nexport EDITOR=/usr/bin/vi" >> "${BUILD_HOME}/${f}"; done \
    && for f in .bash_profile .bashrc .profile; do printf "\neval \"\$(direnv hook bash)\"" >> "${BUILD_HOME}/${f}"; done \
    && for f in .bash_profile .bashrc .profile; do printf "\n" >> "${BUILD_HOME}/${f}"; done

# Add some aliases
RUN set -x \
    && for f in .bash_profile .bashrc .profile; do printf "\n" >> "${BUILD_HOME}/${f}"; done \
    && for f in .bash_profile .bashrc .profile; do printf "\nalias git-lg0=\"git log --pretty=oneline --abbrev-commit\"" >> "${BUILD_HOME}/${f}"; done \
    && for f in .bash_profile .bashrc .profile; do printf "\nalias git-ready-dev=\"git log --oneline dev ^master\"" >> "${BUILD_HOME}/${f}"; done \
    && for f in .bash_profile .bashrc .profile; do printf "\nalias git-ready-develop=\"git log --oneline develop ^master\"" >> "${BUILD_HOME}/${f}"; done \
    && for f in .bash_profile .bashrc .profile; do printf "\n" >> "${BUILD_HOME}/${f}"; done

# Add git bash completion
RUN set -x \
    && curl "https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash" -o "${BUILD_HOME}/.git-completion.bash"

# Add some useful additions to bashrc
COPY "bash_additions.sh" "/tmp/"
RUN set -x \
    && for f in .bash_profile .bashrc .profile; do printf "\n" >> "${BUILD_HOME}/${f}"; done \
    && for f in .bash_profile .bashrc .profile; do cat "/tmp/bash_additions.sh" >> "${BUILD_HOME}/${f}"; done \
    && rm "/tmp/bash_additions.sh"

# Configure the main working directory. This is the base directory used in any
# further RUN, COPY, and ENTRYPOINT commands.
RUN mkdir -p "${BUILD_HOME}/bin" "${BUILD_HOME}/tmp" "${BUILD_LOCK}" "${SOURCE_DIR}/node_modules"

# Copy additional files into container

# Fix permissions on BUILD_HOME directory
RUN set -x \
    && chmod 0700 "${BUILD_HOME}" "${BUILD_HOME}/tmp" "${BUILD_LOCK}" "${SOURCE_DIR}" \
    && chown -R "${BUILD_USER}":"${BUILD_USER}" "${BUILD_HOME}" "${BUILD_LOCK}" "${SOURCE_DIR}"

# Update entry point.
COPY "docker-entrypoint.sh" "/"
RUN set -x && chown root:root "/docker-entrypoint.sh" && chmod 0755 "/docker-entrypoint.sh"

# Ports
EXPOSE 3000
EXPOSE 8080
EXPOSE 9003
EXPOSE 9229

# Setup environment for runtime
USER ${BUILD_USER}
WORKDIR "${BUILD_HOME}"

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD [ "sleep", "infinity" ]
