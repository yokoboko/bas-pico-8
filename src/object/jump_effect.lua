jump_effect={}
extend(jump_effect,animatable)

function jump_effect:new(o)
    o=setmetatable(o,self)
    o=animatable.new(self,o)
    self.__index=self

    --init
    o.right_wall=o.right_wall
    o.y=o.y or 0
    o.left_x=16
    o.right_x=104
    -- animatable
    o:add_animation("fx",3,{32,33,34,35,36,-1})
    return o
end

function jump_effect:update()
    self:update_animation()
end

function jump_effect:draw()
    if self.sprite!=nil then
        local x=self.right_wall and self.right_x or self.left_x
        spr(self.sprite,x,self.y+4,1,2,self.right_wall)
    end
end