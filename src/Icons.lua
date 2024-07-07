local StudioService = game:GetService("StudioService")
return {
    Clear = "rbxassetid://15626193282",
    Emit = "rbxassetid://16948285328",
    Find = "rbxassetid://17293033556",
    Pause = "rbxassetid://16946436987",
    Play = "rbxassetid://16946436719",
    Stop = "rbxassetid://16946436543",
    VisibleOff = "rbxassetid://16887929915",
    VisibleOn = "rbxassetid://18151352229",
    GetClassIcon = function(className)
        return StudioService:GetClassIcon(className).Image
    end,
}
