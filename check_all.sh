#!/bin/bash

./check_shoprite.sh clark > ./logs/clark.log 2>&1 &
sleep 5
./check_shoprite.sh union > ./logs/union.log 2>&1 &
sleep 5
./check_shoprite.sh garwood > ./logs/garwood.log 2>&1 &
sleep 5
