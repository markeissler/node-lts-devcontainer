## .env
##
## Copy this file to .env. Remove leading '#' sign to uncomment lines as you
## define values. Variables in here should not be exported, they will be
## ingested by .envrc, docker-compose, dotenv, etc.
##
## You may export your own personal variables in here, if needed, like debug
## flags:
##
##  export DEBUG=1
##
## Personal environment variables should not be added to .envrc so this is the
## right place to define and export them.
##
## Values in this file should be simple key/value pairs and should not rely on
## any sort of shell evaluation. If you need to do something more complex place
## those values in .env.local which will be ignored by docker-compose, dotenv,
## and similar libraries.
##

# Configure runtime debug configuration. This value should almost always be set
# to `false` for `production` environments.
VITE_APP_DEBUG="true"

# Configure runtime environment (development, production, staging).
VITE_APP_ENV="development"

# Configure app name.
VITE_APP_NAME="my-app"

# URL of the backend API.
#VITE_API_URL="http://localhost:3000"

# PORT on which this React App listens.
#VITE_PORT=3000

##
## OPTIONAL settings follow
##

## Drone (for cli access)
#DRONE_SERVER=""
#DRONE_TOKEN=""

##
## GIT
##
## Override default git author and committer values for this project.
##
#export GIT_AUTHOR_EMAIL="jon.doe@domain.com"
#export GIT_AUTHOR_NAME="Jon Doe"
#export GIT_COMMITTER_EMAIL="jon.doe@domain.com"
#export GIT_COMMITTER_NAME="Jon Doe"
