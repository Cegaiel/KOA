dofile("common.inc");


Tolerance = 5000;


function doit()

	askForWindow("Click Big Yellow Open button on Goody Bags.");  


  while 1 do
    close()
    sleepWithStatus(150, "Looking for Goody Bag Open button")
  end
end


function close()
  srReadScreen();
  local closeBtn = srFindImage("goody_bag_open.png", Tolerance);
  if closeBtn then
    curLoc = getMousePos();
    srClickMouse(closeBtn[0],closeBtn[1]);
    sleepWithStatus(1000, "Clicking Open Button...")
    srSetMousePos(curLoc[0], curLoc[1]);
    lsPlaySound("successful.wav");
  end
end