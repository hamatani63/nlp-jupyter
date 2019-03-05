FROM ubuntu:16.04

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
    python3-dev python3-pip python3-wheel python3-setuptools \
    git cmake sudo build-essential wget nano curl \
    libblas3 libblas-dev libboost-dev \
    zlib1g-dev mecab libmecab-dev mecab-ipadic-utf8 swig xz-utils file\
    && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

RUN ln -s /usr/bin/python3 /usr/local/bin/python && \
    ln -s /usr/bin/pip3 /usr/local/bin/pip && \
    pip install --upgrade pip

# Python ML libraries
RUN pip install jupyter matplotlib pandas scipy scikit-learn seaborn
# Scraping
RUN pip install beautifulsoup4 lxml tqdm
# Gensim and NLTK
RUN pip install gensim cython nltk

# MeCab and Neologd
RUN pip install -e git+https://github.com/SamuraiT/mecab-python3#egg=mecab-python3
RUN git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git && \
    cd mecab-ipadic-neologd && \
    ./bin/install-mecab-ipadic-neologd -n -y

# JUMAN and KNP
ENV JUMANPP_VERSION 1.02
ENV JUMAN_VERSION 7.01
ENV KNP_VERSION 4.19
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/usr/local/lib
# JUMAN++
RUN wget http://lotus.kuee.kyoto-u.ac.jp/nl-resource/jumanpp/jumanpp-${JUMANPP_VERSION}.tar.xz && \
    tar xJvf jumanpp-${JUMANPP_VERSION}.tar.xz && \
    cd jumanpp-${JUMANPP_VERSION}/ && \
    ./configure && \
    make && \
    make install && \
    rm -rf /jumanpp-${JUMANPP_VERSION}.tar.xz && \
    rm -rf /var/cache/*
# JUMAN
RUN wget http://nlp.ist.i.kyoto-u.ac.jp/nl-resource/juman/juman-${JUMAN_VERSION}.tar.bz2 && \
    tar jxvf juman-${JUMAN_VERSION}.tar.bz2 && \
    cd juman-${JUMAN_VERSION} && \
    ./configure && \
    make && \
    make install && \
    rm -rf juman-${JUMAN_VERSION}.tar.bz2 && \
    rm -rf /var/cache/*
# KNP
RUN wget http://nlp.ist.i.kyoto-u.ac.jp/nl-resource/knp/knp-${KNP_VERSION}.tar.bz2 && \
    tar jxvf knp-${KNP_VERSION}.tar.bz2 && \
    cd knp-${KNP_VERSION} && \
    ./configure && \
    make && \
    make install && \
    rm -rf /knp-${KNP_VERSION}.tar.bz2 && \
    rm -rf /var/cache/*
# PyKNP
RUN pip install six pyknp

# jupyter issue #401
RUN pip uninstall -y tornado
RUN pip install tornado==5.1.1

# Run jupyter
USER root
EXPOSE 8888
WORKDIR "/root/notebooks"
COPY run_jupyter.sh /
RUN sudo chmod 755 /run_jupyter.sh
CMD ["/run_jupyter.sh", "--ip=0.0.0.0", "--allow-root"]
