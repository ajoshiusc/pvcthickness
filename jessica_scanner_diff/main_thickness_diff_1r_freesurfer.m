%||AUM||
opengl software;
clc;clear ;close all;
restoredefaultpath;
addpath(genpath('/home/ajoshi/git_sandbox/svreg-matlab/dev'));
addpath(genpath('/home/ajoshi/git_sandbox/svreg-matlab/src'));
addpath(genpath('/home/ajoshi/freesurfer/matlab'));
[ave_sp.vertices,ave_sp.faces]=read_surf(['/home/ajoshi/freesurfer/subjects/fsaverage/surf/rh.sphere.reg']);ave_sp.faces=ave_sp.faces+1;
[ave.vertices,ave.faces]=read_surf(['/home/ajoshi/freesurfer/subjects/fsaverage/surf/rh.inflated']);ave.faces=ave.faces+1;


for jj=3%1:6
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
                [~,sub1]=fileparts(subbasename);
                subbasename2=['/home/ajoshi/freesurfer/subjects/',sub1];
                
                if exist([subbasename2,'/surf/rh.sphere.reg'],'file') && exist([subbasename2,'/surf/rh.thickness'],'file')
                    %pth=fileparts(subbasename);
 
                    thicknessr(:,scanno1)=load_mgh([subbasename2,'/surf/rh.thickness.fsaverage.mgh']);
                    %griddatan(sph2,th2,ave_sp.vertices,'nearest');
                    
                    h=figure;
                    patch('vertices',ave.vertices,'faces',ave.faces,'facevertexcdata',thicknessr(:,scanno1),'edgecolor','none','facecolor','interp');
                    axis on;axis equal;caxis([0,5]);axis off;
                    view(90,0);camlight('headlight');material dull;
                    saveas(h,sprintf('FS_sub%d_%d_l_1ge_vs_siemens_right2_1.png',jj,scanno1));
                    autocrop_img(sprintf('FS_sub%d_%d_l_1ge_vs_siemens_right2_1.png',jj,scanno1));
                    view(-90,0);camlight('headlight');material dull;
                    saveas(h,sprintf('FS_sub%d_%d_l_1ge_vs_siemens_right2_2.png',jj,scanno1));
                    autocrop_img(sprintf('FS_sub%d_%d_l_1ge_vs_siemens_right2_2.png',jj,scanno1));
                    
                    
                    scanno1=scanno1+1;
                    
                else
                    
                    jj
                end
            end
            
            %       if length(subdir)>0
            %           break;
            %       end
        end
    end
    
    if scanno1>1
        sr=ave;%smooth_cortex_fast(ave,.1,6000);
        std_thr=smooth_surf_function(sr,thicknessr(:,3)-thicknessr(:,5));
        
        
        h=figure;
        patch('vertices',sr.vertices,'faces',sr.faces,'facevertexcdata',(std_thr),'edgecolor','none','facecolor','interp');
        axis on;axis equal;caxis([-0.75,.75]);axis off;
        view(90,0);camlight('headlight');material dull;
        saveas(h,sprintf('diff_thickness_FS_sub%d_l_1ge_vs_siemens_right2.png',jj));
        autocrop_img(sprintf('diff_thickness_FS_sub%d_l_1ge_vs_siemens_right2.png',jj));
        view(-90,0);camlight('headlight');material dull;
        saveas(h,sprintf('diff_thickness_FS_sub%d_l_2ge_vs_siemens_right2.png',jj));
        autocrop_img(sprintf('diff_thickness_FS_sub%d_l_2ge_vs_siemens_right2.png',jj));
        
    end
end


