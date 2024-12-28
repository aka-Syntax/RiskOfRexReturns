-- MyMod

local envy = mods["MGReturns-ENVY"]
envy.auto()
mods["RoRRModdingToolkit-RoRR_Modding_Toolkit"].auto()

PATH = _ENV["!plugins_mod_folder_path"]
local NAMESPACE = "aka_Syntax"

-- ========== Main ==========

local function initialize()
  -- Initialization of content goes here
  -- https://github.com/RoRRModdingToolkit/RoRR_Modding_Toolkit/wiki/Initialize

  -- todo:
    -- climb/death animation
    -- implement palettes
    -- add inject animation
  
  local rex = Survivor.new(NAMESPACE, "rex")
  -- put him between merc and loader
  
  rex:clear_callbacks()
  
  local sprites = {
    idle = Resources.sprite_load(NAMESPACE, "rex_idle", path.combine(PATH, "Sprites", "sRexIdle.png"), 1, 16, 27),
    walk = Resources.sprite_load(NAMESPACE, "rex_walk", path.combine(PATH, "Sprites", "sRexWalk.png"), 4, 21, 27),
    jump = Resources.sprite_load(NAMESPACE, "rex_jump", path.combine(PATH, "Sprites", "sRexJump.png"), 1, 14, 28),
    jump_peak = Resources.sprite_load(NAMESPACE, "rex_jump_peak", path.combine(PATH, "Sprites", "sRexJumpPeak.png"), 1, 14, 28),
    fall = Resources.sprite_load(NAMESPACE, "rex_fall", path.combine(PATH, "Sprites", "sRexFall.png"), 1, 14, 28),
    -- note: redo climb later
    climb = Resources.sprite_load(NAMESPACE, "rex_climb", path.combine(PATH, "Sprites", "sRexClimb.png"), 6, 12, 29),
    -- todo: death animation
    decoy = Resources.sprite_load(NAMESPACE, "rex_decoy", path.combine(PATH, "Sprites", "sRexDecoy.png"), 4, 15, 27),
    -- todo: drone/drone_shoot animation
  }

  -- sprite halves for strafing
  local sprite_idle_half = Resources.sprite_load(NAMESPACE, "rex_idle_half", path.combine(PATH, "Sprites", "sRexIdleHalf.png"), 1, 16, 4)
  local sprite_walk_half = Resources.sprite_load(NAMESPACE, "rex_walk_half", path.combine(PATH, "Sprites", "sRexWalkHalf.png"), 4, 19, 4)
  local sprite_jump_half = Resources.sprite_load(NAMESPACE, "rex_jump_half", path.combine(PATH, "Sprites", "sRexJumpHalf.png"), 1, 14, 10)
  local sprite_jump_peak_half = Resources.sprite_load(NAMESPACE, "rex_jump_peak_half", path.combine(PATH, "Sprites", "sRexJumpPeakHalf.png"), 1, 14, 10)
  local sprite_fall_half = Resources.sprite_load(NAMESPACE, "rex_fall_half", path.combine(PATH, "Sprites", "sRexFallHalf.png"), 1, 14, 10)

  -- skill attacks (so far)
  local sprite_atk_inject = Resources.sprite_load(NAMESPACE, "rex_atk_inject", path.combine(PATH, "Sprites", "sRexAtk_Inject.png"), 12, 15, 27)
  local sprite_atk_disperse = Resources.sprite_load(NAMESPACE, "rex_atk_disperse", path.combine(PATH, "Sprites", "sRexDisperse.png"), 6, 15, 27)

  local sprite_skills = Resources.sprite_load(NAMESPACE, "rex_skills", path.combine(PATH, "Sprites", "sRexSkills.png"), 11)
  local sprite_portrait = Resources.sprite_load(NAMESPACE, "rex_portrait", path.combine(PATH, "Sprites", "sRexPortrait.png"), 3)
  local sprite_portrait_small = Resources.sprite_load(NAMESPACE, "rex_portrait_small", path.combine(PATH, "Sprites", "sRexPortraitSmall.png"))
  local sprite_select = Resources.sprite_load(NAMESPACE, "rex_select", path.combine(PATH, "Sprites", "sRexSelect.png"), 23, 56, 0)
  local sprite_syringe = Resources.sprite_load(NAMESPACE, "rex_syringe", path.combine(PATH, "Sprites", "sRexSyringe.png"), 1, 14, 3)
  local sprite_syringe_weaken = Resources.sprite_load(NAMESPACE, "rex_syringe_weaken", path.combine(PATH, "Sprites", "sRexSyringe_Weaken.png"), 1, 24, 5)
  local sprite_weaken = Resources.sprite_load(NAMESPACE, "rex_weaken_debuff", path.combine(PATH, "Sprites", "sDebuffWeaken.png"), 1, 10, 10)
  local sprite_hit = Resources.sprite_load(NAMESPACE, "rex_hit", path.combine(PATH, "Sprites", "sRexHit.png"), 1, 7, 4)

  rex:set_primary_color(Color.from_rgb(151, 177, 95))

  rex.sprite_portrait = sprite_portrait
  rex.sprite_portrait_small = sprite_portrait_small
  rex.sprite_loadout = sprite_select
  rex.sprite_title = sprites.walk
  rex.sprite_idle = sprites.idle
  rex.sprite_credits = sprites.idle
  rex:set_animations(sprites)

  -- setting stats
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

  -- initialize halves to allow for strafing
  rex:onInit(function(actor)
    local idle_half = Array.new()
    local walk_half = Array.new()
    local jump_half = Array.new()
    local jump_peak_half = Array.new()
    local fall_half = Array.new()

    idle_half:push(sprites.idle, sprite_idle_half, 0)
    walk_half:push(sprites.walk, sprite_walk_half, 0)
    jump_half:push(sprites.jump, sprite_jump_half, 0)
    jump_peak_half:push(sprites.jump_peak, sprite_jump_peak_half, 0)
    fall_half:push(sprites.fall, sprite_fall_half, 0)

    actor.sprite_idle_half = idle_half
    actor.sprite_walk_half = walk_half
    actor.sprite_jump_half = jump_half
    actor.sprite_jump_peak_half = jump_peak_half
    actor.sprite_fall_half = fall_half
  end)

  local skill_inject = rex:get_primary()
  local skill_enterroot = rex:get_secondary()
  local skill_disperse = rex:get_utility()
  local skill_tanglingroots = rex:get_special()

  -- local skill_impede = Skill.new(NAMESPACE, "rexXAlt")
  -- rex:add_secondary(skill_impede) -- add cheevo later
  -- local skill_noxiousbloom = Skill.new(NAMESPACE, "rexCAlt")
  -- rex:add_utility(skill_noxiousbloom) -- add cheevo later
  -- local skill_stimulate = Skill.new(NAMESPACE, "rexVAlt")
  -- rex:add_special(skill_stimulate) -- add cheevo later

  local skill_tanglingroots_scepter = Skill.new(NAMESPACE, "rexVUpgrade")
  skill_tanglingroots:set_skill_upgrade(skill_tanglingroots_scepter)
  -- local skill_stimulate_scepter = Skill.new(NAMESPACE, "rexVAltUpgrade")
  -- skill_stimulate:set_skill_upgrade(skill_stimulate_scepter)

  -- skill_exitroot:set_skill_icon(sprite_skills, 1)
  skill_enterroot:set_skill_icon(sprite_skills, 2)
  -- skill_seedbarrage:set_skill_icon(sprite_skills, 3)
  -- skill_impede:set_skill_icon(sprite_skills, 4)
 --  skill_noxiousbloom:set_skill_icon(sprite_skills, 6)
  skill_tanglingroots:set_skill_icon(sprite_skills, 7)
  skill_tanglingroots_scepter:set_skill_icon(sprite_skills, 8)
  -- skill_stimulate:set_skill_icon(sprite_skills, 9)
  -- skill_stimulate_scepter:set_skill_icon(sprite_skills, 10)

  -- skill_exitroot:set_skill_icon(0, 1)
  skill_enterroot:set_skill_properties(0, 1*60)
  -- skill_seedbarrage:set_skill_properties(2.5, 3)
  -- skill_impede:set_skill_properties(0.95, 6*60)
  -- skill_noxiousbloom:set_skill_properties(4.8, 4*60)
  skill_tanglingroots:set_skill_properties(2.8, 4*60)
  skill_tanglingroots_scepter:set_skill_properties(2.8, 4*60)
  -- skill_stimulate:set_skill_properties(3.3, 6*60)
  -- skill_stimulate_scepter:set_skill_properties(3.3, 6*60)

  local state_inject = State.new(NAMESPACE, skill_inject.identifier)
  local state_enterroot = State.new(NAMESPACE, skill_enterroot.identifier)
  local state_disperse = State.new(NAMESPACE, skill_disperse.identifier)
  local state_tanglingroots = State.new(NAMESPACE, skill_tanglingroots.identifier)

  --
  -- |  PRIMARY SKILL:   |
  -- | DIRECTIVE: INJECT |
  --

  -- todo: 
  -- add slight upwards recoil per shot
  -- add trails for syringes (also make them a little bigger)

  -- set icon, damage, and cooldown
  skill_inject:set_skill_icon(sprite_skills, 0)
  skill_inject:set_skill_properties(0.5, 0)

  -- set up syringe projectile
  local obj_syringe = Object.new(NAMESPACE, "rex_syringe")
  obj_syringe.obj_sprite = sprite_syringe
  obj_syringe.obj_depth = 1

  -- clear callbacks to allow for hotloading to work
  obj_syringe:clear_callbacks()

  -- handling syringe logic
  obj_syringe:onStep(function(inst)
    local data = inst:get_data()
    inst.x = inst.x + data.horizontal_velocity

    -- collision with another actor destroys the syringe
    local actor_collisions, _ = inst:get_collisions(gm.constants.pActorCollisionBase)
    for _, other_actor in ipairs(actor_collisions) do
      if data.parent:attack_collision_canhit(other_actor) then
        local damage_direction = 0
        if data.horizontal_velocity < 0 then
          damage_direction = 180 -- reverse knockback
        end
        -- deal direct damage on hit
        data.parent:fire_direct(other_actor, data.damage_coefficient, damage_direction, inst.x, inst.y, sprite_hit)

        -- destroy the syringe
        inst:destroy()
        return
      end
    end

    -- terrain destroys the syringe
    if inst:is_colliding(gm.constants.pSolidBulletCollision) then
      inst:destroy()
      return
    end

    -- out of bounds destroys the syringe
    local stage_width = GM._mod_room_get_current_width()
    local stage_height = GM._mod_room_get_current_height()
    if inst.x < -16 or inst.x > stage_width + 16
      or inst.y < -16 or inst.y > stage_height + 16
    then
      inst:destroy()
      return
    end
  end)

  -- initialize debuff
  local debuff_weaken = Buff.new(NAMESPACE, "rex_weaken")
  debuff_weaken.max_stack = 1
  debuff_weaken.is_timed = true
  debuff_weaken.is_debuff = true
  debuff_weaken.show_icon = true
  debuff_weaken.icon_sprite = sprite_weaken

  debuff_weaken:clear_callbacks()

  -- reduce armor by 20
  -- reduce movespeed and damage by 30%
  -- todo: add vfx overlay
  debuff_weaken:onStatRecalc(function(actor, stack)
    actor.armor = actor.armor - 20
    actor.damage = actor.damage * 0.7
    actor.pHmax = actor.pHmax * 0.7
  end)

  local obj_syringe_weaken = Object.new(NAMESPACE, "rex_syringe_weaken")
  obj_syringe_weaken.obj_sprite = sprite_syringe_weaken
  obj_syringe_weaken.obj_depth = 1

  obj_syringe_weaken:clear_callbacks()

  obj_syringe_weaken:onStep(function(inst)
    local data = inst:get_data()
    inst.x = inst.x + data.horizontal_velocity

    -- collision with another actor destroys the syringe
    local actor_collisions, _ = inst:get_collisions(gm.constants.pActorCollisionBase)
    for _, other_actor in ipairs(actor_collisions) do
      if data.parent:attack_collision_canhit(other_actor) then
        local damage_direction = 0
        if data.horizontal_velocity < 0 then
          damage_direction = 180 -- reverse knockback direction
        end
        -- deal direct damage on hit
        local attack_info = data.parent:fire_direct(other_actor, data.damage_coefficient, damage_direction, inst.x, inst.y, sprite_hit).attack_info
        
        -- is there a way to fetch the amount of damage this hit dealt?
        -- apply weaken debuff for 3 seconds
        other_actor:buff_apply(debuff_weaken, 3*60, 1)
        
        -- onAttackHit callback jank
        attack_info.rex_third_hit_heal = 1
        -- destroy the syringe
        inst:destroy()
        return
      end
    end

    -- terrain destroys the syringe
    if inst:is_colliding(gm.constants.pSolidBulletCollision) then
      inst:destroy()
      return
    end

    -- out of bounds destroys the syringe
    local stage_width = GM._mod_room_get_current_width()
    local stage_height = GM._mod_room_get_current_height()
    if inst.x < -16 or inst.x > stage_width + 16
      or inst.y < -16 or inst.y > stage_height + 16
    then
      inst:destroy()
      return
    end
  end)

  skill_inject:clear_callbacks()
  -- called when activating primary skill
  skill_inject:onActivate(function(actor, skill, index)
    actor:enter_state(state_inject)
  end)

  state_inject:clear_callbacks()
  -- reset sprite animations to frame 0
  state_inject:onEnter(function(actor, data)
    actor.image_index = 0 -- variable used for frame of lower body
    actor.image_index2 = 0 -- variable used for frame of upper body
    data.shots = 0

    actor:skill_util_strafe_init() -- allow half strafe
    actor:skill_util_strafe_turn_init()
  end)

  state_inject:onExit(function(actor, data)
    actor:skill_util_strafe_exit() -- must be called if using half-sprite strafing. you can ignore this if using slide strafing
  end)

  state_inject:onStep(function(actor, data)
    actor.sprite_index2 = sprite_atk_inject

    -- this function animates the upper half-sprite for you and controls the speed multiplier.
	  -- takes in the desired sprite speed (gets capped to 1 internally), and move speed multiplier while strafing, ranges around 0.5
    actor:skill_util_strafe_update(0.35 * actor.attack_speed, 0.45)
    	-- this function updates the vertical offset
	  actor:skill_util_step_strafe_sprites() -- updates upper body's vertical offset
	  actor:skill_util_strafe_turn_update() -- handles queuing up turnarounds mid-animation

    -- code for shooting goes here
    -- fires on frames 0, 2, and 4
    -- todo: fix the fuck out of that heal
    if actor.image_index2 >= data.shots * 2 and data.shots < 3 then
      local direction = GM.cos(GM.degtorad(actor:skill_util_facing_direction()))
      local buff_shadow_clone = Buff.find("ror", "shadowClone")
      for i=0, actor:buff_stack_count(buff_shadow_clone) do
        -- if firing the third syringe: fire big syringe
        if actor.image_index2 >= 4 then
          local spawn_offset = 15 * direction
          local syringe = obj_syringe_weaken:create(actor.x + spawn_offset, actor.y-5)
          local syringe_data = syringe:get_data()
          syringe_data.horizontal_velocity = 20 * direction
          -- flip the syringe if it travels left
          if syringe_data.horizontal_velocity < 0 then
            syringe.image_xscale = -1
          end
          syringe_data.parent = actor

          -- Pass the damage coefficient to the bullet
          local damage = actor:skill_get_damage(skill_inject)
          syringe_data.damage_coefficient = damage
        -- if firing the first syringe: trigger heaven cracker
        elseif actor.image_index2 >= 0 then
          if not actor:skill_util_update_heaven_cracker(actor, dmg) then
            local spawn_offset = 5 * direction
            local syringe = obj_syringe:create(actor.x + spawn_offset, actor.y-5)
            local syringe_data = syringe:get_data()
            syringe_data.horizontal_velocity = 20 * direction
            -- flip the syringe if it travels left
            if syringe_data.horizontal_velocity < 0 then
              syringe.image_xscale = -1
            end
            syringe_data.parent = actor

            -- Pass the damage coefficient to the bullet
            local damage = actor:skill_get_damage(skill_inject)
            syringe_data.damage_coefficient = damage
          end

        -- else: fire lame syringe
        else
          local spawn_offset = 5 * direction
          local syringe = obj_syringe:create(actor.x + spawn_offset, actor.y-5)
          local syringe_data = syringe:get_data()
          syringe_data.horizontal_velocity = 20 * direction
          -- flip the syringe if it travels left
          if syringe_data.horizontal_velocity < 0 then
            syringe.image_xscale = -1
          end
          syringe_data.parent = actor

          -- Pass the damage coefficient to the bullet
          local damage = actor:skill_get_damage(skill_inject)
          syringe_data.damage_coefficient = damage
        end
      end
      data.shots = data.shots + 1
    end

    actor:skill_util_exit_state_on_anim_end()
  end)

  Callback.add("onAttackHit", "rex_inject_heal", function(self, other, result, args)
    -- because args[2] killed my grandma
    local hit_info = Hit_Info.wrap(args[2].value)

    Helper.log_struct(hit_info)
    if hit_info.attack_info.rex_third_hit_heal == 1 then
      -- heal for 50% of the damage dealt
      hit_info.parent:heal(hit_info.damage * 0.5)
    end
  end)

  --
  -- |    UTILITY SKILL:   |
  -- | DIRECTIVE: DISPERSE |
  --

  -- set skill icon, damage, cooldown
  skill_disperse:set_skill_icon(sprite_skills, 5)
  skill_disperse:set_skill_properties(0, 1.5*60)
  skill_disperse:set_skill_animation(sprite_atk_disperse)

  skill_disperse:clear_callbacks()
  -- called when activating primary skill
  skill_disperse:onActivate(function(actor, skill, index)
    actor:enter_state(state_disperse)
  end)

  state_disperse:clear_callbacks()
  -- reset sprite animations to frame 0
  state_disperse:onEnter(function(actor, data)
    actor.image_index = 0
    data.fired = 0
  end)

  state_disperse:onStep(function(actor, data)
    -- fire explosion at frame 1 (0 index)
    -- apply knockback and weaken to enemies
    -- apply recoil to self: stronger recoil while airborne
    -- heal 6% for every enemy hit

    actor:skill_util_fix_hspeed()

    local animation = actor:actor_get_skill_animation(skill_disperse)
    actor:actor_animation_set(animation, 0.25)

    if actor.image_index >= 1 and data.fired == 0 then
      local buff_shadow_clone = Buff.find("ror", "shadowClone")
			for i=0, actor:buff_stack_count(buff_shadow_clone) do
        local direction = GM.cos(GM.degtorad(actor:skill_util_facing_direction()))

        local spawn_offset = 5 * direction
        local damage = actor:skill_get_damage(skill_disperse)
        actor:fire_explosion(actor.x + spawn_offset, actor.y, 200, 200, damage)
        -- do effect bullshit here

        if actor:is_grounded() then
          if direction < 0 then
            actor:apply_stun(1, -1, 0)
          end
          actor:apply_stun(1, 1, 0)
        else
          
        end
        

      end
      data.fired = 1
    end

    actor:skill_util_exit_state_on_anim_end()
  end)


  -- what else do i do here lol
end
Initialize(initialize)

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