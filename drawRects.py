from PIL import Image, ImageDraw, ImageFont
import random
from sys import argv
# get an image

def getopts(argv):
    opts = {}  # Empty dictionary to store key-value pairs.
    while argv:  # While there are arguments left to parse...
        if argv[0][0] == '-':  # Found a "-name value" pair.
            opts[argv[0]] = argv[1]  # Add key and value to the dictionary.
        argv = argv[1:]  # Reduce the argument list by copying it starting from index 1.
    return opts




appleColors = [(255,158,153), (255,213,153), (255,235,153), (152,217,163),
               (150,218,250), (140,196,255), (151,150,214), (255,153,172)]
               
def drawRects(dims, filename):
    rects = getRects(dims)
    base = Image.new('RGB', (210,131), color=(255,255,255))
    draw = ImageDraw.Draw(base)
    colorsUsed = set()
    rects = getRects(dims)
    for rect in rects:
        x, y, w, h = rect[0], rect[1], rect[2], rect[3]
        rgb = random.choice(appleColors)
        while rgb in colorsUsed:
            rgb = random.choice(appleColors)
        colorsUsed.add(rgb)
        draw.rectangle([x,y,x+w,y+h], fill=rgb, outline = "white")
    base.save(filename + ".png")


def getRects(dims):
    dims = dims.split(",")
    dims = list(map(int, dims))
    organizedDims = []
    for i in range(0, len(dims), 4):
        rect = dims[i:i+4]
        for i in range(len(rect)):
            rect[i] = rect[i] / 8
        organizedDims.append(rect)
    return organizedDims


myargs = getopts(argv)
drawRects(myargs['-c'], myargs['-f'])