void VDUStreamProcessor::bufferTransformBitmap(uint16_t bufferId, uint8_t options, uint16_t transformBufferId, uint16_t bitmapId) {
	// resize flag indicates that new bitmap should get a new size
	bool shouldResize = options & TRANSFORM_BITMAP_RESIZE;
	bool explicitSize = options & TRANSFORM_BITMAP_EXPLICIT_SIZE;
	bool autoTranslate = options & TRANSFORM_BITMAP_TRANSLATE;
	if (explicitSize && !shouldResize) {
		debug_log("bufferTransformBitmap: warning - explicit size without resize flag\n\r");
		// we'll let this pass for now, but it may be an error
	}

	int xOffset = 0;
	int yOffset = 0;
	int width = 0;
	int height = 0;
	if (explicitSize) {
		width = readWord_t();
		height = readWord_t();
	}
	if (width == -1 || height == -1) {
		debug_log("bufferTransformBitmap: failed to read explicit size\n\r");
		return;
	}

	auto bitmap = getBitmap(bitmapId);
	if (!bitmap) {
		debug_log("bufferTransformBitmap: bitmap %d not found\n\r", bitmapId);
		return;
	}
	auto transformBufferIter = buffers.find(transformBufferId);
	if (transformBufferIter == buffers.end()) {
		debug_log("bufferTransformBitmap: buffer %d not found\n\r", transformBufferId);
		return;
	}
	auto &transformBuffer = transformBufferIter->second;
	if (!checkTransformBuffer(transformBuffer)) {
		debug_log("bufferTransformBitmap: buffer %d not a 2d transform matrix\n\r", transformBufferId);
		return;
	}

	auto srcWidth = bitmap->width;
	float srcWidthF = (float)srcWidth;
	auto srcHeight = bitmap->height;
	float srcHeightF = (float)srcHeight;
	auto transform = (float *)transformBuffer[0]->getBuffer();
	auto inverse = (float *)transformBuffer[1]->getBuffer();

	if (!explicitSize) {
		width = srcWidth;
		height = srcHeight;
	}
	if (shouldResize || autoTranslate) {
		int minX = INT_MAX;
		int minY = INT_MAX;
		int maxX = INT_MIN;
		int maxY = INT_MIN;
		float pos[3] = { 0.0f, 0.0f, 1.0f };
		float transformed[3];
		dspm_mult_3x3x1_f32(transform, pos, transformed);
		minX = fabgl::imin(minX, (int)transformed[0]);
		minY = fabgl::imin(minY, (int)transformed[1]);
		maxX = fabgl::imax(maxX, (int)transformed[0]);
		maxY = fabgl::imax(maxY, (int)transformed[1]);

		pos[0] = srcWidthF;
		dspm_mult_3x3x1_f32(transform, pos, transformed);
		minX = fabgl::imin(minX, (int)transformed[0]);
		minY = fabgl::imin(minY, (int)transformed[1]);
		maxX = fabgl::imax(maxX, (int)transformed[0]);
		maxY = fabgl::imax(maxY, (int)transformed[1]);

		pos[1] = srcHeightF;
		dspm_mult_3x3x1_f32(transform, pos, transformed);
		minX = fabgl::imin(minX, (int)transformed[0]);
		minY = fabgl::imin(minY, (int)transformed[1]);
		maxX = fabgl::imax(maxX, (int)transformed[0]);
		maxY = fabgl::imax(maxY, (int)transformed[1]);

		pos[0] = 0.0f;
		dspm_mult_3x3x1_f32(transform, pos, transformed);
		minX = fabgl::imin(minX, (int)transformed[0]);
		minY = fabgl::imin(minY, (int)transformed[1]);
		maxX = fabgl::imax(maxX, (int)transformed[0]);
		maxY = fabgl::imax(maxY, (int)transformed[1]);

		debug_log("bufferTransformBitmap: minX %d, minY %d, maxX %d, maxY %d\n\r", minX, minY, maxX, maxY);

		Rect transformedBox = Rect(minX, minY, maxX, maxY);
		debug_log("bufferTransformBitmap: transformed box %d, %d\n\r", transformedBox.width(), transformedBox.height());

		if (shouldResize && !explicitSize) {
			width = (maxX - (autoTranslate ? minX : 0)) + 1;
			height = (maxY - (autoTranslate ? minY : 0)) + 1;
		}
		if (autoTranslate) {
			xOffset = minX;
			yOffset = minY;
		}
	}

	// create a destination buffer using our calculated width and height
	auto bufferStream = make_shared_psram<BufferStream>(width * height);
	if (!bufferStream || !bufferStream->getBuffer()) {
		debug_log("bufferTransformBitmap: failed to create buffer %d\n\r", bufferId);
		return;
	}

	// iterate over our destination buffer, and apply the transformation to each pixel
	auto destination = (RGBA2222 *)bufferStream->getBuffer();
	float pos[3] = {0.0f, 0.0f, 1.0f};
	float srcPos[3] = {0.0f, 0.0f, 1.0f};

	debug_log("bufferTransformBitmap: width %d, height %d, xOffset %d, yOffset %d\n\r", width, height, xOffset, yOffset);

	for (int y = 0; y < height; y++) {
		for (int x = 0; x < width; x++) {
			// calculate the source pixel
			// NB we will need to adjust x,y here if we are auto-translating
			pos[0] = (float)x + xOffset;
			pos[1] = (float)y + yOffset;
			dspm_mult_3x3x1_f32(inverse, pos, srcPos);
			auto srcPixel = RGBA2222(0,0,0,0);
			if (srcPos[0] >= 0.0f && srcPos[0] < srcWidthF && srcPos[1] >= 0.0f && srcPos[1] < srcHeightF) {
				srcPixel = bitmap->getPixel2222((int)srcPos[0], (int)srcPos[1]);
			}
			destination[(int)y * width + (int)x] = srcPixel;
		}
	}

	// save new bitmap data to target buffer
	bufferClear(bufferId);
	buffers[bufferId].push_back(bufferStream);

	// create a new bitmap object
	createBitmapFromBuffer(bufferId, 1, width, height);
}
