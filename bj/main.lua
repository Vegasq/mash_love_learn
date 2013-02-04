require "socket"
require "math"

anim = require "game/anim"
define = require "game/define"
drawer = require "game/drawer"
enem = require "game/enem"
gameplay = require "game/gameplay"

briefing = require "briefing/briefing"

gameover = require "gameover/gameover"
menu = require "menu/menu"
utils = require "utils"
-- ProFi = require 'ProFi'
-- ProFi:start()

function love.load()
    drawer:init()
    define:init()
    menu:init()
    enem:init()
    define:init_levels()
end

function love.update(dt)

    local game_status = define:get_game_status()
    if game_status == 'menu' then
        menu:update()
    elseif game_status == 'game' then
        gameplay:update()
    elseif game_status == 'gameover' then
        gameover:update()
    elseif game_status == 'briefing' then
        briefing:update()
    end
end

function love.draw()
    local game_status = define:get_game_status()
    if game_status == 'menu' then
        menu:draw()
    elseif game_status == 'game' then
        gameplay:draw()
    elseif game_status == 'gameover' then
        gameover:draw()
    elseif game_status == 'briefing' then
        briefing:draw()
    end
end

function love.quit()
--    ProFi:stop()
--    ProFi:writeReport( 'MyProfilingReport.txt' )
end