function thickness_pvc_smooth(subbasename)

pth=fileparts(subbasename);

s=readdfs(fullfile(pth, 'atlas.pvc-thickness_0-6mm.left.mid.cortex.dfs'));
s.attributes=smooth_surf_function(s,s.attributes);
writedfs(fullfile(pth, 'atlas.pvc-thickness_0-6mm.smooth.left.mid.cortex.dfs'),s);

s=readdfs(fullfile(pth, 'atlas.pvc-thickness_0-6mm.right.mid.cortex.dfs'));
s.attributes=smooth_surf_function(s,s.attributes);
writedfs(fullfile(pth, 'atlas.pvc-thickness_0-6mm.smooth.right.mid.cortex.dfs'),s);



