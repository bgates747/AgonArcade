// Host scaffolding around unchanged functions extracted from pinned VDP/vdp-gl.
// This checks point order and raster coverage, not firmware timing or scheduling.
#include <algorithm>
#include <cassert>
#include <climits>
#include <cstdint>
#include <cstdio>
#include <set>
#include <utility>
#include <vector>
#define IRAM_ATTR
#define debug_log(...) ((void)0)
struct Point {
    int16_t X, Y;
    Point(int x=0,int y=0):X(x),Y(y){}
    bool operator==(const Point& p) const {return X==p.X && Y==p.Y;}
};
struct Rect {
    int X1,Y1,X2,Y2;
    Rect(int a=0,int b=0,int c=319,int d=239):X1(a),Y1(b),X2(c),Y2(d){}
    Rect merge(const Rect& r) const {return Rect(std::min(X1,r.X1),std::min(Y1,r.Y1),std::max(X2,r.X2),std::max(Y2,r.Y2));}
};
template<class T> T tmin(T a,T b){return std::min(a,b);}
template<class T> T tmax(T a,T b){return std::max(a,b);}
template<class T> void tswap(T& a,T& b){std::swap(a,b);}
struct RGB888 {};
struct Path {const Point* points;int pointsCount;bool freePoints;};
struct State {Rect absClippingRect;Point origin;};
struct BitmappedDisplayController {
    State state;
    std::set<std::pair<int,int>> pixels;
    struct Pool {void free(void*){assert(false);}} m_primDynMemPool;
    State& paintState(){return state;}
    void hideSprites(Rect&){}
    void fillRow(int y,int x1,int x2,const RGB888&){
        for(int x=x1;x<=x2;++x) pixels.emplace(x,y);
    }
    void fillPath(const Path&,const RGB888&,Rect&);
};
struct RecordingCanvas {
    std::vector<std::vector<Point>> paths;
    void fillPath(const Point* p,int n){paths.emplace_back(p,p+n);}
};
struct Context {
    Point p1,p2,p3,rp1;
    std::vector<Point> pathPoints;
    RecordingCanvas* canvas;
    uint8_t lastPlotCommand=221;
    void setGraphicsOptions(uint8_t){}
    void setGraphicsFill(uint8_t){}
    void pushPoint(Point);
    void plotTriangle();
    void plotParallelogram();
    void plotPath(uint8_t,uint8_t);
    void plotPending(int16_t);
};
#include "stock_functions.inc"

static auto raster(const std::vector<std::vector<Point>>& paths,Rect clip) {
    BitmappedDisplayController d;
    d.state.absClippingRect=clip;
    for(auto& p:paths){Rect update;d.fillPath({p.data(),int(p.size()),false},RGB888{},update);}
    return d.pixels;
}
int main(){
    unsigned cases=0;
    for(int yt:{0,103,104,200,223}) for(int h:{1,2,5,24})
    for(int shift:{-100,0,100}) for(int topWidth:{1,4,40})
    for(Rect clip:{Rect(),Rect(10,104,309,223)}) {
        int yb=yt+h;
        Point tl(160-topWidth,yt),tr(160+topWidth,yt);
        Point bl(160+shift-topWidth-h,yb),br(160+shift+topWidth+h,yb);
        RecordingCanvas triangles,quad;
        Context t{{},{},{},{},{},&triangles},q{{},{},{},{},{},&quad};
        t.pushPoint(tl);t.pushPoint(tr);t.pushPoint(bl);t.plotTriangle();
        t.pushPoint(br);t.plotTriangle();
        // Perimeter order differs from the triangle strip's TL,TR,BL,BR.
        q.pushPoint(tl);q.pushPoint(tr);q.pushPoint(br);q.plotPath(5,0);
        q.pushPoint(bl);q.plotPath(5,5);
        assert(quad.paths.empty()); // Pending until close/next non-PLOT command.
        q.plotPending(18); // Next GCOL, entirely inside the resident list.
        assert(q.pathPoints.empty() && quad.paths.size()==1);
        assert(quad.paths[0]==std::vector<Point>({tl,tr,br,bl}));
        assert(triangles.paths.size()==2);
        assert(raster(triangles.paths,clip)==raster(quad.paths,clip));
        // Explicit move closure and end-of-buffer also commit; another PLOT waits.
        for(int close:{-1,23,25}) {
            RecordingCanvas extra;Context c{{},{},{},{},{},&extra};
            c.pushPoint(tl);c.pushPoint(tr);c.pushPoint(br);c.plotPath(5,0);
            c.pushPoint(bl);c.plotPath(5,5);c.plotPending(close);
            assert(extra.paths.size()==(close==25?0u:1u));
            if(close==25){c.plotPath(0,5);assert(extra.paths.size()==1);}
        }
        // Three-point parallelogram cannot represent widening perspective bands.
        RecordingCanvas para;Context c{{},{},{},{},{},&para};
        c.pushPoint(tl);c.pushPoint(tr);c.pushPoint(br);c.plotParallelogram();
        assert(para.paths[0][3].X!=bl.X);
        ++cases;
    }
    std::printf("{\"raster_and_point_order_cases\":%u,\"triangles_per_shape\":2,\"quad_fills_per_shape\":1,\"coverage_equal_in_sampled_cases\":true}\n",cases);
}
