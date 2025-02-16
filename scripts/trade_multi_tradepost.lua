dofile("common.inc");
dofile("settings.inc");

marchslots = 5
tradepct = 16
dropdown_qty = {};
secondsSend = 0;
secondsReturn = 0;
delay = 0;
extraDelay = 0;
tradeButtonPlusTolerance = 8000;  -- default is 4500; Add higher value here to make sure it's found. This is the + button you see when you open trade window.

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
testMode = false; -- Only send 1 (testModeQty) resource at a time. Idea for testing out macro without sending a bunch of resources. Set to true to enable testMode.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- returnMarchReSend Notes:
-- if set to 2 then when your 2nd of 5 or 6 march has returned, it'll start sending more.
-- 3 will wait until the 3rd march returns before sending more troops
-- 4 will wait until the 4th march returns before sending more troops

-- Use 4 to be really safe, 3 is faster, 2 is really fast but be careful -> it might potentially fail to send last march if all marches haven't returned yet)

-- 4 is very safe. If game is running lag-free then you can try 2 or 3.
-- It's better to be safe than sorry. If in doubt choose 4 to be really safe or 5 for maximum safety. However you save about 1 second for every number above 5.

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
returnMarchReSend = 4; -- which march # (that's returned) before we start resending resources again
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- ETA is uses delay value that you set for each of your characters in askResources() function.
-- If set delay 53 (seconds) then ETA is calculated using that number and multiplying by number of marches it will take to finish trading.
-- However, we need to also consider the amount of time it takes to click/send for EACH of your marches.
-- 1-2 seconds for each march is a good number to consider for extraDelay.
-- extraDelay is ONLY a visual thing for ETA "Remaining" time on screen. It does not affect trade behavior. It's simply to try to give you an idea of ETA remaining.

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Additional seconds for ETA calculation
 extraDelay = returnMarchReSend;

-- Optionally uncomment below to override default value
-- extraDelay = 3;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- Define your characters/farms
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
dropdown_who_values = {"Ceg A", "Ceg B", "Ceg C"};
------------------------------------------------------------------------------------------------------------------------------------------------------------------------


function doit()
  askForWindow("Trade Resources to Player from Trading Post\n\nTap Shift over Bluestacks window to continue!");
  promptOkay("Don\'t Forget !\n\nWhen trading Equip BOTH:\n\nHERO: Sir Dinadan\n\nARMOR: Production (Helm + Greaves)", nil, 0.7, nil, 1, nil)

  checkWindowSize();

  while 1 do
    askResources()

    if doFood then
      promptNumbers(1)
    end

    if doWood then
      promptNumbers(2)
    end

    if doIron then
      promptNumbers(3)
    end

    if doSilver then
      promptNumbers(4)
    end

    if successfulCastLoc then
      sleepWithStatus(1500,"Ready to click last known Send button location.\n\nDO NOT TOUCH MOUSE!!!", nil, 0.7);
    else
      castleLoc()
    end

    if doFood then
      sleepWithStatus(1000,"Starting FOOD Transfer!\n\nDon't Touch Mouse for a moment!", nil, 0.7)
      main(1)
    end

    if doWood then
      sleepWithStatus(1000,"Starting WOOD Transfer!\n\nDon't Touch Mouse for a moment!", nil, 0.7)
      main(2)
    end

    if doIron then
      sleepWithStatus(1000,"Starting IRON Transfer!\n\nDon't Touch Mouse for a moment!", nil, 0.7)
      main(3)
    end

    if doSilver then
      sleepWithStatus(1000,"Starting SILVER Transfer!\n\nDon't Touch Mouse for a moment!", nil, 0.7)
      main(4)
    end

    if finished then
      finish()
    end

  end -- while
end


function castleLoc()
  while not lsShiftHeld() do
    sleepWithStatus(100,"Click your Trade Post, Resource Help button, Members Tab and find the Player you want to trade\n\nTap Shift over Send Button !", nil, 0.7);
  end

  while lsShiftHeld() do
    sleepWithStatus(100,"Release Shift Key", nil, 0.7);
  end

  castlePos = getMousePos()
end


