FROM ubuntu:22.04

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       build-essential python3-dev libffi-dev git python3-pip python3-cffi cmake wget unzip openjdk-21-jre-headless

RUN wget https://github.com/libgit2/libgit2/archive/refs/tags/v0.26.2.tar.gz -O libgit.tar.gz
RUN tar xzf libgit.tar.gz

RUN cmake libgit2-0.26.2
RUN make
RUN make install

RUN apt-get update \
    && apt-get install -y --no-install-recommends libgit2-dev
RUN pip install fasttext-wheel setuptools pip pympler
RUN pip install numpy>=1.22
RUN pip install mongoengine==0.23.1
RUN pip install pymongo==3.12.2
RUN pip install mongomock==3.21.0

RUN pip install --no-cache-dir fasttext-wheel setuptools pympler "numpy>=1.22" tree-sitter tree-sitter-javascript tree-sitter-typescript

ENV AM_I_IN_CONTAINER true

# RefactoringMiner 3.1.5 (release jar is compiled for Java 21)
RUN wget -q https://github.com/tsantalis/RefactoringMiner/releases/download/3.1.5/RefactoringMiner-3.1.5.zip -O /tmp/refactoringminer.zip \
    && unzip -q /tmp/refactoringminer.zip -d /tmp/refactoringminer \
    && mkdir -p /opt/refactoringminer \
    && mv /tmp/refactoringminer/*/bin /tmp/refactoringminer/*/lib /opt/refactoringminer/ \
    && rm -rf /tmp/refactoringminer /tmp/refactoringminer.zip
ENV REFACTORMINER_HOME /opt/refactoringminer

COPY vcsSHARK_fork /vcsSHARK
RUN cd /vcsSHARK && python3 setup.py install

COPY prSHARK_fork /prSHARK
RUN cd /prSHARK && python3 setup.py install

COPY refactoringSHARK_fork /refactoringSHARK
RUN cd /refactoringSHARK && python3 setup.py install

COPY pycoSHARK_fork /pycoSHARK
RUN pip install /pycoSHARK
