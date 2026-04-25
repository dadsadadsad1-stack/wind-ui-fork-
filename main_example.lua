-- WindUI fork test example
-- Run this locally to verify spacing presets, section descriptions, and badges.

local WindUI = require("./src/Init")

local Window = WindUI:CreateWindow({
    Title = "WindUI Fork Test",
    Author = "Spacing + Badge Demo",
    Folder = "WindUI_Fork_Test",
    Size = UDim2.fromOffset(720, 540),
    Theme = "Dark",
    NewElements = true,
    SpacingPreset = "Compact", -- Compact, Normal, or Spacious
    HidePanelBackground = false,
})

Window:SetSpacingPreset("Compact")

local Home = Window:Section({
    Title = "Overview",
    Desc = "This section shows the new subtitle and badge support.",
    Badge = "New",
    Icon = "solar:home-2-bold",
    Opened = true,
})

Home:Button({
    Title = "Refresh Data",
    Desc = "A normal button inside a compact-spaced section.",
    Icon = "rbxassetid://77799629590713",
    IconThemed = true,
    Callback = function()
        print("Refresh clicked")
    end,
})

Home:Toggle({
    Title = "Enable Feature",
    Desc = "This is here to show the spacing preset between elements.",
    Value = true,
    Callback = function(v)
        print("Feature enabled:", v)
    end,
})

Home:Divider()

Home:Label({
    Text = "Spacing preset: Compact",
    Icon = "lucide:info",
})

local Settings = Window:Section({
    Title = "Settings",
    Desc = "This section uses a custom badge and a different icon source.",
    Badge = "Beta",
    Icon = "rbxassetid://77799629590713",
})

Settings:Button({
    Title = "Spacious Mode",
    Desc = "Switch the whole window to a roomier layout.",
    Icon = "solar:rows-3-bold",
    Callback = function()
        Window:SetSpacingPreset("Spacious")
        print("Spacing preset set to Spacious")
    end,
})

Settings:Button({
    Title = "Normal Mode",
    Desc = "Restore the default spacing preset.",
    Icon = "solar:rows-4-bold",
    Callback = function()
        Window:SetSpacingPreset("Normal")
        print("Spacing preset set to Normal")
    end,
})

local Tools = Window:Section({
    Title = "Tools",
    Desc = "Use this section to test live badge updates.",
    Badge = "Hot",
    Icon = "solar:settings-bold",
})

Tools:Button({
    Title = "Mark as Soon",
    Desc = "Changes the badge text live.",
    Icon = "solar:clock-circle-bold",
    Callback = function()
        Tools:SetBadge("Soon")
        print("Badge updated to Soon")
    end,
})

Tools:Button({
    Title = "Mark as Beta",
    Desc = "Changes the badge back to Beta.",
    Icon = "solar:danger-bold",
    Callback = function()
        Tools:SetBadge("Beta")
        print("Badge updated to Beta")
    end,
})

local Assets = Window:Section({
    Title = "Asset Icons",
    Desc = "This section tests Roblox asset id icons directly.",
    Badge = "Test",
    Icon = "rbxassetid://77799629590713",
})

Assets:Label({
    Text = "rbxassetid icons should now work consistently.",
    Icon = "rbxassetid://77799629590713",
})

Assets:Button({
    Title = "Custom Asset Icon Button",
    Desc = "Button icon uses a Roblox asset id.",
    Icon = "rbxassetid://77799629590713",
    Callback = function()
        print("Asset icon button clicked")
    end,
})

Window:Open()
