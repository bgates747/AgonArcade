  template <typename TRawGetRow, typename TRawGetPixelInRow, typename TRawSetPixelInRow, typename TBackground>
  void genericRawDrawBitmap_RGBA2222(int destX, int destY, Bitmap const * bitmap, TBackground * saveBackground, int X1, int Y1, int XCount, int YCount,
                                     TRawGetRow rawGetRow, TRawGetPixelInRow rawGetPixelInRow, TRawSetPixelInRow rawSetPixelInRow)
  {
    const int width  = bitmap->width;
    const int yEnd   = Y1 + YCount;
    const int xEnd   = X1 + XCount;
    auto data = bitmap->data;

    if (saveBackground) {

      // save background and draw the bitmap
      for (int y = Y1; y < yEnd; ++y, ++destY) {
        auto dstrow = rawGetRow(destY);
        auto savePx = saveBackground + y * width + X1;
        auto src = data + y * width + X1;
        for (int x = X1, adestX = destX; x < xEnd; ++x, ++adestX, ++savePx, ++src) {
          *savePx = rawGetPixelInRow(dstrow, adestX);
          if (*src & 0xc0)  // alpha > 0 ?
            rawSetPixelInRow(dstrow, adestX, *src);
        }
      }

    } else {

      // just draw the bitmap
      for (int y = Y1; y < yEnd; ++y, ++destY) {
        auto dstrow = rawGetRow(destY);
        auto src = data + y * width + X1;
        for (int x = X1, adestX = destX; x < xEnd; ++x, ++adestX, ++src) {
          if (*src & 0xc0)  // alpha > 0 ?
            rawSetPixelInRow(dstrow, adestX, *src);
        }
      }

    }
  }
  template <typename TRawGetRow, /*typename TRawGetPixelInRow,*/ typename TRawSetPixelInRow /*, typename TBackground */>
  void genericRawDrawTransformedBitmap_RGBA2222(int destX, int destY, Rect drawingRect, Bitmap const * bitmap, const float * invMatrix,
                                     TRawGetRow rawGetRow, /* TRawGetPixelInRow rawGetPixelInRow, */ TRawSetPixelInRow rawSetPixelInRow)
  {
    // transformed bitmap plot works as follows:
    // 1. for each pixel in the destination rectangle, calculate the corresponding pixel in the source bitmap
    // 2. if the source pixel is within source, and is not transparent, plot it to the destination
    //
    // drawingRect should be all on-screen, pre-clipped, but moved to -destX, -destY
    float pos[3] = {0.0f, 0.0f, 1.0f};
    float srcPos[3] = {0.0f, 0.0f, 1.0f};
    float maxX = drawingRect.X2;
    float maxY = drawingRect.Y2;
    auto data = bitmap->data;
    const int width = bitmap->width;
    const float widthF = (float)width;
    const float heightF = (float)bitmap->height;
 
    for (float y = drawingRect.Y1; y < maxY; y++) {
      for (float x = drawingRect.X1; x < maxX; x++) {
        // calculate the source pixel
        pos[0] = x;
        pos[1] = y;
        dspm_mult_3x3x1_f32(invMatrix, pos, srcPos);

        if (srcPos[0] < 0.0f || srcPos[0] >= widthF || srcPos[1] < 0 || srcPos[1] >= heightF)
          continue;

        auto src = data + (int)srcPos[1] * width + (int)srcPos[0];
        if (*src & 0xc0)  // alpha > 0 ?
          rawSetPixelInRow(rawGetRow((int)y + destY), (int)x + destX, *src);
      }
    }
  }
