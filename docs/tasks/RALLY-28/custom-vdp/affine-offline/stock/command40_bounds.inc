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
