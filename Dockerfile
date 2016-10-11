FROM nvidia/cuda:8.0-cudnn5-devel-ubuntu16.04
MAINTAINER Bradlee Speice

LABEL Description="Jupyter server setup for ECBM E4040 Neural Networks" Version="0.1"

# Start with the updates
RUN apt-get update && \

    # Don't install broken Pip
    apt-get install -y python-pip=8.1.1-2 python3-pip=8.1.1-2 python-pip-whl=8.1.1-2 && \

    # Install the Scipy stuff we need
    apt-get install -y  \
        python-pandas python-matplotlib \
        texlive-latex-extra texlive-fonts-recommended texlive-generic-recommended pandoc

# And the python-specific tools
RUN pip install theano jupyter

# And the startup script
COPY . /

# Set up Theano for the GPU
ENV THEANO_FLAGS='floatX=float32,device=gpu'

EXPOSE 8888
