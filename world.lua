local world = {}
local screenwidth, screenheight = love.graphics.getWidth(), love.graphics.getHeight()

local shader = love.graphics.newShader([[
    #pragma language glsl3;
    extern Image buffer;

    vec4 effect( vec4 color, Image img, vec2 tc, vec2 sc ){
        vec4 pixel = texture(img, tc);
        vec4 pixel_buffer = texture(buffer, tc);
        return pixel;
    }
        
    ]])

local swap = 1
local canvas = {
    [1] = love.graphics.newCanvas(screenwidth, screenheight);
    [2] = love.graphics.newCanvas(screenwidth, screenheight);
}

local buffer = canvas[swap]

world.update = function ()
    shader:send('buffer', buffer)
    if swap == 1 then swap = 2 else swap = 1 end
end

local function draw_once()
    love.graphics.setCanvas(buffer)
    love.graphics.setCanvas()
end

local done = false
world.draw = function ()
    if not done then
        draw_once()
        done = true
    end
    love.graphics.setShader(shader)
    love.graphics.draw(buffer)
    love.graphics.setShader()
end

return world