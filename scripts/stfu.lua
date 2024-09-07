dofile("common.inc");


stfuImageTolerance = 5000;


function doit()

	askForWindow("STFU out of Shout Boxes.\n\nLooks for Kingdom Shout messages and closes the X button when found");  


  while 1 do
    stfu()
    sleepWithStatus(2000, "Looking to STFU on someone ...\n\nC'mon Yahtzee!")
  end
end


function stfu()
  srReadScreen();
  local shout = srFindImage("stfu.png", stfuImageTolerance);
  if shout then
    curLoc = getMousePos();
    srClickMouse(shout[0],shout[1]);
    lsSleep(100);
    srSetMousePos(curLoc[0], curLoc[1]);
    lsPlaySound("successful.wav");
  end
end