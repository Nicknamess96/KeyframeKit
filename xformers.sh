#!/bin/bash

echo "Killing any processes on port 3000..."
fuser -k 3000/tcp

echo "Activating Python virtual environment..."
source /workspace/venv/bin/activate

echo "Killing any processes on port 3000..."
fuser -k 3000/tcp

echo "Updating xformers package..."
pip install -U --pre xformers

echo "Uninstalling torch, torchvision, and torchaudio..."
yes | pip uninstall torch torchvision torchaudio

echo "Reinstalling torch, torchvision, and torchaudio for CUDA 11.8..."
yes | pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118

echo "Relaunching..."
fuser -k 3000/tcp
yes | apt install -y libcudnn8=8.9.2.26-1+cuda11.8 libcudnn8-dev=8.9.2.26-1+cuda11.8 --allow-change-held-packages
cd /workspace/stable-diffusion-webui
python relauncher.py
