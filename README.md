# ATF3
Permits sorting of cells by phenotype (in this case, ATF3 expression).
Takes a folder of FISH_QUANT outline files and a folder of images as inputs.
Displays a maximum intensity z-stack of each image and prompts user to select the observed phenotype.
Two new folders are generated, one for ATF3 positive and another for ATF3 negative cells.
Each outline file from the input folder will be copied and split into two files, one containing the ATF3 positive cells (which goes into the ATF3 positive folder) and another that contains the ATF3 negative cells (which will go into the respective folder).
If an image contains none of ATF3 positive or negative cells, the respective empty outline file will not be generated.

# AutoDataSplit
Automatically splits channels from Hyperstack .czi images within a master folder and any subfolders.
Generates a z-stack .tif image for each channel.
NOTE: FIJI is not the best platform for this operation. There have been issues noted with garbage collection / memory leaks resulting from SciJava.
Please use a machine that can store the entire contents of an image at a time in memory (i.e. have memory larger than the size of your largest single image file).

# Auto-GFP
Automatically quantifies GFP fluorescence for all files in a folder.
Takes a FISH_QUANT outline file as input.
NOTE - you must use my fork of FISH_QUANT for this to work.
(it depends on the listing of the image save directory within the outline file).

# BatchCyto

Takes a folder of FISH_QUANT outline and a folder of  

# GFP_Helper
Assists in GFP quantification.
Takes a FISH_QUANT outline file as input.
Displays cell outlines and numerical orders of cells as overlays.





# CytoplasmicIntensityQuant
Takes a FISH_QUANT outline file containing cell and nuclear outlines as input. Requires that the image to be processed is currently open.
Quantifies (using the "Measure" tool) gray value statistics of the cytoplasmic space using complex ROIs.
Displays cell outlines and numerical orders of cells as overlays.

