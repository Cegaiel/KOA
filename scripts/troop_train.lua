dofile("common.inc");
dofile("constants.inc");

waitTime = 200; -- How many ms (1000 = 1 second) to wait for an image to appear before giving up
defaultSleep = 1250; -- How many ms for most sleep
tolerance = 6000; -- Image tolerance to find it -- Default is 4500 when no tolerance is specified
checkedGray = 0;
abort = 0;
skipSliderBar = 0;

function doit()
  num_train = promptNumber("Num times (loops) to Train?", 1);
  if promptOkay("Are you using One Time Recruitment (5000, 20000, 100000, 1000000) scrolls?\n\nYes: Don't click slider bars since scrolls force the max troops already; saves time!\n\nNo: Will click the right side of the slider bar, each loop, to set Max troops.", nil, 0.7, true) then
    skipSliderBar = 1;
  end
  askForWindow("Troop Training\n\nSelect the troops types you are training.\nBe sure the BLUE TRAIN button is showing BEFORE you begin!\n\nMouse over Blue Stacks window and press Shift key to continue.");  
  checkWindowSize();

  if waitForImage("training/train.png", waitTime, "Verifying Blue Train button is showing") then
    sleepWithStatus(1500, "Blue Train button found, continuing...", nil, 0.7)
    can_continue = 1;
  else
    sleepWithStatus(2000, "Blue Train button NOT found, Shutting down!", nil, 0.7)
  end


  while can_continue and abort == 0 do
    checkBreak();

    -- Check Slider Bar before clicking Level up
    if waitForImage("training/gold_plus.png", waitTime, "Looking for Slider Bar/Plus button", nil, tolerance) then
      local gold_plus = srFindImage("training/gold_plus.png");
      if gold_plus and skipSliderBar == 0 then
        srClickMouse(gold_plus[0]-71,gold_plus[1]+10);
        lsSleep(100);
        srClickMouse(gold_plus[0]-71,gold_plus[1]+10);
	    sleepWithStatus(defaultSleep, "Clicking Max on Slider Bar", nil, 0.7, "Loops remaining: " .. num_train);
      end
    end

    if waitForImage("training/train.png", waitTime, "Verifying Blue Train button is showing", nil, tolerance) then
      local train = srFindImage("training/train.png");
      srClickMouse(train[0],train[1]);
      sleepWithStatus(defaultSleep, "Clicking Train button", nil, 0.7, "Loops remaining: " .. num_train)
    end

    -- Check for Blue Use All button. This will appear if we don't have enough resources at hand
    if waitForImage("training/use_all_blue.png", waitTime, "Checking for USE ALL button", nil, tolerance) then
      local blue_use_all = srFindImage("training/use_all_blue.png");
      if blue_use_all then
        srClickMouse(blue_use_all[0],blue_use_all[1]);
        sleepWithStatus(defaultSleep, "Clicking Blue: Use All button", nil, 0.7, "Loops remaining: " .. num_train)
      end
    end

    -- No Blue Use All button, We've got enough resources - Look for Green Use All button for Speedup
    if waitForImage("training/use_all_green.png", waitTime, "Checking for USE ALL button", nil, tolerance) then
      local green_use_all = srFindImage("training/use_all_green.png");
      if green_use_all then
        srClickMouse(green_use_all[0],green_use_all[1]);
        sleepWithStatus(defaultSleep, "Clicking Green: Use All button", nil, 0.7, "Loops remaining: " .. num_train)
      end
    end

    checkClaimGreen();

    if waitForImage("training/blue_speedup.png", waitTime, "Checking for Blue Speedup", nil, tolerance) then
      local blue_speed_up = srFindImage("training/blue_speedup.png");
      if blue_speed_up then
        srClickMouse(blue_speed_up[0],blue_speed_up[1]);
        sleepWithStatus(defaultSleep, "Clicking Blue: Speed Up button", nil, 0.7, "Loops remaining: " .. num_train)
      end
    end

    -- Sometimes a popup "The Time exceeded 00:xx:xx will be wasted after using Auto Speedup. Confirm to use?"
    if waitForImage("training/confirm_yes.png", waitTime, "Checking for Confirm Speedup is Wasted", nil, tolerance) then
      local confirm_yes = srFindImage("training/confirm_yes.png");
      if confirm_yes then
        srClickMouse(confirm_yes[0],confirm_yes[1]);
        sleepWithStatus(defaultSleep, "Clicking Confirm Yes button", nil, 0.7, "Loops remaining: " .. num_train)
      end
    end
  end -- while
end

function checkClaimGreen()
    if waitForImage("training/claim_green.png", waitTime, "Checking for Green: Claim All button", nil, tolerance) then
      local green_claim = srFindImage("training/claim_green.png");
      if green_claim then
        srClickMouse(green_claim[0],green_claim[1]);
        sleepWithStatus(defaultSleep, "Clicking Green: Claim All button", nil, 0.7, "Loops remaining: " .. num_train)

		num_train = num_train - 1;
		if num_train <= 0 then
		  lsPlaySound("complete.wav");
		  sleepWithStatus(10000,"num Times to Upgrade has been met, aborting!");
          error("num Times to Train has been met, aborting!");
		end
      end
    end

	if abort == 0 and not green_claim then
   	  checkGrayButtons();
	end
end

function checkGrayButtons()
-- NOTE THIS FUNCTION IS COPY/PASTE FROM TROOP_UPGRADE.LUA - I AM NOT 100% SURE IF THIS CASE IS VALID OR NOT.
-- FOR NOW, EVEN IF THERE ARE NO GRAY BUTTONS IT WILL STILL SERVE A PURPOSE BY ABORTING MACRO IF IT CAN'T FIND ANYTHING TO CLICK, FOR TOO LONG.
-- IF checkedGray >= 4 (this function called to many times in a row) then it means we can't find anything else to click. Hence we are stuck; abort!

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
