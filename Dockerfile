FROM ubuntu

#This is the verison that is the vuln uaf exploited in the wild
ARG git_verison 48587c7

#This is needed for general installtaion so no prompts happen
ENV DEBIAN_FRONTEND = noninteractive

RUN apt-get update && \
    apt-get install -y wget python3 python3-pip clang llvm git curl

RUN pip3 install mercurial

#Install git cinnabar
WORKDIR /cinnabar
RUN wget https://raw.githubusercontent.com/glandium/git-cinnabar/master/download.py -O download.py &&\
	python3 download.py
ENV PATH="/cinnabar:${PATH}"

#We now add the build configs
WORKDIR /mozconfigs
ADD mozconfig-asan .
ADD mozconfig-debug .
ADD mozconfig-release . 
ADD mozconfig-release-debug .

WORKDIR /
#We build everything (should take about like 5+ hours)
ADD build.sh .

#Clone firefox
WORKDIR /
RUN git clone hg://hg.mozilla.org/mozilla-central firefox &&\
 cd firefox &&\
 git checkout $git_verison &&\
./mach --no-interactive bootstrap --application-choice='Firefox for Desktop' &&\ 
 cd / &&\
 ./build.sh

RUN ls
