dofile("common.inc");

function doit()
  askForWindow("Show current window size.\n\nI personally use Bluestacks sized at 1751x985.\n\nUsing this size will ensure that any images will be found.\n\nTap Shift while hovering Bluestacks!");  

  while 1 do
    srReadScreen();
    local windowSize = srGetWindowSize();
    if windowSize[0] == 1751 and windowSize[1] == 985 then
      message = "PERFECT!"
      if not playSound then
        lsPlaySound("trolley.wav");
        playSound = 1;
      end
    else
      playSound = nil;
      message = "Start resizing Blue Stacks window (from a corner) until target size matches!";
    end
    statusScreen("Current Window Size: " .. windowSize[0] .. "x" .. windowSize[1] .. "\n\nTarget is 1751x985\n\n" .. message, nil, nil, 0.7);
  end
end