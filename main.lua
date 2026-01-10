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

-- ========== Main ==========

local function initialize()
  local rex = Survivor.new("rex")
	-- put between merc and loader

	-- poke all sprirtes
	local sprite_select = 				Sprite.new("rexSelect", path.combine(SPRITE_PATH, "select.png"), 23, 56, 0)
	local sprite_skills =				Sprite.new("RexSkills", path.combine(SPRITE_PATH, "skills.png"), 6)
	local sprite_portrait =				Sprite.new("RexPortrait", path.combine(SPRITE_PATH, "portrait.png"), 3)
	local sprite_portrait_small =		Sprite.new("RexPortraitSmall", path.combine(SPRITE_PATH, "portraitSmall.png"))

	local sprite_idle = 				Sprite.new("RexIdle", path.combine(SPRITE_PATH, "idle.png"), 1, 20, 36)
	local sprite_idle_half = 			Sprite.new("RexIdleHalf", path.combine(SPRITE_PATH, "idleHalf.png"), 1, 20, 36)
	local sprite_walk = 				Sprite.new("RexWalk", path.combine(SPRITE_PATH, "walk.png"), 4, 23, 36)
	local sprite_walk_half = 			Sprite.new("RexWalkHalf", path.combine(SPRITE_PATH, "walkHalf.png"), 4, 24, 36)
	local sprite_jump = 				Sprite.new("RexJump", path.combine(SPRITE_PATH, "jump.png"), 1, 20, 35)
	local sprite_jump_half = 			Sprite.new("RexJumpHalf", path.combine(SPRITE_PATH, "jumpHalf.png"), 1, 17, 11) -- ???
	local sprite_jump_peak = 			Sprite.new("RexJumpPeak", path.combine(SPRITE_PATH, "jumpPeak.png"), 1, 20, 35)
	local sprite_jump_peak_half = 		Sprite.new("RexJumpPeakHalf", path.combine(SPRITE_PATH, "jumpPeakHalf.png"), 1, 18, 12) -- ???
	local sprite_fall = 				Sprite.new("RexFall", path.combine(SPRITE_PATH, "jumpFall.png"), 1, 20, 35)
	local sprite_fall_half = 			Sprite.new("RexFallHalf", path.combine(SPRITE_PATH, "jumpFallHalf.png"), 1, 19, 13) -- ???
	local sprite_climb = 				Sprite.new("RexClimb", path.combine(SPRITE_PATH, "climb.png"), 5, 17, 26)
	sprite_climb:set_speed(2.5)

	sprite_walk:set_speed(2.5)

	local sprite_shoot_1 = 				Sprite.new("RexShoot1", path.combine(SPRITE_PATH, "shoot1.png"), 12, 17, 36)
	local sprite_shoot_2_aim = 			Sprite.new("RexShoot2Aim", path.combine(SPRITE_PATH, "shoot2aiml.png"), 1, 1, 1)
	local sprite_shoot_2 = 				Sprite.new("RexShoot2", path.combine(SPRITE_PATH, "shoot2real.png"), 5, 5, 5)
	local sprite_shoot_3 = 				Sprite.new("RexShoot3", path.combine(SPRITE_PATH, "shoot3.png"), 6, 24, 36)

	local sprite_syringe = 				Sprite.new("RexSyringe", path.combine(SPRITE_PATH, "syringe.png"), 1, 13, 5)
	local sprite_syringe_big = 			Sprite.new("RexSyringeBig", path.combine(SPRITE_PATH, "syringeBig.png"), 1, 18, 8)
	local sprite_debuff_break = 		Sprite.new("RexDebuffBreak", path.combine(SPRITE_PATH, "debuffBreak.png"), 1, 9, 11)
	local sprite_debuff_weaken = 		Sprite.new("RexDebuffWeaken", path.combine(SPRITE_PATH, "debuffWeaken.png"), 1, 12, 12)

	rex:set_stats_base({
		health = 120,
		damage = 12,
		regen = 0.06
	})

	rex:set_stats_level({
		health = 44,
		damage = 3,
		regen = 0.015,
		armor = 3
	})

	rex.sprite_portrait = sprite_portrait
	rex.sprite_portrait_small = sprite_portrait_small
	rex.sprite_loadout = sprite_select
	
	rex.sprite_idle = sprite_idle
	rex.sprite_title = sprite_walk

	rex.primary_color = Color.from_rgb(151, 177, 95)
	-- rex.cape_offset = Array.new({-3, -6, 0, -2})

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
	local specialUpgrade = Skill.new("rexVUpgrade")

	-- magic number bullshit
	local SHOOT1_DAMAGE = 0.4
	local SHOOT1_SPEED = 20
	local SHOOT1_LIFETIME = 2 * 60
	local SHOOT1_LIFESTEAL = 0.3
	local BREAK_DEBUFF_DURATION = 6 * 60

	local SHOOT2_DELAY = 0.5 * 60

	local SHOOT3_DAMAGE = 0.5
	local SHOOT3_KNOCKBACK = 9
	local SHOOT3_RECOIL = 3
	local SHOOT3_LIFESTEAL = 0.8
	local WEAKEN_DEBUFF_DURATION = 3 * 60

	local ATTACK_TAG_SYRINGE = 1
	local ATTACK_TAG_SYRINGE_B = 2
	local ATTACK_TAG_BOOM = 3

	-- Debuffs
	local debuffRexBreak = Buff.new("rexBreak")
	debuffRexBreak.icon_sprite = sprite_debuff_break
	debuffRexBreak.is_timed = true
	debuffRexBreak.is_debuff = true
	debuffRexBreak.show_icon = true
	debuffRexBreak.max_stack = 999
	-- FIGURE OUT HOW TO DO THE STACKING NUMBER STUFF

	-- reduce armor by X per stack
	RecalculateStats.add(function(actor, api)
		if actor:buff_count(debuffRexBreak) > 0 then
			api.armor_add(-4 * actor:buff_count(debuffRexBreak))
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
		local data = Instance.get_data(inst)
		data.lifetime = SHOOT1_LIFETIME
	end)

  	Callback.add(objSyringe.on_step, function(inst)
		local data = Instance.get_data(inst)
		data.lifetime = data.lifetime - 1
		if data.lifetime < 0 then
			inst:destroy()
		end

		for _, actor in ipairs(inst:get_collisions(gm.constants.pActorCollisionBase)) do
			if inst.parent:attack_collision_canhit(actor) then
				local direct = inst.parent:fire_direct(actor, primary.damage, inst.direction, inst.x, inst.y).attack_info
				direct.__rex_info = ATTACK_TAG_SYRINGE

				-- gm.sound_play_at(sound_m1_hit, 1, 0.3 + math.random() * 0.9, inst.x, inst.y)
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
		local data = Instance.get_data(inst)
		data.lifetime = SHOOT1_LIFETIME
	end)

  	Callback.add(objSyringeBreak.on_step, function(inst)
		local data = Instance.get_data(inst)
		data.lifetime = data.lifetime - 1
		if data.lifetime < 0 then
			inst:destroy()
		end

		for _, actor in ipairs(inst:get_collisions(gm.constants.pActorCollisionBase)) do
			if inst.parent:attack_collision_canhit(actor) then
				local direct = inst.parent:fire_direct(actor, primary.damage, inst.direction, inst.x, inst.y).attack_info
				direct.__rex_info = ATTACK_TAG_SYRINGE_B

				-- gm.sound_play_at(sound_m1_hit, 1, 0.3 + math.random() * 0.9, inst.x, inst.y)
				inst:destroy()
				return
			end
		end

		if inst:is_colliding(gm.constants.pSolidBulletCollision) then
			inst:destroy()
			return
		end
	end)

	-- PRIMARY: INJECT
	local statePrimary = ActorState.new("rexPrimary")
	primary.sprite = sprite_skills
	primary.subimage = 0
	primary.damage = SHOOT1_DAMAGE
	primary.is_primary = true
	primary.cooldown = 36

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
    	actor:skill_util_strafe_update(0.4 * actor.attack_speed, 0.45)
		actor:skill_util_step_strafe_sprites()
		actor:skill_util_strafe_turn_update()

		-- fire the bullet every 2nd frame (may change to every 3rd)
		if actor.image_index2 >= data.shots * 2 and data.shots < 3 then
			-- play firing sound
			local buff_shadow_clone = Buff.find("shadowClone")
			for i=0, actor:buff_count(buff_shadow_clone) do
				if actor.image_index2 >= 4 then -- fire big syringe
					local syringe = objSyringeBreak:create(actor.x + 45 * actor.image_xscale, actor.y - 3)
					syringe.direction = actor:skill_util_facing_direction()
					syringe.image_xscale = actor.image_xscale
					syringe.parent = actor
				else -- fire reg syringe
					local syringe = objSyringe:create(actor.x + 5 * actor.image_xscale, actor.y - 5)
					syringe.direction = actor:skill_util_facing_direction()
					syringe.image_xscale = actor.image_xscale
					syringe.parent = actor
				end
			end
			--  actor:sound_play(sound_m1_shoot, 0.7, 0.8 + math.random() * 0.2) -- sound, volume, pitch
			data.shots = data.shots + 1
		end
		actor:skill_util_exit_state_on_anim_end()
	end)

	Callback.add(statePrimary.on_exit, function(actor, data)
		actor:skill_util_strafe_exit()
	end)

	-- SECONDARY: Seed Mortar
	local priMortar = Skill.new("rexPriMortar")
	priMortar.sprite = sprite_skills
	priMortar.subimage = 1
	priMortar.is_primary = false
	priMortar.is_utility = false
	priMortar.cooldown = 0.8 * 60

	Callback.add(priMortar.on_activate, function(actor)
		actor.firing_mortar = 1
		actor.image_index2 = 0
		actor:set_skill_animation(sprite_shoot_2, 0.25)

		-- play sound for firing mortar
		actor:collision_line_advanced(actor.x, actor.y + 10, actor.x + 150 * actor.image_xscale, actor.y + 10, gm.constants.pBlock, true, true)
		local collision_x1 = gm.variable_global_get("collision_x") - 2 * actor.image_xscale
		local collision_y1 = gm.variable_global_get("collision_y")
		actor:collision_line_advanced(collision_x1, collision_y1, collision_x1 - 10 * actor.image_xscale, actor.y + 2000, gm.constants.pBlock, true, true)
		local collision_x2 = gm.variable_global_get("collision_x")
		local collision_y2 = gm.variable_global_get("collision_y")
		local oProbe = objProbe:create(collision_x2, collision_y2)
		oProbe.parent = actor
	end)


	local objMortar = Object.new("rexMortar")
	local objPreview = Object.new("rexMortarPreview")

	Callback.add(objMortar.on_create, function(inst)
		local data = Instance.get_data(inst)
		data.lifetime_max = SHOOT2_DELAY
		data.lifetime = SHOOT2_DELAY
	end)

	Callback.add(objMortar.on_step, function(inst)
		local data = Instance.get_data(inst)

		data.lifetime = data.lifetime - 1
		if data.lifetime <= 0 then
			local buff_shadow_clone = Buff.find("shadowClone")
			for i=0, inst.parent:buff_count(buff_shadow_clone) do
				inst.parent:fire_explosion(inst.x, inst.y - 10, 192, 192, secondary.damage, gm.constants.sEfSuperMissileExplosion, gm.constants.sSparks12)
				-- play sound

			end
			inst:screen_shake(5)
			inst:destroy()
			-- BOOOM!!!!!!!!!!!!!!!!
		end
	end)

	-- indicator for mortar
	Callback.add(objMortar.on_draw, function(inst)
		local data = Instance.find(inst)
		local radius = (1 - data.lifetime / data.lifetime_max) * 96
		gm.draw_set_color(Color.from_hsv(184, 224, 155))
		gm.draw_circle(self.x, self.y, radius, true)
	end)

	Callback.add(objPreview.on_draw, function(inst)
		local actor = inst.parent

		-- need 2 make this work on enemies
		if actor:get_active_skill(0).skill_id == priMortar.value then
			if actor.callingprobe == 0 then
				actor:collision_line_advanced(actor.x, actor.y + 10, actor.x + 150 * actor.image_xscale, actor.y + 10, gm.constants.pBlock, true, true)
				local collision_x1 = gm.variable_global_get("collision_x") - 2 * actor.image_xscale
				local collision_y1 = gm.variable_global_get("collision_y")
				actor:collision_line_advanced(collision_x1, collision_y1, collision_x1 - 10 * actor.image_xscale, actor.y + 2000, gm.constants.pBlock, true, true)
				local collision_x2 = gm.variable_global_get("collision_x")
				local collision_y2 = gm.variable_global_get("collision_y")
				gm.draw_set_colour(Color.from_hsv(0, 0, 100))
				gm.draw_line_width(collision_x2, collision_y2, collision_x2, collision_y2 - 600, 1)
				gm.draw_circle(collision_x2, collision_y2, 96, true)
			end
		else
			inst:destroy()
		end
	end)

	local stateSecondary = ActorState.new("rexSecondary")
	secondary.sprite = sprite_skills
	secondary.subimage = 2
	secondary.cooldown = 0.8 * 60
	secondary.damage = 5.0
	secondary.does_change_activity_state = true
	secondary.hold_facing_direction = true
	secondary.override_strafe_direction = true

	Callback.add(secondary.on_activate, function(actor)
		actor:set_state(stateSecondary)
	end)

	Callback.add(stateSecondary.on_enter, function(actor, data)
		actor:skill_util_strafe_init()
		actor:skill_util_strafe_turn_init()

		if gm.sign(gm.real(actor.moveRight) - gm.real(actor.moveLeft)) ~= 0 then
			actor.hold_facing_direction_xscale = gm.sign(gm.real(actor.moveRight) - gm.real(actor.moveLeft)) -- stupid dumb idiotic bullshit fuckery, apparently vanilla code also uses that lmao
		else
			actor.hold_facing_direction_xscale = actor.image_xscale
		end

		actor.sprite_index2 = sprite_shoot_2_aim
		actor.image_index2 = 0
		actor.firing_mortar = 0
		actor:add_skill_override(0, priMortar, 10)
		-- play sound

		local preview = objPreview:create(actor.x, actor.y)
		preview.parent = actor

	end)	

	Callback.add(stateSecondary.on_step, function(actor, data)
		local second = ActorSkill.wrap(actor:get_active_skill(1))
		second:freeze_cooldown()

		if actor.firing_mortar == 1 then
			actor.sprite_index2 = sprite_shoot_2
			actor.image_index2 = 0
			actor.firing_mortar = 0
		end

		-- if not holding down secondary: exit state
		if not Util.bool(actor.x_skill) then
			actor:skill_util_exit_state_on_anim_end()
		end
	end)

	Callback.add(stateSecondary.on_exit, function(actor, data)
		actor:skill_util_strafe_exit()
		actor:remove_skill_override(0, priMortar, 10)
	end)

	-- UTILITY: DISPERSE
	local stateUtility = ActorState.new("rexUtility")
	utility.sprite = sprite_skills
	utility.subimage = 3
	utility.cooldown = 1 * 60
	utility.damage = SHOOT3_DAMAGE
	utility.is_primary = false
	utility.is_utility = true

	Callback.add(utility.on_activate, function(actor, skill, slot)
		actor:set_state(stateUtility)
	end)

	Callback.add(stateUtility.on_enter, function(actor, data)
		actor.image_index = 0
		data.fired = 0

		-- actor:sound_play(sound_shift_windup, 0.3, 0.9 + math.random() * 0.9)
	end)

	Callback.add(stateUtility.on_step, function(actor, data)
		-- actor:skill_util_fix_hspeed()
		actor:actor_animation_set(sprite_shoot_3, 0.25)

		if actor.image_index >= 1 and data.fired == 0 then
			local boom = actor:fire_explosion(actor.x + (80 * actor.image_xscale), actor.y, 160, 60, utility.damage, nil, nil).attack_info
			boom.__rex_info = ATTACK_TAG_BOOM
			boom.knockback = SHOOT3_KNOCKBACK
			boom.knockback_direction = actor.image_xscale

			local direction = actor:skill_util_facing_direction()
			local particle = Particle.find("WispGTracer")
			particle:set_direction(direction - 50, direction + 50, 0, 0)
			particle:create_color(actor.x, actor.y, Color.from_rgb(179, 201, 139), 20)

			actor.pHspeed = actor.pHspeed + actor.pHmax * -SHOOT3_RECOIL * actor.image_xscale

			data.fired = 1
		end

		actor:skill_util_exit_state_on_anim_end()
	end)

	-- SPECIAL: Tangling Growth
	special.sprite = sprite_skills
	special.subimage = 4
	special.cooldown = 15 * 60
	special.damage = 1.8

	---
	Callback.add(Callback.ON_ATTACK_HIT, function(hit_info)
		local attack_tag = hit_info.attack_info.__rex_info
		if attack_tag then
			local victim = hit_info.target
			if attack_tag == ATTACK_TAG_SYRINGE then
				GM.apply_buff(victim, debuffRexBreak, BREAK_DEBUFF_DURATION, 1)

			elseif attack_tag ==  ATTACK_TAG_SYRINGE_B then
				GM.apply_buff(victim, debuffRexBreak, BREAK_DEBUFF_DURATION, 1)
				hit_info.attack_info.parent:heal(hit_info.damage * SHOOT1_LIFESTEAL)

			elseif attack_tag == ATTACK_TAG_BOOM then
				GM.apply_buff(victim, debuffRexWeaken, WEAKEN_DEBUFF_DURATION, 1)
				hit_info.attack_info.parent:heal(hit_info.damage * SHOOT3_LIFESTEAL)
			end
		end
	end)
end

Initialize.add(initialize)

-- ** Uncomment the two lines below to re-call initialize() on hotload **
if hotload then initialize() end
hotload = true


gm.post_script_hook(gm.constants.__input_system_tick, function(self, other, result, args)
    -- This is an example of a hook
    -- This hook in particular will run every frame after it has finished loading (i.e., "Hopoo Games" appears)
    -- You can hook into any function in the game
    -- Use pre_script_hook instead to run code before the function
    -- https://github.com/return-of-modding/ReturnOfModding/blob/master/docs/lua/tables/gm.md

end)
