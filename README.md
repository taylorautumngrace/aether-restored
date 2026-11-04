Aether Restored - primarily made by @aspect.of.autumn, @.rezerorem, and @niceornotnice

This mod, as of Version 1.2.1, is broken down into an audio folder, an images folder, and a scripts folder.

This mod's GSCs were assisted by AI; specifically in finding the correct functions to call and debugging.


----------- Audio Folder Breakdown -----------
- Replaces the 1911 SFX with the BO1 1911 SFX.
- Replaces all announcer voicelines with their earliest iteration - usually Samantha from BO1.
- Replaces the Miserable Bastille SFX with the BO1 FAL SFX
- Replaces the Dreadful Dresden SFX with the BO1 MP40 SFX
- Replaces the Stormwrought Pantheon SFX with the BO1 Olympia SFX
- Replaces the Ray Gun SFX with the BO1 Ray Gun SFX
- Replaces the round change music with the BO1 round change music
- Replaces the AN94 SFX with the BO2 AN94 SFX
- Replaces the "eternal perk" announcer voiceline on all maps with the "Acquire Perma Perk" SFX from BO2.
- Replaces the fire sale jingle with the BO2 fire sale jingle
- Replaces the MK35 ISR SFX with the BO2 M27 SFX
- Replaces the Origins box SFX with that of the BO2 Origins box
- Replaces the Ray Gun MK2 SFX with that of the BO2 Ray Gun MK2
- Replaces the VSR Recon SFX with that of the BO2 DSR 50. SFX
- Replaces the last stand SFX with the BO3 last stand SFX.
- Replaces the level up SFX with the ones from BO3.
- Replaces the VMP SFX with the BO3 VMP SFX
- Replaces the zombies loading music with that of BO4's
- Replaces the round change SFX with that of BO4's
- Replaces the TEDD Task music with the Golden Pack-a-Punch theme from Tag Der Toten.
- Replaces the exfil music with the one from BOCW.
- Replaces Paradox Junction's normal box jingle with the classic box jingle.
- Replaces the Pack-A-Punch gun SFX with the BO1 SFX.
- Replaces the Quick Revive jingle with its BO1 jingle.
- Replaces the special round music with the classic versions.
- Replaces the game over music with classic-style sneak peaks of next map EE songs.
- Replaces the Menu, Endgame, Multiplayer, and Warzone themes with Adrenaline from BO2.
- Replaced Damned 8 with Damned 100AE
- Replaces the Bloodthirsty Papasha SFX with that of the WAW PPSH.
- Replaces the zombie noises with those from Zombies Chronicles

---- Zombies Better Slaylist ----

All Slaylist songs have been replaced! The new songs are:

- The One		 	                | Elena Siegman, Kevin Sherwood			                   	 | Shi No Numa
- Beauty of Annihilation     	| Elena Siegman, Kevin Sherwood			                   	 | Der Riese 
- 115 			                 	| Elena Siegman, Kevin Sherwood			 	                   | Kino Der Toten
- Abracadavre 		           	| Elena Siegman, Kevin Sherwood			 	                   | Ascencion
- Not Ready To Die	 	        | Avenged Sevenfold					                             | Call of the Dead
- Pareidolia 		 	            | Elena Siegman, Kevin Sherwood				                   | Shangri-La 
- Nightmare 		             	| Avenged Sevenfold					                             | Moon
- Carrion		                 	| Clark S. Nova, Kevin Sherwood			 	                   | Tranzit
- Shepherd of Fire	 	        | Avenged Sevenfold					                             | Origins
- Archangel		 	              | Elena Siegman, Malukah, Clark S. Nova, Kevin Sherwood  | Origins
- Snakeskin Boots	 	          | Rick Riso, Jack Wall					                         | Shadows of Evil
- The Gift		 	              | Elena Siegman, Kevin Sherwood			 	                   | Revelations
- Drowning		 	              | Malukah, Kevin Sherwood				                         | Voyage of Despair
- Mystery		 	                | Elena Siegman, Kevin Sherwood				                   | Dead of the Night
- Alone			 	                | Clark S. Nova, Kevin Sherwood			 	                   | Die Maschine
- Destroy Something Beautiful	| Cristina Scabbia, Kevin Sherwood			                 | Liberty Falls
- Slave				                | Vicky Psarakis, Kevin Sherwood			                   | Citadelle Des Morts
- Falling to Pieces		        | Malukah, Kevin Sherwood				                         | Shattered Veil
- Remember Us			            | Elena Siegman, Kevin Sherwood				                   | Reckoning
- Turn to Ashes			          | Elena Siegman, Kevin Sherwood				                   | Ashes of the Damned
- Come Back Down		          | Megan Rice, Kevin Sherwood			                     	 | Paradox Junction
- No One There			          | Vicky Psarakis, Kevin Sherwood			                   | Totenreich
- Evencry			                | Malukah, Cole Rolland, Kevin Sherwood			             | Kowakujo

