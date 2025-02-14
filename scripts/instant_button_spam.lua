dofile("common.inc");
dofile("constants.inc");

Tolerance = 5000;
postDelay = 850;
preDelay =150;


function doit()

	askForWindow("Idea for training Dragon Roost or Elemental Mastery research.\n\nSimply clicks the Instant button repeatedly when it's found");  

  checkWindowSize();



  while 1 do
    instant()
    sleepWithStatus(100, "Searching for Instant button ...")
  end
end


function instant()
  srReadScreen();
  local instantBtn = srFindImage("instant.png", Tolerance);
  local closeWindow = srFindImage("window_close.png", Tolerance);

  if instantBtn then
    curLoc = getMousePos();
    lsSleep(preDelay);
    srClickMouse(instantBtn[0],instantBtn[1]);
    sleepWithStatus(postDelay, "Clicking Instant Button!")
    srSetMousePos(curLoc[0], curLoc[1]);


  elseif closeWindow then
      --Hit Esc key
      srKeyDown(VK_ESCAPE);
      lsSleep(100);
      srKeyUp(VK_ESCAPE);
      sleepWithStatus(500, "Closing Window.");
  end

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
