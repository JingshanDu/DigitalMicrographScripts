// Create a histogram from ROI with manually defined parameters
// Jingshan S. Du
// jingshan.du@outlook.com

image imgFront := GetFrontImage()[]
string strImgName = GetName(imgFront)
number numMin, numMax, numChannels

// Dialog for parameter inputs
TagGroup DLG, DLGItems
DLG = DLGCreateDialog( "Create histogram from ROI - Manual Setup", DLGItems )
TagGroup val1tg, val2tg, val3tg, val4tg

DLGitems.DLGAddElement( DLGCreateLabel( "Please enter real numbers:" ) ) 
DLGitems.DLGAddElement( DLGCreateRealField( "Min:", val1tg, -1.02, 8, 8 ) )        
DLGitems.DLGAddElement( DLGCreateRealField( "Max:", val2tg, 1.02, 8, 8 ) )   
DLGitems.DLGAddElement( DLGCreateLabel( "Please enter an integer:" ) )      
DLGitems.DLGAddElement( DLGCreateIntegerField( "# of Channels:", val3tg, 51, 8) )        
DLGitems.DLGAddElement( DLGCreateLabel( "Note: x values in the results represent lower boundaries of binned channels." ) ) 
if ( !Alloc( UIframe ).Init( DLG ).Pose() )
 Throw( "User abort." )

numMin = val1tg.DLGGetValue()
numMax = val2tg.DLGGetValue()
numChannels = val3tg.DLGGetValue()

// Create the histogram
image imgHist = IntegerImage("Histogram of " + strImgName, 4, 0, numChannels)
ImageCalculateHistogram(imgFront, imgHist, numMin, numMax) 
ImageSetDimensionOrigin(imgHist, 0, numMin)
ImageSetDimensionScale(imgHist, 0, (numMax-numMin)/numChannels)

showimage(imgHist)