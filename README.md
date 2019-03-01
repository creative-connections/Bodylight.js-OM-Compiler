# Bodylight.js OpenModelica Compiler

__Work in progress__: most of the functionality is not implemented yet.

This is a docker container with OpenModelica compiler, which produces Bodylight.js compatible FMU files

## Installation

1. Install [docker](https://docs.docker.com/install/)

2. Clone this repository and cd inside

2. Build the docker image
```bash
docker build -t bodylight.js.om.compiler "$(pwd)"
```
 This builds the Dockerfile as bodylight.js.om.compiler.

 You might need to run this command with root privileges.

## Starting the compiler
```bash
docker run -d \
  --name bodylight.js.om.compiler \
  --mount type=bind,source="$(pwd)"/libraries,target=/libraries \
  --mount type=bind,source="$(pwd)"/input,target=/input \
  --mount type=bind,source="$(pwd)"/output,target=/output \
  bodylight.js.om.compiler:latest bash worker.sh
```
This starts the docker container and binds the `input`, `output` and `libraries` directories.

## Stopping the compiler
```bash
docker stop bodylight.js.om.compiler
```

## Usage

1. Put required Modelica libraries into the `libraries` folder. The name of the folder specifies the name of the library to load.

 The compiler looks for a `package.mo` file inside the `libraries\library\` folder.

2. The `input` directory accepts either a single file `name.mo` where `name` is the name of the model for compilation. Or a folder containing a `package.mo` file, where name of the folder is the name of the model to be compiled.

 Files are processed sequentially in alphabetical order.

 In case of error, only the compilation log will be present in the output directory.
