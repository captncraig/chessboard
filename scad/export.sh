#!/bin/bash
 
set -ex

ex(){
   openscad -Dxseg=$1 -Dyseg=$2 -o frame_$1_$2.stl frame.scad
}
 
ex 0 0
ex 0 1
ex 0 2
ex 1 0
ex 1 2
ex 2 0
ex 2 1
ex 2 2