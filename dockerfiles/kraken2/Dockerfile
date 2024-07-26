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
    build-essential \
    libz-dev \
    unzip \
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
## Kraken install
RUN wget https://github.com/DerrickWood/kraken2/archive/refs/tags/v2.1.3.zip && \
    unzip v2.1.3.zip

WORKDIR /usr/local/bin/kraken2-2.1.3
RUN ./install_kraken2.sh /usr/local/bin/kraken2_installation
WORKDIR /usr/local/bin

#######################################################################
#     Updating env
#######################################################################
ENV PATH=/usr/local/bin/kraken2_installation/:$PATH

#######################################################################
#     Scripts
#######################################################################

COPY run.sh .
RUN chmod +x run.sh

CMD ["bash"]