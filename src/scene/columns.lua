columns={}

function columns:new(o)
 	o=setmetatable(o or {},self)
 	self.__index=self

	--init
 	o.tiles={}
 	return o
end

function columns:update(tile_width,tile_height,cam_y)
	--visible
	local min_tile = flr(cam_y/tile_height)
	local max_tile = ceil((cam_y+128)/tile_height)

	--delete
	for k,v in pairs(self.tiles) do
		if v.idx<min_tile or v.idx>max_tile then
			self.tiles[k] = nil
		end
	end
	
	--create&update
	for i=min_tile,max_tile do 
		if self.tiles["t"..i]==nil then 
			--create [don't add saws to the first few tiles (first from bottom up is 1365)]
			local tile_saw=(i<1361) and saw:new({idx=i,tile_width=tile_width,tile_height=tile_height}) or nil
			self.tiles["t"..i]={idx=i,saw=tile_saw}
		elseif self.tiles["t"..i].saw!=nil then
			--update saw
			self.tiles["t"..i].saw:update()
		end
	end
end

function columns:draw(tile_width,tile_height)
	for k,v in pairs(self.tiles) do
		if (v.saw != nil) v.saw:draw()
		local left_sprite=(v.saw != nil and v.saw.left) and 66 or 64 
		local right_sprite=(v.saw != nil and v.saw.left == false) and 66 or 64
		local y = v.idx*tile_height
		spr(left_sprite,0,y,2,3)
	 	spr(right_sprite,128-tile_width,y,2,3,true)
	end
end

function columns:collide(player)
	for k,v in pairs(self.tiles) do
		if (v.saw != nil and v.saw:collide(player)) return true
	end
	return false
end