animatable={}

function animatable:new(o)
	o=setmetatable(o or {},self)
	self.__index=self

	--init
	--o.current [current animation name]
    o.animations={}
	o.frame=1
	o.count=1
	o.sprite=0 --[sprite index]
	
	return o
end

function animatable:add_animation(name,duration,list)
	self.animations[name]={duration=duration,list=list}
	if self.current==nil then 
		self.current = name 
		self.sprite = self.animations[self.current].list[self.frame]
	end
end

function animatable:play_animation(name)
	self.current = name
	self.count=1
	self.frame=1
	self.sprite = self.animations[self.current].list[self.frame]
end

function animatable:update_animation()
	if self.current != nil then 
		self.count+=1
		local animation=self.animations[self.current]
		if self.count>animation.duration then
			self.count=1
			self.frame+=1
			if (self.frame>count(animation.list)) self.frame=1
		end
		self.sprite = self.animations[self.current].list[self.frame]
	end
end