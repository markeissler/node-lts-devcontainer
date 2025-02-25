#!/usr/bin/env bash
#
# docker-entrypoint.sh for app
#

configVolumes() {
    #
    # Setup volume permissions
    #
    printf "%s\n-> " "-> Setting volume permissions..."
    sudo chown "${BUILD_USER}:${BUILD_USER}" "${SOURCE_DIR}/node_modules"
    printf "%s\n" "-> Volume permissions set."
}

updateEnvironment() {
    #
    # Update environment
    #
    if [[ -f "${SOURCE_DIR}/.envrc" ]]; then
        printf "%s\n-> " "-> Updating environment..."
        pushd "${PWD}"
        cd "${SOURCE_DIR}"
        direnv allow
        popd
        printf "%s\n-> " "-> Environment updated."
    fi
}

updateModules() {
    #
    # Update modules
    #
    printf "%s\n-> " "-> Updating modules..."
    yarn install
    printf "%s\n" "-> Modules updated."
}

#
# Check if app is mounted in source before continuing
#
printf "\n%s\n" "Checking configuration..."
if ! [[ -f "${SOURCE_DIR}/package.json" || "${SOURCE_DIR}/Gopkg.toml" ]]; then
    printf "\n%s\n" "-> App not found!"
cat <<- EOF

You must start this container with the app mounted in the working directory:

    ${SOURCE_DIR}

Refer to the dockerfiles/DOCKER.md file documentation for help.

EOF
    exit 1
fi

#
# Configure
#
printf "%s\n" "-> App found. Configuring..."

# update volume permissions
configVolumes

# always run in app source directory!
cd "${SOURCE_DIR}" 2>&1 > /dev/null

# check for previously installed bundles
if [[ ! -f "${BUILD_HOME}/.locks/.bootstrap.lock" ]]; then
    touch "${BUILD_HOME}/.locks/.bootstrap.lock"
    configVolumes
    updateEnvironment
    updateModules
else
    updateEnvironment
    updateModules
fi

# make sure node_modules is owned by the app user
sudo chown "${BUILD_USER}:${BUILD_USER}" "${SOURCE_DIR}/node_modules"

printf "%s\n\n" "Configuration finished."

#
# Start Xvfb. Redirect output to null because it complains when starting from
# non-priveleged mode.
#
Xvfb :99 -screen 0 1280x1024x24 > /dev/null 2>&1 &

#
# Run command (usually starts the target app)
#

# run any other command passed on cli
exec "$@"
