### Merge raster files in to a single raster file

### require the raster package
install.packages("raster")
require(raster)

##define the directory where the raster files are stored
dir<-"D:/tc_2010" 

#vector with the raster files names
input.rasters <- list.files(dir,pattern=".tif$", full.names = T) 

r.list <- list() #create an empty list

## for looping to read all files as rasters and storage in the empty list created before
for(i in 1:length(input.rasters)){
  r.list[[i]] <- raster(input.rasters[i])
}
r.list ## just check if every raster file was corrected read

x <- do.call(merge, r.list) #merge all the rasters into one single raster file
writeRaster(x, "D:/tc_2010/tree_cover_2010.tif", overwrite=TRUE) #saving the mosaic 







