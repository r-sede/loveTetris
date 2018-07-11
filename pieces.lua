
local piece = {};

function piece.new(this, blocksize, ppm)
    this.grid = {
        {0,1,0},
        {0,1,1},
        {0,1,0},
    }
    this.x = 4;
    this.y = 0;
    this.s = blocksize * ppm;
end

function piece.draw(this)
    for i = 0,2 do
        for j = 0,2 do 
            if (this.grid[i+1][j+1] == 1) then
                love.graphics.rectangle('line',
                    this.x + (j * this.s),
                    this.y + (i * this.s),
                    this.s,
                    this.s
                )
            end
        end
    end

end

return piece
