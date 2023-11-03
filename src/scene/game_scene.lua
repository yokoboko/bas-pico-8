game_scene={}

function game_scene:new(o)
    o=setmetatable(o or {},self)
    self.__index=self

    --constants
    o.tile_width = 16
    o.tile_height = 24

    --state
    o.state_initial="initial"
    o.state_playing="playing"
    o.state_will_die="will_die"
    o.state_dead="dead"
    o.state=o.state_initial

    --layers
    o.background=background:new()
    o.columns=columns:new()
    o.trap=trap:new()
    o.player=player:new({tile_height=o.tile_height})
    o.score=score:new()
    o.camera=game_camera:new({y=o.player.pos.y})
    return o
end

function game_scene:update()
    --get button action
    local action_right=self:button_action_right()

    --update layers
    if (self.state!=self.state_dead) self.player:update(action_right,self.trap.pos.y,self.state==self.state_will_die)
    if (self.state!=self.state_initial) self.trap:update(self.camera.y,self.state==self.state_will_die,self.state==self.state_dead)
    self.camera:update(self.player.pos.y)
    self.columns:update(self.tile_width,self.tile_height,self.camera.y,self.player,action_right)
    self.background:update(self.camera.y)

    --update state
    if action_right!=nil and self.columns:will_collide(self.player) then
        self.state=self.state_will_die
    end
    if self.state==self.state_initial and action_right!=nil then
        self.state=self.state_playing
    elseif self.columns:collide(self.player) or self.trap:collide(self.player) then
        self.state=self.state_dead
    end

    --update score
    if (self.state!=self.state_initial) self.score:update(self.camera.y,(action_right!=nil))
end

function game_scene:draw()
    cls()
    --fade out game scene if the player is dead
    if (self.state==self.state_dead) pal({0,1,3,2,5,13,6,8,4,10,11,12,1,14,9,0}, 0)
    self.camera:draw()
    self.background:draw()
    self.columns:draw(self.tile_width,self.tile_height)
    self.trap:draw()
    if (self.state!=self.state_initial) self.score:draw()
    if (self.state!=self.state_dead) self.player:draw()
    pal()
    --todo: draw end screen
end

function game_scene:button_action_right()
    --`true` if right button is pressed
    --`false` if left button is pressed
    --`nil` if no button is presed
    if (self.state==self.state_will_die) return nil
    if btnp(0) or btnp(4) then
        return false
    elseif btnp(1) or btnp(5) then
        return true
    end
    return nil
end