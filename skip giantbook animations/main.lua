local mod = RegisterMod('Skip Giantbook Animations', 1)

if REPENTOGON then
  function mod:onItemOverlayRender(giantbook)
    -- SLEEP_NIGHTMARE can already be skipped, plus if you skip at the wrong time it can play twice
    if giantbook == Giantbook.SLEEP_NIGHTMARE then -- DOGMA
      return
    end
    
    local sprite = ItemOverlay.GetSprite()
    --print(giantbook, sprite:IsPlaying(), sprite:GetFilename(), sprite:GetAnimation(), sprite:GetFrame(), sprite.PlaybackSpeed)
    if sprite:IsPlaying() then
      if sprite:GetFrame() > 0 and mod:isSkipTriggered() then
        -- PlaybackSpeed seems to trigger necessary events
        -- unlike SetLastFrame which can skip events
        local currentFrame = sprite:GetFrame()
        sprite:SetLastFrame()
        local lastFrame = sprite:GetFrame()
        local diff = lastFrame - currentFrame
        sprite:SetFrame(currentFrame)
        if diff > 1 then
          -- be careful: setting high values like 1000 can cause events to be triggered twice
          sprite.PlaybackSpeed = diff
        end
      end
    else -- IsFinished
      sprite.PlaybackSpeed = 1 -- reset
    end
  end
  
  -- ItemOverlay.GetPlayer doesn't seem to be reliable
  function mod:isSkipTriggered()
    local keyboard = 0
    if Input.IsActionTriggered(ButtonAction.ACTION_MENUCONFIRM, keyboard) or Input.IsActionTriggered(ButtonAction.ACTION_DROP, keyboard) then
      return true
    end
    
    for _, player in ipairs(PlayerManager.GetPlayers()) do
      if player.ControllerIndex > keyboard then
        if Input.IsActionTriggered(ButtonAction.ACTION_MENUCONFIRM, player.ControllerIndex) or Input.IsActionTriggered(ButtonAction.ACTION_DROP, player.ControllerIndex) then
          return true
        end
      end
    end
    
    return false
  end
  
  mod:AddCallback(ModCallbacks.MC_POST_ITEM_OVERLAY_RENDER, mod.onItemOverlayRender)
end