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

	local sprite_idle = 				Sprite.new("RexIdle", path.combine(SPRITE_PATH, "idle.png"), 1, 18, 27) -- test offset
	local sprite_idle_half = 			Sprite.new("RexIdleHalf", path.combine(SPRITE_PATH, "idleHalf.png"), 1, 18, 4) -- test offset
	local sprite_walk = 				Sprite.new("RexWalk", path.combine(SPRITE_PATH, "walk.png"), 4, 22, 27)
	local sprite_walk_half = 			Sprite.new("RexWalkHalf", path.combine(SPRITE_PATH, "walkHalf.png"), 4, 21, 4)
	local sprite_jump = 				Sprite.new("RexJump", path.combine(SPRITE_PATH, "jump.png"), 1, 14, 28)
	local sprite_jump_half = 			Sprite.new("RexJumpHalf", path.combine(SPRITE_PATH, "jumpHalf.png"), 1, 14, 28)
	local sprite_jump_peak = 			Sprite.new("RexJumpPeak", path.combine(SPRITE_PATH, "jumpPeak.png"), 1, 14, 28)
	local sprite_jump_peak_half = 		Sprite.new("RexJumpPeakHalf", path.combine(SPRITE_PATH, "jumpPeakHalf.png"), 1, 14, 28)
	local sprite_fall = 				Sprite.new("RexFall", path.combine(SPRITE_PATH, "fall.png"), 1, 14, 28)
	local sprite_fall_half = 			Sprite.new("RexFallHalf", path.combine(SPRITE_PATH, "fallHalf.png"), 1, 14, 28)

	local sprite_shoot_1 = 				Sprite.new("RexShoot1", path.combine(SPRITE_PATH, "shoot1.png"), 12, 16, 27)

	local sprite_syringe = 				Sprite.new("RexSyringe", path.combine(SPRITE_PATH, "syringe.png"), 1, 13, 5)
	local sprite_syringe_big = 			Sprite.new("RexSyringeBig", path.combine(SPRITE_PATH, "syringeBig.png"), 1, 18, 8)

	rex:set_stats_base({
		maxhp = 120,
		damage = 12,
		regen = 0.06
	})

	rex:set_stats_level({
		maxhp = 44,
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
	rex.cape_offset = Array.new({-3, -6, 0, -2})

	Callback.add(rex.on_init, function(actor)
		actor.sprite_idle_half = Array.new({sprite_idle, sprite_idle_half, 0})
		actor.sprite_walk_half = Array.new({sprite_walk, sprite_walk_half, 0, sprite_walk_half})
		actor.sprite_jump_half = Array.new({sprite_jump, sprite_jump_half, 0})
		actor.sprite_jump_peak_half = Array.new({sprite_jump_peak, sprite_jump_peak_half, 0})
		actor.sprite_fall_half = Array.new({sprite_fall, sprite_fall_half, 0})

		actor.sprite_idle = sprite_idle
		actor.sprite_walk = sprite_walk
		actor.sprite_jump = sprite_jump
		actor.sprite_jump_peak = sprite_jump_peak
		actor.sprite_fall = sprite_fall

		actor:survivor_util_init_half_sprites()
	end)

	-- set skills
	local primary = rex:get_skills(Skill.Slot.PRIMARY)[1]
	local secondary = rex:get_skills(Skill.Slot.SECONDARY)[1]
	local utility = rex:get_skills(Skill.Slot.UTILITY)[1]
	local special = rex:get_skills(Skill.Slot.SPECIAL)[1]
	local specialUpgrade = Skill.new("rexVUpgrade")

	-- magic number bullshit
	local SHOOT1_SPEED = 20
	local SHOOT1_LIFETIME = 3 * 60
	local SHOOT1_LIFESTEAL = 0.3
	
	local ATTACK_TAG_SYRINGE = 1
	local ATTACK_TAG_SYRINGE_B = 2
	local BREAK_DEBUFF_DURATION = 6 * 60

  	-- PRIMARY: INJECT

	primary.sprite = sprite_skills
	primary.subimage = 0
	primary.cooldown = 25 -- adjust
	primary.damage = 0.55
	primary.is_primary = true
	-- and whatever other fields i need l8r on

	local statePrimary = ActorState.new("rexPrimary")

	-- Set up syringe projectile
	local objSyringe = Object.new("rexSyringe")
	objSyringe:set_sprite(sprite_syringe)

	Callback.add(objSyringe.on_create, function(inst)
		inst.speed = SHOOT1_SPEED
	end)

  	Callback.add(objSyringe.on_step, function(inst)
		for _, actor in ipairs(inst:get_collisions(gm.constants.pActorCollisionBase)) do
			if inst.parent:attack_collision_canhit(actor) then
				local direct = inst.parent:fire_direct(actor, primary.damage, inst.direction, inst.x, inst.y).attack_info
				direct.__rex_info = ATTACK_TAG_SYRINGE

				-- gm.sound_play_at(sound_m1_hit, 1, 0.3 + math.random() * 0.9, inst.x, inst.y)
				inst:destroy()
			end
		end

		-- hitting terrain destroys obj
		if inst:is_colliding(gm.constants.pBlock) then
			-- gm.sound_play_at(sound_m1_hit, 1, 0.3 + math.random() * 0.9, inst.x, inst.y)
			inst.destroy()
		end

		-- out of bounds destroys the syringe
		local stage_width = GM._mod_room_get_current_width()
		local stage_height = GM._mod_room_get_current_height()
		if inst.x < -16 or inst.x > stage_width + 16 or inst.y < -16 or inst.y > stage_height + 16 then
			inst:destroy()
		end
		
	end)

	-- initialize debuff
	local debuffRexBreak = Buff.new(NAMESPACE, "rexBreak")
	debuffRexBreak.is_timed = true
	debuffRexBreak.is_debuff = true
	debuffRexBreak.show_icon = true
	-- FIGURE OUT HOW TO DO THE STACKING NUMBER STUFF

	-- reduce armor by X per stack
	RecalculateStats.add(function(actor, api)
		if actor:buff_count(debuffRexBreak) <= 0 then return end

		api.armor_add(-4 * actor:buff_count(debuffRexBreak))
	end)

	local objSyringeBreak = Object.new("rexSyringeBreak")
	objSyringeBreak:set_sprite(sprite_syringe_big)

	Callback.add(objSyringeBreak.on_create, function(inst)
		inst.speed = SHOOT1_SPEED
	end)

  	Callback.add(objSyringeBreak.on_step, function(inst)
		for _, actor in ipairs(inst:get_collisions(gm.constants.pActorCollisionBase)) do
			if inst.parent:attack_collision_canhit(actor) then
				local direct = inst.parent:fire_direct(actor, primary.damage, inst.direction, inst.x, inst.y).attack_info
				direct.__rex_info = ATTACK_TAG_SYRINGE_B

				-- gm.sound_play_at(sound_m1_hit, 1, 0.3 + math.random() * 0.9, inst.x, inst.y)
				inst:destroy()
			end
		end

		-- hitting terrain destroys obj
		if inst:is_colliding(gm.constants.pBlock) then
			-- gm.sound_play_at(sound_m1_hit, 1, 0.3 + math.random() * 0.9, inst.x, inst.y)
			inst.destroy()
		end

		-- out of bounds destroys the syringe
		local stage_width = GM._mod_room_get_current_width()
		local stage_height = GM._mod_room_get_current_height()
		if inst.x < -16 or inst.x > stage_width + 16 or inst.y < -16 or inst.y > stage_height + 16
		then
			inst:destroy()
		end

	end)

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
					local syringe = objSyringeBreak:create(actor.x - i * 10 * actor.image_xscale, actor.y)
					syringe.direction = actor:skill_util_facing_direction()
					syringe.image_xscale = actor.image_xscale
					syringe.parent = actor
				else -- fire reg syringe
					local syringe = objSyringe:create(actor.x - i * 10 * actor.image_xscale, actor.y)
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

	Callback.add(Callback.ON_ATTACK_HIT, function(hit_info)
		local attack_tag = hit_info.attack_info.__rex_info
		if attack_tag then
			local victim = hit_info.target
			if attack_tag == ATTACK_TAG_SYRINGE then
				GM.apply_buff(victim, debuffRexBreak, BREAK_DEBUFF_DURATION, 1)

			elseif ATTACK_TAG_SYRINGE_B then
				GM.apply_buff(victim, debuffRexBreak, BREAK_DEBUFF_DURATION, 1)
				hit_info.attack_info.parent:heal(hit_info.damage * SHOOT1_LIFESTEAL)
			end
		end
	end)


	-- SECONDARY: Seed Barrage
	secondary.sprite = sprite_skills
	secondary.subimage = 2
	secondary.cooldown = 0
	secondary.damage = 5.0

	-- UTILITY: DISPERSE
	utility.sprite = sprite_skills
	utility.subimage = 3
	utility.cooldown = 6
	utility.damage = 0.5


	-- SPECIAL: Tangling Growth
	special.sprite = sprite_skills
	special.subimage = 4
	special.cooldown = 15
	special.damage = 1.8

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
