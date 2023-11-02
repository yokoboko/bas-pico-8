trap={}
extend(trap,animatable)
extend(trap,collidable)

function trap:new(o)
    o=animatable.new(self,o)
    o=setmetatable(o,self)
    self.__index=self

    --init
    o.base_speed=0.042
    o.speed=0.9
    o.speed_boost=0.0042
    o.speed_max=2.25
    o.speed_multiply=15
    
    o.offset=128--116
    o.tiles={122,123,124,125,123,124,125,123,124,125,123,126}
    o.tiles_fill={112,113,113,113,113,113,113,113,113,113,113,114}

    --collidable
    o.pos={x=16,y=32767}
	o.hitbox={x=0,y=6,w=95,h=9}

    --animatable
    o:add_animation("spin",3,{74,77})
    return o
end

function trap:update(camera_y,will_die,is_dead)
    self:update_animation()
    if not is_dead then
        self.speed=min(self.speed+self.speed_boost,self.speed_max)
        local shift=self.base_speed*self.speed*self.speed_multiply
        self.pos.y=max(min(self.pos.y-ternary(will_die,shift/5,shift), camera_y+self.offset),camera_y+72)
    end
end

function trap:draw()
    for i=0,3 do
        spr(self.sprite,16+i*24,self.pos.y,3,3)
    end
    palt(0,false)
    palt(11,true)
    for i=1,#self.tiles do
        spr(self.tiles[i],8+i*8,self.pos.y+16,1,1)
        spr(self.tiles[i],8+i*8,self.pos.y+16,1,1)
        spr(self.tiles_fill[i],8+i*8,self.pos.y+24,1,1)
        spr(self.tiles_fill[i],8+i*8,self.pos.y+32,1,1)
        spr(self.tiles_fill[i],8+i*8,self.pos.y+40,1,1)
        spr(self.tiles_fill[i],8+i*8,self.pos.y+48,1,1)
    end
    palt()
end