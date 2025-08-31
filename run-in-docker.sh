#!/usr/bin/env bash
xhost +local:

MAP_UID=${UID:-`id -u`}
MAP_GID=${GID:-`id -g`}

mkdir -p .Garmin

ENV_ARGS=(
    -e DISPLAY=unix$DISPLAY
    -e XDG_RUNTIME_DIR
)
[ -n "${WAYLAND_DISPLAY:-}" ] && ENV_ARGS+=(-e WAYLAND_DISPLAY)

MOUNTS=(
  -v "/tmp/.X11-unix:/tmp/.X11-unix"
  -v "${XDG_RUNTIME_DIR}:${XDG_RUNTIME_DIR}"
  -v "${PWD}/.Garmin:/home/developer/.Garmin"
  -v "${PWD}:${PWD}"
)

# If you are using podman, you will need --userns=keep-id
docker run -it --rm \
    "${ENV_ARGS[@]}" \
    "${MOUNTS[@]}" \
    -w $PWD \
    -u $MAP_UID:$MAP_GID \
    --privileged \
    --ipc=host \
    connectiq:latest "$@"
