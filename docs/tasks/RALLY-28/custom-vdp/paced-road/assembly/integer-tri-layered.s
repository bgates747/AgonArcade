section:
	entry	sp, 144	#
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-tri-layered/package/helper/render_core.inc:111:     return (centre * 50 + (y - 96) * u) / 50;
	slli	a8, a3, 2	# tmp81, ct,
	add.n	a3, a8, a3	# tmp82, tmp81, ct
	slli	a8, a3, 2	# tmp83, tmp82,
	add.n	a3, a3, a8	# tmp84, tmp82, tmp83
	slli	a8, a4, 2	# tmp87, cb,
	add.n	a4, a8, a4	# tmp88, tmp87, cb
	slli	a8, a4, 2	# tmp89, tmp88,
	add.n	a4, a4, a8	# tmp90, tmp88, tmp89
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-tri-layered/package/helper/render_core.inc:111:     return (centre * 50 + (y - 96) * u) / 50;
	addi	a9, a6, -96	#, yb,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-tri-layered/package/helper/render_core.inc:140:         top[i] = road_edge(ct, yt, u);
	addi	a8, sp, 40	#,,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-tri-layered/package/helper/render_core.inc:129: static void section(Out *o, int ct, int cb, int yt, int yb, int marked) {
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-tri-layered/package/helper/render_core.inc:111:     return (centre * 50 + (y - 96) * u) / 50;
	slli	a3, a3, 1	# tmp85, tmp84,
	slli	a4, a4, 1	# tmp91, tmp90,
	movi.n	a10, 0	# ivtmp$175,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-tri-layered/package/helper/render_core.inc:140:         top[i] = road_edge(ct, yt, u);
	s32i	a8, sp, 80	# %sfp,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-tri-layered/package/helper/render_core.inc:111:     return (centre * 50 + (y - 96) * u) / 50;
	addi	a15, a5, -96	# tmp96, yt,
	s32i	a9, sp, 108	# %sfp,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-tri-layered/package/helper/render_core.inc:137:     for (int i = 0; i < 10; ++i) {
	movi.n	a12, 0xa	# tmp148,
	loop	a12, .L133_LEND	# tmp148,
