FROM ubuntu:22.04

RUN apt update
RUN apt install -y git python3-pip python3-cffi
RUN apt install -y cmake
RUN apt install -y wget

RUN wget https://github.com/libgit2/libgit2/archive/refs/tags/v0.26.2.tar.gz -O libgit.tar.gz
RUN tar xzf libgit.tar.gz

RUN cmake libgit2-0.26.2
RUN make
RUN make install

RUN apt install -y libgit2-dev
RUN pip install fasttext-wheel setuptools pip pympler
RUN pip install numpy>=1.22
RUN pip install mongoengine==0.23.1
RUN pip install pymongo==3.12.2

RUN pip install --no-cache-dir fasttext-wheel setuptools pympler "numpy>=1.22"

ENV AM_I_IN_CONTAINER true

COPY vcsSHARK_fork /vcsSHARK
RUN cd /vcsSHARK && python3 setup.py install

COPY prSHARK_fork /prSHARK
RUN cd /prSHARK && python3 setup.py install

COPY pycoSHARK_fork /pycoSHARK
RUN pip install /pycoSHARK
