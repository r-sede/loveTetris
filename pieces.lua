local function randomGrid()
end

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

local piece = {};

function piece.new(this, blocksize, ppm)
    this.rotIndex=1;
    this.grid = t();
    this.x = 0;
    this.y = 0;
    this.s = blocksize * ppm;
end

function piece.rot(this,clockwise)
    local tempIndex = clockwise and this.rotIndex + 1 or this.rotIndex - 1;

    if(tempIndex > table.getn(this.grid)) then
        tempIndex = 1;
    elseif (tempIndex < 1) then
        tempIndex = table.getn(this.grid)
    end

    this.rotIndex = tempIndex;
end

function piece.trans(this,left)
    local tempX = left and this.x -1 or this.x + 1;
    --colision
    this.x= tempX;

end

function piece.draw(this)
    for i = 0,3 do
        for j = 0,3 do 
            if (this.grid[this.rotIndex][j+1][i+1] == 1) then
                love.graphics.rectangle('fill',
                    (this.x*this.s) + (i * this.s),
                    (this.y*this.s) + (j * this.s),
                    this.s,
                    this.s
                )
            end
        end
    end
    love.graphics.print('x: '..this.x..' ; y: '..this.y .. ' ; rot: '..this.rotIndex,
        10,10
    )

end

return piece