function askResources()
  local scale = 0.8;
  local z = 0;
  local y = 0;
  local is_done = nil;
  local defaultColor = 0xffffffFF;
  local highlightColor = 0xfff76bFF;

  while not is_done do
    checkBreak("disallow pause");

    if doFood then
      doFoodColor = highlightColor;
    else
      doFoodColor = defaultColor;
    end

    if doWood then
      doWoodColor = highlightColor;
    else
      doWoodColor = defaultColor;
    end

    if doIron then
      doIronColor = highlightColor;
    else
      doIronColor = defaultColor;
    end

    if doSilver then
      doSilverColor = highlightColor;
    else
      doSilverColor = defaultColor;
    end

    y = 10;
    lsPrint(10, y, z, scale, scale, 0xFFFFFFff, "Who is Trading?");
    y = y + 30;

    lsSetCamera(0,0,lsScreenX*1.3,lsScreenY*1.3);
    dropdown_who_cur_value = readSetting("dropdown_who_cur_value",dropdown_who_cur_value);
    dropdown_who_cur_value = lsDropdown("who", 10, y, 0, 320, dropdown_who_cur_value, dropdown_who_values);
    writeSetting("dropdown_who_cur_value",dropdown_who_cur_value);
    lsSetCamera(0,0,lsScreenX*1.0,lsScreenY*1.0);


------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Define your characters delay, march slots and quantities that you can trade
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Ceg A

    if (dropdown_who_cur_value == 1) then
      dropdown_qty = {600000, 120000, 30000}; -- Food/Wood, Iron, Silver - 50% from Dinadin
      marchslots = 5;
      tradepct = 10.0; -- See Trade Fee on the ACTUAL trade window! Don't use value in Trading Post -> Info window
      secondsSend = 28; -- How many seconds appears on Trade window
      secondsReturn = 23; -- Seconds that appears on March when march is returning home


--Ceg B

    elseif (dropdown_who_cur_value == 2) then
      dropdown_qty = {600000, 120000, 30000}; -- Food/Wood, Iron, Silver - 50% from Dinadin
      marchslots = 5;
      tradepct = 10.0; -- See Trade Fee on the ACTUAL trade window! Don't use value in Trading Post -> Info window
      secondsSend = 28; -- How many seconds appears on Trade window
      secondsReturn = 23; -- Seconds that appears on March when march is returning home


--Ceg C

    elseif (dropdown_who_cur_value == 3) then
      dropdown_qty = {600000, 120000, 30000}; -- Food/Wood, Iron, Silver - 50% from Dinadin
      marchslots = 5;
      tradepct = 10.0; -- See Trade Fee on the ACTUAL trade window! Don't use value in Trading Post -> Info window
      secondsSend = 28; -- How many seconds appears on Trade window
      secondsReturn = 34; -- Seconds that appears on March when march is returning home

------------------------------------------------------------------

    -- Add More characters here with more elseif statements.

------------------------------------------------------------------

    end

    delay = secondsSend + secondsReturn;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    y = y + 40;

    lsPrint(10, y, z, scale, scale, 0xFFFFFFff, "Trade which resources?");
    y = y + 30;

    doFood = readSetting("doFood",doFood);
    doFood = CheckBox(10, y, 10, doFoodColor, "  Food  ( " .. addComma(dropdown_qty[1]) .. " )", doFood, scale, scale);
    writeSetting("doFood",doFood);

    y = y + 30;

    doWood = readSetting("doWood",doWood);
    doWood = CheckBox(10, y, 10, doWoodColor, "  Wood  ( " .. addComma(dropdown_qty[1]) .. " )", doWood, scale, scale);
    writeSetting("doWood",doWood);

    y = y + 30;

    doIron = readSetting("doIron",doIron);
    doIron = CheckBox(10, y, 10, doIronColor, "  Iron  ( " .. addComma(dropdown_qty[2]) .. " )", doIron, scale, scale);
    writeSetting("doIron",doIron);

    y = y + 30;

    doSilver = readSetting("doSilver",doSilver);
    doSilver = CheckBox(10, y, 10, doSilverColor, "  Silver  ( " .. addComma(dropdown_qty[3]) .. " )", doSilver, scale, scale);
    writeSetting("doSilver",doSilver);

    if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff, "End script") then
      error "Clicked End Script button";
    end
	
    if doFood or doWood or doIron or doSilver then
      if lsButtonText(10, lsScreenY - 30, z, 100, 0xFFFFFFff, "Next") then
        is_done = 1;
      end
    end

    lsDoFrame();
    lsSleep(10); -- Sleep just so we don't eat up all the CPU for no reason

  end -- while

