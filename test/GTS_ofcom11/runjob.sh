#!/bin/bash
#SBATCH --job-name=S09com # nombre para identificar el trabajo. Por defecto es el nombre del script
## Solo stl de gts y reduccion de numero de capas a agregar
## Reduccion de distancia de refinamiento para feature edge refinement
## maxNonOrtho en 70 para etapa de encapado
## Uso de stl de SW para evitar refinamientos indeseados de features
## Uso de surfaceFeatureExtract con angulo de 92 para evitar falta de adicion de capas en la parte inferior frontal
#SBATCH --ntasks=60 # cantidad de cores pedidos
#SBATCH --ntasks-per-node=20 # cantidad de cores por nodo, para que agrupe o distribuya procesos
# la linea siguiente es ignorada por Slurm porque empieza con ##
##SBATCH --mem-per-cpu=4G # cantidad de memoria por core
##SBATCH --output=trabajo-%j-salida.txt # la salida y error estandar van a este archivo. Si no es especifca es slurm-%j.out (donde %j es el Job ID)
##SBATCH --error=trabajo-%j-error.txt # si se especifica, la salida de error va por separado a este archivo
##SBATCH --time=2-0 # tiempo máximo de ejecución, el formato es: dias-horas / dias-horas:minutos / horas:minutos:segundos

# aqui comienzan los comandos
# snappyHexMesh
foamCleanTutorials
blockMesh
surfaceFeatureExtract
decomposePar -decomposeParDict system/decomposeParDict.60
mpirun snappyHexMesh -parallel -decomposeParDict system/decomposeParDict.60 -dict system/snappyHexMeshDict > logpart1.snappyHexMesh
mpirun snappyHexMesh -parallel -decomposeParDict system/decomposeParDict.60 -dict system/snappyHexMeshLayersDict > logpart2.snappyHexMesh
#reconstructParMesh -mergeTol 1e-6 -constant > log.reconstructPar1
#renumberMesh -latestTime > renumberMesh.log
mpirun checkMesh -parallel -decomposeParDict system/decomposeParDict.60 > checkMesh.log
