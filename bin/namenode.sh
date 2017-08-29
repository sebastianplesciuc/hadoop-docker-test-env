#!/bin/bash

source /home/config/java_home.env

if [ "`ls -A /hadoop/dfs/name`" == "" ]; then
  echo "Formatting namenode name directory: /hadoop/dfs/name"
  hdfs --config /etc/hadoop namenode -format test
fi

hdfs --config /etc/hadoop namenode