
function thickness_freesurfer(subbasename)

sin=readdfs([subbasename,'.inner.cortex.dfs']);
spial=readdfs([subbasename,'.pial.cortex.dfs']);
sin_ds = reducepatch(sin,100000);
spial_ds = reducepatch(spial,100000);


ind=dsearchn(spial_ds.vertices,sin.vertices);
ind2=dsearchn(sin_ds.vertices,spial.vertices(ind,:)) ;
d1=sqrt(sum((sin.vertices-spial_ds.vertices(ind,:)).^2,2));
d2=sqrt(sum((sin_ds.vertices(ind2,:)-spial.vertices(ind,:)).^2,2));
d=(d1+d2)/2;
sin.attributes=d;

ind=dsearchn(sin_ds.vertices,spial.vertices);
ind2=dsearchn(spial_ds.vertices,sin.vertices(ind,:)) ;
d1=sqrt(sum((spial.vertices-sin_ds.vertices(ind,:)).^2,2));
d2=sqrt(sum((spial_ds.vertices(ind2,:)-sin.vertices(ind,:)).^2,2));
d=(d1+d2)/2;
spial.attributes=d;

writedfs([subbasename,'.inner.fs.cortex.dfs'],sin);
writedfs([subbasename,'.pial.fs.cortex.dfs'],spial);

if exist([subbasename, '.left.inner.cortex.svreg.dfs'],'file')
    split_thickness_map_fs(subbasename);
end