.L133:
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-tri-layered/package/helper/render_core.inc:138:         int u = boundaries[i];
	l32r	a11, .LC15	#,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-tri-layered/package/helper/render_core.inc:140:         top[i] = road_edge(ct, yt, u);
	addi	a13, sp, 40	#,,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-tri-layered/package/helper/render_core.inc:138:         int u = boundaries[i];
	add.n	a8, a10, a11	# tmp92, ivtmp$175,
	l32i.n	a8, a8, 0	# MEM[base: _51, offset: 0B], u
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-tri-layered/package/helper/render_core.inc:140:         top[i] = road_edge(ct, yt, u);
	add.n	a14, a13, a10	# tmp95,, ivtmp$175
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-tri-layered/package/helper/render_core.inc:111:     return (centre * 50 + (y - 96) * u) / 50;
	mull	a9, a15, a8	# tmp97, tmp96, u
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-tri-layered/package/helper/render_core.inc:111:     return (centre * 50 + (y - 96) * u) / 50;
	l32r	a13, .LC16	#,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-tri-layered/package/helper/render_core.inc:111:     return (centre * 50 + (y - 96) * u) / 50;
	add.n	a9, a9, a3	# tmp98, tmp97, tmp85
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-tri-layered/package/helper/render_core.inc:111:     return (centre * 50 + (y - 96) * u) / 50;
	mulsh	a11, a9, a13	# tmp134, tmp98,
	srai	a9, a9, 31	# tmp103, tmp98,
	srai	a11, a11, 4	# tmp102, tmp134,
	sub	a9, a11, a9	# tmp104, tmp102, tmp103
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-tri-layered/package/helper/render_core.inc:111:     return (centre * 50 + (y - 96) * u) / 50;
	l32i	a11, sp, 108	# %sfp,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-tri-layered/package/helper/render_core.inc:140:         top[i] = road_edge(ct, yt, u);
	s32i.n	a9, a14, 0	# MEM[base: _48, offset: 0B], tmp104
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-tri-layered/package/helper/render_core.inc:111:     return (centre * 50 + (y - 96) * u) / 50;
	mull	a8, a11, a8	# tmp107,, u
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-tri-layered/package/helper/render_core.inc:141:         bottom[i] = road_edge(cb, yb, u);
	add.n	a9, sp, a10	# tmp105,, ivtmp$175
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-tri-layered/package/helper/render_core.inc:111:     return (centre * 50 + (y - 96) * u) / 50;
	add.n	a8, a8, a4	# tmp108, tmp107, tmp91
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-tri-layered/package/helper/render_core.inc:111:     return (centre * 50 + (y - 96) * u) / 50;
	mulsh	a11, a8, a13	# tmp136, tmp108,
	srai	a8, a8, 31	# tmp113, tmp108,
	srai	a11, a11, 4	# tmp112, tmp136,
	sub	a8, a11, a8	# tmp114, tmp112, tmp113
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-tri-layered/package/helper/render_core.inc:141:         bottom[i] = road_edge(cb, yb, u);
	s32i.n	a8, a9, 0	# MEM[base: _55, offset: 0B], tmp114
	addi.n	a10, a10, 4	# ivtmp$175, ivtmp$175,
	.L133_LEND:		#
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-tri-layered/package/helper/render_core.inc:156:     int kerb = marked ? 9 : 15, line = marked ? 11 : 15;
	movi.n	a4, 9	# iftmp$20_62,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-tri-layered/package/helper/render_core.inc:156:     int kerb = marked ? 9 : 15, line = marked ? 11 : 15;
	movi.n	a8, 0xb	# iftmp$21_10,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-tri-layered/package/helper/render_core.inc:156:     int kerb = marked ? 9 : 15, line = marked ? 11 : 15;
	bnez.n	a7, .L134	# tmp79,
	movi.n	a4, 0xf	# iftmp$20_62,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-tri-layered/package/helper/render_core.inc:156:     int kerb = marked ? 9 : 15, line = marked ? 11 : 15;
	mov.n	a8, a4	# iftmp$21_10, iftmp$20_62
.L134:
	movi.n	a9, 5	# tmp117,
	movi.n	a3, 4	# tmp118,
	movnez	a3, a9, a7	# tmp118, tmp117, tmp79
	mov.n	a7, a3	# iftmp$24_12, tmp118
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-tri-layered/package/helper/render_core.inc:169:     for (int i = 0; i < (marked ? 5 : 4); ++i)
	movi.n	a3, 0	# i,
