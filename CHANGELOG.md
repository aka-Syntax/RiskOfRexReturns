### v1.1.3

* Forgot to change flower cooldown back to normal :p
* Fixed flower not lifestealing
* Updated lifesteal trail; produces a constant line regardless of distance 

* Damage 10+2.8 -> 10+3
* INJECT debuff cap 999 -> 10

*This probably should have come earlier, whoops. Now, the max -armor you can get from just using INJECT is -30, which aligns with RoR2 weaken's -30 armor.*

* INJECT lifesteal 40% -> 30%
* Mortar damage 250% -> 200%
* Removed extra Mortar charge
* Disperse damage 30% -> 50%
* Flower damage 8x50% -> 8x100%
* Lifesteal 20% -> 25%
* Boosted: Damage 8x80% -> 8x135%, Lifesteal 35% -> 40%

*With these changes I'm a little happier with where REX is in terms of the push and pull of your health. With the Inject -armor nerf you don't heal as much from lifesteal anymore, so you might actually want to click on a healing item every now and then. You're still pretty likely to kill everything if you just throw all your abilities out and spam Mortar, but you'll constantly be at around 50% health or lower, which can be pretty dangerous. You also lose out on #1 iframe generator (Prophet's Cape) for the crime of existing as REX.*

### v1.1.2
* Fixed backwards walk animation playing in reverse

### v1.1.1
* WHOOPS

### v1.1.0

Mini-ish update, nothing major/no new content; just wanted to put this out while I have the luxury to work on this.

* Update ALL Sprites
	* This includes the prior missing sprites, including Decoy, Death, and Multiplayer Drones
	* Todo: Mortar explosion, New Select animation, Logbook entry
* REX now appears in the select screen between their friends Mercenary and Loader :D (like ror2)
* All skills now have updated visuals for lifesteal (like ror2)
* Inject third syringe now has a trail (like ror2)
	
*All 3 having trails looked messy. I also haven't been able to figure out how to make them fire in a fan (or if I even want them to, but probably not), so I think only the third one having a trail is fine.*

* Mortar now starts with 2 charges
* Damage 280% -> 250%

*Trying to cut a little down on spam-clicking pains, now you can double-tap instead of destroying your finger. I didn't test this at all so be sure to lmk how this plays.*

* SATURATE skill retired for now

*I want to think a little harder about any alts I want before I commit to adding them; Saturate was just easy to make because of how similar it was to Mortar. If you still want to play with it (for whatever reason), you can just un-comment the relevant code.*

* Flower has updated viduals
	* Now has an animation for opening up after landing, as well as an idle animation
	* Now no longer gets stuck grotesquely in the floor
	* Todo: Tether vfx between enemy and flower
	* Todo: Cap tethered enemies? Split damage between tethered enemies? idk

Next up on the docket is likely going to be networking and skins. Apparently Zerimp released with skins straight up so I'll definitely be looking into that. Networking is going to be a pain in the ass so it might take a long ass while though. 

alabaster dawn early access is out now GO PLAY IT

### v1.0.5

* Scepter Upgrade: Ravenous Growth
	* Massively increased range. Slightly increased damage, and lifesteal

*A lot of Scepter upgrades are actually pretty disappointing. This one should be in the upper end in terms of increases in power level.*

- Mortar horizontal range 250 -> 350
- Fixed Barrage not working (lol)

* DISPERSE now applies a weaker knockback and recoil if tapped, behaving normally if otherwise held
* DISPERSE now applies a minor amount of vertical force if used in the air
* DISPERSE cooldown 6s -> 5s

*For when you want to DISPERSE for the healing/debuffs without launching enemies out of range. The Afterburner stuff still works exactly the same. If reception to this is lukewarm I may ditch this entirely, but I always wanted DISPERSE to have this functionality because of how absurdly broken RoR2 Tangling Growth is.*

### v1.0.4

Next update is going to include charge-able DISPERSE and (finally) the Scepter upgrade. I wanted to push this update first because it fixes a really important bug.

* Damage: 12+3 -> 10+2.8
* Regeneration reduced: 0.6+0.1 -> 0.5+0.15
* INJECT armor debuff -4, 6s -> -3, 4s
* INJECT lifesteal 30% -> 40%
* Mortar damage 350% -> 300%
* Growth lifesteal 25% -> 20%

- Mortar no longer fires twice in a single skill use when held down for long enough with multiple skill charges

*Thanks to ANXvariable for the assist.*

* Mortar no longer causes rendering issues with certain VFX

*For once I actually played a run to test this. REX should no longer cause any abrupt screen flashing or game crashes, sorry about that.*

### v1.0.3
* Mortar radius reduced from 75 to 60
* Growth damage reduced from 150% to 50%
* Growth lifesteal increased from 15% to 25%
* Mortar can be canceled into itself, allowing for rapid fire
* DISPERSE can be canceled by climbing
* DISPERSE push force is more consistent (i think)
* DISPERSE can be used in quick succession to wavedash

*Thanks to ANXvariable for the assist.*

* Fixed Growth inconsistent pull strength (for the last time)

*Flower used to create a pull object for every enemy in its range, then each object would pull every enemy within its range towards it. Now it only pulls each enemy once.*

### v1.0.2
* New Secondary: SATURATE 
    * Fires a barrage of stunning missiles at the targeted location
* INJECT damage reduced from 3x40% to 3x30%
* INJECT lifesteal reduced from 50% to 30%
* DISPERSE damage reduced from 50% to 30%
* DISPERSE lifesteal reduced from 75% to 60%
* Tangling Growth damage reduced from 8x150% to 8x120%

*Thinking about reducing REX's base damage stat to cut their damage output across the boatd. A thing I'm noticing is that the healing output is still a lot compared to your self-damage output.*

* Fixed Special not pulling harshly enough

Next up is probably going to be the Scepter upgrade, then after that the new sprites/visuals. I wanted to push this update out first because god dammit i broke the special AGAIN

### v1.0.1
* Fixed God punishing you for clicking the Special button

### v1.0.0
* Initial release