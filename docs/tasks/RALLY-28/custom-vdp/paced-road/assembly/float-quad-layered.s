section:
	entry	sp, 144	#
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-layered/package/helper/render_core.inc:133:     float a = (float)yt * (1.0f / 50.0f) + (-96.0f / 50.0f);
	l32r	a8, .LC6	#,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-layered/package/helper/render_core.inc:133:     float a = (float)yt * (1.0f / 50.0f) + (-96.0f / 50.0f);
	float.s	f0, a5, 0	# _1, yt
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-layered/package/helper/render_core.inc:133:     float a = (float)yt * (1.0f / 50.0f) + (-96.0f / 50.0f);
	wfr	f1, a8	# tmp94,
	mul.s	f6, f0, f1	# tmp93, _1, tmp94
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-layered/package/helper/render_core.inc:133:     float a = (float)yt * (1.0f / 50.0f) + (-96.0f / 50.0f);
	l32r	a8, .LC7	#,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-layered/package/helper/render_core.inc:134:     float b = (float)(cb - ct);
	sub	a4, a4, a3	# tmp96, cb, ct
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-layered/package/helper/render_core.inc:133:     float a = (float)yt * (1.0f / 50.0f) + (-96.0f / 50.0f);
	wfr	f2, a8	#,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-layered/package/helper/render_core.inc:134:     float b = (float)(cb - ct);
	float.s	f5, a4, 0	# b, tmp96
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-layered/package/helper/render_core.inc:133:     float a = (float)yt * (1.0f / 50.0f) + (-96.0f / 50.0f);
	sub.s	f6, f6, f2	# a, tmp93,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-layered/package/helper/render_core.inc:135:     float c = (float)yt * (-1.0f / 50.0f) + (float)yb * (1.0f / 50.0f);
	l32r	a4, .LC8	#,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-layered/package/helper/render_core.inc:135:     float c = (float)yt * (-1.0f / 50.0f) + (float)yb * (1.0f / 50.0f);
	float.s	f2, a6, 0	# tmp97, yb
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-layered/package/helper/render_core.inc:145:         x = x + b * 0.0f;
	l32r	a8, .LC9	#,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-layered/package/helper/render_core.inc:135:     float c = (float)yt * (-1.0f / 50.0f) + (float)yb * (1.0f / 50.0f);
	mul.s	f2, f2, f1	# tmp98, tmp97, tmp94
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-layered/package/helper/render_core.inc:135:     float c = (float)yt * (-1.0f / 50.0f) + (float)yb * (1.0f / 50.0f);
	wfr	f1, a4	#,
	mul.s	f0, f0, f1	# tmp100, _1,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-layered/package/helper/render_core.inc:138:         int u = boundaries[i];
	l32r	a11, .LC10	#, tmp105
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-layered/package/helper/render_core.inc:147:         x = x + (float)ct;
	float.s	f3, a3, 0	# _10, ct
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-layered/package/helper/render_core.inc:129: static void section(Out *o, int ct, int cb, int yt, int yb, int marked) {
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-layered/package/helper/render_core.inc:135:     float c = (float)yt * (-1.0f / 50.0f) + (float)yb * (1.0f / 50.0f);
	add.s	f2, f2, f0	# c, tmp98, tmp100
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-layered/package/helper/render_core.inc:145:         x = x + b * 0.0f;
	wfr	f0, a8	# tmp102,
	mul.s	f8, f5, f0	# _8, b, tmp102
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-layered/package/helper/render_core.inc:146:         x = x + c * (float)(u * 0);
	movi.n	a4, 0	# ivtmp$122,
	mul.s	f7, f2, f0	# _9, c, tmp102
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-layered/package/helper/render_core.inc:148:         top[i] = (int)x;
	addi	a10, sp, 40	# tmp107,,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-layered/package/helper/render_core.inc:137:     for (int i = 0; i < 10; ++i) {
	movi.n	a8, 0xa	# tmp144,
	loop	a8, .L16_LEND	# tmp144,
.L16:
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-layered/package/helper/render_core.inc:138:         int u = boundaries[i];
	add.n	a3, a4, a11	# tmp104, ivtmp$122, tmp105
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-layered/package/helper/render_core.inc:144:         float x = a * (float)u;
	l32i.n	a3, a3, 0	# MEM[base: _64, offset: 0B], MEM[base: _64, offset: 0B]
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-layered/package/helper/render_core.inc:148:         top[i] = (int)x;
	add.n	a9, a10, a4	# tmp108, tmp107, ivtmp$122
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-layered/package/helper/render_core.inc:144:         float x = a * (float)u;
	float.s	f0, a3, 0	# _7, MEM[base: _64, offset: 0B]
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-layered/package/helper/render_core.inc:144:         float x = a * (float)u;
	mul.s	f4, f0, f6	# x, _7, a
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-layered/package/helper/render_core.inc:151:         x = x + c * (float)u;
	mul.s	f0, f0, f2	# tmp111, _7, c
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-layered/package/helper/render_core.inc:145:         x = x + b * 0.0f;
	add.s	f1, f8, f4	# x, _8, x
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-layered/package/helper/render_core.inc:150:         x = x + b;
	add.s	f4, f5, f4	# x, b, x
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-layered/package/helper/render_core.inc:146:         x = x + c * (float)(u * 0);
	add.s	f1, f7, f1	# x, _9, x
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-layered/package/helper/render_core.inc:151:         x = x + c * (float)u;
	add.s	f0, f0, f4	# x, tmp111, x
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-layered/package/helper/render_core.inc:147:         x = x + (float)ct;
	add.s	f1, f3, f1	# x, _10, x
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-layered/package/helper/render_core.inc:152:         x = x + (float)ct;
	add.s	f0, f3, f0	# x, _10, x
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-layered/package/helper/render_core.inc:148:         top[i] = (int)x;
	trunc.s	a3, f1, 0	# tmp110, x
	s32i.n	a3, a9, 0	# MEM[base: _63, offset: 0B], tmp110
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-layered/package/helper/render_core.inc:153:         bottom[i] = (int)x;
	trunc.s	a3, f0, 0	# tmp114, x
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-layered/package/helper/render_core.inc:153:         bottom[i] = (int)x;
	add.n	a9, sp, a4	# tmp112,, ivtmp$122
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-layered/package/helper/render_core.inc:153:         bottom[i] = (int)x;
	s32i.n	a3, a9, 0	# MEM[base: _62, offset: 0B], tmp114
	addi.n	a4, a4, 4	# ivtmp$122, ivtmp$122,
	.L16_LEND:		#
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-layered/package/helper/render_core.inc:156:     int kerb = marked ? 9 : 15, line = marked ? 11 : 15;
	movi.n	a4, 9	# iftmp$20_75,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-layered/package/helper/render_core.inc:156:     int kerb = marked ? 9 : 15, line = marked ? 11 : 15;
	movi.n	a8, 0xb	# iftmp$21_23,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-layered/package/helper/render_core.inc:156:     int kerb = marked ? 9 : 15, line = marked ? 11 : 15;
	bnez.n	a7, .L17	# tmp92,
	movi.n	a4, 0xf	# iftmp$20_75,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-layered/package/helper/render_core.inc:156:     int kerb = marked ? 9 : 15, line = marked ? 11 : 15;
	mov.n	a8, a4	# iftmp$21_23, iftmp$20_75
.L17:
	movi.n	a9, 5	# tmp117,
	movi.n	a3, 4	# tmp118,
	movnez	a3, a9, a7	# tmp118, tmp117, tmp92
	mov.n	a7, a3	# iftmp$24_25, tmp118
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-layered/package/helper/render_core.inc:169:     for (int i = 0; i < (marked ? 5 : 4); ++i)
	movi.n	a3, 0	# i,
.L19:
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-layered/package/helper/render_core.inc:170:         road_shape(o, top[left[i]], top[right[i]], bottom[left[i]], bottom[right[i]],
	l32r	a11, .LC11	#,
	slli	a10, a3, 2	# _71, i,
	add.n	a9, a10, a11	# tmp119, _71,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-layered/package/helper/render_core.inc:170:         road_shape(o, top[left[i]], top[right[i]], bottom[left[i]], bottom[right[i]],
	l32r	a11, .LC12	#, tmp125
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-layered/package/helper/render_core.inc:170:         road_shape(o, top[left[i]], top[right[i]], bottom[left[i]], bottom[right[i]],
	l32i.n	a9, a9, 0	# MEM[base: _70, offset: 0B], _14
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-layered/package/helper/render_core.inc:170:         road_shape(o, top[left[i]], top[right[i]], bottom[left[i]], bottom[right[i]],
	add.n	a10, a10, a11	# tmp124, _71, tmp125
	l32i.n	a10, a10, 0	# MEM[base: _67, offset: 0B], _16
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-layered/package/helper/render_core.inc:170:         road_shape(o, top[left[i]], top[right[i]], bottom[left[i]], bottom[right[i]],
	slli	a9, a9, 2	# tmp121, _14,
	slli	a10, a10, 2	# tmp126, _16,
	add.n	a9, sp, a9	# tmp122,, tmp121
	add.n	a10, sp, a10	# tmp127,, tmp126
	l32i.n	a12, a9, 40	# top, _15
	l32i.n	a15, a10, 40	# top, _17
	l32i.n	a9, a9, 0	# bottom, _18
	l32i.n	a14, a10, 0	# bottom, _19
	mov.n	a13, a4	# iftmp$22_24, iftmp$20_75
	beqz.n	a3, .L18	# i,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-layered/package/helper/render_core.inc:171:                    yt, yb, i == 0 ? kerb : i == 1 ? 8 : line);
	addi.n	a13, a3, -1	# tmp139, i,
	movi.n	a10, 8	# tmp138,
	movnez	a10, a8, a13	# tmp138, iftmp$21_23, tmp139
	mov.n	a13, a10	# iftmp$22_24, tmp138
.L18:
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-layered/package/helper/render_core.inc:42:     byte(o, 18);
	movi.n	a11, 0x12	#,
	mov.n	a10, a2	#, o
	s32i	a8, sp, 100	#,
	s32i	a9, sp, 96	#,
	s32i	a14, sp, 92	#,
	s32i	a15, sp, 88	#,
	s32i	a12, sp, 84	#,
	s32i	a13, sp, 80	#,
	call8	byte		#
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-layered/package/helper/render_core.inc:43:     byte(o, 0);
	movi.n	a11, 0	#,
	mov.n	a10, a2	#, o
	call8	byte		#
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-layered/package/helper/render_core.inc:44:     byte(o, c);
	l32i	a13, sp, 80	#,
	mov.n	a10, a2	#, o
	mov.n	a11, a13	#, iftmp$22_24
	call8	byte		#
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-layered/package/helper/render_core.inc:117:     plot(o, 4, tl, yt);
	l32i	a12, sp, 84	#,
	mov.n	a13, a5	#, yt
	movi.n	a11, 4	#,
	mov.n	a10, a2	#, o
	call8	plot		#
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-layered/package/helper/render_core.inc:118:     plot(o, 4, tr, yt);
	l32i	a15, sp, 88	#,
	mov.n	a13, a5	#, yt
	mov.n	a12, a15	#, _17
	movi.n	a11, 4	#,
	mov.n	a10, a2	#, o
	call8	plot		#
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-layered/package/helper/render_core.inc:121:     plot(o, 221, br, yb);
	l32i	a14, sp, 92	#,
	mov.n	a13, a6	#, yb
	mov.n	a12, a14	#, _19
	movi	a11, 0xdd	#,
	mov.n	a10, a2	#, o
	call8	plot		#
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-layered/package/helper/render_core.inc:122:     plot(o, 221, bl, yb);
	l32i	a9, sp, 96	#,
	mov.n	a13, a6	#, yb
	mov.n	a12, a9	#, _18
	movi	a11, 0xdd	#,
	mov.n	a10, a2	#, o
	call8	plot		#
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-layered/package/helper/render_core.inc:169:     for (int i = 0; i < (marked ? 5 : 4); ++i)
	addi.n	a3, a3, 1	# i, i,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-layered/package/helper/render_core.inc:169:     for (int i = 0; i < (marked ? 5 : 4); ++i)
	l32i	a8, sp, 100	#,
	bne	a7, a3, .L19	# iftmp$24_25, i,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-layered/package/helper/render_core.inc:173: }
	retw.n	
