#!/bin/bash
unzip app/bps.war -d app/bps
unzip app/workspace.war -d app/workspace
unzip app/governor.war -d app/governor
cd app/bps
tar zcvf ../bps.tar.gz .
cd ../../app/workspace
tar zcvf ../workspace.tar.gz .
cd ../../app/governor
tar zcvf ../governor.tar.gz .
cd ../../
cd app
split -b 10m bps.tar.gz bps.s
split -b 10m workspace.tar.gz workspace.s
split -b 10m governor.tar.gz governor.s
rm bps.tar.gz
rm workspace.tar.gz
rm governor.tar.gz
