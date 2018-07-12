local tetGrid, ppm, blockSize,WW,WH

local pieces = require'pieces'
local currentPiece = pieces-- = {x=0y=0s=blockSize * ppm}
local shader;
local score=0;
local earnedLevel=11;
local countDown = 0.55;
local debugTime = 0.55;

function love.load()
    love.graphics.setDefaultFilter('nearest');
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
    
    love.window.setMode(WW+300, WH)
    currentPiece:new(ppm,blockSize)
end

function love.update(dt)    
    local now= love.timer.getTime()
    countDown = countDown-dt;
    if(countDown<=0) then
        local fallRes = currentPiece:fall(tetGrid.board)
        if(fallRes == false) then
            copyToBoard()
            currentPiece:new(ppm,blockSize)
            local completedLine,lineToDelete = checkLine()
            if(completedLine>0) then
                removeLine(lineToDelete);
                addPoints(completedLine);
            end
        end
        -- copy to board
        -- call new 
        -- check line
        -- add points ...
        -- print('tick')
        countDown = (0.05*(11-earnedLevel))
        debugTime = countDown;
    end
    
end


function love.draw()
    drawGrid()
    currentPiece:draw()
    love.graphics.print('score :'..score, 400, 10)
    love.graphics.print('level :'..earnedLevel, 400, 25)
    love.graphics.print('countDown :'..debugTime, 400, 40)
    
end

function drawGrid()
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
            if (currentPiece.grid[currentPiece.rotIndex][j+1][i+1] == 1 ) then
                tetGrid.board[j+1+currentPiece.y][i+1+currentPiece.x] = 1
            end
        end
    end
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

function addPoints(completedLine)
    score=score+completedLine
    if (score <= 0) then
        earnedLevel = 1;
    elseif ((score >= 1) and (score <= 90)) then
        earnedLevel = 1 + ((score - 1) / 10);
    elseif (score >= 91) then
        earnedLevel = 10;
    end
    
end

function reset()
    currentPiece:new(ppm,blockSize)
end