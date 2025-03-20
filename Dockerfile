FROM nvcr.io/nvidia/pytorch:24.12-py3

ARG TZ="America/Los_Angeles"

ENV PYTORCH_CUDA_ALLOC_CONF="backend:cudaMallocAsync"
ENV UV_COMPILE_BYTECODE=1
ENV UV_NO_CACHE=1
ENV UV_SYSTEM_PYTHON=1
ENV PIP_DISABLE_PIP_VERSION_CHECK=1
ENV PIP_NO_CACHE_DIR=1
ENV DEBIAN_FRONTEND="noninteractive"
# mitigates
# RuntimeError: Failed to import transformers.generation.utils because of the following error (look up to see its traceback):
# numpy.dtype size changed, may indicate binary incompatibility. Expected 96 from C header, got 88 from PyObject
RUN echo "numpy<2" > numpy-override.txt

# mitigates https://stackoverflow.com/questions/55313610/importerror-libgl-so-1-cannot-open-shared-object-file-no-such-file-or-directo
# mitigates AttributeError: module 'cv2.dnn' has no attribute 'DictValue' \
# see https://github.com/facebookresearch/nougat/issues/40
RUN pip install uv --root-user-action=ignore && uv --version && \
    apt-get update && apt-get install --no-install-recommends ffmpeg libsm6 libxext6 -y && \
    uv pip uninstall --break-system-packages --system $(pip list --format=freeze | grep opencv) && \
    rm -rf /usr/local/lib/python3.*/dist-packages/cv2/ && \
    uv pip install wheel --break-system-packages && \
    uv pip install --no-build-isolation --break-system-packages opencv-python-headless && \
    uv pip install --no-build-isolation --overrides=numpy-override.txt --break-system-packages "comfyui@git+https://github.com/hiddenswitch/ComfyUI/@0fbce0a28299384e4f94ab4ff301f7a566dc3461" && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /workspace
RUN uv pip install comfyui-hunyuanvideowrapper@git+https://github.com/samhodge-aiml/ComfyUI-HunyuanVideoWrapper@0a1e01ca20ff29166953c7dcee18a40503a752ec --break-system-packages 
RUN uv pip install comfyui-custom-scripts@git+https://github.com/samhodge-aiml/ComfyUI-Custom-Scripts@4fbb519c4e9616481ba16b4cd4943dbfabc6d553 --break-system-packages
RUN uv pip install comfyui-kjnodes@git+https://github.com/samhodge-aiml/ComfyUI-KJNodes@31a6e7ecf3d7c954d1eee0a829b37a8c13de7c92 --break-system-packages
RUN uv pip install comfyui-comfyroll@git+https://github.com/samhodge-aiml/ComfyUI_Comfyroll_CustomNodes@555273416791b32fa2e059c0a8831262b9a2361f --break-system-packages
RUN uv pip install comfyui-hunyaunloom@git+https://github.com/samhodge-aiml/ComfyUI-HunyuanLoom/@6b37a746408f1acedb4601e4312424991e89f167 --break-system-packages
RUN uv pip install git+https://github.com/AppMana/appmana-comfyui-nodes-ella/@3bc1e4eaed81153998bec465b8b1487a9601206b  --break-system-packages
RUN uv pip install git+https://github.com/samhodge-aiml/appmana-comfyui-nodes-ipadapter-plus/@ba4ed4767e0e94afa17d8204c419853418ffad9f  --break-system-packages
#RUN uv pip install git+https://github.com/AppMana/appmana-comfyui-nodes-layerdiffuse/@888351374ac955b523e0a360ad0ee924ac7eeb99  --break-system-packages
RUN uv pip install git+https://github.com/samhodge-aiml/appmana-comfyui-nodes-bria-bg-removal/@aab962fccbdaa0497fd79c1314a4c1c83dbdc530 --break-system-packages
RUN uv pip install git+https://github.com/samhodge-aiml/appmana-comfyui-nodes-video-frame-interpolation/@dca559634f3f1c17ab26541b1ce7b116584947ef --break-system-packages
RUN uv pip install git+https://github.com/samhodge-aiml/appmana-comfyui-nodes-impact-pack/@5cd76faebc66f3583d43bdc2ef4666a96bb90db3 --break-system-packages
# RUN uv pip install git+https://github.com/AppMAna/appmana-comfyui-nodes-tensorrt --break-system-packages
RUN uv pip install comfyui-advanced-controlnet@git+https://github.com/samhodge-aiml/ComfyUI-Advanced-ControlNet/@28d0b893109f9972e6bb819003b8163f6160ce17 --break-system-packages
RUN uv pip install comfyui-jankhidiffusion@git+https://github.com/samhodge-aiml/comfyui_jankhidiffusion/@49fe48e83b6910a590ce4224cbd234ecc18c83a0 --break-system-packages
RUN uv pip install comfyui-sampler-lcm-alternative@git+https://github.com/samhodge-aiml/ComfyUI-sampler-lcm-alternative/@ea0d7660ab70d3c691249d0abc9241cd1c2f2e9c --break-system-packages
RUN uv pip install comfyui-liveportraitkj@git+https://github.com/samhodge-aiml/ComfyUI-LivePortraitKJ/@88d2c747ea3f0c061911e47ecbc6a13aa09c8996 --break-system-packages
# RUN uv pip install rgthree-comfy@git+https://github.com/samhodge-aiml/rgthree-comfy/@879eeb029d87bd8dc1a990ab8844743a7304655b --break-system-packages
RUN uv pip install comfyui-clip-with-break@git+https://github.com/samhodge-aiml/comfyui-clip-with-break/@b25f9200b48867664c7766a99a4e9b4ad6a5b913 --break-system-packages
RUN uv pip install git+https://github.com/samhodge-aiml/appmana-comfyui-nodes-animatediff-evolved/@a78108f2770673f5593c7352d89d6588a2f2f1a0 --break-system-packages
RUN uv pip install git+https://github.com/samhodge-aiml/appmana-comfyui-nodes-video-helper-suite@f1747d423fa15b499e8d81827cbb75435750bf0b --break-system-packages
# addresses https://github.com/pytorch/pytorch/issues/104801
# and issues reported by importing nodes_canny
RUN comfyui --quick-test-for-ci --cpu --cwd /workspace

EXPOSE 8188
CMD ["python", "-m", "comfy.cmd.main", "--listen"]
