%||AUM||
opengl software;
clc;clear ;close all;
restoredefaultpath;
addpath(genpath('/home/ajoshi/git_sandbox/svreg-matlab/dev'));
addpath(genpath('/home/ajoshi/git_sandbox/svreg-matlab/src'));


for jj=1:6
    ll1=dir(sprintf('/home/ajoshi/jessica_6_subs/SUBJECT%d',jj));scanno1=1;
    for kk=1:length(ll1)
        
        if ll1(kk).name(1)=='.'
            continue;
        end
        
        ll2=dir(sprintf('/home/ajoshi/jessica_6_subs/SUBJECT%d/%s',jj,ll1(kk).name));
        for ii=1:length(ll2)
            if ll2(ii).name(1)=='.'
                continue;
            end
            ll3=dir(sprintf('/home/ajoshi/jessica_6_subs/SUBJECT%d/%s/%s',jj,ll1(kk).name,ll2(ii).name));
            dcmname=sprintf('/home/ajoshi/jessica_6_subs/SUBJECT%d/%s/%s/%s',jj,ll1(kk).name,ll2(ii).name,ll3(3).name);
            
            subdir=dir(sprintf('/home/ajoshi/jessica_6_subs/SUBJECT%d/%s/%s/*.nii.gz',jj,ll1(kk).name,ll2(ii).name));
            %             for ww=1:length(subdir)
            %                 delete(sprintf('/home/ajoshi/jessica_6_subs/SUBJECT%d/%s/%s/%s',jj,ll1(kk).name,ll2(ii).name,subdir(ww).name));
            %             end
            ll3=dir(sprintf('/home/ajoshi/jessica_6_subs/SUBJECT%d/%s/%s',jj,ll1(kk).name,ll2(ii).name));
            dcmname=sprintf('/home/ajoshi/jessica_6_subs/SUBJECT%d/%s/%s/%s',jj,ll1(kk).name,ll2(ii).name,ll3(3).name);
            
            
            %%%unix(sprintf('/home/ajoshi/mricron/dcm2nii %s',dcmname));
            subdir=dir(sprintf('/home/ajoshi/jessica_6_subs/SUBJECT%d/%s/%s/c*.air',jj,ll1(kk).name,ll2(ii).name));
            
            for ww=1:min(1,length(subdir))
                subbasename=subdir(ww).name(1:end-4);
                subbasename=sprintf('/home/ajoshi/jessica_6_subs/SUBJECT%d/%s/%s/%s',jj,ll1(kk).name,ll2(ii).name,subbasename);
                if exist([subbasename,'.pvc-thickness_0-6mm.left.mid.cortex.dfs'],'file')
                    pth=fileparts(subbasename);
                    
                    sr=readdfs([pth,'/atlas.pvc-thickness_0-6mm.left.mid.cortex.dfs']);
                    thicknessr(:,scanno1)=smooth_surf_function(sr,sr.attributes);sr.attributes=thicknessr(:,scanno1);
                    writedfs([pth,'/atlas.pvc-thickness_0-6mm.left.mid.cortex.sm.dfs'],sr)
                    
                    sriso=readdfs([pth,'/atlas.iso-thickness_0-6mm.left.mid.cortex.dfs']);
                    thicknessriso(:,scanno1)=smooth_surf_function(sriso,sriso.attributes);sriso.attributes=thicknessriso(:,scanno1);
                    writedfs([pth,'/atlas.iso-thickness_0-6mm.left.mid.cortex.sm.dfs'],sriso);
                    
                    srld=readdfs([pth,'/atlas.left.mid.cortex.svreg.dfs']);
                    thicknessrld(:,scanno1)=smooth_surf_function(sr,srld.attributes);srld.attributes=thicknessrld(:,scanno1);
                    writedfs([pth,'/atlas.left.mid.cortex.svreg.sm.dfs'],srld);
                    
                    scanno1=scanno1+1;
                    
                else
                    
                    jj
                    %                    subno
                end
            end
            
     %       if length(subdir)>0
     %           break;
     %       end
        end
    end
    
    if scanno1>1
        sr=smooth_cortex_fast(sr,.1,6000);
        std_thr=thicknessr(:,2)-thicknessr(:,3)-.1;
        std_thriso=thicknessriso(:,2)-thicknessriso(:,3);
        std_thrld=thicknessrld(:,2)-thicknessrld(:,3);
        
        Tl=triangulation(sr.faces,sr.vertices);
        [bvl]=Tl.freeBoundary;bvl=unique(bvl(:));
        std_thr(bvl)=0;        std_thriso(bvl)=0;        std_thrld(bvl)=0;
        
        
        src=close_surf(sr);
        srco=src;
        
        [~,~,ia]=intersect(sr.vertices,src.vertices,'rows','stable');
        std_thrc=zeros(length(src.vertices),1);
        std_thrc(ia)=std_thr;
        std_thrisoc=zeros(length(src.vertices),1);
        std_thrisoc(ia)=std_thriso;
        std_thrldc=zeros(length(src.vertices),1);
        std_thrldc(ia)=std_thrld;
        
        
        
        h=figure;
        patch('vertices',src.vertices,'faces',src.faces,'facevertexcdata',std_thrc,'edgecolor','none','facecolor','interp');
        axis on;axis equal;caxis([-1,1]);axis off;
        view(90,30);camlight('headlight');material dull;
        saveas(h,sprintf('std_dev_thickness_ALE1_sub%d_r_1ge_si_left2.png',jj));
        autocrop_img(sprintf('std_dev_thickness_ALE1_sub%d_r_1ge_si_left2.png',jj));
        view(-90,0);camlight('headlight');material dull;
        saveas(h,sprintf('std_dev_thickness_ALE1_sub%d_r_2ge_si_left2.png',jj));
        autocrop_img(sprintf('std_dev_thickness_ALE1_sub%d_r_2ge_si_left2.png',jj));
        
        
        h=figure;
        patch('vertices',src.vertices,'faces',src.faces,'facevertexcdata',std_thrisoc,'edgecolor','none','facecolor','interp');
        axis on;axis equal;caxis([-1,1]);axis off;
        view(90,30);camlight('headlight');material dull;
        saveas(h,sprintf('std_dev_thickness_LE1_sub%d_r_1ge_si_left2.png',jj));
        autocrop_img(sprintf('std_dev_thickness_LE1_sub%d_r_1ge_si_left2.png',jj));
        view(-90,0);camlight('headlight');material dull;
        saveas(h,sprintf('std_dev_thickness_LE1_sub%d_r_2ge_si_left2.png',jj));
        autocrop_img(sprintf('std_dev_thickness_LE1_sub%d_r_2ge_si_left2.png',jj));
        
        
        h=figure;
        patch('vertices',src.vertices,'faces',src.faces,'facevertexcdata',std_thrldc,'edgecolor','none','facecolor','interp');
        axis on;axis equal;caxis([-1,1]);axis off;
        view(90,30);camlight('headlight');material dull;
        saveas(h,sprintf('std_dev_thickness_LD1_sub%d_r_1ge_si_left2.png',jj));
        autocrop_img(sprintf('std_dev_thickness_LD1_sub%d_r_1ge_si_left2.png',jj));
        view(-90,0);camlight('headlight');material dull;
        saveas(h,sprintf('std_dev_thickness_LD1_sub%d_r_2ge_si_left2.png',jj));
        autocrop_img(sprintf('std_dev_thickness_LD1_sub%d_r_2ge_si_left2.png',jj));
        
        
    end
end


