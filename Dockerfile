# This is the Dockerfile to run Gammapy on Binder.
#

FROM continuumio/miniconda3:4.7.12
MAINTAINER ESAP

RUN pip install --no-cache notebook jupyterlab

# compilers
RUN apt-get --allow-releaseinfo-change update

# install dependencies - including the stable version of Gammapy
COPY binder.py tmp/
COPY environment.txt tmp/environment.yml 

WORKDIR tmp/
RUN conda update conda
RUN conda install -c conda-forge mamba
RUN mamba install -q -y pyyaml
RUN python binder.py
#RUN conda env create -f environment.yml

# add gammapy user running the jupyter notebook process
ENV NB_USER esap
ENV NB_UID 1000
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}


# setting ownerships
USER root
RUN chown -R ${NB_USER}:${NB_USER} ${HOME}

COPY ApertifVisualization.ipynb ${HOME}

# start JupyterLab server in tutorials dir
USER ${NB_USER}
#WORKDIR ${HOME}

