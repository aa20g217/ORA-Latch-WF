FROM 812206152185.dkr.ecr.us-west-2.amazonaws.com/latch-base:9a7d-main

#Install R
RUN apt install -y dirmngr apt-transport-https ca-certificates software-properties-common gnupg2
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-key '95C0FAF38DB3CCAD0C080A7BDC78B2DDEABC47B7'
RUN add-apt-repository 'deb https://cloud.r-project.org/bin/linux/debian buster-cran40/'
RUN apt update
RUN apt install -y r-base

# Install system dependencies for R
RUN apt-get update -qq && \
        DEBIAN_FRONTEND=noninteractive apt-get install -y \
        apt-transport-https \
        build-essential \
        curl \
        gfortran \
        libatlas-base-dev \
        libbz2-dev \
        libcairo2 \
        libcurl4-openssl-dev \
        libicu-dev \
        liblzma-dev \
        libpango-1.0-0 \
        libpangocairo-1.0-0 \
        libpcre3-dev \
        libtcl8.6 \
        libtiff5 \
        libtk8.6 \
        libx11-6 \
        libxt6 \
        locales \
        tzdata \
        zlib1g-dev

# Install system dependencies for devtools
RUN apt-get update -qq && \
        DEBIAN_FRONTEND=noninteractive apt-get install -y \
        git \
        libssl-dev \
        libicu-dev \
        libxml2-dev \
        make \
        libgit2-dev \
        pandoc \
        libgsl-dev


#Install R packages
RUN R -e 'install.packages("BiocManager",repo="https://cloud.r-project.org",dependencies = TRUE)'
RUN R -e 'install.packages("ggplot2",repo="https://cloud.r-project.org",dependencies = TRUE)'
RUN R -e 'library("ggplot2")'


RUN R -e 'BiocManager::install("org.Rn.eg.db",dependencies = TRUE)'
RUN R -e 'library("org.Rn.eg.db")'


RUN R -e 'BiocManager::install("rrvgo",dependencies = TRUE)'
RUN R -e 'library("rrvgo")'
RUN R -e 'BiocManager::install("simplifyEnrichment",dependencies = TRUE)'
RUN R -e 'library("simplifyEnrichment")'
RUN R -e 'BiocManager::install("ReactomePA",dependencies = TRUE)'
RUN R -e 'library("ReactomePA")'
RUN R -e 'BiocManager::install("clusterProfiler",dependencies = TRUE)'
RUN R -e 'library("clusterProfiler")'

RUN R -e 'install.packages("rmarkdown",repo="https://cloud.r-project.org",dependencies = TRUE)'

RUN R -e 'BiocManager::install("org.Hs.eg.db",dependencies = TRUE)'
RUN R -e 'BiocManager::install("org.Mm.eg.db",dependencies = TRUE)'
RUN R -e 'BiocManager::install("enrichplot",dependencies = TRUE)'
RUN R -e 'BiocManager::install("ggnewscale",dependencies = TRUE)'

RUN R -e 'library("ggnewscale")'



# Install pip
RUN apt-get install -y python3-pip

# Copy rmd and r scipt
COPY enrichmentReport.Rmd /root/enrichmentReport.Rmd
COPY knit.R /root/knit.R

# STOP HERE:
# The following lines are needed to ensure your build environement works
# correctly with latch.
COPY wf /root/wf
ARG tag
ENV FLYTE_INTERNAL_IMAGE $tag
RUN python3 -m pip install --upgrade latch
WORKDIR /root
