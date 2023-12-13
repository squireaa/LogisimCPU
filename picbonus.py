from PIL import Image
import struct

input_path = "cs301/chewchan.jpg"

og = Image.open(input_path)
resized = og.resize((256,256))

pixel_data = list(resized.getdata())

rgb_values = []
for pixel in pixel_data:
    red, green, blue = pixel
    hex_value = "#{:02X}{:02X}{:02X}".format(red, green, blue)
    decimal_value = int(hex_value[1:], 16)
    rgb_values.append(decimal_value)

file_path = "cs301/output.bin"

with open(file_path, 'wb') as file:
    for integer in rgb_values:
        packed_data = struct.pack('i', integer)
        file.write(packed_data)
