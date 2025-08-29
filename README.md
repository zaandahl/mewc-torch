<img src="mewc_logo_hex.png" alt="MEWC Hex Sticker" width="200" align="right"/>

# mewc-torch Docker Image

This repository contains the Dockerfile and docker-compose.yml files used to build the `mewc-torch` Docker image. The `mewc-torch` Docker image serves as the base image for the `mewc-detect` Docker image.

- [mewc-detect Docker Image Repository](https://github.com/zaandahl/mewc-detect)

The `mewc-torch` image is built on top of the `pytorch/pytorch:2.0.1-cuda11.7-cudnn8-runtime` image and includes additional dependencies required by MegaDetector v5 and YOLOv5.

## MDv5/MDv1000 PyTorch-only Tag

For MDv5/MDv1000 we provide a PyTorch-only base image with explicit pins and no TensorFlow/tensorboard to avoid NumPy 2.x ABI conflicts and import-time stalls.

- Core pins:
  - NumPy: 1.26.4
  - OpenCV (headless): 4.8.1.78
  - PyTorch: 2.0.1 (CUDA 11.7)
  - TorchVision: 0.15.2
- Ultralytics: 8.0.123 (installed with `--no-deps`)
- No TensorFlow/tensorboard in this image.

Build locally with an explicit tag and run a quick import sanity check:

```bash
docker build -t zaandahl/mewc-torch:py310-cu117-torch2.0.1-no-tf .
docker run --rm -it zaandahl/mewc-torch:py310-cu117-torch2.0.1-no-tf python - <<'PY'
import pkgutil, numpy, torch, torchvision, cv2
print('numpy', numpy.__version__)
print('torch', torch.__version__, 'cuda', torch.version.cuda)
print('vision', torchvision.__version__)
print('cv2', cv2.__version__)
print('tensorflow_present', bool(pkgutil.find_loader("tensorflow")))
PY
```

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

- Python environment isolated in a venv with pinned core packages for MDv5/MDv1000 (see above).
- Necessary utilities (`ffmpeg`, `libsm6`, `libxext6`, `git`, `wget`) installed.
- Source code copied into the `/code/src` directory in the container.

For detailed information about the image contents, please refer to the Dockerfile in this repository.

## GitHub Actions and DockerHub

This project uses GitHub Actions to automate the build process and push the Docker image to DockerHub. You can find the image at:

- [zaandahl/mewc-torch DockerHub Repository](https://hub.docker.com/repository/docker/zaandahl/mewc-torch)

---

As always, please modify the `README.md` as necessary to better fit your project's needs.
