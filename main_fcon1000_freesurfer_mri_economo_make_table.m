
clc;clear all;close all;

addpath('/big_disk/ajoshi/freesurfer/matlab');

setenv('DATA_DIR','/ImagePTE1/ajoshi/code_farm/pvcthickness/MRI_Economo');

setenv('SUBJECTS_DIR','/big_disk/ajoshi/freesurfer/subjects');
l = dir('/big_disk/ajoshi/freesurfer/subjects/sub*');
[ave.vertices,ave.faces]=read_surf(['/big_disk/ajoshi/freesurfer/subjects/fsaverage/surf/rh.inflated']);ave.faces=ave.faces+1;

thicknessr=[];
subno=1;

subjects=[];
for j=1:length(l)
    
    subdir=['/big_disk/ajoshi/freesurfer/subjects/',l(j).name];
    if exist([subdir,'/surf/rh.thickness.fwhm10.fsaverage.mgh'],'file')

        setenv('SUBJECTNAME',l(j).name);
        subno = subno+1;
        
        subjects = sprintf('%s %s',subjects,l(j).name);
        
        fprintf('%d/%d subjects done\n',j,length(l));
    end
end

a=sprintf('aparcstats2table --subjects%s --hemi lh --meas thickness --parc economo --tablefile economo_lh_thickness_table.txt',subjects);
unix(a)

a=sprintf('aparcstats2table --subjects%s --hemi rh --meas thickness --parc economo --tablefile economo_rh_thickness_table.txt',subjects);
unix(a)
