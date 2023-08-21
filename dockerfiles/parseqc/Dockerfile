#######################################################################
#     Basic image
#######################################################################
FROM smaht/ubuntu2204-py38:0.0.1

LABEL maintainers="Michele Berselli (berselli.michele@gmail.com), Dominika Maziec (dominika_maziec@hms.harvard.edu)"

#######################################################################
#     General updates & installing necessary Linux components
#######################################################################
RUN apt-get update -y && apt-get install -y \
    locales=2.35-0ubuntu3.1 \
    tabix=1.13+ds-2build1 \
    libncurses-dev=6.3-2 \
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
## parseQCs install
RUN git clone https://github.com/smaht-dac/pipelines-scripts.git

WORKDIR pipelines-scripts

RUN git checkout 7c4dbc2 && \
    chmod +x qc-scripts/parseQCs.py

WORKDIR /usr/local/bin/

#######################################################################
#     Updating env
#######################################################################
ENV PATH=/usr/local/bin/pipelines-scripts/qc-scripts/:$PATH

CMD ["bash"]
