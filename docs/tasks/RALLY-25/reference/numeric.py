"""Unbounded-integer arithmetic vectors and conservative input-domain bounds."""
import json,struct
from freeze import HERE,PIN,prepare,sha
from model import Cursor,quotient,remainder,sine

def main():
    source,data=prepare()
    divisions=[]
    for kind,values in [('sint32',[-2147483648,-32769,-12801,-7,-1,0,1,7,32768,2147483647]),
                        ('uint32',[0,1,65535,65536,3276800,4294967295])]:
        divisors=[-12800,-3,-1,0,1,3,12800] if kind=='sint32' else [0,1,3,65536,4294967295]
        for n in values:
            for d in divisors:
                error='division_by_zero' if d==0 else 'division_overflow' if n==-2147483648 and d==-1 else None
                row=dict(type=kind,numerator=n,denominator=d)
                if error:row.update(error=error,preserve_both_outputs=True)
                else:
                    q,r=quotient(n,d),remainder(n,d)
                    assert n==q*d+r and abs(r)<abs(d) and (r==0 or (r<0)==(n<0))
                    row.update(quotient=q,remainder=r)
                divisions.append(row)
    checks=[]
    for kind,low,high in [('sint32',-2147483648,2147483647),('uint32',0,4294967295)]:
        for op,a,b in [('add',high,1),('add',high-1,1),('sub',low,1),('sub',low+1,1),
                       ('mul',high,2),('mul',180,2*6028),('mul',3276800,68)]:
            value={'add':lambda:a+b,'sub':lambda:a-b,'mul':lambda:a*b}[op]()
            row=dict(type=kind,operation=op,left=a,right=b)
            row.update(result=value) if low<=value<=high else row.update(error='arithmetic_overflow',preserve_destination=True)
            checks.append(row)
    conversions=[]
    for kind,low,high in [('sint16',-32768,32767),('uint16',0,65535),('sint32',-2147483648,2147483647),('uint32',0,4294967295)]:
        for value in sorted({low-1,low,high,high+1,-38400,38400,3276800,4294967295}):
            row=dict(destination_type=kind,value=value)
            row.update(result=value) if low<=value<=high else row.update(error='conversion_range',preserve_destination=True)
            conversions.append(row)
    c=Cursor();routes=[]
    for tick in range(1,601):
        c.advance(data['records'],data['sine'])
        speed=data['records'][c.record][1];product=2*speed*sine(c.heading,data['sine'])
        routes.append(dict(tick=tick,heading=c.heading,product=product,divisor=12800,delta_q8=quotient(product,12800)))
    ranges={};lookup_vectors=[]
    for name,track in data['tracks'].items():
        asset='fuji.road' if name=='Fuji' else 'oval.road'
        raw=(source/'rally-production'/asset).read_bytes();coeff=list(struct.iter_unpack('<hhihh',raw[64:]))
        maxima=[max(abs(z[i]) for z in coeff) for i in range(5)]
        # These are independent coordinate/field bounds, not observed extrema.
        aa=maxima[0]*4+maxima[1];bb=sum(maxima[2:])
        points=track['points']
        coordinate_span=[max(p[i] for p in points)-min(p[i] for p in points) for i in range(2)]
        deltas=[max(abs(points[(k+1)%len(points)][i]-p[i]) for k,p in enumerate(points)) for i in range(4)]
        ranges[name]=dict(lap_hundredths=track['lap_hundredths'],finish_distance=track['lap_hundredths']*(2 if name=='Fuji' else 6),
            position_q8_max=quotient((track['lap_hundredths']-1)*256,100),
            adjacent_interpolation_product_abs=[v*16383 for v in deltas],
            coefficient_abs_max=maxima,lookup_line_a_abs_bound=aa,lookup_line_b_abs_bound=bb,
            lookup_center_q8_abs_bound=aa+bb*8,
            lookup_product_abs_bound=max(maxima[1]*4095,maxima[3]*4095,maxima[4]*4094,bb*128),
            direct_full_map_cross_abs_bound=sum(coordinate_span)*256*4096,
            sign_station_product_max=(track['lap_hundredths']//48000)*track['lap_hundredths'],
            coefficient_sha256=sha(raw))
        assert ranges[name]['lookup_product_abs_bound']<=2147483647
        assert max(ranges[name]['adjacent_interpolation_product_abs'])<=2147483647
        selected={0,len(coeff)-1}
        for i in range(5):
            selected.add(min(range(len(coeff)),key=lambda k:coeff[k][i]))
            selected.add(max(range(len(coeff)),key=lambda k:coeff[k][i]))
        for interval in sorted({index//19 for index in selected}):
            for local in [0,1,99,100,6399]:
                f14=(local//100)*256+(local%100)*256//100;f=f14//4;ff=f*f//4096
                for q in [7,8,118,128]:
                    index=interval*19+((f14+8000*256//q)>>14)
                    a,b,cc,d,e=coeff[index]
                    line_a=a*4+quotient(b*f,4096);line_b=cc+quotient(d*f,4096)+quotient(e*ff,4096)
                    lookup_vectors.append(dict(track=name,position=interval*6400+local,coefficient_index=index,coefficients=list(coeff[index]),local_hundredths=local,
                        fraction_q14=f14,fraction_q12=f,square_q12=ff,q=q,line_a=line_a,line_b=line_b,center_q8=line_a+quotient(line_b*q,16)))
    vectors=dict(schema=1,source_commit=PIN,division=divisions,checked_arithmetic=checks,checked_conversions=conversions,
                 signed_shift_examples=[dict(value=n,shift=s,arithmetic_shift=n>>s,truncating_division=quotient(n,1<<s)) for n in [-16385,-65,-64,-63,-1,0,1,63,64,65] for s in [6,14]],
                 route_products=routes,lookup=lookup_vectors)
    (HERE/'numeric-vectors.json').write_text(json.dumps(vectors,indent=2)+'\n')
    receipt=dict(schema=1,source_commit=PIN,classification='conservative bounds except explicitly enumerated route extrema',tracks=ranges,
        route_product_actual_min=min(v['product'] for v in routes),route_product_actual_max=max(v['product'] for v in routes),
        route_product_conservative_abs=180*2*32767,route_lateral_actual_min=min(row[4] for row in json.loads((HERE/'vectors.json').read_text())['route']),
        route_lateral_actual_max=max(row[4] for row in json.loads((HERE/'vectors.json').read_text())['route']),
        division_cases=len(divisions),arithmetic_cases=len(checks),conversion_cases=len(conversions),lookup_cases=len(lookup_vectors),
        vectors_sha256=sha((HERE/'numeric-vectors.json').read_bytes()),generator_sha256=sha((HERE/'numeric.py').read_bytes()),
        target_qualification=False,overflow_status_code='pending Golem agreement; semantic labels only')
    (HERE/'numeric-ranges.json').write_text(json.dumps(receipt,indent=2)+'\n')
    print(json.dumps(receipt,indent=2))
if __name__=='__main__':main()
