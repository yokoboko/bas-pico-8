saw={}
extend(saw,animatable)
extend(saw,collidable)

function saw:new(o)
    o=setmetatable(o,self)
    o=animatable.new(self,o)
    o=collidable.new(self,o)
    self.__index=self

    --init {idx=0,tile_width=1,tile_height=1}
    o.left=rnd(1)<0.5

    --collidable
    local x=(o.left) and o.tile_width-8 or 128-o.tile_width-16
	o.pos={x=x,y=o.idx*o.tile_height}
	o.hitbox={x=3,y=3,w=16,h=16}
    
    --animatable
    o:add_animation("spin",3,{68,71})
    return o
end

function saw:update()
    self:update_animation()
end

function saw:draw()
    spr(self.sprite,self.pos.x,self.pos.y,3,3,not self.left)
end