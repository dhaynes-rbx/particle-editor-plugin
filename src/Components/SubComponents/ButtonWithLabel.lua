local ReplicatedFirst = game:GetService("ReplicatedFirst")
local Root = script.Parent.Parent.Parent
local Packages = Root.Packages
local React = require(Packages.React)
local Dash = require(Packages.Dash)
local ReactRoblox = require(Packages.ReactRoblox)
local Icons = require(Root.Icons)
local Button = require(script.Parent.Button)
local Incrementer = require(script.Parent.Parent.Parent.Incrementer)

local enabledTransparency = 0.75

export type Props = {
    Icon: string,
    LayoutOrder: number,
    Enabled: boolean,
    OnActivated: () -> nil,
}

function ButtonWithLabel(props: Props)
    local labelValue, setLabelValue = React.useState(100)
    local layoutOrder = Incrementer.new()
    return React.createElement("Frame", {
        AnchorPoint = Vector2.new(1, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 1,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        LayoutOrder = props.LayoutOrder,
        Position = UDim2.fromScale(1, 0),
        Size = UDim2.fromOffset(50, 24),
    }, {
        uICorner = React.createElement("UICorner", {
            CornerRadius = UDim.new(0, 4),
        }),

        imageButton = Button({
            Icon = props.Icon,
            -- LayoutOrder = 1,
            Enabled = props.Enabled,
            OnActivated = function()
                props.OnActivated(labelValue)
            end,
        }),

        numberInput = React.createElement("Frame", {
            AnchorPoint = Vector2.new(1, 0.5),
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundTransparency = 0.5,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
            LayoutOrder = layoutOrder:Increment(),
            Position = UDim2.fromScale(1, 0),
            Size = UDim2.new(0, 30, 1, 0),
        }, {
            uICorner2 = React.createElement("UICorner", {
                CornerRadius = UDim.new(0, 4),
            }),

            textBox = React.createElement("TextBox", {
                ClearTextOnFocus = false,
                CursorPosition = -1,
                FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
                Text = labelValue,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Right,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 1,
                BorderColor3 = Color3.fromRGB(0, 0, 0),
                BorderSizePixel = 0,
                Size = UDim2.fromScale(1, 1),
                [ReactRoblox.Event.Changed] = function(rbx)
                    print(rbx.Text)
                    setLabelValue(tonumber(rbx.Text) or 0)
                end,
            }),

            uIPadding1 = React.createElement("UIPadding", {
                PaddingLeft = UDim.new(0, 4),
                PaddingRight = UDim.new(0, 4),
            }),
        }),

        uIListLayout = React.createElement("UIListLayout", {
            Padding = UDim.new(0, 4),
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center,
        }),
    })
end

return function(props: Props)
    return React.createElement(ButtonWithLabel, props)
end