end -- askResources()


function resetGlobalVariables()
    totalSent = 0;
    shutdown = nil;
    finished = nil;
    totalNetSent = 0;
    slotsSent = 0;
    tradetotalqty = 0;
    tradetotalqty_food = 0;
    tradetotalqty_wood = 0;
    tradetotalqty_iron = 0;
    tradetotalqty_silver = 0;
    qty = 0;
    resourceName = "?";
    slotsToFulfill = 0;
    slotsToFulfillQty = 0;
    tradeMult = 0;
    qtyAfterFee = 0;
    transferPerSlot = 0;
    transferPerMarch = 0;
    actualTransferPerSlot = 0;
    actualTransferPerMarch = 0;
    loopCount = 0;
end


function promptNumbers(resource)
  resetGlobalVariables();
  local scale = 0.7;
  local z = 0;
  local is_done = nil;

  while not is_done do
    checkBreak("disallow pause");
    local sendMaxMarchSlotsColor = 0xFFFFFFff;
    local y = 10;
    lsPrint(10, y, z, scale, scale, 0xFFFFFFff, "Setup " .. resourceName .. " Trade for:  " .. dropdown_who_values[dropdown_who_cur_value]);
    y = y + 30

    lsPrint(10, y+35, z, scale, scale, 0xFFFFFFff, "Trade Total Qty: ");

    y = y + 35

    if resource == 1 then
      lsPrint(140, y+25, z, scale, scale, 0xFFFFFFff, addComma(tradetotalqty_food));
      tradetotalqty_food = readSetting("tradetotalqty_food",tradetotalqty_food);
      is_done, tradetotalqty_food = lsEditBox("tradetotalqty_food",
        10, y+20, z, 120, 30, scale, scale,
        0x000000ff, tradetotalqty_food);

      if not tonumber(tradetotalqty_food) then
        is_done = nil;
        lsPrint(15, y+25, z+10, 0.7, 0.7, 0xFF2020ff, "NOT NUMERIC !");
        tradetotalqty_food = 0;
      else
        writeSetting("tradetotalqty_food",tonumber(tradetotalqty_food));
      end

      tradetotalqty = tradetotalqty_food;
      qty = dropdown_qty[1];
      resourceName = "FOOD"
      sendMaxMarchSlots_food = readSetting("sendMaxMarchSlots_food",sendMaxMarchSlots_food);
      if sendMaxMarchSlots_food then sendMaxMarchSlotsColor = 0xffaa00ff; end
      sendMaxMarchSlots_food = CheckBox(10, y-35, 10, sendMaxMarchSlotsColor, "  Send Marches dividable by max slots: " .. marchslots, sendMaxMarchSlots_food, 0.7, 0.7);
      writeSetting("sendMaxMarchSlots_food",sendMaxMarchSlots_food);


    elseif resource == 2 then
      lsPrint(140, y+25, z, scale, scale, 0xFFFFFFff, addComma(tradetotalqty_wood));
      tradetotalqty_wood = readSetting("tradetotalqty_wood",tradetotalqty_wood);
      is_done, tradetotalqty_wood = lsEditBox("tradetotalqty_wood",
        10, y+20, z, 120, 30, scale, scale,
        0x000000ff, tradetotalqty_wood);

      if not tonumber(tradetotalqty_wood) then
        is_done = nil;
        lsPrint(15, y+25, z+10, 0.7, 0.7, 0xFF2020ff, "NOT NUMERIC !");
        tradetotalqty_wood = 0;
      else
        writeSetting("tradetotalqty_wood",tonumber(tradetotalqty_wood));
      end

      tradetotalqty = tradetotalqty_wood;
      qty = dropdown_qty[1];
      resourceName = "WOOD"
      sendMaxMarchSlots_wood = readSetting("sendMaxMarchSlots_wood",sendMaxMarchSlots_wood);
      if sendMaxMarchSlots_wood then sendMaxMarchSlotsColor = 0xffaa00ff; end
      sendMaxMarchSlots_wood = CheckBox(10, y-35, 10, sendMaxMarchSlotsColor, "  Send Marches dividable by max slots: " .. marchslots, sendMaxMarchSlots_wood, 0.7, 0.7);
      writeSetting("sendMaxMarchSlots_wood",sendMaxMarchSlots_wood);


    elseif resource == 3 then
      lsPrint(140, y+25, z, scale, scale, 0xFFFFFFff, addComma(tradetotalqty_iron));
      tradetotalqty_iron = readSetting("tradetotalqty_iron",tradetotalqty_iron);
      is_done, tradetotalqty_iron = lsEditBox("tradetotalqty_iron",
        10, y+20, z, 120, 30, scale, scale,
        0x000000ff, tradetotalqty_iron);

      if not tonumber(tradetotalqty_iron) then
        is_done = nil;
        lsPrint(15, y+25, z+10, 0.7, 0.7, 0xFF2020ff, "NOT NUMERIC !");
        tradetotalqty_iron = 0;
      else
        writeSetting("tradetotalqty_iron",tonumber(tradetotalqty_iron));
      end

      tradetotalqty = tradetotalqty_iron;
      qty = dropdown_qty[2];
      resourceName = "IRON"
      sendMaxMarchSlots_iron = readSetting("sendMaxMarchSlots_iron",sendMaxMarchSlots_iron);
      if sendMaxMarchSlots_iron then sendMaxMarchSlotsColor = 0xffaa00ff; end
      sendMaxMarchSlots_iron = CheckBox(10, y-35, 10, sendMaxMarchSlotsColor, "  Send Marches dividable by max slots: " .. marchslots, sendMaxMarchSlots_iron, 0.7, 0.7);
      writeSetting("sendMaxMarchSlots_iron",sendMaxMarchSlots_iron);


    elseif resource == 4 then
      lsPrint(140, y+25, z, scale, scale, 0xFFFFFFff, addComma(tradetotalqty_silver));
      tradetotalqty_silver = readSetting("tradetotalqty_silver",tradetotalqty_silver);
      is_done, tradetotalqty_silver = lsEditBox("tradetotalqty_silver",
        10, y+20, z, 120, 30, scale, scale,
        0x000000ff, tradetotalqty_silver);

      if not tonumber(tradetotalqty_silver) then
        is_done = nil;
        lsPrint(15, y+25, z+10, 0.7, 0.7, 0xFF2020ff, "NOT NUMERIC !");
        tradetotalqty_silver = 0;
      else
        writeSetting("tradetotalqty_silver",tonumber(tradetotalqty_silver));
      end

      tradetotalqty = tradetotalqty_silver;
      qty = dropdown_qty[3];
      resourceName = "SILVER"
      sendMaxMarchSlots_silver = readSetting("sendMaxMarchSlots_silver",sendMaxMarchSlots_silver);
      if sendMaxMarchSlots_silver then sendMaxMarchSlotsColor = 0xffaa00ff; end
      sendMaxMarchSlots_silver = CheckBox(10, y-35, 10, sendMaxMarchSlotsColor, "  Send Marches dividable by max slots: " .. marchslots, sendMaxMarchSlots_silver, 0.7, 0.7);
      writeSetting("sendMaxMarchSlots_silver",sendMaxMarchSlots_silver);

    end

    slotsToFulfill = math.floor(tradetotalqty / qty)
    slotsToFulfillQty = math.floor(slotsToFulfill * qty)

    if (resource == 1 and sendMaxMarchSlots_food) or (resource == 2 and sendMaxMarchSlots_wood) or (resource == 3 and sendMaxMarchSlots_iron) or (resource == 4 and sendMaxMarchSlots_silver) then
      local recalculate = math.floor(slotsToFulfillQty / (marchslots * qty));
      tradetotalqty = (recalculate * marchslots) * qty;
      slotsToFulfill = math.floor(tradetotalqty / qty)
      slotsToFulfillQty = math.floor(slotsToFulfill * qty)
    end

    tradeMult = tradepct * .01
    qtyAfterFee = math.floor(slotsToFulfillQty * tradeMult)
    transferPerSlot = math.floor(qty * tradeMult)
    transferPerMarch = math.floor(qty * tradeMult * marchslots)
    actualTransferPerSlot = math.floor(qty - transferPerSlot)
    actualTransferPerMarch = math.floor(actualTransferPerSlot * marchslots)
    loopCount = math.ceil((slotsToFulfillQty / qty) / marchslots)
    eta = convertTime((delay + extraDelay) * loopCount * 1000)
    etaRaw = (delay+extraDelay) * loopCount * 1000

    y = y + 55;

    if ( (resource == 1 and tonumber(tradetotalqty_food) > 0) or (resource == 2 and tonumber(tradetotalqty_wood) > 0) or (resource == 3 and tonumber(tradetotalqty_iron) > 0) or (resource == 4 and tonumber(tradetotalqty_silver) > 0) ) and loopCount > 0 then
      if lsButtonText(10, lsScreenY - 30, z, 100, 0xFFFFFFff, "Next") then
        is_done = 1;
      end

    else

      if (resource == 1 and sendMaxMarchSlots_food) or (resource == 2 and sendMaxMarchSlots_wood) or (resource == 3 and sendMaxMarchSlots_iron) or (resource == 4 and sendMaxMarchSlots_silver) then
        lsPrintWrapped(10, lsScreenY - 90, z, lsScreenX - 20, 0.7, 0.7, 0xffaa00ff, "Trade Total min (" .. addComma(qty*marchslots) .. ") not met.\nUncheck 'Send Marches dividable by max slots' checkbox for decreased (" .. addComma(qty) .. ") min.");
      else
        lsPrint(10, lsScreenY - 60, z, scale, scale, 0xFF2020ff, "Trade Total min not met (" .. addComma(qty) .. ")");
      end

    end

    if slotsToFulfill > 0 then

      lsPrintWrapped(10, y, z+10, lsScreenX - 20, 0.7, 0.7, 0xD0D0D0ff, "Actual Trade Qty:  " .. addComma(slotsToFulfillQty) .. "\n     Loss from Fee:   -" .. addComma(qtyAfterFee) .. "\n------------------------------------------\nPlayer Receives:  " .. addComma(math.floor(slotsToFulfillQty - qtyAfterFee)) .. "\n\nTrade Fee:  " .. tradepct .. "% :  " .. addComma(transferPerSlot) .. "  < x" .. marchslots .. ":  " .. addComma(transferPerMarch) .. " >\n\nGross Transfer:  " .. addComma(qty) .. "  < x" .. marchslots .. ":  " .. addComma(math.floor(qty*marchslots)) ..        " >\n\nNet Transfer:  " .. addComma(actualTransferPerSlot) .. "  < x" .. marchslots .. ":  " .. addComma(actualTransferPerMarch) .. " >\n\nMarches to Complete x" .. marchslots .. ":  " .. loopCount .. "  < " .. round((slotsToFulfillQty / qty) / marchslots,2) .. " >\n\nMarch Slots to Complete:  " .. slotsToFulfill .. "  < " .. addComma(slotsToFulfillQty) ..      " >\n\nETA:  " .. eta);

    else

      lsPrintWrapped(10, y, z+10, lsScreenX - 20, 0.7, 0.7, 0xD0D0D0ff, "Trade Total Qty:  " .. addComma(tradetotalqty) .. "\n     Loss from Fee:   -" .. addComma(math.floor(tradetotalqty*tradeMult)) .. "\n\nPlayer Receives:  " .. addComma(math.floor(tradetotalqty - (tradetotalqty*tradeMult)    )) .. "\n\nTrade Fee:  " .. tradepct .. "% :  " .. addComma(transferPerSlot) .. "  < x" .. marchslots .. ":  " .. addComma(transferPerMarch) .. " >\n\nGross Transfer:  " .. addComma(qty) .. "  < x" .. marchslots .. ":  " .. addComma(math.floor(qty*marchslots)) ..        " >\n\nNet Transfer:  " .. addComma(actualTransferPerSlot) .. "  < x" .. marchslots .. ":  " .. addComma(actualTransferPerMarch) .. " >\n\nMarches to Complete x" .. marchslots .. ":  " .. loopCount .. "  < " .. round((slotsToFulfillQty / qty) / marchslots,2) .. " >\n\nMarch Slots to Complete:  " .. slotsToFulfill .. "  < " .. addComma(slotsToFulfillQty) ..      " >\n\nETA:  " .. eta);

    end

    if is_done and (not qty) then
      error 'Canceled';
    end
		
    if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff, "End script") then
      error "Clicked End Script button";
    end
	
    lsDoFrame();
    lsSleep(10); -- Sleep just so we don't eat up all the CPU for no reason
  end -- while
