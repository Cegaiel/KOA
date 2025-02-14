dofile("common.inc");
dofile("constants.inc");


Tolerance = 5000;


function doit()

	askForWindow("Click Distribute button (in Alliance chat window).\n\nMacro will attempt to distribute the goody bags.");  

  checkWindowSize();



  while 1 do
    close()
    sleepWithStatus(150, "Looking for Goody Bag Open button")
  end
end


function close()
  srReadScreen();
  local closeBtn = srFindImage("distribute.png", Tolerance);
  local closeWindow = srFindImage("window_close2.png", Tolerance);

  if closeBtn then
--    curLoc = getMousePos();
    srClickMouse(closeBtn[0],closeBtn[1]);
    sleepWithStatus(1000, "Clicking Open Button...")
--    srSetMousePos(curLoc[0], curLoc[1]);
  end

  if closeWindow then
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
