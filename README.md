# DigitalMicrographScripts
Some useful scripts for DigitalMicrograph

## FFT_for_Stack.s
This script generates the FFT complex images for each frame in a stack as a new stack

## FFT_Masks_for_Stack.s
This script extends the FFT masking capability of DM to stacks. After assigning masks on a given frame of the stack, run this script.  
The script will apply the mask to all frames in the stack and generate the filtered IFFT. Supports mask edge smoothing (Gaussian)

## Histogram_from_ROI_Manual.s
It creates a histogram from the region of interest (ROI) of the front image with manually defined parameters, including lower and upper boundaries and number of binning channels.

## Math_Abs.s
Simply calculates the absolute value of each pixel and returns the image.

## Transfer_Calibration_SI.s
Transfer all calibration values, including x, y, and z (usually spectral axis), between Spectral Images (SI images).

## More Scripts...
I bet you already know this, but make sure to check out http://www.dmscripting.com/ by Dave Mitchell if you have not done so.
