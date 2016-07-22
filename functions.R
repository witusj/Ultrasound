library(EBImage)

# function to read pairs of tiff files, extract pixel matrices and create array
# e.g. an_array[,,"mask", "1_3"] contains the pixel matrix of the 1_3_matrix.tif file
# uses the 'EBImage' and 'abind' packages
extractPix <- function(folder, image_name, extension) { 

  ## Concatenate filepath from input variables and read images  
  filepath <- paste0(folder, "/", image_name, ".", extension)
  filepath.m <- paste0(folder, "/", image_name, "_mask.", extension)
  Image <- readImage(filepath)
  Mask <- readImage(filepath.m)
  
  ## extract pixel matrices from both images and combine them in one array
  (image_array <- array(
    c(as.vector(Image@.Data), as.vector(Mask@.Data)),
    dim = c(580, 420, 2, 1),
    dimnames = list(
      NULL,
      NULL,
      c("image", "mask"),
      image_name
    )
  ))
  
 return(image_array)
}