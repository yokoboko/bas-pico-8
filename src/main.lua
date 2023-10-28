--disable btnp repeat
poke(0X5F5C, 255)

function _init()
    current_scene=game_scene:new()
end

function _update60()
    current_scene:update()
end

function _draw()
    current_scene:draw()
end