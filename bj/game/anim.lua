anim = {}
animations = {}
animations_counter = 0

function anim:remove(name)
    for i,v in ipairs(animations) do
        if v.name == name then
            table.remove(animations, i)
            break
        end
    end
    for i,v in ipairs(gAnimations) do
        if v == name then
            table.remove(gAnimations, i)
            break
        end
    end
end

function anim:create_anim(name, anim_image, anim_frame_w, anim_frame_h, type ,x, y)
    if animations_counter > 10 then
        return false
    end
    local now_time = socket.gettime()*1000

    local a = { name=name,
				img=anim_image,
				frame_width=anim_frame_w,
				frame_height=anim_frame_h,
				type=type,
				current_frame=1,
				x=x,
				y=y,
                timer = now_time,
                w=anim_image:getWidth(),
                h=anim_image:getHeight()
			}
    animations[name] = a
    return name
end

function anim:draw(name)
    if animations[name] == nill 
        then return
    end


    local now_time = socket.gettime()*1000
    if now_time - animations[name].timer > 50 then
        animations[name].current_frame = animations[name].current_frame + 1
        animations[name].timer = now_time
    end

    local w_count = animations[name].w / animations[name].frame_width
    local h_count = animations[name].h / animations[name].frame_height

    local status = true

    local line = math.ceil(animations[name].current_frame / w_count)
    local row = (line * w_count) - animations[name].current_frame

    local www = line * animations[name].frame_width - animations[name].frame_width
    local hhh = row * animations[name].frame_height


    local q = love.graphics.newQuad(
        hhh,
        www,
        animations[name].frame_width,
        animations[name].frame_height,
        animations[name].w,
        animations[name].h
    )
	love.graphics.drawq( animations[name].img, q, animations[name].x, animations[name].y, 0, 1, 1, 0, 0)

    if animations[name].current_frame > math.floor(w_count*h_count) then
        if animations[name].type == 'loop' 
            then animations[name].current_frame = 1
        end
        if animations[name].type == 'once' then 
            animations[name] = nil
            for i,v in ipairs(gAnimations) do
                if v == name then
                    table.remove(gAnimations, i)
                end
            end
        end
    end
end

return anim