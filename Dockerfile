FROM nfcore/base
LABEL description="Docker image containing all requirements for czbiohub/nf-kmer-similarity pipeline"

# RUN conda update -n base -c defaults conda
COPY environment.yml /
RUN conda env create -f /environment.yml && conda clean -a
ENV PATH /opt/conda/envs/czbiohub-nf-kmer-similarity-0.1dev/bin:$PATH

# Suggested tags from https://microbadger.com/labels
ARG VCS_REF
LABEL org.label-schema.vcs-ref=$VCS_REF \
org.label-schema.vcs-url="e.g. https://github.com/czbiohub/nf-kmer-similarity"

WORKDIR /home

ENV PACKAGES zlib1g git g++ make ca-certificates gcc zlib1g-dev libc6-dev procps

### don't modify things below here for version updates etc.

WORKDIR /home

RUN apt-get update && \
    apt-get install -y --no-install-recommends ${PACKAGES} && \
    apt-get clean


RUN which -a pip
RUN which -a python
ENV SOURMASH_VERSION 'olgabot/paranathi-parallelize-dayhoff'
RUN cd /home && \
    git clone --branch $SOURMASH_VERSION https://github.com/czbiohub/sourmash.git && \
    cd sourmash && \
    python setup.py install

RUN which -a sourmash

RUN sourmash info
COPY docker/sysctl.conf /etc/sysctl.conf
