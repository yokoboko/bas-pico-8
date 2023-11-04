transition={}
extend(transition,animatable)

function transition:new(o)
	o=setmetatable(o or {},self)
    o=animatable.new(self,o)
	self.__index=self

	--init
	o.cam_y=0
    o.saw_size=54
    o.transition=nil
    o.y=0
    o.offset=128+ceil(o.saw_size/2)
    o.anim_t=0
    o.anim_d=20

    --animatable
    o:add_animation("spin",1,{68,71})

    --
    o:finish()
	return o
end

function transition:update(cam_y)
    if (self.transition==nil) return
    self.cam_y=cam_y
    self:update_animation()
    self.anim_t=min(self.anim_t+1,self.anim_d)
    if self.transition=="start" then
        self.y=self.offset-easing_cubic_out(self.anim_t,0,self.offset,self.anim_d)
    else
        self.y=-easing_cubic_out(self.anim_t,0,self.offset,self.anim_d)
    end
end

function transition:draw()
    if (self.transition==nil) return
    pal({0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}, 0)
    palt(0,false)
    palt(11,true)
    
    --rect
    rectfill(0,self.cam_y+self.y,128,self.cam_y+self.y+128,0)

    --saws
    local sx=ternary(self.sprite==68,32,56)
    local posy=self.cam_y+self.y+ternary(self.transition=="start",0,116)-flr((self.saw_size-12)/2)
    sspr(sx, 32, 24, 24, -4, posy,self.saw_size,self.saw_size)
    sspr(sx, 32, 24, 24, 40, posy,self.saw_size,self.saw_size)
    sspr(sx, 32, 24, 24, 80, posy,self.saw_size,self.saw_size)
    
    palt()
    pal()

    --end transition
    if (self.anim_t>=self.anim_d) self.transition=nil
end

function transition:start()
    self.transition="start"
    self.y=self.offset
    self.anim_t=0
end

function transition:finish()
    self.transition="finish"
    self.y=0
    self.anim_t=0
end