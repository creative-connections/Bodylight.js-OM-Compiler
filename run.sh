#!/bin/bash

sudo docker run -d \
  --name bodylight.js.om.compiler \
  --mount type=bind,source="$(pwd)"/input,target=/input \
  --mount type=bind,source="$(pwd)"/output,target=/output \
  bodylight.js.om.compiler:latest bash
