function thicknessPVC_1D_simulation(n_trials, fwhm, alpha)
% n_trials - number of random trials
% fwhm - gaussian smoothing FWHM

res = 0.8; % voxel resolution in mm
N = 15;
WM_ind = 1:3;
CSF_ind = 15;
GM_ind = 6:11;

msk_known = false(N,1);
msk_known([WM_ind CSF_ind]) = true;
GM_thickness = 3; % in mm & must be < res*length(GM_ind);

[mask_knw, unmask_knw, mask_unknw, unmask_unknw] = createMaskOperators(msk_known);

for n = 1:n_trials
   heat_init = zeros(N,1);
   heat_init(WM_ind) = 1; % inner surface
   heat_init(CSF_ind) = 2; % pial surface
   
   GM_frac = zeros(N,1);
   temp = rand(size(GM_ind)) + 0.0001;
   temp = GM_thickness/res * (temp./sum(temp));
   GM_frac(GM_ind) = temp(:);
   
   [heat_map, thickness, grd_mag] = solve_aniso_heat_compute_thickness(N, GM_frac, res, heat_init, mask_knw, unmask_knw, unmask_unknw, alpha);
   [~,I] = min(abs(heat_map-1.5));
   
   w = gaussian1Dwindow(fwhm);
   GM_frac_smooth = conv(GM_frac, w(:), 'same');
   [heat_map_smooth, thickness_smooth, grd_mag] = solve_aniso_heat_compute_thickness(N, GM_frac_smooth, res, heat_init, mask_knw, unmask_knw, unmask_unknw, alpha);
   [~,I_sm] = min(abs(heat_map_smooth-1.5));
   
   h = figure('position', [  69         472        1789         501]);
   set(h,'DefaultAxesColorOrder',[0 1 0; 0 0 1])
   subplot(1,3,1); plot([GM_frac(:) GM_frac_smooth(:)], '*-', 'LineWidth',2); ylim([-0.01 1.2]); grid on; title('GM Frac.')
   subplot(1,3,2); plot([heat_map(:) heat_map_smooth(:)], '*-', 'LineWidth',2); ylim([0.95 2.05]); grid on; title('Temperature')
   subplot(1,3,3); plot([thickness(:) thickness_smooth(:)], '*-', 'LineWidth',2); ylim([0 GM_thickness+2]); grid on; title('Thickness');
   hold on; plot(I, thickness(I), 'ks', 'MarkerSize',10, 'LineWidth',2); plot(I_sm, thickness_smooth(I_sm), 'ks', 'MarkerSize',10, 'LineWidth',2);
   
end

end

function [heat_map, thickness, grd_mag] = solve_aniso_heat_compute_thickness(N, GM_frac, res, heat_init, mask_knw, unmask_knw, unmask_unknw, alpha)
tolFactor = 1e-10;
MaxPCGiter = 4500; % set more than 1200

heatWt = 1./GM_frac;
heatWt(~isfinite(heatWt)) = 1e6;

D = createAnisoD_1D_central(N, sqrt(heatWt), 1/res);
DF = createAnisoD_1D(N, sqrt(heatWt), 1/res);
D = [D; alpha*DF];

b = -1*D*unmask_knw*mask_knw*heat_init(:);
A = D*unmask_unknw; clear D

% sol with pcg
Atb = A'*b; clear b;
AtA = A'*A; clear A;
L = ichol(AtA); % preconditioner
tol = tolFactor/norm(Atb);
[x,fl,rr,it,rv] = pcg(AtA, Atb, tol, MaxPCGiter, L, L', 1.5*ones(size(AtA,2),1));
[fl, rr, it]
clear AtA Atb L

heat_map = unmask_knw*mask_knw*heat_init(:) + unmask_unknw*x;
heat_map = reshape(heat_map, size(heat_init));

% Compute thickness
gy = gradient(heat_map, res);
% gy = (circshift(heat_map(:), -1) - circshift(heat_map(:), 1))/(2*res);

grd_mag = abs(gy);
thickness = GM_frac./grd_mag;
thickness(~isfinite(thickness)) = 0;
end

function [D] = createAnisoD_1D(N, anisoWt, resWt)
 
% e1 = anisoWt(:); % Anand's method 
e1 = (anisoWt(:) + circshift(anisoWt(:), -1))/2; % Chitresh's method

e1(end) = 0; % no value at last point
e2 = circshift(e1, 1); % to get desired structure on D

D = spdiags([e1,-e2],[0,1],N,N);
D = D .* resWt;
end

function [D] = createAnisoD_1D_central(N, anisoWt, resWt)

e1 = circshift(anisoWt(:), -1)/2;
e2 = circshift(anisoWt(:), 1)/2; % to get desired structure on D

e1(end-1:end) = 0; % no value at end point
e2(1:2) = 0; % no value at end point

D = spdiags([e1,-e2],[-1,1],N,N);
D = D .* resWt;
end


function w = gaussian1Dwindow(res_ratio)
% res_ration is FWHM

sgm = res_ratio/sqrt(8*log(2));
siz = sgm*6;
x = -ceil(siz/2):ceil(siz/2);
w = exp(-(x.^2/(2*(sgm^2))));
w = w/sum(w(:));

end



