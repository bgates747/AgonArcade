section:
	entry	sp, 144	#
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:133:     float a = (float)yt * (1.0f / 50.0f) + (-96.0f / 50.0f);
	l32r	a8, .LC15	#,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:133:     float a = (float)yt * (1.0f / 50.0f) + (-96.0f / 50.0f);
	float.s	f0, a5, 0	# _1, yt
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:133:     float a = (float)yt * (1.0f / 50.0f) + (-96.0f / 50.0f);
	wfr	f1, a8	# tmp97,
	mul.s	f6, f0, f1	# tmp96, _1, tmp97
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:133:     float a = (float)yt * (1.0f / 50.0f) + (-96.0f / 50.0f);
	l32r	a8, .LC16	#,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:134:     float b = (float)(cb - ct);
	sub	a4, a4, a3	# tmp99, cb, ct
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:133:     float a = (float)yt * (1.0f / 50.0f) + (-96.0f / 50.0f);
	wfr	f2, a8	#,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:134:     float b = (float)(cb - ct);
	float.s	f5, a4, 0	# b, tmp99
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:133:     float a = (float)yt * (1.0f / 50.0f) + (-96.0f / 50.0f);
	sub.s	f6, f6, f2	# a, tmp96,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:135:     float c = (float)yt * (-1.0f / 50.0f) + (float)yb * (1.0f / 50.0f);
	l32r	a4, .LC17	#,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:135:     float c = (float)yt * (-1.0f / 50.0f) + (float)yb * (1.0f / 50.0f);
	float.s	f2, a6, 0	# tmp100, yb
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:145:         x = x + b * 0.0f;
	l32r	a8, .LC18	#,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:135:     float c = (float)yt * (-1.0f / 50.0f) + (float)yb * (1.0f / 50.0f);
	mul.s	f2, f2, f1	# tmp101, tmp100, tmp97
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:135:     float c = (float)yt * (-1.0f / 50.0f) + (float)yb * (1.0f / 50.0f);
	wfr	f1, a4	#,
	mul.s	f0, f0, f1	# tmp103, _1,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:138:         int u = boundaries[i];
	l32r	a11, .LC19	#, tmp108
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:147:         x = x + (float)ct;
	float.s	f3, a3, 0	# _10, ct
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:129: static void section(Out *o, int ct, int cb, int yt, int yb, int marked) {
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:135:     float c = (float)yt * (-1.0f / 50.0f) + (float)yb * (1.0f / 50.0f);
	add.s	f2, f2, f0	# c, tmp101, tmp103
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:145:         x = x + b * 0.0f;
	wfr	f0, a8	# tmp105,
	mul.s	f8, f5, f0	# _8, b, tmp105
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:146:         x = x + c * (float)(u * 0);
	movi.n	a4, 0	# ivtmp$171,
	mul.s	f7, f2, f0	# _9, c, tmp105
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:148:         top[i] = (int)x;
	addi	a10, sp, 40	# tmp110,,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:137:     for (int i = 0; i < 10; ++i) {
	movi.n	a8, 0xa	# tmp177,
	loop	a8, .L133_LEND	# tmp177,
.L133:
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:138:         int u = boundaries[i];
	add.n	a3, a4, a11	# tmp107, ivtmp$171, tmp108
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:144:         float x = a * (float)u;
	l32i.n	a3, a3, 0	# MEM[base: _106, offset: 0B], MEM[base: _106, offset: 0B]
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:148:         top[i] = (int)x;
	add.n	a9, a10, a4	# tmp111, tmp110, ivtmp$171
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:144:         float x = a * (float)u;
	float.s	f0, a3, 0	# _7, MEM[base: _106, offset: 0B]
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:144:         float x = a * (float)u;
	mul.s	f4, f0, f6	# x, _7, a
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:151:         x = x + c * (float)u;
	mul.s	f0, f0, f2	# tmp114, _7, c
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:145:         x = x + b * 0.0f;
	add.s	f1, f8, f4	# x, _8, x
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:150:         x = x + b;
	add.s	f4, f5, f4	# x, b, x
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:146:         x = x + c * (float)(u * 0);
	add.s	f1, f7, f1	# x, _9, x
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:151:         x = x + c * (float)u;
	add.s	f0, f0, f4	# x, tmp114, x
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:147:         x = x + (float)ct;
	add.s	f1, f3, f1	# x, _10, x
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:152:         x = x + (float)ct;
	add.s	f0, f3, f0	# x, _10, x
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:148:         top[i] = (int)x;
	trunc.s	a3, f1, 0	# tmp113, x
	s32i.n	a3, a9, 0	# MEM[base: _105, offset: 0B], tmp113
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:153:         bottom[i] = (int)x;
	trunc.s	a3, f0, 0	# tmp117, x
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:153:         bottom[i] = (int)x;
	add.n	a9, sp, a4	# tmp115,, ivtmp$171
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:153:         bottom[i] = (int)x;
	s32i.n	a3, a9, 0	# MEM[base: _102, offset: 0B], tmp117
	addi.n	a4, a4, 4	# ivtmp$171, ivtmp$171,
	.L133_LEND:		#
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:156:     int kerb = marked ? 9 : 15, line = marked ? 11 : 15;
	movi.n	a8, 9	# iftmp$20_115,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:156:     int kerb = marked ? 9 : 15, line = marked ? 11 : 15;
	movi.n	a4, 0xb	# iftmp$21_36,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:156:     int kerb = marked ? 9 : 15, line = marked ? 11 : 15;
	bnez.n	a7, .L134	# tmp95,
	movi.n	a8, 0xf	# iftmp$20_115,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:156:     int kerb = marked ? 9 : 15, line = marked ? 11 : 15;
	mov.n	a4, a8	# iftmp$21_36, iftmp$20_115
.L134:
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:159:     for (int i = 0; i < 9; ++i) {
	movi.n	a10, 0	# i,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:163:         if (!marked && i == 3) {next = 6; i = 5;}
	movi.n	a9, 1	# tmp125,
	mov.n	a3, a10	# tmp124, i
	moveqz	a3, a9, a7	# tmp124, tmp125, tmp95
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:163:         if (!marked && i == 3) {next = 6; i = 5;}
	extui	a3, a3, 0, 8	#, tmp124
	s32i	a3, sp, 84	# %sfp,
.L140:
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:161:         int col = i == 0 || i == 8 ? kerb : i == 2 || i == 6 ? line : 8;
	movi.n	a12, -9	#,
	mov.n	a13, a8	# col, iftmp$20_115
	bnone	a10, a12, .L135	# i,,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:161:         int col = i == 0 || i == 8 ? kerb : i == 2 || i == 6 ? line : 8;
	movi.n	a13, -5	# tmp121,
	and	a13, a10, a13	# tmp122, i, tmp121
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:161:         int col = i == 0 || i == 8 ? kerb : i == 2 || i == 6 ? line : 8;
	addi	a13, a13, -2	# tmp166, tmp122,
	movi.n	a3, 8	# tmp165,
	moveqz	a3, a4, a13	# tmp165, iftmp$21_36, tmp166
	mov.n	a13, a3	# col, tmp165
.L135:
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:162:         if (i == 4) col = marked ? line : 8;
	bnei	a10, 4, .L136	# i,,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:162:         if (i == 4) col = marked ? line : 8;
	movi.n	a13, 8	# tmp159,
	movnez	a13, a4, a7	# col, iftmp$21_36, tmp95
.L136:
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:163:         if (!marked && i == 3) {next = 6; i = 5;}
	l32i	a3, sp, 84	# %sfp,
	beqz.n	a3, .L147	#,
	beqi	a10, 3, .L146	# i,,
.L147:
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:164:         int left = next == 6 && !marked ? 3 : i;
	addi	a3, a10, -5	# tmp136, i,
	movi.n	a12, 0	#,
	movnez	a12, a9, a3	#, tmp125, tmp136
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:164:         int left = next == 6 && !marked ? 3 : i;
	extui	a3, a12, 0, 8	# tmp139, tmp135
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:160:         int next = i + 1;
	addi.n	a11, a10, 1	# next, i,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:164:         int left = next == 6 && !marked ? 3 : i;
	bnez.n	a3, .L148	# tmp139,
	movnez	a3, a9, a7	# tmp144, tmp125, tmp95
	beqz.n	a3, .L146	# tmp144,
.L148:
	mov.n	a3, a10	# i, i
	j	.L137		#
.L146:
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:163:         if (!marked && i == 3) {next = 6; i = 5;}
	movi.n	a11, 6	# next,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:163:         if (!marked && i == 3) {next = 6; i = 5;}
	movi.n	a3, 5	# i,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:164:         int left = next == 6 && !marked ? 3 : i;
	movi.n	a10, 3	# i,
.L137:
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:165:         road_shape(o, top[left], top[next], bottom[left], bottom[next], yt, yb, col);
	slli	a10, a10, 2	# tmp145, i,
	add.n	a10, sp, a10	# tmp146,, tmp145
	slli	a11, a11, 2	# tmp148, next,
	l32i.n	a12, a10, 40	# top, _26
	add.n	a11, sp, a11	# tmp149,, tmp148
	l32i.n	a10, a10, 0	# bottom,
	l32i.n	a14, a11, 0	# bottom, _29
	l32i.n	a15, a11, 40	# top, _27
	s32i	a10, sp, 80	# %sfp,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:42:     byte(o, 18);
	movi.n	a11, 0x12	#,
	mov.n	a10, a2	#, o
	s32i	a8, sp, 104	#,
	s32i	a9, sp, 108	#,
	s32i	a14, sp, 100	#,
	s32i	a15, sp, 96	#,
	s32i	a12, sp, 92	#,
	s32i	a13, sp, 88	#,
	call8	byte		#
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:43:     byte(o, 0);
	movi.n	a11, 0	#,
	mov.n	a10, a2	#, o
	call8	byte		#
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:44:     byte(o, c);
	l32i	a13, sp, 88	#,
	mov.n	a10, a2	#, o
	mov.n	a11, a13	#, col
	call8	byte		#
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:117:     plot(o, 4, tl, yt);
	l32i	a12, sp, 92	#,
	mov.n	a13, a5	#, yt
	movi.n	a11, 4	#,
	mov.n	a10, a2	#, o
	call8	plot		#
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:118:     plot(o, 4, tr, yt);
	l32i	a15, sp, 96	#,
	mov.n	a13, a5	#, yt
	mov.n	a12, a15	#, _27
	movi.n	a11, 4	#,
	mov.n	a10, a2	#, o
	call8	plot		#
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:121:     plot(o, 221, br, yb);
	l32i	a14, sp, 100	#,
	mov.n	a13, a6	#, yb
	mov.n	a12, a14	#, _29
	movi	a11, 0xdd	#,
	mov.n	a10, a2	#, o
	call8	plot		#
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:122:     plot(o, 221, bl, yb);
	l32i	a12, sp, 80	# %sfp,
	mov.n	a10, a2	#, o
	mov.n	a13, a6	#, yb
	movi	a11, 0xdd	#,
	call8	plot		#
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:159:     for (int i = 0; i < 9; ++i) {
	addi.n	a10, a3, 1	# i, i,
	l32i	a8, sp, 104	#,
	l32i	a9, sp, 108	#,
	bnei	a3, 8, .L140	# i,,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/float-quad-strips/package/helper/render_core.inc:173: }
	retw.n	
