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
    tabix \
    libncurses-dev

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
## FastQC install
RUN wget https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.12.0.zip && \
    unzip fastqc_v0.12.0.zip && \
    cd FastQC/ && \
    chmod 755 fastqc && \
    cd ..

#######################################################################
#     Updating env
#######################################################################
ENV PATH=/usr/local/bin/FastQC/:$PATH

CMD ["bash"]
