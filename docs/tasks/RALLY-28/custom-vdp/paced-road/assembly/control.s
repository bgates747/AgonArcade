section:
	entry	sp, 80	#
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:107:     float a = (float)yt * (1.0f / 50.0f) + (-96.0f / 50.0f);
	l32r	a8, .LC15	#,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:107:     float a = (float)yt * (1.0f / 50.0f) + (-96.0f / 50.0f);
	float.s	f0, a5, 0	# _1, yt
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:107:     float a = (float)yt * (1.0f / 50.0f) + (-96.0f / 50.0f);
	wfr	f2, a8	# tmp94,
	mul.s	f1, f0, f2	# tmp93, _1, tmp94
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:107:     float a = (float)yt * (1.0f / 50.0f) + (-96.0f / 50.0f);
	l32r	a8, .LC16	#,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:108:     float b = (float)(cb - ct), c = (float)yt * (-1.0f / 50.0f) + (float)yb * (1.0f / 50.0f);
	sub	a4, a4, a3	# tmp96, cb, ct
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:107:     float a = (float)yt * (1.0f / 50.0f) + (-96.0f / 50.0f);
	wfr	f3, a8	#,
	sub.s	f1, f1, f3	#, tmp93,
	movi.n	a8, 5	# tmp103,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:111:         colour(o, i == 0 ? (marked ? 9 : 15) : i == 1 ? 8 : (marked ? 11 : 15));
	movi.n	a9, 0xf	# tmp130,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:111:         colour(o, i == 0 ? (marked ? 9 : 15) : i == 1 ? 8 : (marked ? 11 : 15));
	movi.n	a10, 0xb	# tmp145,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:107:     float a = (float)yt * (1.0f / 50.0f) + (-96.0f / 50.0f);
	ssi	f1, sp, 0	# %sfp,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:108:     float b = (float)(cb - ct), c = (float)yt * (-1.0f / 50.0f) + (float)yb * (1.0f / 50.0f);
	float.s	f1, a4, 0	#, tmp96
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:108:     float b = (float)(cb - ct), c = (float)yt * (-1.0f / 50.0f) + (float)yb * (1.0f / 50.0f);
	l32r	a4, .LC17	#,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:108:     float b = (float)(cb - ct), c = (float)yt * (-1.0f / 50.0f) + (float)yb * (1.0f / 50.0f);
	ssi	f1, sp, 12	# %sfp,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:108:     float b = (float)(cb - ct), c = (float)yt * (-1.0f / 50.0f) + (float)yb * (1.0f / 50.0f);
	float.s	f1, a6, 0	# tmp97, yb
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:111:         colour(o, i == 0 ? (marked ? 9 : 15) : i == 1 ? 8 : (marked ? 11 : 15));
	moveqz	a10, a9, a7	# tmp145, tmp130, tmp92
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:108:     float b = (float)(cb - ct), c = (float)yt * (-1.0f / 50.0f) + (float)yb * (1.0f / 50.0f);
	mul.s	f1, f1, f2	# tmp98, tmp97, tmp94
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:108:     float b = (float)(cb - ct), c = (float)yt * (-1.0f / 50.0f) + (float)yb * (1.0f / 50.0f);
	wfr	f2, a4	#,
	mul.s	f0, f0, f2	# tmp100, _1,
	movi.n	a4, 4	# tmp104,
	movnez	a4, a8, a7	# tmp104, tmp103, tmp92
	s32i.n	a4, sp, 8	# %sfp, tmp104
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:108:     float b = (float)(cb - ct), c = (float)yt * (-1.0f / 50.0f) + (float)yb * (1.0f / 50.0f);
	add.s	f0, f1, f0	#, tmp98, tmp100
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:111:         colour(o, i == 0 ? (marked ? 9 : 15) : i == 1 ? 8 : (marked ? 11 : 15));
	movi.n	a4, 9	# tmp129,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:103: static void section(Out *o, int ct, int cb, int yt, int yb, int marked) {
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:111:         colour(o, i == 0 ? (marked ? 9 : 15) : i == 1 ? 8 : (marked ? 11 : 15));
	moveqz	a4, a9, a7	# iftmp$20_18, tmp130, tmp92
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:108:     float b = (float)(cb - ct), c = (float)yt * (-1.0f / 50.0f) + (float)yb * (1.0f / 50.0f);
	ssi	f0, sp, 4	# %sfp,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:111:         colour(o, i == 0 ? (marked ? 9 : 15) : i == 1 ? 8 : (marked ? 11 : 15));
	movi.n	a8, 0	# i,
	s32i.n	a10, sp, 16	# %sfp, tmp145
	j	.L134		#
