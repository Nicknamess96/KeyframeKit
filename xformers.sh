#!/bin/bash

echo "Removing /workspace/venv..."
rm -r /workspace/venv

echo "Killing any processes on port 3000..."
fuser -k 3000/tcp

echo "Changing directory to /workspace/stable-diffusion-webui and running relauncher.py..."
cd /workspace/stable-diffusion-webui
python relauncher.py

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
