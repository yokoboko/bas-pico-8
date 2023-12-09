game_over={}

function game_over:new(o)
    o=setmetatable(o or {},self)
    self.__index=self
    
    --init
    o.x=63
    o.y=38
    o.circles={
        {x=o.x,y=o.y,r=28,d=16},
        {x=o.x,y=o.y+24,r=8,d=18},
        {x=o.x-20,y=o.y-20,r=8,d=20},
        {x=o.x-20,y=o.y+32,r=2,d=22},
        {x=o.x+20,y=o.y-34,r=1,d=24},
        {x=o.x+20,y=o.y+34,r=4,d=26},
        {x=o.x-39,y=o.y+10,r=3,d=28},
        {x=o.x-32,y=o.y+18,r=1,d=28},
    }
    o.cam_y=0
    o.player_x=0
    o.player_y=0
    o.anim_t=0
    o.score=nil
    o.highscore=false

    o.particles={}
    o.explode_size=3
    o.explode_colors={8,8,8,4}
    o.explode_amount=10
	return o
end

function game_over:update(cam_y,player_pos,score)
    self.cam_y=cam_y
    self.player_x=player_pos.x+8
    self.player_y=player_pos.y-cam_y+8

    --set score, highscore and explode
    if self.score==nil then
        self.score=score
        local highscore=dget(0)
        if score>highscore then
            dset(0, score)
            self.highscore=highscore!=0
        else
            self.highscore=false
        end
        self:explode(player_pos.x,
                     player_pos.y,
                     self.explode_size,
                     self.explode_colors,
                     self.explode_amount)
        sfx(25)
    end

    --update particles
    for p in all(self.particles) do
        --lifetime
        p.t+=1
        if p.t>p.die then del(self.particles,p) end

        --color depends on lifetime
        if p.t/p.die < 1/#p.c_table then
            p.c=p.c_table[1]

        elseif p.t/p.die < 2/#p.c_table then
            p.c=p.c_table[2]

        elseif p.t/p.die < 3/#p.c_table then
            p.c=p.c_table[3]

        else
            p.c=p.c_table[4]
        end

        --physics
        if p.grav then p.dy+=.5 end
        if p.grow then p.r+=.1 end
        if p.shrink then p.r-=.1 end

        --move
        p.x+=p.dx
        p.y+=p.dy
    end 
end

function game_over:draw()
    --explosion
    for p in all(self.particles) do
        --draw pixel for size 1, draw circle for larger
        if p.r<=1 then
            pset(p.x,p.y,p.c)
        else
            circfill(p.x,p.y,p.r,p.c)
        end
    end

    --circless
    self.anim_t=min(self.anim_t+1,100)
    for c in all(self.circles) do
        local t=min(self.anim_t,c.d)
        local x=easing_cubic_out(t,self.player_x,c.x-self.player_x,c.d)
        local y=easing_cubic_out(t,self.player_y,c.y-self.player_y,c.d)
        local r=easing_cubic_out(t,0,c.r,c.d)
        circfill(x,self.cam_y+y,r,8)
        circfill(x,self.cam_y+y,r,8)
    end
    
    --text
    if self.anim_t>=10 then
        print("\^igame over\n",self.x-17,self.cam_y+self.y-8,2)
        line(self.x-19,self.cam_y+self.y-8,self.x-19,self.cam_y+self.y-4,2)
        line(self.x+19,self.cam_y+self.y-8,self.x+19,self.cam_y+self.y-4,2)
        if self.highscore then
            print("new",self.x-6,self.cam_y+self.y+2)
            print("highscore",self.x-18,self.cam_y+self.y+8)
            print(self.score,64-flr((#tostr(self.score)*4)/2),self.cam_y+self.y+16)
        else
            print("score",self.x-9,self.cam_y+self.y+7)
            print(self.score,64-flr((#tostr(self.score)*4)/2),self.cam_y+self.y+15)
        end
    end
end

-- explosion effect
function game_over:explode(x,y,r,c_table,num)
    for i=0,num do
        self:add_particle(
            x,         -- x
            y,         -- y
            20+rnd(10),-- die
            rnd(2)-1,  -- dx
            rnd(2)-1,  -- dy
            false,     -- gravity
            false,     -- grow
            true,      -- shrink
            r,         -- radius
            c_table    -- color_table
        )
    end
end

function game_over:add_particle(x,y,die,dx,dy,grav,grow,shrink,r,c_table)
    local fx={
        x=x,
        y=y,
        t=0,
        die=die,
        dx=dx,
        dy=dy,
        grav=grav,
        grow=grow,
        shrink=shrink,
        r=r,
        c=0,
        c_table=c_table
    }
    add(self.particles,fx)
end