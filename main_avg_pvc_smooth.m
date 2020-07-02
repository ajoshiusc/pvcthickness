%opengl software;
clc;clear all;close all;
restoredefaultpath;
addpath(genpath('.'));
addpath(genpath('/big_disk/ajoshi/coding_ground/svreg/src'));

atlasbasename='/big_disk/ajoshi/coding_ground/svreg/BrainSuiteAtlas1/mri';
lst=dir('/big_disk/ajoshi/coding_ground/pvcthickness/HCP_data/*');
%matlabpool local 2
aa1 = 0;
atlas_l=readdfsGz([atlasbasename,'.left.mid.cortex.dfs']);
atlas_r=readdfsGz([atlasbasename,'.right.mid.cortex.dfs']);


for jj=1:length(lst)
    subbasename=['/big_disk/ajoshi/coding_ground/pvcthickness/HCP_data/',lst(jj).name, '/atlas'];
    if (exist([['/big_disk/ajoshi/coding_ground/pvcthickness/HCP_data/',lst(jj).name, '/atlas'], '.pvc-thickness_0-6mm.left.mid.cortex.dfs'],'file') )
        aa1=aa1+1;
        %split_thickness_map(['/auto/rcf-proj2/aaj/for_shravanr/',lst(jj).name, '/mprage_anonymized']);
        s=readdfs([subbasename, '.pvc-thickness_0-6mm.left.mid.cortex.dfs']);
        if length(s.attributes)~=length(atlas_l.vertices)
            continue;
        end
        if (aa1==1)
            thicknessl=zeros(length(s.attributes),length(lst));
        end
        thicknessl(:,aa1)=s.attributes;
        s=readdfs([subbasename, '.pvc-thickness_0-6mm.right.mid.cortex.dfs']);
        if (aa1==1)
            thicknessr=zeros(length(s.attributes),length(lst));
        end
        
        thicknessr(:,aa1)=s.attributes;
        
    end
    jj
end
thicknessr(:,aa1+1:end)=[];thicknessl(:,aa1+1:end)=[];
save hcp_avg

avg_thickness_mappedl=trimmean(thicknessl,10,2);
avg_thickness_mappedr=trimmean(thicknessr,10,2);
%avg_thickness_mappedl_linked=trimmean(mapped_thickness_l_linked,10,2);
%avg_thickness_mappedr_linked=trimmean(mapped_thickness_r_linked,10,2);
smidltar=atlas_l;smidrtar=atlas_r;
smidltar1=smidltar;smidrtar1=smidrtar;
Tl=triangulation(smidltar.faces,smidltar.vertices);
[bvl]=Tl.freeBoundary;bvl=unique(bvl(:));
avg_thickness_mappedl(bvl)=0;
Tr=triangulation(smidrtar.faces,smidrtar.vertices);
[bvr]=Tr.freeBoundary;bvr=unique(bvr(:));
avg_thickness_mappedr(bvr)=0;


smidrtar.attributes=avg_thickness_mappedr;
smidltar.attributes=avg_thickness_mappedl;
smidltar=smooth_cortex_fast(smidltar,.1,6000);
smidrtar=smooth_cortex_fast(smidrtar,.1,6000);
smidltarc=close_surf(smidltar);smidltarco=smidltarc;
smidrtarc=close_surf(smidrtar);smidrtarco=smidrtarc;


[~,~,ia]=intersect(smidltar.vertices,smidltarc.vertices,'rows','stable');
avg_thickness_mappedlc=zeros(length(smidltarc.vertices),1);
avg_thickness_mappedlc(ia)=avg_thickness_mappedl;

%avg_thickness_mappedlsmc=avg_thickness_mappedlc;%
avg_thickness_mappedlsmc=smooth_surf_function(smidltarc,avg_thickness_mappedlc,1,1);
avg_thickness_mappedlsmc(ia(bvl))=0;

h=figure;
patch('faces',smidltarc.faces,'vertices',smidltarc.vertices,'facevertexcdata',avg_thickness_mappedlsmc,'edgecolor','none','facecolor','interp');axis off;
caxis([0,4.5]);view(-90,0);axis equal; axis off; camlight; material dull;
saveas(h,'avg_thickness_mappedl_sm.fig');
view(-90,30);camlight;material dull;
saveas(h,'avg_thickness_mappedl_1_sm.png');
caxis([0,4.5]);view(90,0);axis equal; axis off; camlight; material dull;
saveas(h,'avg_thickness_mappedl_2_sm.png');

[~,~,ia]=intersect(smidrtar.vertices,smidrtarc.vertices,'rows','stable');
avg_thickness_mappedrc=zeros(length(smidrtarc.vertices),1);
avg_thickness_mappedrc(ia)=avg_thickness_mappedr;
avg_thickness_mappedrsm=avg_thickness_mappedrc;%smooth_surf_function(smidrtarc,avg_thickness_mappedrc,1,1);
avg_thickness_mappedrsm(ia(bvr))=0;

h=figure;
patch('faces',smidrtarc.faces,'vertices',smidrtarc.vertices,'facevertexcdata',avg_thickness_mappedrsm,'edgecolor','none','facecolor','interp');axis off;
caxis([0,4.5]);view(-90,0);axis equal; axis off; camlight; material dull;
saveas(h,'avg_thickness_mappedr_sm.fig');
view(-90,0);camlight;material dull;colormap jet
saveas(h,'avg_thickness_mappedr_1_sm.png');
view(90,30);camlight;material dull;
saveas(h,'avg_thickness_mappedr_2_sm.png');

h=figure;
[~,~,ia]=intersect(smidltar.vertices,smidltarc.vertices,'rows','stable');
avg_thickness_mappedl_linkedc=zeros(length(smidltarc.vertices),1);
avg_thickness_mappedl_linkedc(ia)=avg_thickness_mappedl_linked;
avg_thickness_mappedl_linkedc(ia(bvl))=0;

view_patch_economo3(smidltarc,avg_thickness_mappedl_linkedc);

saveas(h,'avg_thickness_mappedl_linked.fig');
view(-90,30);camlight;material dull;
saveas(h,'avg_thickness_mappedl_1_linked.png');
view(90,0);camlight;material dull;
saveas(h,'avg_thickness_mappedl_2_linked.png');

h=figure;
[~,~,ia]=intersect(smidrtar.vertices,smidrtarc.vertices,'rows','stable');
avg_thickness_mappedr_linkedc=zeros(length(smidrtarc.vertices),1);
avg_thickness_mappedr_linkedc(ia)=avg_thickness_mappedr_linked;
avg_thickness_mappedr_linkedc(ia(bvr))=0;
view_patch_economo3(smidrtarc,avg_thickness_mappedr_linkedc);
saveas(h,'avg_thickness_mappedr_linked.fig');
view(-90,0);camlight;material dull;
saveas(h,'avg_thickness_mappedr_1_linked.png');
view(90,30);camlight;material dull;
saveas(h,'avg_thickness_mappedr_2_linked.png');



%thickness_heateq /home/biglab/Easswar/svreg-matlab/sample/data1/data1_input/data1_orig/brainsuite_subj1_m6


