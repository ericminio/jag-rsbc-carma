#!/bin/sh

oc create -f image.json
oc create -f build.json
oc set triggers buildconfigs/carma-vip-adaptor --from-github

echo "build status:"
unset COMPLETE
oc describe builds carma-vip-adaptor | grep Status
while [[ ${#COMPLETE} -eq 0 ]]
do
    sleep 3
    oc describe builds carma-vip-adaptor | grep Status
    COMPLETE=`oc describe builds carma-vip-adaptor | grep Complete`
done

oc new-app carma-vip-adaptor:latest
echo "exposing..."
oc expose svc/carma-vip-adaptor

echo "init environment variables with placeholders..."
oc set env dc/carma-vip-adaptor API_USERNAME=change-me
oc set env dc/carma-vip-adaptor API_PASSWORD=change-me
oc set env dc/carma-vip-adaptor ADFS_URL=change-me
oc set env dc/carma-vip-adaptor CARMA_CLIENT_ID=change-me
oc set env dc/carma-vip-adaptor CARMA_CLIENT_SECRET=change-me
oc set env dc/carma-vip-adaptor CARMA_RESOURCE=change-me
oc set env dc/carma-vip-adaptor CARMA_USERNAME=change-me
oc set env dc/carma-vip-adaptor CARMA_PASSWORD=change-me
oc set env dc/carma-vip-adaptor CARMA_URL=change-me

echo "starting app..."
sleep 15
./ping.sh
