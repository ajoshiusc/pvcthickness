%||AUM||
%||Shree Ganeshaya Namaha||
clc;clear all;close all;

addpath('/big_disk/ajoshi/freesurfer/matlab');

%l = dir('/home/ajoshi/Downloads/subjects/c*');
l = dir('/big_disk/ajoshi/freesurfer/subjects/sub*');


[ave.vertices,ave.faces]=read_surf(['/big_disk/ajoshi/freesurfer/subjects/fsaverage/surf/rh.inflated']);ave.faces=ave.faces+1;

thicknessr=[];
subno=1;
for j=1:length(l)
    
    subdir=['/big_disk/ajoshi/freesurfer/subjects/',l(j).name];
    if exist([subdir,'/surf/rh.thickness.fwhm10.fsaverage.mgh'],'file')
        thicknessr(:,subno)=load_mgh([subdir,'/surf/rh.thickness.fwhm10.fsaverage.mgh']);
        subno = subno+1;
        fprintf('%d/%d subjects done\n',j,length(l));
    end
end

jet1=jet(1000);
jet1(1,:)=1;
h=figure;
patch('vertices',ave.vertices,'faces',ave.faces,'facevertexcdata',mean(thicknessr,2),'edgecolor','none','facecolor','interp');
axis on;axis equal;caxis([0,4.5]);axis off;view(90,30);material dull;colormap(jet1);camlight;axis tight;
saveas(h,'fs_avg_thickness_1_rh.png');
view(-90,0);camlight;axis tight;
saveas(h,'fs_avg_thickness_2_rh.png');



