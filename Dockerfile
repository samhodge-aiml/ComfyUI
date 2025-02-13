FROM nvcr.io/nvidia/pytorch:24.12-py3

ARG TZ="Australia/Adelaide"

ENV PYTORCH_CUDA_ALLOC_CONF="backend:cudaMallocAsync"
ENV UV_COMPILE_BYTECODE=1
ENV UV_NO_CACHE=1
ENV UV_SYSTEM_PYTHON=1
ENV PIP_DISABLE_PIP_VERSION_CHECK=1
ENV PIP_NO_CACHE_DIR=1
ENV DEBIAN_FRONTEND="noninteractive"
# mitigates https://stackoverflow.com/questions/55313610/importerror-libgl-so-1-cannot-open-shared-object-file-no-such-file-or-directo
# mitigates AttributeError: module 'cv2.dnn' has no attribute 'DictValue' \
# see https://github.com/facebookresearch/nougat/issues/40
WORKDIR /workspace
RUN pip install  uv --root-user-action=ignore && uv --version && \
    apt-get update && apt-get install --no-install-recommends ffmpeg libsm6 libxext6 -y && \
    rm -rf /usr/local/lib/python3.*/dist-packages/cv2/
RUN uv pip install --upgrade  pip setuptools wheel --break-system-packages
RUN uv pip install aiohttp --break-system-packages
RUN uv pip install --no-build-isolation opencv-python-headless --break-system-packages
RUN uv pip install --no-build-isolation "comfyui@git+https://github.com/samhodge-aiml/ComfyUI.git@cde73655d220827b6c934ba145037e4f499670df" --break-system-packages
RUN rm -rf /var/lib/apt/lists/*
RUN uv pip install  git+https://github.com/AppMana/appmana-comfyui-nodes-video-helper-suite --break-system-packages
RUN uv pip install comfyui-hunyuanvideowrapper@git+https://github.com/samhodge-aiml/ComfyUI-HunyuanVideoWrapper@cd50b21d607485bb19aa302f1c9ed0c38160c56d --break-system-packages 

# addresses https://github.com/pytorch/pytorch/issues/104801
# and issues reported by importing nodes_canny
RUN comfyui --quick-test-for-ci --cpu --cwd /workspace 
EXPOSE 8188
CMD ["python3", "-m", "comfy.cmd.main", "--listen"]
