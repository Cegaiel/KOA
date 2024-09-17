dofile("common.inc");


function doit()
  askForWindow("Show current window size. I personally have Bluestacks sized at 1751x985 .\n\nTap Shift while hovering Bluestacks!");  

  while 1 do
    srReadScreen();
    local windowSize = srGetWindowSize();
    if windowSize[0] == 1751 and windowSize[1] == 985 then
      message = "\n\nPERFECT!"
    else
      message = "";
    end
    statusScreen("Current Window Size: " .. windowSize[0] .. "x" .. windowSize[1] .. "\n\nTarget is 1751x985" .. message, nil, nil, 0.7);
  end
end