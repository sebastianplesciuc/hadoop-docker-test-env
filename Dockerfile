FROM centos:7

RUN yum install epel-release -y
RUN yum update -y
RUN yum install -y wget
RUN yum install -y java-1.8.0-openjdk-headless

RUN mkdir -p /home/config/
RUN echo 'export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")' > /home/config/java_home.env

ENV HADOOP_VERSION 2.8.1
ENV HADOOP_URL https://www.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz

RUN set -x \
    && curl -fSL "$HADOOP_URL" -o /tmp/hadoop.tar.gz \
    && tar -xvf /tmp/hadoop.tar.gz -C /opt/ \
    && rm /tmp/hadoop.tar.gz*

RUN ln -s /opt/hadoop-$HADOOP_VERSION/etc/hadoop /etc/hadoop
RUN cp /etc/hadoop/mapred-site.xml.template /etc/hadoop/mapred-site.xml
RUN mkdir /opt/hadoop-$HADOOP_VERSION/logs

RUN mkdir /hadoop-data
RUN mkdir -p /hadoop/dfs/data
RUN mkdir -p /hadoop/dfs/name
RUN mkdir -p /hadoop/yarn/timeline

ENV HADOOP_PREFIX=/opt/hadoop-$HADOOP_VERSION
ENV HADOOP_CONF_DIR=/etc/hadoop
ENV MULTIHOMED_NETWORK=1

ENV USER=root
ENV PATH $HADOOP_PREFIX/bin/:$PATH

EXPOSE 8020
EXPOSE 8042
EXPOSE 8088
EXPOSE 8188
EXPOSE 50070
EXPOSE 50075

ADD ./bin /hadoop/bin
RUN chmod +x /hadoop/bin/*

RUN yum install -y which

ENTRYPOINT tail -f /dev/null