end --promptNumbers(resource)


function tradeButtonPlus(resource)
  -- testMode is when we might want to do some tests on modifying the macro but we just want to send 1 resource at a time so we don't run out too fast
  -- Simply click the + button one time instead of the slider bar.
  if testMode then
    xSliderOffset = 0;
  else
    xSliderOffset = 40;
  end

  srClickMouse(castlePos[0], castlePos[1])
  if not waitForImage("tradePlus.png", 2000, "Waiting for Trade Window", nil, tradeButtonPlusTolerance) then -- Wait 2(2000ms) seconds before giving up and shutdown
    shutdown = 1;
  end

  if not shutdown then

    tradePlus = srFindImage("tradePlus.png", tradeButtonPlusTolerance)


    if resource == 1 then
      srClickMouse(tradePlus[0]-xSliderOffset, tradePlus[1]+7)
    elseif resource == 2 then
      srClickMouse(tradePlus[0]-xSliderOffset, tradePlus[1]+136)
    elseif resource == 3 then
      srClickMouse(tradePlus[0]-xSliderOffset, tradePlus[1]+261)
    elseif resource == 4 then
      srClickMouse(tradePlus[0]-xSliderOffset, tradePlus[1]+385)
    end

    srClickMouse(965, 870) -- Send Button
    if waitForNoImage("tradePlus.png", 2000, "Waiting for NO Trade window", nil, tradeButtonPlusTolerance) then -- Wait 2(2000ms) seconds before giving up and shutdown
      shutdown = 1;
      sleepWithStatus(3000, "Trade window is still open for too long -- something is wrong.\n\nAborting ...",nil,0.7,"Returning to Main Menu");
    end

  else -- shutdown is true; give up.
    sleepWithStatus(3000, "Could not find Plus button in Trade window.\n\nAborting ...",nil,0.7,"Returning to Main Menu");
  end

