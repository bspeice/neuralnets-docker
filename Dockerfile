FROM nvidia/cuda:8.0-cudnn5-devel-ubuntu16.04
MAINTAINER Bradlee Speice

LABEL Description="Jupyter server setup for ECBM E4040 Neural Networks" Version="0.1"

# Update our cache first
RUN apt-get update && \

    # add-apt-repository
    apt-get install -y software-properties-common && \

    # Add Julia repository
    add-apt-repository "ppa:staticfloat/juliareleases" && \

    # Install Julia
    apt-get update && apt-get install -y julia && \

    # Don't install broken Pip
    apt-get install -y python-pip=8.1.1-2 python3-pip=8.1.1-2 python-pip-whl=8.1.1-2 && \

    # Install the Scipy stuff we need
    apt-get install -y  \
        python3 libpython3-dev \
        python-pandas python-matplotlib \
        texlive-latex-extra texlive-fonts-recommended texlive-generic-recommended pandoc

   
# And the python-specific tools
RUN pip install theano jupyter

# And the Julia-specific tools
# Note that this must be after installing Jupyter to pick up the kernel
RUN julia -e 'Pkg.update()' && \
    julia -e '[Pkg.add(s) for s in [
        "Mocha",
        "ArrayFire",
        "Knet",
        "Gadfly",
        "IJulia",
        "Distributions",
        "ImageMagick",
        "Plots",
        "GR"
    ]]'


# And the startup script
COPY . /

# Set up Theano for the GPU
ENV THEANO_FLAGS='floatX=float32,device=gpu'

EXPOSE 8888
