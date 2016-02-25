from PIL import Image
import os
import re

from pytesseract import image_to_string

if os.getcwd() != 'C:\\Users\\j_caracotsios\\Desktop\\Work\\learning\\tutorials\\ocr-tutorials\\pytesseract-tutorial':
    os.chdir('C:\\Users\\j_caracotsios\\Desktop\\Work\\learning\\tutorials\\ocr-tutorials\\pytesseract-tutorial')

# Try out image_to_string on my business card (doesn't work very well)
print(image_to_string(Image.open('businesscard.JPG')))

# Try out image_to_string on some text (i works great!)
print(image_to_string(Image.open('test.png')))

# Try it out on a sample resume (doesn't work on the whole thing)
print(image_to_string(Image.open('resume.png')))

# Doesn't work on top corner
print(image_to_string(Image.open('resume_top_corner.png')))

# But it DOES work successfully on this very small area!
print(image_to_string(Image.open('resume_top_corner_small.png')))

# CROP, TRANSFORM, AND READ VIA PIL AND PYTESSERACT
resume = Image.open('resume.png')

# Resume is 1700 x 1200 pixels
print(resume.size)

resume_id = resume.crop((50, 160, 600, 335))

resume_id.save('cropped_resume.png')


text = image_to_string(resume_id)
text = re.sub(pattern='[\n]+', repl='_', string=text)
data = text.split(sep='_')
