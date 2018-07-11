
local piece = {};

function piece.new(this, blocksize, ppm)
    this.grid = {
        {1,1,1,1},
        {1,1,1,1},
        {1,1,1,1},
        {1,1,1,1},
    }
    this.x = 0;
    this.y = 0;
    this.s = blocksize * ppm;
end

function piece.draw(this)
    for i = 0,3 do
        for j = 0,3 do 
            if (this.grid[j+1][i+1] == 1) then
                love.graphics.rectangle('line',
                    (this.x*this.s) + (i * this.s),
                    ((this.y-2)*this.s) + (j * this.s),
                    this.s,
                    this.s
                )
            end
        end
    end
    love.graphics.print('x: '..this.x..' ; y: '..this.y,
        10,10
    )

end

return piece
