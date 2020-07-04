# -*- coding: utf-8 -*-
"""
Created on Tue Aug 16 15:51:16 2016

@author: ajoshi
"""
import nibabel.freesurfer.io as fsio
from dfsio import writedfs, readdfs
from nibabel.gifti.giftiio import read as gread
import os
from surfproc import patch_color_labels, view_patch_vtk, smooth_patch
from scipy.spatial import cKDTree
import scipy as sp


def interpolate_labels(fromsurf=[], tosurf=[], skipzero=0):
    ''' interpolate labels from surface to to surface'''
    tree = cKDTree(fromsurf.vertices)
    d, inds = tree.query(tosurf.vertices, k=1, p=2)
    if skipzero == 0:
        tosurf.labels = fromsurf.labels[inds]
    else:
        indz = (tosurf.labels == 0)
        tosurf.labels = fromsurf.labels[inds]
        tosurf.labels[indz] = 0
    return tosurf


class bci_fs:
    pass


class bci:
    pass


hemi = 'left'
fshemi = 'lh'
''' BCI to FS processed BCI '''
bci_bsti = readdfs('/home/ajoshi/BrainSuite19b/svreg/BCI-DNI\
_brain_atlas/BCI-DNI_brain.' + hemi + '.mid.cortex.dfs')
bci_bst = readdfs('/home/ajoshi/BrainSuite19b/svreg/BCI-DNI\
_brain_atlas/BCI-DNI_brain.' + hemi + '.inner.cortex.dfs')
bci_bst.labels = bci_bsti.labels
bci_bst.vertices[:, 0] -= 96 * 0.8
bci_bst.vertices[:, 1] -= 192 * 0.546875
bci_bst.vertices[:, 2] -= 192 * 0.546875
bci_fs.vertices, bci_fs.faces = fsio.read_geometry('/big_disk/ajoshi/data/BCI_\
DNI_Atlas/surf/' + fshemi + '.white')

fslabels, _, _ = fsio.read_annot(
    '/big_disk/ajoshi/freesurfer/subjects/BCI_DNI_Atlas/label/' + fshemi +
    '.economo.annot')
bci_fs.labels = fslabels

bci_bst = interpolate_labels(bci_fs, bci_bst)
bci_bsti.labels = bci_bst.labels
bci_bsti = patch_color_labels(bci_bsti)
view_patch_vtk(bci_bsti)

bci_bsti = smooth_patch(bci_bsti, iterations=10000)
view_patch_vtk(bci_bsti)

writedfs('BCI_DNI_economo_' + hemi + '.dfs', bci_bsti)
