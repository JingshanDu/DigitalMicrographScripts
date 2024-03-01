// Gaussian filter for an image stack
// Modified to handle image stacks
// Jingshan S. Du | jingshan.du@outlook.com
// Original script description:

	// Script function to carry out Gaussian blurring.
	// D. R. G. Mitchell, October. 2016
	// adminnospam@dmscripting.com (remove the nospam to make this email address work)
	// version:20161230, v1.1
	// www.dmscripting.com

	// Function to apply a gaussian kernel (blurring) to an image

	// This is based heavily on Andrey Chuvilin's Filter-GaussHat script.

	// Function to convolve an image with a Guassian kernel. The image may be of any dimension
	// ie it is not necessary for it to be a power of 2. 

	// Sourceimg is the image to be filtered; standard deviation is that of the Gaussian
	// kernel: 1=minimal blurring, 3=mild blurring, 10=severe blurring.

image GaussianConvolution(image sourceimg, number standarddev)
	{
	
		// Trap for zero (or negative) standard deviations
		
		if(standarddev<=0) return sourceimg
	
	
		// get the size of the source image. If it is not a power of 2 in dimension
		// warp it so that it is.

		number xsize, ysize, div2size, expandx, expandy, logsize
		getsize(sourceimg, xsize, ysize)
		expandx=xsize
		expandy=ysize


		// Check the x axis for power of 2 dimension - if it is not, round up to the next size
		// eg if it is 257 pixels round it up to 512.

		logsize=log2(xsize)
		if(mod(logsize,1)!=0) logsize=logsize-mod(logsize,1)+1
		expandx=2**logsize


		// Check the y axis for power of 2 dimension - if it is not, round up to the next size
		// eg if it is 257 pixels round it up to 512.

		logsize=log2(ysize)
		if(mod(logsize,1)!=0) logsize=logsize-mod(logsize,1)+1
		expandy=2**logsize


		// Use the Warp function to stretch the image to fit into the revised dimensions

		image warpimg=realimage("",4,expandx, expandy)
		warpimg=warp(sourceimg, icol*xsize/expandx, irow*ysize/expandy)


		// Create the gaussian kernel using the same dimensions as the expanded image

		image kernelimg:=realimage("",4,expandx,expandy)
		number xmidpoint=xsize/2
		number ymidpoint=ysize/2
		kernelimg=1/(2*pi()*standarddev**2)*exp(-1*(((icol-xmidpoint)**2+(irow-ymidpoint)**2)/(2*standarddev**2)))


		// Carry out the convolution in Fourier space

		compleximage fftkernelimg:=realFFT(kernelimg)
		compleximage FFTSource:=realfft(warpimg)
		compleximage FFTProduct:=FFTSource*fftkernelimg.modulus().sqrt()
		realimage invFFT:=realIFFT(FFTProduct)


		// Warp the convoluted image back to the original size

		image filter=realimage("",4,xsize, ysize)
		filter=warp(invFFT,icol/xsize*expandx,irow/ysize*expandy)
		return filter
	}


// Main program to calculate and display a gaussian blurred image

// Check an image is displayed

number nodocs=countdocumentwindowsoftype(5)
if(nodocs<1)
	{
		showalert("Please ensure an image is displayed.",2)
		exit(0)
	}


// Source the image

number xsize, ysize, zsize, standarddev
image front:=getfrontimage()
try
{
	get3dsize(front, xsize, ysize, zsize)		
}
catch
{
	showalert("The front-most image is not a stack.",2)
	exit(0)
}
string imgname=getname(front)

// Create an empty stack for the processed images
image gaussblur := realimage("Gauss", 4, xsize, ysize, zsize)


// Prompt for the Standard Deviation of the blur to be used and call the above function

if(!getnumber("Select the standard deviation of the Gaussian Kernel:",3,standarddev)) exit(0)

for (number z = 0; z < zsize; z++)
{
	image img := front.slice2(0,0,z, 0,xsize,1, 1,ysize,1)
	gaussblur.slice2(0,0,z, 0,xsize,1, 1,ysize,1) = GaussianConvolution(img, standarddev)
}	

// Display the image and copy across the calibrations and tag groups

showimage(gaussblur)
setname(gaussblur, imgname+" - Gaussian Blur - sigma ("+standarddev+")")
imagecopycalibrationfrom(gaussblur, front)

taggroup fronttags=front.imagegettaggroup()
taggroup gausstags=gaussblur.imagegettaggroup()
taggroupcopytagsfrom(gausstags, fronttags)