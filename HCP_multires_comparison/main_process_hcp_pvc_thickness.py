#AUM
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


def thicknessPVC(sub):
    # cortical thickness computation
    subbase = join('/big_disk/ajoshi/coding_ground/pvcthickness/HCP_data/',
                   sub, 't1')

    if isfile(subbase + '.right.pial.cortex.svreg.dfs'):
        if not isfile(
                join('/big_disk/ajoshi/coding_ground/pvcthickness/HCP_data/',
                     sub, 'atlas.pvc-thickness_0-6mm.right.mid.cortex.dfs')):

            system('/home/ajoshi/BrainSuite18a/svreg/bin/thicknessPVC.sh ' +
                   subbase + ' >/dev/null 2>&1')


def bstsvreg(sub):
    # perform brainsuite and svreg processing
    subdir = join('/big_disk/ajoshi/coding_ground/pvcthickness/HCP_data/', sub)
    t1file = join('/data_disk/HCP_All', sub, 'T1w',
                  'T1w_acpc_dc_restore_brain.nii.gz')
    if not isfile(t1file):
        return

    outt1 = join(subdir, 't1.nii.gz')

    if isfile(join(subdir, 't1.roiwise.stats.txt')):
        return

    makedirs(subdir)

    # compute 1mm downsampled image
    system('flirt -in ' + t1file + ' -ref ' + t1file + ' -out ' + outt1 +
           ' -applyisoxfm 1 >/dev/null 2>&1')

    # generate mask
    msk = compute_background_mask(outt1)
    msk.to_filename(join(subdir, 't1.mask.nii.gz'))

    # make a copy of the original image
    copyfile(outt1, join(subdir, 't1.bse.nii.gz'))

    system(
        '/big_disk/ajoshi/coding_ground/pvcthickness/cortical_extraction_nobse.sh '
        + join(subdir, 't1') + ' >/dev/null 2>&1')
    system('/home/ajoshi/BrainSuite18a/svreg/bin/svreg.sh ' +
           join(subdir, 't1') + ' -S >/dev/null 2>&1')


def main():
    f = pd.read_csv('hcp_unrestricted_aajoshi_4_17_2016_14_56_18.csv')

    pool = Pool(processes=8)

    hcpsubs = list([])

    for i in tqdm(range(f['Age'].size)):
        if float(f['Age'][i][:2]) > 30:
            hcpsubs.append(str(f.Subject[i]))

    r = list(tqdm(pool.imap(bstsvreg, hcpsubs), total=len(hcpsubs)))
    r = list(tqdm(pool.imap(thicknessPVC, hcpsubs), total=len(hcpsubs)))

    pool.close()
    pool.join()


if __name__ == "__main__":
    main()
