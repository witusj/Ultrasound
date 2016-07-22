source("functions.R")
library(abind)
library(rjson)
library(jsonlite)

## Method 1
## Create vector with names of image files without the extension.
scans <- list.files(path = "train", pattern = ".[0-9]+\\.tif")
scans <- gsub("\\.tif", "", scans)

## Use scans vector to loop through pairs of image and mask files
## to extract pixel data and combine them in one array.
ptm <- proc.time()
arr <- extractPix("train", "1_1", "tif")

for (i in scans[2:length(scans)]) {
  new_arr <- extractPix("train", i, "tif")
  arr <- abind(arr, new_arr)
  
}
proc.time() - ptm
#head(arr[,c(1:10),"mask","1_4"])

## Method 2
## Prepare an empty array
ptm <- proc.time()
image_array <- array(
  c(numeric(580*420), numeric(580*420)),
  dim = c(580, 420, 2, length(scans)),
  dimnames = list(
    NULL,
    NULL,
    c("image", "mask"),
    scans
  )
)

## Fill the prepared array with data. This works faster than binding new arrays (via 'abind' function). 
x = 1
for (i in scans[1:length(scans)]) {
filepath <- paste0("train/", i, ".tif")
filepath.m <- paste0("train/", i, "_mask.tif")
Image <- readImage(filepath)
Mask <- readImage(filepath.m)

image_array[,,"image", i] <- as.vector(Image@.Data)
image_array[,,"mask", i] <- as.vector(Mask@.Data)
}
proc.time() - ptm
#head(image_array[,,"image", "1_2"])


## Write the data as json to a text file
elements_list <- sapply(dimnames(image_array)[[4]], function(x) paste0(
                                                                       "{\"id\": \"", x, "\",\n",
                                                                       "\"image\" : [", paste0(as.vector(image_array[,,"image",x]), collapse = ", "), "],\n",
                                                                       "\"mask\" : [", paste0(as.vector(image_array[,,"mask",x]), collapse = ", "), "]\n",
                                                                       "},\n"
                                                                       )
                        )
fileConn<-file("output.txt")
writeLines(elements_list, fileConn)
close(fileConn)