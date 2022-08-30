"""Convert minc to nifti format."""

import os
import numpy as np
from nibabel import load, save, Nifti1Image

minc = load("t1_icbm_normal_3mm_pn3_rf20.mnc.gz")
basename = minc.get_filename().split(os.extsep, 1)[0]

affine = np.array([[0, 0, 1, 0],
                   [0, 1, 0, 0],
                   [3, 0, 0, 0],
                   [0, 0, 0, 1]])

out = Nifti1Image(minc.get_data(), affine=affine)
save(out, basename + '.nii.gz')