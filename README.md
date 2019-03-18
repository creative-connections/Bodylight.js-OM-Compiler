# Bodylight.js OpenModelica Compiler
This is a docker container with OpenModelica compiler, which produces Bodylight.js compatible FMU files

## Windows instructions
1. Install [docker](https://docs.docker.com/install/)

2. Download this repository and open PowerShell in the top directory

If you decide to clone this repository, take care to disable automatic line ending conversion in git.

3. Build the docker image
```powershell
docker build -t bodylight.js.om.compiler .
```

#### Usage
1. Put required Modelica libraries into the `libraries` folder. The name of the folder specifies the name of the library to load.
 The compiler looks for a `package.mo` file inside the `libraries\library\` folder.
2. The `input` directory accepts a single file `name.mo` where `name` is the name of the model for compilation.
 In case of error, only the compilation log will be present in the output directory.
3. Run the following command in PowerShell inside the directory, take care to replace `name.mo` at the end of the command with your filename.
```powershell
docker run --rm --mount "type=bind,source=$(Get-Location)\input,target=/input" --mount "type=bind,source=$(Get-Location)\output,target=/output" bodylight.js.om.compiler:latest bash worker.sh name.mo
```
After the compilation finishes, `input/name.mo` is deleted and the resulting name.fmu file is copied to the `output` directory, along with the compilation log `name.log`

## Linux instructions
1. Install [docker](https://docs.docker.com/install/)
2. Clone this repository and cd inside
3. Build the docker image
```bash
docker build -t bodylight.js.om.compiler "$(pwd)"
```
This builds the Dockerfile as bodylight.js.om.compiler. You might need to run this command with root privileges.

#### Starting the compiler
```bash
docker run -d \
  --name bodylight.js.om.compiler \
  --mount type=bind,source="$(pwd)"/libraries,target=/libraries \
  --mount type=bind,source="$(pwd)"/input,target=/input \
  --mount type=bind,source="$(pwd)"/output,target=/output \
  --rm bodylight.js.om.compiler:latest bash worker.sh
```
This starts the docker container and binds the `input`, `output` and `libraries` directories.

#### Stopping the compiler
```bash
docker stop bodylight.js.om.compiler
```

#### Usage
1. Put required Modelica libraries into the `libraries` folder. The name of the folder specifies the name of the library to load.
 The compiler looks for a `package.mo` file inside the `libraries\library\` folder.
2. The `input` directory accepts a single file `name.mo` where `name` is the name of the model for compilation.
 Files are processed sequentially in alphabetical order.
 In case of error, only the compilation log will be present in the output directory.
