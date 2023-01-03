import cv2     # h, w, c
import numpy
import matplotlib.pyplot as plt

img = cv2.imread("sprite1.bmp" , 1)
fname = open("sprite1.bin",'w')

ylenth = img.shape[1]          # row
xlenth = img.shape[0]          # col

for i in range(xlenth):
    for j in range(ylenth):
        r = bin(img[i][j][0])
        print(r)
        fname.write(str(img[i][j][0])+str(img[i][j][1])+str(img[i][j][2])+'\n')
    # fname.write('\n')
fname.close()

