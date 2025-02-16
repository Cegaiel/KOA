dofile("common.inc");
dofile("constants.inc");


Tolerance = 5000;


function doit()

	askForWindow("Click Claim link on Goody Bags.\n\nMacro will click Open button and then Close window.\n\nIt does not offer Thanks!");  

  checkWindowSize();



  while 1 do
    close()
    sleepWithStatus(150, "Looking for Goody Bag Open button")
  end
end


function close()
  srReadScreen();
  local closeBtn = srFindImage("goody_bag_open.png", Tolerance);
  local closeWindow = srFindImage("window_close2.png", Tolerance);

  if closeBtn then
    curLoc = getMousePos();
    srClickMouse(closeBtn[0],closeBtn[1]);
    sleepWithStatus(1000, "Clicking Open Button...")
    srSetMousePos(curLoc[0], curLoc[1]);
  end

  if closeWindow then
      --Hit Esc key
      srKeyDown(VK_ESCAPE);
      lsSleep(100);
      srKeyUp(VK_ESCAPE);
      sleepWithStatus(500, "Closing Window.");
  end

end
