dofile("common.inc");
dofile("constants.inc");

tolerance = 7000;

function doit()

  askForWindow("For Hero Rally research using speedups\n\nSearches for Use All, Research and Get More (to open speedup menu) buttons.");  

  checkWindowSize();

  while 1 do
    heroRally()
    sleepWithStatus(200, "Looking for buttons to click")
  end
end

function heroRally()
  srReadScreen();
  local green = srFindImage("training/use_all_green.png", tolerance);
  local more = srFindImage("get_more.png", tolerance);
  local research = srFindImage("research.png", tolerance);
  local close = srFindImage("window_close.png", tolerance);


    if more then
      srClickMouse(more[0],more[1]);
      lsSleep(100);
      sleepWithStatus(1000, "Clicked 'Get More' button");

    elseif research then
      curLoc = getMousePos();
      srClickMouse(research[0],research[1]);
      lsSleep(100);
      sleepWithStatus(1000, "Clicked 'Research' button");

    elseif green then
      srClickMouse(green[0],green[1]);
      lsSleep(100);
      sleepWithStatus(1000, "Clicked 'Use All' button");
      doRepeat= 1;

    elseif close then
      --Hit Esc key
      srKeyDown(VK_ESCAPE);
      lsSleep(100);
      srKeyUp(VK_ESCAPE);
      sleepWithStatus(1000, "Training is MAXed. Closing Window.");

    end

    if doRepeat then
      srClickMouse(curLoc[0],curLoc[1]);
      lsSleep(100);
      sleepWithStatus(2500, "Checking if we can train any more!");
      doRepeat = nil;
    end

end
