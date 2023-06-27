# GPU / Machine Learning Image

This kernel image is built for usage with GPUs for AI and Machine Learning 

## Supported packages
- [TensorFlow / Keras](https://www.tensorflow.org/)
- [Cuda](https://nvidia.github.io/cuda-python/install.html)
- [Pytorch](https://pytorch.org/)

## Building Locally

**Note**: For testing with GPUs, the Docker engine and required packages have to be installed. https://github.com/NVIDIA/nvidia-docker
```shell
make copy-common-files
cd gpu && docker build . 
```
