clc;clear all;close all;
restoredefaultpath;

pp='/ImagePTE1/ajoshi/code_farm/svreg';
cmd_str=[pp,'/3rdParty',pathsep,pp,'/MEX_Files',pathsep,pp,'/src'];
addpath(cmd_str);


l=dir('/big_disk/ajoshi/jessica_6_subs_final/milxcloud/*MNI.nii.gz');

for j=1:length(l)
    
    sub_name = l(j).name(1:end-7);
        
    %% Process Left hemisphere
        
    %sub_name='co20050723_090747MPRAGET1Coronals003a001_1mm_MNI';
    
    v=load_nii_BIG_Lab(fullfile('/big_disk/ajoshi/jessica_6_subs_final/milxcloud/',[sub_name,'_Thickness.nii.gz']));
    
    
    subbasename=fullfile('/big_disk/ajoshi/jessica_6_subs_final/milxcloud/BrainSuite',sub_name,sub_name);
    
    pial=readdfs([subbasename,'.left.pial.cortex.dfs']);
    inner=readdfs([subbasename,'.left.inner.cortex.dfs']);
    midmid.faces=inner.faces;
    midmid.vertices=0.75*inner.vertices+0.25*pial.vertices;
    %writedfs([subbasename,'.left.midmid.cortex.dfs'],midmid);
    
    xres = v.hdr.dime.pixdim(2);
    yres = v.hdr.dime.pixdim(3);
    zres = v.hdr.dime.pixdim(4);
    SZ = size(v.img);
    
    ind = find(v.img > 0);
    
    % Generate indices of the voxels to be labeled
    [XX,YY,ZZ]=ind2sub(SZ,ind);XX=XX-1;YY=YY-1;ZZ=ZZ-1;
    
    Xc = XX*xres;
    Yc = YY*yres;
    Zc = ZZ*zres;
    
    th=griddata(Xc,Yc,Zc, double(v.img(ind)), midmid.vertices(:,1),midmid.vertices(:,2),midmid.vertices(:,3),'nearest');
    
    sub=readdfs([subbasename,'.left.mid.cortex.svreg.dfs']);
    sub.attributes=th;
    tar=readdfs(fullfile('/big_disk/ajoshi/jessica_6_subs_final/milxcloud/BrainSuite',sub_name,'atlas.left.mid.cortex.svreg.dfs'));
    tar.attributes=map_data_flatmap(sub,sub.attributes,tar);
    tar = colorDFS(tar, tar.attributes, [0 6], jet(256));
    writedfs([subbasename,'_atlas_milx.left.mid.cortex.dfs'], tar);
    
    
    
    %% Process right hemisphere
    pial=readdfs([subbasename,'.right.pial.cortex.dfs']);
    inner=readdfs([subbasename,'.right.inner.cortex.dfs']);
    midmid.faces=inner.faces;
    midmid.vertices=0.75*inner.vertices+0.25*pial.vertices;
    %writedfs([subbasename,'.right.midmid.cortex.dfs'],midmid);
    
    xres = v.hdr.dime.pixdim(2);
    yres = v.hdr.dime.pixdim(3);
    zres = v.hdr.dime.pixdim(4);
    SZ = size(v.img);
    
    ind = find(v.img > 0);
    
    % Generate indices of the voxels to be labeled
    [XX,YY,ZZ] = ind2sub(SZ,ind);XX=XX-1;YY=YY-1;ZZ=ZZ-1;
    
    Xc = XX*xres;
    Yc = YY*yres;
    Zc = ZZ*zres;
    
    th=griddata(Xc,Yc,Zc, double(v.img(ind)), midmid.vertices(:,1),midmid.vertices(:,2),midmid.vertices(:,3),'nearest');
    
    sub=readdfs([subbasename,'.right.mid.cortex.svreg.dfs']);
    sub.attributes=th;
    tar=readdfs(fullfile('/big_disk/ajoshi/jessica_6_subs_final/milxcloud/BrainSuite',sub_name,'atlas.right.mid.cortex.svreg.dfs'));
    tar.attributes=map_data_flatmap(sub,sub.attributes,tar);
    tar = colorDFS(tar, tar.attributes, [0 6], jet(256));
    writedfs([subbasename,'_atlas_milx.right.mid.cortex.dfs'], tar);
    disp(subbasename);
    
end

