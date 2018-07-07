
#!/bin/bash
#$ -l mem=25G -cwd -j y -R y -N matlab-gpu
#$ -l gpu=1
hostname
cd /ifs/scratch/columbia/cardiology/vi_lab/pr2483/Purkinje_spatial_diffusion1
module load CUDA/7.5.18
module load matlab/2014a
matlab -r main -singleCompThread
