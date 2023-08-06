#!/usr/bin/with-contenv bashio
set -e

SERVICEFILE="/etc/systemd/system/qbusmqtt.service"
MQTT_HOST=$(bashio::services mqtt "host")
MQTT_USER=$(bashio::services mqtt "username")
MQTT_PASSWORD=$(bashio::services mqtt "password")

# Create the systemd service file
echo "[Unit]" > "${SERVICEFILE}"
echo "Description=MQTT client for Qbus communication" >> "${SERVICEFILE}"
echo "After=multi-user.target networking.service" >> "${SERVICEFILE}"
echo "" >> "${SERVICEFILE}"
echo "[Service]" >> "${SERVICEFILE}"
echo "ExecStart=/usr/bin/qbus/qbusMqttGw -serial=\"QBUSMQTTGW\" -daemon true -logbuflevel -1 -logtostderr true -storagedir /opt/qbus -mqttbroker \"tcp://${MQTT_HOST}:1883\" -mqttuser ${MQTT_USER} -mqttpassword ${MQTT_PASSWORD}" >> "${SERVICEFILE}"
echo "PIDFile=/run/qbusmqttgw.pid" >> "${SERVICEFILE}"
echo "Restart=on-failure" >> "${SERVICEFILE}"
echo "RemainAfterExit=no" >> "${SERVICEFILE}"
echo "RestartSec=5s" >> "${SERVICEFILE}"
echo "" >> "${SERVICEFILE}"
echo "[Install]" >> "${SERVICEFILE}"
echo "WantedBy=multi-user.target" >> "${SERVICEFILE}"

systemctl daemon-reload

# Start
bashio::log.info "Starting Qbus MQTT gateway..."
exec systemctl enable --now qbusmqtt.service < /dev/null
