


local function o()
    local grids = {
        {
            {0,0,0,0},
            {0,1,1,0},
            {0,1,1,0},
            {0,0,0,0},
        }
    }
    return grids
end



local function i()

    local grids = {
        {
            {0,0,1,0},
            {0,0,1,0},
            {0,0,1,0},
            {0,0,1,0},
        },
        {
            {0,0,0,0},
            {1,1,1,1},
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
            {0,0,1,1},
            {0,1,1,0},
            {0,0,0,0},
        },
        {
            {0,0,1,0},
            {0,0,1,1},
            {0,0,0,1},
            {0,0,0,0},
        }
    }
    return grids
end

local function z()
    local grids = {
        {
            {0,0,0,0},
            {0,1,1,0},
            {0,0,1,1},
            {0,0,0,0},
        },
        {
            {0,0,0,1},
            {0,0,1,1},
            {0,0,1,0},
            {0,0,0,0},
        }
    }
    return grids
end

local function l()
    local grids = {
        {
            {0,0,0,0},
            {0,1,1,1},
            {0,1,0,0},
            {0,0,0,0},
        },
        {
            {0,0,1,0},
            {0,0,1,0},
            {0,0,1,1},
            {0,0,0,0},
        },
        {
            {0,0,0,1},
            {0,1,1,1},
            {0,0,0,0},
            {0,0,0,0},
        },
        {
            {0,1,1,0},
            {0,0,1,0},
            {0,0,1,0},
            {0,0,0,0},
        }
    }
    return grids
end

local function j()
    local grids = {
        {
            {0,0,0,0},
            {0,1,1,1},
            {0,0,0,1},
            {0,0,0,0},
        },
        {
            {0,0,1,1},
            {0,0,1,0},
            {0,0,1,0},
            {0,0,0,0},
        },
        {
            {0,1,0,0},
            {0,1,1,1},
            {0,0,0,0},
            {0,0,0,0},
        },
        {
            {0,0,1,0},
            {0,0,1,0},
            {0,1,1,0},
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

local function getRandomPiece()
    local n = love.math.random( 7 )
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

local piece = {}
local tetSprite,tetSpriteSize

function piece.loadSprite(sprite)
    tetSprite = love.graphics.newImage(sprite)
    tetSpriteSize = tetSprite:getWidth()
    print(tetSpriteSize)
end

function piece.new(this, blocksize, ppm)
    this.rotIndex=1
    this.grid = getRandomPiece()
    this.x = 0
    this.y = 0
    this.s = blocksize * ppm
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

    this.rotIndex = tempIndex
end

function piece.trans(this,left,board)
    local tempX = left and this.x -1 or this.x + 1
    --colision
    if (this:isCollide(board, tempX, this.rotIndex)) then
        return
    end
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

function piece.isCollide(this,board,tempX,rotIndex)
    for i = 0,3 do
        for j = 0,3 do 
            if (this.grid[rotIndex][j+1][i+1] == 1) then
                if(j+1+this.y > table.getn(board) or board[j+1+this.y][i+1+tempX] == 1 or board[j+1+this.y][i+1+tempX] == nil) then
                    return true
                end
                --print(board[j+1+this.y][i+1+tempX])
            end
        end
    end
    return false
end

function piece.isOnContact(this,board,tempY)
    for i = 0,3 do
        for j = 0,3 do 
            if (this.grid[this.rotIndex][j+1][i+1] == 1) then
                if (j+1+tempY > table.getn(board) or board[j+1+tempY][i+1+this.x] == 1)then
                    return true
                end
            end
        end
    end
    return false
end

function piece.draw(this)
    for i = 0,3 do
        for j = 0,3 do 
            if (this.grid[this.rotIndex][j+1][i+1] == 1) then
                -- love.graphics.rectangle('fill',
                --     (this.x*this.s) + (i * this.s),
                --     (this.y*this.s) + (j * this.s),
                --     this.s,
                --     this.s
                -- )
                love.graphics.draw(tetSprite,
                    (this.x*this.s) + (i * this.s),
                    (this.y*this.s) + (j * this.s),
                    0,
                    this.s/tetSpriteSize,
                    this.s/tetSpriteSize                
                )
            end
        end
    end
    love.graphics.print('x: '..this.x..' ; y: '..this.y .. ' ; rot: '..this.rotIndex,
        10,10
    )
end

return piece
