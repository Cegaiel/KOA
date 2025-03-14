-- common_window.inc
--
-- Common functions for handling windows: opening, arranging, unpinning
--
-- DO NOT INCLUDE THIS FILE! Include common.inc instead
--

TOP_LEFT = 0;
TOP_RIGHT = 1;
BOTTOM_LEFT = 2;
BOTTOM_RIGHT = 3;

-------------------------------------------------------------------------------
-- stashWindow(sourceX, sourceY, corner, bounds)
--
-- Drags a window from a given location to a corner of the screen.
--
-- sourceX, sourceY -- location of anchor point to drag window
-- corner -- destination corner (TOP_LEFT, TOP_RIGHT, BOTTOM_LEFT,
--           or BOTTOM_RIGHT)
-- bounds (optional) -- bounds of window
-------------------------------------------------------------------------------

local stashBit = 0;

function stashWindow(sourceX, sourceY, corner, bounds)
  if not sourceX or not sourceY or not corner then
    error("Incorrect number of arguments for stashWindow()");
  end
  stashBit = (stashBit + 2) % 4;
  if not bounds then
    srReadScreen();
    bounds = srGetWindowBorders(sourceX, sourceY);
  end
  local size = {};
  size[0] = bounds[2] - bounds[0];
  size[1] = bounds[3] - bounds[1];
  local screen = srGetWindowSize();
  local dest = {};
  dest[0] = screen[0] - size[0] + (sourceX - bounds[0]) - 5;
  if corner == TOP_LEFT or corner == BOTTOM_LEFT then
    dest[0] = sourceX - bounds[0] + 5;
  end
  dest[1] = screen[1] - size[1] + (sourceY - bounds[1]) - stashBit - 5;
  if corner == TOP_LEFT or corner == TOP_RIGHT then
    dest[1] = sourceY - bounds[1] + stashBit + 5;
  end
  safeDrag(sourceX, sourceY, dest[0], dest[1]);
  srSetMousePos(sourceX, sourceY);
  lsSleep(click_delay);
  return dest;
end

-------------------------------------------------------------------------------
-- stashAllWindows(corner)
--
-- Move all windows not in the same quadrant as corner into the given
-- corner.  Use this twice on different corners to make sure that you
-- grab all windows.
--
-- corner -- Destination corner
-------------------------------------------------------------------------------

