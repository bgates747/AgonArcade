"""Run with Blender: blender -b --python rally/tools/build_car.py.
Original open-wheel model, flat palette materials, nine orthographic yaw views.
"""
from pathlib import Path
import math
import bpy
from mathutils import Vector
ROOT=Path(__file__).resolve().parents[1]
OUT=ROOT/'assets/car'
RAW=ROOT/'obj/car-raw'
OUT.mkdir(parents=True,exist_ok=True); RAW.mkdir(parents=True,exist_ok=True)
bpy.ops.object.select_all(action='SELECT'); bpy.ops.object.delete(use_global=False)
for block in list(bpy.data.materials): bpy.data.materials.remove(block)
# sRGB palette codes map exactly to the Agon RGB222 cube after export.
COLORS={'red':(255,0,0),'red_dark':(170,0,0),'orange':(255,85,0),
        'cream':(255,255,170),'white':(255,255,255),'yellow':(255,255,0),
        'rubber':(0,0,0),'tread':(85,85,85),'metal':(170,170,170),
        'dark_metal':(85,85,85),'helmet':(0,170,255),'visor':(0,0,85)}
def linear(v):
    v=v/255
    return v/12.92 if v<=.04045 else ((v+.055)/1.055)**2.4
materials={}
for name,rgb in COLORS.items():
    mat=bpy.data.materials.new(name)
    mat.diffuse_color=tuple(linear(c) for c in rgb)+(1,)
    materials[name]=mat
bpy.ops.object.empty_add(type='PLAIN_AXES',location=(0,0,0))
car=bpy.context.object; car.name='CAR_YAW_ROOT'
car['forward_axis']='+Y';car['sprite_anchor']='world origin, ground plane; fixed camera for all views'
def assign(obj,name,mat):
    obj.name=name; obj.data.materials.append(materials[mat]); obj.parent=car
    return obj
def box(name,loc,scale,mat):
    bpy.ops.mesh.primitive_cube_add(size=1,location=loc)
    obj=assign(bpy.context.object,name,mat);obj.scale=scale
    bpy.ops.object.transform_apply(location=False,rotation=False,scale=True)
    return obj
def hull(name,sections):
    # Each section: y, half-width, bottom-z, top-z. Explicit flat face colors.
    verts=[]
    for y,w,b,t in sections: verts.extend([(-w,y,b),(w,y,b),(w,y,t),(-w,y,t)])
    faces=[(3,2,1,0)]
    for i in range(len(sections)-1):
        for j in range(4): faces.append((i*4+j,i*4+(j+1)%4,(i+1)*4+(j+1)%4,(i+1)*4+j))
    n=4*(len(sections)-1);faces.append((n,n+1,n+2,n+3))
    mesh=bpy.data.meshes.new(name);mesh.from_pydata(verts,[],faces);mesh.update()
    obj=bpy.data.objects.new(name,mesh);bpy.context.collection.objects.link(obj);obj.parent=car
    for color in ('red_dark','red','orange'):mesh.materials.append(materials[color])
    for face in mesh.polygons: face.material_index=2 if face.normal.z>.5 else 1 if face.normal.x<0 else 0
    return obj
hull('Tapered monocoque',[(-1.5,.52,.22,.62),(-.65,.6,.22,.76),(.45,.43,.22,.68),(1.85,.18,.26,.36)])
for side in (-1,1):
    obj=box('Sidepod '+str(side),(side*.67,-.37,.43),(.38,1.55,.38),'red_dark' if side>0 else 'red')
    box('Sidepod highlight '+str(side),(side*.67,-.37,.627),(.34,1.45,.014),'orange')
