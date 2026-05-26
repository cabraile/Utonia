# Use CUDA 11.8 base
FROM nvidia/cuda:11.8.0-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

# Install system dependencies
RUN apt-get update && apt-get install -y \
    python3.10 \
    python3.10-dev \
    python3-pip \
    git \
    build-essential \
    ninja-build \
    && ln -sf /usr/bin/python3.10 /usr/bin/python \
    && rm -rf /var/lib/apt/lists/*

# Drivers
ENV O3D_HEADLESS=1
RUN apt-get update && apt-get install -y \
    libgl1 \
    libglx-mesa0 \
    libx11-6 \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip
RUN python -m pip install --upgrade pip

# 1. Install PyTorch stack first
RUN pip install torch==2.7.1 torchvision==0.22.1 torchaudio==2.7.1 --index-url https://download.pytorch.org/whl/cu118

# 2. Install dependencies that don't require compilation
RUN pip install numpy scipy addict timm psutil huggingface_hub open3d matplotlib opencv-python camtools trimesh natsort gradio einops

# 3. Install C++/CUDA extensions in order
# Flash Attention often requires ninja and gcc to be present
RUN pip install torch-scatter -f https://data.pyg.org/whl/torch-2.7.1+cu118.html
RUN pip install spconv-cu118

WORKDIR /workspace
CMD ["/bin/bash"]