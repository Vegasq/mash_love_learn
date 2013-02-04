gameover = {}
function gameover:draw()
    love.graphics.setFont(font50);
    love.graphics.printf("Game Over\n You're score: "..score, 100, 300, 1100, 'center')
end
return gameover