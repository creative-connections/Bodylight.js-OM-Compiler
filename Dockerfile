FROM creativeconnections/minimal-open-modelica:latest
WORKDIR /work
ADD ./compiler /work

RUN apt-get update
RUN apt-get install -y inotify-tools

CMD ["bash", "worker.sh"]
