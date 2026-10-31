/* Host-only enumeration using the frozen actual projection/visibility code.
 * No firmware services, emulator or target allocation is executed. */
#include "checked.c"
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
typedef struct {int present,pos,other,lane,h,flags,x,y,source;} Witness;
static Witness traffic[126][5][2],signs_seen[8][126];
static unsigned char *image(const char *name){
    FILE *f=fopen(name,"rb");assert(f);fseek(f,0,SEEK_END);long n=ftell(f);rewind(f);
    unsigned char *p=malloc((size_t)n);assert(p&&fread(p,1,(size_t)n,f)==(size_t)n);fclose(f);return p;
}
static void at(Assets *a,const unsigned char *data,RallyRenderStateV1 *s,int pos,int track){
    s->player_station=pos;a->lap=(track?90:512)*6400;a->count=track?90:512;
    a->state=s;a->coeff=data+u32(data+40)+(pos/6400)*228;
    int local=pos%6400;a->fraction14=(local/100)*256+(local%100)*256/100;
    a->f=a->fraction14/4;a->ff=a->f*a->f/4096;
}
static void output(FILE *f,const char *track,const char *kind,int q,int v,int mirror,Witness *w){
    fprintf(f,"%s,%s,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d\n",track,kind,q,v,mirror,
        w->present,w->pos,w->other,w->lane,w->h,w->flags,w->x,w->y);
}
int main(int argc,char **argv){
    assert(argc==4);FILE *out=fopen(argv[3],"wb");assert(out);
    fprintf(out,"track,kind,q,view,mirror,present,player_station,opponent_station,lateral_units,heading,flags,x,y\n");
    for(int track=0;track<2;++track){
        unsigned char *data=image(argv[track+1]);Assets a={0};
        assert(u32(data+12)==asset_meta[track][0] && u32(data+8)==asset_meta[track][2]);
        assert(hash(data+32,u32(data+8)-32)==asset_meta[track][1]);
        RallyRenderStateV1 state={.struct_bytes=sizeof(state),.schema=1,.session=7};RallyRenderContextV1 ctx={0};
        RallyRenderResourcesV1 res={0,5,120,63970,63984,63930};
        a.state=&state;a.context=&ctx;a.resources=&res;
        for(int i=0;i<10;++i)a.t[i]=data+u32(data+40+i*16);
        memset(traffic,0,sizeof traffic);memset(signs_seen,0,sizeof signs_seen);
        const int lap=(track?90:512)*6400;
        /* Every legal integer camera station is checked for signs. Source
         * identity, real curve offsets, visibility and two-slot selection are
         * the actual renderer's, not a source_count*scale cross product. */
        uint8_t commands[2048];
        for(int pos=0;pos<lap;++pos){
            at(&a,data,&state,pos,track);Out o={commands,0,sizeof commands,0};unsigned ns=0;
            assert(state_ok(&state,lap,7));actors(&o,&a,&ns);assert(!o.error);
            for(unsigned i=0;i<ns;++i){
                Car *r=&ctx.signs[i];R28SpritePlan plan;
                if(!r28_sprite_plan(r,1,104,&plan))continue;
                int q=r->scale/2,b=r->bitmap-120;assert(q>=16&&q<=125&&b>=0&&b<8);
                if(!signs_seen[b][q].present)signs_seen[b][q]=(Witness){1,pos,0,0,0,0,r->x,r->y,b};
            }
        }
        /* Traffic: construct legal visible witnesses at representative camera
         * stations. Missing witnesses are retained in the safe envelope, never
         * declared impossible from sampling. All five views/both reflections
         * are reported independently for each reachable quotient. */
        int valid[126]={0},near_z[126]={0};
        for(int z=64;z<=1100;++z){int q=8000/z;valid[q]=1;if(!near_z[q])near_z[q]=z;}
        for(int pos=0;pos<lap;pos+=100){
            at(&a,data,&state,pos,track);int tx=tangent(&a,pos,4),ty=tangent(&a,pos,6);
            for(int q=7;q<=125;++q){
                if(!valid[q])continue;int missing=0;
                for(int v=0;v<5;++v)for(int m=0;m<2;++m)missing+=!traffic[q][v][m].present;
                if(!missing)continue;
                int other=(pos+near_z[q]*100)%lap;
                int cross=(tx*tangent(&a,other,6)-ty*tangent(&a,other,4))/4096;
                for(int lane=-55;lane<=55;lane+=1){
                    int c=cx(&a,96+q)+lane*q/50;
                    int base=heading(&a,cross)-bearing(&a,c);
                    for(int v=0;v<5;++v)for(int mirror=0;mirror<2;++mirror){
                        if(traffic[q][v][mirror].present)continue;
                        int low=v? v*1344-672:0,high=v==4?32767:(v+1)*1344-673;
                        int lo=mirror?(low>0?low:1):-high,hi=mirror?high:0-low;
                        if(lo<base-1920)lo=base-1920;if(hi>base+1920)hi=base+1920;
                        if(lo>hi)continue;int yaw=lo,h=yaw-base;
                        Car r={5+v,63970,2*q,mirror?-2*q:2*q,mirror?202*q:0,c-102*q/256,96+q-140*q/256};
                        R28SpritePlan plan;if(!r28_sprite_plan(&r,0,24,&plan))continue;
                        assert(view(yaw)==v && (yaw>0)==mirror && h>=-1920&&h<=1920);
                        /* Check the complete original actor planner accepts
                         * this constructed witness, not just our formula. */
                        state.flags=5;
                        state.opponents[0]=(RallyRenderOpponentV1){other,lane*256,h,1};
                        assert(state_ok(&state,lap,7));
                        Out check={commands,0,sizeof commands,0};unsigned ns=0;
                        assert(actors(&check,&a,&ns)==1 && !check.error);
                        assert(!memcmp(&r,&ctx.cars[0],sizeof(r)));
                        state.flags=0;state.opponents[0]=(RallyRenderOpponentV1){0,0,0,0};
                        traffic[q][v][mirror]=(Witness){1,pos,other,lane,h,5,r.x,r.y,5+v};
                    }
                }
            }
        }
        const char *name=track?"oval":"fuji";
        for(int q=7;q<=125;++q)if(valid[q])for(int v=0;v<5;++v)for(int m=0;m<2;++m)
            output(out,name,"traffic",q,v,m,&traffic[q][v][m]);
        for(int b=0;b<8;++b)for(int q=16;q<=125;++q)if(signs_seen[b][q].present)
            output(out,name,"sign",q,b,0,&signs_seen[b][q]);
        free(data);fprintf(stderr,"%s domain scan finished\n",name);fflush(stderr);
    }
    assert(fclose(out)==0);return 0;
}
