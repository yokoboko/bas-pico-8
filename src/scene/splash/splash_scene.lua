splash_scene={}

function splash_scene:new(o)
    o=setmetatable(o or {},self)
    self.__index=self
    o.text="yokoboko"
    o.fading=0
    o.fadespeed=5
    o.start_fadeout=120
    o.count=0
    return o
end

function splash_scene:update()
    if self.count<self.start_fadeout then
        self.count+=1
        if (self.count==self.start_fadeout) self.fading=1
    end
    if self.fading==-1 and self.count==self.start_fadeout then
        current_scene=game_scene:new()
    end
end

function splash_scene:draw()
    cls()
    if (self.fading>0) self:_fadeout()
    if (self.fading<0) return
    local y=47
    spr(204,47,y,4,4)
    print(self.text,63-#self.text*2,y+34,15)
end

function splash_scene:_fadeout()
    local fade,c,p={[0]=0,17,18,19,20,16,22,6,24,25,9,27,28,29,29,31,0,0,16,17,16,16,5,0,2,4,0,3,1,18,2,4}
    self.fading+=1
    if self.fading%self.fadespeed==1 then
        for i=0,15 do
            c=peek(24336+i)
            if (c>=128) c-=112
            p=fade[c]
            if (p>=16) p+=112
            pal(i,p,1)
        end
        if self.fading==7*self.fadespeed+1 then
            cls()
            pal()
            self.fading=-1
        end
    end
end
