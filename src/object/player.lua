player={}
extend(player,animatable)

function player:new(o)
	o=animatable.new(self,o)
	o=setmetatable(o or {},self)
	self.__index=self

	--init
	o.x = 16
	o.y = 32767-128+52
	o:add_animation("idle",20,{0,2})
	o:add_animation("scared",1,{4})
	o:add_animation("flying",2,{6,8})

	return o
end

function player:update()
	self:update_animation()
end

function player:draw()
	log("sprite: "..self.sprite)
	spr(self.sprite,self.x,self.y,2,2)
end