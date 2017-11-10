FROM ubuntu:17.10

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install clang-format cloc cmake cppcheck doxygen g++ git graphviz lcov python-pip valgrind vim-common && \
    apt-get -y autoremove && \
    apt-get clean all

RUN pip install --upgrade pip && \
    pip install conan==0.28.0 coverage==4.4.1 flake8==3.4.1 gcovr==3.3 && \
    rm -rf /root/.cache/pip/*

ENV CONAN_USER_HOME=/conan

RUN mkdir $CONAN_USER_HOME && \
    conan

COPY files/registry.txt $CONAN_USER_HOME/.conan/

COPY files/default_profile $CONAN_USER_HOME/.conan/profiles/default

RUN git clone https://github.com/ess-dmsc/utils.git && \
    cd utils && \
    git checkout 98b81cf00f80ceb8383eb4dc6abb27669959e11b && \
    make install

RUN adduser --disabled-password --gecos "" jenkins

RUN chown -R jenkins $CONAN_USER_HOME/.conan

USER jenkins

WORKDIR /home/jenkins
