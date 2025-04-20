import pandas as pd
from tqdm import tqdm
from time import sleep
from shutil import copyfile
from os import makedirs, system
from os.path import join, isfile
from multiprocessing import Pool
from nilearn.image import resample_img
import numpy as np
from nilearn.masking import compute_background_mask
import glob
import os



def bstsvreg(subbasename):

    # run brainsuite and svreg on the original image
    if 0: #not isfile('' + subbasename + '.right.pial.cortex.dfs'):
        # perform brainsuite and svreg processing
        exe_name = "/home1/ajoshi/Projects/pvcthickness/cortical_extraction_full.sh"
        if not os.path.isfile(exe_name):
            exe_name = "/home/ajoshi/Projects/pvcthickness/cortical_extraction_full_local.sh"
        
        #system(f"{exe_name} {subbasename}")
        system(f"sbatch /home1/ajoshi/Projects/pvcthickness/run_script.job \'{exe_name} {subbasename}\'")

    if not isfile('' + subbasename + '.right.pial.cortex.svreg.dfs'):
        # run svreg
        exe_name = "/home1/ajoshi/Projects/SVRegSource000/compile_scripts/svreg_99_build0001_linux/bin/svreg.sh"
        atlasbasename = "/home1/ajoshi/Projects/SVRegSource000/compile_scripts/svreg_99_build0001_linux/BCI-DNI_brain_atlas/BCI-DNI_brain"

        if not os.path.isfile(exe_name):
            exe_name = "/home/ajoshi/Software/BrainSuite21a/svreg/bin/svreg.sh"
            atlasbasename = "/home/ajoshi/Software/BrainSuite21a/svreg/BCI-DNI_brain_atlas/BCI-DNI_brain"


        #system(f"module load matlab/2024a; export BrainSuiteMCR=/apps/generic/matlab/2024a/; {exe_name} {subbasename}")
        system(f"sbatch /home1/ajoshi/Projects/pvcthickness/run_script.job \'{exe_name} {subbasename} {atlasbasename} -S\'")


def main():

    session = '3b'
    nyu_proj1183 = f"/project/ajoshi_1183/nyu_data/NYU_TRT_session{session}"
    outdir = join(f"/project/ajoshi_1183/NYU_data_test_retest/{session}")

    # get a list of subjects
    sub_list = glob.glob(
        f"{nyu_proj1183}/*"
    )

    nyusubs = [os.path.basename(x) for x in sub_list]

    if not os.path.isdir(nyu_proj1183):
        # this means I am running on my local machine
        # so only process 2 subjects
        nyu_proj1183 = f"/home/ajoshi/project_ajoshi_1183/nyu_data/NYU_TRT_session{session}"
        outdir = join(f"/home/ajoshi/NYU_data_test_retest/{session}")
        sub_list = glob.glob(
            f"{nyu_proj1183}/*"
        )
        nyusubs = [os.path.basename(x) for x in sub_list]
        nyusubs = nyusubs[:2]

    if not os.path.isdir(outdir):
        makedirs(outdir)

    for sub in tqdm(nyusubs):
        outdir_sub = join(outdir, sub)
        if not os.path.isdir(outdir_sub):
            makedirs(outdir_sub)

    # copy the original image to the  orig output directory
    for sub in tqdm(nyusubs):
        t1file = join(
            nyu_proj1183,
            sub,
            "anat",
            "mprage_anonymized.nii.gz",
        )
        t1bsefile = join(
            nyu_proj1183,
            sub,
            "anat",
            "mprage_skullstripped.nii.gz",
        )
        outdir_sub = join(outdir, sub)
        if isfile(t1file) and not isfile(join(outdir_sub, "t1.mask.nii.gz")):
            copyfile(t1file, join(outdir_sub, "t1.nii.gz"))
            #copyfile(t1bsefile, join(outdir_sub, "t1.bse.nii.gz"))
            # make a brain mask
            #msk = compute_background_mask(t1bsefile)
            #msk.to_filename(join(outdir_sub, "t1.mask.nii.gz"))

    # run brainsuite and svreg on all the images
    for sub in nyusubs:
        outdir_sub = join(outdir, sub)
        t1file = join(outdir_sub, "t1.nii.gz")
        if not isfile(t1file):
            continue
        # run brainsuite and svreg on the original image
        bstsvreg(t1file.replace(".nii.gz", ""))

if __name__ == "__main__":
    main()
