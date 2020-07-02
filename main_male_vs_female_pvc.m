opengl software;
clc;clear all;close all;
restoredefaultpath;
addpath(genpath('/home/ajoshi/git_sandbox/svreg-matlab/src'));
addpath(genpath('/home/ajoshi/git_sandbox/svreg-matlab/dev'));
atlasbasename='/home/ajoshi/BCI-DNI_brain_atlas_lr/BCI-DNI_brain_lr';
newbasename = '/home/ajoshi/git_sandbox/svreg-matlab/';
%matlabpool local 2

fp=fopen('/home/ajoshi/thickness_paper/demographics1.csv','r');
jj=0;
while(~feof(fp))
    jj=jj+1;
    subid{jj}=fscanf(fp,'%s',1);
    subno{jj}=fscanf(fp,'%d',1);
    subage{jj}=fscanf(fp,'%d',1);
    subgender{jj}=fscanf(fp,'%s\n',1);
end
fclose(fp);
aa1 = 0;
left_atlas=readdfs('/home/ajoshi/git_sandbox/svreg-matlab/BCI-DNI_brain_atlas/BCI-DNI_brain.left.mid.cortex.dfs');
right_atlas=readdfs('/home/ajoshi/git_sandbox/svreg-matlab/BCI-DNI_brain_atlas/BCI-DNI_brain.right.mid.cortex.dfs');
maleno=0;femno=0;
for jj=1:length(subid)
    
    subbasename=['/home/ajoshi/for_shravanr/',subid{jj}, '/mprage_anonymized'];   
    if (exist(['/home/ajoshi/for_shravanr/',subid{jj},'/atlas.pvc-thickness_0-6mm.left.mid.cortex.dfs'],'file') && exist([subbasename,'.left.mid.cortex.svreg.dfs'],'file'))  

       sl=readdfs(['/home/ajoshi/for_shravanr/',subid{jj},'/atlas.pvc-thickness_0-6mm.left.mid.cortex.dfs']);       
       sr=readdfs(['/home/ajoshi/for_shravanr/',subid{jj},'/atlas.pvc-thickness_0-6mm.right.mid.cortex.dfs']);       

       if length(sl.attributes)~=length(left_atlas.vertices)
           continue;
       end
       if strcmp(subgender{jj},'f')
           femno=femno+1;
           fem_mapped_thickness_l(:,femno)=sl.attributes;
           fem_mapped_thickness_r(:,femno)=sr.attributes;
       else
           maleno=maleno+1;           
           male_mapped_thickness_l(:,maleno)=sl.attributes;
           male_mapped_thickness_r(:,maleno)=sr.attributes;
       end           
           
       jj
    end
    jj
end


save male_female_fcon1000_pvc;

jet1=[0.5,0.5,0.5;jet];
left_atlas=smooth_cortex_fast(left_atlas,.5,3000);
Tl=triangulation(left_atlas.faces,left_atlas.vertices);
[bvl]=Tl.freeBoundary;bvl=unique(bvl(:));

parfor jj=1:size(male_mapped_thickness_l,2)
     male_mapped_thickness_l(:,jj)=smooth_surf_function(left_atlas,male_mapped_thickness_l(:,jj));
     male_mapped_thickness_r(:,jj)=smooth_surf_function(right_atlas,male_mapped_thickness_r(:,jj));
jj
end


parfor jj=1:size(fem_mapped_thickness_l,2)
     fem_mapped_thickness_l(:,jj)=smooth_surf_function(left_atlas,fem_mapped_thickness_l(:,jj));
     fem_mapped_thickness_r(:,jj)=smooth_surf_function(right_atlas,fem_mapped_thickness_r(:,jj));
jj
end
save male_female_fcon1000_pvc_smooth;

%save smooth_mapped_thickness2

%Tr=triangulation(smidrtar.faces,smidrtar.vertices);
%[bvr]=Tr.freeBoundary;bvr=unique(bvr(:));
%avg_thickness_mappedr(bvr)=0;


[aa,pp]=ttest2(male_mapped_thickness_l',fem_mapped_thickness_l');
%pp=smooth_surf_function(smidltar1,pp',1,1);pp=pp';pp(pp<0)=0;
pp(bvl)=1;
pfdr=FDR(pp,0.05); pp=pp.*0.05./pfdr;
h=figure;axis equal;axis off;

left_atlasc=close_surf(left_atlas);[~,~,ia]=intersect(left_atlas.vertices,left_atlasc.vertices,'rows','stable');
pp1=1+zeros(length(left_atlas.vertices),1);pp1(ia)=pp;ppl=pp;
patch('faces',left_atlasc.faces,'vertices',left_atlasc.vertices,'facevertexcdata',10*(0.05-pp1).*(pp1<0.05),'facecolor','interp','edgecolor','none');
axis equal;colormap(jet1); material dull; view(-90,0);camlight('headlight');axis off;
saveas(h,'mapped_thickness_m_vs_f_mapped2_l_pvc_1_smooth.png');view(90,0);camlight('headlight');
saveas(h,'mapped_thickness_m_vs_f_mapped2_l_pvc_2_smooth.png');


[aa,pp]=ttest2(male_mapped_thickness_r',fem_mapped_thickness_r');
%pp=smooth_surf_function(smidltar1,pp',1,1);pp=pp';pp(pp<0)=0;
pp(bvl)=1;
pfdr=FDR(pp,0.05); pp=pp.*0.05./pfdr;
h=figure;axis equal;axis off;

right_atlasc=close_surf(right_atlas);[~,~,ia]=intersect(right_atlas.vertices,right_atlasc.vertices,'rows','stable');
pp1=1+zeros(length(right_atlas.vertices),1);pp1(ia)=pp;ppl=pp;
patch('faces',right_atlasc.faces,'vertices',right_atlasc.vertices,'facevertexcdata',10*(0.05-pp1).*(pp1<0.05),'facecolor','interp','edgecolor','none');
axis equal;colormap(jet1); material dull; view(-90,0);camlight('headlight');axis off;
saveas(h,'mapped_thickness_m_vs_f_mapped2_r_pvc_1_smooth.png');view(90,0);camlight('headlight');
saveas(h,'mapped_thickness_m_vs_f_mapped2_r_pvc_2_smooth.png');