function stashAllWindows(corner)
  if not corner then
    error("Incorrect number of arguments for stashAllWindows()");
  end
  local top = (corner == TOP_LEFT or corner == TOP_RIGHT);
  local left = (corner == TOP_LEFT or corner == BOTTOM_LEFT);
  local screen = srGetWindowSize();
  local done = false;
  local stashes = {};
  srReadScreen();
  local anchors = findAllImages("ThisIs.png");
  while not done do
    done = true;
    for i=1,#anchors do
      if not wasStashed(anchors[i], stashes) then
	safeClick(anchors[i][0], anchors[i][1]);
	lsSleep(click_delay);
	local lastPos = stashWindow(anchors[i][0], anchors[i][1], corner);
	stashes[#stashes + 1] = lastPos;
	done = false;
      end
    end
    lsSleep(tick_delay);
    srReadScreen();
    anchors = findAllImages("ThisIs.png");
    statusScreen("Stashing Windows");
  end
end

function wasStashed(pos, stashes)
  local result = false;
  for i=1,#stashes do
    local diffX = math.abs(stashes[i][0] - pos[0]);
    local diffY = math.abs(stashes[i][1] - pos[1]);
    if diffX < 20 and diffY < 20 then
      result = true;
      break;
    end
  end
  return result;
end

-------------------------------------------------------------------------------
-- openAndPin(x, y, timeout)
--
-- Click at the given position to open a window, then pin that window.
--
-- x, y -- position to click
-- timeout -- time to wait before giving up
--
-- Returns true on success.
-------------------------------------------------------------------------------

function openAndPin(x, y, timeout)
  if not x or not y or not timeout then
    error("Incorrect number of arguments for openAndPin()");
  end
  local success = false;
  srReadScreen();
  local anchors = findAllImages("ThisIs.png");
  local startTime = lsGetTimer();
  safeBegin();
  srSetMousePos(x, y);
  lsSleep(50);
  srClickMouse(x, y, 1);
  lsDoFrame();
  statusScreen("Clicking to open window");
  local done = false;
  local anchor = nil;
  while not done do
    srReadScreen();
    local newAnchors = findAllImages("ThisIs.png");
    done = false;
    local limit = math.min(#anchors, #newAnchors);
    for i=1,limit do
      if anchors[i][0] ~= newAnchors[i][0]
	or anchors[i][1] ~= newAnchors[i][1]
      then
	anchor = newAnchors[i];
	done = true;
	break;
      end
    end
    if not done and #anchors ~= #newAnchors then
      done = true;
      anchor = newAnchors[#newAnchors];
    end
    if not done and lsGetTimer() > startTime + timeout then
      done = true;
    end
    anchors = newAnchors;
    statusScreen("Waiting for window to open");
    lsSleep(tick_delay);
  end
  if anchor then
    success = true;
    if not findImageInWindow("UnPin.png", x+5, y) then
      safeClick(anchor[0], anchor[1], 1);
      statusScreen("Pinning window");
    end
  end
  return success;
end

-------------------------------------------------------------------------------
-- arrangeInGrid(cascade, waterGap, varWidth, varHeight, sizeRight, offsetWidth, offsetHeight)
--
-- Arrange all open windows into a grid on the screen. Stashes them first.
--
-- cascade (optional) -- arrange windows into an overlapping cascade
-- waterGap (optional) -- leave a gap at the top for getting water
-- varWidth, varHeight (optional) -- specify window width/height - instead of detecting.
-- sizeRight (optional) -- amount of space to right of screen, defaults to automato width
-- offsetWidth (optional) -- adds an additional width offset
-- offsetHeight (optional) -- adds an additional height offset

-------------------------------------------------------------------------------

function arrangeInGrid(cascade, waterGap, varWidth, varHeight, sizeRight, offsetWidth, offsetHeight)
  stashAllWindows(BOTTOM_LEFT);
  stashAllWindows(BOTTOM_RIGHT);
  arrangeStashed(cascade, waterGap, varWidth, varHeight, sizeRight, offsetWidth, offsetHeight);
end

-------------------------------------------------------------------------------
-- arrangeStashed(cascade, waterGap, varWidth, varHeight, sizeRight, offsetWidth, offsetHeight)
--
-- Arrange all open windows into a grid on the screen. Assumes they
-- are pre-stashed.
--
-- cascade (optional) -- arrange windows into a overlapping cascade
-- waterGap (optional) -- leave a 50px gap at the top (for water or similar)
-- varWidth (optional) -- width of windows, if not set width will be initial window width
-- varHeight (optional) --  height of windows, if not set height will be initial window height
-- sizeRight (optional) -- amount of space to right of screen, defaults to automato width
-- offsetWidth (optional) -- adds an additional width offset
-- offsetHeight (optional) -- adds an additional height offset

-------------------------------------------------------------------------------

function arrangeStashed(cascade, waterGap, varWidth, varHeight, sizeRight, offsetWidth, offsetHeight)
  local screen = srGetWindowSize();
  local bottomRightX = screen[0] - 20;
  local bottomRightY = screen[1] - 20;

 if sizeRight then
	 screen[0] = screen[0] - sizeRight;
 else
	screen[0] = screen[0] - lsGetWindowSize()[0];
 end
 
  local currentX = 0;
  local currentY = 0;
  if waterGap then
    currentY = 50;
  end
  local lastX = 0;
  local lastY = 0;
  local xMax = 0;
  local yMax = 0;
  srReadScreen();
  local window = findImageInWindow("ThisIs.png", bottomRightX, bottomRightY);
  while window and (window[0] > lastX or window[1] > lastY) do
    safeClick(window[0], window[1]);
    lsSleep(click_delay);
    srReadScreen();
    local bounds = srGetWindowBorders(window[0], window[1]);
    local width, height;
    if not varWidth then
      width = bounds[2] - bounds[0];
    else
      width = varWidth;
    end
    if not varHeight then
      height = bounds[3] - bounds[1];
    else
      height = varHeight;
    end
    if offsetWidth then
     width = width + offsetWidth;
    end
    if offsetHeight then
     height = height + offsetHeight;
    end
    
    if cascade then
      if currentY + height >= screen[1] then
        currentX = currentX + xMax;
        currentY = 0;
        xMax = 0;
      end
      if currentX + width >= screen[0] then
        error("Cannot arrange these windows into a cascade.");
      end
    else
      if currentX + width >= screen[0] then
        currentX = 0;
        currentY = currentY + yMax;
        yMax = 0;
      end
      if currentY + height >= screen[1] then
        error("Cannot arrange these windows into a grid.");
      end
    end
    lastX = window[0] - bounds[0] + currentX;
    lastY = window[1] - bounds[1] + currentY;
    safeDrag(window[0], window[1], lastX, lastY);
    if cascade then
      currentX = currentX + 8;
      currentY = currentY + 25;
    else
      currentX = currentX + width + 5;
    end
    xMax = math.max(xMax, width);
    yMax = math.max(yMax, height);
    lsSleep(tick_delay);
    srReadScreen();
    window = findImageInWindow("ThisIs.png", bottomRightX, bottomRightY);
    statusScreen("Arranging Windows");
  end
end

-------------------------------------------------------------------------------
-- closeAllWindows(x, y, width, height)
--
-- Close all open windows.
--
-- x, y (optional) -- origin of box to search
-- width, height (optional) -- size of box to search
-------------------------------------------------------------------------------

function closeAllWindows(x, y, width, height)
  if not x then
    x = 0;
  end
  if not y then
    y = 0;
  end
  if not width then
    width = srGetWindowSize()[0];
  end
  if not height then
    height = srGetWindowSize()[1];
  end

  local closeImages = {"ThisIs.png", "UnPin.png", "Ok.png"};
  local closeRight = {1, 1, nil};

  local found = true;
  while found do
    found = false;
    for i=1,#closeImages do
      local image = closeImages[i];
      local right = closeRight[i];
      srReadScreen();
      local images = findAllImagesInRange(image, x, y, width, height);
      while #images >= 1 do
	done = true;
	safeClick(images[#images][0], images[#images][1], right);
	sleepWithStatus(200, "Closing Windows");
	srReadScreen();
	images = findAllImagesInRange(image, x, y, width, height);
      end
    end
  end
end

-------------------------------------------------------------------------------
-- closeEmptyRegions()
--
-- Closes all empty windows on the screen
--
-------------------------------------------------------------------------------

function closeEmptyRegions()
  allRegs = findAllTextRegions();
  if allRegs then
    for i = 1, #allRegs do
      local p = parseRegion(allRegs[i]);
      if p == nil then
        unpinRegion(allRegs[i]);
      end
    end
  end
end

-------------------------------------------------------------------------------
-- windowManager(title, message, allowCascade, allowWaterGap, varWidth, varHeight, sizeRight, offsetWidth, offsetHeight, default_focus, default_waterGap)
--
-- Run a window manager interface to let the user open, pin, arrange,
-- or clear windows.
--
-- title (optional) -- title of window
-- message (optional) -- extra instructions for the user
-- allowCascade (optional) -- allow the user to arrange in a cascade
-- allowWaterGap (optional) -- allow the user to add a water gap
-- varWidth, varHeight (optional) -- specify window width/height - instead of detecting
-- sizeRight (optional) -- amount of space to right of screen, defaults to automato width
-- offsetWidth (optional) -- adds an additional width offset
-- offsetHeight (optional) -- adds an additional height offset
-- default_focus (optional) -- bool: force 'Pause for Focus' box to be checked
-- default_waterGap (optional) -- bool: force 'Leave Gap for Water' box to be checked

-------------------------------------------------------------------------------

pauseForFocus = false;

function windowManager(title, message, allowCascade, allowWaterGap, varWidth, varHeight, sizeRight, offsetWidth, offsetHeight, default_focus, default_waterGap)
  if not title then
    title = "Window Manager";
  end
  if not message then
    message = "Tap Ctrl to open and pin a window.\nTap Alt to open, pin and stash."
  end
  local waterGap = false;

  if default_waterGap then
    waterGap = true;
  end

  if default_focus then
    pauseForFocus = true;
  end

  local shift = false;
  local done = false;
  while not done do
    local y = 10;
    lsPrint(10, y, 0, 1.0, 1.0, 0xFFFFFFff, title);
    y = y + 50;

    if lsButtonText(30, y, 0, 250, 0x80D080ff, "Form Grid") then
      lsDoFrame();
      if pauseForFocus then
	askForWindow(focusMessage);
      end
      arrangeInGrid(false, waterGap, varWidth, varHeight, sizeRight, offsetWidth, offsetHeight);
    end
    y = y + 30;

    if allowCascade then
      if lsButtonText(30, y, 0, 250, 0x80D080ff, "Form Cascade") then
	lsDoFrame();
	if pauseForFocus then
	  askForWindow(focusMessage);
	end
	arrangeInGrid(true, waterGap, varWidth, varHeight, sizeRight, offsetWidth, offsetHeight);
      end
      y = y + 30;
    end

    if lsButtonText(30, y, 0, 250, 0x80D080ff, "Stash Windows (Right)") then
      lsDoFrame();
      if pauseForFocus then
	askForWindow(focusMessage);
      end
      stashAllWindows(BOTTOM_RIGHT);
    end
    y = y + 30;

    if lsButtonText(30, y, 0, 250, 0x80D080ff, "Stash Windows (Left)") then
      lsDoFrame();
      if pauseForFocus then
	askForWindow(focusMessage);
      end
      stashAllWindows(BOTTOM_LEFT);
    end
    y = y + 30;

    if lsButtonText(30, y, 0, 250, 0x80D080ff, "Un-Pin Windows") then
      lsDoFrame();
      if pauseForFocus then
	askForWindow(focusMessage);
      end
      closeAllWindows();
    end
    y = y + 40;

    pauseForFocus = CheckBox(30, y, 10, 0xffffffff, " Pause for Focus",
			    pauseForFocus);
    if allowWaterGap then
      y = y + 20;
      waterGap = CheckBox(30, y, 10, 0xffffffff, " Leave Gap for Water",
			    waterGap);
    end
      y = y + 30;

    lsPrintWrapped(10, y, 0, lsScreenY - 20, 0.7, 0.7, 0xd0d0d0ff,
		   message);
    if lsButtonText(lsScreenX - 110, lsScreenY - 30, 0, 100,
		    0xffffffff, "End Script") then
      error(quit_message);
    end
    while lsControlHeld() do
      checkBreak();
      shift = true;
    end
    if shift then
      shift = false;
      local x = 0;
      local y = 0;
      x, y = srMousePos();
      openAndPin(x, y, 500);
    end
    while lsAltHeld() do
      checkBreak();
      shift = true;
    end
    if shift then
      shift = false;
      local x = 0;
      local y = 0;
      x, y = srMousePos();
      openAndPin(x, y, 500);
      stashWindow(x, y, BOTTOM_RIGHT);
    end
    if lsButtonText(10, lsScreenY - 30, 0, 100, 0xFFFFFFff, "Done") then
        done = true;
    end
    checkBreak();
    lsDoFrame();
    lsSleep(tick_delay);
  end
end

-------------------------------------------------------------------------------
-- unpinManager(title, message)
--
-- Interface to help the user clear away all windows when a macro completes.
--
-- title (optional)  -- title of window
-- message (optional) -- extra instructions for the user
-------------------------------------------------------------------------------

function unpinManager(title, message)
  if not title then
    title = "Unpin Manager";
  end
  if not message then
    message = "";
  end
  while lsShiftHeld() and lsControlHeld() do
    lsPrintWrapped(10, 80, 0, lsScreenX - 20, 0.8, 0.8, 0x808080ff,
		  "Please release Ctrl+Shift");
    lsSleep(tick_delay);
    lsDoFrame();
  end
  local done = false;
  while not done do
    lsPrint(10, 10, 0, 1.0, 1.0, 0xFFFFFFff, title);
    lsPrintWrapped(10, 60, 0, lsScreenX - 20, 0.7, 0.7,
		   0xd0d0d0ff, message);
    if lsButtonText(30, 160, 0, 250, 0x80D080ff, "Un-Pin Windows") then
      lsDoFrame();
      if pauseForFocus then
	askForWindow(focusMessage);
      end
      closeAllWindows();
    end
    if lsButtonText(lsScreenX - 110, lsScreenY - 30, 0, 100,
		    0xffffffff, "Done") then
      done = true;
    end
    if lsShiftHeld() and lsControlHeld() then
      done = true;
    end
    lsDoFrame();
    lsSleep(tick_delay);
  end
end

-------------------------------------------------------------------------------
-- unpinRegion(region)
--
-- Unpins a region
--
-- region - region object to unpin
-------------------------------------------------------------------------------

function unpinRegion(region)
  if region then
    lsPrintln("Unpinning at: " .. region[0] + region[2] - 15 .. ", " .. region[1] + region[3] + 15);
    safeClick(region[0] + region[2] - 15, region[1] + 15, 0);
  end
end

-------------------------------------------------------------------------------
-- unpinOnExit(f)
--
-- Execute function f and present an unpin manager window when it
-- completes or if an error is thrown.
--
-- f -- function to execute with no arguments
-------------------------------------------------------------------------------

function unpinOnExit(f)
  if not f then
    error("Incorrect number of arguments for f");
  end
  local status, error = pcall(f);
  unpinManager("Complete", error);
end

-------------------------------------------------------------------------------
-- closeEmptyAndErrorWindows()
--
-- Closes all empty windows and error windows on the screen
--
-------------------------------------------------------------------------------

function closeEmptyAndErrorWindows()
  local windows = findAllWindows();
  local closed = 0;
  if windows then
    for i = 1, #windows do
      temp = makeBox(windows[i].x + 7, windows[i].y + 4, 
          windows[i].width -35, windows[i].height - 7);
      p = parseWindow(temp);
      
      if #p == 0 then
        unpinWindow(windows[i]);
        closed = closed + 1;
      end
    end
  end
  return closed;
end

-------------------------------------------------------------------------------
-- unpinWindow(window)
--
-- Unpins a window
--
-- window - window object to unpin
-------------------------------------------------------------------------------

function unpinWindow(window)
  if window then
    safeClick(window.x + window.width - 15, window.y + 15, 0);
  end
end

-------------------------------------------------------------------------------
-- checkWindowSize()
--
-- Used by Bluestacks to make sure the window is resized correctly 
-- This will help ensure we get positive matches on images because captured Bluestack images at 1751x985.
--
-------------------------------------------------------------------------------


function checkWindowSize()
  local ok = nil;
  local windowSize = nil;

  while not ok do
    srReadScreen();
    windowSize = srGetWindowSize();

    if windowSize[0] == 1751 and windowSize[1] == 985 then
     ok = 1;

	 while lsMouseIsDown() do
       srReadScreen();
       windowSize = srGetWindowSize();
       if windowSize[0] == 1751 and windowSize[1] == 985 then
         statusScreen("Current Window Size: Perfect!\n\nRelease Mouse button now.", nil, nil, 0.7);
         ok = 1;
        else
          statusScreen("Current Window Size: " .. windowSize[0] .. "x" .. windowSize[1] .. "\n\nTarget Window Size: 1751x985\n\nStart resizing Blue Stacks window (from a corner) until target size matches!", nil, nil, 0.7);
          ok = nil;
        end

	 end -- while lsMouseIsDown

    end

    if not ok then
      statusScreen("Current Window Size: " .. windowSize[0] .. "x" .. windowSize[1] .. "\n\nTarget Window Size: 1751x985\n\nStart resizing Blue Stacks window (from a corner) until target size matches!", nil, nil, 0.7);
    end

  end -- while not ok
end
