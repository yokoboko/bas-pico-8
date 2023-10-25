saw={}
extend(saw,animatable)

function saw:new(o)
    o=animatable.new(self,o)
    local o=setmetatable(o or {},self)
    self.__index=self

    --init
    o.left=rnd(1)<0.5
    o:add_animation("spin",3,{68,71})
    
    return o
end

function saw:update()
    self:update_animation()
end

function saw:draw(idx,tile_width,tile_height)
    local pos_y=idx*tile_height
    clip(tile_width,0,128-tile_width-16,128)
    if self.left == true then
        spr(self.sprite,tile_width-8,pos_y,3,3)
    else 
        spr(self.sprite,128-tile_width-16,pos_y,3,3,true)
    end
    clip()
end