#!/bin/bash
#SBATCH --job-name=GTSmesh # nombre para identificar el trabajo. Por defecto es el nombre del script
#SBATCH --ntasks=40 # cantidad de cores pedidos
#SBATCH --ntasks-per-node=20 # cantidad de cores por nodo, para que agrupe o distribuya procesos
# la linea siguiente es ignorada por Slurm porque empieza con ##
##SBATCH --mem-per-cpu=4G # cantidad de memoria por core
##SBATCH --output=trabajo-%j-salida.txt # la salida y error estandar van a este archivo. Si no es especifca es slurm-%j.out (donde %j es el Job ID)
##SBATCH --error=trabajo-%j-error.txt # si se especifica, la salida de error va por separado a este archivo
#SBATCH --time=1-0 # tiempo máximo de ejecución, el formato es: dias-horas / dias-horas:minutos / horas:minutos:segundos

# aqui comienzan los comandos
# ejecutar previamente openfoam 7
blockMesh
surfaceFeatures
decomposePar -copyZero
mpirun snappyHexMesh -parallel -overwrite -dict ../system/snappyHexMeshDict > logpart1.snappyHexMesh
mpirun snappyHexMesh -parallel -overwrite -dict ../system/snappyHexMeshLayersDict > logpart2.snappyHexMesh
reconstructParMesh -mergeTol 1e-6 -constant > log.reconstructPar1
renumberMesh -latestTime > renumberMesh.log
checkMesh > checkMesh.log
