// This script extends the FFT masking capability of DM to stacks
// After assigning masks on a given frame of the stack, run this script
// The script will apply the mask to all frames in the stack and generate the filtered IFFT
// Supports mask edge smoothing (Gaussian)
// Jingshan S. Du | jingshan.du@outlook.com
// Based on examples by D. R. G. Mitchell (dmscripting.com) and Gatan documentation


// Get the frontmost stack (FFT with one or more masks applied)

number xsize, ysize, zsize
image stackfft:=getfrontimage()
try
{
	get3dsize(stackfft, xsize, ysize, zsize)		
}
catch
{
	showalert("The front-most image is not a stack.",2)
	exit(0)
}
imagedisplay imgdisp=stackfft.imagegetimagedisplay(0)

// Ask for filter options
number filtersize
TagGroup DLG, DLGItems
DLG = DLGCreateDialog( "Apply Filter Options", DLGItems )

TagGroup val1tg
DLGitems.DLGAddElement( DLGCreateRealField( "Smooth Edge By (pixels):", val1tg, 5, 8, 3 ) )        

if ( !Alloc( UIframe ).Init( DLG ).Pose() ) // if cancelled, script ends
{
	exit(0)
}

filtersize =  val1tg.DLGGetValue()

// Create the mask image and display it

// A mask image is created 5=width of the edge smoothing
// 0=mask is transparent, 'hasmask' a variable which returns true if
// there is a mask present on the selected image, 0 if not.

// Note this command will work with any combination of the various mask types present

number hasmask
compleximage mask=createmaskfromannotations(imgdisp, filtersize,0, hasmask)

// If no masks are applied to the selected FFT then hasmask=0

if(hasmask==0)
{
	showalert("There are no masks applied to this FFT!",0)
	exit(0)
}

setname(mask, "Mask")

// Build the IFFT stack

image stackifft := realimage("Masked Stack", 4, xsize, ysize, zsize)

for (number z = 0; z < zsize; z++)
{
	image img := stackfft.slice2(0,0,z, 0,xsize,1, 1,ysize,1)
	// Multiply the FFT by the mask
	compleximage maskedfft=mask*img
	converttopackedcomplex(maskedfft)
	// Carry out the inverse FFT and display the filtered image
	stackifft.slice2(0,0,z, 0,xsize,1, 1,ysize,1) = packedifft(maskedfft)
}

stackifft.showimage()