local tetGrid, ppm, blockSize,WW,WH
local lastTick = love.timer.getTime()
local pieces = require'pieces'
local currentPiece = pieces-- = {x=0y=0s=blockSize * ppm}
local shader;

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    currentPiece.loadSprite('assets/img/tetrisBlock.png')
    blockSize = 8
    ppm = 4
    tetGrid = {
        w = 10,
        h = 20,
        board = {}
    }

    for i=1,tetGrid.h do
        table.insert(tetGrid.board, {0,0,0,0,0,0,0,0,0,0})
    end
    -- tetGrid.board = {
    --     {0,0,0,0,0,0,0,0,0,0},
    --     {0,0,0,0,0,0,0,0,0,0},
    --     {0,0,0,0,0,0,0,0,0,0},
    --     {0,0,0,0,0,0,0,0,0,0},
    --     {0,0,0,0,0,0,0,0,0,0},
    --     {0,0,0,0,0,0,0,0,0,0},
    --     {0,0,0,0,0,0,0,0,0,0},
    --     {0,0,0,0,0,0,0,0,0,0},
    --     {0,0,0,0,0,0,0,0,0,0},
    --     {0,0,0,0,0,0,0,0,0,0},
    --     {0,0,0,0,0,0,0,0,0,0},
    --     {0,0,0,0,0,0,0,0,0,0},
    --     {0,0,0,0,0,0,0,0,0,0},
    --     {1,1,1,1,1,1,1,0,0,0},
    --     {0,0,0,0,0,0,0,0,0,0},
    --     {0,0,0,0,0,0,0,0,0,0},
    --     {0,0,0,0,0,0,0,0,0,0},
    --     {0,0,0,0,0,0,0,0,0,0},
    --     {0,0,0,0,0,0,0,0,0,0},
    --     {0,0,0,0,0,0,0,0,0,0},
    -- }

    WW = tetGrid.w * blockSize * ppm
    WH = (tetGrid.h ) * blockSize * ppm
    
    love.window.setMode(WW, WH)
    currentPiece:new(ppm,blockSize)
    --print(currentPiece.grid)
end

function love.update(dt)    
    local now= love.timer.getTime()
    if(now - lastTick >= 1 *0.3) then
        lastTick = now
        local fallRes = currentPiece:fall(tetGrid.board)
        if(fallRes == false) then
            copyToBoard()
            local completedLine,lineToDelete = checkLine()
            print('completedLine: '..completedLine)
            --print('lineToDelete: '..lineToDelete)
            if(completedLine>0) then
                removeLine(lineToDelete);
                --addPoints(completedLine);
            end
        end
                --copy to board
        --check line
        -- add points ...
        -- set call new 
        -- print('tick')
    end
    
end


function love.draw()
    drawGrid()
    currentPiece:draw()
    --love.graphics.rectangle('fill', testPiece.x,testPiece.y,testPiece.s,testPiece.s)
end

function drawGrid()
    --print(empty)
    for i = 0,tetGrid.w-1 do
        for j = 0,tetGrid.h-1 do 
            local mode
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

function copyToBoard()
    for i = 0,3 do
        for j = 0,3 do 
            if (currentPiece.grid[currentPiece.rotIndex][j+1][i+1] == 1) then
                tetGrid.board[j+1+currentPiece.y][i+1+currentPiece.x] = 1
            end
        end
    end
    currentPiece:new(ppm,blockSize)
end

function removeLine(lineToDelete)
    print('removeLine')
    for i=1,#lineToDelete do
        local line = lineToDelete[i]
        table.remove(tetGrid.board, line)
        table.insert(tetGrid.board, 1, {0,0,0,0,0,0,0,0,0,0})
    end
end

function checkLine()
    local completedLine = 0
    local lineToDelete = {}
    for j = 1,tetGrid.h do
        local curLine = 0 
        for i = 1,tetGrid.w do 
            curLine = curLine + tetGrid.board[j][i]
        end
        if(curLine == 10) then
            completedLine = completedLine + 1
            table.insert(lineToDelete, j)

        end
    end
    
    return completedLine, lineToDelete;
end

function reset()
    currentPiece:new(ppm,blockSize)
end