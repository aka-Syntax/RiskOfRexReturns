-- risk of rex returns
local envy = mods["LuaENVY-ENVY"]
envy.auto()
mods["ReturnsAPI-ReturnsAPI"].auto{
	namespace = "rex",
	mp = false
}

local PATH = _ENV["!plugins_mod_folder_path"]
local NAMESPACE = "aka_Syntax"
local SPRITE_PATH = path.combine(PATH, "Sprites")
local SOUND_PATH = path.combine(PATH, "Sounds")

-- ========== Main ==========

local function initialize()
  local rex = Survivor.new("rex")
	-- how the hell do i put this guy inbetween merc and laoder

	-- Sprites
	local sprite_select = 				Sprite.new("rexSelect", path.combine(SPRITE_PATH, "select.png"), 23, 56, 0)
	local sprite_skills =				Sprite.new("RexSkills", path.combine(SPRITE_PATH, "skills.png"), 6)
	local sprite_portrait =				Sprite.new("RexPortrait", path.combine(SPRITE_PATH, "portrait.png"), 3)
	local sprite_portrait_small =		Sprite.new("RexPortraitSmall", path.combine(SPRITE_PATH, "portraitSmall.png"))
	local sprite_palette = 				Sprite.new("RexPalette", path.combine(SPRITE_PATH, "palette.png"))
	local sprite_credits = 				Sprite.new("RexCredits", path.combine(SPRITE_PATH, "credits.png"))

	local sprite_idle = 				Sprite.new("RexIdle", path.combine(SPRITE_PATH, "idle.png"), 1, 20, 36)
	local sprite_idle_half = 			Sprite.new("RexIdleHalf", path.combine(SPRITE_PATH, "idleHalf.png"), 1, 20, 36)
	local sprite_walk = 				Sprite.new("RexWalk", path.combine(SPRITE_PATH, "walk.png"), 4, 23, 36)
	local sprite_walk_half = 			Sprite.new("RexWalkHalf", path.combine(SPRITE_PATH, "walkHalf.png"), 4, 23, 36)
	local sprite_jump = 				Sprite.new("RexJump", path.combine(SPRITE_PATH, "jump.png"), 1, 20, 35)
	local sprite_jump_half = 			Sprite.new("RexJumpHalf", path.combine(SPRITE_PATH, "jumpHalf.png"), 1, 17, 11)
	local sprite_jump_peak = 			Sprite.new("RexJumpPeak", path.combine(SPRITE_PATH, "jumpPeak.png"), 1, 20, 35)
	local sprite_jump_peak_half = 		Sprite.new("RexJumpPeakHalf", path.combine(SPRITE_PATH, "jumpPeakHalf.png"), 1, 18, 12)
	local sprite_fall = 				Sprite.new("RexFall", path.combine(SPRITE_PATH, "jumpFall.png"), 1, 20, 35)
	local sprite_fall_half = 			Sprite.new("RexFallHalf", path.combine(SPRITE_PATH, "jumpFallHalf.png"), 1, 19, 13)
	local sprite_climb = 				Sprite.new("RexClimb", path.combine(SPRITE_PATH, "climb.png"), 5, 17, 26)
	-- sprite_climb:set_speed(2.5) -- why does this not work vro

	local sprite_shoot_1 = 				Sprite.new("RexShoot1", path.combine(SPRITE_PATH, "shoot1.png"), 10, 17, 36)
	local sprite_shoot_2_aim = 			Sprite.new("RexShoot2Aim", path.combine(SPRITE_PATH, "shoot2aiml.png"), 1, 25, 59)
	local sprite_shoot_2 = 				Sprite.new("RexShoot2", path.combine(SPRITE_PATH, "shoot2real.png"), 5, 25, 59)
	local sprite_shoot_3 = 				Sprite.new("RexShoot3", path.combine(SPRITE_PATH, "shoot3.png"), 6, 24, 36)

	local sprite_syringe = 				Sprite.new("RexSyringe", path.combine(SPRITE_PATH, "syringe.png"), 1, 13, 5)
	local sprite_syringe_big = 			Sprite.new("RexSyringeBig", path.combine(SPRITE_PATH, "syringeBig.png"), 1, 18, 8)
	local sprite_debuff_break = 		Sprite.new("RexDebuffBreak", path.combine(SPRITE_PATH, "debuffBreak.png"), 1, 9, 11)
	local sprite_debuff_weaken = 		Sprite.new("RexDebuffWeaken", path.combine(SPRITE_PATH, "debuffWeaken.png"), 1, 12, 12)

	local sprite_flower = 				Sprite.new("RexFlower", path.combine(SPRITE_PATH, "flowerSeed.png"), 1, 10, 10)
	local sprite_flower_bloom = 		Sprite.new("RexFlowerBloom", path.combine(SPRITE_PATH, "flowerBloom.png"), 8, 10, 10)
	local sprite_flower_idle = 			Sprite.new("RexFlowerIdle", path.combine(SPRITE_PATH, "flowerIdle.png"), 1, 21, 25)
	local sprite_flower_pull = 			Sprite.new("RexFlowerPull", path.combine(SPRITE_PATH, "flowerPull.png"), 8, 10, 10)

	-- Sounds
	local sound_select = 				Sound.new("rexSelect", path.combine(SOUND_PATH, "select.ogg"))
	local sound1_shoot = 				Sound.new("rexShoot1_Shoot", path.combine(SOUND_PATH, "shoot1_shoot.ogg"))
	local sound1_hit = 					Sound.new("rexShoot1_Hit", path.combine(SOUND_PATH, "shoot1_hit.ogg"))
	local sound1_3hit = 				Sound.new("rexShoot1_3Hit", path.combine(SOUND_PATH, "shoot1_3hit.ogg"))

	local sound2_launch = 				Sound.new("rexShoot2_Launch", path.combine(SOUND_PATH, "shoot2_launch.ogg"))
	local sound2_impact = 				Sound.new("rexShoot2_Impact", path.combine(SOUND_PATH, "shoot2_hit.ogg"))

	local sound3_charge = 				Sound.new("rexShoot3_Charge", path.combine(SOUND_PATH, "shoot3_charge.ogg"))
	local sound3_shoot = 				Sound.new("rexShoot3_Shoot", path.combine(SOUND_PATH, "shoot3_shoot.ogg"))

	local sound4_shoot = 				Sound.new("rexShoot4_Shoot", path.combine(SOUND_PATH, "shoot4_shoot.ogg"))
	local sound4_impact = 				Sound.new("rexShoot4_Impact", path.combine(SOUND_PATH, "shoot4_hit.ogg"))
	local sound4_pull = 				Sound.new("rexShoot4_Pull", path.combine(SOUND_PATH, "shoot4_pull.ogg"))
	local sound4_expire = 				Sound.new("rexShoot4_Expire", path.combine(SOUND_PATH, "shoot4_expire.ogg"))

	rex:set_stats_base({
		health = 120,
		damage = 11,
		regen = 0.05
	})

	rex:set_stats_level({
		health = 44,
		damage = 2.75,
		regen = 0.01,
		armor = 3
	})

	rex.sprite_portrait = sprite_portrait
	rex.sprite_portrait_small = sprite_portrait_small
	rex.sprite_loadout = sprite_select

	rex.sprite_idle = sprite_idle
	rex.sprite_title = sprite_walk
	rex.sprite_credits = sprite_credits

	rex.sprite_palette = sprite_palette
	rex.sprite_portrait_palette = sprite_palette
	rex.sprite_loadout_palette = sprite_palette

	rex.primary_color = Color.from_rgb(151, 177, 95)
	-- rex.select_sound_id = sound_select
	rex.cape_offset = Array.new({-5, -7, 0, 3})

	Callback.add(rex.on_init, function(actor)
		actor.sprite_idle_half = Array.new({sprite_idle, sprite_idle_half, 0})
		actor.sprite_walk_half = Array.new({sprite_walk, sprite_walk_half, 0})
		actor.sprite_jump_half = Array.new({sprite_jump, sprite_jump_half, 0})
		actor.sprite_jump_peak_half = Array.new({sprite_jump_peak, sprite_jump_peak_half, 0})
		actor.sprite_fall_half = Array.new({sprite_fall, sprite_fall_half, 0})

		actor.sprite_idle = sprite_idle
		actor.sprite_walk = sprite_walk
		actor.sprite_jump = sprite_jump
		actor.sprite_jump_peak = sprite_jump_peak
		actor.sprite_fall = sprite_fall
		actor.sprite_climb = sprite_climb

		actor:survivor_util_init_half_sprites()
	end)

	-- set skills
	local primary = rex:get_skills(Skill.Slot.PRIMARY)[1]
	local secondary = rex:get_skills(Skill.Slot.SECONDARY)[1]
	local utility = rex:get_skills(Skill.Slot.UTILITY)[1]
	local special = rex:get_skills(Skill.Slot.SPECIAL)[1]
	-- local specialUpgrade = Skill.new("rexVUpgrade")

	local secondary2 = Skill.new("rexX2")
	rex:add_skill(Skill.Slot.SECONDARY, secondary2)

	-- magic number bullshit
	local SHOOT1_DAMAGE = 0.3
	local SHOOT1_SPEED = 20
	local SHOOT1_LIFETIME = 2 * 60
	local SHOOT1_LIFESTEAL = 0.3
	local BREAK_DEBUFF_DURATION = 4 * 60

	local SHOOT2_DAMAGE = 3
	local SHOOT2_DELAY = 0.5 * 60
	local SHOOT2_COOLDOWN = 0.8 * 60
	local SHOOT2_RADIUS = 60

	local SHOOT3_DAMAGE = 0.3
	local SHOOT3_KNOCKBACK = 6.5
	local SHOOT3_RECOIL = 3.5
	local SHOOT3_LIFESTEAL = 0.5
	local WEAKEN_DEBUFF_DURATION = 3 * 60

	local SHOOT4_DAMAGE = 0.5
	local SHOOT4_TICK_TIME = 90
	local SHOOT4_PULSES = 8
	local SHOOT4_RADIUS = 160
	local SHOOT4_PULL_LIFETIME = 0.2 * 60
	local SHOOT4_LIFESTEAL = 0.15

	local SHOOT4S_DAMAGE = 0.5
	local SHOOT4S_TICK_TIME = 90
	local SHOOT4S_PULSES = 8
	local SHOOT4S_RADIUS = 160
	local SHOOT4S_PULL_LIFETIME = 0.2 * 60
	local SHOOT4S_LIFESTEAL = 0.15

	local SHOOT2B_DAMAGE = 2.0
	local SHOOT2B_LIFETIME = 2 * 60
	local SHOOT2B_BOMBS = 8
	local SHOOT2B_DELAY = 0.25 * 60
	local SHOOT2B_RADIUS = 100

	local ATTACK_TAG_SYRINGE = 1
	local ATTACK_TAG_SYRINGE_B = 2
	local ATTACK_TAG_BOOM = 3
	local ATTACK_TAG_GROWTH = 4

	-- Self-damage function
	-- just doing what midas does
	local DAMAGE_INFLICT_FLAGS = {
		ignore_armor = 1 << 0,
		nonlethal = 1 << 1,
		pierce_shield = 1 << 2,
		ignore_invincibility = 1 << 3,
	}

	local function rex_inst_damage(actor, percent)
		local flags = DAMAGE_INFLICT_FLAGS.ignore_armor
					+ DAMAGE_INFLICT_FLAGS.nonlethal
					+ DAMAGE_INFLICT_FLAGS.ignore_invincibility
		gm.damage_inflict(actor.id, actor.hp * percent, flags, -4, actor.x, actor.y, actor.hp * percent, 2, Color.GRAY, false);
	end

	-- Function for finding the closest enemy on a line
	-- Re-inventing RoRML functions from first principles
	local function find_horizontal_enemy(actor)
		local dir = actor.image_xscale
		local start_x = actor.x
		local base_y = actor.y - 5

		local closest
		local closest_dist = math.huge

		for _, enemy in ipairs(Instance.find_all(gm.constants.pActor)) do
			if enemy ~= actor and actor:attack_collision_canhit(enemy) then
				if math.abs(enemy.y - base_y) <= 80 then
					if (enemy.x - start_x) * dir > 0 and math.abs(enemy.x - start_x) <= 250 then
						local d = math.abs(enemy.x - start_x)
						if d < closest_dist then
							closest = enemy
							closest_dist = d
						end
					end
				end
			end
		end

		return closest
	end

	local buff_mirror = Buff.find("shadowClone")

	-- Debuffs
	local debuffRexBreak = Buff.new("rexBreak")
	debuffRexBreak.icon_sprite = sprite_debuff_break
	debuffRexBreak.is_timed = true
	debuffRexBreak.is_debuff = true
	debuffRexBreak.show_icon = true
	debuffRexBreak.max_stack = 999
	-- FIGURE OUT HOW TO DO THE STACKING NUMBER STUFF

	RecalculateStats.add(function(actor, api)
		if actor:buff_count(debuffRexBreak) > 0 then
			api.armor_add(-3 * actor:buff_count(debuffRexBreak))
		end
	end)

	local debuffRexWeaken = Buff.new("rexWeaken")
	debuffRexWeaken.icon_sprite = sprite_debuff_weaken
	debuffRexWeaken.is_timed = true
	debuffRexWeaken.is_debuff = true
	debuffRexWeaken.show_icon = true
	debuffRexWeaken.max_stack = 1

	-- reduce armor by -20, slow by 30%
	RecalculateStats.add(function(actor, api)
		if actor:buff_count(debuffRexWeaken) > 0 then
			api.armor_add(-20)
			api.pHmax_mult(0.7)
		end
	end)

	-- INJECT Syringe(s)
	-- Set up syringe projectile
	local objSyringe = Object.new("rexSyringe")
	objSyringe:set_sprite(sprite_syringe)

	Callback.add(objSyringe.on_create, function(inst)
		inst.speed = SHOOT1_SPEED
		inst.lifetime = SHOOT1_LIFETIME
	end)

  	Callback.add(objSyringe.on_step, function(inst)
		inst.lifetime = inst.lifetime - 1
		if inst.lifetime < 0 then
			inst:destroy()
		end

		for _, actor in ipairs(inst:get_collisions(gm.constants.pActorCollisionBase)) do
			if inst.parent:attack_collision_canhit(actor) then
				local direct = inst.parent:fire_direct(actor, primary.damage, inst.direction, inst.x, inst.y).attack_info
				direct.__rex_info = ATTACK_TAG_SYRINGE

				gm.sound_play_at(sound1_hit.value, 0.7, 0.6 + math.random() * 0.1, inst.x, inst.y)
				inst:destroy()
				return
			end
		end

		if inst:is_colliding(gm.constants.pSolidBulletCollision) then
			inst:destroy()
			return
		end
	end)

	local objSyringeBreak = Object.new("rexSyringeBreak")
	objSyringeBreak:set_sprite(sprite_syringe_big)

	Callback.add(objSyringeBreak.on_create, function(inst)
		inst.speed = SHOOT1_SPEED
		inst.lifetime = SHOOT1_LIFETIME
	end)

  	Callback.add(objSyringeBreak.on_step, function(inst)
		inst.lifetime = inst.lifetime - 1
		if inst.lifetime < 0 then
			inst:destroy()
		end

		for _, actor in ipairs(inst:get_collisions(gm.constants.pActorCollisionBase)) do
			if inst.parent:attack_collision_canhit(actor) then
				local direct = inst.parent:fire_direct(actor, primary.damage, inst.direction, inst.x, inst.y).attack_info
				direct.__rex_info = ATTACK_TAG_SYRINGE_B

				gm.sound_play_at(sound1_3hit.value, 0.7, 0.6 + math.random() * 0.1, inst.x, inst.y)
				inst:destroy()
				return
			end
		end

		if inst:is_colliding(gm.constants.pSolidBulletCollision) then
			inst:destroy()
			return
		end
	end)

	-- Primary: INJECT
	local statePrimary = ActorState.new("rexPrimary")
	primary.sprite = sprite_skills
	primary.subimage = 0
	primary.damage = SHOOT1_DAMAGE
	primary.is_primary = true
	primary.cooldown = 40

	Callback.add(primary.on_activate, function(actor, skill, slot)
		actor:set_state(statePrimary)
	end)

	Callback.add(statePrimary.on_enter, function(actor, data)
		actor.image_index = 0 -- variable used for frame of lower body
		actor.image_index2 = 0 -- variable used for frame of upper body
		data.shots = 0

		actor:skill_util_strafe_init()
		actor:skill_util_strafe_turn_init()
	end)

	Callback.add(statePrimary.on_step, function(actor, data)
		actor.sprite_index2 = sprite_shoot_1
		-- this function animates the upper half-sprite for you and controls the speed multiplier.
		-- takes in the desired sprite speed (gets capped to 1 internally), and move speed multiplier while strafing, ranges around 0.5
    	actor:skill_util_strafe_update(0.45 * actor.attack_speed, 0.45)
		actor:skill_util_step_strafe_sprites()
		actor:skill_util_strafe_turn_update()

		-- fire the bullet every 2nd frame (may change to every 3rd)
		if actor.image_index2 >= data.shots * 2 and data.shots < 3 then
			local dir = actor:skill_util_facing_direction()

			actor.z_count = actor.z_count + 1
			local heaven_cracker_count = actor:item_count(Item.find("heavenCracker"))
			local cracker_shot = false

			if heaven_cracker_count > 0 and actor.z_count >= 5 - heaven_cracker_count then
				cracker_shot = true
				actor.z_count = 0
			end

			for i=0, actor:buff_count(buff_mirror) do
				if actor.image_index2 >= 4 then -- fire big syringe
					if cracker_shot then
						local syringeBlast = actor:fire_bullet(actor.x, actor.y, 700, dir, primary.damage, 1, gm.constants.sSparks1, Tracer.DRILL).attack_info
						syringeBlast.__rex_info = ATTACK_TAG_SYRINGE_B
					else
						local syringe = objSyringeBreak:create(actor.x + (i * 20) + 22 * actor.image_xscale, actor.y - 3)
						syringe.direction = dir
						syringe.image_xscale = actor.image_xscale
						syringe.parent = actor
					end
				else -- fire reg syringe
					if cracker_shot then
						local syringeBlast = actor:fire_bullet(actor.x, actor.y, 700, dir, primary.damage, 1, gm.constants.sSparks1, Tracer.DRILL).attack_info
						syringeBlast.__rex_info = ATTACK_TAG_SYRINGE
					else
						local syringe = objSyringe:create(actor.x + (i * 20) + 7 * actor.image_xscale, actor.y - 5)
						syringe.direction = dir
						syringe.image_xscale = actor.image_xscale
						syringe.parent = actor
					end
				end
			end
			actor:sound_play(sound1_shoot, 0.7, 0.8 + math.random() * 0.2)
			data.shots = data.shots + 1
		end
		actor:skill_util_exit_state_on_anim_end()
	end)

	Callback.add(statePrimary.on_exit, function(actor, data)
		actor:skill_util_strafe_exit()
	end)

	-- SECONDARY: Seed Mortar
	local objMortar = Object.new("rexMortar")
	local objPreview = Object.new("rexMortarPreview")

	Callback.add(objMortar.on_create, function(inst)
		inst.lifetime_max = SHOOT2_DELAY
		inst.lifetime = SHOOT2_DELAY
	end)

	Callback.add(objMortar.on_step, function(inst)
		local data = Instance.get_data(inst)

		inst.lifetime = inst.lifetime - 1
		if inst.lifetime <= 0 then
			for i=0, inst.parent:buff_count(buff_mirror) do
				local hit = inst.parent:fire_explosion(inst.x + (i * 20), inst.y, SHOOT2_RADIUS*2, SHOOT2_RADIUS*2, secondary.damage, gm.constants.sEfSuperMissileExplosion, gm.constants.sSparks12).attack_info
				hit.climb = i * 8 * 1.35
				gm.sound_play_at(sound2_impact.value, 0.5, 0.9 + math.random() * 0.2, inst.x, inst.y)
			end
			inst:screen_shake(5)
			inst:destroy()
		end
	end)

	-- indicator for mortar
	Callback.add(objMortar.on_draw, function(inst)
		local t = 1 - inst.lifetime / inst.lifetime_max
		local radius = (1 - math.exp(-5 * t)) * SHOOT2_RADIUS
		gm.draw_set_colour(Color.from_hsv(0, 0, 100))
		gm.draw_circle(inst.x, inst.y, radius, true)
	end)

	
	Callback.add(objPreview.on_draw, function(inst)
		local actor = inst.parent
		if actor:get_active_skill(1).skill_id == secondary.value then
			if actor.aiming == 1 then
				local target = find_horizontal_enemy(actor)
				if target then
					inst.x = target.x
					inst.y = target.y
				else
					inst.x = actor.x + 150 * actor.image_xscale
					inst.y = actor.y - 5
				end

				gm.draw_set_colour(Color.from_hsv(0, 0, 100))

				for offset = 0, 15 * 35, 35 do
					gm.draw_line_width(inst.x, inst.y - offset, inst.x, inst.y - offset - 20, 1)
				end

				gm.draw_circle(inst.x, inst.y, SHOOT2_RADIUS, true)
			else
				inst:destroy()
			end
		end
	end)

	secondary.sprite = sprite_skills
	secondary.subimage = 1
	secondary.cooldown = SHOOT2_COOLDOWN
	secondary.damage = SHOOT2_DAMAGE
	secondary.does_change_activity_state = true
	secondary.require_key_press = true
	secondary.hold_facing_direction = true
	secondary.override_strafe_direction = true
	secondary.required_interrupt_priority = ActorState.InterruptPriority.ANY

	local stateSecondary = ActorState.new("rexSecondaryAim")
	local stateSecondaryFire = ActorState.new("rexSecondaryShoot")

	Callback.add(secondary.on_activate, function(actor)
		actor:set_state(stateSecondary)
	end)

	Callback.add(stateSecondary.on_enter, function(actor, data)
		actor.image_index2 = 0
		actor:skill_util_strafe_init()
		actor.aiming = 1

		if gm.sign(gm.real(actor.moveRight) - gm.real(actor.moveLeft)) ~= 0 then
			actor.hold_facing_direction_xscale = gm.sign(gm.real(actor.moveRight) - gm.real(actor.moveLeft)) -- stupid dumb idiotic bullshit fuckery, apparently vanilla code also uses that lmao
		else
			actor.hold_facing_direction_xscale = actor.image_xscale
		end

		local preview = objPreview:create(actor.x, actor.y)
		preview.parent = actor
	end)

	Callback.add(stateSecondary.on_step, function(actor, data)
		actor.sprite_index2 = sprite_shoot_2_aim
		local second = ActorSkill.wrap(actor:get_active_skill(1))
		second:freeze_cooldown()

		actor:skill_util_step_strafe_sprites()

		-- if not holding down secondary: exit state
		if not actor:control("skill2", 0) then
			actor.aiming = 0
			actor:set_state(stateSecondaryFire)
		end
	end)

	Callback.add(stateSecondary.on_exit, function(actor, data)
		actor:skill_util_strafe_exit()
	end)

	Callback.add(stateSecondaryFire.on_enter, function(actor, data)
		actor.fired = 0
		actor.image_index2 = 0
		actor:skill_util_strafe_init()
	end)

	Callback.add(stateSecondaryFire.on_step, function(actor, data) 
		actor.sprite_index2 = sprite_shoot_2
		actor:skill_util_strafe_update(0.25 * actor.attack_speed, 0.5)
		actor:skill_util_step_strafe_sprites()

		if actor.fired == 0 then
			rex_inst_damage(actor, 0.12)

			local target = find_horizontal_enemy(actor)

			local spawn_x, spawn_y

			if target then
				spawn_x = target.x
				spawn_y = target.y
			else
				spawn_x = actor.x + 150 * actor.image_xscale
				spawn_y = actor.y - 5
			end

			local oMortar = objMortar:create(spawn_x, spawn_y)
			oMortar.parent = actor

			actor:sound_play(sound2_launch.value, 0.5, 0.9 + math.random() * 0.1)

			actor.fired = 1
		end
		actor:skill_util_exit_state_on_anim_end()
	end)

	Callback.add(stateSecondaryFire.on_exit, function(actor, data)
		actor:skill_util_strafe_exit()
	end)

	Callback.add(stateSecondaryFire.on_get_interrupt_priority, function(actor, data)
		if actor.image_index2 >= 1 then
			return ActorState.InterruptPriority.ANY
		end
	end)

	--
	-- Secondary2: SATURATE
	local objBarrage = Object.new("rexBarrage")
	local objPreview2 = Object.new("rexBarragePreview")

	Callback.add(objBarrage.on_create, function(inst)
		inst.lifetime_max = SHOOT2B_DELAY + SHOOT2B_LIFETIME
		inst.lifetime = SHOOT2B_DELAY + SHOOT2B_LIFETIME
		inst.age = SHOOT2B_DELAY

		local data = Instance.get_data(inst)
		data.boom_timer = 0
	end)

	Callback.add(objBarrage.on_step, function(inst)
		local data = Instance.get_data(inst)

		-- I HATE DOING MATH!!!!!!!!!!!!!!!!!!!!!!!!
		inst.age = inst.age - 1
		inst.lifetime = inst.lifetime - 1
		if inst.lifetime <= SHOOT2B_LIFETIME then
			data.boom_timer = data.boom_timer + 1

			if data.boom_timer >= SHOOT2B_LIFETIME / SHOOT2B_BOMBS then
				data.boom_timer = 0

				local x_offset = gm.random_range(-60, 60)
				local y_offset = gm.random_range(-20, 20)

				for i=0, inst.parent:buff_count(buff_mirror) do
					local hit = inst.parent:fire_explosion(inst.x + x_offset + (i * 20), inst.y + y_offset, 100, 100, secondary2.damage, gm.constants.sEfSuperMissileExplosion, gm.constants.sSparks12).attack_info
					hit.climb = i * 8 * 1.35
					hit.stun = 1
				gm.sound_play_at(sound2_impact.value, 0.5, 0.9 + math.random() * 0.2, inst.x, inst.y)
				end
			end
		end

		if inst.lifetime <= 0 then
			inst:destroy()
		end
	end)

	Callback.add(objBarrage.on_draw, function(inst)
		local data = Instance.get_data(inst)
		local radius

		if inst.lifetime >= SHOOT2B_LIFETIME then
			local t = 1 - (inst.age / SHOOT2B_DELAY)
			radius = (1 - math.exp(-5 * t)) * SHOOT2B_RADIUS
		else
			radius = SHOOT2B_RADIUS
		end
		gm.draw_set_colour(Color.from_hsv(0, 0, 100))
		gm.draw_circle(inst.x, inst.y, radius, true)
	end)

	Callback.add(objPreview2.on_draw, function(inst)
		local actor = inst.parent
		if actor:get_active_skill(1).skill_id == secondary2.value then
			if actor.aiming == 1 then
				local target = find_horizontal_enemy(actor)
				if target then
					inst.x = target.x
					inst.y = target.y
				else
					inst.x = actor.x + 250 * actor.image_xscale
					inst.y = actor.y - 5
				end

				gm.draw_set_colour(Color.from_hsv(0, 0, 100))

				for offset = 0, 15 * 35, 35 do
					gm.draw_line_width(inst.x, inst.y - offset, inst.x, inst.y - offset - 20, 1)
				end
				gm.draw_circle(inst.x, inst.y, SHOOT2B_RADIUS, true)
			else
				inst:destroy()
			end
		end
	end)

	local stateSecondary2 = ActorState.new("rexSecondary2Aim")
	local stateSecondary2Fire = ActorState.new("rexSecondary2Shoot")
	secondary2.sprite = sprite_skills
	secondary2.subimage = 5
	secondary2.cooldown = 6 * 60
	secondary2.damage = SHOOT2B_DAMAGE
	secondary2.required_interrupt_priority = ActorState.InterruptPriority.ANY

	Callback.add(secondary2.on_activate, function(actor)
		actor:set_state(stateSecondary2)
	end)

	Callback.add(stateSecondary2.on_enter, function(actor, data)
		actor.image_index2 = 0
		actor:skill_util_strafe_init()
		actor.aiming = 1

		if gm.sign(gm.real(actor.moveRight) - gm.real(actor.moveLeft)) ~= 0 then
			actor.hold_facing_direction_xscale = gm.sign(gm.real(actor.moveRight) - gm.real(actor.moveLeft)) -- stupid dumb idiotic bullshit fuckery, apparently vanilla code also uses that lmao
		else
			actor.hold_facing_direction_xscale = actor.image_xscale
		end

		local preview = objPreview2:create(actor.x, actor.y)
		preview.parent = actor
	end)

	Callback.add(stateSecondary2.on_step, function(actor, data)
		actor.sprite_index2 = sprite_shoot_2_aim
		local second = ActorSkill.wrap(actor:get_active_skill(1))
		second:freeze_cooldown()

		actor:skill_util_step_strafe_sprites()

		-- if not holding down secondary: exit state
		if not Util.bool(actor.x_skill) then
			actor.aiming = 0
			actor:set_state(stateSecondary2Fire)
		end
	end)

	Callback.add(stateSecondary2Fire.on_enter, function(actor, data)
		data.fired = 0
		actor.image_index2 = 0
	end)

	Callback.add(stateSecondary2Fire.on_step, function(actor, data) 
		actor.sprite_index2 = sprite_shoot_2
		actor:skill_util_strafe_update(0.25 * actor.attack_speed, 0.5)
		actor:skill_util_step_strafe_sprites()

		if data.fired == 0 then
			local target = find_horizontal_enemy(actor)

			local spawn_x, spawn_y

			if target then
				spawn_x = target.x
				spawn_y = target.y
			else
				spawn_x = actor.x + 250 * actor.image_xscale
				spawn_y = actor.y - 5
			end

			local oBarrage = objBarrage:create(spawn_x, spawn_y)
			oBarrage.parent = actor

			actor:sound_play(sound2_launch.value, 0.5, 0.9 + math.random() * 0.1)

			data.fired = 1
		end
		actor:skill_util_exit_state_on_anim_end()
	end)

	Callback.add(stateSecondary2Fire.on_exit, function(actor, data)
		actor:skill_util_strafe_exit()
	end)

	Callback.add(stateSecondary2Fire.on_get_interrupt_priority, function(actor, data)
		if actor.image_index2 >= 1 then
			return ActorState.InterruptPriority.ANY
		end
	end)

	--
	-- Utility: DISPERSE
	--
	local stateUtility = ActorState.new("rexUtility")
	stateUtility.activity_flags = ActorState.ActivityFlag.ALLOW_ROPE_CANCEL

	utility.sprite = sprite_skills
	utility.subimage = 2
	utility.cooldown = 6 * 60
	utility.damage = SHOOT3_DAMAGE
	utility.is_primary = false
	utility.is_utility = true
	utility.disable_aim_stall = true

	Callback.add(utility.on_activate, function(actor, skill, slot)
		actor:set_state(stateUtility)
	end)

	Callback.add(stateUtility.on_enter, function(actor, data)
		actor.image_index = 0
		data.fired = 0
		actor:sound_play(sound3_charge, 0.3, 0.9 + math.random() * 0.1)
	end)

	Callback.add(stateUtility.on_step, function(actor, data)
		actor:skill_util_fix_hspeed()
		actor:actor_animation_set(sprite_shoot_3, 0.25)

		if actor.image_index >= 1 and data.fired == 0 then
			actor.activity_free = 1
			for i=0, actor:buff_count(buff_mirror) do
				local boom = actor:fire_explosion(actor.x + (80 * actor.image_xscale) + (i * 20), actor.y, 160, 70, utility.damage, nil, nil).attack_info
				boom.climb = i * 8 * 1.35
				boom.__rex_info = ATTACK_TAG_BOOM
				boom.knockback = SHOOT3_KNOCKBACK
				boom.knockback_direction = actor.image_xscale
			end
			local direction = actor:skill_util_facing_direction()
			local particle = Particle.find("WispGTracer")
			particle:set_direction(direction - 50, direction + 50, 0, 0)
			particle:create_color(actor.x, actor.y, Color.from_rgb(179, 201, 139), 20)

			actor.pHspeed = (actor.pHspeed * 0.5) + actor.pHmax * (SHOOT3_RECOIL) * -actor.image_xscale

			actor:sound_play(sound3_shoot, 1, 0.9 + math.random() * 0.9)

			data.fired = 1
		end

		actor:skill_util_exit_state_on_anim_end()
	end)

	Callback.add(stateUtility.on_get_interrupt_priority, function(actor, data)
		if actor.image_index >= 3 then
			return ActorState.InterruptPriority.ANY
		end
	end)

	-- Special: Tangling Growth
	local debuffRexRoot = Buff.new("rexRoot")
	debuffRexRoot.show_icon = false
	debuffRexRoot.is_timed = true
	debuffRexRoot.is_debuff = true
	debuffRexRoot.max_stack = 1

	-- stops enemy movement
	RecalculateStats.add(function(actor, api)
		if actor:buff_count(debuffRexRoot) > 0 then
			api.pHmax_mult(0)
		end
	end)

	local objFlowerPull = Object.new("rexFlowerPull")

	Callback.add(objFlowerPull.on_create, function(inst)
		inst.lifetime = SHOOT4_PULL_LIFETIME
	end)

	-- i sincerely apologize to the starstorm returns team for violently dismembering their code and using the pieces to construct my own abhorrent abominations
	Callback.add(objFlowerPull.on_step, function(inst)
		local data = Instance.get_data(inst)

		for _, target in ipairs(inst:get_collisions_circle(gm.constants.pActor, SHOOT4_RADIUS, inst.x, inst.y)) do
			if inst.parent:attack_collision_canhit(target) and not target:is_climbing() and not target.intangible then
				local t = 1 - inst.lifetime / SHOOT4_PULL_LIFETIME
				local falloff = (1 - t)^2
				local strength = math.max(0.1, 10 * falloff)
					
				if GM.actor_is_classic(target) then -- classic enemies (Eg. NOT Jellyfish or Archer Bugs) are pulled horizontally to the center of the pull
					target:move_contact_solid(180 + Math.direction(inst.x, target.y, target.x, target.y), strength)
				elseif not GM.actor_is_boss(target) then -- non-boss, non-classic enemies are pulled directly to the center
					target.x = target.x - math.cos(math.rad(Math.direction(inst.x, inst.y, target.x, target.y))) * strength
					target.y = target.y + math.sin(math.rad(Math.direction(inst.x, inst.y, target.x, target.y))) * strength
				end
			end
		end

		inst.lifetime = inst.lifetime - 1
		if inst.lifetime <= 0 then
			inst:destroy()
		end
	end)

	local objFlowerBomb = Object.new("rexGrowthBomb")
	sprite_flower:set_collision_mask(6, 6, 8, 8)
	objFlowerBomb:set_sprite(sprite_flower)

	local objFlower = Object.new("rexTanglingGrowth")
	sprite_flower_idle:set_collision_mask(20, 20, 20, 20)
	objFlower:set_sprite(sprite_flower_idle)

	Callback.add(objFlowerBomb.on_create, function(inst)
		inst.speed = 10
		inst.gravity = 0.2
	end)

	Callback.add(objFlowerBomb.on_step, function(inst)
		local data = Instance.get_data(inst)
		inst.image_angle = inst.direction - 270

		data.prev_x = data.prev_x or inst.x
		data.prev_y = data.prev_y or inst.y

		if inst:is_colliding(gm.constants.pBlock) then
				-- stupid chud code i shat out my ass to try and make sure
				-- the flower doesnt get stuck inside terrain 
				-- which doesnt even work. fuck my stupid chud life
				inst:collision_line_advanced(data.prev_x, data.prev_y, inst.x, inst.y, gm.constants.pBlock, true, true)

				local hit_x = gm.variable_global_get("collision_x")
				local hit_y = gm.variable_global_get("collision_y")
				local nx = math.cos(math.rad(inst.direction + 180))
				local ny = math.sin(math.rad(inst.direction + 180))
				local spawn_x = hit_x + nx * 2
				local spawn_y = hit_y + ny * 2

				local flower = objFlower:create(spawn_x, spawn_y)
				flower.parent = inst.parent
				inst:destroy()
				return
			end

			data.prev_x = inst.x
			data.prev_y = inst.y
	end)


	Callback.add(objFlower.on_create, function(inst)
		local data = Instance.get_data(inst)
		data.timer = SHOOT4_TICK_TIME
		data.pulses_left = SHOOT4_PULSES

		if inst:is_colliding(gm.constants.pBlock, inst.x + 5, inst.y) then
			inst.image_angle = 90
		elseif inst:is_colliding(gm.constants.pBlock, inst.x - 5, inst.y) then
			inst.image_angle = 270
		elseif inst:is_colliding(gm.constants.pBlock, inst.x, inst.y + 5) then
			inst.image_angle = 0
		elseif inst:is_colliding(gm.constants.pBlock, inst.x, inst.y - 5) then
			inst.image_angle = 180
		end

		gm.sound_play_at(sound4_impact.value, 0.7, 0.5, inst.x, inst.y)
	end)

	Callback.add(objFlower.on_step, function(inst)
		local data = Instance.get_data(inst)
		local parent = inst.parent

		if not parent then
			inst:destroy()
			return
		end

		data.timer = data.timer + 1
		if data.timer >= SHOOT4_TICK_TIME then
			data.timer = 0
			data.pulses_left = data.pulses_left - 1

			for _, target in ipairs(inst:get_collisions_circle(gm.constants.pActor, SHOOT4_RADIUS, inst.x, inst.y)) do
				if inst.parent:attack_collision_canhit(target) then
					local dir = Math.direction(inst.x, inst.y, target.x, target.y)
					for i=0, inst.parent:buff_count(buff_mirror) do
						local hit = parent:fire_direct(target, special.damage, dir, inst.x, inst.y, nil).attack_info
						hit.climb = i * 8 * 1.35
						hit.__rex_info = ATTACK_TAG_GROWTH
					end
				
				end
			end

			local objPull = objFlowerPull:create(inst.x, inst.y)
			objPull.parent = parent
			objPull.team = inst.team

			gm.sound_play_at(sound4_pull.value, 0.5, 0.8 + math.random() * 0.1, inst.x, inst.y)

			if data.pulses_left <= 0 then
				inst:destroy()
				-- play destroy sound (LATER)
				return
			end
		end
	end)

	Callback.add(objFlower.on_draw, function(inst)
		gm.draw_set_colour(Color.from_hex(0x8c4369))
		gm.draw_circle(inst.x, inst.y, SHOOT4_RADIUS, true)
	end)

	local stateSpecial = ActorState.new("rexSpecial")
	special.sprite = sprite_skills
	special.subimage = 3
	special.cooldown = 14 * 60
	special.damage = SHOOT4_DAMAGE
	
	Callback.add(special.on_activate, function(actor, data)
		actor:set_state(stateSpecial)
	end)

	Callback.add(stateSpecial.on_enter, function(actor, data)
		data.fired = 0
	end)

	Callback.add(stateSpecial.on_step, function(actor, data)
		if data.fired == 0 then
			rex_inst_damage(actor, 0.24)
			local bomb = objFlowerBomb:create(actor.x + 20 * actor.image_xscale, actor.y - 8)
			bomb.parent = actor
			bomb.direction = actor:skill_util_facing_direction()
			bomb.image_xscale = actor.image_xscale

			actor:sound_play(sound4_shoot.value, 1, 1)

			data.fired = 1
		end

		actor:skill_util_exit_state_on_anim_end()
	end)

	---
	Callback.add(Callback.ON_ATTACK_HIT, function(hit_info)
		local attack_tag = hit_info.attack_info.__rex_info
		if attack_tag then
			local target = hit_info.target
			if attack_tag == ATTACK_TAG_SYRINGE then
				GM.apply_buff(target, debuffRexBreak, BREAK_DEBUFF_DURATION, 1)

			elseif attack_tag ==  ATTACK_TAG_SYRINGE_B then
				GM.apply_buff(target, debuffRexBreak, BREAK_DEBUFF_DURATION, 1)
				hit_info.attack_info.parent:heal(hit_info.damage * SHOOT1_LIFESTEAL)

			elseif attack_tag == ATTACK_TAG_BOOM then
				GM.apply_buff(target, debuffRexWeaken, WEAKEN_DEBUFF_DURATION, 1)
				hit_info.attack_info.parent:heal(hit_info.damage * SHOOT3_LIFESTEAL)

			elseif attack_tag == ATTACK_TAG_GROWTH then
				local slow = Buff.find("slow")
				GM.apply_buff(target, debuffRexRoot, SHOOT4_PULL_LIFETIME, 1)
				GM.apply_buff(target, slow, 1 * 60, 1)
				hit_info.attack_info.parent:heal(hit_info.damage * SHOOT4_LIFESTEAL)
			end
		end
	end)
end

Initialize.add(initialize)

-- ** Uncomment the two lines below to re-call initialize() on hotload **
if hotload then initialize() end
hotload = true


gm.post_script_hook(gm.constants.__input_system_tick, function(inst, other, result, args)
    -- This is an example of a hook
    -- This hook in particular will run every frame after it has finished loading (i.e., "Hopoo Games" appears)
    -- You can hook into any function in the game
    -- Use pre_script_hook instead to run code before the function
    -- https://github.com/return-of-modding/ReturnOfModding/blob/master/docs/lua/tables/gm.md

end)
