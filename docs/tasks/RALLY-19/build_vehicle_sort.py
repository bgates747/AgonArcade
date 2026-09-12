"""Append resident wrapped distances and the oracle's exact15-pair car ordering.

Python names fixed storage and finite calls only. Runtime arithmetic/comparisons
are compiled by the existing C++ Golem frontend and execute from admitted state.
"""
import argparse
from profile import TASK
from build_admitted_road import build as road

def build(track,root):
    source=road(track,root);s=source.read_text();lap=576000 if track=='oval' else 3276800
    s+=f'''
Buffer vehicleMath(1700,12);
Field vehicleWide(vehicleMath,0,s32,0,{2*lap-1});
Field vehicleLeft(vehicleMath,4,s32,0,{lap-1}); Field vehicleRight(vehicleMath,8,s32,0,{lap-1});
Buffer vehicleWorking(1701,16);
Field vehiclePosition(vehicleWorking,0,s32,0,{lap-1});
Field vehicleDistance(vehicleWorking,4,s32,0,{lap-1});
Field vehicleLapQuotient(vehicleWorking,8,u16,0,1); Field vehicleLess(vehicleWorking,10,u16,0,1);
Field vehicleZero(vehicleWorking,12,u16,0,0); Field vehicleOne(vehicleWorking,14,u16,1,1);
Set(vehicleOne,1);
Buffer vehicleOrder(1702,72); Buffer vehicleSwap(1703,12);
Matrix vehicleCar(1800,1,1); Matrix vehiclePlayer(1801,1,1);
Matrix vehicleDifference(1802,1,1); Matrix vehicleLap(1803,1,1); Matrix vehicleWrappedInput(1804,1,1);
MatValues(vehicleLap,{lap});
Program vehicleComputeDistance(2800) {{
    MatLoad(vehicleCar,vehiclePosition); MatLoad(vehiclePlayer,activeposition);
    MatSub(vehicleDifference,vehicleCar,vehiclePlayer);
    MatAdd(vehicleWrappedInput,vehicleDifference,vehicleLap);
    StorePositive32Floor(vehicleWide,vehicleWrappedInput);
    DivModPositive(vehicleLapQuotient,vehicleDistance,vehicleWide,{lap});
}};
Program vehicleCompare(2801) {{ LessThan(vehicleLess,vehicleLeft,vehicleRight); }};
'''
    fields=[('position',0,'s32',0,lap-1,4),('distance',4,'s32',0,lap-1,4),
            ('lane',8,'s16',-90,90,2),('id',10,'u16',0,5,2)]
    for i in range(7):
        name='vehicleTemp' if i==6 else 'vehicle'+str(i)
        owner='vehicleSwap' if i==6 else 'vehicleOrder';base=0 if i==6 else i*12
        for field,offset,type_,lo,hi,_ in fields:s+=f'Field {name}{field}({owner},{base+offset},{type_},{lo},{hi});\n'
    pairs=[(i,j) for i in range(5) for j in range(i+1,6)]
    for k,(i,j) in enumerate(pairs):
        s+=f'Program vehicleSwap{i}{j}({2810+k}) {{\n'
        for to,from_ in [('vehicleTemp','vehicle'+str(i)),('vehicle'+str(i),'vehicle'+str(j)),('vehicle'+str(j),'vehicleTemp')]:
            for field,_,_,_,_,width in fields:s+=f'    Copy({to}{field},{from_}{field},{width});\n'
        s+='};\n'
    s+='Program vehicleSort(2802) {\n'
    for i in range(6):
        s+=f'''    Copy(vehiclePosition,activecar{i}Position,4); Call(vehicleComputeDistance);
    Copy(vehicle{i}position,activecar{i}Position,4); Copy(vehicle{i}distance,vehicleDistance,4);
    Copy(vehicle{i}lane,activecar{i}Lane,2); Set(vehicle{i}id,{i});
'''
    for i,j in pairs:
        s+=f'''    Copy(vehicleLeft,vehicle{i}distance,4); Copy(vehicleRight,vehicle{j}distance,4);
    Call(vehicleCompare); CallIf(vehicleSwap{i}{j},vehicleLess,eq,vehicleOne);
'''
    s+='};\n'
    anchor='    Call(road_fullRoad);';assert s.count(anchor)==1
    s=s.replace(anchor,anchor+'\n    Call(vehicleSort);')
    target=root/(track+'-vehicle-sort.golem');target.write_text(s);return target

if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('track',choices=['oval','fuji']);a=p.parse_args()
    print(build(a.track,TASK/'.work/vehicle-sort-source'))
