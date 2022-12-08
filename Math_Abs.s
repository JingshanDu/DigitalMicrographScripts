// Math_Abs
// This script simply calculates the absolute value
// of each pixel and returns the image
// Jingshan S. Du | jingshan.du@outlook.com

image front:=getfrontimage()

image result = abs(front)

string imgname=getname(front)
setname(result, imgname + " (Abs)")

showimage(result)
documentwindow resultwin=getdocumentwindow(0)