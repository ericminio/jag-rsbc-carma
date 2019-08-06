#!/bin/sh

oc get routes
APP=`oc get routes | grep carma-vip-adaptor | cut -f 4 -d ' '`
curl $APP/ping

echo " "
