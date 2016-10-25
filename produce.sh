#!/bin/sh

sleep 10

#declare exchange
curl -i -u guest:guest -H "content-type:application/json" \
    -XPUT -d'{"type":"direct"}' \
    http://rabbit:15672/api/exchanges/%2f/exchange

#declare queue
curl -i -u guest:guest -H "content-type:application/json" \
    -XPUT -d'{}' \
    http://rabbit:15672/api/queues/%2f/logs

#declare binding
curl -i -u guest:guest -H "content-type:application/json" \
    -XPOST -d'{"routing_key":"key"}' \
    http://rabbit:15672/api/bindings/%2f/e/exchange/q/logs

#publish every second
echo "start publishing"
while :; do curl -s -u guest:guest -H "content-type:application/json" \
    -XPOST -d'{"properties":{},"payload_encoding":"string", "routing_key":"key","payload":"{\"message\":\"bar\", \"host\":\"rabbit says:\"}"}' \
    http://rabbit:15672/api/exchanges/%2f/exchange/publish; sleep 1; done