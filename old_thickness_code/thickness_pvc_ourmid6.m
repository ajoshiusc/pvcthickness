% clc;close all;clear all;
% restoredefaultpath;
% addpath(genpath('/home/biglab/Easswar/svreg-matlab/src'));
% addpath(genpath('/home/biglab/Easswar/svreg-matlab/dev'));
%reslice_nii('C:/Users/ajoshi/Documents/git_sandbox/svreg-matlab/sample/data1/data1_input/data1_orig/brainsuite_subj1_m6.bfc.nii.gz', 'C:/Users/ajoshi/Documents/git_sandbox/svreg-matlab/sample/data1/data1_input/data1_orig/p5.nii.gz',[.5 .5 .5]);


function thickness_pvc_ourmid6(subbasename,iso_heat)
if ~exist('iso_heat','var')
    iso_heat=0;
end
vv=load_nii([subbasename,'.bfc.nii.gz']);
vpvc=load_nii([subbasename,'.pvc.frac.nii.gz']);

%v=load_nii('C:/Users/ajoshi/Documents/git_sandbox/svreg-matlab/sample/data1/data1_input/data1_orig/p5.bfc.nii.gz');
%view_nii(vv);
%vv=resample_avw(vv,[512,512,512]);
vv.img=uint8(0*vv.img);
vpvc=resample_avw(vpvc,[512,512,512]);
%view_nii(vv);
sin=readdfs([subbasename,'.inner.cortex.dfs']);sin=refine_surf(sin);sin=refine_surf(sin);%sin.faces=[];
spial=readdfs([subbasename,'.pial.cortex.dfs']);spial=refine_surf(spial);spial=refine_surf(spial);%spial.faces=[];
res=vv.hdr.dime.pixdim(2:4);

for jj=1:41
    sur=((1-(jj-1)/40)*spial.vertices+((jj-1)/40)*sin.vertices);
    ind=sub2ind(size(vv.img),round(sur(:,1)/res(1))+1,round(sur(:,2)/res(2))+1,round(sur(:,3)/res(3))+1);
    vv.img(ind)=1;
    % if jj==1
    %     inner_ind=ind;
    % elseif jj==41
    %     pial_ind=ind;
    % end
end
clear sur;
vv.img=imdilate(vv.img,ones(3,3,3));%vv.img=imerode(vv.img,ones(3,3,3));
%vo.img(vi.img>0)=0;
%vv.img(inner_ind)=2;vv.img(pial_ind)=3;
vv=resample_avw(vv,[512,512,512],'nearest');
res=vv.hdr.dime.pixdim(2:4);

spial=refine_surf(spial);spial=refine_surf(spial);spial.faces=[];
pial_ind=sub2ind(size(vv.img),round(spial.vertices(:,1)/res(1))+1,round(spial.vertices(:,2)/res(2))+1,round(spial.vertices(:,3)/res(3))+1);
pial_ind=unique(pial_ind);clear spial;

sin=refine_surf(sin);sin=refine_surf(sin);sin.faces=[];
inner_ind=sub2ind(size(vv.img),round(sin.vertices(:,1)/res(1))+1,round(sin.vertices(:,2)/res(2))+1,round(sin.vertices(:,3)/res(3))+1);
inner_ind=unique(inner_ind);clear sin;

vv.img(inner_ind)=2;vv.img(pial_ind)=3;

% view_nii(vo);
% vfrac=load_nii('C:/Users/ajoshi/Documents/git_sandbox/svreg-matlab/sample/data1/data1_input/data1_orig/brainsuite_subj1_m6.pvc.frac.nii.gz');
% vfrac=resample_avw(vfrac,[512,512,512]);
% vv.img((vfrac.img>1) & (vfrac.img<3))=vv.img((vfrac.img>1) & (vfrac.img<3))+500;
% view_nii(vv);
mask_ind=find(vv.img>0);
sz=[512,512,512];
d_tot = createDWithPeriodicBoundary3D_pre(sz(1), sz(2), sz(3),res(1),res(2),res(3),mask_ind,'D1pre.mat','D2pre.mat','D3pre.mat');
pial_ind=find(vv.img==3);inner_ind=find(vv.img==2);
[~,pial_ind11]=intersect(mask_ind,pial_ind);
[~,inner_ind11]=intersect(mask_ind,inner_ind);

