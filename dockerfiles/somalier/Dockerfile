#######################################################################
#     Basic image
#######################################################################
FROM public.ecr.aws/smaht-dac/base-ubuntu2204-py38:0.0.1

LABEL maintainers="Michele Berselli (berselli.michele@gmail.com), Dominika Maziec (dominika_maziec@hms.harvard.edu)"

#######################################################################
#     General updates & installing necessary Linux components
#       - libncurses-dev, libbz2-dev, liblzma-dev used by samtools
#######################################################################
RUN apt-get update -y && apt-get install -y \
    locales \
    tabix=1.13+ds-2build1 \
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
## Samtools install
RUN wget https://github.com/samtools/samtools/releases/download/1.17/samtools-1.17.tar.bz2 && \
    tar -xjf samtools-1.17.tar.bz2 && \
    rm -rf samtools-1.17.tar.bz2

WORKDIR /usr/local/bin/samtools-1.17

RUN ./configure && \
    make

WORKDIR /usr/local/bin/

RUN ln -s samtools-1.17 samtools

## Somalier install
RUN wget https://github.com/brentp/somalier/releases/download/v0.2.19/somalier
RUN chmod +x somalier

#######################################################################
#     Scripts
#######################################################################
## somalier_extract
COPY somalier_extract.sh .
RUN chmod +x somalier_extract.sh

## somalier_relate
COPY somalier_relate.sh .
RUN chmod +x somalier_relate.sh

#######################################################################
#     Updating env
#######################################################################
ENV PATH=/usr/local/bin/samtools/:$PATH

CMD ["bash"]
