dofile("common.inc");
dofile("constants.inc");


function doit()

	askForWindow("Trials");  
	

  while 1 do
    pos = getMousePos();


  if lsShiftHeld() then
    while lsShiftHeld() do
      sleepWithStatus(100, "Release Shift Key", nil, 0.7)
    end
  lastPos = pos
  sleepWithStatus(100, "Fight!", nil, 0.7)
  fight()
end



  if lsAltHeld() then
    while lsAltHeld() do
      sleepWithStatus(100, "Release Alt Key", nil, 0.7)
    end
  lastPos = pos
  sleepWithStatus(100, "Looting!", nil, 0.7)
  loot()
end


  sleepWithStatus(100, "Tap SHIFT Castle to Fight.\n\nTap ALT over Chest to Loot\n\nPos: " .. pos[0] .. ", " .. pos[1], nil, 0.7)


  end
end


function fight()
local bigX2 = nil;
local bbigX2 = nil;
local marchWait = 0;
local marchAttempts = 0;
  srClickMouse(pos[0], pos[1]) -- Click on Castle
  sleepWithStatus(500, "Clicking Castle", nil, 0.7)
  srClickMouse(pos[0]+175, pos[1]) -- Click on Challenge
  sleepWithStatus(500, "Clicking Challenge", nil, 0.7)
  srClickMouse(1400, 875)  -- Click March Button
  sleepWithStatus(500, "Clicking March", nil, 0.7)




while not bigX2 do
srReadScreen();
bigX2 = srFindImage("redX_BIG2.png",10000);
marchWait = marchWait + 1;
if marchWait == 3 then -- 1 second since each wait is 100ms
  sleepWithStatus(100, "Trying March again", nil, 0.7)
  marchWait = 0;
  srClickMouse(1400, 875)  -- Click March Button
  marchAttempts = marchAttempts + 1;
end
sleepWithStatus(100, "Searching for Red X", nil, 0.7)

if marchAttempts == 2 then
  break;
end


end 


if bigX2 then
  srClickMouse(bigX2[0]+20, bigX2[1]+20)  -- Click Collect Red X (Big 2)
else
  srClickMouse(1547, 154)  -- Click Collect Red X (Big 2)
end

sleepWithStatus(100, "Clicked Red X", nil, 0.7)


while not bbigX2 do
  srReadScreen();
  bbigX2 = srFindImage("beigeX_BIG2.png");
  marchWait = marchWait + 1;
  if marchWait == 3 then -- 1 second since each wait is 100ms
    break;
  end
sleepWithStatus(100, "Searching for Beige X", nil, 0.7)
end 


if bbigX2 then
  srClickMouse(bbigX2[0]+20, bbigX2[1]+20);
  sleepWithStatus(100, "Clicked Beige X", nil, 0.7)
  else
    srClickMouse(1591, 91)  -- Click Collect Beige X
  end
  srSetMousePos(lastPos[0], lastPos[1])
end


function loot()
  srClickMouse(pos[0], pos[1]) -- Click on Chest
sleepWithStatus(100, "Clicked Chest", nil, 0.7)
  srClickMouse(930, 673)  -- Click Collect Button
sleepWithStatus(100, "Clicked Collect Button", nil, 0.7)
  srSetMousePos(lastPos[0], lastPos[1])
end
