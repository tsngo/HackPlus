Gain 5 or 3 hacking skill points after each successful hack depending on difficulty of hack attempted or 1 point for failed hack. All point gain is configable using ini. 

Rewards can be randomized using ini setting. I also left debug settings in the ini which makes hacks always succeed and makes them not cost an action (similar to lightning hands). These are off by default. 

Inspiration came from watching ChristopherOdd's Legend Ironman playthrough on YouTube. Techno-bable follows: This mod uses UIScreenListener to modify FinalizeHack and FinalizeIntrusion templates from X2Ability_DefaultAbilitySet and X2Ability_SpecialistAbilitySet classes. Anything that modifies hacking in these two templates will likely conflict. 

v1.1 
Added tiers for success reward 
Added a on fail reward 
Added randomize reward flag 
Added fly over text on unit to indicate point gain 
Changed preview picture 

v1.0 
Initial version 
+5 gain for every successful hack