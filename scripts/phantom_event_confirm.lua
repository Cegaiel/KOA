dofile("common.inc");
waitTime = 2000; -- How many ms (1000 = 1 second) to wait for an image to appear before giving up

function doit()

	askForWindow("Clicks Confirm button when encountered.\n\nMouse over Blue Stacks window and press Shift key to continue.");  
	
  checkWindowSize();


  while 1 do

    while lsMouseIsDown() do
      sleepWithStatus(16, "Release Mouse !", nil, 0.7, "Pausing while Mouse is down");
    end

    srReadScreen();
    local smallConfirm = srFindImage("phantom_small_confirm.png");
    local largeConfirm = srFindImage("phantom_large_confirm.png"); -- This is the Confirm button after clicking a March button
    local match = srFindImage("phantom_match.png");
    local curLoc = getMousePos();

    if match then
      srClickMouse(match[0],match[1]);
  	sleepWithStatus(2500, "Clicked Match button; Joining Match!")

    elseif largeConfirm then
      srClickMouse(largeConfirm[0],largeConfirm[1]);
  	sleepWithStatus(2500, "Clicked Ready button; I'm Ready!")

    elseif smallConfirm then
      while lsMouseIsDown() do
        sleepWithStatus(16, "Release Mouse !", nil, 0.7, "Pausing while Mouse is down");
      end
      srClickMouse(smallConfirm[0],smallConfirm[1]+85);
      lsSleep(100);
      srSetMousePos(curLoc[0],curLoc[1]);
    end

  sleepWithStatus(100, "Looking for buttons")

  end

end
