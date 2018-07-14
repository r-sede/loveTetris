local function o()
    local grids = {
        {
            {0,0,0,0},
            {0,6,6,0},
            {0,6,6,0},
            {0,0,0,0},
        }
    }
    return grids
end

local function i()

    local grids = {
        {
            {0,0,7,0},
            {0,0,8,0},
            {0,0,8,0},
            {0,0,9,0},
        },
        {
            {0,0,0,0},
            {10,11,11,12},
            {0,0,0,0},
            {0,0,0,0},
        }
    }
    return grids
end

local function s()
    local grids = {
        {
            {0,0,0,0},
            {0,0,2,2},
            {0,2,2,0},
            {0,0,0,0},
        },
        {
            {0,0,2,0},
            {0,0,2,2},
            {0,0,0,2},
            {0,0,0,0},
        }
    }
    return grids
end

local function z()
    local grids = {
        {
            {0,0,0,0},
            {0,3,3,0},
            {0,0,3,3},
            {0,0,0,0},
        },
        {
            {0,0,0,3},
            {0,0,3,3},
            {0,0,3,0},
            {0,0,0,0},
        }
    }
    return grids
end

local function l()
    local grids = {
        {
            {0,0,0,0},
            {0,4,4,4},
            {0,4,0,0},
            {0,0,0,0},
        },
        {
            {0,0,4,0},
            {0,0,4,0},
            {0,0,4,4},
            {0,0,0,0},
        },
        {
            {0,0,0,4},
            {0,4,4,4},
            {0,0,0,0},
            {0,0,0,0},
        },
        {
            {0,4,4,0},
            {0,0,4,0},
            {0,0,4,0},
            {0,0,0,0},
        }
    }
    return grids
end

local function j()
    local grids = {
        {
            {0,0,0,0},
            {0,5,5,5},
            {0,0,0,5},
            {0,0,0,0},
        },
        {
            {0,0,5,5},
            {0,0,5,0},
            {0,0,5,0},
            {0,0,0,0},
        },
        {
            {0,5,0,0},
            {0,5,5,5},
            {0,0,0,0},
            {0,0,0,0},
        },
        {
            {0,0,5,0},
            {0,0,5,0},
            {0,5,5,0},
            {0,0,0,0},
        }
    }
    return grids
end

local function t()
    local grids = {
        {
            {0,0,0,0},
            {0,1,1,1},
            {0,0,1,0},
            {0,0,0,0},
        },
        {
            {0,0,1,0},
            {0,0,1,1},
            {0,0,1,0},
            {0,0,0,0},
        },
        {
            {0,0,1,0},
            {0,1,1,1},
            {0,0,0,0},
            {0,0,0,0},
        },
        {
            {0,0,1,0},
            {0,1,1,0},
            {0,0,1,0},
            {0,0,0,0},
        }
    }
    return grids
end


local piece = {}
local tetSpriteSize

local randPieceIndex = {love.math.random( 7 ),love.math.random( 7 )}

local function getGridNumber(n)
    if(n==1) then
        return o()
    elseif(n==2) then
        return i()
    elseif(n==3) then
        return s()
    elseif(n==4) then
        return z()
    elseif(n==5) then
        return l()
    elseif(n==6) then
        return j()
    elseif(n==7) then
        return t()
    end
end

local function getRandomPiece()
    --print('[1]:'..randPieceIndex[1]..' ; [2]:'..randPieceIndex[2])
    local n = table.remove(randPieceIndex,1);
    table.insert( randPieceIndex,  love.math.random( 7 ) )
    return getGridNumber(n);
end

function piece.loadSprite(sprite)
    local tetSprite = love.graphics.newImage(sprite)
    tetSpriteSize = tetSprite:getWidth()
    --print(tetSpriteSize)
end

function piece.new(this, blocksize, ppm)
    this.rotIndex=1
    this.grid = getRandomPiece()
    this.x = 3
    this.y = -1
    this.s = blocksize * ppm
    this.nextGrid = getGridNumber(randPieceIndex[1]);
end

function piece.rot(this,clockwise,board)
    local tempIndex = clockwise and this.rotIndex + 1 or this.rotIndex - 1

    if(tempIndex > table.getn(this.grid)) then
        tempIndex = 1
    elseif (tempIndex < 1) then
        tempIndex = table.getn(this.grid)
    end

    if (this:isCollide(board, this.x, tempIndex)) then
        return
    end
    blockRotate:play()
    this.rotIndex = tempIndex
end

function piece.trans(this,left,board)
    local tempX = left and this.x -1 or this.x + 1
    --colision
    if (this:isCollide(board, tempX, this.rotIndex)) then
        return
    end
    blockMove:play()
    this.x= tempX
end

function piece.fall(this,board)
    local tempY = this.y + 1

    if(this:isOnContact(board, tempY))then

        return false
    end
    this.y = tempY
    return true
end

function piece.drop(this,board)

    while not (this:isOnContact(board, this.y))do
        this.y = this.y + 1
    end
    this.y = this.y -1;
end

function piece.isCollide(this,board,tempX,rotIndex)
    if(this.y <= -1) then return false end
    for i = 0,3 do
        for j = 0,3 do 
            if (this.grid[rotIndex][j+1][i+1] > 0) then
                if(j+1+this.y > table.getn(board) or  board[j+1+this.y][i+1+tempX] == nil or board[j+1+this.y][i+1+tempX] > 0 ) then
                    return true
                end
                --print(board[j+1+this.y][i+1+tempX])
            end
        end
    end
    return false
end

function piece.isOnContact(this,board,tempY)
    if(this.y <= -1) then return false end
    for i = 0,3 do
        for j = 0,3 do 
            if (this.grid[this.rotIndex][j+1][i+1] > 0) then
                if (j+1+tempY > table.getn(board) or board[j+1+tempY][i+1+this.x] > 0)then
                    return true
                end
            end
        end
    end
    return false
end
function piece.draw(this, debug)
    for i = 0,3 do
        for j = 0,3 do 
            if (this.grid[this.rotIndex][j+1][i+1] > 0) then
                love.graphics.draw(tetrisSpriteSheet[this.grid[this.rotIndex][j+1][i+1]],
                    (this.x*this.s) + (i * this.s),
                    ((this.y-2)*this.s) + (j * this.s),
                    0,
                    this.s/tetSpriteSize,
                    this.s/tetSpriteSize                
                )
            end
        end
    end


    for ii = 0,3 do
        for jj = 0,3 do 
            if (this.nextGrid[1][jj+1][ii+1] > 0) then
                love.graphics.draw(tetrisSpriteSheet[this.nextGrid[1][jj+1][ii+1]],
                    368 + (ii * this.s),
                    416 + (jj * this.s),
                    0,
                    this.s/tetSpriteSize,
                    this.s/tetSpriteSize                
                )
            end
        end
    end
    if(debug) then
        love.graphics.print('x: '..this.x..' ; y: '..this.y .. ' ; rot: '..this.rotIndex,
            10,10
        )
    end
end

return piece
