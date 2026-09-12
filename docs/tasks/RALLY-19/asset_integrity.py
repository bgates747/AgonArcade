"""Generate compiled size/FNV-1a signatures from actual Golem output bytes."""
from pathlib import Path

def signature(data):
    value=2166136261
    for byte in data:value=((value^byte)*16777619)&0xffffffff
    return len(data),value

def generate(work):
    work=Path(work)
    rows=[]
    for track in ['oval','fuji']:
        parts=[]
        for ext in ['.vdp','.clr']:
            size,value=signature((work/(track+ext)).read_bytes())
            assert 0<size<=1024*1024
            parts.append('{UINT32_C(%d),UINT32_C(%d)}'%(size,value))
        rows.append('{'+','.join(parts)+'}')
    source='#pragma once\n#include "checked_asset.hpp"\nnamespace rally { namespace r19 {\ninline constexpr AssetSignature SceneAssets[2][2]={\n'+',\n'.join(rows)+'\n};\n}}\n'
    (work/'include/scene_assets.hpp').write_text(source)
