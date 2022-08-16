function love.load()
    love.window.setTitle( "FURRY game")
    love.graphics.setDefaultFilter("nearest", "nearest")
ts = love.graphics.newImage("titlescreendemo.png")
sti = require "librarys/sti"
anim8 = require "librarys/anim8/anim8"
p={x=13*16,y=7*16,vx=0,vy=0}
p.ss = love.graphics.newImage("colin.png")
p.grid = anim8.newGrid(8, 16, p.ss:getWidth(), p.ss:getHeight())
p.anims = {}
p.anims.down = anim8.newAnimation(p.grid('1-4', 1), 0.2)
p.anims.up = anim8.newAnimation(p.grid('1-4', 2), 0.2)
p.anims.right = anim8.newAnimation(p.grid('1-4', 3), 0.2)
p.anims.left = anim8.newAnimation(p.grid('1-4', 4), 0.2)
p.anim=p.anims.down
option=1
ismoving=false
map = sti("maps/Area1.lua") 
wf = require 'librarys/windfield'
world = wf.newWorld(0,0)
love.graphics.setDefaultFilter("nearest")
love.window.setMode( 1024,512 )
dbugfunctions=false
speed=64
m={x=10,y=0,p=0}
p.collider = world:newRectangleCollider(p.x,p.y,15,15)
p.collider:setAngle(0)
titlescreen=true
dialouge = {}
dialouge.open = false
dialouge.number = 1
dialouge.position = 1
dialouge.closed = 0 
dialouge[1]="....."
dialouge[2]=".........."
dialouge[3]="................"
dialouge[4]="Your eyes sting under the intense light, but you make an effort to open your eyes and take a look at the situation you're in."
dialouge[5]="Through your hazy eyes, you discover that you're in a very unfamiliar room."
dialouge[6]="Your limbs feel weak, your head is spinning, but the most gripping this on your mind is that you feel like you havent eaten anything in years."
dialouge[7]="You possess nothing but a small pair of shorts. You don't even think they're yours."
dialouge[8]="Obviously, you've been kidnapped. Your vauge memories seem to align with this fact as well. You've been kidnapped by someone and they brought you here."
dialouge[9]="You feel very confused, but you clearly understand that the first thing you should do is escape from this room."
dialouge[10]="exit"
dialouge[11]="You looked inside. There's no way you could climb in."
dialouge[12]="However, you hear something that sounds like dragging and slipping around."
dialouge[13]="You should probably stand back."
dialouge[14]="You see a computer with Furry Windows Vista. You try to crawl in but you dont fit."
sanssound = love.audio.newSource("sandsunderman.mp3", "static")
movesound = love.audio.newSource("sound.wav", "static")
tsmusic = love.audio.newSource("TSMusic.mp3", "stream")
font = love.graphics.newFont( "changefont.ttf" )
fontbig = love.graphics.newFont( "changefont.ttf", 20 )
default = love.graphics.newFont(14)
if titlescreen then
tsmusic:play()
end

walls = {}
if map.layers["collision"] then
    for i,obj in ipairs(map.layers["collision"].objects) do
        local wall= world:newRectangleCollider(obj.x*2+16*16,obj.y*2,obj.width*2,obj.height*2)
        wall:setType('static')
        table.insert(walls,wall)
    end
    end
end

function isint(n)
    return n==math.floor(n)
end