end --tradeButtonPlus(resource)


function main(resource)
  resetGlobalVariables()

  if resource == 1 then
    resourceName = "FOOD"
    tradetotalqty_food = readSetting("tradetotalqty_food",tradetotalqty_food);
    tradetotalqty = tradetotalqty_food;
    qty = dropdown_qty[1];
    sendMaxMarchSlots_food = readSetting("sendMaxMarchSlots_food",sendMaxMarchSlots_food);

  elseif resource == 2 then
    resourceName = "WOOD"
    tradetotalqty_wood = readSetting("tradetotalqty_wood",tradetotalqty_wood);
    tradetotalqty = tradetotalqty_wood;
    qty = dropdown_qty[1];
    sendMaxMarchSlots_wood = readSetting("sendMaxMarchSlots_wood",sendMaxMarchSlots_wood);

  elseif resource == 3 then
    resourceName = "IRON"
    tradetotalqty_iron = readSetting("tradetotalqty_iron",tradetotalqty_iron);
    tradetotalqty = tradetotalqty_iron;
    qty = dropdown_qty[2];
    sendMaxMarchSlots_iron = readSetting("sendMaxMarchSlots_iron",sendMaxMarchSlots_iron);

  elseif resource == 4 then
    resourceName = "SILVER"
    tradetotalqty_silver = readSetting("tradetotalqty_silver",tradetotalqty_silver);
    tradetotalqty = tradetotalqty_silver;
    qty = dropdown_qty[3];
    sendMaxMarchSlots_silver = readSetting("sendMaxMarchSlots_silver",sendMaxMarchSlots_silver);

  end

  slotsToFulfill = math.floor(tradetotalqty / qty)
  slotsToFulfillQty = math.floor(slotsToFulfill * qty)

  if (resource == 1 and sendMaxMarchSlots_food) or (resource == 2 and sendMaxMarchSlots_wood) or (resource == 3 and sendMaxMarchSlots_iron) or (resource == 4 and sendMaxMarchSlots_silver) then
    local recalculate = math.floor(slotsToFulfillQty / (marchslots * qty));
    tradetotalqty = (recalculate * marchslots) * qty;
    slotsToFulfill = math.floor(tradetotalqty / qty)
    slotsToFulfillQty = math.floor(slotsToFulfill * qty)
  end

  tradeMult = tradepct * .01
  qtyAfterFee = math.floor(slotsToFulfillQty * tradeMult)
  transferPerSlot = math.floor(qty * tradeMult)
  transferPerMarch = math.floor(qty * tradeMult * marchslots)

  actualTransferPerSlot = math.floor(qty - transferPerSlot)
  actualTransferPerMarch = math.floor(actualTransferPerSlot * marchslots)

  loopCount = math.ceil((slotsToFulfillQty / qty) / marchslots)

  eta = convertTime((delay + extraDelay) * loopCount * 1000)
  etaRaw = (delay+extraDelay) * loopCount * 1000

  beginTime = lsGetTimer()

  for j=1, loopCount do
    if shutdown then
      break;
    end 

    for i=1, marchslots do
      if shutdown then
        break;
      end 

      if not finished then

        tradeButtonPlus(resource)

        if shutdown then
          break;
        end

        sleepWithStatus(100, "Sending March " .. i .. " of " .. marchslots, nil, 0.7)
        totalSent = totalSent + qty
        totalNetSent = totalNetSent + actualTransferPerSlot
        totalRemaining = math.floor(slotsToFulfillQty - totalSent)
        slotsSent = slotsSent + 1

        if resource == 1 then
          lsEditBoxSetText("tradetotalqty_food", tonumber(totalRemaining));
          writeSetting("tradetotalqty_food", tonumber(totalRemaining));

        elseif resource == 2 then
          lsEditBoxSetText("tradetotalqty_wood", tonumber(totalRemaining));
          writeSetting("tradetotalqty_wood", tonumber(totalRemaining));

        elseif resource == 3 then
          lsEditBoxSetText("tradetotalqty_iron", tonumber(totalRemaining));
          writeSetting("tradetotalqty_iron", tonumber(totalRemaining));

        elseif resource == 4 then
          lsEditBoxSetText("tradetotalqty_silver", tonumber(totalRemaining));
          writeSetting("tradetotalqty_silver", tonumber(totalRemaining));
        end

      end -- if not finished

      successfulCastLoc = 1; -- We've already recorded the Send button location

      if slotsSent == slotsToFulfill then
        finished = 1
      end

      if i == returnMarchReSend then -- Start Time on this march, instead of last march, below
        marchTimer = lsGetTimer()
      end

    end -- for i 

    while not shutdown do
      marchTimerRemainingRaw = (lsGetTimer() - marchTimer) /1000;
      marchTimerRemaining = math.floor(marchTimerRemainingRaw);
      marchTimerRemainingReverseRaw = delay - marchTimerRemainingRaw;
      marchTimerRemainingReverse = math.floor(marchTimerRemainingReverseRaw);
	netRemaining = math.floor((slotsToFulfillQty - qtyAfterFee) - totalNetSent);

	if netRemaining < 0 then netRemaining = 0; end

      if marchTimerRemainingRaw < secondsSend then
        status = ">> Sending March >>"
      else
        status = "<< March Returning <<"
      end

      if tonumber(marchTimerRemaining) >= tonumber(delay) then
        break;
      else

        waitingMessage = "Waiting " .. marchTimerRemaining .. " (" .. marchTimerRemainingReverse .. ") of " .. math.floor(delay) .. "s for this March"
        finishedMessage = "FINISHED"
        mainMessage = "Resource:  " .. resourceName .. "  ( " .. status .. " )\n\nSent " .. slotsSent .. " of " .. slotsToFulfill .. " March Slots\nPasses: " .. j .. " of " .. loopCount .. "  < " .. loopCount - j .. " Remaining >\n\nTotal Gross Sent: " .. addComma(math.floor(totalSent)) .. " of " .. addComma(slotsToFulfillQty) .. "\nTotal Net Sent:    " .. addComma(math.floor(totalNetSent)) .. " of " .. addComma(math.floor(slotsToFulfillQty - qtyAfterFee)) ..  "\n\nN/G Per March: " .. addComma(actualTransferPerMarch) .. " / " .. addComma(math.floor(qty*marchslots)) .. "\nN/G Remaining: " .. addComma(netRemaining) .. " / " .. addComma(totalRemaining) .. "\n\n" .. eta .."  |  ETA\n" .. getElapsedTime(beginTime) .. "  |  Elapsed\n" .. convertTime(etaRaw - (lsGetTimer()-beginTime)) .. "  |  Remaining\n\n" .. convertTime(marchTimerRemainingReverseRaw*1000) ..  "  | Remaining (This March)";


        sleepWithStatus(200, mainMessage, nil, 0.7, waitingMessage)
