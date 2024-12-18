game_scene={}

function game_scene:new(o)
    o=setmetatable(o or {},self)
    self.__index=self

    --constants
    o.tile_width = 16
    o.tile_height = 24

    --init
    o.state_initial="initial"
    o.state_playing="playing"
    o.state_will_die="will_die"
    o.state_dead="dead"
    o.state=o.state_initial
    o.buttons_cooldown=0
    o.transition_scene=false

    --layers
    o.background=background:new()
    o.columns=columns:new()
    o.trap=trap:new()
    o.player=player:new({tile_height=o.tile_height})
    o.score=score:new()
    o.game_initial=game_initial:new()
    o.game_over=game_over:new()
    o.transition=transition:new()
    o.camera=game_camera:new({y=o.player.pos.y})

    --music
    music(0,600)
    return o
end

function game_scene:update()
    --temporary overflow fix
    if self.player.tile_pos==-1300 and self.player.jump_tile_pos==0 then
        self.columns:shift(self.tile_height,self.camera.y)
        self.player.tile_pos=1300
        self.camera.y += 2600*self.tile_height
        self.trap.pos.y += 2600*self.tile_height
    end

    --get button action
    local action_right=self:button_action_right()
    if self.buttons_cooldown>0 then
        self.buttons_cooldown-=1
        action_right=nil
    end

    --restart game
    if self.state==self.state_dead and action_right!=nil then
        self.transition_scene=true
        self.transition:start()
        return
    end

    --update layers
    if (self.state!=self.state_dead) self.player:update(action_right,self.trap.pos.y,self.state==self.state_will_die)
    if (self.state!=self.state_initial) self.trap:update(self.camera.y,self.score.score,self.state==self.state_dead)
    self.camera:update(self.player.pos.y)
    self.columns:update(self.tile_width,self.tile_height,self.camera.y,self.player,action_right,self.state==self.state_dead)
    self.background:update(self.camera.y)

    --update state
    if action_right!=nil and self.columns:will_collide(self.player) then
        self.state=self.state_will_die
        music(-1, 300)
        sfx(21)
    end
    if self.state==self.state_initial and action_right!=nil then
        self.state=self.state_playing
        self.game_initial:hide()
        music(2)
        sfx(26)
    elseif self.state!=self.state_dead and (self.columns:collide(self.player) or self.trap:collide(self.player)) then
        if (self.state!=self.state_will_die) sfx(21)
        sfx(27)
        self.buttons_cooldown=22
        self.state=self.state_dead
        music(-1, 300)
    end

    --update score
    if (self.state!=self.state_initial and self.state!=self.state_dead) self.score:update(self.camera.y,(action_right!=nil))

    --game initial
    if (self.game_initial!=nil and self.game_initial.anim_finished) self.game_initial=nil 
    if (self.game_initial!=nil) self.game_initial:update(self.camera.y)

    --game over
    if (self.state==self.state_dead) self.game_over:update(self.camera.y,self.player.pos,self.score.score)

    --transition
    if (self.state==self.state_dead and self.transition_scene and self.transition.transition==nil) current_scene=game_scene:new()
    self.transition:update(self.camera.y)
end

function game_scene:draw()
    cls()
    --fade out game scene if the player is dead
    if (self.state==self.state_dead) pal({0,1,3,2,5,13,6,8,4,10,11,12,1,14,9,0}, 0)
    self.camera:draw()
    self.background:draw()
    self.columns:draw(self.tile_width,self.tile_height)
    self.trap:draw()
    if (self.state!=self.state_initial and self.state!=self.state_dead) self.score:draw()
    if (self.game_initial!=nil) self.game_initial:draw()
    if (self.state!=self.state_dead and self.transition.anim_t>0) self.player:draw()
    pal()

    --game over
    if (self.state==self.state_dead) self.game_over:draw()

    --transition
    self.transition:draw()

    -- draw_stats(self.camera.y) --draw stats
end

function game_scene:button_action_right()
    --`true` if right button is pressed
    --`false` if left button is pressed
    --`nil` if no button is presed
    if (self.state==self.state_will_die or self.transition_scene) return nil
    if btnp(0) or btnp(4) then
        return false
    elseif btnp(1) or btnp(5) then
        return true
    end
    return nil
end