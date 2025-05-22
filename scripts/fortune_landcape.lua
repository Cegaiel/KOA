dofile("common.inc");
dofile("constants.inc");
dofile("settings.inc");


Tolerance = 5000;
diceDelay = 4200;
moreFeedback = false;

function doit()

  askForWindow("Fortune Landscape: Clicks Fate Cards and attempts to change to On the House, Major Haul and optionally 777.\n\nYou will Tap Shift key each time to change cards and roll dice.\n\nBe sure macro works well first before trying Full Auto Mode!\n\nPut Automato on far left side of screen so it doesn't cover large fate card images (middle) or small fate card or dice on bottom right.");  

  checkWindowSize();

  config();

  if doAuto then
    sleepWithStatus(2500,"Preparing to start Full Auto Mode!\n\nHands off the mouse!", nil, 0.7);
  end

  while 1 do
    main()
  end
end


function main()

if doAuto then
  checkBreak();
else
  while not lsShiftHeld() do
    sleepWithStatus(100,"Tap Shift to Change Fate Cards.", nil, 0.7);
  end

  while lsShiftHeld() do
    sleepWithStatus(100,"Release Shift Key", nil, 0.7);
  end
end


  srReadScreen();
  local fateCard = srFindImage("fortune/fate_card.png", Tolerance);
  local fateCard2 = srFindImage("fortune/on_the_house_small.png", Tolerance);
  local fateCard3 = srFindImage("fortune/777_small.png", Tolerance);
  local fateCard4 = srFindImage("fortune/major_haul_small.png", Tolerance);
  local fateDetails = srFindImage("fortune/fate_card_details.png", Tolerance);
  local confirm = srFindImage("fortune/confirm.png", Tolerance);

  if confirm then
    srClickMouse(confirm[0], confirm[1])
    sleepWithStatus(500,"Found/Clicked Confirm button to Clear screen", nil, 0.7);
  end

  if fateCard then -- Found Generic/Brown card, so change it
    srClickMouse(fateCard[0], fateCard[1])
    if moreFeedback then
      sleepWithStatus(500,"Found/Clicked Generic/Brown Fate Card", nil, 0.7);
    end

    changeFateCards();

    if rollDice() then
      sleepWithStatus(diceDelay,"Rolling Dice; Waiting on Movement ...", nil, 0.7);
      -- Check if rewards window is open and close it
      checkRewardsConfirmButton();
    else
      sleepWithStatus(diceDelay/2,"Dice not Found!", nil, 0.7);
    end


  elseif fateCard2 or (fateCard3 and doSeven) or fateCard4 then -- Found an existing desirable card; keep it!
    if moreFeedback then
      sleepWithStatus(500,"Desirable card ALREADY LOADED", nil, 0.7);
    end

    if rollDice() then
      sleepWithStatus(diceDelay,"Rolling Dice; Waiting on Movement ...", nil, 0.7);
      -- Check if rewards window is open and close it
      checkRewardsConfirmButton();
    else
      sleepWithStatus(diceDelay/2,"Dice not Found!", nil, 0.7);
    end


  elseif fateDetails then
    if moreFeedback then
      sleepWithStatus(500,"Undesirable card seems loaded, CHANGE IT!", nil, 0.7);
    end
    srClickMouse(fateDetails[0]+100, fateDetails[1]-50)

    changeFateCards();

    if rollDice() then
      sleepWithStatus(diceDelay,"Rolling Dice; Waiting on Movement ...", nil, 0.7);
      -- Check if rewards window is open and close it
      checkRewardsConfirmButton();
    else
      sleepWithStatus(diceDelay/2,"Dice not Found!", nil, 0.7);
    end


  else
     sleepWithStatus(1500,"Did not find the Brown/Generic Fate card or desirable fate card !\n\nNothing to Do ...", nil, 0.7);
  end -- if fateCard

end


function changeCard()
  srReadScreen();
  local changeCard = srFindImage("fortune/change_card.png", Tolerance);
  if changeCard then
    srClickMouse(changeCard[0], changeCard[1])
    sleepWithStatus(500,"Clicked Change Card", nil, 0.7);
    return true;
   end
  return false;
end


function rollDice()
  srReadScreen();
  local dice = srFindImage("fortune/fate_card_details.png", Tolerance);
  if dice then
    srClickMouse(dice[0]-80, dice[1]+50)
    return true;
  end
  return false;
end

function changeFateCards()
    while 1 do
      sleepWithStatus(500,"Searching for desirable cards.", nil, 0.7);

      if changeCard() then
        srReadScreen();
        local majorHaul = srFindImage("fortune/major_haul.png", Tolerance);
        local onHouse = srFindImage("fortune/on_the_house.png", Tolerance);
        local seven = srFindImage("fortune/777.png", Tolerance);

        if majorHaul or onHouse or (doSeven and seven) then
          sleepWithStatus(500,"Found Desirable Card; KEEP !", nil, 0.7);
          ESCKey();
          break;
        end
      end -- if changeCard
    end -- while
end


function ESCKey()
  --Hit Esc key
  srKeyDown(VK_ESCAPE);
  lsSleep(100);
  srKeyUp(VK_ESCAPE);
  --lsSleep(100);
  sleepWithStatus(100,"Escape Key used", nil, 0.7);
end


function checkRewardsConfirmButton()
  srReadScreen();
  local fateDetails = srFindImage("fortune/fate_card_details.png", Tolerance);
  local confirm = srFindImage("fortune/confirm.png", Tolerance);

  if confirm then
    srClickMouse(confirm[0], confirm[1])
    sleepWithStatus(500,"Found/Clicked Confirm button to Clear screen", nil, 0.7);

    -- Check if Rewards window is still open behind the recently close Confirm button
    srReadScreen();
    local fateDetails = srFindImage("fortune/fate_card_details.png", Tolerance);
    if not fateDetails then ESCKey() end

  elseif not fateDetails then
    ESCKey();
  end
end


function config()
  local scale = 0.8;
  local z = 0;
  local y = 20;
  local is_done = nil;
  local defaultColor = 0xffffffFF;
  local highlightColor = 0xfff76bFF;

  while not is_done do
    checkBreak("disallow pause");

    if doSeven then
      doSevenColor = highlightColor;
    else
      doSevenColor = defaultColor;
    end

    if doAuto then
      doAutoColor = highlightColor;
    else
      doAutoColor = defaultColor;
    end


    doSeven = readSetting("doSeven",doSeven);
    doSeven = CheckBox(10, y, 10, doSevenColor, "  Keep/Use 777 Cards?", doSeven, scale, scale);
    writeSetting("doSeven",doSeven);

    doAuto = readSetting("doAuto",doAuto);
    doAuto = CheckBox(10, y+50, 10, doAutoColor, "  Full Auto Mode?", doAuto, scale, scale);
    writeSetting("doAuto",doAuto);



    if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff, "End script") then
      error "Clicked End Script button";
    end
	
    if lsButtonText(10, lsScreenY - 30, z, 100, 0xFFFFFFff, "Next") then
      is_done = 1;
    end

    lsDoFrame();
    lsSleep(10); -- Sleep just so we don't eat up all the CPU for no reason
  end
end
