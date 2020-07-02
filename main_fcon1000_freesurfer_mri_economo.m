
clc;clear all;close all;

addpath('/big_disk/ajoshi/freesurfer/matlab');

setenv('DATA_DIR','/ImagePTE1/ajoshi/code_farm/pvcthickness/MRI_Economo');

setenv('SUBJECTS_DIR','/big_disk/ajoshi/freesurfer/subjects');
l = dir('/big_disk/ajoshi/freesurfer/subjects/sub*');
[ave.vertices,ave.faces]=read_surf(['/big_disk/ajoshi/freesurfer/subjects/fsaverage/surf/rh.inflated']);ave.faces=ave.faces+1;

thicknessr=[];
subno=1;
for j=1:length(l)
    
    subdir=['/big_disk/ajoshi/freesurfer/subjects/',l(j).name];
    if exist([subdir,'/surf/rh.thickness.fwhm10.fsaverage.mgh'],'file')

        setenv('SUBJECTNAME',l(j).name);
        subno = subno+1;
        
        unix('mris_ca_label -t ${DATA_DIR}/lh.colortable.txt ${SUBJECTNAME} lh ${SUBJECTS_DIR}/${SUBJECTNAME}/surf/lh.sphere.reg ${DATA_DIR}/lh.economo.gcs ${SUBJECTS_DIR}/${SUBJECTNAME}/label/lh.economo.annot')
        unix('mris_ca_label -t ${DATA_DIR}/rh.colortable.txt ${SUBJECTNAME} rh ${SUBJECTS_DIR}/${SUBJECTNAME}/surf/rh.sphere.reg ${DATA_DIR}/rh.economo.gcs ${SUBJECTS_DIR}/${SUBJECTNAME}/label/rh.economo.annot')

        unix('mris_anatomical_stats -a ${SUBJECTNAME}/label/lh.economo.annot -f ${SUBJECTNAME}/stats/lh.economo.stats ${SUBJECTNAME} lh');
        unix('mris_anatomical_stats -a ${SUBJECTNAME}/label/rh.economo.annot -f ${SUBJECTNAME}/stats/rh.economo.stats ${SUBJECTNAME} rh');
        
        
        fprintf('%d/%d subjects done\n',j,length(l));
    end
end
