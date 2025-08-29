## Base: proven with WSL2 and CUDA 11.7
FROM pytorch/pytorch:2.0.1-cuda11.7-cudnn8-runtime

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1

# OS packages needed by scientific stack and image IO
RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg libsm6 libxext6 git wget \
 && rm -rf /var/lib/apt/lists/*

# Work in /code
WORKDIR /code

# ---- Python isolation: venv to avoid conda/pip conflicts ----
ENV VIRTUAL_ENV=/opt/venv
RUN python -m venv ${VIRTUAL_ENV}
ENV PATH="${VIRTUAL_ENV}/bin:${PATH}"

# Fresh toolchain
RUN pip install --no-cache-dir -U pip setuptools wheel

# ---- Core, ABI‑compatible pins (no TensorFlow) ----
# NumPy 1.26.x + OpenCV headless 4.8.x are compatible with torch 2.0.1 / vision 0.15.2
RUN pip install --no-cache-dir \
    "numpy==1.26.4" \
    "opencv-python-headless==4.8.1.78"

# Torch/vision cu117 wheels (match base CUDA 11.7)
RUN pip install --no-cache-dir --upgrade --force-reinstall \
    torch==2.0.1 torchvision==0.15.2 \
    --index-url https://download.pytorch.org/whl/cu117

# IMPORTANT: do not install tensorflow/tensorboard in this image
# Install remaining runtime deps
COPY requirements.runtime.txt /tmp/requirements.runtime.txt
RUN pip install --no-cache-dir -r /tmp/requirements.runtime.txt

# Ultralytics without dependency side-effects (we already pinned everything it needs)
RUN pip install --no-cache-dir --no-deps ultralytics==8.0.123

# Minimal common util (if you ship it with the base)
COPY src/ ./src/

# ---- Build-time sanity (imports must succeed in the venv) ----
RUN python - <<'PY'
import sys, pkgutil
import numpy, torch, torchvision, cv2
print('numpy', numpy.__version__)
print('torch', torch.__version__, 'cuda', torch.version.cuda)
print('vision', torchvision.__version__)
print('cv2', cv2.__version__)
print('tensorflow_present', bool(pkgutil.find_loader("tensorflow")))
PY

# Default entrypoint is left to downstream images
