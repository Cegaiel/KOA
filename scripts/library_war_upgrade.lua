dofile("common.inc");

Tolerance = 2500;


function doit()

	askForWindow("Used for clicking the Green Activate or Green Upgrade button in Library of War.\n\nEach click the button dims out and prevents you from clicking it for about 2 seconds. This will click it every possible moment it can (not dim)\n\nMacro will ask how many clicks you want before it starts.");  

  checkWindowSize();


  num_clicks = promptNumber("How many times to click the button?", 1);
  max_clicks = num_clicks;
  cur_clicks = 0;
  sleepWithStatus(2000, "Ready to start; Hands off the mouse!");


  while 1 do
  if cur_clicks >= max_clicks then
    sleepWithStatus(3000, "All done, quitting!\n\nTotal Clicks: " .. cur_clicks .. "/" .. max_clicks);
    break;
  end

    findButton()
    sleepWithStatus(150, "Looking for Activate/Upgrade buttons\n\nTotal Clicks: " .. cur_clicks .. "/" .. max_clicks);
  end
end


function findButton()
  srReadScreen();
  btnActivate = srFindImage("library_war_activate.png", Tolerance);
  btnUpgrade = srFindImage("library_war_upgrade.png", Tolerance);

  if btnActivate then
    curLoc = getMousePos();
    srClickMouse(btnActivate[0],btnActivate[1]);
    sleepWithStatus(1000, "Clicking Activate Button...")
    srSetMousePos(curLoc[0], curLoc[1]);
    cur_clicks = cur_clicks + 1;
  elseif btnUpgrade then
    curLoc = getMousePos();
    srClickMouse(btnUpgrade[0],btnUpgrade[1]);
    sleepWithStatus(1000, "Clicking Upgrade Button...")
    srSetMousePos(curLoc[0], curLoc[1]);
    cur_clicks = cur_clicks + 1;
  end
end
