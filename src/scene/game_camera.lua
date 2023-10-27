game_camera={}

function game_camera:new(o)
	o=setmetatable(o or {},self)
	self.__index=self
    
	--init
    o.offset=-72 --player y offset
    o.tracking=20 --slowdown player tracking
    o.track_faster=64 --track faster if player is less than this treshold
	o.y = o.y or 0
    o.y+=o.offset
	return o
end

function game_camera:update(player_y)
    local cam_tracking=self.tracking
    --track faster
    if (player_y-self.y<self.track_faster) cam_tracking/=2.5
    --shift
    self.y-=(self.y-(player_y+self.offset))/cam_tracking
end

function game_camera:draw()
    camera(0,self.y)
end