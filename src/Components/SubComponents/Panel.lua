local ReplicatedFirst = game:GetService("ReplicatedFirst")
local Root = script.Parent.Parent.Parent
local Packages = Root.Packages
local React = require(Packages.React)
local Dash = require(Packages.Dash)

export type Props = {}

local function Panel(props: Props)
    local ephemerals = {
        uIStroke = React.createElement("UIStroke", {
            Thickness = 2,
        }),

        uICorner = React.createElement("UICorner", {
            CornerRadius = UDim.new(0, 4),
        }),

        uIGradient = React.createElement("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(170, 170, 184)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(136, 136, 148)),
            }),
            Rotation = 90,
        }),

        uIListLayout = React.createElement("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
        }),

        uIPadding = React.createElement("UIPadding", {
            PaddingBottom = UDim.new(0, 4),
            PaddingLeft = UDim.new(0, 4),
            PaddingRight = UDim.new(0, 4),
            PaddingTop = UDim.new(0, 4),
        }),
    }

    local children = Dash.join(props.Children, ephemerals)

    return React.createElement(React.Fragment, {}, {
        Root = React.createElement("Frame", {
            AnchorPoint = Vector2.new(1, 1),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
            Position = UDim2.fromScale(1, 1),
            Size = UDim2.fromOffset(160, 0),
        }, {

            MainSection = React.createElement("Frame", {
                AnchorPoint = Vector2.new(1, 1),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderColor3 = Color3.fromRGB(0, 0, 0),
                BorderSizePixel = 0,
                Position = UDim2.fromScale(1, 1),
                Size = UDim2.fromOffset(160, 0),
            }, children),
        }),
    })
end

return function(props: Props, children)
    if children then
        props.Children = children
    end
    return React.createElement(Panel, props)
end
