collidable={}

function collidable:new(o)
    o=setmetatable(o or {},self)
    self.__index=self
    
    --init
    o.pos = o.pos or {x=0,y=0}
    o.hitbox = o.hitbox or {x=0,y=0,w=1,h=1}
    return o
end

function collidable:collide(other)
    if
        other.pos.x+other.hitbox.x+other.hitbox.w>self.pos.x+self.hitbox.x and 
        other.pos.y+other.hitbox.y+other.hitbox.h>self.pos.y+self.hitbox.y and
        other.pos.x+other.hitbox.x<self.pos.x+self.hitbox.x+self.hitbox.w and
        other.pos.y+other.hitbox.y<self.pos.y+self.hitbox.y+self.hitbox.h 
    then
        return true
    end
end

function collidable:draw_collision_box()
    local x = self.pos.x+self.hitbox.x
    local y = self.pos.y+self.hitbox.y
    rect(x,y,x+self.hitbox.w,y+self.hitbox.h,8)
    rectfill(self.pos.x,self.pos.y,self.pos.x,self.pos.y,9)
end
