from PIL import Image, ImageDraw
import math

size = 1024
bg = (20, 8, 18)
point = (255, 40, 70)
line = (200, 30, 60, 180)

img = Image.new('RGBA', (size, size), bg)
d = ImageDraw.Draw(img)

# generate some connected points for a network look
import random
random.seed(42)
points = []
for i in range(12):
    angle = random.random() * math.pi * 2
    r = size * (0.18 + random.random() * 0.32)
    x = int(size/2 + math.cos(angle) * r)
    y = int(size/2 + math.sin(angle) * r)
    points.append((x, y))

# draw soft glow for each point
for x,y in points:
    for rad,alpha in [(30,20),(18,40),(8,140)]:
        overlay = Image.new('RGBA', (size, size), (0,0,0,0))
        od = ImageDraw.Draw(overlay)
        od.ellipse((x-rad, y-rad, x+rad, y+rad), fill=(point[0], point[1], point[2], alpha))
        img = Image.alpha_composite(img, overlay)

# connect some lines
for i in range(len(points)):
    for j in range(i+1, len(points)):
        if random.random() < 0.28:
            overlay = Image.new('RGBA', (size, size), (0,0,0,0))
            od = ImageDraw.Draw(overlay)
            od.line((points[i], points[j]), fill=line, width=2)
            img = Image.alpha_composite(img, overlay)

# central subtle vignette
over = Image.new('RGBA', (size, size), (0,0,0,0))
od = ImageDraw.Draw(over)
for r in range(size//2, 0, -8):
    alpha = int(80 * (1 - r/(size/2)))
    od.ellipse((size/2-r, size/2-r, size/2+r, size/2+r), outline=(0,0,0,alpha))
img = Image.alpha_composite(img, over)

# resize to 512 and save as PNG
out = img.resize((512,512), Image.LANCZOS)
out.save('assets/icons/app_icon.png')
print('WROTE assets/icons/app_icon.png')
