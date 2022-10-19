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
            
            for ww=1:length(subdir)
                subbasename=subdir(ww).name(1:end-4);
                subbasename=sprintf('/home/ajoshi/jessica_6_subs/SUBJECT%d/%s/%s/%s',jj,ll1(kk).name,ll2(ii).name,subbasename);
                if exist([subbasename,'.pvc-thickness_0-6mm.right.mid.cortex.dfs'],'file')
                    pth=fileparts(subbasename);
                    
                    sr=readdfs([pth,'/atlas.pvc-thickness_0-6mm.right.mid.cortex.dfs']);
                    thicknessr(:,scanno1)=sr.attributes;
                    
                    sriso=readdfs([pth,'/atlas.iso-thickness_0-6mm.right.mid.cortex.dfs']);
                    thicknessriso(:,scanno1)=sriso.attributes;
                    
                    srld=readdfs([pth,'/atlas.right.mid.cortex.svreg.dfs']);
                    thicknessrld(:,scanno1)=srld.attributes;scanno1=scanno1+1;
                    
                    scanno1=scanno1+1;
                else
                    
                    jj
                    %                    subno
                end
            end
        end
    end
    
    if scanno1>1
        sr=smooth_cortex_fast(sr,.1,6000);
        std_thr=std(thicknessr,[],2);
        std_thriso=std(thicknessriso,[],2);
        std_thrld=std(thicknessrld,[],2);
        
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
        axis on;axis equal;caxis([0,6]);axis off;
        view(90,30);camlight('headlight');material dull;
        saveas(h,sprintf('std_dev_thickness_ALE_sub%d_r_1.png',jj));
        view(-90,0);camlight('headlight');material dull;
        saveas(h,sprintf('std_dev_thickness_ALE_sub%d_r_2.png',jj));
        
        
        
        h=figure;
        patch('vertices',src.vertices,'faces',src.faces,'facevertexcdata',std_thrisoc,'edgecolor','none','facecolor','interp');
        axis on;axis equal;caxis([0,6]);axis off;
        view(90,30);camlight('headlight');material dull;
        saveas(h,sprintf('std_dev_thickness_LE_sub%d_r_1.png',jj));
        view(-90,0);camlight('headlight');material dull;
        saveas(h,sprintf('std_dev_thickness_LE_sub%d_r_2.png',jj));
        
        
        h=figure;
        patch('vertices',src.vertices,'faces',src.faces,'facevertexcdata',std_thrldc,'edgecolor','none','facecolor','interp');
        axis on;axis equal;caxis([0,6]);axis off;
        view(90,30);camlight('headlight');material dull;
        saveas(h,sprintf('std_dev_thickness_LD_sub%d_r_1.png',jj));
        view(-90,0);camlight('headlight');material dull;
        saveas(h,sprintf('std_dev_thickness_LD_sub%d_r_2.png',jj));
        
        
    end
end


