FROM fedora:rawhide

COPY setup.sh .
RUN bash setup.sh

COPY tests.sh .

CMD ["/bin/bash"]
