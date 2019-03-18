#!/bin/bash

# This looks up the dependency modelica packages in /libraries and outputs the
# first part of the resulting .mos script
function includes () {
  echo "cd(\"/compile\");"
  echo "loadModel(Modelica);"
  for directory in /libraries/*; do
    if [ -d "$directory" ]; then
      if [ -f "$directory/package.mo" ]; then
        filn="\"$directory/package.mo\""
        modelname=$(basename $(dirname $filn))
        echo "loadFile($filn);"
      fi
    fi
  done
}

function compile () {
  mkdir /compile
  filename="${FILE##*/}"
  basename="${filename%.*}"
  script="/compile/script.mos"

  log="/output/${basename}.log"
  [ -f ${log} ] && rm $log

  echo "=== Processing file ${FILE} ===" | tee -a $log
  echo "Compiling to FMU, log: ${log}" | tee -a $log

  mv $FILE /compile/$filename

  includes > $script
  echo "loadFile(\"/compile/$filename\");" >> $script
  echo "buildModelFMU($basename,\"2.0\",\"cs\",\"<default>\",{\"static\"},true);" >> $script
  echo "errors:=getMessagesStringInternal()" >> $script

  echo "--- start script.mos ---" | tee -a $log
  cat $script | tee -a $log
  echo "---   end script.mos ---" | tee -a $log

  omc $script |& tee -a $log

  mv /compile/*.fmu /output |& tee -a $log

  rm -r /compile
}

if [[ $# -eq 0 ]]; then
  inotifywait -m -r -e close_write --format '%w%f' "/input" | while read FILE
  do
    compile $FILE
  done
fi

if [[ $# -eq 1 ]]; then
  compile /input/$1
fi
