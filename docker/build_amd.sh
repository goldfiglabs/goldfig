set -e 

PACKAGE=$1

echo "Building package ${PACKAGE}"

pipenv lock -r > requirements.txt

INTROSPECTOR_DOCKER_REPO=${DOCKER_REPO:-goldfig}
IMAGE="${INTROSPECTOR_DOCKER_REPO}/${PACKAGE}:amd64-latest"
DOCKER_BUILDKIT=1 docker build --platform linux/amd64 -t ${IMAGE} -f docker/Dockerfile-amd .
