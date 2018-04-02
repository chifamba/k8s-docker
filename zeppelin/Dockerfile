FROM ubuntu

MAINTAINER Robert Chifamba
RUN apt-get update && \
	apt-get install -y git npm openjdk-8-jdk-headless libfontconfig maven curl && \
	curl -o zeppelin-bin-all.tgz http://mirrors.ocf.berkeley.edu/apache/zeppelin/zeppelin-0.7.3/zeppelin-0.7.3-bin-all.tgz && \
	mkdir -p /zeppelin && \
	tar xvf zeppelin-bin-all.tgz -C /zeppelin  --strip-components=1 && \
	rm zeppelin-bin-all.tgz && \
	curl -o /zeppelin/zeppelin-mongodb-0.7.0.jar https://github.com/bbonnin/zeppelin-mongodb-interpreter/releases/download/0.7.0/zeppelin-mongodb-0.7.0.zip 


EXPOSE 8080
#ENTRYPOINT /zeppelin/bin/zeppelin-daemon.sh start

