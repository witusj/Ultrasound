# Inspired by:
# http://rpackages.ianhowson.com/bioc/EBImage/man/channel.html
# http://earlglynn.github.io/RNotes/package/EBImage/Intro-to-EBImage.html
# https://www.kaggle.com/chefele/ultrasound-nerve-segmentation/animated-images-with-outlined-nerve-area/code
# http://master.bioconductor.org/help/course-materials/2010/CSAMA10/100617-pau-brixen-ebimage-2.pdf

# Method 1 with 'tiff' package
library(tiff)

## read tiff file
filepath <- "train/1_1.tif"
img <- readTIFF(filepath, as.is=TRUE) ## returns a matrix (420 x 580) 

## plot image
collist<-gray(0:20 / 20)
rotate <- function(x) t(apply(x, 2, rev)) # correct for rotation by image function
image(rotate(img), col = collist, axes = FALSE, useRaster = TRUE)

# Method 2 with 'EBImage' package
library(EBImage)

## read tiff files
filepath <- "train/1_1.tif"
filepath.m <- "train/1_1_mask.tif"
Image <- readImage(filepath)
Mask <- readImage(filepath.m)

## View(Image@.Data)
## print(Image)
display(Image)

## Detect edges by first decucting adjecent columns, then adjecent rows and adding both matrices
## NOT NECESSARY!!
Mask1 <- Mask
Mask_mx <- Mask1@.Data

Zero_vec1 <- rep(0, length(Mask_mx[,1]))
Mask_mx1 <- cbind(Mask_mx, Zero_vec1)
Mask_mx1 <- sapply(2:length(Mask_mx1[1,]), function(x) Mask_mx1[,x]-Mask_mx1[,x-1])
Mask_mx1 <- (Mask_mx1 != 0)*1
Mask1 <- Mask
Mask1@.Data <- Mask_mx1

Zero_vec2 <- rep(0, length(Mask_mx[1,]))
Mask_mx2 <- rbind(Mask_mx, Zero_vec2)
Mask_mx2 <- sapply(2:length(Mask_mx2[,1]), function(x) Mask_mx2[x,]-Mask_mx2[x-1,])
Mask_mx2 <- (Mask_mx2 != 0)*1
Mask2 <- Mask
Mask2@.Data <- Mask_mx2

Mask_mx12 <- Mask_mx1+t(Mask_mx2)

Mask1@.Data <- Mask_mx12
display(Mask1)

## Add masked line to original image
Image_color <- toRGB(Image)
Image_color <- paintObjects(Mask, Image_color, col='red')
display(Image_color)

writeImage(Image, 'Image.jpeg', quality=95)
writeImage(Mask, 'Mask.jpeg', quality=95)
writeImage(Image_color, 'Image_color.jpeg', quality=95)
