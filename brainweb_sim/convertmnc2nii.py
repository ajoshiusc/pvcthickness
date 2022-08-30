"""Convert minc to nifti format."""

import os
import numpy as np
from nilearn.image import load_img, new_img_like
img = load_img("t1_icbm_normal_3mm_pn3_rf20.nii.gz")
basename = img.get_filename().split(os.extsep, 1)[0]

out = new_img_like(img, np.uint16(img.get_fdata()))



out.to_filename(basename + '_uint16.nii.gz')