// Minimal host services around unchanged extracted stock functions. See the
// source manifest for boundaries; this is not an ESP32 framebuffer simulator.
#include "stock.hpp"
#include <algorithm>
#include <climits>
#include <cmath>
#include <cstdlib>
#include <functional>
#include <stdexcept>

#define IRAM_ATTR
#define debug_log(...) ((void)0)
#define VGA_SYNC_MASK 0xc0
#define VGA_PIXELINROW(row,X) (row[(X)^2])

#if defined(__GNUC__)
#pragma GCC diagnostic ignored "-Wunused-parameter"
#pragma GCC diagnostic ignored "-Wswitch"
#pragma GCC diagnostic ignored "-Wunused-but-set-variable"
#endif

using esp_err_t=int;
constexpr esp_err_t ESP_OK=0;
extern "C" {
#include "dsp_ansi.inc"
}
#define dspm_mult_3x3x1_f32(A,B,C) dspm_mult_f32_ansi(A,B,C,3,3,1)

namespace stock {
namespace fabgl=::stock;

int imin(int a,int b){return std::min(a,b);}
int imax(int a,int b){return std::max(a,b);}
template<typename T>T tmin(T a,T b){return std::min(a,b);}
template<typename T>T tmax(T a,T b){return std::max(a,b);}

enum class PaintMode:uint8_t {Set=0,OR=1,AND=2,XOR=3,Invert=4,NOT=4,NoOp=5,ANDNOT=6,ORNOT=7};
struct PaintOptions {bool swapFGBG=false;PaintMode mode=PaintMode::Set;};
struct Point {int X=0,Y=0;};
struct State {Point origin{};Rect absClippingRect{};PaintOptions paintOptions{};RGB888 penColor{};};
struct BitmapDrawingInfo {
    int16_t X,Y;const Bitmap* bitmap;
    BitmapDrawingInfo(int x,int y,const Bitmap* b):X(x),Y(y),bitmap(b){}
};
struct BitmapTransformedDrawingInfo {
    int16_t X,Y;const Bitmap* bitmap;const float* transformMatrix;const float* transformInverse;bool freeMatrix;
    BitmapTransformedDrawingInfo(int x,int y,const Bitmap* b,const float* f,const float* i)
        :X(x),Y(y),bitmap(b),transformMatrix(f),transformInverse(i),freeMatrix(false){}
};

class BitmappedDisplayController {
public:
    int width_,height_,stride_;
    std::vector<uint8_t> data_;
    std::vector<uint8_t*> m_viewPort;
    State state_;
    struct Pool {void free(void* p){std::free(p);}}m_primDynMemPool;
    explicit BitmappedDisplayController(int width,int height)
        :width_(width),height_(height),stride_((width+3)&~3),
         data_(size_t(stride_)*height,0xc0),m_viewPort(height){
        if(width<=0||height<=0||width>32767||height>32767)throw std::invalid_argument("Surface bounds");
        for(int y=0;y<height;++y)m_viewPort[y]=data_.data()+size_t(y)*stride_;
        state_.absClippingRect=Rect(0,0,width-1,height-1);
    }
    virtual ~BitmappedDisplayController()=default;
    State& paintState(){return state_;}
    int getViewPortWidth()const{return width_;}
    int getViewPortHeight()const{return height_;}
    void hideSprites(Rect&){} // This standalone bitmap fixture contains no sprites.
    void drawBitmap(const BitmapDrawingInfo&,Rect&);
    void absDrawBitmap(int,int,const Bitmap*,void*,bool);
    void drawBitmapWithTransform(const BitmapTransformedDrawingInfo&,Rect&);
    virtual void rawDrawBitmap_RGBA2222(int,int,const Bitmap*,void*,int,int,int,int)=0;
    virtual void rawDrawBitmapWithMatrix_RGBA2222(int,int,Rect&,const Bitmap*,const float*)=0;
    virtual void rawDrawBitmap_Native(int,int,const Bitmap*,int,int,int,int){throw std::logic_error("RGBA2222 only");}
    virtual void rawDrawBitmap_Mask(int,int,const Bitmap*,void*,int,int,int,int){throw std::logic_error("RGBA2222 only");}
    virtual void rawDrawBitmap_RGBA8888(int,int,const Bitmap*,void*,int,int,int,int){throw std::logic_error("RGBA2222 only");}
    virtual void rawDrawBitmapWithMatrix_Mask(int,int,Rect&,const Bitmap*,const float*){throw std::logic_error("RGBA2222 only");}
    virtual void rawDrawBitmapWithMatrix_RGBA8888(int,int,Rect&,const Bitmap*,const float*){throw std::logic_error("RGBA2222 only");}
#include "pixel_templates.inc"
};

class VGA64Controller:public BitmappedDisplayController {
public:
    using BitmappedDisplayController::BitmappedDisplayController;
    uint8_t m_HVSync=0xc0;
    uint8_t preparePixel(const RGB888& c){return m_HVSync|(c.R>>6)|((c.G>>6)<<2)|((c.B>>6)<<4);}
    std::function<void(uint8_t*,int,uint8_t)> setRowPixelLambda(PaintMode);
    void rawDrawBitmap_RGBA2222(int,int,const Bitmap*,void*,int,int,int,int) override;
    void rawDrawBitmapWithMatrix_RGBA2222(int,int,Rect&,const Bitmap*,const float*) override;
};

#include "display_methods.inc"
#include "vga_methods.inc"

struct StockSurface::Impl:VGA64Controller {using VGA64Controller::VGA64Controller;};
StockSurface::StockSurface(int width,int height):impl_(new Impl(width,height)){}
StockSurface::~StockSurface()=default;
StockSurface::StockSurface(StockSurface&&)noexcept=default;
StockSurface& StockSurface::operator=(StockSurface&&)noexcept=default;
void StockSurface::clear(uint8_t value){std::fill(impl_->data_.begin(),impl_->data_.end(),value);}
void StockSurface::draw_affine(const Bitmap& bitmap,const Affine& matrix,Rect clip,int x,int y){
    if(bitmap.format!=PixelFormat::RGBA2222)throw std::invalid_argument("Fixture expects RGBA2222 source");
    impl_->state_.absClippingRect=clip.intersection(Rect(0,0,impl_->width_-1,impl_->height_-1));
    Rect update;
    impl_->drawBitmapWithTransform(BitmapTransformedDrawingInfo(x,y,&bitmap,matrix.forward.data(),matrix.inverse.data()),update);
}
void StockSurface::draw_plain(const Bitmap& bitmap,Rect clip,int x,int y){
    if(bitmap.format!=PixelFormat::RGBA2222)throw std::invalid_argument("Fixture expects RGBA2222 source");
    impl_->state_.absClippingRect=clip.intersection(Rect(0,0,impl_->width_-1,impl_->height_-1));
    Rect update;impl_->drawBitmap(BitmapDrawingInfo(x,y,&bitmap),update);
}
std::vector<uint8_t>& StockSurface::pixels(){return impl_->data_;}
const std::vector<uint8_t>& StockSurface::pixels()const{return impl_->data_;}
uint8_t StockSurface::pixel_at(int x,int y)const{
    if(x<0||y<0||x>=impl_->width_||y>=impl_->height_)throw std::out_of_range("Surface pixel");
    return impl_->data_[size_t(y)*impl_->stride_+(x^2)];
}

Affine make_affine(float sx,float sy,float tx,float ty){
    if(!std::isfinite(sx)||!std::isfinite(sy)||!std::isfinite(tx)||!std::isfinite(ty)||sx==0||sy==0)
        throw std::invalid_argument("Finite invertible diagonal transform required");
    const float identity[9]={1,0,0,0,1,0,0,0,1};
    const float operation[9]={sx,0,tx,0,sy,ty,0,0,1};
    Affine result;
    dspm_mult_f32_ansi(operation,identity,result.forward.data(),3,3,3);
    // Explicit HOST MODEL: no old DSP determinant, Mat allocations or inverse
    // code is substituted into an allegedly firmware-faithful timing path.
    result.inverse={1.0f/sx,0,-tx/sx,0,1.0f/sy,-ty/sy,0,0,1};
    return result;
}

BufferGeometry natural_buffer_size(const Bitmap& source,const Affine& matrix){
    const Bitmap* bitmap=&source;
    const auto srcWidth=bitmap->width,srcHeight=bitmap->height;
    const float srcWidthF=float(srcWidth),srcHeightF=float(srcHeight);
    const float* transform=matrix.forward.data();
    int width=srcWidth,height=srcHeight,xOffset=0,yOffset=0;
    const bool shouldResize=true,autoTranslate=true,explicitSize=false;
#include "command40_bounds.inc"
    return {width,height,xOffset,yOffset};
}

std::vector<uint8_t> transform_buffer(const Bitmap& source,const Affine& matrix,int width,int height,int xOffset,int yOffset){
    if(width<0||height<0||width>32767||height>32767)throw std::invalid_argument("Destination bounds");
    struct Buffer {std::vector<uint8_t> bytes;uint8_t* getBuffer(){return bytes.data();}};
    auto bufferStream=std::make_unique<Buffer>();bufferStream->bytes.resize(size_t(width)*height);
    const Bitmap* bitmap=&source;
    const float srcWidthF=float(bitmap->width),srcHeightF=float(bitmap->height);
    const float* inverse=matrix.inverse.data();
#include "command40_pixels.inc"
    return std::move(bufferStream->bytes);
}

} // namespace stock
