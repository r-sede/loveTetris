local tetGrid, ppm, blockSize,WW,WH

local pieces = require'pieces'
local currentPiece = pieces-- = {x=0y=0s=blockSize * ppm}
local shader;
local score=0;
local lineCompl = 0;
local earnedLevel = 1;
local realLevel = 1;
local countDown = (0.05*(11-earnedLevel));
local debugTime = (0.05*(11-earnedLevel));
local freeFallIteration = 0;
local gameOver = false;
local pause = false;

function love.load()
    
    love.graphics.setDefaultFilter('nearest');
    currentPiece.loadSprite('assets/img/tetrisBlock.png')
    blockMove = love.audio.newSource("assets/sfx/tetris_blockmove.ogg", "static")
    blockRotate = love.audio.newSource("assets/sfx/tetris_blockrotate.ogg", "static")
    blockDrop = love.audio.newSource("assets/sfx/tetris_blockdrop.ogg", "static")
    levelUp = love.audio.newSource("assets/sfx/tetris_levelup.ogg", "static")
    lineClear = love.audio.newSource("assets/sfx/tetris_lineclear.ogg", "static")
    fourLineClear = love.audio.newSource("assets/sfx/tetris_4lines.ogg", "static")
    backMusic = love.audio.newSource("assets/sfx/tetris_music.ogg","stream")
    goverMusic = love.audio.newSource("assets/sfx/tetris_gameover.ogg","stream")
    backMusic:setLooping(true);
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
    backMusic:play()

end

function love.update (dt)
    if(gameOver) then return end
    if(pause) then return end

    countDown = countDown-dt;
    if (countDown <= 0) then
        local fallRes = currentPiece:fall(tetGrid.board)
        if (fallRes == false) then
            copyToBoard()
            freeFallIteration = freeFallIteration + 1;
            iter()
        end

        countDown = (0.05*(11-realLevel))
        debugTime = countDown;
    end
    
end


function love.draw()
    drawGrid()
    currentPiece:draw()
    love.graphics.print('score :'..score, 400, 10)
    love.graphics.print('line :'..lineCompl, 400, 25)
    love.graphics.print('earnedLevel :'..earnedLevel, 400, 40)
    love.graphics.print('realLevel :'..realLevel, 400, 55)
    love.graphics.print('countDown :'..debugTime, 400, 70)
    love.graphics.print('freeFallIteration :'..freeFallIteration, 400, 70+15)
    local pauseStr = pause and 'pause' or 'play';
    love.graphics.print('pause ? :'..pauseStr, 400, 70+15+15)
    local gameStr = gameOver and 'gameOver' or 'alive';
    love.graphics.print('gameOver ? :'..gameStr, 400, 70+15+15+15)
    
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
        --reset()
        print('pause')
        if (pause == false) then 
            pause = true 
            backMusic:pause()
        else 
            backMusic:play()
            pause = false
            
        end
    end
    if(key=='down') then
        currentPiece:drop(tetGrid.board)
        blockDrop:play()
        copyToBoard()
        freeFallIteration = 0;
        iter()
    end
    if(key=='escape') then
        love.event.quit()
    end
end

function iter()
    currentPiece:new(ppm,blockSize)
    score = score + ( (21 + (3 * realLevel)) - freeFallIteration );
    local completedLine,lineToDelete = checkLine()
    if (completedLine > 0) then
        if(completedLine ==4) then fourLineClear:play() else lineClear:play() end
        removeLine(lineToDelete);
        addPoints(completedLine);
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
    for ii=1,10 do
        if tetGrid.board[1][ii] == 1 then
            gameOver = true;
            backMusic:stop()
            goverMusic:play()
            return
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
    lineCompl=lineCompl+completedLine
    if (lineCompl <= 0) then
        earnedLevel = 1;
    elseif ((lineCompl >= 1) and (lineCompl <= 90)) then
        earnedLevel = 1 + ((lineCompl - 1) / 10);
    elseif (lineCompl >= 91) then
        earnedLevel = 10;
    end

    local tempRealLevel = math.floor( earnedLevel )
    if(tempRealLevel > realLevel) then
        realLevel = tempRealLevel;
        levelUp:play();
    end

    
end

function reset()
    currentPiece:new(ppm,blockSize)
end