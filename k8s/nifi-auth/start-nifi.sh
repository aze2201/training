#!/bin/bash
set -e

echo "Rendering nifi.properties from template..."

envsubst < /opt/nifi/conf/nifi.properties.tpl > /opt/nifi/nifi-current/conf/nifi.properties

echo "Starting NiFi..."
exec /opt/nifi/nifi-current/bin/nifi.sh run
