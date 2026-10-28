section:
	entry	sp, 144	#
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-quad-strips/package/helper/render_core.inc:129: static void section(Out *o, int ct, int cb, int yt, int yb, int marked) {
	s32i	a6, sp, 80	# %sfp, yb
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-quad-strips/package/helper/render_core.inc:111:     return (centre * 50 + (y - 96) * u) / 50;
	slli	a6, a3, 2	# tmp84, ct,
	add.n	a3, a6, a3	# tmp85, tmp84, ct
	slli	a6, a3, 2	# tmp86, tmp85,
	add.n	a3, a3, a6	# tmp87, tmp85, tmp86
	slli	a6, a4, 2	# tmp90, cb,
	add.n	a4, a6, a4	# tmp91, tmp90, cb
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-quad-strips/package/helper/render_core.inc:111:     return (centre * 50 + (y - 96) * u) / 50;
	l32i	a8, sp, 80	# %sfp,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-quad-strips/package/helper/render_core.inc:111:     return (centre * 50 + (y - 96) * u) / 50;
	slli	a6, a4, 2	# tmp92, tmp91,
	add.n	a4, a4, a6	# tmp93, tmp91, tmp92
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-quad-strips/package/helper/render_core.inc:111:     return (centre * 50 + (y - 96) * u) / 50;
	addi	a8, a8, -96	#,,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-quad-strips/package/helper/render_core.inc:129: static void section(Out *o, int ct, int cb, int yt, int yb, int marked) {
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-quad-strips/package/helper/render_core.inc:111:     return (centre * 50 + (y - 96) * u) / 50;
	slli	a3, a3, 1	# tmp88, tmp87,
	slli	a4, a4, 1	# tmp94, tmp93,
	movi.n	a10, 0	# ivtmp$171,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-quad-strips/package/helper/render_core.inc:140:         top[i] = road_edge(ct, yt, u);
	addi	a6, sp, 40	# tmp97,,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-quad-strips/package/helper/render_core.inc:111:     return (centre * 50 + (y - 96) * u) / 50;
	addi	a15, a5, -96	# tmp99, yt,
	s32i	a8, sp, 84	# %sfp,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-quad-strips/package/helper/render_core.inc:137:     for (int i = 0; i < 10; ++i) {
	movi.n	a12, 0xa	# tmp181,
	loop	a12, .L133_LEND	# tmp181,
.L133:
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-quad-strips/package/helper/render_core.inc:138:         int u = boundaries[i];
	l32r	a9, .LC15	#,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-quad-strips/package/helper/render_core.inc:111:     return (centre * 50 + (y - 96) * u) / 50;
	l32r	a13, .LC16	#,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-quad-strips/package/helper/render_core.inc:138:         int u = boundaries[i];
	add.n	a8, a10, a9	# tmp95, ivtmp$171,
	l32i.n	a8, a8, 0	# MEM[base: _87, offset: 0B], u
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-quad-strips/package/helper/render_core.inc:140:         top[i] = road_edge(ct, yt, u);
	add.n	a14, a6, a10	# tmp98, tmp97, ivtmp$171
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-quad-strips/package/helper/render_core.inc:111:     return (centre * 50 + (y - 96) * u) / 50;
	mull	a9, a15, a8	# tmp100, tmp99, u
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-quad-strips/package/helper/render_core.inc:111:     return (centre * 50 + (y - 96) * u) / 50;
	add.n	a9, a9, a3	# tmp101, tmp100, tmp88
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-quad-strips/package/helper/render_core.inc:111:     return (centre * 50 + (y - 96) * u) / 50;
	mulsh	a11, a9, a13	# tmp157, tmp101,
	srai	a9, a9, 31	# tmp106, tmp101,
	srai	a11, a11, 4	# tmp105, tmp157,
	sub	a9, a11, a9	# tmp107, tmp105, tmp106
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-quad-strips/package/helper/render_core.inc:111:     return (centre * 50 + (y - 96) * u) / 50;
	l32i	a11, sp, 84	# %sfp,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-quad-strips/package/helper/render_core.inc:140:         top[i] = road_edge(ct, yt, u);
	s32i.n	a9, a14, 0	# MEM[base: _86, offset: 0B], tmp107
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-quad-strips/package/helper/render_core.inc:111:     return (centre * 50 + (y - 96) * u) / 50;
	mull	a8, a11, a8	# tmp110,, u
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-quad-strips/package/helper/render_core.inc:141:         bottom[i] = road_edge(cb, yb, u);
	add.n	a9, sp, a10	# tmp108,, ivtmp$171
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-quad-strips/package/helper/render_core.inc:111:     return (centre * 50 + (y - 96) * u) / 50;
	add.n	a8, a8, a4	# tmp111, tmp110, tmp94
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-quad-strips/package/helper/render_core.inc:111:     return (centre * 50 + (y - 96) * u) / 50;
	mulsh	a11, a8, a13	# tmp159, tmp111,
	srai	a8, a8, 31	# tmp116, tmp111,
	srai	a11, a11, 4	# tmp115, tmp159,
	sub	a8, a11, a8	# tmp117, tmp115, tmp116
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-quad-strips/package/helper/render_core.inc:141:         bottom[i] = road_edge(cb, yb, u);
	s32i.n	a8, a9, 0	# MEM[base: _85, offset: 0B], tmp117
	addi.n	a10, a10, 4	# ivtmp$171, ivtmp$171,
	.L133_LEND:		#
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-quad-strips/package/helper/render_core.inc:156:     int kerb = marked ? 9 : 15, line = marked ? 11 : 15;
	movi.n	a6, 9	# iftmp$20_102,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-quad-strips/package/helper/render_core.inc:156:     int kerb = marked ? 9 : 15, line = marked ? 11 : 15;
	movi.n	a4, 0xb	# iftmp$21_23,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-quad-strips/package/helper/render_core.inc:156:     int kerb = marked ? 9 : 15, line = marked ? 11 : 15;
	bnez.n	a7, .L134	# tmp82,
	movi.n	a6, 0xf	# iftmp$20_102,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-quad-strips/package/helper/render_core.inc:156:     int kerb = marked ? 9 : 15, line = marked ? 11 : 15;
	mov.n	a4, a6	# iftmp$21_23, iftmp$20_102
.L134:
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-quad-strips/package/helper/render_core.inc:159:     for (int i = 0; i < 9; ++i) {
	movi.n	a9, 0	# i,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-quad-strips/package/helper/render_core.inc:163:         if (!marked && i == 3) {next = 6; i = 5;}
	movi.n	a8, 1	# tmp125,
	mov.n	a3, a9	# tmp124, i
	moveqz	a3, a8, a7	# tmp124, tmp125, tmp82
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-quad-strips/package/helper/render_core.inc:163:         if (!marked && i == 3) {next = 6; i = 5;}
	extui	a3, a3, 0, 8	#, tmp124
	s32i	a3, sp, 84	# %sfp,
.L140:
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-quad-strips/package/helper/render_core.inc:161:         int col = i == 0 || i == 8 ? kerb : i == 2 || i == 6 ? line : 8;
	movi.n	a3, -9	#,
	mov.n	a13, a6	# col, iftmp$20_102
	bnone	a9, a3, .L135	# i,,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-quad-strips/package/helper/render_core.inc:161:         int col = i == 0 || i == 8 ? kerb : i == 2 || i == 6 ? line : 8;
	movi.n	a13, -5	# tmp121,
	and	a13, a9, a13	# tmp122, i, tmp121
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-quad-strips/package/helper/render_core.inc:161:         int col = i == 0 || i == 8 ? kerb : i == 2 || i == 6 ? line : 8;
	addi	a13, a13, -2	# tmp170, tmp122,
	movi.n	a3, 8	# tmp169,
	moveqz	a3, a4, a13	# tmp169, iftmp$21_23, tmp170
	mov.n	a13, a3	# col, tmp169
.L135:
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-quad-strips/package/helper/render_core.inc:162:         if (i == 4) col = marked ? line : 8;
	bnei	a9, 4, .L136	# i,,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-quad-strips/package/helper/render_core.inc:162:         if (i == 4) col = marked ? line : 8;
	movi.n	a13, 8	# tmp163,
	movnez	a13, a4, a7	# col, iftmp$21_23, tmp82
.L136:
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-quad-strips/package/helper/render_core.inc:163:         if (!marked && i == 3) {next = 6; i = 5;}
	l32i	a3, sp, 84	# %sfp,
	beqz.n	a3, .L147	#,
	beqi	a9, 3, .L146	# i,,
.L147:
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-quad-strips/package/helper/render_core.inc:164:         int left = next == 6 && !marked ? 3 : i;
	addi	a3, a9, -5	# tmp136, i,
	movi.n	a11, 0	#,
	movnez	a11, a8, a3	#, tmp125, tmp136
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-quad-strips/package/helper/render_core.inc:164:         int left = next == 6 && !marked ? 3 : i;
	extui	a3, a11, 0, 8	# tmp139, tmp135
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-quad-strips/package/helper/render_core.inc:160:         int next = i + 1;
	addi.n	a10, a9, 1	# next, i,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-quad-strips/package/helper/render_core.inc:164:         int left = next == 6 && !marked ? 3 : i;
	bnez.n	a3, .L148	# tmp139,
	movnez	a3, a8, a7	# tmp144, tmp125, tmp82
	beqz.n	a3, .L146	# tmp144,
.L148:
	mov.n	a3, a9	# i, i
	j	.L137		#
.L146:
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-quad-strips/package/helper/render_core.inc:163:         if (!marked && i == 3) {next = 6; i = 5;}
	movi.n	a10, 6	# next,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-quad-strips/package/helper/render_core.inc:163:         if (!marked && i == 3) {next = 6; i = 5;}
	movi.n	a3, 5	# i,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-quad-strips/package/helper/render_core.inc:164:         int left = next == 6 && !marked ? 3 : i;
	movi.n	a9, 3	# i,
.L137:
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-quad-strips/package/helper/render_core.inc:165:         road_shape(o, top[left], top[next], bottom[left], bottom[next], yt, yb, col);
	slli	a9, a9, 2	# tmp145, i,
	slli	a10, a10, 2	# tmp148, next,
	add.n	a10, sp, a10	# tmp149,, tmp148
	add.n	a9, sp, a9	# tmp146,, tmp145
	l32i.n	a14, a10, 0	# bottom, _16
	l32i.n	a15, a10, 40	# top, _14
	l32i.n	a12, a9, 40	# top, _13
	l32i.n	a9, a9, 0	# bottom, _15
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-quad-strips/package/helper/render_core.inc:42:     byte(o, 18);
	movi.n	a11, 0x12	#,
	mov.n	a10, a2	#, o
	s32i	a8, sp, 108	#,
	s32i	a9, sp, 104	#,
	s32i	a14, sp, 100	#,
	s32i	a15, sp, 96	#,
	s32i	a12, sp, 92	#,
	s32i	a13, sp, 88	#,
	call8	byte		#
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-quad-strips/package/helper/render_core.inc:43:     byte(o, 0);
	movi.n	a11, 0	#,
	mov.n	a10, a2	#, o
	call8	byte		#
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-quad-strips/package/helper/render_core.inc:44:     byte(o, c);
	l32i	a13, sp, 88	#,
	mov.n	a10, a2	#, o
	mov.n	a11, a13	#, col
	call8	byte		#
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-quad-strips/package/helper/render_core.inc:117:     plot(o, 4, tl, yt);
	l32i	a12, sp, 92	#,
	mov.n	a13, a5	#, yt
	movi.n	a11, 4	#,
	mov.n	a10, a2	#, o
	call8	plot		#
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-quad-strips/package/helper/render_core.inc:118:     plot(o, 4, tr, yt);
	l32i	a15, sp, 96	#,
	mov.n	a13, a5	#, yt
	mov.n	a12, a15	#, _14
	movi.n	a11, 4	#,
	mov.n	a10, a2	#, o
	call8	plot		#
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-quad-strips/package/helper/render_core.inc:121:     plot(o, 221, br, yb);
	l32i	a14, sp, 100	#,
	l32i	a13, sp, 80	# %sfp,
	mov.n	a12, a14	#, _16
	movi	a11, 0xdd	#,
	mov.n	a10, a2	#, o
	call8	plot		#
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-quad-strips/package/helper/render_core.inc:122:     plot(o, 221, bl, yb);
	l32i	a9, sp, 104	#,
	l32i	a13, sp, 80	# %sfp,
	mov.n	a12, a9	#, _15
	movi	a11, 0xdd	#,
	mov.n	a10, a2	#, o
	call8	plot		#
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-quad-strips/package/helper/render_core.inc:159:     for (int i = 0; i < 9; ++i) {
	addi.n	a9, a3, 1	# i, i,
	l32i	a8, sp, 108	#,
	bnei	a3, 8, .L140	# i,,
# /Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/paced-road/.work/candidates/integer-quad-strips/package/helper/render_core.inc:173: }
	retw.n	
