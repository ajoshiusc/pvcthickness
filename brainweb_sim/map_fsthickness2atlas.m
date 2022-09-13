function map_fsthickness2atlas(subbasename)        


        fsmidl=readdfs([subbasename,'.left.mid.cortex.fs.dfs']);
        smidl=readdfs([subbasename,'.left.mid.cortex.svreg.dfs']);
        %smidl.attributes = fsmidl.attributes;

        fsmidr=readdfs([subbasename,'.right.mid.cortex.fs.dfs']);        
        smidr=readdfs([subbasename,'.right.mid.cortex.svreg.dfs']);
        %smidr.attributes = fsmidr.attributes;


        %[qq,ind1,ind2]=intersect(fsmidl.vertices,smidl.vertices,'rows','stable');clear I;
        %smid.vertices(ind1(I),:) %same as left of S
        thicknessl=fsmidl.attributes;%(ind1);
        
        %[qq,ind1,ind2]=intersect(fsmidr.vertices,smidr.vertices,'rows','stable');clear I;
        %I(ind2)=1:length(ind2);
        %smid.vertices(ind1(I),:) %same as left of S
        thicknessr=fsmidr.attributes;%(ind1);
        pth1=fileparts(subbasename);
        smidltar=readdfs([pth1,'/atlas.left.mid.cortex.svreg.dfs']);
        smidrtar=readdfs([pth1,'/atlas.right.mid.cortex.svreg.dfs']);
        
        
        mapped_thickness_l=mygriddata(smidl.u',smidl.v',thicknessl,smidltar.u',smidltar.v');
        mapped_thickness_r=mygriddata(smidr.u',smidr.v',thicknessr,smidrtar.u',smidrtar.v');
        smidltar.attributes=mapped_thickness_l;        
        smidrtar.attributes=mapped_thickness_r;
        writedfs([pth1,'/atlas_fs_thickness.left.mid.cortex.svreg.dfs'],smidltar);
        writedfs([pth1,'/atlas_fs_thickness.right.mid.cortex.svreg.dfs'],smidrtar);
        
        

        