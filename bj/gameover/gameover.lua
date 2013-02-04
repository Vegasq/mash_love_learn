gameover = {}
function gameover:draw()
    love.graphics.setFont(font50);
    love.graphics.printf("Game Over\n You're score: "..score, 100, 300, 1100, 'center')
end
function gameover:update()
    down = love.keyboard.isDown( ' ' )
    if down then
        score=0
        define:set_game_status('menu')
    end
end
return gameover