box('Cockpit black opening',(0,-.2,.78),(.61,.83,.055),'rubber')
box('Seat back',(0,-.55,.88),(.48,.12,.25),'dark_metal')
# Helmet is faceted and deliberately oversized for sprite readability.
bpy.ops.mesh.primitive_uv_sphere_add(segments=8,ring_count=4,radius=.24,location=(0,-.25,1.0))
assign(bpy.context.object,'Driver helmet','helmet')
box('Helmet visor',(0,-.46,1.02),(.33,.055,.11),'visor')
box('Nose stripe',(0,1.15,.53),(.12,1.05,.025),'yellow').rotation_euler.x=math.radians(-12)
# Rear wing is high and unmistakable in the primary rear view.
for x in (-.36,.36):box('Rear wing support',(x,-1.37,.88),(.07,.15,.62),'dark_metal')
box('Rear aerofoil',(0,-1.52,1.23),(2.64,.43,.12),'cream')
box('Rear wing trailing face',(0,-1.746,1.23),(2.5,.025,.105),'red_dark')
for side in (-1,1):box('Rear wing endplate',(side*1.32,-1.52,1.23),(.065,.55,.34),'red')
box('Front aerofoil',(0,1.81,.31),(2.1,.46,.09),'cream')
for side in (-1,1):box('Front endplate',(side*1.05,1.81,.34),(.065,.5,.22),'red')
# Four faceted slick tires, oriented around the X axle.
for y,width,radius in [(-1.03,.58,.49),(1.18,.39,.40)]:
    for side in (-1,1):
        x=side*(1.03 if y<0 else .97)
        bpy.ops.mesh.primitive_cylinder_add(vertices=12,radius=radius,depth=width,
            end_fill_type='NGON',location=(x,y,radius),rotation=(0,math.pi/2,0))
        obj=assign(bpy.context.object,('Rear' if y<0 else 'Front')+' tire '+str(side),'rubber')
        obj.data.materials.append(materials['tread'])
        # Highlight selected top facets without lighting-generated extra colors.
        for face in obj.data.polygons:
            if len(face.vertices)==4 and face.normal.x<-.45: face.material_index=1
        bpy.ops.mesh.primitive_cylinder_add(vertices=8,radius=radius*.43,depth=.018,
            location=(x+side*(width/2+.012),y,radius),rotation=(0,math.pi/2,0))
        assign(bpy.context.object,'Wheel hub '+str(y)+' '+str(side),'metal')
        box('Suspension axle '+str(y)+' '+str(side),(side*.73,y,.36),(.5,.06,.07),'metal')
box('Rear gearbox',(0,-1.6,.36),(.35,.25,.24),'dark_metal')
for x in (-.22,.22):box('Exhaust outlet',(x,-1.64,.6),(.09,.14,.09),'metal')
scene=bpy.context.scene
scene.render.engine='BLENDER_WORKBENCH'
scene.display.shading.light='FLAT';scene.display.shading.color_type='MATERIAL'
scene.display.shading.show_shadows=False;scene.display.shading.show_cavity=False
scene.display.shading.show_specular_highlight=False;scene.display.shading.show_object_outline=False
scene.display.render_aa='OFF';scene.render.film_transparent=True
scene.view_settings.view_transform='Standard';scene.view_settings.look='None'
scene.view_settings.exposure=0;scene.view_settings.gamma=1
scene.render.image_settings.file_format='PNG';scene.render.image_settings.color_mode='RGBA'
scene.render.resolution_x=64;scene.render.resolution_y=48;scene.render.resolution_percentage=100
bpy.ops.object.camera_add(location=(0,-8,4.2))
camera=bpy.context.object;camera.name='SPRITE_CAMERA_LOCKED'
camera.rotation_euler=(Vector((0,0,.55))-camera.location).to_track_quat('-Z','Y').to_euler()
camera.data.type='ORTHO';camera.data.ortho_scale=4.6;scene.camera=camera
# Constant framing/ground anchor; yaw turns the model, never the camera.
scene['palette']='Agon RGB222; 0,85,170,255 per channel; binary-alpha export'
scene['notes']='Original open-wheel racer. +Y forward, +Z up. Yaw views -30..30 in 7.5 degree steps.'
car.rotation_euler.z=0
bpy.context.preferences.filepaths.save_version=0
bpy.ops.object.select_all(action='DESELECT')
car.select_set(True);bpy.context.view_layer.objects.active=car
for screen in bpy.data.screens:
    for area in screen.areas:
        if area.type=='VIEW_3D':
            area.spaces.active.shading.light='FLAT'
            area.spaces.active.shading.color_type='MATERIAL'
            area.spaces.active.region_3d.view_perspective='CAMERA'
bpy.ops.wm.save_as_mainfile(filepath=str(OUT/'rally-car.blend'))
for index in range(9):
    angle=-30+index*7.5;car.rotation_euler.z=math.radians(angle)
    scene.render.filepath=str(RAW/f'car-{index:02d}.png')
    bpy.ops.render.render(write_still=True)
print('Saved editable car and nine raw yaw views:',OUT)
