FROM nvcr.io/nvidia/pytorch:25.01-py3

ARG TZ="America/Los_Angeles"

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
RUN pip install  uv --root-user-action=ignore && uv --version && uv venv --seed --python 3.12 --directory /workspace && source /workspace/.venv/bin/activate && \
    apt-get update && apt-get install --no-install-recommends ffmpeg libsm6 libxext6 -y && \
    rm -rf /usr/local/lib/python3.10/dist-packages/cv2/
RUN source /workspace/.venv/bin/activate && /workspace/.venv/bin/pip3 install --upgrade  pip setuptools wheel 
RUN source /workspace/.venv/bin/activate && /workspace/.venv/bin/pip3 install aiohttp
RUN source /workspace/.venv/bin/activate && /workspace/.venv/bin/pip3 install --no-build-isolation opencv-python-headless
RUN source /workspace/.venv/bin/activate && /workspace/.venv/bin/pip3 install --no-build-isolation "comfyui@git+https://github.com/samhodge-aiml/ComfyUI.git@sageattention-transformers-patch"
RUN rm -rf /var/lib/apt/lists/*
RUN source .venv/bin/activate && /workspace/.venv/bin/pip3 install  git+https://github.com/AppMana/appmana-comfyui-nodes-video-helper-suite

# addresses https://github.com/pytorch/pytorch/issues/104801
# and issues reported by importing nodes_canny
RUN comfyui --quick-test-for-ci --cpu --cwd /workspace
EXPOSE 8188
CMD ["source", ".venv/bin/activate", "&&", "python", "-m", "comfy.cmd.main", "--listen"]
