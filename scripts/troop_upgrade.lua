dofile("common.inc");
dofile("constants.inc");

waitTime = 200; -- How many ms (1000 = 1 second) to wait for an image to appear before giving up
defaultSleep = 200; -- How many ms for most sleep
tolerance = 6000; -- Image tolerance to find it -- Default is 4500 when no tolerance is specified
checkedGray = 0;
abort = 0;
num_loops = 0;

function doit()
  num_upgrades = promptNumber("Num times to Train/Upgrade Troops?", 1);
  askForWindow("Troop Upgrade\n\nSelect the troop you are upgrading so that the GREEN Upgrade button is showing BEFORE you begin!\n\nMouse over Blue Stacks window and press Shift key to continue.");  
  checkWindowSize();

  if waitForImage("training/upgrade_button.png", waitTime, "Verifying Green Upgrade button showing") then
    sleepWithStatus(1500, "Green Upgrade button FOUND, continuing...", nil, 0.7);
    can_continue = 1;
  else
    sleepWithStatus(2000, "Green Upgrade button NOT found, Shutting down!", nil, 0.7);
  end

  while can_continue and abort == 0 do
    checkBreak();
    if waitForImage("training/upgrade_button.png", waitTime, "Verifying Green Upgrade button showing", nil, tolerance) then
      local upgrade = srFindImage("training/upgrade_button.png");
      srClickMouse(upgrade[0],upgrade[1]);
      sleepWithStatus(defaultSleep, "Clicking Upgrade button", nil, 0.7, "Loops remaining: " .. num_upgrades)
    end

    -- Check Slider Bar before clicking Level up
    if waitForImage("training/gold_plus.png", waitTime, "Looking for Slider Bar/Plus button", nil, tolerance) then
      local gold_plus = srFindImage("training/gold_plus.png");
      if gold_plus then
        srClickMouse(gold_plus[0]-52,gold_plus[1]+10);
        sleepWithStatus(defaultSleep, "Clicking Max on Slider Bar", nil, 0.7, "Loops remaining: " .. num_upgrades)
      end
    end


    if waitForImage("training/level_up.png", waitTime, "Waiting for Level Up button", nil, tolerance) then
      local level_up = srFindImage("training/level_up.png");
      if level_up then
        srClickMouse(level_up[0],level_up[1]);
        sleepWithStatus(defaultSleep, "Clicking Level-Up button", nil, 0.7, "Loops remaining: " .. num_upgrades)
      end
    end

    checkGrayButtons();

    -- Check for Blue Use All button. This will appear if we don't have enough resources at hand
    if waitForImage("training/use_all_blue.png", waitTime, "Checking for USE ALL button", nil, tolerance) then
      local blue_use_all = srFindImage("training/use_all_blue.png");
      if blue_use_all then
        srClickMouse(blue_use_all[0],blue_use_all[1]);
        sleepWithStatus(defaultSleep, "Clicking Blue: Use All button", nil, 0.7, "Loops remaining: " .. num_upgrades)
        checkedGray = 0;
      end
    end


    -- No Blue Use All button, We've got enough resources - Look for Green Use All button for Speedup
    if waitForImage("training/use_all_green.png", waitTime, "Checking for USE ALL button", nil, tolerance) then
      local green_use_all = srFindImage("training/use_all_green.png");
      if green_use_all then
        srClickMouse(green_use_all[0],green_use_all[1]);
        sleepWithStatus(defaultSleep, "Clicking Green: Use All button", nil, 0.7, "Loops remaining: " .. num_upgrades)
        checkedGray = 0;
      end
    end

    if waitForImage("training/claim_blue.png", waitTime, "Checking for Blue: Claim All button", nil, tolerance) then
      local blue_claim = srFindImage("training/claim_blue.png");
      if blue_claim then
        srClickMouse(blue_claim[0],blue_claim[1]);
        sleepWithStatus(defaultSleep, "Clicking Blue: Claim All button", nil, 0.7, "Loops remaining: " .. num_upgrades)
        checkedGray = 0;
        num_upgrades = num_upgrades - 1;
		if num_upgrades <= 0 then
  		  lsPlaySound("complete.wav");
          sleepWithStatus(10000,"num Times to Train has been met, aborting!");
          error("num Times to Train has been met, aborting!");
        end
      end
    end


    -- checkClaimGreen();

    if waitForImage("training/blue_speedup.png", waitTime, "Checking for Blue Speedup", nil, tolerance) then
      local blue_speed_up = srFindImage("training/blue_speedup.png");
      if blue_speed_up then
        srClickMouse(blue_speed_up[0],blue_speed_up[1]);
        sleepWithStatus(defaultSleep, "Clicking Blue: Speed Up button", nil, 0.7, "Loops remaining: " .. num_upgrades)
        checkedGray = 0;
      end
    end

    -- Sometimes a popup "The Time exceeded 00:xx:xx will be wasted after using Auto Speedup. Confirm to use?"
    if waitForImage("training/confirm_yes.png", waitTime, "Checking Confirm Speedup is Wasted", nil, tolerance) then
      local confirm_yes = srFindImage("training/confirm_yes.png");
      if confirm_yes then
        srClickMouse(confirm_yes[0],confirm_yes[1]);
        sleepWithStatus(defaultSleep, "Clicking Confirm Yes button", nil, 0.7, "Loops remaining: " .. num_upgrades)
      end
    end
  end -- while
end

function checkClaimGreen()
-- This might mean we've already upgraded all the troops.
    if waitForImage("training/claim_green.png", waitTime, "Checking for Green: Claim All button", nil, tolerance) then
      local green_claim = srFindImage("training/claim_green.png");
      if green_claim then
        srClickMouse(green_claim[0],green_claim[1]);
        sleepWithStatus(defaultSleep, "Clicking Green: Claim All button", nil, 0.7, "Loops remaining: " .. num_upgrades)
        num_upgrades = num_upgrades - 1;
		if num_upgrades <= 0 then
          sleepWithStatus(2500,"num Times to Upgrade has been met, aborting!");
          abort = 1;
        end
      end

	  EscapeKey(); -- Hit Esc Key
      lsSleep(defaultSleep);
	  EscapeKey(); -- Hit Esc Key
      error("Quitting; ALL TROOPS UPGRADED!?");
    end
end

function checkGrayButtons()
-- A gray Use All (speeds) button MIGHT appear here.
-- Check for Gray Use All button. This will appear when game is being stupid. Just close it out
-- We will check for three possible Gray buttons. I've found that sometimes one button will not be found, when it should.
  local foundGray = nil;
  checkedGray = checkedGray +1;

      UseAllGrayButton1 = srFindImage("training/use_all_gray.png")
      UseAllGrayButton2 = srFindImage("training/use_all_gray2.png")
      --UseAllGrayButton3 = srFindImage("training/use_all_gray3.png")

      if UseAllGrayButton1 or UseAllGrayButton2 or UseAllGrayButton3 then
        foundGray = 1;
      end

      if foundGray or checkedGray >= 4 then
         sleepWithStatus(1000,"ISSUE: Found Gray Use All Button or we are stuck: Using ESC KEY\n\nCheckedGray Counter: " .. checkedGray);
	  EscapeKey(); -- Hit Esc Key
      end

      if checkedGray >= 10 then
  		 lsPlaySound("fail.wav");
         error("Abort: Looped too many times without finding anything to click. Macro seems stuck on unexpected window");
      end

end

function EscapeKey()
      --Same as pressing Esc Key on keyboard
      srKeyDown(VK_ESCAPE);
      lsSleep(100);
      srKeyUp(VK_ESCAPE);
      lsSleep(100);
end
