menu = {}

function menu:init()
	self.menu = {}
    self.top = 200
    self.offset = 50
    logo = {name='logo', text='Black January', x=50, y=400, w=0, h=0, font=font50, color=0}
    start_game = {name='start_game', text='Start Game', x=50, y=500, w=200, h=30, font=font, color=0}
	exit_game = {name='exit_game', text='Exit Game', x=50, y=550, w=200, h=30, font=font, color=0}
    table.insert(self.menu, logo)
    table.insert(self.menu, start_game)
	table.insert(self.menu, exit_game)
end

function menu:update()
    local x, y = love.mouse.getPosition()
    local color

    for i,v in ipairs(self.menu) do
        if utils:CheckCollision(v.x, v.y, v.w, v.h, x, y, 10, 10) then
            color = {r=0,g=0,b=255,a=255}
            down = love.mouse.isDown( 'l' )
            if down then
                if v.name == 'start_game' then
                    love.mouse.setVisible(false)
                    define:set_game_status('game')
                elseif v.name == 'exit_game' then
                    love.event.push("quit")
                end
            end
        else
            color = {r=255,g=255,b=255,a=255}
        end
        v.color=color
    end
end

function menu:draw()
    for i,v in ipairs(self.menu) do
        love.graphics.setFont(v.font)
        love.graphics.setColor(v.color.r, v.color.g, v.color.b, v.color.a)
        
        love.graphics.print(v.text, v.x, v.y)
    end
end

return menu