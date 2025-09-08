dofile("common.inc");
waitTime = 1500; -- wait time for things that do not have a SKIP checkbox
waitTerminate = 0;
waitTerminateMax = 3;

function doit()

	askForWindow("Spam click the Draws x1 or x10 button Frozen Chests or Collectors Chest (plane keys) or 20 for Dragon Chest event when you have lots of keys.\n\nDragon Chest Event: Check the 'Skip' checkbox to go faster!\n\nMouse over Blue Stacks window and press Shift key to continue.");  
	
  checkWindowSize();

  while 1 do
      srReadScreen();
      local key = srFindImage("dragon_keys_small.png");
      local frozen = srFindImage("frozen_crystals.png");
      local planes = srFindImage("planes_key_10.png");

	if key then
          srClickMouse(key[0],key[1]);
          sleepWithStatus(250, "Clicking Draws x1 button", nil, 0.7)
          sleepWithStatus(250, "CLICKED Draws x1 button", nil, 0.7)
	elseif frozen then
          srClickMouse(frozen[0],frozen[1]);
          sleepWithStatus(750, "Clicking Spin x1 button", nil, 0.7)
          sleepWithStatus(750, "CLICKED Spin x1 button", nil, 0.7)
	elseif planes then
          srClickMouse(planes[0],planes[1]);
          sleepWithStatus(250, "Clicking Spin x1 button", nil, 0.7)
          sleepWithStatus(250, "CLICKED Spin x1 button", nil, 0.7)
	end

	if not key and not frozen and not planes then
	  waitTerminate = waitTerminate + 1;
          sleepWithStatus(2000, "Could not anything to click, rechecking " .. waitTerminate .. "/" .. waitTerminateMax .. " times", nil, 0.7)

          if waitTerminate == 5 then
            sleepWithStatus(2000, "Giving Up, Bye!", nil, 0.7)
            break;
          end

	else
	  waitTerminate = 0;
        end
  end
end
