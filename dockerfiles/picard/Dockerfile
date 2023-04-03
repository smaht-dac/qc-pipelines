#######################################################################
#     Basic image
#######################################################################
FROM smaht/ubuntu2204-py38:0.0.1

MAINTAINER Michele Berselli (berselli.michele@gmail.com)

#######################################################################
#     General updates & installing necessary Linux components
#######################################################################
RUN apt-get update -y && apt-get install -y \
    locales \
    tabix

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
## Conda install
RUN conda install -c bioconda -y picard==3.0.0 && \
    conda clean -a -y -f

CMD ["bash"]
