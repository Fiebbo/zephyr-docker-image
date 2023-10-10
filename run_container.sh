#!/bin/bash
DOCKER_IMAGE_NAME="zephyr/devel"
DOCKER_IMAGE_TAG="3.4.0"

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
    echo " -h             Display help information."
    echo " -t             Tag of the image to load."
}

while getopts ':t:h' opt; do
    case "$opt" in
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

docker run --rm -it \
           -e "TERM=xterm-256color" \
           -e "color_prompt=yes" \
           ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}

          #  --mac-address 00:42:ac:11:00:08 \
          #  -v /etc/group:/etc/group:ro \
          #  -v /etc/passwd:/etc/passwd:ro \
          #  -v /etc/shadow:/etc/shadow:ro \
          #  -v /etc/sudoers.d:/etc/sudoers.d:ro \
          #  -v ${PWD}/../../../shared_dir:${PWD}/../../../shared_dir \
