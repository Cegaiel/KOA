dofile("common.inc");
dofile("settings.inc");
--dofile("constants.inc");


delay = 30
marchslots = 5
tradepct = 16
qty = 1000
totalSent = 0
totalNetSent = 0
slotsSent = 0
dropdown_qty = {};
dropdown_qty_values = {};
dropdown_who_values = {"Ceg A (Simon)", "Ceg B (Dog)", "Ceg C (Skull)", "Cegaiel", "Manual"};
tradetotalqty = 0

testMode = false; -- Only send 1 (testModeQty) resource at a time. Idea for testing out macro without sending a bunch of resources. Set to true to enable testMode.

-- returnMarchReSend Notes:
-- if set to 2 then when your 2nd of 5 or 6 march has returned, it'll start sending more.
-- 3 will wait until the 3rd march returns before sending more troops
-- 4 will wait until the 4th march returns before sending more troops

-- Use 4 to be really safe, 3 is faster, 2 is really fast but be careful -> it might potentially fail to send last march if all marches haven't returned yet)

-- My best advice is if game is running full speed use 4 or 3. If game is slightly lagging, then 2 should be ok.

returnMarchReSend = 4; -- which march (that's returned) to start resending resources again

function doit()
  askForWindow("Trade Resources to Player");

  promptOkay("Don\'t Forget !\n\nWhen trading Equip BOTH:\n\nHERO: Sir Dinadan\n\nARMOR: Production (Head/Feet)", nil, 0.7)

  while 1 do
    totalSent = 0;
    shutdown = nil;
    finished = nil;
    totalNetSent = 0
    slotsSent = 0
    tradetotalqty = 0

    promptNumbers()

    if successfulCastLoc then
      sleepWithStatus(2500,"Preparing to click last known good Castle Position.\n\nDO NOT TOUCH MOUSE!!!", nil, 0.7);
    else
      castleLoc()
    end

    main()

    if finished then
      finish()
    end

  end -- while
end


function castleLoc()
  while not lsShiftHeld() do
    sleepWithStatus(100,"Tap Shift over Castle Location.\n\nPick a location that won\'t be affected by the magnfiying glass when troops are nearby.", nil, 0.7);
  end

  while lsShiftHeld() do
    sleepWithStatus(100,"Release Shift Key", nil, 0.7);
  end

  castlePos = getMousePos()
  srClickMouse(castlePos[0], castlePos[1]) -- Click castle to Open Trade menu for tradeLoc (next)
end


function tradeLoc()  -- Not in use currently
lsSleep(200)
  while not lsShiftHeld() do
    sleepWithStatus(100,"Tap Shift over RIGHT Edge of Slider Box (Near the + button).\n\nMake sure you test by clicking the spot to verify it slides to Max", nil, 0.7);
  end
  while lsShiftHeld() do
    sleepWithStatus(100,"Release Shift Key", nil, 0.7);
  end
  tradePos = getMousePos()
end


function sendButtonLoc()
  while not closeX do
    srReadScreen();
    closeX = srFindImage("redX_BIG2.png")
    sleepWithStatus(100,"Searching for RED X", nil, 0.7);
  end
    srClickMouse(closeX[0], closeX[1])
    sleepWithStatus(500,"Closing Red X", nil, 0.7);

end


function promptNumbers()
	scale = 0.7;
	local z = 0;
	local is_done = nil;
	local value = nil;
	local tradetotalqty = 0
	-- Edit box and text display
	while not is_done do
		-- Put these everywhere to make sure we don't lock up with no easy way to escape!
		checkBreak("disallow pause");
		local y = 10;
		y = y + 30


        lsSetCamera(0,0,lsScreenX*1.3,lsScreenY*1.3);
        dropdown_who_cur_value = readSetting("dropdown_who_cur_value",dropdown_who_cur_value);
        dropdown_who_cur_value = lsDropdown("who", 10, y, 0, 320, dropdown_who_cur_value, dropdown_who_values);
        writeSetting("dropdown_who_cur_value",dropdown_who_cur_value);



--- Note the amounts you can trade is based on using Head/Feet of Production Armor.
-- NEW: We are now also calculating the Trade Bonus while Hero: Sir Dinadan (Bard Guitar, Green) is equipped.



--Ceg A
-- :31 seconds appears on Button to Trade
-- :22 actual seconds appears on timer bar when march is returning
-- :53 TOTAL - Set Delay, below to this value

        if (dropdown_who_cur_value == 1) then
          dropdownValues(450000, 90000, 22500) -- Food/Wood, Iron, Silver - 50% from Dinadin
          marchslots = 5;
          tradepct = 6.5; -- See Trade Fee on the ACTUAL trade window! Don't use value in Trading Post -> Info window

-- Delay is seconds on button to march to the castle PLUS the seconds when march is returning
delay = 53;


--Ceg B
-- :28 seconds appears on Button to Trade
-- :21 actual seconds appears on timer bar when march is returning
-- :49 TOTAL - Set Delay, below to this value

        elseif (dropdown_who_cur_value == 2) then
          dropdownValues(450000, 90000, 22500) -- Food/Wood, Iron, Silver - 50% from Dinadin
          marchslots = 5;
          tradepct = 6.5; -- See Trade Fee on the ACTUAL trade window! Don't use value in Trading Post -> Info window

-- Delay is seconds on button to march to the castle PLUS the seconds when march is returning
delay = 49;


--Ceg C
-- :47 seconds appears on Button to Trade
-- :4 actual seconds appears on timer bar when march is returning
-- :83 TOTAL - Set Delay, below to this value


        elseif (dropdown_who_cur_value == 3) then
          dropdownValues(450000, 90000, 22500) -- Food/Wood, Iron, Silver - 50% from Dinadin
          marchslots = 5;
          tradepct = 6.5; -- See Trade Fee on the ACTUAL trade window! Don't use value in Trading Post -> Info window

-- Delay is seconds on button to march to the castle PLUS the seconds when march is returning
delay = 83;


-- CEGAIEL
        elseif (dropdown_who_cur_value == 4) then
          dropdownValues(450000, 90000, 22500) -- Food/Wood, Iron, Silver - 50% from Dinadin
          marchslots = 5;
          tradepct = 6;




-- MANUAL
        elseif (dropdown_who_cur_value == 5) then
          dropdownValues(435000, 87000, 21750) -- Food/Wood, Iron, Silver - 50% from Dinadin
          marchslots = 5;
        end


        lsSetCamera(0,0,lsScreenX*1.0,lsScreenY*1.0);
        lsPrint(10, y-30, z, scale, scale, 0xFFFFFFff, "Who is Trading:");
        manualDelay = readSetting("manualDelay",manualDelay);
        manualDelay = CheckBox(200, y-30, 0, 0xFFFFFFff, " Manual", manualDelay, 0.7, 0.7);
        writeSetting("manualDelay",manualDelay);

        if (dropdown_who_cur_value == 4) then
          manualDelay = 1;
        end


        y = y + 25;

        if dropdown_who_cur_value < 5 then
          lsPrint(10, y, z, scale, scale, 0xFFFFFFff, "What are you Trading?");
          y = y + 50;
          lsSetCamera(0,0,lsScreenX*1.3,lsScreenY*1.3);
          dropdown_qty_cur_value = readSetting("dropdown_qty_cur_value",dropdown_qty_cur_value);
          dropdown_qty_cur_value = lsDropdown("qty", 10, y, 0, 320, dropdown_qty_cur_value, dropdown_qty_values);
          writeSetting("dropdown_qty_cur_value",dropdown_qty_cur_value);
          lsSetCamera(0,0,lsScreenX*1.0,lsScreenY*1.0);
          y = y + 10;


        else

          lsPrint(5, y, z, scale, scale, 0xFFFFFFff, "Max Num you can Trade:");

          qty = readSetting("qty",qty);
          is_done, qty = lsEditBox("qty",
			10, y+20, z, 120, 30, scale, scale,
			0x000000ff, qty);
              if not tonumber(qty) then
			is_done = nil;
			lsPrint(5, y+18, z+10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
			qty = 1;
              else
		       writeSetting("qty",tonumber(qty));
              end

          y = y + 60

        end



        lsPrint(10, y, z, scale, scale, 0xFFFFFFff, "Trade Total Qty: ");
        lsPrint(140, y+25, z, scale, scale, 0xFFFFFFff, addComma(tradetotalqty));

        tradetotalqty = readSetting("tradetotalqty",tradetotalqty);
        is_done, tradetotalqty = lsEditBox("tradetotalqty",
			10, y+20, z, 120, 30, scale, scale,
			0x000000ff, tradetotalqty);

        if not tonumber(tradetotalqty) then
          is_done = nil;
          lsPrint(5, y+18, z+10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
          tradetotalqty = 0;
        else
          writeSetting("tradetotalqty",tonumber(tradetotalqty));
        end



        if (dropdown_who_cur_value == 5) or manualDelay then
          delay = readSetting("delay",delay);
          y = y + 60
          lsPrint(10, y, z, scale, scale, 0xFFFFFFff, "Seconds to wait for next Trade:");
          lsPrint(90, y+24, z, scale, scale, 0xFFFFFFff, "Roughly (March Time x 2) - 2");


          is_done, delay = lsEditBox("delay",
			10, y+20, z, 70, 30, scale, scale,
			0x000000ff, delay);
          if not tonumber(delay) then
            is_done = nil;
            lsPrint(5, y+18, z+10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
            delay = 1;
          else
            writeSetting("delay",tonumber(delay));
          end
        end

        lsPrint(120, 11, z, scale, scale, 0xFFFFFFff, "(Delay: " .. delay .. ")");

        if (dropdown_who_cur_value == 5)  then
          y = y + 60;
          lsPrint(10, y, z, scale, scale, 0xFFFFFFff, "Trade %");
          tradepct = readSetting("tradepct",tradepct);
          is_done, tradepct = lsEditBox("tradepct",
			10, y+20, z, 40, 30, scale, scale,
			0x000000ff, tradepct);
          if not tonumber(tradepct) then
            is_done = nil;
            lsPrint(5, y+18, z+10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
            tradepct = 1;
          else
            writeSetting("tradepct",tonumber(tradepct));
          end
        end


        slotsToFulfill = math.floor(tradetotalqty / qty)
        slotsToFulfillQty = math.floor(slotsToFulfill * qty)

        tradeMult = tradepct * .01
        qtyAfterFee = math.floor(slotsToFulfillQty * tradeMult)
        transferPerSlot = math.floor(qty * tradeMult)
        transferPerMarch = math.floor(qty * tradeMult * marchslots)

        actualTransferPerSlot = math.floor(qty - transferPerSlot)
        actualTransferPerMarch = math.floor(actualTransferPerSlot * marchslots)

        loopCount = math.ceil((slotsToFulfillQty / qty) / marchslots)




-- ETA is using delay (ie 45s), which only counts the 1st cart/march.
-- It takes about 8-9 seconds to finish sending 2nd - 4th cart/march.
-- extraDelay is only a visual thing for ETA "Remaining" time on screen.

        extraDelay = 9;

        eta = convertTime((delay + extraDelay) * loopCount * 1000)
        etaRaw = (delay+extraDelay) * loopCount * 1000
        y = y + 55;

        if tonumber(tradetotalqty) > 0 then
          if lsButtonText(10, lsScreenY - 30, z, 100, 0xFFFFFFff, "Next") then
            is_done = 1;
          end
        end

        if (dropdown_who_cur_value == 5) or manualDelay then
          y = y + 30
          lsPrintWrapped(10, y-30, z, lsScreenX - 20, scale, scale, 0xD0D0D0ff, "Ceg -> A: 56? |  Ceg -> B: 53 |  Ceg -> C: 63\n------------------------------------------");
        end



        if slotsToFulfill > 0 then

		lsPrintWrapped(10, y, z+10, lsScreenX - 20, 0.7, 0.7, 0xD0D0D0ff, "Trade Total Qty: " .. addComma(slotsToFulfillQty) .. "\nLoss from Fee:   -" .. addComma(qtyAfterFee) .. "\n------------------------------------------\nPlayer Receives: " .. addComma(math.floor(slotsToFulfillQty - qtyAfterFee)) .. "\n\nTrade Fee: " .. tradepct .. "% : " .. addComma(transferPerSlot) .. "  < x" .. marchslots .. ": " .. addComma(transferPerMarch) .. " >\n\nGross Transfer: " .. addComma(qty) .. "  < x" .. marchslots .. ": " .. addComma(math.floor(qty*marchslots)) ..        " >\n\nNet Transfer: " .. addComma(actualTransferPerSlot) .. "  < x" .. marchslots .. ": " .. addComma(actualTransferPerMarch) .. " >\n\nMarches to Complete x" .. marchslots .. ": " .. loopCount .. "  < " .. round((slotsToFulfillQty / qty) / marchslots,2) .. " >\n\nMarch Slots to Complete: " .. slotsToFulfill .. "  < " .. addComma(slotsToFulfillQty) ..      " >\n\nETA:  " .. eta);


        else
-- This won't actually transfer anything. Just changes the first 3 lines (after Trade Total Qty BOX, to show what trade losses would be for such a small number

		lsPrintWrapped(10, y, z+10, lsScreenX - 20, 0.7, 0.7, 0xD0D0D0ff, "Trade Total Qty: " .. addComma(tradetotalqty) .. "\nLoss from Fee:   -" .. addComma(math.floor(tradetotalqty*tradeMult)) .. "\n\nPlayer Receives: " .. addComma(math.floor(tradetotalqty - (tradetotalqty*tradeMult)    )) .. "\n\nTrade Fee: " .. tradepct .. "% : " .. addComma(transferPerSlot) .. "  < x" .. marchslots .. ": " .. addComma(transferPerMarch) .. " >\n\nGross Transfer: " .. addComma(qty) .. "  < x" .. marchslots .. ": " .. addComma(math.floor(qty*marchslots)) ..        " >\n\nNet Transfer: " .. addComma(actualTransferPerSlot) .. "  < x" .. marchslots .. ": " .. addComma(actualTransferPerMarch) .. " >\n\nMarches to Complete x" .. marchslots .. ": " .. loopCount .. "  < " .. round((slotsToFulfillQty / qty) / marchslots,2) .. " >\n\nMarch Slots to Complete: " .. slotsToFulfill .. "  < " .. addComma(slotsToFulfillQty) ..      " >\n\nETA:  " .. eta);

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


function tradeButton()
  trade = nil;
  tradeWait = 0;
  maxTradeWait = 4;
  srClickMouse(castlePos[0], castlePos[1])


  while not trade and not shutdown do
    srReadScreen();
    trade = srFindImage("trade.png", 12000) -- last number is tolerance. If the image isn't being found or clicked, try raising that value by 1000 at a time until it finds it.
    if not trade then
      trade = srFindImage("trade2.png", 12000) -- Try another image if we got Peace Shield activated.
    end

    tradeWait = tradeWait + 1
    sleepWithStatus(200, "Waiting for Trade Button to Appear", nil, 0.7, "Waiting " .. tradeWait .. "/" .. maxTradeWait .. " ticks to ReClick Castle");
      if tradeWait >= maxTradeWait then  -- Wait 1.5s and try to click castle again, using sleepWithStatus 100 above = 15
--    lsSleep(200)

        srClickMouse(castlePos[0], castlePos[1])
        tradeWait = 0

        if not firstTrade then
          shutdown = 1
        end

      end
  end -- while not trade



  if trade then
    srClickMouse(trade[0], trade[1])
    firstTrade = 1; -- This denotes we actually got at least one transfer going and not stuck on the initial Trade Not Found when macro starts (the screen needs moved slightly).
    lsSleep(200)
  end
end


function tradeButtonPlus()
        tradePlus = nil;
        tradeWait = 0;
        maxTradeWait = 4;

        while not tradePlus do
          srReadScreen();
          tradePlus = srFindImage("tradePlus.png", 8000)
          sleepWithStatus(200, "Waiting for Trade Window to Open", nil, 0.7);
          tradeWait = tradeWait + 1

          if tradeWait >= maxTradeWait then  -- Wait 1.5s and try to click castle again, using sleepWithStatus 100 above = 15
            break;
          end

        end --while
        -- Click the end of Slider Bar for Max Resources


      -- testMode is when we might want to do some tests on modifying the macro but we just want to send 1 resource at a time so we don't run out too fast
      -- Simply click the + button one time instead of the slider bar.
      if testMode then
	  xSliderOffset = 0;
      else
	  xSliderOffset = 40;
      end


        if product == "Food" then
          srClickMouse(tradePlus[0]-xSliderOffset, tradePlus[1]+7)
        elseif product == "Wood" then
          srClickMouse(tradePlus[0]-xSliderOffset, tradePlus[1]+136)
        elseif product == "Iron" then
          srClickMouse(tradePlus[0]-xSliderOffset, tradePlus[1]+261)
        elseif product == "Silver" then
          srClickMouse(tradePlus[0]-xSliderOffset, tradePlus[1]+385)
        end

        srClickMouse(965, 870) -- Send Button
        lsSleep(200)
end


function main()

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
          tradeButton()

          if shutdown then
            break; -- If we didn't find a trade button then abort and go back to main menu
          end 

          tradeButtonPlus()
          sleepWithStatus(100, "Sending March " .. i .. " of " .. marchslots, nil, 0.7)
          totalSent = totalSent + qty
          totalNetSent = totalNetSent + actualTransferPerSlot
          totalRemaining = math.floor(slotsToFulfillQty - totalSent)
          slotsSent = slotsSent + 1
	    lsEditBoxSetText("tradetotalqty", tonumber(totalRemaining));
	    writeSetting("tradetotalqty", tonumber(totalRemaining));
        end

        successfulCastLoc = 1; --zz we got passed tradeButton() and tradeButtonPlus(), must be good?

	  if slotsSent == slotsToFulfill then
          finished = 1
        end

	  if i == returnMarchReSend then -- Start Time on this march, instead of last march, below
      	    marchTimer = lsGetTimer()
	  end

      end -- for i 

      --Note this now starts timer after sending last cart/march, NOT FIRST, so that misclicks (repeat Trade Button) won't break the timers
     -- marchTimer = lsGetTimer()

      while not shutdown do

	  marchTimerRemainingRaw = (lsGetTimer() - marchTimer) /1000;
	  marchTimerRemaining = math.floor(marchTimerRemainingRaw);
	  marchTimerRemainingReverseRaw = delay - marchTimerRemainingRaw; --zz
	  marchTimerRemainingReverse = math.floor(marchTimerRemainingReverseRaw);

	  if tonumber(marchTimerRemaining) >= tonumber(delay) then
	    break;
	  else

	    waitingMessage = "Waiting " .. marchTimerRemaining .. " (" .. marchTimerRemainingReverse .. ") of " .. math.floor(delay) .. "s for this March"
	    --waitingMessage = "Waiting " .. marchTimerRemaining .. " of " .. math.floor(delay) .. "s for this March"
	    finishedMessage = "FINISHED"

	    mainMessage = "Sent " .. slotsSent .. " of " .. slotsToFulfill .. " March Slots\nPasses: " .. j .. " of " .. loopCount .. "  < " .. loopCount - j .. " Remaining >\n\nTotal Gross Sent: " .. addComma(math.floor(totalSent)) .. " of " .. addComma(slotsToFulfillQty) .. "\nTotal Net Sent:    " .. addComma(math.floor(totalNetSent)) .. " of " .. addComma(math.floor(slotsToFulfillQty - qtyAfterFee)) ..  "\n\nN/G Per March: " .. addComma(actualTransferPerMarch) .. " / " .. addComma(math.floor(qty*marchslots)) .. "\nN/G Remaining: " .. addComma(math.floor((slotsToFulfillQty - qtyAfterFee) - totalNetSent)) .. " / " .. addComma(totalRemaining) .. "\n\n" .. eta .."  |  ETA   ( " .. product .. " )\n" .. getElapsedTime(beginTime) .. "  |  Elapsed\n" .. convertTime(etaRaw - (lsGetTimer()-beginTime)) .. "  |  Remaining\n\n" .. convertTime(marchTimerRemainingReverseRaw*1000) ..  "  | Remaining (This March)"


	    sleepWithStatus(200, mainMessage, nil, 0.7, waitingMessage)
--	    stfu()
	  end -- if tonumber(marchTimeRemaining)

	end  -- while

    end --for j

    if shutdown then -- We didn't get a Trade button on first try, so abort, start Over
      shutdown = nil;
      lsPlaySound("error.wav")
      castleLoc()
      main()
    end

end


function finish()
  soundCounter = 0;
  while 1 do
    statusScreen(mainMessage, nil, 0.7);
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
      progressBar(310)
    end

    if totalSent > 0 then

      if lsButtonText(10, lsScreenY - 30, 0, 120, 0xFFFFFFFF, "Main Menu") then
        totalSent = 0;
        shutdown = nil;
        finished = nil;
        totalNetSent = 0
        slotsSent = 0
        tradetotalqty = 0
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

function dropdownValues(fw, i, s)
  dropdown_qty = {fw, i, s};
  dropdown_qty_values = {"Food (" .. addComma(dropdown_qty[1]) .. ")", "Wood (" .. addComma(dropdown_qty[1]) .. ")", "Iron (" .. addComma(dropdown_qty[2]) .. ")", "Silver (" .. addComma(dropdown_qty[3]) .. ")"};

        if (dropdown_qty_cur_value == 1) then
          qty = dropdown_qty[1]
          product = "Food"
        elseif (dropdown_qty_cur_value == 2) then
          qty = dropdown_qty[1]
          product = "Wood"
        elseif (dropdown_qty_cur_value == 3) then
          qty = dropdown_qty[2]
          product = "Iron"
        elseif (dropdown_qty_cur_value == 4) then
          qty = dropdown_qty[3]
          product = "Silver"
        end

        if testMode then
          qty = 1;
        end
end