zm_slaylist_times.gsc is needed due to times of new songs varying from the default ones.


----------- Images Folder Breakdown -----------

---- Perks ----
- Adds the Black Ops 1 perk icons, but with an alternative Melee Macchiato, Elemental Pop and Mystery Perk.
- Adds the Black Ops 2 perk icons, but with an alternative Melee Macchiato, Elemental Pop, and Mystery Perk.
- Adds the Black Ops 3 perk icons.
- Adds the Black Ops 3 perk icons, but with an alternative Elemental Pop.
- Adds the Black Ops 3 Shadows of Evil perk icons.
- Adds the Black Ops 3 Shadows of Evil perk icons, but with an alternative Elemental Pop.
- Adds the Black Ops 4 perk icons.

---- Powerups ----
- Adds the Black Ops 3 powerup icons.
- Adds the Black Ops 3 Shadows of Evil powerup icons.
- Adds the Black Ops 4 powerup icons.


----------- Scripts Folder Breakdown -----------

---- zm_armor_health_rework.gsc ----
- Armor and Health system reworked! Made with code snippets from @grum_sudo and @i0v
- BO3 health and damage values, with no damage scaling. 
- Armor now always functions as if Turtle Shell was on.
- Armor plates now always auto-equip, as if Armormatic was on. They restore 20% of a plate of armor instead of a full one
- Turtle Shell now makes armor slowly regenerate over time -  6.5 second delay and a tick of every 0.35 seconds.
- Armormatic has been reworked to be a 50% armor plate heal, over the default 20%.
- T2 armor now costs 5000. T3/Golden armor no longer exists: buying armor again at T2 refills it instead of upgrading.
- Tweaked Boss/Elite/Special damage.

---- zm_classic_behavior.gsc ----
- All armored zombies have been removed from the spawn pool; for the time being, this includes the Agni zombies on Kowakujo.
- Zombie speed has been limited to be at 90% of their max speed.

---- zm_classiclike_perks.gsc ----
- Perks now have their BO3 prices, except for Elemental Pop (3500), Wisp Tea (2000), and Death Perception (2000).
- Wunderfizz is now random, and costs 3500 per perk.
- Once a player has every perk, you can return to the Wunderfizz and buy a random eternal perk for 8000.


FULL CREDITS:

- @aspect.of.autumn	       | BO2 Eternal Perk, BO3 Level Up, BO4 TEDD Task, BOCW Exfil, Non-ZM SFX. BO1/2/3/SOE Alternative perk packs. "Better Slaylist". zm_armor_health_rework.gsc, zm_classic_behavior.gsc.

- @.rezerorem		       	   | BO1 announcer, Ray Gun, Round Change; BO2 fire sale, Origins Box; BO3 last stand; classic box jingle, power ups, Quick Revive jingle, special round; Zombie SFX

- @niceornotnice  	       | BO1 1911, Dreadful Dresden, Miserable Bastille, Stormwrought Pantheon; BO2 AN94, MK35 ISR, Ray Gun MK2, VS Recon; BO3 VMP; BO4 Round Change, Classic Pack-A-Punch gun; WAW PPSH SFX. BO3/SOE perk packs.

-  @phdflopperguy5		       | BO1/BO2/BO3/SOE/BO4 powerup packs, BO4 perk pack

- @siguess420		      	   | Damned 100AE, BO1/2 Alternative perk packs.

- @mistergeneric		       | Classic style game over music.

- @i0v		      	         | zm_armor_health_rework.gsc.

- @doefiend		       	     | BO2 Alternative perk pack.

- @grum_sudo		       	   | zm_classic_behavior.gsc.

- @TheVanguardShinobi	     | Extensive testing.


---- TO-DO BEFORE REV 2 ----
- Ability to buy the eternal version of a perk you own from that perk's own machine for 10000 in "Classic-like Perks"
- Survival maps have reduced Wunderfizz prices in "Classic-Like Perks"
- Create and integrate a "Disabled Crafting Table" GSC.
- Create and integrate "Better Perks" GSC.
- Create and integrate "Gobblegum Tweaks" GSC.
- Classic AI/Spawning, Agni restoration in "Classic Zombie Behavior".
- Potential bug fixes from Version 1.
