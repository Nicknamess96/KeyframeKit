#!/bin/bash

# Function to download a file
download_file() {
  local url=$1
  local dir=$2
  local use_content_disposition=$3

  echo "Starting download from $url..."
  
  if [ "$use_content_disposition" = true ]; then
    wget --content-disposition -P "$dir" "$url"
  else
    wget -P "$dir" "$url"
  fi

  if [ $? -eq 0 ]; then
    echo "Download completed successfully."
  else
    echo "Download failed. Please check the URL or your network connection."
  fi
}

# Function to clone a git repository
clone_repo() {
  local repo_url=$1
  local target_dir=$2

  echo "Cloning repository $repo_url into $target_dir..."

  git clone "$repo_url" "$target_dir"
  
  if [ $? -eq 0 ]; then
    echo "Cloning completed successfully."
  else
    echo "Cloning failed. Please check the repository URL or your network connection."
  fi
}

# URLs of the files to download
urls=("https://huggingface.co/stabilityai/sd-vae-ft-mse-original/resolve/main/vae-ft-mse-840000-ema-pruned.safetensors"
      "https://civitai.com/api/download/models/130072"
      "https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11f1p_sd15_depth.pth"
      "https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_lineart.pth"
      "https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_openpose.pth"
      "https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11f1e_sd15_tile.pth")

# Directories to save the files
dirs=("/workspace/stable-diffusion-webui/models/VAE"
      "/workspace/stable-diffusion-webui/models/Stable-diffusion"
      "/workspace/stable-diffusion-webui/extensions/sd-webui-controlnet/models"
      "/workspace/stable-diffusion-webui/extensions/sd-webui-controlnet/models"
      "/workspace/stable-diffusion-webui/extensions/sd-webui-controlnet/models"
      "/workspace/stable-diffusion-webui/extensions/sd-webui-controlnet/models")

# Git repositories to clone
repos=("https://github.com/pkuliyi2015/multidiffusion-upscaler-for-automatic1111")

# Directories to clone the repositories
repo_dirs=("/workspace/stable-diffusion-webui/extensions/multidiffusion-upscaler-for-automatic1111")

# Loop through each URL
for i in ${!urls[@]}; do
  dir=${dirs[$i]}

  # Check if directory exists, if not create it
  if [ ! -d "$dir" ]; then
    echo "Directory $dir does not exist. Creating it..."
    mkdir -p "$dir"
  else
    echo "Directory $dir exists."
  fi

  # Download the file
  if [ $i -eq 1 ]; then
    download_file ${urls[$i]} "$dir" true
  else
    download_file ${urls[$i]} "$dir" false
  fi
done

# Loop through each repository URL
for i in ${!repos[@]}; do
  dir=${repo_dirs[$i]}

  # Check if directory exists, if not create it
  if [ ! -d "$dir" ]; then
    echo "Directory $dir does not exist. Creating it..."
    mkdir -p "$dir"
  else
    echo "Directory $dir exists."
  fi

  # Clone the repository
  clone_repo ${repos[$i]} "$dir"
done

# Update the ui-config.json file
config_file="/workspace/stable-diffusion-webui/ui-config.json"

sed -i '/txt2img\/Resize width to\/maximum/ s/2048/8192/' "$config_file"
sed -i '/txt2img\/Resize height to\/maximum/ s/2048/8192/' "$config_file"
sed -i '/txt2img\/Width\/maximum/ s/2048/8192/' "$config_file"
sed -i '/txt2img\/Height\/maximum/ s/2048/8192/' "$config_file"
