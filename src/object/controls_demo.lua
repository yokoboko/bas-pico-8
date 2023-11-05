controls_demo={}

function controls_demo:new(o)
    o=setmetatable(o or {},self)
    self.__index=self

    --init
    o.width=38
    o.height=22
    o.x=63-flr(o.width/2)
    o.y=0
    o.offset_y=66
    o.col=13
    o.active_col=15
    o.anim_idx=1
    o.anim_t=0
    --s: start; c: change; d: duration; out: ease out/in; lb: left button pressed; rb: right pressed; f: flip char at the end of the animation
    o.animations={
        --jump left side
        {s=0,c=0.3,d=14,out=true,lb=true},
        {s=0.3,c=-0.3,d=14,out=false},
        {s=0,c=0,d=8,out=true},
        {s=0,c=0.3,d=14,out=true,lb=true},
        {s=0.3,c=-0.3,d=14,out=false},
        {s=0,c=0,d=8,out=true},
        {s=0,c=0.3,d=14,out=true,lb=true},
        {s=0.3,c=-0.3,d=14,out=false},
        {s=0,c=0,d=8,out=true},

        --change direction
        {s=0,c=1,d=24,out=true,rb=true,f=true},
        {s=1,c=0,d=24,out=true},

        --jump right side
        {s=1,c=-0.3,out=true,d=14,rb=true},
        {s=0.7,c=0.3,out=false,d=14},
        {s=1,c=0,d=8,out=true},
        {s=1,c=-0.3,out=true,d=14,rb=true},
        {s=0.7,c=0.3,out=false,d=14},
        {s=1,c=0,d=8,out=true},
        {s=1,c=-0.3,out=true,d=14,rb=true},
        {s=0.7,c=0.3,out=false,d=14},
        {s=1,c=0,d=8,out=true},

        --change direction
        {s=1,c=-1,d=24,out=true,lb=true,f=false},
        {s=0,c=0,d=24,out=true},
    }
    o.char_x=0
    o.char_width=8
    o.char_height=4
    o.char_flip=false
    o.lbtn_pressed=0
    o.rbtn_pressed=0
    return o
end

function controls_demo:update(pos_y)
    self.y=pos_y+self.offset_y

    --update animation index and time
    local anim=self.animations[self.anim_idx]
    self.anim_t=self.anim_t+1
    if (self.anim_t>anim.d/2 and anim.f!=nil) self.char_flip=anim.f
    if self.anim_t>=anim.d then
        self.anim_idx+=1
        self.anim_t=0
     
        if (self.anim_idx>#self.animations) self.anim_idx=1
        anim=self.animations[self.anim_idx]
        if anim.lb then
            self.lbtn_pressed=14
        elseif anim.rb then
            self.rbtn_pressed=14
        end
       
    else
        self.lbtn_pressed=max(self.lbtn_pressed-1,0)
        self.rbtn_pressed=max(self.rbtn_pressed-1,0)
    end

    --update rect_x
    local anim_value=ternary(anim.out,easing_cubic_out(self.anim_t,anim.s,anim.c,anim.d),easing_cubic_in(self.anim_t,anim.s,anim.c,anim.d))
    self.char_x=anim_value*(self.width-self.char_width)
end 

function controls_demo:draw()
    --vertical lines
    line(self.x,self.y,self.x,self.y+self.height-4,self.active_col)
    line(self.x+self.width-1,self.y,self.x+self.width-1,self.y+self.height-4,self.active_col)

    --char
    spr(37,self.x+self.char_x,self.y+6,1,1,self.char_flip)

    --button icons
    local left_col=self.lbtn_pressed>0 and self.active_col or self.col
    palt(0,false)
    palt(11,true)
    print("⬅️",self.x-3,self.y+self.height,0)
    print("⬅️",self.x-3,self.y+self.height-1,left_col)
    print("🅾️",self.x-3,self.y+self.height+7,0)
    print("🅾️",self.x-3,self.y+self.height+6,self.col)

    local left_col=self.rbtn_pressed>0 and self.active_col or self.col
    print("➡️",self.x+self.width-4,self.y+self.height,0)
    print("➡️",self.x+self.width-4,self.y+self.height-1,left_col)
    print("❎",self.x+self.width-4,self.y+self.height+7,0)
    print("❎",self.x+self.width-4,self.y+self.height+6,self.col)
    palt()
end