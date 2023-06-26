# mewc-torch Docker Image

This repository contains the Dockerfile and docker-compose.yml files used to build the `mewc-torch` Docker image. The `mewc-torch` Docker image serves as the base image for the MegaDetector v5 Docker image.

- [MegaDetector Docker Image Repository](https://github.com/zaandahl/megadetector)

The `mewc-torch` image is built on top of the `pytorch/pytorch:2.0.1-cuda11.7-cudnn8-runtime` image and includes additional dependencies required by MegaDetector v5 and YOLOv5.

## MegaDetector v5

MegaDetector v5 is a version of MegaDetector that utilizes the YOLOv5 neural network for object detection. More information about MegaDetector v5 can be found in its GitHub repositories:

- [MegaDetector v5 GitHub Repository](https://github.com/agentmorris/MegaDetector)

## YOLOv5

YOLOv5 is a state-of-the-art, extremely fast and accurate object detection model. More information about YOLOv5 can be found in its GitHub repository:

- [YOLOv5 GitHub Repository](https://github.com/ultralytics/yolov5)

## Building the Docker Image

This repository uses `docker-compose` to build the Docker image. To build the `mewc-torch` Docker image, clone this repository and use the `docker-compose` command:

```bash
git clone https://github.com/zaandahl/mewc-torch.git
cd mewc-torch
docker-compose up --build
```

This will create a Docker image named `zaandahl/mewc-torch`.

## Docker Image Contents

The Docker image contains:

- Python environment with the requirements from `requirements.txt` file installed.
- Necessary utilities (`ffmpeg`, `libsm6`, `libxext6`, `git`, `wget`) installed.
- Source code copied into the `/code` directory in the container.

For detailed information about the image contents, please refer to the Dockerfile in this repository.

## GitHub Actions and DockerHub

This project uses GitHub Actions to automate the build process and push the Docker image to DockerHub. You can find the image at:

- [zaandahl/mewc-torch DockerHub Repository](https://hub.docker.com/repository/docker/zaandahl/mewc-torch)

---

As always, please modify the `README.md` as necessary to better fit your project's needs.