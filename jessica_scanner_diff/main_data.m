%||AUM||
%opengl software;
clc;clear ;close all;



for jj=1:6
    ll1=dir(sprintf('/home/rcf-40/ajoshi/aaj/jessica_6_subs/SUBJECT%d',jj));
    for kk=1:length(ll1)
        
        if ll1(kk).name(1)=='.'
            continue;
        end
        
        ll2=dir(sprintf('/home/rcf-40/ajoshi/aaj/jessica_6_subs/SUBJECT%d/%s',jj,ll1(kk).name));
        for ii=1:length(ll2)
            if ll2(ii).name(1)=='.'
                continue;
            end
            ll3=dir(sprintf('/home/rcf-40/ajoshi/aaj/jessica_6_subs/SUBJECT%d/%s/%s',jj,ll1(kk).name,ll2(ii).name));
            dcmname=sprintf('/home/rcf-40/ajoshi/aaj/jessica_6_subs/SUBJECT%d/%s/%s/%s',jj,ll1(kk).name,ll2(ii).name,ll3(3).name);
            
            subdir=dir(sprintf('/home/rcf-40/ajoshi/aaj/jessica_6_subs/SUBJECT%d/%s/%s/*.nii.gz',jj,ll1(kk).name,ll2(ii).name));
            for ww=1:length(subdir)
                delete(sprintf('/home/rcf-40/ajoshi/aaj/jessica_6_subs/SUBJECT%d/%s/%s/%s',jj,ll1(kk).name,ll2(ii).name,subdir(ww).name));
            end
            ll3=dir(sprintf('/home/rcf-40/ajoshi/aaj/jessica_6_subs/SUBJECT%d/%s/%s',jj,ll1(kk).name,ll2(ii).name));
            dcmname=sprintf('/home/rcf-40/ajoshi/aaj/jessica_6_subs/SUBJECT%d/%s/%s/%s',jj,ll1(kk).name,ll2(ii).name,ll3(3).name);

            
            unix(sprintf('/home/rcf-40/ajoshi/aaj/mricron/dcm2nii %s',dcmname));
            subdir=dir(sprintf('/home/rcf-40/ajoshi/aaj/jessica_6_subs/SUBJECT%d/%s/%s/c*',jj,ll1(kk).name,ll2(ii).name));
            
            for ww=1:length(subdir)
                subbasename=subdir(ww).name;
                subbasename=sprintf('/home/rcf-40/ajoshi/aaj/jessica_6_subs/SUBJECT%d/%s/%s/%s',jj,ll1(kk).name,ll2(ii).name,subbasename);
               % if ~exist([subbasename,'.iso-thickness_0-6mm.right.mid.cortex.dfs'],'file')
                    unix(['qsub -v SUB1=',subbasename,' /home/rcf-proj2/aaj/BrainSuite14c/bin/cortical_extraction_jessica6.sh &']);
                    %%unix(['qsub -v SUB1=',subbasename,' /home/rcf-proj2/aaj/BrainSuite14c/bin/thicknesspvc.sh&']);
                    jj
%                    subno
              %  end
            end
            
            
        end
        
    end
    
    
end


