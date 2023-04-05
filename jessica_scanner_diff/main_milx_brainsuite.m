clc;clear all;close all;

l=dir('/big_disk/ajoshi/jessica_6_subs_final/milxcloud/*MNI.nii.gz');


if 0
for j=1:length(l)
    
    fprintf('%d: %s \n',j,l(j).name);
    
    subbasename = l(j).name(1:end-7);
    disp(subbasename);
    
    sub_dir=fullfile('/big_disk/ajoshi/jessica_6_subs_final/milxcloud/BrainSuite',subbasename);
    mkdir(sub_dir);
    copyfile(fullfile('/big_disk/ajoshi/jessica_6_subs_final/milxcloud/',l(j).name),sub_dir);
    
end
end


parfor j=1:length(l)

    subbasename = fullfile('/big_disk/ajoshi/jessica_6_subs_final/milxcloud/BrainSuite',l(j).name(1:end-7),l(j).name(1:end-7));

    if ~exist([subbasename,'svreg.inv.jacobian.nii.gz'],'file')
%    unix(['/home/ajoshi/BrainSuite19b/bin/cortical_extraction_4bfc.sh ',subbasename])
        unix(['/home/ajoshi/BrainSuite19b/svreg/bin/svreg.sh ',subbasename, ' -S']);
    end
    
end


%sub=readdfs('/big_disk/ajoshi/milx_cloud_results/milxcloud_results/BrainSuite/BCI_DNI_brain_deface_MNI.left.mid.cortex.svreg.dfs');
%sub.attributes=th;
%tar=readdfs('/big_disk/ajoshi/milx_cloud_results/milxcloud_results/BrainSuite/atlas.left.mid.cortex.svreg.dfs');
%tar.attributes=map_data_flatmap(sub,sub.attributes,tar);
%tar = colorDFS(tar, tar.attributes, [0 6], jet(256));
%writedfs(['BCI_milx.left.mid.cortex.dfs'], tar);





