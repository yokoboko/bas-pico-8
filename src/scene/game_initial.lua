game_initial={}

function game_initial:new(o)
    o=setmetatable(o or {},self)
    self.__index=self
    
    --init
    o.cam_y=0
    o.y=0
    o.anim=false
    o.anim_finished=false
    o.anim_t=0
    o.anim_d=32
    o.highscore=higscore:new()
    o.controls_demo=controls_demo:new()
	return o
end

function game_initial:update(cam_y,player_pos,score)
    local offset_y=0
    if self.anim and self.anim_finished==false then
        offset_y=easing_cubic_in_out(self.anim_t,0,110,self.anim_d)
        self.anim_t+=1
        if (self.anim_t>self.anim_d) self.anim_finished=true
    end
    self.cam_y=cam_y+offset_y
    self.highscore:update(self.cam_y+self.y)
    self.controls_demo:update(self.cam_y+self.y)
end

function game_initial:draw()
    if (self.anim) pal({0,1,3,2,5,13,6,2,4,2,11,12,1,4,93,0}, 0)
    --name sprite
    palt(0,false)
    palt(11,true)
    spr(192,34,self.cam_y+18,8,4)
    palt()
    
    --highscore and controls demo
    self.highscore:draw()
    self.controls_demo:draw()
    pal()
end

function game_initial:hide()
    self.anim=true
end