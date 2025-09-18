# DEBUG VERSION OF THE DOCKERFILE

ARG REPO_NAME="proj-parking"
ARG DESCRIPTION="A project to make the Duckiebot park."
ARG MAINTAINER="SrabanMondal srabanmondal1@gmail.com"
ARG ICON="car"

ARG ARCH
ARG DISTRO=daffy
ARG DOCKER_REGISTRY=docker.io
ARG BASE_IMAGE=dt-ros-commons
ARG BASE_TAG=${DISTRO}-${ARCH}
ARG LAUNCHER=default

FROM ${DOCKER_REGISTRY}/duckietown/${BASE_IMAGE}:${BASE_TAG} as base

ARG DISTRO
ARG REPO_NAME
ARG DESCRIPTION
ARG MAINTAINER
ARG ICON
ARG BASE_TAG
ARG BASE_IMAGE
ARG LAUNCHER
ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT

RUN dt-build-env-check "${REPO_NAME}" "${MAINTAINER}" "${DESCRIPTION}"

ARG REPO_PATH="${CATKIN_WS_DIR}/src/${REPO_NAME}"
ARG LAUNCH_PATH="${LAUNCH_DIR}/${REPO_NAME}"
RUN mkdir -p "${REPO_PATH}" "${LAUNCH_PATH}"
WORKDIR "${REPO_PATH}"

ENV DT_MODULE_TYPE="${REPO_NAME}" \
    DT_MODULE_DESCRIPTION="${DESCRIPTION}" \
    DT_MODULE_ICON="${ICON}" \
    DT_MAINTAINER="${MAINTAINER}" \
    DT_REPO_PATH="${REPO_PATH}" \
    DT_LAUNCH_PATH="${LAUNCH_PATH}" \
    DT_LAUNCHER="${LAUNCHER}"

COPY ./dependencies-apt.txt "${REPO_PATH}/"
RUN dt-apt-install ${REPO_PATH}/dependencies-apt.txt

ARG PIP_INDEX_URL="https://pypi.org/simple"
ENV PIP_INDEX_URL=${PIP_INDEX_URL}
COPY ./dependencies-py3.* "${REPO_PATH}/"
RUN dt-pip3-install "${REPO_PATH}/dependencies-py3.*"

COPY ./packages "${REPO_PATH}/packages"

# --- DEBUGGING: Humne neeche ki lines ko comment kar diya hai ---
# RUN . /opt/ros/${ROS_DEBUGGING_ROS_DISTRO}/setup.sh && \
#     catkin build \
#     --workspace ${CATKIN_WS_DIR}/
#
# COPY ./launchers/. "${LAUNCH_PATH}/"
# RUN dt-install-launchers "${LAUNCH_PATH}"
#
# CMD ["bash", "-c", "dt-launcher-${DT_LAUNCHER}"]

# --- DEBUGGING: Yeh line humein seedha terminal degi ---
CMD ["/bin/bash"]
