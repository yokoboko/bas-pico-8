player={}
extend(player,animatable)
extend(player,collidable)

function player:new(o)
	o=setmetatable(o or {},self)
	o=animatable.new(self,o)
	o=collidable.new(self,o)
	self.__index=self

	--init
	o.right_wall=false
	o.left_x=12
	o.right_x=100
	o.tile_height=o.tile_height or 8
	o.tile_offset_y=4 --in pixels
	o.tile_pos=1362
	o.jumping=false
	o.jump_speed=0.05 -- in tiles
	o.jump_tile_pos=0 --in tiles
	o.jump_changes_direction=false
	o.jump_amp=8 --amplitude

	--collidable
	o.pos={x=o.left_x,y=o.tile_pos*o.tile_height+o.tile_offset_y}
	o.hitbox={x=3,y=1,w=8,h=11}
	
	--animatable
	o:add_animation("idle",20,{0,2})
	o:add_animation("scared",1,{4})
	o:add_animation("flying",2,{6,8})
	return o
end

function player:update(pressed_right)
	--jump
	if pressed_right!=nil then
		if self.jumping then
			self.tile_pos-=1
		else
			self.jumping=true
		end
		self.jump_tile_pos=0
		self.jump_changes_direction=self.right_wall!=pressed_right
		self.right_wall=pressed_right
	end
	if self.jumping then
		self.jump_tile_pos=max(self.jump_tile_pos-self.jump_speed,-1)
		if self.jump_tile_pos==-1 then
			self.jumping=false
			self.tile_pos-=1
			self.jump_tile_pos=0
		end
	end

	--position
	self.pos.y=(self.tile_pos+self.jump_tile_pos)*self.tile_height+self.tile_offset_y
	if self.jumping then
		if self.jump_changes_direction then
			local offset=(self.right_x-self.left_x)*abs(self.jump_tile_pos)
			self.pos.x=ternary(self.right_wall,self.left_x+offset,self.right_x-offset)
		else
			local offset=sin(self.jump_tile_pos/2)*self.jump_amp
			self.pos.x=ternary(self.right_wall,self.right_x-offset,self.left_x+offset)
		end
	else
		self.pos.x=ternary(self.right_wall,self.right_x,self.left_x)
	end

	--animation
	if self.jumping then
		self:play_animation("flying")
	else 
		self:play_animation("idle")
	end
	self:update_animation()
end

function player:draw()
	local facing_left=ternary(self.jumping,not self.right_wall, self.right_wall)
	spr(self.sprite,self.pos.x,self.pos.y,2,2,facing_left)
end