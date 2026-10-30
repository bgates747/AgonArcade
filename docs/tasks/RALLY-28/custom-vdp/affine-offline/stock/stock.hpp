#pragma once
#include <array>
#include <cstdint>
#include <memory>
#include <vector>

namespace stock {

struct Rect {
    int16_t X1, Y1, X2, Y2;
    Rect() : X1(0), Y1(0), X2(0), Y2(0) {}
    Rect(int a, int b, int c, int d) : X1(a), Y1(b), X2(c), Y2(d) {}
    int width() const { return X2 - X1 + 1; }
    int height() const { return Y2 - Y1 + 1; }
    Rect translate(int x, int y) const { return Rect(X1+x,Y1+y,X2+x,Y2+y); }
    Rect merge(const Rect&) const;
    Rect intersection(const Rect&) const;
};

struct RGBA2222 {
    uint8_t R:2, G:2, B:2, A:2;
    RGBA2222(int r,int g,int b,int a):R(r),G(g),B(b),A(a){}
};
struct RGBA8888 { uint8_t R,G,B,A; };
struct RGB888 { uint8_t R=0,G=0,B=0; };
enum class PixelFormat:uint8_t { Undefined,Native,Mask,RGBA2222,RGBA8888 };

struct Bitmap {
    int width,height;
    uint8_t* data;
    PixelFormat format=PixelFormat::RGBA2222;
    RGB888 foregroundColor{};
    Bitmap(int w,int h,const uint8_t* pixels):width(w),height(h),data(const_cast<uint8_t*>(pixels)){}
    RGBA2222 getPixel2222(int x,int y) const;
};

struct Affine { std::array<float,9> forward,inverse; };

// Forward composition uses the unchanged ANSI DSP multiplication function.
// The diagonal inverse is an analytic HOST MODEL, not the old firmware Mat
// allocation/determinant/inverse implementation. Do not time it as target setup.
Affine make_affine(float sx,float sy,float tx=0,float ty=0);

class StockSurface {
public:
    explicit StockSurface(int width=320,int height=240);
    ~StockSurface();
    StockSurface(StockSurface&&) noexcept;
    StockSurface& operator=(StockSurface&&) noexcept;
    StockSurface(const StockSurface&)=delete;
    StockSurface& operator=(const StockSurface&)=delete;
    void clear(uint8_t rgba=0xc0);
    void draw_affine(const Bitmap&,const Affine&,Rect clip,int x,int y);
    void draw_plain(const Bitmap&,Rect clip,int x,int y);
    // VGA's unchanged pixel-address macro stores x at x^2. Exposed bytes are
    // raw VGA64 rows, with stride rounded to4; use pixel_at for logical pixels.
    std::vector<uint8_t>& pixels();
    const std::vector<uint8_t>& pixels() const;
    uint8_t pixel_at(int x,int y) const;
private:
    struct Impl;
    std::unique_ptr<Impl> impl_;
};

struct BufferGeometry { int width,height,xOffset,yOffset; };
// Natural command40 flags0x05: resize plus auto-translation, including +1 edges.
BufferGeometry natural_buffer_size(const Bitmap&,const Affine&);
// Exact explicit destination pixel kernel; allocation is host vector allocation.
std::vector<uint8_t> transform_buffer(const Bitmap&,const Affine&,int width,int height,int xOffset=0,int yOffset=0);

} // namespace stock
