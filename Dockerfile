FROM ubuntu:24.04

RUN apt update && \
    apt install -y git cmake make ninja-build meson

RUN cd /opt \ 
    && git clone https://gitlab.eurecom.fr/oai/openairinterface5g.git \
    && cd openairinterface-AERPAW \
    && cp /root/Profiles/ProfileScripts/Radio/Helpers/oai_container.patch /opt/openairinterface-AERPAW/ \
    && cd cmake_targets \
    && apt update -y \
    && apt install -y libforms-dev libforms-bin tmux apt-utils \
    && ./build_oai -I \
    && ./build_oai -w USRP --noavx512 --ninja --eNB --nrUE --gNB --build-lib "nrscope" --cmake-opt "-DCMAKE_C_FLAGS='-mavx2 -mpclmul -msse4.2' -DCMAKE_CXX_FLAGS='-mavx2 -mpclmul -msse4.2'" -C

RUN cd /opt \
    && git clone https://github.com/open5gs/open5gs.git \
    && cd open5gs \
    && git checkout tags/v2.6.4 \
    && meson subprojects update \
    && meson build --prefix=`pwd`/install \
    && ninja -C build \
    && cd build \
    && ninja install \
    && cp /root/Profiles/ProfileScripts/Radio/Helpers/open5gs_nr_core.yaml /opt/open5gs/build/configs/open5gs_nr_core.yaml \
    && cp /root/Profiles/ProfileScripts/Radio/Helpers/open5gs_nr_core_oai.yaml /opt/open5gs/build/configs/open5gs_nr_core_oai.yaml \
    && cp /root/Profiles/ProfileScripts/Radio/Helpers/ho_core.yaml /opt/open5gs/build/configs/ho_core.yaml \
    && cp -r open5gsdb /opt/ 
