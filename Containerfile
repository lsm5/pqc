FROM fedora:41

COPY script.sh .
RUN bash script.sh

CMD ["/bin/bash"]
