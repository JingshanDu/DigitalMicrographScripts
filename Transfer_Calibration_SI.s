// Script to transfer both spatial and spectral calibration values for SI images
// Jingshan S. Du, Northwestern University
// du {[@]} u.northwestern.edu
// Based on scripts and function references by Dave Mitchell
// Original description:

		// Script to transfer the spatial calibration

		// from one image to another, irrespective of binning differences between the two

		// Warnings are posted if the source and target images are of different sizes.

		 

		// version:20011001

		// adminnospam@dmscripting.com (remove the nospam to make this email address work)
		 

		// D. Mitchell, Oct 2001

		// version 1.0

 

image sourceimage, targetimage

number width, height

number zorigin, zscale

string units, zunits

 

 

// Set up calibration (source) and destination (target) images.

 

gettwoimageswithprompt(" Source (0),Target (1)","Select Source and Target Images", sourceimage, targetimage)

getsize (sourceimage, width, height)

units=getunitstring(sourceimage)

 

// Check to make sure that the source image is calibrated.

 

if(units=="")

{

OKdialog("Your Source image is not calibrated")

exit(0)

}

 

// Compare the target and source images, and if differently binned, appropriate scaling is applied.

 

number targetwidth, targetheight

getsize(targetimage, targetwidth, targetheight)

 

// Tests to see if the target and souce images are the same size in x and y directions.

// Posts a warning if not with options to continue or abort

 

If((width/targetwidth)!=1 || (height/targetheight)!=1)

{

if(!twobuttondialog("Warning: Images are different sizes."+"\n"+"Source Image = "+width+" x "+height+"\n"+"Target Image = "+targetwidth+" x "+targetheight, "Proceed", "Abort"))

{

exit(0)

}

}


// Copy the x and y calibration
											
imagecopycalibrationfrom(targetimage,sourceimage)


// Copy the spectral calibration


imagegetdimensioncalibration(sourceimage, 2, zorigin, zscale, zunits, 0)
imagesetdimensioncalibration(targetimage, 2, zorigin, zscale, zunits, 0) 


showimage(targetimage)

 

// Apply scale bar

 

ImageDisplay display = targetimage.ImageGetImageDisplay(0)

ApplyDataBar(display)
