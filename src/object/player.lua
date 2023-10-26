player={}
extend(player,animatable)
extend(player,collidable)

function player:new(o)
	o=setmetatable(o or {},self)
	o=animatable.new(self,o)
	o=collidable.new(self,o)
	self.__index=self

	--init
	o.facing_left=false
	o.left_x=13
	o.right_x=100

	--collidable
	o.pos={x=o.left_x,y=32767-128+54}
	o.hitbox={x=3,y=1,w=8,h=11}
	
	--animatable
	o:add_animation("idle",20,{0,2})
	o:add_animation("scared",1,{4})
	o:add_animation("flying",2,{6,8})
	return o
end

function player:update()
	self:update_animation()
end

function player:draw()
	spr(self.sprite,self.pos.x,self.pos.y,2,2,self.facing_left)
	self:draw_collision_box()
end