vpvc=vpvc.img(mask_ind); speed=zeros(length(mask_ind),1);
speed(vpvc>1 & vpvc<=2)=vpvc(vpvc>1 & vpvc<=2)-1;
speed(vpvc>2 & vpvc<=3)=3-vpvc(vpvc>2 & vpvc<=3);
speed=1./(speed+1e-6);

if iso_heat==1
    speed=ones(size(speed));
end
d_tot=spdiags([sqrt(speed);sqrt(speed);sqrt(speed)],[0],size(d_tot,1),size(d_tot,1))*d_tot;

% create heat flow maps
heat_label = 0*vv.img(mask_ind);  heat_label(pial_ind11)=1;
msk_k=0*heat_label;
msk_k(union(pial_ind11,inner_ind11))=1;%heat_label==50 | heat_label==100; % mask of known values
msk_uk = ~msk_k; % & heat_label>0;
heat_label(inner_ind11) = 0;
clear vpvc
%alpha = 1;%0;
%d=d([mask_ind;512^3+mask_ind;2*512^3+mask_ind],mask_ind);
%d = createDDWithDBoundary3D(sz(1), sz(2), sz(3));
%d_tot = alpha*d; % 2*speye(size(d,2))];
clear d;
mask_knw = speye(length(mask_ind));
unmask_knw = speye(length(mask_ind));
unmask_unknw = speye(length(mask_ind));

mask_knw(~msk_k, :) = [];
unmask_knw(:, ~msk_k) = [];
unmask_unknw(:, ~msk_uk) = [];
clear msk_k msk_uk
b = -1*d_tot*unmask_knw*mask_knw*double(heat_label(:));
A = d_tot*unmask_unknw;
%x = lsqr(A, b, 1e-60, 1000);
%x=mypcg(A'*A,A'*b,) 
clear ind inner_ind inner_ind11 pial_ind pial_ind11  
rndstr=num2str(round(100000*rand));
d_tot_fname=[subbasename,rndstr,'dtot.mat'];
save(d_tot_fname,'d_tot','mask_ind', 'heat_label','speed', 'vv','unmask_knw', 'unmask_unknw', 'mask_knw','-v7.3');
clear d_tot mask_ind speed unmask_knw unmask_unknw mask_knw heat_label vv
Atb=A'*b;clear b; AtA=A'*A;clear A;
x=mypcg(AtA,Atb,1e-10,300,diag(AtA)+1e-3);
clear AtA Atb
load(d_tot_fname);
heat_map = unmask_knw*mask_knw*double(heat_label(:)) + unmask_unknw*x;
vv.img=double(0*vv.img);
vv.img(mask_ind)=heat_map;vi=vv;
%heat_map = vo.img;%reshape(heat_map, sz);


%vi.img=abs(vi.img);
% view_nii(vi);
%vi.hdr.dime.datatype=64; vi.hdr.dime.bitpix=64;
%newbasename = '/home/biglab/Easswar/';

%save_nii(vi,[newbasename, newname,'.mid.cortex.pvc.thickness_newmid.heat.nii.gz']);

