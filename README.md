# CNN applied to Rootless Cones and TARs

This is the code to accompany the submitted paper: *Detection of Geological Landforms on Mars using Convolutional Neural Networks and Support Vector Machiness* by Palafox, Hamilton, Scheidt and Alvarez.

## Introduction
This codes acoompay the paper and was used to generate the maps presented in Figures 3, 4 and 5. This code is not intended to reproduce the figures, since the image dtaabase that was created is not included here.

## Data
The code uses JP2 files, both for HiRISE and CTX images, which can be directly downloaded from the CTX and HiRISE webpages.

##Data processing
As it stands, the code can process full images, but the GUI will allow the user to create a new subset in the large JP2 files. The subset will be stored in an independent folder defined in lines 16 and 18 of the file ParallelMainFileDeepNetCUDA.m

## Requirements
1. Matlab software, these experiments were done in version 2014, but it should work with later versions, support for previous versions was not tested and is not guaranteed to work.
2. For the GPU processing, the users need and NVIDIA video card that has Cuda processors. They also need to install the CUDA toolkit as well as a C++ compiler, for this experiments we used Visual Studio 2013.
3. To process the Convolutional Neural Networks, you need to download and install the library MatConvNet (http://www.vlfeat.org/matconvnet/). Installation isntructions and CUDA toolkit compatibility are explained in the Installation section.

## Landform detection
To create new labels for landform detection, the users can just change line 24 in ParallelMainFileDeepNetCUDA.m and add the landforms of interest

## Usage

Run ParallelMainFileDeepNetCUDA.m, which will ask if you wish to create a new image, for the first run this is necessary:

1. You will be able to create an inset of a previously downloaded HiRISE or CTX image.
2. Then, the program will ask the user to tag the landforms of interest.
3. The user can retag previous images by selecting them after they are created.

## Results

The results are stored in the folder specified in lines 16 and 18.

## Notes

As of now, the code is capable of running on both HiRISE and CTX images, I see no reason why the code should not be able to be used in other kinds of images, feel free to try and show your results.
