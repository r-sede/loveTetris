tetrisState = {}

tetrisState.game = {}
tetrisState.title = {}


tetrisState.game.load = function (arg)
  score=0
  lineCompl = 0
  earnedLevel = 1
  realLevel = 1
  countDown = (0.05*(11-earnedLevel))
  debugTime = (0.05*(11-earnedLevel))
  freeFallIteration = 0
  gameOver = false
  tetGrid = {
    w = 10,
    h = 20,
    board = {}
  }
  
  for i=1,tetGrid.h do
    table.insert(tetGrid.board, {0,0,0,0,0,0,0,0,0,0})
  end
  love.window.setMode(WW+224, WH)
  currentPiece:new(ppm,blockSize)
  backMusic:play()
end

tetrisState.game.exit = function ()
  backMusic:stop()
  
end

tetrisState.game.update = function (dt)
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




tetrisState.game.draw = function ()
  drawGrid()
  love.graphics.draw(sideText,WW,0,0,ppm,ppm)
  currentPiece:draw(debug)
  
  if(debug) then
    love.graphics.print('earnedLevel :'..earnedLevel, 10, 25)
    love.graphics.print('countDown :'..debugTime, 10, 25+15)
    love.graphics.print('freeFallIteration :'..freeFallIteration, 10, 25+15+15)
    pauseStr = pause and 'pause' or 'play';
    love.graphics.print('pause ? :'..pauseStr, 10, 25+15+15+15)
    gameStr = gameOver and 'gameOver' or 'alive';
    love.graphics.print('gameOver ? :'..gameStr, 10, 25+15+15+15+15)
  end
  
  love.graphics.setFont(numberFont,32)
  love.graphics.print(score, 368, 96)
  love.graphics.print(realLevel, 416, 96+96+32)
  love.graphics.print(lineCompl, 416, 96+96+32+96)
  love.graphics.setNewFont(14)
end

tetrisState.game.keypressed = function (key)
  if(key=='x' and not pause) then
    currentPiece:rot(true,tetGrid.board)
  end
  if(key=='s' and not pause) then
    currentPiece:rot(false,tetGrid.board)
  end
  if(key=='left' and not pause) then
    currentPiece:trans(true,tetGrid.board)
  end
  if(key=='right' and not pause) then
    currentPiece:trans(false,tetGrid.board)
  end
  if(key=='g') then
    --print('grid')
    if (displayGrid == false) then 
      displayGrid = true 
    else 
      displayGrid = false
    end
  end 
  if(key=='d') then
    --print('debug')
    if (debug == false) then 
      debug = true 
    else 
      debug = false
    end
  end  
  if(key=='space') then
    --reset()
    --print('pause')
    if (pause == false) then 
      pause = true
      if not (mute) then 
        backMusic:pause()
      end
    else
      if not(mute) then 
        backMusic:play()
      end
      pause = false
    end
  end
  if(key=='m') then
    --reset()
    --print('mute')
    if (mute == false) then 
      mute = true 
      backMusic:pause()
    else 
      backMusic:play()
      mute = false
    end
  end
  if(key=='down' and not pause) then
    currentPiece:drop(tetGrid.board)
    blockDrop:play()
    copyToBoard()
    freeFallIteration = 0;
    iter()
  end
  if(key=='escape') then
    tetrisState.setState('title')
  end
end
-----------------------------------------
---------------TITLE---------------------
-----------------------------------------
MENU = {'scores','play','credit' }
MENUCURSOR = 1
MENUPOS = 
{
  {(WW*0.35) - (20) , WH*0.5},
  {(WW*0.35) - (20) , (WH*0.5) +(32)},
  {(WW*0.35) - (20) , (WH*0.5) +(64)}
}

tetrisState.title.load = function(arg)
  --start music
  MENUCURSOR = 1
  love.window.setMode(WW, WH)
end

tetrisState.title.exit = function()
  --endMusic
end

tetrisState.title.update = function(dt)
  
end

tetrisState.title.draw = function(arg)
  love.graphics.draw(TITLESCREEN, 0, 0, 0, 1, 1)
  --love.graphics.print(HIGHSCORE[1], PPM * VW * 0.40, 23*PPM,0,2*PPM,2*PPM)
  love.graphics.setColor(52/255,104/255,81/255,1)
  love.graphics.print(MENU[1], WW*0.35, WH*0.5, 0, 2, 2)
  love.graphics.print(MENU[2], WW*0.35,  (WH*0.5) +(32), 0, 2, 2)
  love.graphics.print(MENU[3], WW*0.35,  (WH*0.5) +(64), 0, 2, 2)
  love.graphics.print('>', MENUPOS[MENUCURSOR][1],MENUPOS[MENUCURSOR][2],0,2,2)
  love.graphics.setColor(1,1,1,1)
end

tetrisState.title.keypressed = function(key)
  if key == 'return' then
    --if MENUCURSOR == 1 then pacMan_states.setState('scores') end
    if MENUCURSOR == 2 then tetrisState.setState('game') end
    if MENUCURSOR == 3 then return end
  end
  if key == 'escape' then love.event.quit() end
  if key == 'up' then
    MENUCURSOR = MENUCURSOR - 1
    if MENUCURSOR < 1 then MENUCURSOR = #MENU end
  end
  if key == 'down' then
    MENUCURSOR = MENUCURSOR + 1
    if MENUCURSOR > #MENU then MENUCURSOR = 1 end
  end
end

tetrisState.setState = function(state)
  tetrisState[CURRENTSTATE].exit()
  CURRENTSTATE = state
  tetrisState[CURRENTSTATE].load()
end