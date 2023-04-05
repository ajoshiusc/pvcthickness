%||AUM||
%opengl software;
clc;clear ;close all;



for jj=1:6
    ll1=dir(sprintf('/ifs/faculty/shattuck/ajoshi/thickness_paper/jessica_6_subs/SUBJECT%d',jj));
    for kk=1:length(ll1)
        
        if ll1(kk).name(1)=='.'
            continue;
        end
        
        ll2=dir(sprintf('/ifs/faculty/shattuck/ajoshi/thickness_paper/jessica_6_subs/SUBJECT%d/%s',jj,ll1(kk).name));
        for ii=1:length(ll2)
            if ll2(ii).name(1)=='.'
                continue;
            end
            ll3=dir(sprintf('/ifs/faculty/shattuck/ajoshi/thickness_paper/jessica_6_subs/SUBJECT%d/%s/%s',jj,ll1(kk).name,ll2(ii).name));
            dcmname=sprintf('/ifs/faculty/shattuck/ajoshi/thickness_paper/jessica_6_subs/SUBJECT%d/%s/%s/%s',jj,ll1(kk).name,ll2(ii).name,ll3(3).name);
            
            subdir=dir(sprintf('/ifs/faculty/shattuck/ajoshi/thickness_paper/jessica_6_subs/SUBJECT%d/%s/%s/*.nii.gz',jj,ll1(kk).name,ll2(ii).name));
%             for ww=1:length(subdir)
%                 delete(sprintf('/ifs/faculty/shattuck/ajoshi/thickness_paper/jessica_6_subs/SUBJECT%d/%s/%s/%s',jj,ll1(kk).name,ll2(ii).name,subdir(ww).name));
%             end
            ll3=dir(sprintf('/ifs/faculty/shattuck/ajoshi/thickness_paper/jessica_6_subs/SUBJECT%d/%s/%s',jj,ll1(kk).name,ll2(ii).name));
            dcmname=sprintf('/ifs/faculty/shattuck/ajoshi/thickness_paper/jessica_6_subs/SUBJECT%d/%s/%s/%s',jj,ll1(kk).name,ll2(ii).name,ll3(3).name);

            
            %%%unix(sprintf('/ifs/faculty/shattuck/ajoshi/thickness_paper/mricron/dcm2nii %s',dcmname));
            subdir=dir(sprintf('/ifs/faculty/shattuck/ajoshi/thickness_paper/jessica_6_subs/SUBJECT%d/%s/%s/c*.air',jj,ll1(kk).name,ll2(ii).name));
            
            for ww=1:length(subdir)
                subbasename=subdir(ww).name(1:end-4);
                subbasename=sprintf('/ifs/faculty/shattuck/ajoshi/thickness_paper/jessica_6_subs/SUBJECT%d/%s/%s/%s',jj,ll1(kk).name,ll2(ii).name,subbasename);
                if 1%~exist([subbasename,'.pvc-thickness_0-6mm.right.mid.cortex.dfs'],'file')
                    %%unix(['qsub -v SUB1=',subbasename,' /home/rcf-proj2/BrainSuite14c/bin/cortical_extraction_jessica6.sh &']);
                    unix(['qsub /ifs/faculty/shattuck/ajoshi/thickness_paper/scripts/n4_bst_svreg.sh ',subbasename,' &']);
                    jj
%                    subno
                end
            end
            
            
        end
        
    end
    
    
end


