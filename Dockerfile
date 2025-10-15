FROM ubuntu:24.04

#COPY openairinterface5g /opt/openairinterface5g
RUN apt-get update && \
    apt-get install -y git && \
    rm -rf /var/lib/apt/lists/*


RUN git clone https://gitlab.eurecom.fr/oai/openairinterface5g.git /opt/openairinterface5g

WORKDIR /opt/openairinterface5g/cmake_targets

# install deps
RUN apt update -y \
    && apt install -y libforms-dev libforms-bin tmux apt-utils cmake make ninja-build meson libuhd-dev uhd-host \
    && ./build_oai -I

# build OAI UE, gNB, and eNB
RUN ./build_oai -w USRP --noavx512 --ninja --eNB --nrUE --gNB --build-lib "nrscope" --cmake-opt "-DCMAKE_C_FLAGS='-mavx2 -mpclmul -msse4.2' -DCMAKE_CXX_FLAGS='-mavx2 -mpclmul -msse4.2'" -C

# RUN cd /opt \
#     && git clone https://github.com/open5gs/open5gs.git \
#     && cd open5gs \
#     && git checkout tags/v2.6.4 \
#     && meson subprojects update \
#     && meson build --prefix=`pwd`/install \
#     && ninja -C build \
#     && cd build \
#     && ninja install \
#     && cp /root/Profiles/ProfileScripts/Radio/Helpers/open5gs_nr_core.yaml /opt/open5gs/build/configs/open5gs_nr_core.yaml \
#     && cp /root/Profiles/ProfileScripts/Radio/Helpers/open5gs_nr_core_oai.yaml /opt/open5gs/build/configs/open5gs_nr_core_oai.yaml \
#     && cp /root/Profiles/ProfileScripts/Radio/Helpers/ho_core.yaml /opt/open5gs/build/configs/ho_core.yaml \
#     && cp -r open5gsdb /opt/ 
