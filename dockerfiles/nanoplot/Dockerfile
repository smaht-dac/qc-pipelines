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
## Python dependencies
# This is a combination of versions that works:
#   NanoPlot-1.44.1 biopython-1.83 nanoget-1.19.3 narwhals-1.42.1
#   numpy-1.24.4 pandas-2.0.3 plotly-6.2.0 pyarrow-17.0.0 pysam-0.23.3
#   pytz-2025.2 scipy-1.10.1 tzdata-2025.2 kaleido-0.2.1

# kaleido >= 1.0.0 is not compatible with NanoPlot 1.44.1 (but NanoPlot will try to install it)
RUN pip install kaleido==0.2.1

## NanoPlot
RUN pip install NanoPlot==1.44.1

#######################################################################
#     Scripts
#######################################################################
## run
COPY run.sh .
RUN chmod +x run.sh

CMD ["bash"]
