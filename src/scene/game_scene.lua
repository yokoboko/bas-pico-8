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
    o.player = player:new()
    o.camera = game_camera:new({y=o.player.pos.y})
    return o
end

function game_scene:update()
    self.player:update()
    self.camera:update(self.player.pos.y)
    self.columns:update(self.tile_width,self.tile_height,self.camera.y)
    local is_colliding=self.columns:collide(self.player)
    if is_colliding then
        log("colliding")
    end
end

function game_scene:draw()
    cls()
    self.camera:draw()
    self.background:draw()
    self.columns:draw(self.tile_width,self.tile_height)
    self.player:draw()
end