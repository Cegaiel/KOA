dofile("common.inc");


function doit()
  askForWindow("Show current window size. I personally have Bluestacks sized at 1751x985 .\n\nTap Shift while hovering Bluestacks!");  

  while 1 do
    local windowSize = srGetWindowSize();
    statusScreen("Current Window Size: " .. windowSize[0] .. "x" .. windowSize[1], nil, nil, 0.7);
  end
end