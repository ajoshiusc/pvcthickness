opengl software;
clc;clear all;close all;
restoredefaultpath;
addpath(genpath('/home/ajoshi/git_sandbox/svreg-matlab/src'));
addpath(genpath('/home/ajoshi/git_sandbox/svreg-matlab/dev'));
atlasbasename='/home/ajoshi/BCI-DNI_brain_atlas_lr/BCI-DNI_brain_lr';
lst=dir('/home/ajoshi/for_shravanr/sub*');
newbasename = '/home/ajoshi/git_sandbox/svreg-matlab/';
%matlabpool local 2
aa1 = 0;
left_flipped=readdfs('/home/ajoshi/BCI-DNI_brain_atlas_lr/BCI-DNI_brain_lr.right.mid.cortex.svreg.dfs');
left_flipped_tar=readdfs('/home/ajoshi/BCI-DNI_brain_atlas_lr/atlas.right.mid.cortex.svreg.dfs');

for jj=1:length(lst)
    
    subbasename=['/home/ajoshi/for_shravanr/',lst(jj).name, '/mprage_anonymized'];   
    if (exist(['/home/ajoshi/for_shravanr/',lst(jj).name,'/atlas.pvc-thickness_0-6mm.left.mid.cortex.dfs'],'file') && exist([subbasename,'.left.mid.cortex.svreg.dfs'],'file'))  

       sl=readdfs(['/home/ajoshi/for_shravanr/',lst(jj).name,'/atlas.pvc-thickness_0-6mm.left.mid.cortex.dfs']);       
       sr=readdfs(['/home/ajoshi/for_shravanr/',lst(jj).name,'/atlas.pvc-thickness_0-6mm.right.mid.cortex.dfs']);       

       if length(sl.attributes)~=length(left_flipped.attributes)
           continue;
       end
          aa1=aa1+1;     
       mapped_thickness_l(:,aa1)=(sl.attributes);
       mapped_thickness_r(:,aa1)=(sr.attributes);
       
    
       mapped_thickness_r_mapped2_l(:,aa1)=mygriddata(left_flipped_tar.u',left_flipped_tar.v',mapped_thickness_r(:,aa1),left_flipped.u',left_flipped.v');
       jj
    end
    jj
end


save left_mapped2_right_fcon1000_pvc;

smidltar=readdfs('/home/ajoshi/BCI-DNI_brain_atlas_lr/atlas.left.mid.cortex.svreg.dfs');
jet1=[0.5,0.5,0.5;jet];smidltar1=smidltar;
smidltar=smooth_cortex_fast(smidltar,.1,6000);

for jj=1:size(mapped_thickness_l,2)
    mapped_thickness_r_mapped2_l(:,jj)=smooth_surf_function(smidltar1,mapped_thickness_r_mapped2_l(:,jj));
    mapped_thickness_l(:,jj)=smooth_surf_function(smidltar1,mapped_thickness_l(:,jj));
jj
end

save left_mapped2_right_fcon1000_pvc_smooth;

%save smooth_mapped_thickness2

Tl=triangulation(smidltar.faces,smidltar.vertices);
[bvl]=Tl.freeBoundary;bvl=unique(bvl(:));
%Tr=triangulation(smidrtar.faces,smidrtar.vertices);
%[bvr]=Tr.freeBoundary;bvr=unique(bvr(:));
%avg_thickness_mappedr(bvr)=0;


[aa,pp]=ttest(mapped_thickness_r_mapped2_l',mapped_thickness_l');
%pp=smooth_surf_function(smidltar1,pp',1,1);pp=pp';pp(pp<0)=0;
pp(bvl)=1;
pfdr=FDR(pp,0.05); pp=pp.*0.05./pfdr;
h=figure;axis equal;axis off;


smidltarc=close_surf(smidltar);[~,~,ia]=intersect(smidltar.vertices,smidltarc.vertices,'rows','stable');
pp1=1+zeros(length(smidltarc.vertices),1);pp1(ia)=pp;ppl=pp;
patch('faces',smidltarc.faces,'vertices',smidltarc.vertices,'facevertexcdata',10*(0.05-pp1).*(pp1<0.05),'facecolor','interp','edgecolor','none');
axis equal;colormap(jet1); material dull; view(-90,0);camlight('headlight');axis off;caxis([0,.5]);
saveas(h,'mapped_thickness_r_mapped2_l_pvc_1_smooth.png');view(90,0);camlight('headlight');
saveas(h,'mapped_thickness_r_mapped2_l_pvc_2_smooth.png');



diff1=trimmean(mapped_thickness_r_mapped2_l-mapped_thickness_l,10,2);diff1(bvl)=0;
diff=zeros(length(smidltarc.vertices),1);diff(ia)=diff1;
h=figure;patch('faces',smidltarc.faces,'vertices',smidltarc.vertices,'facevertexcdata',diff,'facecolor','interp','edgecolor','none');
axis equal;colormap(jet); material dull; view(-90,0);camlight('headlight');axis off;caxis([-1,1]);colormap(bipolar);
saveas(h,'mapped_thickness_r_mapped2_l_pvc_1_smooth_diff.png');view(90,0);camlight('headlight');
saveas(h,'mapped_thickness_r_mapped2_l_pvc_2_smooth_diff.png');


