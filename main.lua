local tetGrid, ppm, blockSize,WW,WH;
local lastTick = love.timer.getTime();
local pieces = require'pieces';
local currentPiece = pieces;-- = {x=0;y=0;s=blockSize * ppm};


function love.load()
    blockSize = 8;
    ppm = 4;
    tetGrid = {
        w = 10,
        h = 22 
    }
    WW = tetGrid.w * blockSize * ppm;
    WH = (tetGrid.h -2 ) * blockSize * ppm;
    
    love.window.setMode(WW, WH);
    currentPiece:new(ppm,blockSize)
    --print(currentPiece.grid)
end

function love.update(dt)
    local now= love.timer.getTime();
    if(now - lastTick >= 1) then
        lastTick = now;
        currentPiece.y = currentPiece.y + 1;
        -- print('tick')
    end
    
end


function love.draw()
    currentPiece:draw()
    --love.graphics.rectangle('fill', testPiece.x,testPiece.y,testPiece.s,testPiece.s);
end

function love.keypressed(key)
    if(key=='space') then
        reset()
    end
    if(key=='escape') then
        love.event.quit()
    end
end


function reset()
    currentPiece:new(ppm,blockSize)
end