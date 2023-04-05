%||AUM||
%opengl software;
clc;clear ;close all;

addpath(genpath('/ifshome/ajoshi/AnandJoshi/git_sandbox/svreg-matlab/src'));
jobid=0;
for jj=1
    ll1=dir(sprintf('/ifs/faculty/shattuck/ajoshi/thickness_paper/jessica_6_subs_final/SUBJECT%d',jj));
    for kk=3:5%1:length(ll1)
        
        if ll1(kk).name(1)=='.'
            continue;
        end
        
        ll2=dir(sprintf('/ifs/faculty/shattuck/ajoshi/thickness_paper/jessica_6_subs_final/SUBJECT%d/%s',jj,ll1(kk).name));
        for ii=1:length(ll2)
            if ll2(ii).name(1)=='.'
                continue;
            end
            ll3=dir(sprintf('/ifs/faculty/shattuck/ajoshi/thickness_paper/jessica_6_subs_final/SUBJECT%d/%s/%s',jj,ll1(kk).name,ll2(ii).name));
            dcmname=sprintf('/ifs/faculty/shattuck/ajoshi/thickness_paper/jessica_6_subs_final/SUBJECT%d/%s/%s/%s',jj,ll1(kk).name,ll2(ii).name,ll3(3).name);
            
            subdir=dir(sprintf('/ifs/faculty/shattuck/ajoshi/thickness_paper/jessica_6_subs_final/SUBJECT%d/%s/%s/*.nii.gz',jj,ll1(kk).name,ll2(ii).name));
%             for ww=1:length(subdir)
%                 delete(sprintf('/ifs/faculty/shattuck/ajoshi/thickness_paper/jessica_6_subs_final/SUBJECT%d/%s/%s/%s',jj,ll1(kk).name,ll2(ii).name,subdir(ww).name));
%             end
            ll3=dir(sprintf('/ifs/faculty/shattuck/ajoshi/thickness_paper/jessica_6_subs_final/SUBJECT%d/%s/%s',jj,ll1(kk).name,ll2(ii).name));
            dcmname=sprintf('/ifs/faculty/shattuck/ajoshi/thickness_paper/jessica_6_subs_final/SUBJECT%d/%s/%s/%s',jj,ll1(kk).name,ll2(ii).name,ll3(3).name);

            
            %%%unix(sprintf('/ifs/faculty/shattuck/ajoshi/thickness_paper/mricron/dcm2nii %s',dcmname));
            subdir=dir(sprintf('/ifs/faculty/shattuck/ajoshi/thickness_paper/jessica_6_subs_final/SUBJECT%d/%s/%s/c*.air',jj,ll1(kk).name,ll2(ii).name));
            
            for ww=1:min(1,length(subdir))
                subbasename=subdir(ww).name(1:end-4);
                subbasename=sprintf('/ifs/faculty/shattuck/ajoshi/thickness_paper/jessica_6_subs_final/SUBJECT%d/%s/%s/%s',jj,ll1(kk).name,ll2(ii).name,subbasename);
                FileInfo = dir([subbasename,'.iso-thickness_0-6mm.right.mid.cortex.dfs']);%pvc-thickness_0-6mm
                [Y, M, D, H, MN, S] = datevec(FileInfo.datenum);D
                M
                if 1% D<15 || M<10
                    %svreg(subbasename,'-S -P');
                   %split_thickness_map(subbasename);
                    %thicknessPVC(subbasename);
                    thicknessISO(subbasename);
                    %%unix(['qsub -v SUB1=',subbasename,' /home/rcf-proj2/BrainSuite14c/bin/cortical_extraction_jessica6.sh &']);
                   % delete([subbasename,'.roiwise.stats.txt']);
                    %unix(['nohup /ifs/faculty/shattuck/ajoshi/thickness_paper/scripts/svreg_matlab.sh ',subbasename,' &']);
                        jobid=jobid+1;
                    jj
%                    subno
                end
            end
            
            
        end
        
    end
    
    
end
jobid

%exit
