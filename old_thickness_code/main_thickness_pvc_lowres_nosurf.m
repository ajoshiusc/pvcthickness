clc;close all;clear all;
restoredefaultpath;
addpath(genpath('c:/Users/ajoshi/documents/git_sandbox/svreg-matlab/src'));
addpath(genpath('c:/Users/ajoshi/documents/git_sandbox/svreg-matlab/dev'));
%reslice_nii('C:\Users\ajoshi\Documents\git_sandbox\svreg-matlab\sample\data1\data1_input\data1_orig\brainsuite_subj1_m6.bfc.nii.gz', 'C:\Users\ajoshi\Documents\git_sandbox\svreg-matlab\sample\data1\data1_input\data1_orig\p5.nii.gz',[.5 .5 .5]);
vv=load_nii('C:\Users\ajoshi\Documents\git_sandbox\svreg-matlab\sample\data1\data1_input\data1_orig\brainsuite_subj1_m6.bfc.nii.gz');
vpvc=load_nii('C:\Users\ajoshi\Documents\git_sandbox\svreg-matlab\sample\data1\data1_input\data1_orig\brainsuite_subj1_m6.pvc.frac.nii.gz');

%v=load_nii('C:\Users\ajoshi\Documents\git_sandbox\svreg-matlab\sample\data1\data1_input\data1_orig\p5.bfc.nii.gz');
%view_nii(vv);
%vv=resample_avw(vv,[512,512,512]); 
vv.img=uint8(0*vv.img);
%vpvc=resample_avw(vpvc,[512,512,512]);

%view_nii(vv);

vo=vv; vo.img=0*vo.img;
% vo.img(vpvc.img>=3)=0;
% vo.img(vpvc.img<=1)=255;
vo.img(vpvc.img>1 & vpvc.img<3) = 128;

vo.img=imdilate(vo.img,[1,1,1;1,1,1;1,1,1]);
 
view_nii(vo);

% vfrac=load_nii('C:\Users\ajoshi\Documents\git_sandbox\svreg-matlab\sample\data1\data1_input\data1_orig\brainsuite_subj1_m6.pvc.frac.nii.gz');
% vfrac=resample_avw(vfrac,[512,512,512]);
% vv.img((vfrac.img>1) & (vfrac.img<3))=vv.img((vfrac.img>1) & (vfrac.img<3))+500;
% view_nii(vv);
mask_ind=find(vo.img>0);
pial_ind1=find(vpvc.img<=1);
inner_ind1=find(vpvc.img>=3);
[~,pial_ind11]=intersect(mask_ind,pial_ind1);
[~,inner_ind11]=intersect(mask_ind,inner_ind1);

vpvc=vpvc.img(mask_ind); speed=zeros(length(mask_ind),1);
speed(vpvc>1 & vpvc<=2)=vpvc(vpvc>1 & vpvc<=2)-1;
speed(vpvc>2 & vpvc<=3)=3-vpvc(vpvc>2 & vpvc<=3);
speed=1./(speed+1e-3);
[Lx,Ly,Lz]=getDvolLE(size(vo.img),mask_ind,vo.hdr.dime.pixdim(2:4));

Lx=spdiags(sqrt(speed),[0],size(Lx,1),size(Lx,1))*Lx;Ly=spdiags(sqrt(speed),[0],size(Lx,1),size(Lx,1))*Ly;Lz=spdiags(sqrt(speed),[0],size(Lx,1),size(Lx,1))*Lz;

bx=sum(Lx(:,pial_ind11),2);
by=sum(Ly(:,pial_ind11),2);
bz=sum(Lz(:,pial_ind11),2);


L=[Lx;Ly;Lz];
L(:,[pial_ind11;inner_ind11])=[];
b=[bx;by;bz];mask_ind1=mask_ind;
mask_ind1([pial_ind11;inner_ind11])=[];
vi.img=double(0*vi.img);
vi.img(mask_ind1)=mypcg(L'*L,-L'*b,1e-100,10000,1+diag(L'*L));
vi.img(pial_ind1)=1;
vi.img(inner_ind1)=0;
vi.img=abs(vi.img);
view_nii(vi);

clear L b bx by bz pial_ind1 inner_ind1 pial_ind11 inner_ind11

gr=(Lx*vi.img(mask_ind)).^2 + (Ly*vi.img(mask_ind)).^2 + (Lz*vi.img(mask_ind)).^2;
clear L Lx Ly Lz b bx by bz speed 
vo.img=double(vo.img);
vo.img(mask_ind)=sqrt(1./(gr+eps));
view_nii(vo);

sin=readdfs('C:\Users\ajoshi\Documents\git_sandbox\svreg-matlab\sample\data1\data1_input\data1_orig\brainsuite_subj1_m6.inner.cortex.dfs');
spial=readdfs('C:\Users\ajoshi\Documents\git_sandbox\svreg-matlab\sample\data1\data1_input\data1_orig\brainsuite_subj1_m6.pial.cortex.dfs');
smid=spial;
smid.vertices=(spial.vertices+sin.vertices)/2;
view_patch(smid);
res=vo.hdr.dime.pixdim(2:4);
th=interp3(vo.img,smid.vertices(:,2)/res(2)+1,smid.vertices(:,1)/res(1)+1,smid.vertices(:,3)/res(3)+1,'linear');

smid1=smooth_cortex_fast(smid,.1,3000);
figure;
patch('vertices',smid1.vertices,'faces',smid.faces,'facevertexcdata',th,'edgecolor','none','facecolor','interp');
axis equal;axis off;material dull;camlight;caxis([0,6]);

th1=sqrt(sum((sin.vertices-spial.vertices).^2,2));
figure;
patch('vertices',smid1.vertices,'faces',smid.faces,'facevertexcdata',th1,'edgecolor','none','facecolor','interp');
axis equal;axis off;material dull;camlight;caxis([0,6]);


vo1=load_nii('C:\Users\ajoshi\Documents\git_sandbox\svreg-matlab\sample\data1\data1_input\data1_orig\outer.nii.gz');
vi.img(vo1.img==0)=1;

smid1=isosurface(vi.img,.5);smid1.vertices=[smid1.vertices(:,2),smid1.vertices(:,1),smid1.vertices(:,3)];
smid1=reducepatch(smid1,200000);smid1=myclean_patch_cc(smid1);
smid1.vertices(:,1)=(smid1.vertices(:,1)-1)*res(1);smid1.vertices(:,2)=(smid1.vertices(:,2)-1)*res(2);smid1.vertices(:,3)=(smid1.vertices(:,3)-1)*res(3);
smid1o=smid1;
th=interp3(vo.img,smid1.vertices(:,2)/res(2)+1,smid1.vertices(:,1)/res(1)+1,smid1.vertices(:,3)/res(3)+1,'linear');
figure;
patch('vertices',smid1.vertices,'faces',smid1.faces,'facevertexcdata',th,'edgecolor','none','facecolor','interp');
axis equal;axis off;material dull;camlight;caxis([0,6]);

smid1=smooth_cortex_fast(smid1,.1,5000);
figure;
patch('vertices',smid1.vertices,'faces',smid1.faces,'facevertexcdata',th,'edgecolor','none','facecolor','interp');
axis equal;axis off;material dull;camlight;caxis([0,4]);

view_patch_economo(smid1,th);
thsm=smooth_surf_function(smid1,th,0,1.5);
view_patch_economo(smid1,thsm);

