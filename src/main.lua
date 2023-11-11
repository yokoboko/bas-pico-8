--disable btnp repeat
poke(0X5F5C, 255)

--game data
cartdata("bas_data_1")

function _init()
    current_scene=splash_scene:new()
end

function _update60()
    current_scene:update()
end

function _draw()
    current_scene:draw()
end