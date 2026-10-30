std::function<void(uint8_t * row, int x, uint8_t colorIndex)> VGA64Controller::setRowPixelLambda(PaintMode mode)
{
  switch (mode) {
    case PaintMode::Set:
      return [&] (uint8_t * row, int x, uint8_t pattern) { VGA_PIXELINROW(row, x) = pattern; };
    case PaintMode::OR:
      return [&] (uint8_t * row, int x, uint8_t pattern) { VGA_PIXELINROW(row, x) |= pattern; };
    case PaintMode::ORNOT:
      return [&] (uint8_t * row, int x, uint8_t pattern) { VGA_PIXELINROW(row, x) |= (~pattern & 63); };
    case PaintMode::AND:
      return [&] (uint8_t * row, int x, uint8_t pattern) { VGA_PIXELINROW(row, x) &= pattern; };
    case PaintMode::ANDNOT:
      return [&] (uint8_t * row, int x, uint8_t pattern) { VGA_PIXELINROW(row, x) &= (~pattern & 63) | m_HVSync; };
    case PaintMode::XOR:
      return [&] (uint8_t * row, int x, uint8_t pattern) { VGA_PIXELINROW(row, x) ^= pattern & 63; };
    case PaintMode::Invert:
      return [&] (uint8_t * row, int x, uint8_t pattern) { auto px = &VGA_PIXELINROW(row, x); *px = ~(*px ^ VGA_SYNC_MASK); };
    default:  // PaintMode::NoOp
      return [&] (uint8_t * row, int x, uint8_t pattern) { return; };
  }
}
void VGA64Controller::rawDrawBitmap_RGBA2222(int destX, int destY, Bitmap const * bitmap, void * saveBackground, int X1, int Y1, int XCount, int YCount)
{
  auto paintMode = paintState().paintOptions.mode;
  auto setRowPixel = setRowPixelLambda(paintMode);

  if (paintState().paintOptions.swapFGBG) {
    // used for bitmap plots to indicate drawing with BG color instead of bitmap color
    auto bg = preparePixel(paintState().penColor);
    genericRawDrawBitmap_RGBA2222(destX, destY, bitmap, (uint8_t*)saveBackground, X1, Y1, XCount, YCount,
                                  [&] (int y)                             { return (uint8_t*) m_viewPort[y]; },  // rawGetRow
                                  [&] (uint8_t * row, int x)              { return VGA_PIXELINROW(row, x); },    // rawGetPixelInRow
                                  [&] (uint8_t * row, int x, uint8_t src) { setRowPixel(row, x, bg); }           // rawSetPixelInRow
                                );
    return;
  }

  genericRawDrawBitmap_RGBA2222(destX, destY, bitmap, (uint8_t*)saveBackground, X1, Y1, XCount, YCount,
                                [&] (int y)                             { return (uint8_t*) m_viewPort[y]; },              // rawGetRow
                                [&] (uint8_t * row, int x)              { return VGA_PIXELINROW(row, x); },                // rawGetPixelInRow
                                [&] (uint8_t * row, int x, uint8_t src) { setRowPixel(row, x, m_HVSync | (src & 0x3f)); }  // rawSetPixelInRow
                               );
}
void VGA64Controller::rawDrawBitmapWithMatrix_RGBA2222(int destX, int destY, Rect & drawingRect, Bitmap const * bitmap, const float * invMatrix)
{
  auto paintMode = paintState().paintOptions.mode;
  auto setRowPixel = setRowPixelLambda(paintMode);

  if (paintState().paintOptions.swapFGBG) {
    // used for bitmap plots to indicate drawing with BG color instead of bitmap color
    auto bg = preparePixel(paintState().penColor);
    genericRawDrawTransformedBitmap_RGBA2222(destX, destY, drawingRect, bitmap, invMatrix,
                                            [&] (int y)                { return (uint8_t*) m_viewPort[y]; },  // rawGetRow
                                            // [&] (uint8_t * row, int x) { return VGA_PIXELINROW(row, x); },    // rawGetPixelInRow
                                            [&] (uint8_t * row, int x, uint8_t src) { setRowPixel(row, x, bg); }  // rawSetPixelInRow
                                          );
    return;
  }

  genericRawDrawTransformedBitmap_RGBA2222(destX, destY, drawingRect, bitmap, invMatrix,
                                          [&] (int y)                { return (uint8_t*) m_viewPort[y]; },  // rawGetRow
                                          // [&] (uint8_t * row, int x) { return VGA_PIXELINROW(row, x); },    // rawGetPixelInRow
                                          [&] (uint8_t * row, int x, uint8_t src) { setRowPixel(row, x, src); }  // rawSetPixelInRow
                                         );
}
