dofile("common.inc");
dofile("constants.inc");

waitTime = 200; -- How many ms (1000 = 1 second) to wait for an image to appear before giving up
tolerance = 4500; -- Image tolerance to find it -- Default is 4500 when no tolerance is specified

function doit()
  askForWindow("Troop Training\n\nSelect the troop you are training so that the BLUE TRAIN button is showing BEFORE you begin!\n\nMouse over Blue Stacks window and press Shift key to continue.");  
  checkWindowSize();

  if waitForImage("training/train.png", waitTime, "Verifying Blue Train button is showing") then
    sleepWithStatus(1500, "Green Upgrade button found, continuing...", nil, 0.7)
    can_continue = 1;
  else
    sleepWithStatus(2000, "Blue Train button NOT found, Shutting down!", nil, 0.7)
  end


  while can_continue do
    checkBreak();


    -- Check Slider Bar before clicking Level up
    if waitForImage("training/gold_plus.png", waitTime, "Looking for Slider Bar/Plus button", nil, tolerance) then
      local gold_plus = srFindImage("training/gold_plus.png");
      if gold_plus then
        srClickMouse(gold_plus[0]-71,gold_plus[1]+10);
        lsSleep(100);
        srClickMouse(gold_plus[0]-71,gold_plus[1]+10);
       sleepWithStatus(100, "Clicking Max on Slider Bar", nil, 0.7)
      end
    end

    if waitForImage("training/train.png", waitTime, "Verifying Blue Train button is showing", nil, tolerance) then
      local train = srFindImage("training/train.png");
      srClickMouse(train[0],train[1]);
      sleepWithStatus(100, "Clicking Upgrade button", nil, 0.7)
    end

    if waitForImage("training/level_up.png", waitTime, "Waiting for Level Up button", nil, tolerance) then
      local level_up = srFindImage("training/level_up.png");
      if level_up then
        srClickMouse(level_up[0],level_up[1]);
        sleepWithStatus(100, "Clicking Level-Up button", nil, 0.7)
      end
    end

  --checkGrayButtons()


    -- Check for Blue Use All button. This will appear if we don't have enough resources at hand
    if waitForImage("training/use_all_blue.png", waitTime, "Checking for USE ALL button", nil, tolerance) then
      local blue_use_all = srFindImage("training/use_all_blue.png");
      if blue_use_all then
        srClickMouse(blue_use_all[0],blue_use_all[1]);
        sleepWithStatus(100, "Clicking Blue: Use All button", nil, 0.7)
      end
    end

    -- No Blue Use All button, We've got enough resources - Look for Green Use All button for Speedup
    if waitForImage("training/use_all_green.png", waitTime, "Checking for USE ALL button", nil, tolerance) then
      local green_use_all = srFindImage("training/use_all_green.png");
      if green_use_all then
        srClickMouse(green_use_all[0],green_use_all[1]);
        sleepWithStatus(100, "Clicking Green: Use All button", nil, 0.7)
      end
    end

    checkClaimGreen();

    if waitForImage("training/blue_speedup.png", waitTime, "Checking for Blue Speedup", nil, tolerance) then
      local blue_speed_up = srFindImage("training/blue_speedup.png");
      if blue_speed_up then
        srClickMouse(blue_speed_up[0],blue_speed_up[1]);
        sleepWithStatus(100, "Clicking Blue: Speed Up button", nil, 0.7)
      end
    end

    -- Sometimes a popup "The Time exceeded 00:xx:xx will be wasted after using Auto Speedup. Confirm to use?"
    if waitForImage("training/confirm_yes.png", waitTime, "Checking for Confirm Speedup is Wasted", nil, tolerance) then
      local confirm_yes = srFindImage("training/confirm_yes.png");
      if confirm_yes then
        srClickMouse(confirm_yes[0],confirm_yes[1]);
        sleepWithStatus(100, "Clicking Confirm Yes button", nil, 0.7)
      end
    end
  end -- while
end

function checkClaimGreen()
    if waitForImage("training/claim_green.png", waitTime, "Checking for Green: Claim All button", nil, tolerance) then
      local green_claim = srFindImage("training/claim_green.png");
      if green_claim then
        srClickMouse(green_claim[0],green_claim[1]);
        sleepWithStatus(100, "Clicking Green: Claim All button", nil, 0.7)
      end
    end
end

function checkGrayButtons()
-- A gray Use All (speeds) button MIGHT appear here.
-- Check for Gray Use All button. This will appear when game is being stupid. Just close it out
-- We will check for three possible Gray buttons. I've found that sometimes one button will not be found, when it should.

    if waitForImage("training/use_all_gray.png", waitTime, "Checking for GRAY USE ALL", nil, tolerance) then
      sleepWithStatus(100,"ISSUE: Found Gray Use All Button: Preparing ESC KEY");
      UseAllGrayButton1 = srFindImage("training/use_all_gray.png")
      UseAllGrayButton2 = srFindImage("training/use_all_gray2.png")
      UseAllGrayButton3 = srFindImage("training/use_all_gray3.png")
      --Hit Esc key
      srKeyDown(VK_ESCAPE);
      lsSleep(100);
      srKeyUp(VK_ESCAPE);
      lsSleep(100);
   end

  if not UseAllGrayButton1 and UseAllGrayButton2 then
      if waitForImage("training/use_all_gray2.png", waitTime, "Checking for GRAY USE ALL 2", nil, tolerance) then
        sleepWithStatus(100,"ISSUE: Found Gray Use All Button 2: Preparing ESC KEY");
        --Hit Esc key
        srKeyDown(VK_ESCAPE);
        lsSleep(100);
        srKeyUp(VK_ESCAPE);
        lsSleep(100);
     end
  end

  if not UseAllGrayButton1 and not UseAllGrayButton1 and UseAllGrayButton3 then
      if waitForImage("training/use_all_gray3.png", waitTime, "Checking for GRAY USE ALL 3", nil, tolerance) then
        sleepWithStatus(100,"ISSUE: Found Gray Use All Button 3: Preparing ESC KEY");
        --Hit Esc key
        srKeyDown(VK_ESCAPE);
        lsSleep(100);
        srKeyUp(VK_ESCAPE);
        lsSleep(100);
     end
  end
end
