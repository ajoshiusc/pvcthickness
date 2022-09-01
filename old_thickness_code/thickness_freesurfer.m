
function thickness_freesurfer(subbasename)

sin=readdfs([subbasename,'.inner.cortex.dfs']);
spial=readdfs([subbasename,'.pial.cortex.dfs']);

ind=dsearchn(spial.vertices,sin.vertices);
ind2=dsearchn(sin.vertices,spial.vertices(ind,:)) ;
d1=sqrt(sum((sin.vertices-spial.vertices(ind,:)).^2,2));
d2=sqrt(sum((sin.vertices(ind2,:)-spial.vertices(ind,:)).^2,2));
d=(d1+d2)/2;
sin.attributes=d;

ind=dsearchn(sin.vertices,spial.vertices);
ind2=dsearchn(spial.vertices,sin.vertices(ind,:)) ;
d1=sqrt(sum((spial.vertices-sin.vertices(ind,:)).^2,2));
d2=sqrt(sum((spial.vertices(ind2,:)-sin.vertices(ind,:)).^2,2));
d=(d1+d2)/2;
spial.attributes=d;

writedfs([subbasename,'.inner.fs.cortex.dfs'],sin);
writedfs([subbasename,'.pial.fs.cortex.dfs'],spial);

