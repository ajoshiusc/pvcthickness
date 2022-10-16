
clc;clear all;close all;

addpath(genpath('/ImagePTE1/ajoshi/code_farm/svreg/src'));


lh = readdfs('BCI_DNI_economo_left.dfs');
rh = readdfs('BCI_DNI_economo_right.dfs');

load('/big_disk/ajoshi/thickness_paper/fcon1000_avg_ld.mat');

thickness = zeros(43,1);

for labid=1:43
    ind=(lh.labels==labid+1);
    th_l=mean(mean(thicknessl(ind,:)));
    
    ind=(rh.labels==labid+1);
    th_r=mean(mean(thicknessr(ind,:)));
    
    thickness(labid) = (th_l+th_r)/2;

end
