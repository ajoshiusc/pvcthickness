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
    if (exist(['/home/ajoshi/for_shravanr/',subid{jj},'/atlas.iso-thickness_0-6mm.left.mid.cortex.dfs'],'file') && exist([subbasename,'.left.mid.cortex.svreg.dfs'],'file'))  

       sl=readdfs(['/home/ajoshi/for_shravanr/',subid{jj},'/atlas.iso-thickness_0-6mm.left.mid.cortex.dfs']);       
       sr=readdfs(['/home/ajoshi/for_shravanr/',subid{jj},'/atlas.iso-thickness_0-6mm.right.mid.cortex.dfs']);       

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


save male_female_fcon1000_iso;

jet1=[0.5,0.5,0.5;jet];
left_atlas=smooth_cortex_fast(left_atlas,.5,3000);
Tl=triangulation(left_atlas.faces,left_atlas.vertices);
[bvl]=Tl.freeBoundary;bvl=unique(bvl(:));

% parfor jj=1:size(mapped_thickness_l,2)
%     mapped_thickness_r_mapped2_l(:,jj)=smooth_surf_function(smidltar1,mapped_thickness_r_mapped2_l(:,jj));
%     mapped_thickness_l(:,jj)=smooth_surf_function(smidltar1,mapped_thickness_l(:,jj));
% jj
% end



%save smooth_mapped_thickness2

Tl=triangulation(smidltar.faces,smidltar.vertices);
[bvl]=Tl.freeBoundary;bvl=unique(bvl(:));
%Tr=triangulation(smidrtar.faces,smidrtar.vertices);
%[bvr]=Tr.freeBoundary;bvr=unique(bvr(:));
%avg_thickness_mappedr(bvr)=0;


[aa,pp]=ttest2(male_mapped_thickness_l',fem_mapped_thickness_l');
%pp=smooth_surf_function(smidltar1,pp',1,1);pp=pp';pp(pp<0)=0;
pp(bvl)=1;
pfdr=FDR(pp,0.05); pp=pp.*0.05./pfdr;
h=figure;axis equal;axis off;

smidltarc=close_surf(smidltar);[~,~,ia]=intersect(smidltar.vertices,smidltarc.vertices,'rows','stable');
pp1=1+zeros(length(smidltarc.vertices),1);pp1(ia)=pp;ppl=pp;
patch('faces',smidltarc.faces,'vertices',smidltarc.vertices,'facevertexcdata',10*(0.05-pp1).*(pp1<0.05),'facecolor','interp','edgecolor','none');
axis equal;colormap(jet1); material dull; view(-90,0);camlight('headlight');axis off;
saveas(h,'mapped_thickness_r_mapped2_l_iso_1_smooth.png');view(90,0);camlight('headlight');
saveas(h,'mapped_thickness_r_mapped2_l_iso_2_smooth.png');



diff1=trimmean(mapped_thickness_r_mapped2_l-mapped_thickness_l,10,2);diff1(bvl)=0;
diff=zeros(length(smidltarc.vertices),1);diff(ia)=diff1;
h=figure;patch('faces',smidltarc.faces,'vertices',smidltarc.vertices,'facevertexcdata',diff,'facecolor','interp','edgecolor','none');
axis equal;colormap(jet); material dull; view(-90,0);camlight('headlight');axis off;caxis([-1,1]);colormap(bipolar);
saveas(h,'mapped_thickness_r_mapped2_l_iso_1_smooth_diff.png');view(90,0);camlight('headlight');
saveas(h,'mapped_thickness_r_mapped2_l_iso_2_smooth_diff.png');

