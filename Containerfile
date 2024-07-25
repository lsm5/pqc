FROM fedora:40

COPY install.sh .
COPY setup.sh .

RUN bash install.sh
RUN bash setup.sh

CMD ["/bin/bash"]