.L137:
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:111:         colour(o, i == 0 ? (marked ? 9 : 15) : i == 1 ? 8 : (marked ? 11 : 15));
	l32i.n	a9, sp, 16	# %sfp,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:111:         colour(o, i == 0 ? (marked ? 9 : 15) : i == 1 ? 8 : (marked ? 11 : 15));
	movi.n	a4, 8	# iftmp$20_18,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:111:         colour(o, i == 0 ? (marked ? 9 : 15) : i == 1 ? 8 : (marked ? 11 : 15));
	addi.n	a7, a8, -1	# tmp156, i,
	movnez	a4, a9, a7	# iftmp$20_18,, tmp156
.L134:
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:42:     byte(o, 18);
	movi.n	a11, 0x12	#,
	mov.n	a10, a2	#, o
	s32i.n	a8, sp, 40	#,
	call8	byte		#
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:43:     byte(o, 0);
	movi.n	a11, 0	#,
	mov.n	a10, a2	#, o
	call8	byte		#
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:44:     byte(o, c);
	mov.n	a11, a4	#, iftmp$20_18
	mov.n	a10, a2	#, o
	call8	byte		#
	l32i.n	a8, sp, 40	#,
	l32r	a4, .LC19	#, tmp106
	l32r	a14, .LC18	#, tmp105
	slli	a7, a8, 2	# _69, i,
	add.n	a14, a7, a14	# _57, _69, tmp105
	add.n	a7, a7, a4	# _58, _69, tmp106
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:112:         for (int v = 0; v < 2; ++v)
	movi.n	a4, 0	# v,
	j	.L136		#
.L141:
	movi.n	a4, 1	# v,
