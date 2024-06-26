local ReplicatedFirst = game:GetService("ReplicatedFirst")
local Root = script.Parent.Parent.Parent
local Packages = Root.Packages
local React = require(Packages.React)
local Dash = require(Packages.Dash)
local ReactRoblox = require(Packages.ReactRoblox)
local Icons = require(Root.Icons)

local enabledTransparency = 0.75

type Props = {
    Icon: string,
    LayoutOrder: number,
    Enabled: boolean,
    Muted: boolean,
    OnActivated: () -> nil,
    Size: UDim2,
    ShiftClickActive: boolean,
    SetHoveredButton: (string) -> nil,
    OnHovered: (boolean) -> nil,
}

local function Button(props: Props)
    local hover, setHover = React.useState(false)
    local isHoveredOrShiftEnabled = hover or props.ShiftClickActive

    React.useEffect(function()
        if props.OnHovered then
            props.OnHovered(hover)
        end
    end, { hover })

    return React.createElement("Frame", {
        -- AnchorPoint = Vector2.new(1, 0),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = (isHoveredOrShiftEnabled or props.Enabled) and 0.75 or 1,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        LayoutOrder = props.LayoutOrder,
        Position = props.Position or UDim2.fromScale(0, 0),
        Size = props.Size or UDim2.fromOffset(20, 20),
    }, {
        button = React.createElement("ImageButton", {
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundColor3 = Color3.fromRGB(255, 0, 4),
            BackgroundTransparency = 1,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
            Image = props.Icon,
            ImageColor3 = Color3.new(0, 0, 0),
            ImageTransparency = 0,
            Interactable = props.Muted,
            Position = UDim2.fromScale(0, 0.5),
            Size = UDim2.fromScale(1, 1),

            [ReactRoblox.Event.Activated] = function()
                props.OnActivated()
            end,
            [ReactRoblox.Event.MouseEnter] = function()
                setHover(true)
                if props.SetHoveredButton then
                    props.SetHoveredButton(true)
                end
            end,
            [ReactRoblox.Event.MouseLeave] = function()
                setHover(false)
                if props.SetHoveredButton then
                    props.SetHoveredButton(false)
                end
            end,
        }, {
            aspectRatio = React.createElement("UIAspectRatioConstraint", {
                AspectRatio = 1,
            }),
        }),

        uICorner1 = React.createElement("UICorner", {
            CornerRadius = UDim.new(0, 4),
        }),
        uiPadding = React.createElement("UIPadding", {
            PaddingBottom = UDim.new(0, 2),
            PaddingLeft = UDim.new(0, 2),
            PaddingRight = UDim.new(0, 2),
            PaddingTop = UDim.new(0, 2),
        }),
    })
end

return function(props: Props)
    return React.createElement(Button, props)
end
