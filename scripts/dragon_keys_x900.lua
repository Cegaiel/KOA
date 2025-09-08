dofile("common.inc");
waitTime = 2000; -- How many ms (1000 = 1 second) to wait for an image to appear before giving up


function doit()

	askForWindow("Clicks the Spin button on Dragon Chest event when you have lots of keys.\n\nFirst: Click 'Draws x900' button AND also check the Skip box until you see the next GREEN Spin 900 times button.\n\nOnce you see the GREEN BUTTON THEN you can start this script.\n\nMouse over Blue Stacks window and press Shift key to continue.");  
	
  checkWindowSize();


  if waitForImage("dragon_keys_900.png", waitTime, "Verifying you have GREEN Spin button") then
    sleepWithStatus(1500, "FOUND Green Spin button, continuing...", nil, 0.7)
    can_continue = 1;
  else
    sleepWithStatus(2000, "GREEN spin button NOT found, Shutting down!", nil, 0.7)
  end


  while can_continue do

    if waitForImage("dragon_keys_900.png", waitTime, "Waiting for Green Spin button") then
      local key = srFindImage("dragon_keys_900.png");
      srClickMouse(key[0],key[1]);
      sleepWithStatus(100, "Clicking Green Spin button", nil, 0.8)
    else
      sleepWithStatus(500, "Could not find Green Spin button, giving up", nil, 0.8)
      break;
    end
  end

end
