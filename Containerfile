FROM fedora:40

COPY setup.sh .
RUN bash setup.sh

COPY tests.sh .

CMD ["/bin/bash"]
