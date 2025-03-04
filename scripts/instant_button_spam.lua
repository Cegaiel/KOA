dofile("common.inc");
dofile("constants.inc");

Tolerance = 5000;
postDelay = 750;
preDelay = 150;


function doit()

	askForWindow("Idea for training Dragon Roost or Elemental Mastery research.\n\nSimply clicks the Instant button repeatedly when it's found.\n\nMake sure you checkbox 'Don't ask anymore today', first.");  

  checkWindowSize();



  while 1 do
    instant()
    sleepWithStatus(preDelay, "Searching for Instant button ...")
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
    lsSleep(preDelay);
    srSetMousePos(curLoc[0], curLoc[1]);
    sleepWithStatus(postDelay, "Clicked Instant Button!")


  elseif closeWindow then
      --Hit Esc key
      srKeyDown(VK_ESCAPE);
      lsSleep(100);
      srKeyUp(VK_ESCAPE);
      sleepWithStatus(preDelay, "Closing Window.");
  end

end
