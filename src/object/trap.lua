trap={}
extend(trap,animatable)
extend(trap,collidable)

function trap:new(o)
    o=animatable.new(self,o)
    o=setmetatable(o,self)
    self.__index=self

    --init
    o.speed_start=0.5
    o.speed_top=1.7
    o.speed_top_treshold=200 --game score points when we reach top speed
    o.offset=128
    o.offset_min=120
    o.tiles={122,123,124,125,123,124,125,123,124,125,123,126}
    o.tiles_fill={112,113,113,113,113,113,113,113,113,113,113,114}
    o.speed_top=o.speed_top-o.speed_start --exclude start from top speed to ensure max is correct

    --collidable
    o.pos={x=16,y=32767}
	o.hitbox={x=0,y=6,w=95,h=9}

    --animatable
    o:add_animation("spin",3,{74,77})
    return o
end

function trap:update(camera_y,score,is_dead)
    self:update_animation()
    local speed=min(score/self.speed_top_treshold,1) --0 to 1
    local shift=self.speed_start+self.speed_top*speed
    self.pos.y=max(min(self.pos.y-shift, camera_y+self.offset),camera_y+72)
    --animate in the trap when the game starts
    self.offset=max(self.offset-0.2, self.offset_min)
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