RGBA2222 Bitmap::getPixel2222(int x, int y) const {
  RGBA2222 value = RGBA2222(0,0,0,0);

  if (x < 0 || x >= width || y < 0 || y >= height) {
    return value;
  }

  switch (format) {
    case PixelFormat::Undefined:
      break;
    case PixelFormat::Native:
      break;
    case PixelFormat::Mask:
    {
      int rowlen = (width + 7) / 8;
      uint8_t * rowptr = data + y * rowlen;
      value.A = (rowptr[x >> 3] >> (7 - (x & 7))) & 1 ? 3 : 0;
      if (value.A) {
        value.R = foregroundColor.R >> 6;
        value.G = foregroundColor.G >> 6;
        value.B = foregroundColor.B >> 6;
      } else {
        value.R = value.G = value.B = 0;
      }
      break;
    }
    case PixelFormat::RGBA2222:
      value = ((RGBA2222*)data)[y * width + x];
      break;
    case PixelFormat::RGBA8888:
    {
      RGBA8888 rgba = ((RGBA8888*)data)[y * width + x];
      value.A = rgba.A >> 6;
      value.B = rgba.B >> 6;
      value.G = rgba.G >> 6;
      value.R = rgba.R >> 6;
      break;
    }
  }

  return value;
}
void IRAM_ATTR BitmappedDisplayController::drawBitmap(BitmapDrawingInfo const & bitmapDrawingInfo, Rect & updateRect)
{
  int x = bitmapDrawingInfo.X + paintState().origin.X;
  int y = bitmapDrawingInfo.Y + paintState().origin.Y;
  updateRect = updateRect.merge(Rect(x, y, x + bitmapDrawingInfo.bitmap->width - 1, y + bitmapDrawingInfo.bitmap->height - 1));
  hideSprites(updateRect);
  absDrawBitmap(x, y, bitmapDrawingInfo.bitmap, nullptr, false);
}
void IRAM_ATTR BitmappedDisplayController::absDrawBitmap(int destX, int destY, Bitmap const * bitmap, void * saveBackground, bool ignoreClippingRect)
{
  const int clipX1 = ignoreClippingRect ? 0 : paintState().absClippingRect.X1;
  const int clipY1 = ignoreClippingRect ? 0 : paintState().absClippingRect.Y1;
  const int clipX2 = ignoreClippingRect ? getViewPortWidth() - 1 : paintState().absClippingRect.X2;
  const int clipY2 = ignoreClippingRect ? getViewPortHeight() - 1 : paintState().absClippingRect.Y2;

  if (destX > clipX2 || destY > clipY2)
    return;

  int width  = bitmap->width;
  int height = bitmap->height;

  int X1 = 0;
  int XCount = width;

  if (destX < clipX1) {
    X1 = clipX1 - destX;
    destX = clipX1;
  }
  if (X1 >= width)
    return;

  if (destX + XCount > clipX2 + 1)
    XCount = clipX2 + 1 - destX;
  if (X1 + XCount > width)
    XCount = width - X1;

  int Y1 = 0;
  int YCount = height;

  if (destY < clipY1) {
    Y1 = clipY1 - destY;
    destY = clipY1;
  }
  if (Y1 >= height)
    return;

  if (destY + YCount > clipY2 + 1)
    YCount = clipY2 + 1 - destY;
  if (Y1 + YCount > height)
    YCount = height - Y1;

  switch (bitmap->format) {

    case PixelFormat::Undefined:
      break;

    case PixelFormat::Native:
      rawDrawBitmap_Native(destX, destY, bitmap, X1, Y1, XCount, YCount);
      break;

    case PixelFormat::Mask:
      rawDrawBitmap_Mask(destX, destY, bitmap, saveBackground, X1, Y1, XCount, YCount);
      break;

    case PixelFormat::RGBA2222:
      rawDrawBitmap_RGBA2222(destX, destY, bitmap, saveBackground, X1, Y1, XCount, YCount);
      break;

    case PixelFormat::RGBA8888:
      rawDrawBitmap_RGBA8888(destX, destY, bitmap, saveBackground, X1, Y1, XCount, YCount);
      break;

  }

}
void IRAM_ATTR BitmappedDisplayController::drawBitmapWithTransform(BitmapTransformedDrawingInfo const & drawingInfo, Rect & updateRect)
{
  // work out corners of the bitmap by taking the corners of the bitmap and transforming them by the matrix
  int x = paintState().origin.X + drawingInfo.X;
  int y = paintState().origin.Y + drawingInfo.Y;
  int width = drawingInfo.bitmap->width;
  int height = drawingInfo.bitmap->height;

  Rect originalBox = Rect(0, 0, width, height);
  auto transformMatrix = drawingInfo.transformMatrix;

  // work out each corner's new position
  int minX = INT_MAX;
  int minY = INT_MAX;
  int maxX = INT_MIN;
  int maxY = INT_MIN;
  float pos[3] = { (float)originalBox.X1, (float)originalBox.Y1, 1.0f };
  float transformed[3];
  dspm_mult_3x3x1_f32(transformMatrix, pos, transformed);
  minX = imin(minX, (int)transformed[0]);
  minY = imin(minY, (int)transformed[1]);
  maxX = imax(maxX, (int)transformed[0]);
  maxY = imax(maxY, (int)transformed[1]);

  pos[0] = (float)originalBox.X2;
  dspm_mult_3x3x1_f32(transformMatrix, pos, transformed);
  minX = imin(minX, (int)transformed[0]);
  minY = imin(minY, (int)transformed[1]);
  maxX = imax(maxX, (int)transformed[0]);
  maxY = imax(maxY, (int)transformed[1]);

  pos[0] = (float)originalBox.X1;
  pos[1] = (float)originalBox.Y2;
  dspm_mult_3x3x1_f32(transformMatrix, pos, transformed);
  minX = imin(minX, (int)transformed[0]);
  minY = imin(minY, (int)transformed[1]);
  maxX = imax(maxX, (int)transformed[0]);
  maxY = imax(maxY, (int)transformed[1]);

  pos[0] = (float)originalBox.X2;
  dspm_mult_3x3x1_f32(transformMatrix, pos, transformed);
  minX = imin(minX, (int)transformed[0]);
  minY = imin(minY, (int)transformed[1]);
  maxX = imax(maxX, (int)transformed[0]);
  maxY = imax(maxY, (int)transformed[1]);

  Rect transformedBox = Rect(minX, minY, maxX, maxY);

  // transformed box at this point is the bounding box _without_ taking into account origin
  // drawingRect gets translated, and then clipped to the current clipping rect
  Rect drawingRect = transformedBox.translate(x, y).intersection(paintState().absClippingRect);

  if (drawingRect.width() == 0 || drawingRect.height() == 0) {
    // no area within our current clipping rect to draw
    if (drawingInfo.freeMatrix) {
      m_primDynMemPool.free((void*)drawingInfo.transformMatrix);
      m_primDynMemPool.free((void*)drawingInfo.transformInverse);
    }
    return;
  }

  updateRect = updateRect.merge(drawingRect);
  hideSprites(updateRect);

  // translate our drawing rect _back_ to the origin
  // NB agon-vdp never adjusts the vdp-gl canvas origin, so this is essentially unnecessary, and untested
  drawingRect = drawingRect.translate(-x, -y);

  // drawingRect is now the translated area of the bitmap that we want to draw
  // using an inverted matrix, we can work out the original pixels in the bitmap to draw on-screen

  // Draw the bitmap
  switch (drawingInfo.bitmap->format) {

    case PixelFormat::Undefined:
      break;

    // case PixelFormat::Native:
    //   rawDrawBitmapWithMatrix_Native(x, y, drawingRect, drawingInfo.bitmap, drawingInfo.transformInverse);
    //   break;

    case PixelFormat::Mask:
      rawDrawBitmapWithMatrix_Mask(x, y, drawingRect, drawingInfo.bitmap, drawingInfo.transformInverse);
      break;

    case PixelFormat::RGBA2222:
      rawDrawBitmapWithMatrix_RGBA2222(x, y, drawingRect, drawingInfo.bitmap, drawingInfo.transformInverse);
      break;

    case PixelFormat::RGBA8888:
      rawDrawBitmapWithMatrix_RGBA8888(x, y, drawingRect, drawingInfo.bitmap, drawingInfo.transformInverse);
      break;

  }

  if (drawingInfo.freeMatrix) {
    m_primDynMemPool.free((void*)drawingInfo.transformMatrix);
    m_primDynMemPool.free((void*)drawingInfo.transformInverse);
  }
}
Rect IRAM_ATTR Rect::merge(Rect const & rect) const
{
  return Rect(imin(rect.X1, X1), imin(rect.Y1, Y1), imax(rect.X2, X2), imax(rect.Y2, Y2));
}
Rect IRAM_ATTR Rect::intersection(Rect const & rect) const
{
  return Rect(tmax(X1, rect.X1), tmax(Y1, rect.Y1), tmin(X2, rect.X2), tmin(Y2, rect.Y2));
}
