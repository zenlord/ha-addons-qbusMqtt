ARG BUILD_FROM
FROM ${BUILD_FROM}

# Install requirements for add-on
RUN \
  set -x && \
  apt update && \
  apt -y install --no-install-recommends \
    git \
    wget \
    tftp-hpa \
    unzip && \
  rm -rf /var/lib/apt/lists/*

# Download and unpack
RUN \
  mkdir /usr/bin/qbus && \
  mkdir /opt/qbus

RUN \
  cd /tmp && \
  git clone https://github.com/QbusKoen/qbusMqtt.git && \
  cp qbusMqtt/qbusMqtt/puttftp /opt/qbus/ && \
  cp -r qbusMqtt/qbusMqtt/fw/ /opt/qbus/ && \
  tar -C /usr/bin/qbus/ -xf qbusMqtt/qbusMqtt/qbusMqttGw/qbusMqttGw-x64.tar && \
  rm -rf /tmp/qbusMqtt/

#RUN curl https://raw.githubusercontent.com/QbusKoen/qbusMqtt/main/qbusMqtt/qbusMqttGw/qbusMqttGw-x64.tar | tar -C /usr/bin/qbus/ -x
#RUN curl https://raw.githubusercontent.com/QbusKoen/qbusMqtt/main/qbusMqtt/puttftp -0 /opt/qbus/
#RUN curl -r https://raw.githubusercontent.com/QbusKoen/qbusMqtt/main/qbusMqtt/fw/ -0 /opt/qbus/

RUN \
  chmod +x /usr/bin/qbus/qbusMqttGw && \
  chmod +x /opt/qbus/puttftp

# Copy data for add-on
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
