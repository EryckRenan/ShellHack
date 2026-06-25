This UberASM was borrowed from Flux () leveraging built in functionalities.

The actual asm that allows for player to be hurt/die from muncher/enemy after collecting goal is an ASAR Patch.

Keep in mind it doesn leverage !FreeRAM = $0E0B



Instructions How To Use:

1) Add the UberAsm to the level # intending to use in UberASM list.txt:

	GoalPowerupCheck/HurtAfterGoalCondition.asm

2) In the Calisto folder, add an extra line in the Patches.toml file:

	"{patches_folder}/custom/HurtAfterGoalCondition.asm"