function dump(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. dump(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
 end
 function love.keypressed(key, scancode, isrepeat)
    if key == "z" and dialouge.open then
       dialouge.number=dialouge.number+1
       dialouge.position=1
       sanssound:play()
       if dialouge[dialouge.number]=="exit" then
          dialouge.open=false
        dialouge.closed = 0
       end
    end
    if  key == "z" and titlescreen and option==1 then
        tsmusic:stop()
        titlescreen=false
        dialouge.open=true
       elseif key == "z" and titlescreen and option==3 then
        love.window.close()
    end
    if key=="z" and not dialouge.open and dialouge.closed > 0.5 then
        interactable(173,94,192,101,11)
    end
    if titlescreen and option<3 and key=="down" then
        movesound:stop()
        option=option+1
        movesound:play()
    elseif titlescreen and option>1 and key=="up" then
        movesound:stop()
        option=option-1
        movesound:play()
    end
    if key == "x" and dialouge.open then
        dialouge.position=1000
    end
 end

 function interactable(x1,y1,x2,y2,dia)
    if p.x>x1 and p.x<x2 and p.y>y1 and p.y<y2 then
       dialouge.open=true
       dialouge.number=dia
       dialouge.position=1
       sanssound:play()
    end
end

function love.update(dt)
    if not titlescreen then
    dialouge.closed = dialouge.closed+0.15
    p.collider:setAngle(0)
    if dialouge.position < string.len(dialouge[dialouge.number]) then
    dialouge.position = dialouge.position+0.5
    end
    --print("next")
    end
    --if isint(dialouge.position) and dialouge.position < string.len(dialouge[dialouge.number]) then
    --    sanssound:stop()
    --    sanssound:play()
    --end
    if m.p then
        print("x = "..m.x/2 .. " Y = "..m.y/2)
    end
    m.x=love.mouse.getX()
    m.y=love.mouse.getY()
    m.p=love.mouse.isDown( 1 )
    local up    = love.keyboard.isScancodeDown('w', 'up')
	local down  = love.keyboard.isScancodeDown('s', 'down')
	local left  = love.keyboard.isScancodeDown('a', 'left')
	local right = love.keyboard.isScancodeDown('d', 'right')
    local space = love.keyboard.isScancodeDown('space')
    if not dialouge.open and not titlescreen then
    if up then
        p.vy = speed *-1
        ismoving=true
        p.anim=p.anims.up
    elseif down then 
        p.vy = speed
        ismoving=true
        p.anim=p.anims.down
    else
        p.vy = 0
    end
    if left then
        p.vx = speed * -1
        ismoving=true
        p.anim=p.anims.left
    elseif right then
        p.vx = speed
        ismoving=true
        p.anim=p.anims.right
    else
        p.vx = 0
    end
end

    if not up and not down and not left and not right then
        ismoving=false
    end
        p.anim:update(dt)
    if ismoving == false then
        p.anim:gotoFrame(2)
    end
    if space then  
        dialouge.open = true
    end
    p.x = p.x + p.vx * dt
    p.y= p.y + p.vy * dt
    p.collider:setLinearVelocity(p.vx,p.vy)
    world:update(dt)
    p.x = p.collider:getX()-8
    p.y = p.collider:getY()-8
end

function love.draw()
    love.graphics.scale( 2, 2 )
    love.graphics.setFont(font)
    if not titlescreen then
    love.graphics.setColor(255,255,255)
    map:draw(0,0,4,4)
--player drawing
    love.graphics.push()
    
    p.anim:draw(p.ss, p.x, p.y-16, 0, 2,2)
    love.graphics.pop()
    if dialouge.open then
        love.graphics.setColor(0.1,0.1,0.1)
        love.graphics.rectangle("fill", 90,160, 320,92)
        love.graphics.setColor(0.5,0.5,0.5)
        love.graphics.rectangle("fill", 95,165, 310,87)
        love.graphics.setColor(1,1,1)
        love.graphics.printf(string.sub(dialouge[dialouge.number],1,dialouge.position), 100,170, 300, "left")
        love.graphics.setFont(default)
        love.graphics.print("^",256,247,3.14159)
    end
--    world:draw()
    else
    love.graphics.draw(ts,0, 0)
    love.graphics.rectangle( "line", 40, 140, 350-45, 214-140)
    love.graphics.print("New Game",fontbig,65,145)
    love.graphics.print("Load Game (doesnt work yet)",fontbig,65,165)
    love.graphics.print("Quit Game",fontbig,65,185)
    love.graphics.print(">",fontbig,50,125+option*20)
    end
end