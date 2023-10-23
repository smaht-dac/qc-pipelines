#######################################################################
#     Basic image
#######################################################################
FROM public.ecr.aws/smaht-dac/base-ubuntu2204-py38:0.0.1

LABEL maintainers="Alexander Veit (alexander_veit@hms.harvard.edu), Michele Berselli (berselli.michele@gmail.com)"

#######################################################################
#     General updates & installing necessary Linux components
#######################################################################
RUN apt-get update -y && apt-get install -y \
    locales \
    tabix=1.13+ds-2build1 \
    gzip \
    libncurses-dev=6.3-2 \
    libbz2-dev=1.0.8-5build1 \
    liblzma-dev=5.2.5-2ubuntu1 \
    --no-install-recommends \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

#######################################################################
#     Setting env
#######################################################################
## Set working directory
WORKDIR /usr/local/bin

## Supporting UTF-8
RUN locale-gen "en_US.UTF-8" && update-locale LC_ALL="en_US.UTF-8"
ENV LC_ALL=en_US.UTF-8

#######################################################################
#     Software
#######################################################################
## RNASeQC 2.4.2 install
RUN wget wget https://github.com/getzlab/rnaseqc/releases/download/v2.4.2/rnaseqc.v2.4.2.linux.gz && \
    gzip -d rnaseqc.v2.4.2.linux.gz && \
    chmod +x rnaseqc.v2.4.2.linux

RUN ln -s rnaseqc.v2.4.2.linux rnaseqc

## Python dependencies
RUN pip install click

#######################################################################
#     Scripts
#######################################################################
## collect_rnaseqc_metrics run
COPY collect_rnaseqc_metrics.py .
COPY run.sh .
RUN chmod +x run.sh

CMD ["bash"]
