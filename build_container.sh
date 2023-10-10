#!/bin/bash
set -u
DOCKER_EXT="devel"
update_paths()
{
    DOCKER_IMAGE_NAME="zephyr/${DOCKER_EXT}"
    DOCKER_IMAGE_TAG="3.4.1"
    DOCKER_SAVE_NAME_BASE="zephyr-${DOCKER_EXT}-image"
    LOGFILE="image_size.log"
}

print_usage()
{
    echo "Usage: $(basename $0) [-h] [-t <tag>]"
}

print_help()
{
    print_usage
    echo ""
    echo "example: $(basename $0) -t 1.0.0"
    echo ""
    echo " -f             One of {base, ci, devel}"
    echo " -h             Display help information."
    echo " -t             Tag to apply to the image."
}

while getopts ':f:t:h' opt; do
    case "$opt" in
    f)
        DOCKER_EXT="$OPTARG"
        ;;
    h)
        print_help
        exit 0
        ;;

    t)
        DOCKER_IMAGE_TAG="$OPTARG"
        ;;
    :)
        echo "option requires an argument."
        print_usage
        exit 1
        ;;

    ?)
        echo "Invalid command option. ${OPTARG}"
        print_usage
        exit 1
        ;;
    esac
done
shift "$(($OPTIND -1))"
update_paths


docker build -f Dockerfile.devel \
             --build-arg UID=$(id -u) \
             --build-arg GID=$(id -g) \
             -t ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} \
             .
#             --build-arg username=$(id -un) \
BUILD_RESULT="$?"

# save the size of docker image
if [ "${BUILD_RESULT}" = "0" ]; then
    _IMAGE_TARBALL="${DOCKER_SAVE_NAME_BASE}-${DOCKER_IMAGE_TAG}.tar"
    echo "Done."
    echo ""
    echo "To distribute the built image use the following docker 'save/load' commands"
    echo "# save the image"
    echo "docker save -o ${_IMAGE_TARBALL} ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}"
    echo "# load the image"
    echo "docker load -i ${_IMAGE_TARBALL}"

    echo "$(date +%d-%b-%Y)" > ${LOGFILE}
    echo "===== image size =====================================================" >> ${LOGFILE}
    _GLOB="REPOSITORY|${DOCKER_IMAGE_NAME}"
    docker image list | grep -E ${_GLOB} >> ${LOGFILE}
fi
