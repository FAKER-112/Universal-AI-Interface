from PIL import Image, ImageDraw

size = 1024
# Monochrome: black background, white lines.
img = Image.new('RGB', (size, size), (0, 0, 0))
draw = ImageDraw.Draw(img)

c = size / 2
num_circles = 6
for i in range(1, num_circles + 1):
    # Radially spread circles
    radius = (c * 0.85 / num_circles) * i
    
    # As it gets further out, the layers get thinner.
    thickness = int(c * 0.15 * (num_circles - i + 1.5) / num_circles)
    if thickness < 4:
        thickness = 4
        
    draw.ellipse((c - radius, c - radius, c + radius, c + radius), outline=(255, 255, 255), width=thickness)

# Anti-alias by generating larger and downscaling
img.resize((512, 512), Image.Resampling.LANCZOS).save('assets/logo.png')