.L136:
	movi.n	a10, 0x55	#,
	movi.n	a9, 4	# tmp110,
	movnez	a9, a10, a4	# tmp108,, v
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:116:                 x = x + b * (float)v;
	lsi	f1, sp, 12	# %sfp,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:114:                 int u = side ? right[i] : left[i];
	l32i.n	a10, a14, 0	# MEM[base: _57, offset: 0B], iftmp$24_59
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:116:                 x = x + b * (float)v;
	float.s	f0, a4, 0	# tmp107, v
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:115:                 float x = a * (float)u;
	lsi	f2, sp, 0	# %sfp,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:116:                 x = x + b * (float)v;
	mul.s	f0, f0, f1	# _9, tmp107,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:115:                 float x = a * (float)u;
	float.s	f1, a10, 0	# tmp112, iftmp$24_59
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:117:                 x = x + c * (float)(u * v);
	mull	a10, a10, a4	# tmp113, iftmp$24_59, v
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:115:                 float x = a * (float)u;
	mul.s	f1, f1, f2	# x, tmp112,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:117:                 x = x + c * (float)(u * v);
	lsi	f3, sp, 4	# %sfp,
	mov.n	a15, a6	# tmp111, yb
	moveqz	a15, a5, a4	# tmp111, yt, v
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:116:                 x = x + b * (float)v;
	add.s	f2, f0, f1	# x, _9, x
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:117:                 x = x + c * (float)(u * v);
	float.s	f1, a10, 0	# tmp114, tmp113
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:119:                 plot(o, v ? 85 : 4, (int)x, v ? yb : yt);
	mov.n	a13, a15	#, tmp111
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:117:                 x = x + c * (float)(u * v);
	mul.s	f1, f1, f3	# tmp115, tmp114,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:119:                 plot(o, v ? 85 : 4, (int)x, v ? yb : yt);
	mov.n	a11, a9	#, tmp108
	mov.n	a10, a2	#, o
	s32i.n	a8, sp, 40	#,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:117:                 x = x + c * (float)(u * v);
	add.s	f1, f1, f2	# x, tmp115, x
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:118:                 x = x + (float)ct;
	float.s	f2, a3, 0	# _54, ct
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:119:                 plot(o, v ? 85 : 4, (int)x, v ? yb : yt);
	s32i.n	a14, sp, 36	#,
	s32i.n	a9, sp, 28	#,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:118:                 x = x + (float)ct;
	add.s	f1, f1, f2	# x, x, _54
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:119:                 plot(o, v ? 85 : 4, (int)x, v ? yb : yt);
	s32i.n	a15, sp, 32	#,
	ssi	f0, sp, 20	#,
	ssi	f2, sp, 24	#,
	trunc.s	a12, f1, 0	#, x
	call8	plot		#
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:114:                 int u = side ? right[i] : left[i];
	l32i.n	a10, a7, 0	# MEM[base: _58, offset: 0B], iftmp$24_37
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:115:                 float x = a * (float)u;
	lsi	f3, sp, 0	# %sfp,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:115:                 float x = a * (float)u;
	float.s	f1, a10, 0	# tmp118, iftmp$24_37
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:116:                 x = x + b * (float)v;
	lsi	f0, sp, 20	#,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:115:                 float x = a * (float)u;
	mul.s	f1, f1, f3	# x, tmp118,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:117:                 x = x + c * (float)(u * v);
	mull	a10, a10, a4	# tmp119, iftmp$24_37, v
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:117:                 x = x + c * (float)(u * v);
	lsi	f3, sp, 4	# %sfp,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:118:                 x = x + (float)ct;
	lsi	f2, sp, 24	#,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:116:                 x = x + b * (float)v;
	add.s	f1, f0, f1	# x, _9, x
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:117:                 x = x + c * (float)(u * v);
	float.s	f0, a10, 0	# tmp120, tmp119
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:119:                 plot(o, v ? 85 : 4, (int)x, v ? yb : yt);
	l32i.n	a15, sp, 32	#,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:117:                 x = x + c * (float)(u * v);
	mul.s	f0, f0, f3	# tmp121, tmp120,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:119:                 plot(o, v ? 85 : 4, (int)x, v ? yb : yt);
	l32i.n	a9, sp, 28	#,
	mov.n	a13, a15	#, tmp111
	mov.n	a11, a9	#, tmp108
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:117:                 x = x + c * (float)(u * v);
	add.s	f0, f0, f1	# x, tmp121, x
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:119:                 plot(o, v ? 85 : 4, (int)x, v ? yb : yt);
	mov.n	a10, a2	#, o
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:118:                 x = x + (float)ct;
	add.s	f0, f0, f2	# x, x, _54
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:119:                 plot(o, v ? 85 : 4, (int)x, v ? yb : yt);
	trunc.s	a12, f0, 0	#, x
	call8	plot		#
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:112:         for (int v = 0; v < 2; ++v)
	l32i.n	a8, sp, 40	#,
	l32i.n	a14, sp, 36	#,
	bnei	a4, 1, .L141	# v,,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:110:     for (int i = 0; i < (marked ? 5 : 4); ++i) {
	l32i.n	a4, sp, 8	# %sfp,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:110:     for (int i = 0; i < (marked ? 5 : 4); ++i) {
	addi.n	a8, a8, 1	# i, i,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:110:     for (int i = 0; i < (marked ? 5 : 4); ++i) {
	bne	a4, a8, .L137	#, i,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/control/package/helper/render_core.inc:123: }
	retw.n	
