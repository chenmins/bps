#!/bin/bash
cd app
split -b 10m bps.tar.gz bps.s
split -b 10m workspace.tar.gz workspace.s
split -b 10m governor.tar.gz governor.s
rm bps.tar.gz
rm workspace.tar.gz
rm governor.tar.gz
