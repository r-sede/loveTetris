tetGrid, ppm, blockSize,WW,WH = nil,nil,nil,nil

local pieces = require'pieces'
currentPiece = pieces-- = {x=0y=0s=blockSize * ppm}

score=0
lineCompl = 0
earnedLevel = 1
realLevel = 1
countDown = (0.05*(11-earnedLevel))
debugTime = (0.05*(11-earnedLevel))
freeFallIteration = 0
gameOver = false
pause = false
displayGrid = false
mute = false
debug = false
TITLESCREEN = nil

CURRENTSTATE = 'title'
pauseStr,gameStr = nil,nil

numberFont=nil
sideText=nil
tetrisSpriteSheet = {}

function love.load(arg)
    love.keyboard.setKeyRepeat(true)
    love.window.setTitle('LoveTetris')
    love.graphics.setDefaultFilter('nearest')
    currentPiece.loadSprite('assets/img/1.png')
    sideText = love.graphics.newImage ('assets/img/side.png')
    
    for i = 1,12 do
        tetrisSpriteSheet[i] = love.graphics.newImage('assets/img/'..i..'.png') 
    end
    
    numberFont = love.graphics.newImageFont("assets/img/tetris_numbers.png","0123456789><")
    
    blockMove = love.audio.newSource("assets/sfx/tetris_blockmove.ogg", "static")
    blockRotate = love.audio.newSource("assets/sfx/tetris_blockrotate.ogg", "static")
    blockDrop = love.audio.newSource("assets/sfx/tetris_blockdrop.ogg", "static")
    levelUp = love.audio.newSource("assets/sfx/tetris_levelup.ogg", "static")
    lineClear = love.audio.newSource("assets/sfx/tetris_lineclear.ogg", "static")
    fourLineClear = love.audio.newSource("assets/sfx/tetris_4lines.ogg", "static")
    backMusic = love.audio.newSource("assets/sfx/tetris_music.ogg","stream")
    goverMusic = love.audio.newSource("assets/sfx/tetris_gameover.ogg","stream")
    
    backMusic:setLooping(true)
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
        WH = (tetGrid.h-2 ) * blockSize * ppm
        TITLESCREEN = love.graphics.newImage('assets/img/titleScreen.png')
        love.window.setMode(WW, WH)

        require'tetrisStates'
        tetrisState[CURRENTSTATE].load(arg)
        
    end
    
    function love.update (dt)
        tetrisState[CURRENTSTATE].update(dt)

end


function love.draw()
    tetrisState[CURRENTSTATE].draw()

end

function drawGrid()
    for i = 0,tetGrid.w-1 do
        for j = 0,tetGrid.h-1 do 
            local mode
            if (tetGrid.board[j+1][i+1] > 0) then
                love.graphics.draw(tetrisSpriteSheet[tetGrid.board[j+1][i+1]],
                    (i*ppm * blockSize),
                    ((j-2)*ppm * blockSize),
                    0,
                    ppm,
                    ppm
                )
            elseif (displayGrid) then
                love.graphics.rectangle('line',
                    (i*ppm * blockSize),
                    ((j-2)*ppm * blockSize),
                    ppm * blockSize,
                    ppm * blockSize
                )
            end
        end
    end
end




function love.keypressed(key)
    tetrisState[CURRENTSTATE].keypressed(key)
end

function iter()
    currentPiece:new(ppm,blockSize)
    score = score + ( (21 + (3 * realLevel)) - freeFallIteration )
    local completedLine,lineToDelete = checkLine()
    if (completedLine > 0) then
        if(completedLine ==4) then fourLineClear:play() else lineClear:play() end
        removeLine(lineToDelete)
        addPoints(completedLine)
    end    
end

function copyToBoard()
    for i = 0,3 do
        for j = 0,3 do 
            if (currentPiece.grid[currentPiece.rotIndex][j+1][i+1] > 0 ) then
                tetGrid.board[j+1+currentPiece.y][i+1+currentPiece.x] = currentPiece.grid[currentPiece.rotIndex][j+1][i+1]
            end
        end
    end
    checkGameOver()
end

function checkGameOver()
    for ii=1,10 do
        if tetGrid.board[3][ii] > 0 then
            gameOver = true
            backMusic:stop()
            goverMusic:play()
            tetrisState.setState('title')
            return
        end
    end
end

function removeLine(lineToDelete)
    --print('removeLine')
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
            if tetGrid.board[j][i] > 0 then
                curLine = curLine + 1
            end
        end
        if(curLine == 10) then
            completedLine = completedLine + 1
            table.insert(lineToDelete, j)
        end
    end
    
    return completedLine, lineToDelete
end

function addPoints(completedLine)
    lineCompl=lineCompl+completedLine
    if (lineCompl <= 0) then
        earnedLevel = 1
    elseif ((lineCompl >= 1) and (lineCompl <= 90)) then
        earnedLevel = 1 + ((lineCompl - 1) / 10)
    elseif (lineCompl >= 91) then
        earnedLevel = 10
    end

    local tempRealLevel = math.floor( earnedLevel )
    if(tempRealLevel > realLevel) then
        realLevel = tempRealLevel
        levelUp:play()
    end

    
end

function reset()
    currentPiece:new(ppm,blockSize)
end