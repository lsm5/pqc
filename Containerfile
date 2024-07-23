FROM fedora:40

COPY script.sh .
RUN bash script.sh

CMD ["/bin/bash"]
