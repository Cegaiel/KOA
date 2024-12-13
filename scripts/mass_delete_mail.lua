dofile("common.inc");

waitTime = 2000; -- How many ms (1000 = 1 second) to wait for an image to appear before giving up
remaining = 5; -- How many more times to delete after the 99+ mail indicator is no longer found
--ignore99 = 1;

function doit()

	askForWindow("Mass Mail Delete. This is idea when you have received many trades and have 99+ emails.\n\nThis will delete the mail - NOT MARK AS READ so that you don't clutter things up.\n\nOpen up your Mail and click the category to start deleting. It will look for the 'Manage' button.\n\nMouse over Blue Stacks window and press Shift key to continue.");  
	
  checkWindowSize();


  if ignore99 == 1 then
    sleepWithStatus(1500, "Ignore99 is true, continuing without 99+ icon verification", nil, 0.7)
    can_continue = 1;
  elseif waitForImage("mail_99_plus.png", waitTime, "Verifying you have 99+ mails indicator") then
    sleepWithStatus(1500, "FOUND 99+ mail indicator, continuing...", nil, 0.7)
    can_continue = 1;
  else
    sleepWithStatus(2000, "99+ indicator not found, Shutting down!", nil, 0.7)

  end



  while can_continue do


  if remaining == 0 then
    sleepWithStatus(1500, "Shutting down!", nil, 0.7)
    break;
  end

  if ignore99 == 1 then
  -- Do Nothing
  elseif not waitForImage("mail_99_plus.png", 1000, "Verifying 99+ mail indicator") then
    sleepWithStatus(1000, "Less than 99 mails remaining - Will Shut Down after " .. remaining .. " more deletes!", nil, 0.7)
    remaining = remaining - 1;
  end

  if waitForImage("mail_manage.png", waitTime, "Waiting for Manage button") then
    local manage = srFindImage("mail_manage.png");
    srClickMouse(manage[0],manage[1]);
    sleepWithStatus(100, "Clicking Manage button", nil, 0.7)
  else
    sleepWithStatus(500, "Could not find Manage button, giving up", nil, 0.7)
    break;
  end

  if waitForImage("mail_all.png", waitTime, "Waiting for ALL checkbox") then
    local all = srFindImage("mail_all.png");
    srClickMouse(all[0]-95,all[1]+7);
    sleepWithStatus(500, "Clicking ALL checkbox", nil, 0.7)
  else
    sleepWithStatus(500, "Could not find ALL checkbox, giving up", nil, 0.7)
    break;
  end

  if waitForImage("mail_delete.png", waitTime, "Waiting for Delete button") then
    local delete = srFindImage("mail_delete.png");
    srClickMouse(delete[0],delete[1]);
    sleepWithStatus(500, "Clicking Delete button", nil, 0.7)
  else
    sleepWithStatus(500, "Could not find Delete button, giving up", nil, 0.7)
    break;
  end

  if waitForImage("confirm_yes.png", waitTime, "Waiting for Confirm Yes button") then
    local yes = srFindImage("confirm_yes.png");
    srClickMouse(yes[0],yes[1]);
    sleepWithStatus(500, "Clicking YES button", nil, 0.7)
  else
    sleepWithStatus(500, "Could not find Confirm Yes button, giving up", nil, 0.7)
    break;
  end


  waitForNoImage("confirm_yes.png", waitTime, "Waiting for NO Confirm Yes button")

  end -- while

end

function checkWindowSize()
  while 1 do
    srReadScreen();
    local windowSize = srGetWindowSize();
    if windowSize[0] == 1751 and windowSize[1] == 985 then
      break;
    end
    statusScreen("Current Window Size: " .. windowSize[0] .. "x" .. windowSize[1] .. "\n\nTarget Window Size: 1751x985\n\nStart resizing Blue Stacks window (from a corner) until target size matches!", nil, nil, 0.7);
  end
end
