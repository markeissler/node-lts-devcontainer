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
[[ "${VITE_APP_DEBUG:-}" ]] && export VITE_APP_DEBUG="${VITE_APP_DEBUG}"

# Configure runtime environment (development, production, staging).
[[ "${VITE_APP_ENV:-}" ]] && export VITE_APP_ENV="${VITE_APP_ENV}"

# Configure app name.
[[ "${VITE_APP_NAME:-}" ]] && export VITE_APP_NAME="${VITE_APP_NAME}"

# URL of the backend API.
[[ "${VITE_API_URL:-}" ]] && export VITE_API_URL="${VITE_API_URL}"

# PORT on which this React App listens.
[[ "${VITE_PORT:-}" ]] && export VITE_PORT="${VITE_PORT}"
