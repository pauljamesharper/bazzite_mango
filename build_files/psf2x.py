#!/usr/bin/env python3
"""Pixel-double a PSF2 console font: psf2x.py in.psf[.gz] out.psf.gz"""
import gzip, struct, sys
src, dst = sys.argv[1:3]
data = (gzip.open if src.endswith('.gz') else open)(src, 'rb').read()
magic, ver, hsz, flags, n, csz, h, w = struct.unpack('<8I', data[:32])
assert magic == 0x864ab572, 'not PSF2'
row = (w + 7) // 8
glyphs = data[hsz:hsz + n * csz]
W, H = w * 2, h * 2
ROW = (W + 7) // 8
out = bytearray()
for g in range(n):
    gl = glyphs[g * csz:(g + 1) * csz]
    for y in range(h):
        bits = int.from_bytes(gl[y * row:(y + 1) * row], 'big') >> (row * 8 - w)
        wide = 0
        for x in range(w):
            if bits >> (w - 1 - x) & 1:
                wide |= 3 << (2 * (w - 1 - x))
        line = (wide << (ROW * 8 - W)).to_bytes(ROW, 'big')
        out += line + line
hdr = struct.pack('<8I', magic, 0, 32, flags, n, ROW * H, H, W)
with gzip.open(dst, 'wb') as f:
    f.write(hdr + out + data[hsz + n * csz:])
