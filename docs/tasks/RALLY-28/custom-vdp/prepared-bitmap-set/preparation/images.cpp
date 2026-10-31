// Host-only exact sampler/reference, stock-generation model and error census.
#include "stock.hpp"
#include <algorithm>
#include <cassert>
#include <cmath>
#include <cstdint>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <map>
#include <set>
#include <string>
#include <vector>
using Bytes=std::vector<uint8_t>;
struct Mask {
    int x,y,w,h,dw,dh;Bytes distance;std::vector<std::pair<int,int>> opaque;
    Mask()=default;
    Mask(int l,int t,int width,int height,const Bytes&p):x(l-2),y(t-2),w(width),h(height),dw(width+4),dh(height+4),distance(dw*dh,3){
        for(int yy=0;yy<h;++yy)for(int xx=0;xx<w;++xx)if(p[yy*w+xx]>>6){
            distance[(yy+2)*dw+xx+2]=0;opaque.emplace_back(l+xx,t+yy);
        }
        for(int yy=1;yy<dh;++yy)for(int xx=0;xx<dw;++xx){
            int i=yy*dw+xx;distance[i]=std::min<int>(distance[i],distance[i-dw]+1);
            if(xx)distance[i]=std::min<int>(distance[i],std::min(distance[i-1],distance[i-dw-1])+1);
            if(xx+1<dw)distance[i]=std::min<int>(distance[i],distance[i-dw+1]+1);
        }
        for(int yy=dh-2;yy>=0;--yy)for(int xx=dw-1;xx>=0;--xx){
            int i=yy*dw+xx;distance[i]=std::min<int>(distance[i],distance[i+dw]+1);
            if(xx+1<dw)distance[i]=std::min<int>(distance[i],std::min(distance[i+1],distance[i+dw+1])+1);
            if(xx)distance[i]=std::min<int>(distance[i],distance[i+dw-1]+1);
        }
    }
    int at(int xx,int yy)const{xx-=x;yy-=y;return xx<0||yy<0||xx>=dw||yy>=dh?3:distance[yy*dw+xx];}
};
struct Image {int id,mirror,q,family,w,h,x,y;uint64_t offset;Bytes exact,stock;Mask em,sm;};
static int silhouette(const Mask&a,const Mask&b){
    int n=0;for(auto p:a.opaque)n=std::max(n,b.at(p.first,p.second));
    for(auto p:b.opaque)n=std::max(n,a.at(p.first,p.second));return n;
}
static int pixel(const Image&i,const Bytes&p,int x,int y){
    x-=i.x;y-=i.y;if(x<0||y<0||x>=i.w||y>=i.h)return 0;
    int v=p[y*i.w+x];return v>>6?v:0;
}
struct Error {int edge=0,mask=0;double rgba=0,iou=1;};
static Error compare(const Image&a,const Image&b,bool stock){
    Error e;e.edge=std::max({std::abs(a.x-b.x),std::abs(a.y-b.y),std::abs(a.x+a.w-b.x-b.w),std::abs(a.y+a.h-b.y-b.h)});
    if(e.edge>2){e.mask=3;e.rgba=1;e.iou=0;return e;}
    e.mask=silhouette(a.em,stock?b.sm:b.em);
    int united=0,intersect=0,different=0;
    for(int y=std::min(a.y,b.y);y<std::max(a.y+a.h,b.y+b.h);++y)
        for(int x=std::min(a.x,b.x);x<std::max(a.x+a.w,b.x+b.w);++x){
            int u=pixel(a,a.exact,x,y),v=pixel(b,stock?b.stock:b.exact,x,y);
            united+=(u||v);intersect+=(u&&v);different+=(u!=v);
        }
    e.rgba=united?double(different)/united:0;e.iou=united?double(intersect)/united:1;return e;
}
static std::vector<int> integers(const std::string&s){
    std::vector<int> r;size_t a=0;
    while(a<s.size()){size_t b=s.find(',',a);r.push_back(std::stoi(s.substr(a,b-a)));if(b==s.npos)break;a=b+1;}
    return r;
}
int main(int argc,char**argv){
    assert(argc==2);std::string root=argv[1];std::ifstream input(root+"/INPUT.tsv");assert(input);
    std::ofstream pixels(root+"/.work/exact-images.bin",std::ios::binary),generated(root+"/.work/stock-images.bin",std::ios::binary);
    std::ofstream records(root+"/IMAGES.csv"),pairs(root+"/ERROR-PAIRS.csv");
    records<<"source,mirror,q,family,width,height,anchor_x,anchor_y,offset,bytes,natural_bytes,stock_rgba_error,stock_mask_error\n";
    pairs<<"family,request_q,prepared_q,edge_error,exact_mask_error,stock_mask_error,exact_rgba_error,stock_rgba_error,exact_iou,stock_iou\n";
    std::vector<Image> images;images.reserve(8000);uint64_t offset=0;
    std::map<int,std::map<int,std::vector<int>>> families;
    int id,sw,sh,mirror,family;std::string path,domain;
    while(input>>id>>sw>>sh>>mirror>>family>>path>>domain){
        std::ifstream art(path,std::ios::binary);assert(art);Bytes src(sw*sh);art.read((char*)src.data(),src.size());assert(art.gcount()==(long)src.size());
        for(int q:integers(domain)){
            int scale=2*q,w=(mirror?101:sw)*scale/256,h=sh*scale/256;
            Image im;im.id=id;im.mirror=mirror;im.q=q;im.family=family;im.w=w;im.h=h;
            im.x=-(id<120?51:32)*scale/256;im.y=-(id<120?70:64)*scale/256;im.offset=offset;
            im.exact.resize(w*h);
            for(int y=0;y<h;++y)for(int x=0;x<w;++x){
                int sx=mirror?101-(x*256+scale-1)/scale:x*256/scale;
                assert(sx>=0&&sx<sw&&y*256/scale<sh);im.exact[y*w+x]=src[(y*256/scale)*sw+sx];
            }
            stock::Bitmap bitmap(sw,sh,src.data());
            auto matrix=stock::make_affine((mirror?-scale:scale)/256.0f,scale/256.0f,mirror?101*scale/256.0f:0);
            auto bounds=stock::natural_buffer_size(bitmap,matrix);
            assert(bounds.width==w+1&&bounds.height==h+1&&bounds.xOffset==0&&bounds.yOffset==0);
            // Explicit-size command40 crops the unused final row/column.
            im.stock=stock::transform_buffer(bitmap,matrix,w,h,0,0);
            im.em=Mask(im.x,im.y,w,h,im.exact);im.sm=Mask(im.x,im.y,w,h,im.stock);
            auto error=compare(im,im,true);
            pixels.write((char*)im.exact.data(),im.exact.size());generated.write((char*)im.stock.data(),im.stock.size());
            records<<id<<','<<mirror<<','<<q<<','<<family<<','<<w<<','<<h<<','<<-im.x<<','<<-im.y<<','<<offset<<','<<w*h<<','<<(w+1)*(h+1)<<','<<std::setprecision(12)<<error.rgba<<','<<error.mask<<'\n';
            offset+=im.exact.size();families[family][q].push_back((int)images.size());images.push_back(std::move(im));
        }
    }
    for(const auto& f:families){
        for(const auto& request:f.second)for(const auto& prepared:f.second){
            Error exact,stock;assert(request.second.size()==prepared.second.size());
            for(size_t i=0;i<request.second.size();++i){
                const auto&a=images[request.second[i]];const auto&b=images[prepared.second[i]];
                assert(a.id==b.id);auto e=compare(a,b,false),s=compare(a,b,true);
                exact.edge=std::max(exact.edge,e.edge);exact.mask=std::max(exact.mask,e.mask);
                exact.rgba=std::max(exact.rgba,e.rgba);exact.iou=std::min(exact.iou,e.iou);
                stock.edge=std::max(stock.edge,s.edge);stock.mask=std::max(stock.mask,s.mask);
                stock.rgba=std::max(stock.rgba,s.rgba);stock.iou=std::min(stock.iou,s.iou);
            }
            pairs<<f.first<<','<<request.first<<','<<prepared.first<<','<<exact.edge<<','<<exact.mask<<','<<stock.mask<<','<<std::setprecision(12)<<exact.rgba<<','<<stock.rgba<<','<<exact.iou<<','<<stock.iou<<'\n';
        }
        std::cerr<<"family "<<f.first<<" image/error census complete\n";
    }
    assert(pixels&&generated&&records&&pairs);std::cerr<<images.size()<<" images; "<<offset<<" pixel bytes (host analysis only)\n";
}
