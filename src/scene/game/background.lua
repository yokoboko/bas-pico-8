background={}

function background:new(o)
    o=setmetatable(o or {},self)
    self.__index=self

    --init
    o.tile_width=8 --tiles
    o.tile_height=4 --tiles
    o.x=32
    o.heigh=o.tile_height*8*3 --pixels
    o.tiles={}
    return o
end

function background:update(cam_y)
    --visible
	local min_tile = flr(cam_y/self.heigh)
	local max_tile = ceil((cam_y+128)/self.heigh)

	--delete
	for k,v in pairs(self.tiles) do
		if v<min_tile or v>max_tile then
			self.tiles[k] = nil
		end
	end
	
	--create
	for i=min_tile,max_tile do 
		if self.tiles["t"..i]==nil then 
			self.tiles["t"..i]=i
		end
	end
end

function background:draw()
    for k,v in pairs(self.tiles) do
        local y=v*self.heigh
        spr(136,self.x,y,self.tile_width,self.tile_height)
        spr(136,self.x,y+32,self.tile_width,self.tile_height)
		spr(128,self.x,y+64,self.tile_width,self.tile_height)
	end
end