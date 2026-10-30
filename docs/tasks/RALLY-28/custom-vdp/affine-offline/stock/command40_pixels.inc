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

