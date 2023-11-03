score={}

function score:new(o)
	o=setmetatable(o or {},self)
	self.__index=self

	--init
	o.score=0
    o.x=0
    o.y=0
    o.offset_y=4
    o.width=0
    o.height=6
    o.anim_t=0
    o.anim_d=24
    o.anim_y=0
    o.anim_target=10
	return o
end

function score:update(cam_y,jumped)
    if (jumped) self.score+=1
    self.width=#tostr(self.score)*4
    self.x=64-ceil(self.width/2)
    self.y=cam_y+self.offset_y
    --slide animation
    if self.anim_t<self.anim_d then
        self.anim_t+=1
        self.anim_y=self.anim_target-easing_cubic_out(self.anim_t,0,self.anim_target,self.anim_d)
    end
end

function score:draw()
    local y=self.y-self.anim_y
    palt(0,false)
    palt(11,true)
    rectfill(self.x,y,self.x+self.width,y+self.height,0)
    spr(115,self.x-8,y,1,1,true)
    spr(115,self.x+self.width+1,y)
    palt()
    print(self.score,self.x+1,y+1,15)
end

