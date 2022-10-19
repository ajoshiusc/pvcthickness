%||AUM||
opengl software;
clc;clear ;close all;
restoredefaultpath;
addpath(genpath('/home/ajoshi/git_sandbox/svreg-matlab/dev'));
addpath(genpath('/home/ajoshi/git_sandbox/svreg-matlab/src'));


for jj=1:6
    ll1=dir(sprintf('/home/ajoshi/jessica_6_subs/SUBJECT%d',jj));scanno1=1;
    scannerno=0;        clear avg_th_r avg_th_iso_r avg_th_ld_r;

    for kk=1:length(ll1)
        
        
        if ll1(kk).name(1)=='.'
            continue;
        end
        
        ll2=dir(sprintf('/home/ajoshi/jessica_6_subs/SUBJECT%d/%s',jj,ll1(kk).name));
        scanner_scan=0;
        thicknessr=[];
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
                    scanner_scan=scanner_scan+1;
                    sr=readdfs([pth,'/atlas.pvc-thickness_0-6mm.right.mid.cortex.dfs']);
                    thicknessr(:,scanner_scan)=smooth_surf_function(sr,sr.attributes);
                    
                    sriso=readdfs([pth,'/atlas.iso-thickness_0-6mm.right.mid.cortex.dfs']);
                    thicknessriso(:,scanner_scan)=smooth_surf_function(sriso,sriso.attributes);
                    
                    srld=readdfs([pth,'/atlas.right.mid.cortex.svreg.dfs']);
                    thicknessrld(:,scanner_scan)=smooth_surf_function(srld,srld.attributes);
                    
                   
                    
                else
                    
                    jj
                    %                    subno
                end
            end
            
%            if length(subdir)>0
%                break;
%            end
            
        end
                scannerno=scannerno+1;
        
        avg_th_r(:,scannerno)=mean(thicknessr,2);
        avg_th_iso_r(:,scannerno)=mean(thicknessriso,2);
        avg_th_ld_r(:,scannerno)=mean(thicknessrld,2);

    end
    sr=smooth_cortex_fast(sr,.5,3000);
        save(sprintf('/home/ajoshi/jessica_6_subs/SUBJECT%d.mat',jj)); 

    Tl=triangulation(sr.faces,sr.vertices);
    [bvl]=Tl.freeBoundary;bvl=unique(bvl(:));
    avg_th_r(bvl,:)=0;    avg_th_iso_r(bvl,:)=0; avg_th_ld_r(bvl,:)=0;

    
    src=close_surf(sr);srco=src;
    [~,~,ia]=intersect(sr.vertices,src.vertices,'rows','stable');
    avg_th_rc=zeros(length(src.vertices),size(avg_th_r,2));
    avg_th_rc(ia,:)=avg_th_r;
    avg_th_iso_rc=zeros(length(src.vertices),size(avg_th_iso_r,2));
    avg_th_iso_rc(ia,:)=avg_th_iso_r;
    avg_th_ld_rc=zeros(length(src.vertices),size(avg_th_ld_r,2));
    avg_th_ld_rc(ia,:)=avg_th_ld_r;

        
    h=figure;
    patch('faces',src.faces,'vertices',src.vertices,'facevertexcdata',abs(avg_th_rc(:,1)-avg_th_rc(:,3)),'facecolor','interp','edgecolor','none');
    view(90,30);axis equal;camlight;material dull;caxis([0,1]);axis off;
    saveas(h,sprintf('/home/ajoshi/jessica_6_subs/SUBJECT%d_pvc1.png',jj));
    view(-90,0);axis equal;camlight;material dull;caxis([0,1]);
    saveas(h,sprintf('/home/ajoshi/jessica_6_subs/SUBJECT%d_pvc2.png',jj));
    
    h=figure;
    patch('faces',src.faces,'vertices',src.vertices,'facevertexcdata',abs(avg_th_iso_rc(:,1)-avg_th_iso_rc(:,3)),'facecolor','interp','edgecolor','none');
    view(90,30);axis equal;camlight;material dull;caxis([0,1]);axis off;
    saveas(h,sprintf('/home/ajoshi/jessica_6_subs/SUBJECT%d_iso1.png',jj));
    view(-90,0);axis equal;camlight;material dull;caxis([0,1]);
    saveas(h,sprintf('/home/ajoshi/jessica_6_subs/SUBJECT%d_iso2.png',jj));

    
    h=figure;
    patch('faces',src.faces,'vertices',src.vertices,'facevertexcdata',abs(avg_th_ld_rc(:,1)-avg_th_ld_rc(:,3)),'facecolor','interp','edgecolor','none');
    view(90,30);axis equal;camlight;material dull;caxis([0,1]);axis off;
    saveas(h,sprintf('/home/ajoshi/jessica_6_subs/SUBJECT%d_ld1.png',jj));
    view(-90,0);axis equal;camlight;material dull;caxis([0,1]);
    saveas(h,sprintf('/home/ajoshi/jessica_6_subs/SUBJECT%d_ld2.png',jj));
    
end


