// FFT for Stack
// This script generates the FFT complex images for each frame in a stack as a new stack
// Jingshan S. Du | jingshan.du@outlook.com
// Based on various codes and examples by D. R. G. Mitchell (dmscripting.com) and Gatan examples

// Check to make sure an image is shown
number nodocs
nodocs=countdocumentwindowsoftype(5)
if(nodocs==0)
{
	showalert("There are no images displayed!",0)
	exit(0)
}

// Get the foremost image and some data from it
number xsize, ysize, zsize
image stackimg:=getfrontimage()

try
{
	get3dsize(stackimg, xsize, ysize, zsize)		
}
catch
{
	showalert("The front-most image is not a stack.",2)
	exit(0)
}

// Create the FFT complex stack
image stackfft := compleximage("FFT Stack", 8, xsize, ysize, zsize)

// Carry out the forward FFT
for (number z = 0; z < zsize; z++)
{
	image img := stackimg.slice2(0,0,z, 0,xsize,1, 1,ysize,1)
	stackfft.slice2(0,0,z, 0,xsize,1, 1,ysize,1) = RealFFT(img)
}	
stackfft.showimage()