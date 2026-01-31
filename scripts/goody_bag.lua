dofile("common.inc");
dofile("constants.inc");


Tolerance = 5000;


function doit()

	askForWindow("Click Claim link (in Alliance Chat) and it will click the Open button. Tip: Go to Kingdom Chat and click the x Good Bags left to claim window. This method you won't have to find Claim Links!\n\nOr Click the bag icon (in Alliance Chat) then click the bag actual bag to distribute. This will click Distribute button\n\nEither option will close the window when done.\n\nClaim/Open does NOT offer any Thanks.");  

  checkWindowSize();



  while 1 do
    look()
    sleepWithStatus(150, "Looking for Goody Bag Distribute, Claim or Open buttons")
  end
end


function look()
  srReadScreen();
  local btnDistribute = srFindImage("distribute.png", Tolerance);
  local btnOpen = srFindImage("goody_bag_open.png", Tolerance);
  local curLoc = getMousePos();
  local closeWindow = srFindImage("window_close2.png", Tolerance);
  local claim = srFindImage("goody_bag_claim.png", Tolerance);


  if btnDistribute then
    srClickMouse(btnDistribute[0],btnDistribute[1]);
    sleepWithStatus(500, "Clicked Distribute Button...");
    srReadScreen();
    local btnBag = srFindImage("goody_bag_icon.png", Tolerance);
    if btnBag then
      srClickMouse(btnBag[0],btnBag[1]);
      lsSleep(100);
      srSetMousePos(curLoc[0], curLoc[1]);
    end

  elseif btnOpen then
    srClickMouse(btnOpen[0],btnOpen[1]);
    sleepWithStatus(500, "Clicked Open Button...")
    srSetMousePos(curLoc[0], curLoc[1]);

  elseif claim then
    srClickMouse(claim[0],claim[1]);
    sleepWithStatus(500, "Clicked Claim Button...")
    srSetMousePos(curLoc[0], curLoc[1]);

  elseif closeWindow then
      --Hit Esc key
      srKeyDown(VK_ESCAPE);
      lsSleep(100);
      srKeyUp(VK_ESCAPE);
      lsSleep(100);
  end

end
