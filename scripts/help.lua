dofile("common.inc");

Tolerance = 5000;


function doit()

	askForWindow("Click the Help button anytime it appears. Ideal if you see someone upgrading like crazy!");  

  checkWindowSize();



  while 1 do
    findHelpButton()
    sleepWithStatus(150, "Looking for Help button")
  end
end


function findHelpButton()
  srReadScreen();
  btnHelp = srFindImage("help.png", Tolerance);
  if btnHelp then
    curLoc = getMousePos();
    srClickMouse(btnHelp[0],btnHelp[1]);
    sleepWithStatus(1000, "Clicking Help Button...")
    srSetMousePos(curLoc[0], curLoc[1]);
  end

end
