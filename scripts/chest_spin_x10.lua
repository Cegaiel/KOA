dofile("common.inc");
waitTime = 1500; -- wait time for things that do not have a SKIP checkbox


function doit()

	askForWindow("Spam click the Draws x10 button on Dragon and Frozen Chests event when you have lots of keys.\n\nDragon Chest Event: Check the 'Skip' checkbox to go faster!\n\nMouse over Blue Stacks window and press Shift key to continue.");  
	
  checkWindowSize();

  while 1 do

      local key = srFindImage("dragon_keys_small.png");
      local frozen = srFindImage("frozen_crystals.png");

	if key then
          srClickMouse(key[0],key[1]);
          sleepWithStatus(250, "Clicking Draws x1 button", nil, 0.7)
          sleepWithStatus(250, "CLICKED Draws x1 button", nil, 0.7)
	elseif frozen then
          srClickMouse(frozen[0],frozen[1]);
          sleepWithStatus(750, "Clicking Spin x1 button", nil, 0.7)
          sleepWithStatus(750, "CLICKED Spin x1 button", nil, 0.7)
	end

	if not key and not frozen then
          sleepWithStatus(2000, "Could not anything to click, giving up", nil, 0.7)
          break;
        end
  end
end
