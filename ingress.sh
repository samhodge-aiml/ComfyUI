#!/usr/bin/env bash

HF_TOKEN=$1
USER=$2
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
WORKSPACE_DIR="${SCRIPT_DIR}/workspace_data"
MODELS_DIR="${WORKSPACE_DIR}/models"

# HotShot Animate Diff Model Temporal
echo "Starting Animate Diff Hotshot Temporal"
mkdir -p ${MODELS_DIR}/animatediff_models
wget -O - --header="Authorization: Bearer ${HF_TOKEN}" \
https://huggingface.co/hotshotco/Hotshot-XL/resolve/main/hsxl_temporal_layers.f16.safetensors \
> ${MODELS_DIR}/animatediff_models/hsxl_temporal_layers.f16.safetensors
echo "Ending Animate Diff Hotshot Temporal"

# SDXL VAE
echo "Starting SDXL VAE"
mkdir -p ${MODELS_DIR}/vae
wget -O - --header="Authorization: Bearer ${HF_TOKEN}" \
https://huggingface.co/stabilityai/sdxl-vae/resolve/main/sdxl_vae.safetensors \
> ${MODELS_DIR}/vae/sdxl_vae.safetensors
echo "Ending SDXL VAE"

# Liveportait
echo "Starting Live Portrait"
mkdir -p ${MODELS_DIR}/liveportrait
cd ${MODELS_DIR}/liveportrait
git lfs install
git clone "https://${USER}:${HF_TOKEN}@huggingface.co/Kijai/LivePortrait_safetensors"
cd LivePortrait_safetensors && cp -r ./* ./../. && cd .. && rm -rf LivePortrait_safetensors
cd ${SCRIPT_DIR}
echo "Ending Live Portrait"

# Xinsir ControlNet Union XL diffusion_pytorch_model_promax.safetensors
echo "Starting ControlNet Union XL"
mkdir -p ${MODELS_DIR}/controlnet
cd ${MODELS_DIR}/controlnet
git clone "https://${USER}:${HF_TOKEN}@huggingface.co/xinsir/controlnet-union-sdxl-1.0"
cd ${SCRIPT_DIR}
echo "Ending ControlNet Union XL"

# IPAdapter

# clip_vision directory
echo "Starting IP Adapter"
mkdir -p ${MODELS_DIR}/clip_vision

wget -O - --header="Authorization: Bearer ${HF_TOKEN}" \
https://huggingface.co/h94/IP-Adapter/resolve/main/models/image_encoder/model.safetensors \
> ${MODELS_DIR}/clip_vision/CLIP-ViT-H-14-laion2B-s32B-b79K.safetensors

wget -O - --header="Authorization: Bearer ${HF_TOKEN}" \
https://huggingface.co/h94/IP-Adapter/resolve/main/sdxl_models/image_encoder/model.safetensors \
> ${MODELS_DIR}/clip_vision/CLIP-ViT-bigG-14-laion2B-39B-b160k.safetensors

wget -O - --header="Authorization: Bearer ${HF_TOKEN}" \
https://huggingface.co/Kwai-Kolors/Kolors-IP-Adapter-Plus/resolve/main/image_encoder/pytorch_model.bin \
> ${MODELS_DIR}/clip_vision/clip-vit-large-patch14-336.bin

# ipadapter directory
mkdir -p ${MODELS_DIR}/ipadapter

wget -O - --header="Authorization: Bearer ${HF_TOKEN}" \
https://huggingface.co/h94/IP-Adapter/resolve/main/models/ip-adapter_sd15.safetensors \
> ${MODELS_DIR}/ipadapter/ip-adapter_sd15.safetensors

wget -O - --header="Authorization: Bearer ${HF_TOKEN}" \
https://huggingface.co/h94/IP-Adapter/resolve/main/models/ip-adapter_sd15_light_v11.bin \
> ${MODELS_DIR}/ipadapter/ip-adapter_sd15_light_v11.bin

wget -O - --header="Authorization: Bearer ${HF_TOKEN}" \
https://huggingface.co/h94/IP-Adapter/resolve/main/models/ip-adapter-plus_sd15.safetensors \
> ${MODELS_DIR}/ipadapter/ip-adapter-plus_sd15.safetensors

wget -O - --header="Authorization: Bearer ${HF_TOKEN}" \
https://huggingface.co/h94/IP-Adapter/resolve/main/models/ip-adapter-plus-face_sd15.safetensors \
> ${MODELS_DIR}/ipadapter/ip-adapter-plus-face_sd15.safetensors

wget -O - --header="Authorization: Bearer ${HF_TOKEN}" \
https://huggingface.co/h94/IP-Adapter/resolve/main/models/ip-adapter-full-face_sd15.safetensors \
> ${MODELS_DIR}/ipadapter/ip-adapter-full-face_sd15.safetensors

wget -O - --header="Authorization: Bearer ${HF_TOKEN}" \
https://huggingface.co/h94/IP-Adapter/resolve/main/models/ip-adapter_sd15_vit-G.safetensors \
> ${MODELS_DIR}/ipadapter/ip-adapter_sd15_vit-G.safetensors

wget -O - --header="Authorization: Bearer ${HF_TOKEN}" \
https://huggingface.co/h94/IP-Adapter/resolve/main/sdxl_models/ip-adapter_sdxl_vit-h.safetensors \
> ${MODELS_DIR}/ipadapter/ip-adapter_sdxl_vit-h.safetensors

wget -O - --header="Authorization: Bearer ${HF_TOKEN}" \
https://huggingface.co/h94/IP-Adapter/resolve/main/sdxl_models/ip-adapter-plus-face_sdxl_vit-h.safetensors \
> ${MODELS_DIR}/ipadapter/ip-adapter-plus-face_sdxl_vit-h.safetensors

wget -O - --header="Authorization: Bearer ${HF_TOKEN}" \
https://huggingface.co/h94/IP-Adapter/resolve/main/sdxl_models/ip-adapter_sdxl.safetensors \
> ${MODELS_DIR}/ipadapter/ip-adapter_sdxl.safetensors
echo "Ending IP Adapter"


# SDXL LoRa LCM

echo "Starting SDXL LoRa LCM"

mkdir -p ${MODELS_DIR}/loras/SDXL

wget -O - --header="Authorization: Bearer ${HF_TOKEN}" \
https://huggingface.co/latent-consistency/lcm-lora-sdxl/resolve/main/pytorch_lora_weights.safetensors \
> ${MODELS_DIR}/loras/SDXL/lcm_lora_sdxl.safetensors

echo "Ending SDXL LoRa LCM"

# SDXL Model see also https://civitai.com/models/198051?modelVersionId=1099629
# License https://github.com/Stability-AI/generative-models/blob/main/model_licenses/LICENSE-SDXL1.0

echo "Starting Lineart Model"

mkdir -p ${MODELS_DIR}/checkpoints

wget -O - --header="Authorization: Bearer ${HF_TOKEN}" \
https://huggingface.co/inkakolape/ModelsXL1/resolve/main/CHEYENNE_ch01ALTCleanLineart.safetensors \
> ${MODELS_DIR}/checkpoints/CHEYENNE_ch01ALTCleanLineart.safetensors

echo "Ending Lineart Model"

# Animate Diff Evolved Motion Models

echo "Starting Animate Diff Motion Models"

mkdir -p ${MODELS_DIR}/animatediff_models

wget -O - \
https://huggingface.co/guoyww/animatediff/resolve/cd71ae134a27ec6008b968d6419952b0c0494cf2/mm_sd_v14.ckpt \
> ${MODELS_DIR}/animatediff_models/mm_sd_v14.ckpt

wget -O - \
https://huggingface.co/guoyww/animatediff/blob/cd71ae134a27ec6008b968d6419952b0c0494cf2/mm_sd_v15.ckpt \
> ${MODELS_DIR}/animatediff_models/mm_sd_v15.ckpt

wget -O - \
https://huggingface.co/guoyww/animatediff/blob/cd71ae134a27ec6008b968d6419952b0c0494cf2/mm_sd_v15_v2.ckpt \
> ${MODELS_DIR}/animatediff_models/mm_sd_v15_v2.ckpt

wget -O - \
https://huggingface.co/guoyww/animatediff/blob/cd71ae134a27ec6008b968d6419952b0c0494cf2/mm_sdxl_v10_beta.ckpt \
> ${MODELS_DIR}/animatediff_models/mm_sdxl_v10_beta.ckpt

wget -O - --header="Authorization: Bearer ${HF_TOKEN}" \
https://huggingface.co/wangfuyun/AnimateLCM/resolve/main/AnimateLCM_sd15_t2v.ckpt \
> ${MODELS_DIR}/animatediff_models/AnimateLCM_sd15_t2v.ckpt

echo "Ending Animate Diff Motion Models"
