game_scene={}

function game_scene:new(o)
    o=setmetatable(o or {},self)
    self.__index=self

    --constants
    o.tile_width = 16
    o.tile_height = 24

    --layers
    o.background = background:new()
    o.columns = columns:new()
    o.player = player:new({tile_height=o.tile_height})
    o.camera = game_camera:new({y=o.player.pos.y})
    return o
end

function game_scene:update()
    --buttons
    local pressed_right=nil
    if btnp(0) or btnp(4) then
        pressed_right=false
    elseif btnp(1) or btnp(5) then
        pressed_right=true
    end

    --update layers
    self.player:update(pressed_right)
    self.camera:update(self.player.pos.y)
    self.columns:update(self.tile_width,self.tile_height,self.camera.y)

    --collision detection
    local is_colliding=self.columns:collide(self.player)
    if is_colliding then
        -- log("colliding")
    end
end

function game_scene:draw()
    cls()
    self.camera:draw()
    self.background:draw()
    self.columns:draw(self.tile_width,self.tile_height)
    self.player:draw()
end