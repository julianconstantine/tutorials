from PIL import ImageColor, Image

# Both of these return the RGBA coordinates for red: (255, 0, 0, 255)
ImageColor.getcolor(color='red', mode='RGBA')
ImageColor.getcolor(color='RED', mode='RGBA')

# Returns RGBA coordinates fro black: (0, 0, 0, 255)
ImageColor.getcolor(color='Black', mode='RGBA')

# Returns RGBA coordinates for chocolate: (210, 105, 30, 255)
ImageColor.getcolor(color='chocolate', mode='RGBA')

# Returns RGBA coordinate for cornflowerblue: (100, 149, 237, 255)
ImageColor.getcolor(color='CornflowerBlue', mode='RGBA')

# Load picture of Zophie the cat
catIm = Image.open('zophie.png')

# Get width x height of catIm: 816 x 1088 px
print(catIm.size)

# Get filename of catIm: zophie.png
print(catIm.filename)

# Get file format/description thereof
print(catIm.format, catIm.format_description)

# Save zophie.png as a JPEG file (Pillow does this automatically)
catIm.save('zophie.jpg')

# Create a new, solid purple image file that's 100 x 200 px
im = Image.new(mode='RGBA', size=(100, 200), color='purple')
im.save(fp='purpleImage.png')

# Use the .crop() method to crop an Image object according to some box tuple
croppedIm = catIm.crop((335, 345, 565, 560))
croppedIm.save('cropped.png')

# Make a copy of zophie.png using the .copy() method
catCopyIm = catIm.copy()

# Crop image so that we only see Zophie the cat's face
faceIm = catIm.crop((335, 345, 565, 560))

# faceIm is 230 x 215 px
print(faceIm.size)

# Now, use the .paste() method to paste faceIm on top of catCopyIm at the coordinates (0, 0) and (400, 500)
# NOTE: THe .paste() method modifies the Image object in place
catCopyIm.paste(faceIm, (0, 0))
catCopyIm.paste(faceIm, (400, 500))
catCopyIm.save('pasted.png')

catImWidth, catImHeight = catIm.size
faceImWidth, faceImHeight = faceIm.size
catCopyTwo = catIm.copy()

# This code will "tile" Zophie's head across the entire image
for left in range(0, catImWidth, faceImWidth):
    for top in range(0, catImHeight, faceImHeight):
        print(left, top)
        catCopyTwo.paste(faceIm, (left, top))

catCopyTwo.save('tiled.png')

# Shrink zophie.png down to 1/4 of its original size
width, height = catIm.size

quartersizedIm = catIm.resize((int(width/2), int(height/2)))
quartersizedIm.save('quartersize.png')

# Now stretch out the image so that it's longer
svelteIm = catIm.resize((width, height+300))
svelteIm.save('svelte.png')

# Rotate zophie.png by 90, 180, and 270 degres and save the rotated images as new files
catIm.rotate(90).save('rotated90.png')
catIm.rotate(180).save('rotated180.png')
catIm.rotate(270).save('rotated270.png')

# If you set "expand" to True, the image will enlarge to fit the size of the rotated image (and add a black
# background anywhere that is not already filled in)
catIm.rotate(6).save('rotated6.png')
catIm.rotate(6, expand=True).save('rotated6_expanded.png')

# To flip an image, use the .transpose() method
# NOTE: YOu must either pass Image.FLIP_LEFT_RIGHT (to flip horizontally) or Image.FLIP_TOP_BOTTOM (to flip vertically)
# to the .transpose() method
catIm.transpose(Image.FLIP_LEFT_RIGHT).save('horizontal_flip.png')
catIm.transpose(Image.FLIP_TOP_BOTTOM).save('vertical_flip.png')

# Can use the .getpixel() and .putpizel() methods to get and alter individual pixels in an image
im = Image.new(mode='RGBA', size=(100, 100))

# The pixel at (0, 0) is the default "transparent black" pixel
print(im.getpixel(xy=(0, 0)))

for x in range(100):
    for y in range(50):
        im.putpixel(xy=(x, y), value=(210, 210, 210))

for x in range(100):
    for y in range(50, 100):
        im.putpixel(xy=(x, y), value=ImageColor.getcolor(color='darkgray', mode='RGBA'))

# Now, the pixel in position (0, 0) is: (210, 210, 210, 255)
print(im.getpixel(xy=(0, 0)))

# And the pixel in position (0, 50) is: (169, 169, 169, 255)
print(im.getpixel((0, 50)))

# Now, save the image (which is just a box whose top half is light gray and bottom half is dark gray
im.save('putPixel.png')