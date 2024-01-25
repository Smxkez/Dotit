-- DotIt by NoSmxke
-- This addon provides advanced dot management for warlocks in World of Warcraft.
DotIt = CreateFrame("Frame", nil, UIParent)

DotIt.Default = {
    ["Curse of Weakness"] = false,
    ["Curse of Tongues"] = false,
    ["Curse of Shadow"] = false,
    ["Curse of the Elements"] = false,
    ["Curse of Recklessness"] = false,
    ["Curse of Agony"] = false,
    ["Corruption"] = false,
    ["Siphon Life"] = false,
    ["Immolate"] = false
}

DotIt.Settings = DotIt.Default
DotIt.ImmunityTracker = {
    ["Immolate"] = false
}

function DotIt:OnEvent(event, arg1)
    if event == "ADDON_LOADED" and arg1 == "DotIt" then
        DEFAULT_CHAT_FRAME:AddMessage("DotIt: loaded")
        DotIt:UnregisterEvent("ADDON_LOADED")
        DotIt_Settings = DotIt_Settings or DotIt.Default
        DotIt.Settings = DotIt_Settings
        DotIt.Settings["IsCasting"] = false

        SLASH_DOTIT1 = "/dotit"
        SlashCmdList["DOTIT"] = function(msg)
            if msg == "settings" then
                if not DotIt.settingsMenu then
                    DotIt:CreateSettingsMenu()
                end
                if DotIt.settingsMenu:IsVisible() then
                    DotIt.settingsMenu:Hide()
                else
                    DotIt.settingsMenu:Show()
                end
            else
                DotIt:Cast()
            end
        end
    elseif event == "PLAYER_TARGET_CHANGED" then
        DotIt:ResetTimers()
    elseif event == "SPELLCAST_START" then
        DotIt.Settings["IsCasting"] = true
    elseif event == "SPELLCAST_INTERRUPTED" or event == "SPELLCAST_FAILED" then
        DotIt.Settings["IsCasting"] = false
    elseif event == "SPELLCAST_STOP" then
        DotIt.Settings["IsCasting"] = false
    end
end

DotIt:RegisterEvent("ADDON_LOADED")
DotIt:RegisterEvent("PLAYER_TARGET_CHANGED")
DotIt:RegisterEvent("SPELLCAST_START")
DotIt:RegisterEvent("SPELLCAST_INTERRUPTED")
DotIt:RegisterEvent("SPELLCAST_FAILED")
DotIt:RegisterEvent("SPELLCAST_STOP")

function DotIt:ResetTimers()
    for spell, value in pairs(DotIt.Settings) do
        if value ~= false then
            DotIt.Settings[spell] = 0
        end
    end
end