--	    stfu()
        end -- if tonumber(marchTimeRemaining)

    end  -- while

  end --for j


  if shutdown then -- We didn't get a Trade button on first try, so abort, start Over
    shutdown = nil;
    lsPlaySound("error.wav")
    castleLoc()
    main(resource)
  end

end --main(resource)


function finish()
  soundCounter = 0;
  while 1 do
    --statusScreen(mainMessage, nil, 0.7);
    statusScreen("All resources have been transfered!", nil, 0.7);
    if lsButtonText(10, lsScreenY - 30, 0, 120, 0xFFFFFFFF, "Main Menu") then
      break;
    end
    if soundCounter == 0 then
      lsPlaySound("successful.wav");
    end
    soundCounter = soundCounter + 1;
      if soundCounter == 35 then soundCounter = 0 end
    lsSleep(100);
  end -- while
end


function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end


function addComma(amount)
  local formatted = amount
  while true do  
    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
    if (k==0) then
      break
    end
  end
  return formatted
end


function convertTime(startTime)
        local duration = math.floor((startTime) / 1000);
        local hours = math.floor(duration / 60 / 60);
        local minutes = math.floor((duration - hours * 60 * 60) / 60);
        local seconds = duration - hours * 60 * 60 - minutes * 60;
        return string.format("%02d:%02d:%02d",hours,minutes,seconds);
