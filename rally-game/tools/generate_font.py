"""Generate our hand-drawn fixed-palette UI font, 256 MSB-first 8x8 glyphs."""
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
glyphs = json.loads((ROOT / 'assets/font.json').read_text())
pixels = bytearray(2048)
for ch, rows in glyphs.items():
    assert len(ch) == 1 and len(rows) == 7
    assert all(len(row) == 5 and set(row) <= {'0', '1'} for row in rows)
    pixels[ord(ch)*8:ord(ch)*8+7] = bytes(int(row, 2) << 2 for row in rows)
for ch in range(ord('a'), ord('z')+1):
    pixels[ch*8:ch*8+8] = pixels[(ch-32)*8:(ch-32)*8+8]
header = '// Generated from assets/font.json by tools/generate_font.py.\n'
header += '#pragma once\n#include <stdint.h>\nnamespace rally::game {\n'
header += 'constexpr uint8_t FontPixels[2048]={\n'
for start in range(0, len(pixels), 32):
    header += ','.join(str(x) for x in pixels[start:start+32])+',\n'
header += '};\n}\n'
(ROOT / 'include/font_data.hpp').write_text(header)