clear L b bx by bz pial_ind1 inner_ind1 pial_ind11 inner_ind11 unmask_unknw mask_knw
gg=d_tot*vv.img(mask_ind);clear d_tot;
gr=gg(1:length(mask_ind)).^2+gg(length(mask_ind)+(1:length(mask_ind))).^2+gg(2*length(mask_ind)+(1:length(mask_ind))).^2;
%gr=(Lx*vi.img(mask_ind)).^2 + (Ly*vi.img(mask_ind)).^2 + (Lz*vi.img(mask_ind)).^2;
clear gg L Lx Ly Lz b bx by bz
vv.img=double(vv.img);
vv.img(mask_ind)=(1./speed).*sqrt(1./(gr+eps));
% view_nii(vo);
vv.hdr.dime.datatype=64; vv.hdr.dime.bitpix=64;
%save_nii(vo,[newbasename, newname,'.mid.cortex.pvc.thickness_newmid.nii.gz']);
sin=readdfs([subbasename,'.inner.cortex.dfs']);
spial=readdfs([subbasename,'.pial.cortex.dfs']);
%sin=readdfs('/home/biglab/Easswar/svreg-matlab/dev/thickness/inner_cube.dfs');
%spial=readdfs('/home/biglab/Easswar/svreg-matlab/dev/thickness/pial_cube.dfs');
smid=spial;
smid.vertices=(spial.vertices+sin.vertices)/2;
%view_patch(smid);
res=vv.hdr.dime.pixdim(2:4);
th=interp3(vv.img,smid.vertices(:,2)/res(2)+1,smid.vertices(:,1)/res(1)+1,smid.vertices(:,3)/res(3)+1,'linear');
smid.attributes=th;
%writedfs([newbasename, newname,'.mid.cortex.pvc.thickness.dfs'],smid);
clear speed
sin=readdfs([subbasename,'.inner.cortex.dfs']);
spial=readdfs([subbasename,'.pial.cortex.dfs']);
smid=spial;
smid.vertices=(spial.vertices+sin.vertices)/2;
sur(1).vertices=spial.vertices;
sur(11).vertices=sin.vertices;
sur(2)=sur(1);sur(2).vertices=(.9*spial.vertices+.1*sin.vertices);
sur(3)=sur(1);sur(3).vertices=(.8*spial.vertices+.2*sin.vertices);
sur(4)=sur(1);sur(4).vertices=(.7*spial.vertices+.3*sin.vertices);
sur(5)=sur(1);sur(5).vertices=(.6*spial.vertices+.4*sin.vertices);
sur(6)=sur(1);sur(6).vertices=(.5*spial.vertices+.5*sin.vertices);
sur(7)=sur(1);sur(7).vertices=(.4*spial.vertices+.6*sin.vertices);
sur(8)=sur(1);sur(8).vertices=(.3*spial.vertices+.7*sin.vertices);
sur(9)=sur(1);sur(9).vertices=(.2*spial.vertices+.8*sin.vertices);
sur(10)=sur(1);sur(10).vertices=(.1*spial.vertices+.9*sin.vertices);

%save tmp2
v_temp = vv;
v_temp.img(mask_ind) = gr; clear mask_ind
res=vv.hdr.dime.pixdim(2:4);
gr_temp = zeros(11,size(sin.vertices,1),1);
for j = 2:10
    gr_temp(j,:) = interp3(vi.img,sur(j).vertices(:,2)/res(2)+1,sur(j).vertices(:,1)/res(1)+1,sur(j).vertices(:,3)/res(3)+1,'linear');
end
clear vi;
for i = 1:size(sin.vertices,1)
    [C I] = min(abs(gr_temp(2:10,i)-0.5));
    corr_vertices(i,:) = sur(I+1).vertices(i,:);
end

clear sur v_temp gr_temp;

th2 = interp3(vv.img,corr_vertices(:,2)/res(2)+1,corr_vertices(:,1)/res(1)+1,corr_vertices(:,3)/res(3)+1,'linear');
% view_patch_economo(smid,th2);
% title('New smid');
smid.attributes=th2;
smid.vertices=corr_vertices;

%writedfs([newbasename, newname,'.mid.cortex.pvc.thickness_newmid.dfs'],smid);
%view_patch_economo(smid,smid.attributes);
cm=hsv(1000);
smid.vcolor=cm(round(max(min((1000/6)*smid.attributes,1000),1)),:);
if iso_heat==1
    writedfs([subbasename,'.heateq.mid.cortex.dfs'],smid);
else
    writedfs([subbasename,'.heateq_pvc.mid.cortex.dfs'],smid);
end
% for i = 2:9
% temp1(i-1,:) = gr_temp(i,:)-gr_temp(i+1,:);
% end
% [temp2 temp3] = find(temp1<-0.2);