end


--Custom sleepWithStatus to add extra boxes, buttons, etc
local waitChars = {"-", "\\", "|", "/"};
local waitFrame = 1;

function sleepWithStatus(delay_time, message, color, scale, waitMessage)
  if not waitMessage then
    waitMessage = "Waiting ";
  else
    waitMessage = waitMessage .. " ";
  end
  if not color then
    color = 0xffffffff;
  end
  if not delay_time then
    error("Incorrect number of arguments for sleepWithStatus()");
  end
  if not scale then
    scale = 0.8;
  end
  local start_time = lsGetTimer();
  while delay_time > (lsGetTimer() - start_time) do
    local frame = math.floor(waitFrame/5) % #waitChars + 1;
    time_left = delay_time - (lsGetTimer() - start_time);
    newWaitMessage = waitMessage;
    if delay_time >= 1000 then
      newWaitMessage = waitMessage .. time_left .. " ms ";
    end
    lsPrintWrapped(10, 50, 0, lsScreenX - 20, scale, scale, 0xd0d0d0ff,
                   newWaitMessage .. waitChars[frame]);

    statusScreen(message, color, nil, scale);
    lsSleep(tick_delay);
    waitFrame = waitFrame + 1;

    if totalSent > 0 then
      progressBar(350)
    end

    if totalSent > 0 then

      if lsButtonText(10, lsScreenY - 30, 0, 120, 0xFFFFFFFF, "Main Menu") then
        promptNumbers();
      end
    end
  end
