game_scene={}

function game_scene:new(o)
    o=setmetatable(o or {},self)
    self.__index=self

    --constants
    o.tile_width = 16
    o.tile_height = 24

    --camera [offset by screen height and 7 pixels to align bottom tile]
    o.cam_y=32767-128-7 

    --layers
    o.background = background:new()
    o.columns = columns:new()
    o.player = player:new()

    return o
end

function game_scene:update()
    self.cam_y+=-0.5
    self.columns:update(self.tile_width,self.tile_height,self.cam_y)
    self.player:update()
end

function game_scene:draw()
    cls()
    camera(0,self.cam_y)
    self.background:draw()
    self.columns:draw(self.tile_width,self.tile_height)
    self.player:draw()
end