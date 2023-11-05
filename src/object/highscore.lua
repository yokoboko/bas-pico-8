higscore={}

function higscore:new(o)
	o=setmetatable(o or {},self)
	self.__index=self

	--init
    o.highscore=dget(0)
	o.highscore_string="best "..o.highscore
    o.width=#o.highscore_string*4
    o.height=6
    o.x=64-ceil(o.width/2)
    o.y=0
    o.offset_y=54
	return o
end

function higscore:update(cam_y)
    if (self.highscore==0) return
    self.y=cam_y+self.offset_y
end

function higscore:draw()
    if (self.highscore==0) return
    palt(0,false)
    palt(11,true)
    rectfill(self.x,self.y,self.x+self.width,self.y+self.height,0)
    spr(115,self.x-8,self.y,1,1,true)
    spr(115,self.x+self.width+1,self.y)
    palt()
    print(self.highscore_string,self.x+1,self.y+1,15)
end

