; Start level with on/off state set to off
; By: imamelia
; https://smwc.me/671814

load:
	LDA #$01
	STA $14AF|!addr
	RTL