end

function progressBar(y)
  barWidth = 220;
  barTextX = (barWidth - 22) / 2
  barX = 10;
  percent = round(totalSent / slotsToFulfillQty * 100,2) 
  progress = (barWidth / slotsToFulfillQty) * totalSent

  if progress < barX+6 then
    progress = barX+6
  end

  if math.floor(percent) <= 25 then
    progressBarColor = 0x669c35FF
  elseif math.floor(percent) <= 50 then
    progressBarColor = 0x77bb41FF
  elseif math.floor(percent) <= 65 then
    progressBarColor = 0x96d35fFF
  elseif math.floor(percent) <= 72 then
    progressBarColor = 0xdced41FF
  elseif math.floor(percent) <= 79 then
    progressBarColor = 0xe9ea18FF
  elseif math.floor(percent) <= 83 then
    progressBarColor = 0xf8be0cFF
  elseif math.floor(percent) <= 92 then
    progressBarColor = 0xff7567FF
  elseif math.floor(percent) <= 99 then
    progressBarColor = 0xff301bFF
  else
    progressBarColor = 0xe3c6faFF
  end

  lsPrint(barTextX, y+3.5, 15, 0.60, 0.60, 0x000000ff, percent .. " %");
  lsDrawRect(barX, y, barWidth, y+20, 5,  0x3a88feFF); -- blue shadow
  lsDrawRect(barX+2, y+2, barWidth-2, y+18, 10,  0xf6f6f6FF); -- white bar background
  lsDrawRect(barX+4, y+4, progress, y+16, 15,  progressBarColor); -- colored progress bar
end

function stfu()
  srReadScreen();
  local shout = srFindImage("ShoutX.png");
  if shout then
    srClickMouse(shout[0]+5,shout[1],1);
    lsPlaySound("beepping.wav");
  lsSleep(100)
  end
end
