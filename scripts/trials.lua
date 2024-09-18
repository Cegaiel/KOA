dofile("common.inc");
dofile("constants.inc");

waitTime = 2000; -- How many ms (1000 = 1 second) to wait for an image to appear before giving up

function doit()

	askForWindow("Trials Assistance. This will allow you to Tap Shift button over Castle to quickly attack it and close window out.\n\nYou can then Tap Alt button over a chest to quickly loot it.\n\nMouse over Blue Stacks window and press Shift key to continue.");  
	
  checkWindowSize();

  while 1 do
    pos = getMousePos();

    if lsShiftHeld() then
      while lsShiftHeld() do
        sleepWithStatus(100, "Release Shift Key", nil, 0.7)
      end
      lastPos = pos
      sleepWithStatus(100, "Fight!", nil, 0.7)
      fight();
    end

    if lsAltHeld() then
      while lsAltHeld() do
        sleepWithStatus(100, "Release Alt Key", nil, 0.7)
      end
      lastPos = pos
      sleepWithStatus(100, "Looting!", nil, 0.7)
      loot();
    end

    sleepWithStatus(100, "Tap SHIFT over Castle (near center) to Fight.\n\nTap ALT over Chest to Loot\n\nPos: " .. pos[0] .. ", " .. pos[1], nil, 0.7)
  end
end


function fight()
  local fail = nil;
  srClickMouse(pos[0], pos[1]) -- Click on Castle
  sleepWithStatus(500, "Clicking Castle", nil, 0.7)
  srClickMouse(pos[0]+175, pos[1]) -- Click on Challenge
  sleepWithStatus(100, "Clicking Challenge", nil, 0.7)
  if waitForImage("march.png", waitTime, "Waiting for March button") then
    local march = srFindImage("march.png");
    srClickMouse(march[0],march[1]);
    sleepWithStatus(100, "Clicking March", nil, 0.7)
  else
    fail = 1;
  end

  if not fail then 

    if waitForImage("redX_BIG2.png", waitTime, "Waiting for Red X button") then
      srKeyDown(VK_ESCAPE);
      lsSleep(100);
      srKeyUp(VK_ESCAPE);
      lsSleep(100);
    else
      sleepWithStatus(500, "Could not find Red X button, giving up", nil, 0.7)
    end

    if waitForImage("beigeX_BIG2.png", waitTime, "Waiting for Beige X button") then
      srKeyDown(VK_ESCAPE);
      lsSleep(100);
      srKeyUp(VK_ESCAPE);
      lsSleep(100);
    else
      sleepWithStatus(500, "Could not find Beige X button, giving up", nil, 0.7)
    end

  else -- if not fail

    while 1 do
      if lsShiftHeld() then
        while lsShiftHeld() do
          sleepWithStatus(100, "Release Shift Key", nil, 0.7)
        end
        break;
      else -- if lsShiftHeld()
        sleepWithStatus(100, "Could not find March button, giving up\n\nBe sure you are clicking near the center of castle; otherwise the click offset might miss the Challenge button!\n\nTap Shift to exit this message.", nil, 0.7)
      end -- if lsShiftHeld()

    end -- while

  end -- if not fail

  srSetMousePos(lastPos[0], lastPos[1])
end


function loot()
  srClickMouse(pos[0], pos[1]) -- Click on Chest
  sleepWithStatus(150, "Clicked Chest", nil, 0.7)

  if waitForImage("collect.png", waitTime, "Waiting for Collect button") then
    local collect = srFindImage("collect.png");
    srClickMouse(collect[0],collect[1]);
    sleepWithStatus(150, "Clicked Collect Button", nil, 0.7)
  else
    sleepWithStatus(500, "Could not find Collect button, giving up", nil, 0.7)
  end

  srSetMousePos(lastPos[0], lastPos[1])
end

function checkWindowSize()
  while 1 do
    srReadScreen();
    local windowSize = srGetWindowSize();
    if windowSize[0] == 1751 and windowSize[1] == 985 then
      break;
    end
    statusScreen("Current Window Size: " .. windowSize[0] .. "x" .. windowSize[1] .. "\n\nTarget Window Size: 1751x985\n\nStart resizing Blue Stacks window (from a corner) until target size matches!", nil, nil, 0.7);
  end
end
