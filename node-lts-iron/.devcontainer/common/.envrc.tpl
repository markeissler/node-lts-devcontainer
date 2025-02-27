# .envrc
# Use this file with direnv to automatically load necessary environment variables.
#   https://github.com/direnv/direnv
#

# Usage:
#   This file is committed and loads values from .env and/or .env.local which are NOT committed.
#
#   Copy .env.sample to .env and then run "direnv allow" to load updated values.
#   Without direnv, just run "source .envrc" (assumes bash is your shell).
#

[[ -f "./.env" ]] && printf "direnv: loading .env\n" && source "./.env"
[[ -f "./.env.local" ]] && printf "direnv: loading .env.local\n" && source "./.env.local"

# Configure runtime debug configuration. This value should almost always be set
# to `false` for `production` environments.
[[ "${REACT_APP_DEBUG:-}" ]] && export REACT_APP_DEBUG="${REACT_APP_DEBUG}"

# Configure runtime environment (staging, prod).
[[ "${REACT_APP_ENV:-}" ]] && export REACT_APP_ENV="${REACT_APP_ENV}"

# Configure app name.
[[ "${REACT_APP_NAME:-}" ]] && export REACT_APP_NAME="${REACT_APP_NAME}"
