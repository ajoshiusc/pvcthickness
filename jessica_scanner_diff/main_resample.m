clc;clear;close all;
clc;clear all;close all;restoredefaultpath;
pp='/ImagePTE1/ajoshi/code_farm/svreg';
cmd_str=[pp,'/3rdParty',pathsep,pp,'/MEX_Files',pathsep,pp,'/src'];
addpath(cmd_str);

jobid=0;
for jj=1:6
    ll1=dir(sprintf('/big_disk/ajoshi/jessica_6_subs_final/SUBJECT%d',jj));
    for kk=1:length(ll1)
        
        if ll1(kk).name(1)=='.'
            continue;
        end
        
        ll2=dir(sprintf('/big_disk/ajoshi/jessica_6_subs_final/SUBJECT%d/%s',jj,ll1(kk).name));
        for ii=1:length(ll2)
            if ll2(ii).name(1)=='.'
                continue;
            end
            ll3=dir(sprintf('/big_disk/ajoshi/jessica_6_subs_final/SUBJECT%d/%s/%s',jj,ll1(kk).name,ll2(ii).name));
            dcmname=sprintf('/big_disk/ajoshi/jessica_6_subs_final/SUBJECT%d/%s/%s/%s',jj,ll1(kk).name,ll2(ii).name,ll3(3).name);
            
            subdir=dir(sprintf('/big_disk/ajoshi/jessica_6_subs_final/SUBJECT%d/%s/%s/*.nii.gz',jj,ll1(kk).name,ll2(ii).name));
%             for ww=1:length(subdir)
%                 delete(sprintf('/big_disk/ajoshi/jessica_6_subs_final/SUBJECT%d/%s/%s/%s',jj,ll1(kk).name,ll2(ii).name,subdir(ww).name));
%             end
            ll3=dir(sprintf('/big_disk/ajoshi/jessica_6_subs_final/SUBJECT%d/%s/%s',jj,ll1(kk).name,ll2(ii).name));
            dcmname=sprintf('/big_disk/ajoshi/jessica_6_subs_final/SUBJECT%d/%s/%s/%s',jj,ll1(kk).name,ll2(ii).name,ll3(3).name);

            
            %%%unix(sprintf('/big_disk/ajoshi/mricron/dcm2nii %s',dcmname));
            subdir=dir(sprintf('/big_disk/ajoshi/jessica_6_subs_final/SUBJECT%d/%s/%s/c*.air',jj,ll1(kk).name,ll2(ii).name));
            
            for ww=1:min(1,length(subdir))
                subbasename=subdir(ww).name(1:end-4);
                subbasename=sprintf('/big_disk/ajoshi/jessica_6_subs_final/SUBJECT%d/%s/%s/%s',jj,ll1(kk).name,ll2(ii).name,subbasename);
                FileInfo = dir([subbasename,'.iso-thickness_0-6mm.right.mid.cortex.dfs']);%pvc-thickness_0-6mm
                [Y, M, D, H, MN, S] = datevec(FileInfo.datenum);
                
                if 1% D<15 || M<10
                    %svreg(subbasename,'-S -P');
                   %split_thickness_map(subbasename);
                    %thicknessPVC(subbasename);
                    %thicknessISO(subbasename);
                    svreg_resample([subbasename,'.nii.gz'],[subbasename,'_1mm.nii.gz']);
                    %%unix(['qsub -v SUB1=',subbasename,' /home/rcf-proj2/BrainSuite14c/bin/cortical_extraction_jessica6.sh &']);
                   % delete([subbasename,'.roiwise.stats.txt']);
                    %unix(['nohup /big_disk/ajoshi/scripts/svreg_matlab.sh ',subbasename,' &']);
                        jobid=jobid+1;
                    %jj
%                    subno
                end
            end
            
            
        end
        
    end
    
    
end

%exit