function DotIt:CreateSettingsMenu()
    if DotIt.settingsMenu then
        DotIt.settingsMenu:Show()
        return
    end

    DotIt.settingsMenu = CreateFrame("Frame", "DotItSettingsMenu", UIParent)
    DotIt.settingsMenu:SetWidth(225)
    DotIt.settingsMenu:SetHeight(300)
    DotIt.settingsMenu:SetPoint("CENTER", UIParent, "CENTER")
    DotIt.settingsMenu:SetMovable(true)
    DotIt.settingsMenu:EnableMouse(true)
    DotIt.settingsMenu:RegisterForDrag("LeftButton")
    DotIt.settingsMenu:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 16,
        insets = {
            left = 4,
            right = 4,
            top = 4,
            bottom = 4
        }
    })
    DotIt.settingsMenu:SetBackdropColor(0, 0, 0, 1)
    DotIt.settingsMenu:Hide()

    local title = DotIt.settingsMenu:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    title:SetPoint("TOP", DotIt.settingsMenu, "TOP", 0, -10)
    title:SetText("DotIt Settings")

    local yOffset = -30

    -- Checkbox 1: Corruption
    local checkbox1 = CreateFrame("CheckButton", "DotItCheckbox1", DotIt.settingsMenu, "UICheckButtonTemplate")
    checkbox1:SetPoint("TOPLEFT", 20, yOffset)
    checkbox1.text = checkbox1:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    checkbox1.text:SetPoint("LEFT", checkbox1, "RIGHT", 5, 0)
    checkbox1.text:SetText("Corruption")
    checkbox1:SetChecked(DotIt.Settings["Corruption"])
    checkbox1:SetScript("OnClick", function()
        DotIt.Settings["Corruption"] = checkbox1:GetChecked()
    end)

    yOffset = yOffset - 25

    -- Checkbox 2: Siphon Life
    local checkbox2 = CreateFrame("CheckButton", "DotItCheckbox2", DotIt.settingsMenu, "UICheckButtonTemplate")
    checkbox2:SetPoint("TOPLEFT", 20, yOffset)
    checkbox2.text = checkbox2:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    checkbox2.text:SetPoint("LEFT", checkbox2, "RIGHT", 5, 0)
    checkbox2.text:SetText("Siphon Life")
    checkbox2:SetChecked(DotIt.Settings["Siphon Life"])
    checkbox2:SetScript("OnClick", function()
        DotIt.Settings["Siphon Life"] = checkbox2:GetChecked()
    end)

    -- Checkbox 3: Immolate
    yOffset = yOffset - 25
    local checkbox3 = CreateFrame("CheckButton", "DotItCheckbox3", DotIt.settingsMenu, "UICheckButtonTemplate")
    checkbox3:SetPoint("TOPLEFT", 20, yOffset)
    checkbox3.text = checkbox3:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    checkbox3.text:SetPoint("LEFT", checkbox3, "RIGHT", 5, 0)
    checkbox3.text:SetText("Immolate")
    checkbox3:SetChecked(DotIt.Settings["Immolate"])
    checkbox3:SetScript("OnClick", function()
        DotIt.Settings["Immolate"] = checkbox3:GetChecked()
    end)

    -- Checkbox 4: Curse of Agony
    yOffset = yOffset - 25
    local checkbox4 = CreateFrame("CheckButton", "DotItCheckbox4", DotIt.settingsMenu, "UICheckButtonTemplate")
    checkbox4:SetPoint("TOPLEFT", 20, yOffset)
    checkbox4.text = checkbox4:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    checkbox4.text:SetPoint("LEFT", checkbox4, "RIGHT", 5, 0)
    checkbox4.text:SetText("Curse of Agony")
    checkbox4:SetChecked(DotIt.Settings["Curse of Agony"])
    checkbox4:SetScript("OnClick", function()
        DotIt.Settings["Curse of Agony"] = checkbox4:GetChecked()
    end)

    -- Checkbox 5: Curse of Recklessness
    yOffset = yOffset - 25
    local checkbox5 = CreateFrame("CheckButton", "DotItCheckbox5", DotIt.settingsMenu, "UICheckButtonTemplate")
    checkbox5:SetPoint("TOPLEFT", 20, yOffset)
    checkbox5.text = checkbox5:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    checkbox5.text:SetPoint("LEFT", checkbox5, "RIGHT", 5, 0)
    checkbox5.text:SetText("Curse of Recklessness")
    checkbox5:SetChecked(DotIt.Settings["Curse of Recklessness"])
    checkbox5:SetScript("OnClick", function()
        DotIt.Settings["Curse of Recklessness"] = checkbox5:GetChecked()
    end)

    -- Checkbox 6: Curse of the Elements
    yOffset = yOffset - 25
    local checkbox6 = CreateFrame("CheckButton", "DotItCheckbox6", DotIt.settingsMenu, "UICheckButtonTemplate")
    checkbox6:SetPoint("TOPLEFT", 20, yOffset)
    checkbox6.text = checkbox6:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    checkbox6.text:SetPoint("LEFT", checkbox6, "RIGHT", 5, 0)
    checkbox6.text:SetText("Curse of the Elements")
    checkbox6:SetChecked(DotIt.Settings["Curse of the Elements"])
    checkbox6:SetScript("OnClick", function()
        DotIt.Settings["Curse of the Elements"] = checkbox6:GetChecked()
    end)

    -- Checkbox 7: Curse of Shadow
    yOffset = yOffset - 25
    local checkbox7 = CreateFrame("CheckButton", "DotItCheckbox7", DotIt.settingsMenu, "UICheckButtonTemplate")
    checkbox7:SetPoint("TOPLEFT", 20, yOffset)
    checkbox7.text = checkbox7:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    checkbox7.text:SetPoint("LEFT", checkbox7, "RIGHT", 5, 0)
    checkbox7.text:SetText("Curse of Shadow")
    checkbox7:SetChecked(DotIt.Settings["Curse of Shadow"])
    checkbox7:SetScript("OnClick", function()
        DotIt.Settings["Curse of Shadow"] = checkbox7:GetChecked()
    end)

    -- Checkbox 8: Curse of Tongues
    yOffset = yOffset - 25
    local checkbox8 = CreateFrame("CheckButton", "DotItCheckbox8", DotIt.settingsMenu, "UICheckButtonTemplate")
    checkbox8:SetPoint("TOPLEFT", 20, yOffset)
    checkbox8.text = checkbox8:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    checkbox8.text:SetPoint("LEFT", checkbox8, "RIGHT", 5, 0)
    checkbox8.text:SetText("Curse of Tongues")
    checkbox8:SetChecked(DotIt.Settings["Curse of Tongues"])
    checkbox8:SetScript("OnClick", function()
        DotIt.Settings["Curse of Tongues"] = checkbox8:GetChecked()
    end)

    -- Checkbox 9: Curse of Weakness
    yOffset = yOffset - 25
    local checkbox9 = CreateFrame("CheckButton", "DotItCheckbox9", DotIt.settingsMenu, "UICheckButtonTemplate")
    checkbox9:SetPoint("TOPLEFT", 20, yOffset)
    checkbox9.text = checkbox9:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    checkbox9.text:SetPoint("LEFT", checkbox9, "RIGHT", 5, 0)
    checkbox9.text:SetText("Curse of Weakness")
    checkbox9:SetChecked(DotIt.Settings["Curse of Weakness"])
    checkbox9:SetScript("OnClick", function()
        DotIt.Settings["Curse of Weakness"] = checkbox9:GetChecked()
    end)

    local closeButton = CreateFrame("Button", "DotItSettingsMenuCloseButton", DotIt.settingsMenu, "UIPanelCloseButton")
    closeButton:SetPoint("TOPRIGHT", -10, -10)
    closeButton:SetScript("OnClick", function()
        DotIt.settingsMenu:Hide()
    end)

    DotIt.settingsMenu:SetScript("OnMouseDown", function(DotIt, button)
        if button == "LeftButton" then
            DotIt:StartMoving()
        end
    end)
    DotIt.settingsMenu:SetScript("OnMouseUp", function(DotIt, button)
        if button == "LeftButton" then
            DotIt:StopMovingOrSizing()
        end
    end)

    DEFAULT_CHAT_FRAME:AddMessage("DotIt settings menu created.")
