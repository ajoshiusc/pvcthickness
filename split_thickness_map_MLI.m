% SVReg: Surface-Constrained Volumetric Registration
% Copyright (C) 2019 The Regents of the University of California and the University of Southern California
% Created by Anand A. Joshi, Chitresh Bhushan, David W. Shattuck, Richard M. Leahy 
% 
% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; version 2.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301,
% USA.


function split_thickness_map_MLI(subbase)

inner=readdfsGz([subbase, '.inner.cortex.dfs']);
pial=readdfsGz([subbase, '.pial.cortex.dfs']);
th=readdfs([subbase, '.MLI-thickness_0-6mm.mid.cortex.dfs']);

inner_l=readdfsGz([subbase, '.left.inner.cortex.dfs']);
pial_l=readdfsGz([subbase, '.left.pial.cortex.dfs']);

inner_r=readdfsGz([subbase, '.right.inner.cortex.dfs']);
pial_r=readdfsGz([subbase, '.right.pial.cortex.dfs']);

[~,ia,ib]=intersect(inner.vertices,inner_l.vertices,'rows','stable');

mid_l=inner_l;
mid_l.vertices=(inner_l.vertices+pial_l.vertices)/2;
mid_l.vcolor=th.vcolor(ia,:);
mid_l.attributes=th.attributes(ia,:);

mid_l=smooth_cortex_fast(mid_l,.5,2000);
writedfs([subbase, '.MLI-thickness_0-6mm.left.mid.cortex.dfs'],mid_l);

[~,ia,ib]=intersect(inner.vertices,inner_r.vertices,'rows','stable');

mid_r=inner_r;
mid_r.vertices=(inner_r.vertices+pial_r.vertices)/2;
mid_r.vcolor=th.vcolor(ia,:);
mid_r.attributes=th.attributes(ia,:);
mid_r=smooth_cortex_fast(mid_r,.5,2000);
writedfs([subbase, '.MLI-thickness_0-6mm.right.mid.cortex.dfs'],mid_r);


