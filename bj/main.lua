require "socket"
require "math"

anim = require "game/anim"
define = require "game/define"
drawer = require "game/drawer"
enem = require "game/enem"
gameplay = require "game/gameplay"

menu = require "menu/menu"
utils = require "utils"
-- ProFi = require 'ProFi'
-- ProFi:start()

function love.load()
    drawer:init()
    define:init()
    menu:init()
    enem:init()
end

function love.update(dt)
    local game_status = define:get_game_status()
    if game_status == 'menu' then
        menu:update()
    elseif game_status == 'game' then
        gameplay:update()
    end
end

function love.draw()
    if gameplay:check_game_over() then
        return
    end

    local game_status = define:get_game_status()
    if game_status == 'menu' then
        menu:draw()
    elseif game_status == 'game' then
        gameplay:drow()
    end
end

function love.quit()
--    ProFi:stop()
--    ProFi:writeReport( 'MyProfilingReport.txt' )
end