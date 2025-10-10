dofile("common.inc");

Tolerance = 2500;
preDelay = 250;


function doit()

	askForWindow("Idea for Enhancing Weapons.\n\nSimply clicks the 'Enhance' button repeatedly when it's found.");  

  checkWindowSize();



  while 1 do
    enhance()
    sleepWithStatus(preDelay, "Searching for Enhance button ...")
  end
end


function enhance()
  srReadScreen();
  local enhanceBtn = srFindImage("enhance.png", Tolerance);
  if enhanceBtn then
    curLoc = getMousePos();
    srClickMouse(enhanceBtn[0],enhanceBtn[1]);
    lsSleep(preDelay);
    srSetMousePos(curLoc[0], curLoc[1]);
    sleepWithStatus(preDelay, "Clicked Enhance Button!")
  end
end
