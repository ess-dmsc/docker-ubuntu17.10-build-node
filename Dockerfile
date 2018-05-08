FROM ubuntu:17.10

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install clang-format cloc cmake cppcheck doxygen g++ git graphviz \
        lcov python-pip valgrind vim-common tzdata autoconf automake libtool perl && \
    apt-get -y autoremove && \
    apt-get clean all

RUN pip install --force-reinstall pip==9.0.3 && \
    pip install conan==1.0.2 coverage==4.4.2 flake8==3.5.0 gcovr==3.3 && \
    rm -rf /root/.cache/pip/*

ENV CONAN_USER_HOME=/conan

RUN mkdir $CONAN_USER_HOME && \
    conan

COPY files/registry.txt $CONAN_USER_HOME/.conan/

COPY files/default_profile $CONAN_USER_HOME/.conan/profiles/default

RUN git clone https://github.com/ess-dmsc/utils.git && \
    cd utils && \
    git checkout 3f89fad6e801471baabee446ba4d327e54642b32 && \
    make install

RUN adduser --disabled-password --gecos "" jenkins

RUN chown -R jenkins $CONAN_USER_HOME/.conan

USER jenkins

WORKDIR /home/jenkins

RUN conan install cmake_installer/3.10.0@conan/stable
