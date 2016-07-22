#Simplify images by clustering pixels according to their distance to cluster means

##Get arrays of image and mask matrices for later comparison
source(textConnection(readLines("data.R")[c(1:16)]))
#source("data.R")

##Loop through vector of image names
for (i in scans[1:length(scans)]){

##and read in image data. 
image_idx <- i
Image_vec <- as.vector(arr[,,"image", image_idx])

##Choose number of clusters and run clustering function
k = 6
set.seed(1)
Image_kmc <- kmeans(Image_vec, centers = k, iter.max = 10000)

##Transform cluster vector into matrix
Image_clusters <- Image_kmc$cluster
dim(Image_clusters) <- c(nrow(arr[,,"image", image_idx]), ncol(arr[,,"image", image_idx]))

##Create clustered image
tiff(paste0(image_idx,"_rb.tif"), width = 580, height = 420)
image(Image_clusters, axes = FALSE, col = rainbow(k))
dev.off()
Image_rainbow <- readImage(paste0(image_idx,"_rb.tif"))

##Add masked line to clustered image and display
Image_rainbow <- toRGB(Image_rainbow)
Image_rainbow <- paintObjects(arr[,,"mask", image_idx], Image_rainbow, col='white')
display(Image_rainbow)

##Add masked line to original image and display
filepath <- paste0("train/", image_idx,".tif")
Image <- readImage(filepath)
Image_color <- toRGB(Image)
Image_color <- paintObjects(arr[,,"mask",image_idx], Image_color, col='red')
display(Image_color)
}