.L136:
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-tri-layered/package/helper/render_core.inc:170:         road_shape(o, top[left[i]], top[right[i]], bottom[left[i]], bottom[right[i]],
	l32r	a13, .LC17	#,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-tri-layered/package/helper/render_core.inc:170:         road_shape(o, top[left[i]], top[right[i]], bottom[left[i]], bottom[right[i]],
	l32r	a11, .LC18	#, tmp125
	slli	a9, a3, 2	# _57, i,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-tri-layered/package/helper/render_core.inc:170:         road_shape(o, top[left[i]], top[right[i]], bottom[left[i]], bottom[right[i]],
	add.n	a10, a9, a13	# tmp119, _57,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-tri-layered/package/helper/render_core.inc:170:         road_shape(o, top[left[i]], top[right[i]], bottom[left[i]], bottom[right[i]],
	add.n	a9, a9, a11	# tmp124, _57, tmp125
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-tri-layered/package/helper/render_core.inc:170:         road_shape(o, top[left[i]], top[right[i]], bottom[left[i]], bottom[right[i]],
	l32i.n	a10, a10, 0	# MEM[base: _52, offset: 0B], _1
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-tri-layered/package/helper/render_core.inc:170:         road_shape(o, top[left[i]], top[right[i]], bottom[left[i]], bottom[right[i]],
	l32i.n	a9, a9, 0	# MEM[base: _9, offset: 0B], _3
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-tri-layered/package/helper/render_core.inc:170:         road_shape(o, top[left[i]], top[right[i]], bottom[left[i]], bottom[right[i]],
	slli	a10, a10, 2	# tmp121, _1,
	slli	a9, a9, 2	# tmp126, _3,
	add.n	a10, sp, a10	# tmp122,, tmp121
	add.n	a9, sp, a9	# tmp127,, tmp126
	l32i.n	a15, a9, 40	# top, _4
	l32i.n	a12, a10, 40	# top, _2
	l32i.n	a14, a10, 0	# bottom, _5
	l32i.n	a9, a9, 0	# bottom, _6
	mov.n	a13, a4	# iftmp$22_11, iftmp$20_62
	beqz.n	a3, .L135	# i,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-tri-layered/package/helper/render_core.inc:171:                    yt, yb, i == 0 ? kerb : i == 1 ? 8 : line);
	addi.n	a13, a3, -1	# tmp143, i,
	movi.n	a10, 8	# tmp142,
	movnez	a10, a8, a13	# tmp142, iftmp$21_10, tmp143
	mov.n	a13, a10	# iftmp$22_11, tmp142
.L135:
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-tri-layered/package/helper/render_core.inc:42:     byte(o, 18);
	movi.n	a11, 0x12	#,
	mov.n	a10, a2	#, o
	s32i	a8, sp, 104	#,
	s32i	a9, sp, 100	#,
	s32i	a14, sp, 96	#,
	s32i	a15, sp, 92	#,
	s32i	a12, sp, 88	#,
	s32i	a13, sp, 84	#,
	call8	byte		#
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-tri-layered/package/helper/render_core.inc:43:     byte(o, 0);
	movi.n	a11, 0	#,
	mov.n	a10, a2	#, o
	call8	byte		#
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-tri-layered/package/helper/render_core.inc:44:     byte(o, c);
	l32i	a13, sp, 84	#,
	mov.n	a10, a2	#, o
	mov.n	a11, a13	#, iftmp$22_11
	call8	byte		#
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-tri-layered/package/helper/render_core.inc:117:     plot(o, 4, tl, yt);
	l32i	a12, sp, 88	#,
	mov.n	a13, a5	#, yt
	movi.n	a11, 4	#,
	mov.n	a10, a2	#, o
	call8	plot		#
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-tri-layered/package/helper/render_core.inc:118:     plot(o, 4, tr, yt);
	l32i	a15, sp, 92	#,
	mov.n	a13, a5	#, yt
	mov.n	a12, a15	#, _4
	movi.n	a11, 4	#,
	mov.n	a10, a2	#, o
	call8	plot		#
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-tri-layered/package/helper/render_core.inc:124:     plot(o, 85, bl, yb);
	l32i	a14, sp, 96	#,
	mov.n	a13, a6	#, yb
	mov.n	a12, a14	#, _5
	movi.n	a11, 0x55	#,
	mov.n	a10, a2	#, o
	call8	plot		#
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-tri-layered/package/helper/render_core.inc:125:     plot(o, 85, br, yb);
	l32i	a9, sp, 100	#,
	mov.n	a13, a6	#, yb
	mov.n	a12, a9	#, _6
	movi.n	a11, 0x55	#,
	mov.n	a10, a2	#, o
	call8	plot		#
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-tri-layered/package/helper/render_core.inc:169:     for (int i = 0; i < (marked ? 5 : 4); ++i)
	addi.n	a3, a3, 1	# i, i,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-tri-layered/package/helper/render_core.inc:169:     for (int i = 0; i < (marked ? 5 : 4); ++i)
	l32i	a8, sp, 104	#,
	bne	a7, a3, .L136	# iftmp$24_12, i,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-tri-layered/package/helper/render_core.inc:173: }
	retw.n	
