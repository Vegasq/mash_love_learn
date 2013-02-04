briefing = {}

function briefing:draw()
    if(score > 0) then
        love.graphics.setFont(font50);
        love.graphics.printf("Next level!\n You're score: "..score, 100,300, 1000, 'center')
    end
    love.graphics.setFont(font);
    love.graphics.printf(gCurrent_level.description, 100, 500, 1100, 'center')
    love.graphics.printf('Press Space to continue', 100, 600, 1100, 'center')


end

function briefing:update()
    down = love.keyboard.isDown( ' ' )
    if down then
        score=0
        define:set_game_status('game')
    end
end

return briefing