COMMON_COMMAND="docker run --sig-proxy=true -i -v ~/.awssaml.properties:/root/.awssaml.properties -v ~/.aws:/root/.aws -v ~/.kube:/root/.kube --rm cloud-tools:0.0.1"

# function to invoke docker via docker image
function d() { __execute_comand docker "$@" ; }

# function to invoke helm via docker image
function h() { __execute_comand helm "$@" ; }

# function to invoke kubectl via docker image
function k() { __execute_comand kubectl "$@" ; }

# function to invoke aws via docker image
function a() { __execute_comand aws "$@" ; }

# function to invoke aws-saml via docker image
function as() { __execute_comand aws-saml "$@" ; }

# function to invoke python3 via docker image
function p() {
  if [ -z "$@" ]; then command="--help"; else command="$@"; fi
  __execute_comand python3 $command
}

function __execute_comand() { eval $COMMON_COMMAND "$@" ; }

