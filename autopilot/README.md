# Autopilot New

*This is authored by AdamMil01 and significatly modified by me. Original is available [here][original]*

This mod adds some automation and quality-of-life improvements to battles: fast item switching, auto-passing, auto-shieldwalling, ignoring bros and AI control. Also automatically uses some skills at the end of your turn - reload, break free, wake up ally and recover when it makes sense.


## Install

Download a zip from [NexusMods][] and put it into `data` dir. Requires [stdlib][], [Modern Hooks][ModernHooks] and [msu][].


## Configuration

It is possible to configure whether bros will free themselves and other bros from nets, webs and sleep and auto reload if some AP left at end turn. Also, there is a way to show AI debug for auto bros. Press Esc -> Mod Options -> Autopilot New. Consult field tooltips there for more info.


## Compatibility

Is always safe to add or remove. Only uses hooks now, no overwritten files.

Tested with:
- Swifter
- Reforged (some active skills won't be used)
- Legends
- Accessory Companions (including Legends)
- North Expansion
- Heroic Scenario Pack
- Fantasy Brothers (only some custom skills will be used)
- Proper Necromancer (uses Raise Undead and Possess)


## Limitations

AI mode uses military melee and ranged agents to control your bros. Some behaviors and fixes are added on top, see in the next section, however, some behaviors are just not there and I did't have time to implement them myself - doing this as well as testing them is really time consuming.

So, what auto bros won't do currently (probably, not an exhaustive list):

- change ammo
- throw grenades, holy water, acid
- use poison, bandages
- taunt
- use any active skills from other mods, unless added to some common behavior by their mod or mentioned lower, i.e. Sprint from Reforged, which are not used by enemy military
- use custom weapon skills that are not used by enemies, unless added here manually

The last two points might be fixed easy enough if there are behaviors in that mod. So *contact me* to add those to autopilot agent.

Another thing with AI is its evaluation happens in parallel to whatever is shown on the battlefield, i.e. an archer thinks about next move/target, while arrow is still in the air, this may lead to the archer finishing his turn because no AP left, lossing possible +4 AP from Berserk. So enemies dying, zombies raising might not be accounted when a behavior is calculated. It may lead to suprising and funny behavior or on kill effects not used properly as in the archer example. Most often this simply makes game crash, i.e. when that archer tryies to shoot a dead enemy. Autopilot New fixes the vast majority of such crashes.

There is a `::Const.AI.ParallelizationMode` constant in the game, which might be set to false to make many of such crashes/bugs go away, but the delayed effects of some actions, like ranged attacks, will still go in parallel to some thinking, so the archer above will still try to shoot dead enemies, which crashes. Autopilot fixes some of such crashes but not all. Also, setting that to false makes combat slower, everybody takes their time to think, mostly noticable on ranged units.


## Changes from the Original Mod

Aside from better compatibility my modifications to auto bros behavior include:

- better attack default behavior, especially for weapons with several significantly different skills and throwing bros
- use rally the troops, adrenalin, line breaker, lunge, deathblow skills
- pick up a weapon
- throw nets, unleash dogs, beat the drum
- equip a net or a shield from bag (completely new behaviors)
- much better Raise Undead behavior
- mind spent fatigue more when thinking of using shield wall, split shield, adrenaline, rotation, knock back and disengage
- specific improvements to 2-tile bros:
    - more active overall, move and attack more, wait less
    - do not hide behind throwing bros
- specific improvements to throwing bros:
    - lock into melee less
    - do not be afraid of throwing over the shoulder of an ally
    - do not move next to an ally to protect him, i.e. like a melee bro
    - account for missile diversion properly

Support some skills from third-party mods:

- many skills from Reforged are used
- support custom weapons from CleverFool's mod
- use custom active skills from Heroic Scenario Pack
- beat the barbarian drum from North Expansion
- unleash companions and tame from AC (Accessory Companions)
- some skills from Fantasy Brothers
- many sorts of necromancers will do their thing

Other additions:

- a way to debug AI for bros, not only for enemies
- MSU Mod options to enable and disable some behaviors

Fixes:

- no disappearing buttons or status icons anymore
- removed always active "Run them down" / "It's over" in AI mode
- hide skills and other UI buttons when auto waiting, skipping turn or on AI
- immediately act after switching to auto, no skipping turn anymore
- fixed many many crashes in combat AI
- more compatibility, see above


[NexusMods]: https://www.nexusmods.com/battlebrothers/mods/675
[ModernHooks]: https://www.nexusmods.com/battlebrothers/mods/685
[stdlib]: https://www.nexusmods.com/battlebrothers/mods/676
[modhooks]: https://www.nexusmods.com/battlebrothers/mods/42
[msu]: https://www.nexusmods.com/battlebrothers/mods/479
[original]: https://www.nexusmods.com/battlebrothers/mods/62