end

function DotIt:Cast()
    local currentTime = GetTime()

    -- Curse of Agony
    if DotIt.Settings["Curse of Agony"] and
        (DotIt.Settings["Curse of Agony"] == 0 or (currentTime - DotIt.Settings["Curse of Agony"] > 24)) and
        not DotIt:GetSpellCooldown("Curse of Agony") and not DotIt.Settings["IsCasting"] then
        CastSpellByName("Curse of Agony")
        DotIt.Settings["Curse of Agony"] = currentTime
        return
    end

    -- Curse of Recklessness
    if DotIt.Settings["Curse of Recklessness"] and
        (DotIt.Settings["Curse of Recklessness"] == 0 or (currentTime - DotIt.Settings["Curse of Recklessness"] > 24)) and
        not DotIt:GetSpellCooldown("Curse of Recklessness") and not DotIt.Settings["IsCasting"] then
        CastSpellByName("Curse of Recklessness")
        DotIt.Settings["Curse of Recklessness"] = currentTime
        return
    end

    -- Curse of Curse of the Elements
    if DotIt.Settings["Curse of the Elements"] and
        (DotIt.Settings["Curse of the Elements"] == 0 or (currentTime - DotIt.Settings["Curse of the Elements"] > 24)) and
        not DotIt:GetSpellCooldown("Curse of the Elements") and not DotIt.Settings["IsCasting"] then
        CastSpellByName("Curse of the Elements")
        DotIt.Settings["Curse of the Elements"] = currentTime
        return
    end

    -- Curse of Shadow
    if DotIt.Settings["Curse of Shadow"] and
        (DotIt.Settings["Curse of Shadow"] == 0 or (currentTime - DotIt.Settings["Curse of Shadow"] > 24)) and
        not DotIt:GetSpellCooldown("Curse of Shadow") and not DotIt.Settings["IsCasting"] then
        CastSpellByName("Curse of Shadow")
        DotIt.Settings["Curse of Shadow"] = currentTime
        return
    end

    -- Curse of Tongues
    if DotIt.Settings["Curse of Tongues"] and
        (DotIt.Settings["Curse of Tongues"] == 0 or (currentTime - DotIt.Settings["Curse of Tongues"] > 24)) and
        not DotIt:GetSpellCooldown("Curse of Tongues") and not DotIt.Settings["IsCasting"] then
        CastSpellByName("Curse of Tongues")
        DotIt.Settings["Curse of Tongues"] = currentTime
        return
    end

    -- Curse of Weakness
    if DotIt.Settings["Curse of Weakness"] and
        (DotIt.Settings["Curse of Weakness"] == 0 or (currentTime - DotIt.Settings["Curse of Weakness"] > 24)) and
        not DotIt:GetSpellCooldown("Curse of Weakness") and not DotIt.Settings["IsCasting"] then
        CastSpellByName("Curse of Weakness")
        DotIt.Settings["Curse of Weakness"] = currentTime
        return
    end

    -- Corruption
    if DotIt.Settings["Corruption"] and
        (DotIt.Settings["Corruption"] == 0 or (currentTime - DotIt.Settings["Corruption"] > 18)) and
        not DotIt:GetSpellCooldown("Corruption") and not DotIt.Settings["IsCasting"] then
        CastSpellByName("Corruption")
        DotIt.Settings["Corruption"] = currentTime
        return
    end

    -- Siphon Life
    if DotIt.Settings["Siphon Life"] and
        (DotIt.Settings["Siphon Life"] == 0 or (currentTime - DotIt.Settings["Siphon Life"] > 30)) and
        not DotIt:GetSpellCooldown("Siphon Life") and not DotIt.Settings["IsCasting"] then
        CastSpellByName("Siphon Life")
        DotIt.Settings["Siphon Life"] = currentTime
        return
    end

    -- Immolate
    if DotIt.Settings["Immolate"] and
        (DotIt.Settings["Immolate"] == 0 or (currentTime - DotIt.Settings["Immolate"] > 15)) and
        not DotIt:GetSpellCooldown("Immolate") and not DotIt.Settings["IsCasting"] then
        CastSpellByName("Immolate")
        DotIt.Settings["Immolate"] = currentTime
        return
    end

    -- Shadow Bolt as a filler, only if none of the above conditions are met
    if not DotIt.Settings["IsCasting"] then
        CastSpellByName("Shadow Bolt")
    end
end

function DotIt:GetSpellCooldown(name)
    local spellID = 1
    local spell = GetSpellName(spellID, BOOKTYPE_SPELL)
    while (spell) do
        local start, duration, hasCooldown = GetSpellCooldown(spellID, BOOKTYPE_SPELL)
        if spell == name and duration > 0 then
            return true
        end
        spellID = spellID + 1
        spell = GetSpellName(spellID, BOOKTYPE_SPELL)
    end
    return false
end

SlashCmdList["DOTIT"] = function(msg)
    if msg == "settings" then
        if not DotIt.settingsMenu then
            DotIt:CreateSettingsMenu()
            print("Settings menu created.")
        end
        if DotIt.settingsMenu:IsVisible() then
            DotIt.settingsMenu:Hide()
            print("Settings menu hidden.")
        else
            DotIt.settingsMenu:Show()
            print("Settings menu shown.")
        end
    else
        DotIt:Cast()
    end
end

SLASH_DOTIT1 = "/dotit"

DotIt:SetScript("OnEvent", DotIt.OnEvent)
