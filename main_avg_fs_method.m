opengl software;
clc;clear all;close all;
restoredefaultpath;
addpath(genpath('.'));
addpath(genpath('/ImagePTE1/ajoshi/code_farm/svreg/src'));

atlasbasename='/home/ajoshi/BrainSuite21a/svreg/BCI-DNI_brain_atlas/BCI-DNI_brain';
lst=dir('/big_disk/ajoshi/fcon_1000/Beijing/su*');
%matlabpool local 2
aa1 = 0;
%matlabpool(3);
% for jj=1:length(lst)
%     try
%         subbasename=['/big_disk/ajoshi/fcon_1000/Beijing/',lst(jj).name, '/mprage_anonymized'];
%         if ~exist([subbasename, '.iso-thickness_0-6mm.mid.cortex.dfs'],'file')
%             tic;fprintf('%s\n',lst(jj).name);
%             thicknessiso(subbasename,.5);toc
%         else
%             lst1=dir([subbasename, '.iso-thickness_0-6mm.mid.cortex.dfs']);
%             if (-1*(lst1.datenum -datenum(date)))<5
%                 fprintf('Smoothing done %s for %s\n',datestr(lst1.datenum),lst(jj).name);
%                 continue;
%             end;
%         end
%     catch
%         disp('Hi');
%     end
% end
atlas_l=readdfsGz([atlasbasename,'.left.mid.cortex.dfs']);
atlas_r=readdfsGz([atlasbasename,'.right.mid.cortex.dfs']);


for jj=1:length(lst)
    subbasename=['/big_disk/ajoshi/fcon_1000/Beijing/',lst(jj).name, '/anat/BST/atlas'];
    if (exist(['/big_disk/ajoshi/fcon_1000/Beijing/',lst(jj).name, '/anat/BST/atlas_fs_thickness.left.mid.cortex.svreg.dfs'],'file') )
        aa1=aa1+1;
        %split_thickness_map(['/big_disk/ajoshi/fcon_1000/Beijing/',lst(jj).name, '/mprage_anonymized']);
        s=readdfs([subbasename, '_fs_thickness.left.mid.cortex.svreg.dfs']);
        if length(s.attributes)~=length(atlas_l.vertices)
            continue;
        end
        if (aa1==1)
            thicknessl=zeros(length(s.attributes),length(lst));
        end
        thicknessl(:,aa1)=s.attributes;
        s=readdfs([subbasename, '_fs_thickness.right.mid.cortex.svreg.dfs']);
        if (aa1==1)
            thicknessr=zeros(length(s.attributes),length(lst));
        end
        
        thicknessr(:,aa1)=s.attributes;
        
    end
    jj
end
thicknessr(:,aa1+1:end)=[];thicknessl(:,aa1+1:end)=[];
save fcon1000_avg_fs_method
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



smidltar=smooth_cortex_fast(smidltar,.5,3000);
smidrtar=smooth_cortex_fast(smidrtar,.5,3000);
smidltarc=close_surf(smidltar);smidltarco=smidltarc;
smidrtarc=close_surf(smidrtar);smidrtarco=smidrtarc;


[~,~,ia]=intersect(smidltar.vertices,smidltarc.vertices,'rows','stable');
avg_thickness_mappedlc=zeros(length(smidltarc.vertices),1);
avg_thickness_mappedlc(ia)=avg_thickness_mappedl;

avg_thickness_mappedlsmc=avg_thickness_mappedlc;%smooth_surf_function(smidltarc,avg_thickness_mappedlc,1,1);
avg_thickness_mappedlsmc(ia(bvl))=0;

h=figure;
view_patch_economo(smidltarc,avg_thickness_mappedlsmc);
saveas(h,'avg_thickness_mappedl_fs_method.fig');
view(-90,30);camlight('headlight');material dull;
saveas(h,'avg_thickness_mappedl_1_fs_method.png');

view(90,0);camlight('headlight');material dull;
saveas(h,'avg_thickness_mappedl_2_fs_method.png');

[~,~,ia]=intersect(smidrtar.vertices,smidrtarc.vertices,'rows','stable');
avg_thickness_mappedrc=zeros(length(smidrtarc.vertices),1);
avg_thickness_mappedrc(ia)=avg_thickness_mappedr;
avg_thickness_mappedrsm=avg_thickness_mappedrc;%smooth_surf_function(smidrtarc,avg_thickness_mappedrc,1,1);
avg_thickness_mappedrsm(ia(bvr))=0;

h=figure;
view_patch_economo(smidrtarc,avg_thickness_mappedrsm);
saveas(h,'avg_thickness_mappedr_fs_method.fig');
view(-90,0);camlight('headlight');material dull;
saveas(h,'avg_thickness_mappedr_1_fs_method.png');
view(90,30);camlight('headlight');material dull;
saveas(h,'avg_thickness_mappedr_2_fs_method.png');


h=figure;
patch('faces',smidltarc.faces,'vertices',smidltarc.vertices,'facevertexcdata',avg_thickness_mappedlsmc,'facecolor','interp','edgecolor','none');
view(-90,30);material dull;caxis([0,4.5]);axis equal; axis off;
aa=jet;
%%aa(1:round(64*2/4.5),3)=0.5625;aa(1:round(64*2/4.5),[1,2])=0;
colormap(aa);
view(-90,30);camlight('headlight');material dull;
saveas(h,'avg_thickness_left_fs_method_continuous_1.png');
view(90,0);camlight('headlight');material dull;
saveas(h,'avg_thickness_left_fs_method_continuous_2.png');


h=figure;
patch('faces',smidrtarc.faces,'vertices',smidrtarc.vertices,'facevertexcdata',avg_thickness_mappedrsm,'facecolor','interp','edgecolor','none');
view(-90,0);material dull;caxis([0,4.5]);axis equal; axis off;
aa=jet;
%%aa(1:round(64*2/4.5),3)=0.5625;aa(1:round(64*2/4.5),[1,2])=0;
colormap(aa);
view(-90,0);camlight('headlight');material dull;
saveas(h,'avg_thickness_right_fs_method_continuous_1.png');
view(90,30);camlight('headlight');material dull;
saveas(h,'avg_thickness_right_fs_method_continuous_2.png');



