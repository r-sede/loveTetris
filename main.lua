local tetGrid, ppm, blockSize,WW,WH;
local lastTick = love.timer.getTime();
local pieces = require'pieces';
local currentPiece = pieces;-- = {x=0;y=0;s=blockSize * ppm};


function love.load()
    blockSize = 8;
    ppm = 4;
    tetGrid = {
        w = 10,
        h = 20,
        board = {}
    }

    for i=1,tetGrid.h do
        table.insert(tetGrid.board, {0,0,0,0,1,0,0,0,0,0});
    end
    tetGrid.board = {
        {1,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,1,1,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,1,0,0,1},
        {1,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,1},
        {1,1,1,1,1,1,1,1,1,1},
    }

    WW = tetGrid.w * blockSize * ppm;
    WH = (tetGrid.h ) * blockSize * ppm;
    
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
    drawGrid()
    currentPiece:draw()
    --love.graphics.rectangle('fill', testPiece.x,testPiece.y,testPiece.s,testPiece.s);
end

function drawGrid()
    --print(empty)
    for i = 0,tetGrid.w-1 do
        for j = 0,tetGrid.h-1 do 
            local mode;
            if (tetGrid.board[j+1][i+1] == 1) then
                mode = 'fill'
            else
                mode='line'
            end
            love.graphics.rectangle(mode,
                (i*ppm * blockSize),
                (j*ppm * blockSize),
                ppm * blockSize,
                ppm * blockSize
            )
        end
    end
end




function love.keypressed(key)
    if(key=='x') then
        currentPiece:rot(true,tetGrid.board)
    end
    if(key=='s') then
        currentPiece:rot(false,tetGrid.board)
    end
    if(key=='left') then
        currentPiece:trans(true,tetGrid.board)
    end
    if(key=='right') then
        currentPiece:trans(false,tetGrid.board)
    end
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