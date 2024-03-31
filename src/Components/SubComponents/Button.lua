local ReplicatedFirst = game:GetService("ReplicatedFirst")
local Root = script.Parent.Parent.Parent
local Packages = Root.Packages
local React = require(Packages.React)
local Dash = require(Packages.Dash)
local ReactRoblox = require(Packages.ReactRoblox)
local Icons = require(Root.Icons)

local enabledTransparency = 0.75

export type Props = {
    Icon: string,
    LayoutOrder: number,
    ParticleEmitter: ParticleEmitter,
    Enabled: boolean,
    OnActivated: () -> nil,
}

local function Button(props: Props)
    local hover, setHover = React.useState(false)
    return React.createElement("Frame", {
        -- AnchorPoint = Vector2.new(1, 0),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = (hover or props.Enabled) and 0.75 or 1,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        LayoutOrder = props.LayoutOrder,
        Position = props.Position or UDim2.fromScale(0, 0),
        Size = UDim2.fromOffset(20, 20),
    }, {
        uICorner1 = React.createElement("UICorner", {
            CornerRadius = UDim.new(0, 4),
        }),

        button = React.createElement("ImageButton", {
            Image = props.Icon,
            ImageTransparency = 0,
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundColor3 = Color3.fromRGB(255, 0, 4),
            BackgroundTransparency = 1,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
            Position = UDim2.fromScale(0, 0.5),
            Size = UDim2.fromScale(1, 1),
            [ReactRoblox.Event.Activated] = function()
                props.OnActivated()
            end,
            [ReactRoblox.Event.MouseEnter] = function()
                setHover(true)
            end,
            [ReactRoblox.Event.MouseLeave] = function()
                setHover(false)
            end,
        }, {
            aspectRatio = React.createElement("UIAspectRatioConstraint", {
                AspectRatio = 1,
            }),
        }),
    })
end

return function(props: Props)
    return React.createElement(Button, props)
end
