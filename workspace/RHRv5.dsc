290	0	Only passable by Mario. To sprites, it will obey the act-as setting.
291	0	Only passable by sprites. To Mario, it will obey the act-as setting.
292	0	Shatters when a sprite is thrown at it.
293	0	A Donut Lift, which will fall shortly after being stepped on.
295	0	simple walljump block
296	0	Sprite only triangle, will bounce kicked sprites if they're going rightward
297	0	Sprite only triangle, will bounce kicked sprites if they're going rightward
298	0	This block is forces player's jump type to jump (if spinning) and is erased when Mario touches it.
299	0	This block is forces player's jump type to spin (if not spinning) and is erased when Mario touches it.
29a	0	This block is forces player's jump type to spin (if not spinning) and is erased when Mario touches it.
29b	0	A coin that changes the switch state to ON when collected.
29c	0	A coin that changes the switch state to OFF when collected.
29d	0	This block is simply erased when Mario touches it. It's used for several purposes in the baserom: a 1F0 that disappears after you touch it; disappearing indicators, etc.
29f	0	Block that kills the player (even on yoshi), is solid for sprites and kills on wall running.
2a0	0	A block that acts like a mid-air suspended Spiny.
2a1	0	A block that acts like a mid-air suspended Spiny that disappears after contact.
2a2	0	A block that acts like a stationary Swooper.
2a3	0	A single-use bounce block. Noteblock bounce height, doesn't negate spin
2a4	0	A throw block with an endless supply.
2a5	0	Makes Mario small and optionally clears Item Box, removes P-balloon, and flight states.
2a6	0	The top of the 1x2 key block.
2a7	0	The top of the 1x3 key block.
2a8	0	Bounces sprites! But is passable by Mario.
2a9	0	A coin that activates the p-switch timer and is erased when Mario touches it.
2aa	0	A coin that activates star power and is erased when Mario touches it.
2ab	0	Sets the switch state to ON when anything (incl. dead sprites) touches it.
2ac	0	Sets the switch state to OFF when anything (incl. dead sprites) touches it.
2b1	0	Right-facing one-way; solid to anything moving leftwards.
2b2	0	A one-way for Mario that only allows him to go up through it, and will kill him if he tries to go down.
2b3	0	A one-way for Mario that only allows him to go right through it, and will kill him if he tries to go left.
2b4	0	The left of the 2x1 key block.
2b5	0	The right of the 2x1 key block.
2b6	0	The bottom of the 1x2 key block.
2b7	0	The middle of the 1x3 key block.
2b8	0	This block turns shells and koopas touching it into disco shells.
2b9	0	This block turns a disco shell into a kicked shell.
2ba	0	This block stuns most shells upon contact (except for multi bounce shells) & if shell is disco converts to a regular shell.
2bb	0	Passthrough when switch state is ON and the Map16 act-as when OFF.
2bc	0	Passthrough when switch state is OFF and the Map16 act-as when ON.
2bd	0	Block that kills the player (even on yoshi), is passable for sprites and kills on wall running.
2c0	0	Left-facing one-way; solid to anything moving rightwards.
2c1	0	Down-facing one-way; solid to anything moving upwards.
2c2	0	A one-way for Mario that only allows him to go left through it, and will kill him if he tries to go right.
2c3	0	A one-way for Mario that only allows him to go down through it, and will kill him if he tries to go up.
2c4	0	The left of the 3x1 key block.
2c5	0	The middle of the 3x1 key block.
2c6	0	The right of the 3x1 key block.
2c7	0	The bottom of the 1x3 key block.
2c8	0	This block turns shells and koopas touching it into disco shells.
2c9	0	This block turns a disco shell into a kicked shell.
2ca	0	This block stuns most shells upon contact (except for multi bounce shells) & if shell is disco converts to a regular shell.
2cb	0	Solid for sprites, but allows Mario to pass. Fireballs won't pass.
2cc	0	Solid for sprite if ON otherwise passable for everything else
2cd	0	Kills sprites. Does not work for sprites that do not have object interaction.
2d0	0	Solid for sprites ONLY (block-interactable sprites) when they go down, but allows up
2d1	0	Solid for sprites ONLY (block-interactable sprites) when they go left, but allows right
2d2	0	Solid for sprites ONLY (block-interactable sprites) when they go down, but allows up
2d3	0	Solid for sprites ONLY (block-interactable sprites) when they go left, but allows right
2d4	0	If the ON/OFF switch is on, solid when hit from above. If off, solid when hit from below.
2d5	0	If the ON/OFF switch is on, solid when hit from the right. If off, solid when hit from the left.
2d6	0	Limits sprite speed to $23
2d7	0	Limits sprite speed to $53
2d8	0	A block that clears the star power timer when player passes through.
2d9	0	Solid when star power is activated
2da	0	Solid when star power is NOT activated
2db	0	An on-off death block, solid when the switch is on.
2dc	0	An on-off death block, solid when the switch is on
2e0	0	Solid for sprites ONLY (block-interactable sprites) when they go right, but allows left
2e1	0	Solid for sprites ONLY (block-interactable sprites) when they go up, but allows down
2e2	0	Solid for sprites ONLY (block-interactable sprites) when they go left, but allows right
2e3	0	Solid for sprites ONLY (block-interactable sprites) when they go up, but allows down
2e4	0	If the ON/OFF switch is on, solid when hit from the left. If off, solid when hit from the right.
2e5	0	If the ON/OFF switch is on, solid when hit from below. If off, solid when hit from above.
2e6	0	Limits sprite downward speed to $19
2e7	0	mario_sprite_only/spriteboostblock.asm
2e8	0	A block that clears blue p-switch timer when player passes through.
2e9	0	A regular on-off block, which only becomes solid when the p-switch is activated
2ea	0	A regular on-off block, which is solid when the p-switch is NOT activated
2eb	0	This is one half of a pair of custom on/off switches. Unlike normal switches, after you hit this one, it'll become a brick block and you'll be unable to flip it again, UNTIL the OTHER switch is flipped (and vice versa). Is also set to be activated by Mario fireballs, too, but you can change this.
2ec	0	This is one half of a pair of custom on/off switches. Unlike normal switches, after you hit this one, it'll become a brick block and you'll be unable to flip it again, UNTIL the OTHER switch is flipped (and vice versa). Is also set to be activated by Mario fireballs, too, but you can change this.
2f0	0	A question mark block which always contains a Mushroom.
2f1	0	A question mark block which always contains a Fire Flower.
2f2	0	A question mark block which always contains a Cape Feather.
2f3	0	A question mark block which contains sprite 1-Up if Yoshi exists, else Yoshi in an egg.
2f4	0	A question mark block which always contains a Vine.
2f5	0	A question mark block which always contains a P-Balloon.
2f6	0	A question mark block which always contains a Key.
2f7	0	A question mark block which contains a Throw Block.
2f8	0	A question mark block which contains a normal Poison Mushroom.
2f9	0	A question mark block which contains a lethal Poison Mushroom.
2fa	0	A question mark block which contains a G(al)oomba.
2fb	0	A question mark block which contains a Fish.
2fc	0	A question mark block which always contains a Blue P-Switch.
2fd	0	A question mark block which always contains a Silver P-Switch.
2fe	0	A question mark block which contains a portable Springboard.
2ff	0	A question mark block which contains a Roulette Power-up.
300	0	Top cap of vertical 2-way pipe, left side.
301	0	Top cap of vertical 2-way pipe, right side.
302	0	Part of pipe that Mario moves through.
303	0	Part of pipe that Mario moves through.
304	0	Part of pipe that Mario moves through.
305	0	Bottom cap of a small vertical 2-way pipe.
306	0	Top cap of vertical 2-way pipe, left side.
307	0	Top cap of vertical 2-way pipe, right side.
308	0	Part of pipe that Mario moves through.
309	0	Part of pipe that Mario moves through.
30a	0	Part of pipe that Mario moves through.
30b	0	Bottom cap of a small vertical 2-way pipe.
30c	0	Part of pipe that Mario moves through.
30d	0	Part of pipe that Mario moves through.
30e	0	Part of pipe that Mario moves through.
30f	0	Part of pipe that Mario moves through.
310	0	Part of pipe that Mario moves through.
311	0	Part of pipe that Mario moves through.
312	0	Left-facing cap of a horizontal two-way pipe, bottom tile.
313	0	Part of pipe that Mario moves through.
314	0	Right-facing cap of a horizontal two-way pipe, bottom tile.
315	0	Part of pipe that Mario moves through.
316	0	Part of pipe that Mario moves through.
317	0	Part of pipe that Mario moves through.
318	0	Left-facing cap of a horizontal exit-only pipe, bottom tile.
319	0	Part of pipe that Mario moves through.
31a	0	Right-facing cap of a horizontal two-way pipe, bottom tile.
31b	0	Part of pipe that Mario moves through.
31c	0	Changes the pipe direction from up to right or left to down.
31d	0	Part of pipe that Mario moves through.
31e	0	Part of pipe that Mario moves through.
31f	0	Changes the pipe direction from right to down or up to left.
320	0	Bottom cap of vertical 2-way pipe, left side.
321	0	Bottom cap of vertical 2-way pipe, right side.
322	0	Left-facing cap of a small horizontal exit-only pipe
323	0	Part of pipe that Mario moves through.
324	0	Right-facing cap of a small horizontal exit-only pipe
325	0	Bottom cap of a small vertical 2-way pipe.
326	0	Bottom cap of a vertical exit-only pipe, left side.
327	0	Bottom cap of a vertical exit-only pipe, right side.
328	0	Left-facing cap of a small horizontal exit-only pipe
329	0	Part of pipe that Mario moves through.
32a	0	Right-facing cap of a horizontal exit-only pipe, bottom tile.
32b	0	Bottom cap of a small vertical exit-only pipe.
32c	0	Part of pipe that Mario moves through.
32d	0	Part of pipe that Mario moves through.
32e	0	Part of pipe that Mario moves through.
32f	0	Part of pipe that Mario moves through.
332	0	Part of pipe that Mario moves through but it but clears held item.
333	0	Part of pipe that Mario moves through but it but clears held item.
334	0	Part of pipe that Mario moves through but it but clears held item.
335	0	Part of pipe that Mario moves through but it but clears held item.
336	0	Top cap of a vertical exit-only pipe, left side.
337	0	Top cap of a vertical exit-only pipe, right side.
338	0	Part of pipe that Mario moves through.
339	0	Part of pipe that Mario moves through.
33a	0	Left-facing cap of a horizontal exit-only pipe, bottom tile.
33b	0	Top cap of a small vertical exit-only pipe.
33c	0	Changes the pipe direction from left to up or down to right.
33d	0	Part of pipe that Mario moves through.
33e	0	Part of pipe that Mario moves through.
33f	0	Changes the pipe direction from down to left or right to up.
342	0	Part of pipe that Mario moves through but it but clears held item.
343	0	Part of pipe that Mario moves through but it but clears held item.
344	0	Part of pipe that Mario moves through but it but clears held item.
345	0	Part of pipe that Mario moves through but it but clears held item.
346	0	Bottom cap of vertical 2-way pipe, left side.
347	0	Bottom cap of vertical 2-way pipe, right side.
348	0	Left-facing cap of a horizontal two-way pipe, bottom tile.
349	0	Right-facing cap of a horizontal exit-only pipe, bottom tile.
34a	0	Right-facing cap of a small horizontal exit-only pipe
34b	0	Bottom cap of a small vertical 2-way pipe.
34c	0	Changes the pipe direction from up to right or left to down.
34d	0	Changes the pipe direction from right to down or up to left.
350	0	Bounces throw blocks from the side.
351	0	ShellStop.asm
352	0	ShellStop2.asm
353	0	This block stuns most shells upon contact (except for multi bounce shells) & if shell is disco converts to a regular shell.
354	0	Block which will stick to it most of the sprites that can be carried
355	0	This block boosts the player down-right.
356	0	This block boosts the player rightwards.
357	0	This block boosts the player downwards.
358	0	This block boosts the player down-left.
359	0	ON/OFF switch block that hurts player upon contact.
35a	0	ON/OFF switch block that hurts player upon contact.
35c	0	Changes the pipe direction from left to up or down to right.
35d	0	Changes the pipe direction from down to left or right to up.
360	0	Bounces throw blocks from the side.
361	0	ShellStop.asm
362	0	ShellStop2.asm
363	0	This block stuns most shells upon contact (except for multi bounce shells) & if shell is disco converts to a regular shell.
365	0	This block boosts the player up-right.
366	0	This block boosts the player upwards.
367	0	This block boosts the player leftwards.
368	0	This block boosts the player up-left.
369	0	ON/OFF switch block that hurts player upon contact.
36a	0	ON/OFF switch block that hurts player upon contact.
36f	0	Part of pipe that Mario moves through.
370	0	Left tile of the two-tile wide 32x16 coin.
371	0	Right tile of the two-tile wide 32x16 coin.
393	0	This block is solid, and only becomes passable once $7E007C value has been met or exceeded.
394	0	Only passable by Mario. To sprites, it will obey the act-as setting.
3b0	0	This block acts like a 1F0 that converts the sprite above to disco and is erased when Mario touches it.
3b1	0	This block is forces player's jump type to jump (if spinning) and is erased when Mario touches it.
3b2	0	This block is forces player's jump type to spin (if not spinning) and is erased when Mario touches it.
3b3	0	Transforms Koopas into other Koopas.
3b4	0	This block removes interactions from other sprites for most sprites which pass through.
3b5	0	This block makes most sprites invincible to star/cape/fire/bounce blk. after passing through.
3b6	0	This block makes most sprites process offscreen after passing through.
3b7	0	This block prevents most sprites from turning into a coin when goal is passed, after passing through.
3b8	0	This block makes most sprites not use default interaction with the player after passing through.
3b9	0	This block stuns most shells upon contact (except for multi bounce shells) & if shell is disco converts to a regular shell.
3ba	0	This block stuns most shells upon contact (except for multi bounce shells) & if shell is disco converts to a regular shell.
3bb	0	ON/OFF switch block that hurts player upon contact.
3bc	0	Shatters when a sprite is kicked/thrown at it, but hurts or kills player upon contact.
3bd	0	A turnblock that spins forever after being activated, and will hurt/kill the player if they come in contact. ***Disclaimer, grey palette will turn to palette 6 once animation begins. This can be corrected by tweaking a few colors in palette 6.
3be	0	This block acts like a right facing purple triangle to sprites but will kill player if they come in contact.
3bf	0	This block acts like a left facing purple triangle to sprites but will kill player if they come in contact.
3c0	0	Scroll camera left. (Remove graphics in Map16 when finished.)
3c1	0	Scroll camera right. (Remove graphics in Map16 when finished.)
3c2	0	Enable horizontal camera scroll. (Remove graphics in Map16 when finished.)
3c3	0	Disable horizontal camera scroll. (Remove graphics in Map16 when finished.)
3c4	0	Enable vertical camera scroll. (Remove graphics in Map16 when finished.)
3c5	0	Disable vertical camera scroll. (Remove graphics in Map16 when finished.)
3d0	0	This is a block that the player and enemies will stick to when they jump into it from below.
3d1	0	This is a block that the player and enemies will stick to when they jump into it from below.
3d2	0	When On/Off switch is in the On state the player and enemies will stick to when they jump into it from below. Player will passthrough like air when switch state is Off
3d3	0	When On/Off switch is in the On state the player and enemies will stick to when they jump into it from below. Player will passthrough like air when switch state is Off
3d4	0	When On/Off switch is in the On state the player and enemies will stick to when they jump into it from below. Player will passthrough like air when switch state is Off
3d5	0	Turns on scrollable music playlist when hit. Works with MusicPlaylist.asm UberASM.
3e0	0	When obtained, this coin forces player to face left and is erased when player touches it.
3e1	0	When obtained, this coin forces player to switch direction their facing and is erased when player touches it.
3e2	0	When obtained, this coin forces player to face right and is erased when player touches it.
3e3	0	A coin that can be collected by throwing a shell or by collecting it.
3f0	0	This block is solid to non-disco sprites, and passable by mario & disco sprites.
3f1	0	This block is passable by non-disco sprites, and solid to mario & disco sprites.
3f2	0	This block is solid to disco sprites, and passable by mario & non-disco sprites.
3f3	0	This block is solid to mario & non-disco sprites, and passable by disco sprites.
3f4	0	block is only passable by shells
400	0	This block spawns a sprite, automatically carried, with the block erasing itself afterwards. Note that the bobomb and mechakoopa require the correct sprite GFX to display properly.
401	0	This block spawns a sprite, automatically carried, with the block erasing itself afterwards. Note that the bobomb and mechakoopa require the correct sprite GFX to display properly.
402	0	This block spawns a sprite, automatically carried, with the block erasing itself afterwards. Note that the bobomb and mechakoopa require the correct sprite GFX to display properly.
403	0	This block spawns a sprite, automatically carried, with the block erasing itself afterwards. Note that the bobomb and mechakoopa require the correct sprite GFX to display properly.
404	0	This block spawns a sprite, automatically carried, with the block erasing itself afterwards. Note that the bobomb and mechakoopa require the correct sprite GFX to display properly.
405	0	This block spawns a sprite, automatically carried, with the block erasing itself afterwards. Note that the bobomb and mechakoopa require the correct sprite GFX to display properly.
406	0	This block spawns a stunned disco shell that is automatically carried & activated once kicked. The block destroys itself afterwards.
407	0	This block spawns a stunned disco shell that is automatically carried & activated once kicked. The block destroys itself afterwards.
408	0	This block spawns a spiny shell that is automatically carried and destroys itself afterwards.
409	0	This block spawns a spiny shell that is automatically carried and destroys itself afterwards.
40a	0	This block spawns a spiny shell that is automatically carried and destroys itself afterwards.
40b	0	This block spawns a motor shell that is automatically carried and destroys itself afterwards.
40c	0	This block spawns a motor shell that is automatically carried and destroys itself afterwards.
40d	0	This block spawns a motor shell that is automatically carried and destroys itself afterwards.
40e	0	This block spawns a custom shell that is automatically carried & the block destroys itself afterwards.
410	0	This block spawns a 1 bounce shell that is automatically carried and destroys itself afterwards.
411	0	This block spawns a 2 bounce shell that is automatically carried and destroys itself afterwards.
412	0	This block spawns a 3 bounce shell that is automatically carried and destroys itself afterwards.
413	0	This block spawns a 4 bounce shell that is automatically carried and destroys itself afterwards.
414	0	This block spawns a 5 bounce shell that is automatically carried and destroys itself afterwards.
415	0	This block spawns a 6 bounce shell that is automatically carried and destroys itself afterwards.
416	0	This block spawns a 7 bounce shell that is automatically carried and destroys itself afterwards.
417	0	This block spawns a 8 bounce shell that is automatically carried and destroys itself afterwards.
418	0	This block spawns a 9 bounce shell that is automatically carried and destroys itself afterwards.
419	0	This block spawns an infinite bounce shell that is automatically carried and destroys itself afterwards.
41a	0	Upper left tile of the four-tile centered 32x32 spawn carried shell.
41b	0	Upper right tile of the four-tile centered 32x32 spawn carried shell.
41c	0	Top tile of the two-tile tall 16x32 spawn carried shell.
420	0	This block spawns a sprite, automatically carried, with the block erasing itself afterwards. Note that the bobomb and mechakoopa require the correct sprite GFX to display properly.
421	0	This block spawns a sprite, automatically carried, with the block erasing itself afterwards. Note that the bobomb and mechakoopa require the correct sprite GFX to display properly.
422	0	This block spawns a sprite, automatically carried, with the block erasing itself afterwards. Note that the bobomb and mechakoopa require the correct sprite GFX to display properly.
423	0	This block spawns a sprite, automatically carried, with the block erasing itself afterwards. Note that the bobomb and mechakoopa require the correct sprite GFX to display properly.
424	0	This block spawns a sprite, automatically carried, with the block erasing itself afterwards. Note that the bobomb and mechakoopa require the correct sprite GFX to display properly.
425	0	This block spawns a sprite, automatically carried, with the block erasing itself afterwards. Note that the bobomb and mechakoopa require the correct sprite GFX to display properly.
426	0	This block spawns a sprite, automatically carried, with the block erasing itself afterwards. Note that the bobomb and mechakoopa require the correct sprite GFX to display properly.
427	0	This block spawns a throwblock that is automatically carried and destroys itself afterwards.
428	0	This block spawns a throwblock that is automatically carried and destroys itself afterwards.
42a	0	Bottom left tile of the four-tile centered 32x32 spawn carried shell.
42b	0	Bottom right tile of the four-tile centered 32x32 spawn carried shell.
42c	0	Bottom tile of the two-tile tall 16x32 spawn carried shell.
42d	0	Left tile of the two-tile wide 32x16 spawn carried shell.
42e	0	Right tile of the two-tile wide 32x16 spawn carried shell.
44d	0	Left tile of the two-tile wide 32x16 coin.
44e	0	Right tile of the two-tile wide 32x16 coin.
45a	0	Top tile of the two-tile tall 16x32 coin.
460	0	This block spawns a carried green shell while riding Yoshi. The block destroys itself afterwards.
461	0	This block spawns a carried red shell while riding Yoshi. The block destroys itself afterwards.
462	0	This block spawns a carried blue shell while riding Yoshi. The block destroys itself afterwards.
463	0	This block spawns a carried yellow shell while riding Yoshi. The block destroys itself afterwards.
464	0	This block spawns a carried spiny shell while riding Yoshi. The block destroys itself afterwards.
465	0	This block spawns a carried disco shell while riding Yoshi. The block destroys itself afterwards.
466	0	This block spawns a carried ghost shell while riding Yoshi. The block destroys itself afterwards.
467	0	This block spawns a carried sprite even if player is already carrying something. The block destroys itself afterwards.
46a	0	Bottom tile of the two-tile tall 16x32 coin.
7d65	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7d66	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7d67	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7d68	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7d69	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7d6a	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7d6b	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7d6c	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7d6d	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7d6e	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7d6f	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7d70	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7d71	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7d72	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7d73	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7d74	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7d75	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7d76	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7d77	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7d78	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7d79	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7d7a	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7d7b	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7d7c	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7d7d	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7d7e	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7d7f	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7d80	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7d81	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7d82	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7d83	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7d84	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7d85	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7d86	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7d87	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7d88	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7d89	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7d8a	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7d8b	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7d8c	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7d8d	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7d8e	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7d8f	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7d90	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7d91	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7d92	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7d93	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7d94	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7d95	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7d96	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7d97	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7d98	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7d99	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7d9a	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7d9b	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7d9c	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7d9d	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7d9e	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7d9f	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7da0	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7da1	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7da2	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7da3	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7da4	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7da5	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7da6	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7da7	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7da8	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7da9	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7daa	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7dab	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7dac	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7dad	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7dae	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7daf	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7db0	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7db1	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7db2	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7db3	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7db4	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7db5	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7db6	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7db7	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7db8	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7db9	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7dba	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7dbb	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7dbc	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7dbd	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7dbe	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7dbf	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7dc0	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7dc1	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7dc2	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7dc3	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7dc4	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7dc5	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7dc6	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7dc7	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7dc8	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7dc9	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7dca	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7dcb	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7dcc	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7dcd	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7dce	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7dcf	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7dd0	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7dd1	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7dd2	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7dd3	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7dd4	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7dd5	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7dd6	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7dd7	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7dd8	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7dd9	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7dda	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ddb	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ddc	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ddd	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7dde	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ddf	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7de0	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7de1	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7de2	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7de3	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7de4	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7de5	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7de6	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7de7	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7de8	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7de9	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7dea	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7deb	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7dec	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ded	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7dee	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7def	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7df0	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7df1	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7df2	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7df3	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7df4	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7df5	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7df6	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7df7	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7df8	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7df9	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7dfa	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7dfb	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7dfc	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7dfd	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7dfe	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7dff	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e01	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e02	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e03	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e04	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e05	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e06	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e07	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e08	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e09	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e0a	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e0b	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e0c	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e0d	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e0e	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e0f	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e10	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e11	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e12	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e13	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e14	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e15	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e16	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e17	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e18	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e19	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e1a	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e1b	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e1c	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e1d	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e1e	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e1f	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e20	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e21	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e22	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e23	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e24	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e25	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e26	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e27	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e28	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e29	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e2a	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e2b	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e2c	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e2d	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e2e	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e2f	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e30	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e31	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e32	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e33	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e34	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e35	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e36	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e37	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e38	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e39	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e3a	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e3b	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e3c	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e3d	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e3e	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e3f	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e40	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e41	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e42	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e43	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e44	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e45	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e46	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e47	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e48	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e49	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e4a	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e4b	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e4c	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e4d	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e4e	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e4f	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e50	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e51	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e52	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e53	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e54	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e55	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e56	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e57	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e58	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e59	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e5a	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e5b	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e5c	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e5d	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e5e	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e5f	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e65	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e66	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e67	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e68	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e69	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e6a	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e6b	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e6c	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e6d	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e6e	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e6f	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e70	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e71	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e72	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e73	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e74	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e75	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e76	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e77	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e78	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e79	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e7a	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e7b	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e7c	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e7d	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e7e	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e7f	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e80	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e81	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e82	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e83	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e84	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e85	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e86	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e87	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e88	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e89	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e8a	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e8b	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e8c	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e8d	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e8e	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e8f	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e90	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e91	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e92	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e93	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e94	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e95	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e96	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e97	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e98	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e99	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e9a	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e9b	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e9c	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e9d	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e9e	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7e9f	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ea0	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ea1	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ea2	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ea3	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ea4	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ea5	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ea6	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ea7	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ea8	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ea9	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7eaa	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7eab	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7eac	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ead	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7eae	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7eaf	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7eb0	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7eb1	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7eb2	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7eb3	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7eb4	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7eb5	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7eb6	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7eb7	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7eb8	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7eb9	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7eba	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ebb	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ebc	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ebd	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ebe	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ebf	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ec0	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ec1	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ec2	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ec3	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ec4	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ec5	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ec6	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ec7	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ec8	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ec9	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7eca	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ecb	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ecc	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ecd	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ece	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ecf	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ed0	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ed1	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ed2	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ed3	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ed4	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ed5	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ed6	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ed7	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ed8	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ed9	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7eda	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7edb	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7edc	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7edd	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ede	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7edf	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ee0	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ee1	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ee2	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ee3	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ee4	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ee5	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ee6	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ee7	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ee8	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ee9	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7eea	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7eeb	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7eec	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7eed	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7eee	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7eef	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ef0	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ef1	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ef2	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ef3	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ef4	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ef5	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ef6	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ef7	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ef8	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7ef9	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7efa	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7efb	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7efc	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7efd	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7efe	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7eff	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f00	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f01	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f02	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f03	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f04	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f05	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f06	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f07	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f08	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f09	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f0a	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f0b	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f0c	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f0d	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f0e	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f0f	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f10	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f11	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f12	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f13	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f14	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f15	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f16	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f17	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f18	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f19	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f1a	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f1b	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f1c	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f1d	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f1e	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f1f	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f20	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f21	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f22	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f23	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f24	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f25	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f26	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f27	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f28	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f29	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f2a	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f2b	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f2c	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f2d	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f2e	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f2f	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f30	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f31	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f32	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f33	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f34	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f35	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f36	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f37	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f38	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f39	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f3a	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f3b	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f3c	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f3d	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f3e	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f3f	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f40	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f41	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f42	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f43	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f44	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f45	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f46	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f47	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f48	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f49	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f4a	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f4b	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f4c	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f4d	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f4e	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f4f	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f50	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f51	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f52	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f53	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f54	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f55	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f56	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f57	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f58	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f59	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f5a	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f5b	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f5c	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f5d	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f5e	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f5f	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f60	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f61	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f62	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f63	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f64	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f65	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f66	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f67	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
7f68	0	A teleport block, that teleports the player when the Cursor sprite clicks over it.
200 0 Tile that can be used with Lunar Magic's Layer 3 tide Act As feature.
201 0 Tile that can be used with Lunar Magic's Layer 3 tide Act As feature.
202 0 Tile that can be used with Lunar Magic's Layer 3 tide Act As feature.
203 0 Tile that can be used with Lunar Magic's Layer 3 tide Act As feature.
204 0 Tile that can be used with Lunar Magic's Layer 3 tide Act As feature.
205 0 Tile that can be used with Lunar Magic's Layer 3 tide Act As feature.
206 0 Tile that can be used with Lunar Magic's Layer 3 tide Act As feature.
207 0 Tile that can be used with Lunar Magic's Layer 3 tide Act As feature.
208 0 Tile that can be used with Lunar Magic's Layer 3 tide Act As feature.
209 0 Tile that can be used with Lunar Magic's Layer 3 tide Act As feature.
20A 0 Tile that can be used with Lunar Magic's Layer 3 tide Act As feature.
330 0 Arrow pointing down.
331 0 Arrow pointing left.
340 0 Arrow pointing right.
341 0 Arrow pointing up.
3C6 0 Upper left part of large circular line guide.
3C7 0 Upper left part of large circular line guide.
3D6 0 Upper left part of large circular line guide.
3D7 0 Upper left part of large circular line guide.
3E6 0 Lower left part of large circular line guide.
3E7 0 Lower left part of large circular line guide.
3F6 0 Lower left part of large circular line guide.
3F7 0 Lower left part of large circular line guide.
3C8 0 Upper right part of large circular line guide.
3C9 0 Upper right part of large circular line guide.
3D8 0 Upper right part of large circular line guide.
3D9 0 Upper right part of large circular line guide.
3E8 0 Lower right part of large circular line guide.
3E9 0 Lower right part of large circular line guide.
3F8 0 Lower right part of large circular line guide.
3F9 0 Lower right part of large circular line guide.
3CE 0 Upper left part of small circular line guide.
3CF 0 Upper right part of small circular line guide.
3DE 0 Lower left part of small circular line guide.
3DF 0 Lower right part of small circular line guide.
3CA 0 Horizontal line guide. Sprite can be placed one tile ABOVE and still be on the line.
3DA 0 Horizontal line guide. Sprite can be placed one tile BELOW and still be on the line.
3CB 0 Horizontal line guide end.
3DB 0 Horizontal line guide end.
3EA 0 Vertical line guide. Sprite can be placed one tile LEFT and still be on the line.
3EB 0 Vertical line guide. Sprite can be placed one tile RIGHT and still be on the line.
3FA 0 Vertical line guide end.
3FB 0 Vertical line guide end.
3EC 0 -45 degree line guide.
3ED 0 45 degree line guide.
3FC 0 45 degree ON/OFF line guide.
3FD 0 -45 degree ON/OFF line guide.
3CC 0 Part of leftward steep line guide.
3DC 0 Part of leftward steep line guide.
3CD 0 Part of rightward steep line guide.
3DD 0 Part of rightward steep line guide.
3EE 0 Part of rightward gradual line guide.
3EF 0 Part of rightward gradual line guide.
3FE 0 Part of leftward gradual line guide.
3FF 0 Part of leftward gradual line guide.

; Don't add blocks here!
; Blocks must be added to the list above the "@dsc" section.