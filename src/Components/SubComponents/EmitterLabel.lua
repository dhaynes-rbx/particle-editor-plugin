local Selection = game:GetService("Selection")

local Root = script.Parent.Parent.Parent
local Packages = Root.Packages
local React = require(Packages.React)
local ReactRoblox = require(Packages.ReactRoblox)
local Incrementer = require(Root.Incrementer)
local Icons = require(Root.Icons)

local Button = require(Root.Components.SubComponents.Button)

type Props = {
    Name: string,
    Enabled: boolean,
    SetEnabled: () -> nil,
    LayoutOrder: number,
    SetDragging: () -> nil,
}

local function EmitterLabel(props: Props)
    local hover, setHover = React.useState(false)
    local labelSizeX = hover and 0.8 or 1
    local layoutOrder = Incrementer.new()
    return React.createElement("Frame", {
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 26),
        LayoutOrder = props.LayoutOrder,

        [ReactRoblox.Event.MouseEnter] = function()
            setHover(true)
        end,
        [ReactRoblox.Event.MouseLeave] = function()
            setHover(false)
        end,
    }, {
        uIPadding1 = React.createElement("UIPadding", {
            PaddingBottom = UDim.new(0, 4),
            PaddingTop = UDim.new(0, 4),
        }),

        textButton = React.createElement("TextButton", {
            FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
            Text = props.Name,
            TextColor3 = Color3.fromRGB(0, 0, 0),
            TextSize = 14,
            TextTruncate = Enum.TextTruncate.AtEnd,
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
            LayoutOrder = layoutOrder:Increment(),
            Size = UDim2.fromScale(labelSizeX, 1),
            [ReactRoblox.Event.Activated] = function()
                Selection:Set({ props.ParticleEmitter })
            end,
        }),
        buttonFrame = hover and React.createElement("Frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            LayoutOrder = layoutOrder:Increment(),
            AutomaticSize = Enum.AutomaticSize.Y,
            Size = UDim2.fromScale(1, 0),
        }, {

            findButton = Button({
                Icon = Icons.Find,
                LayoutOrder = layoutOrder:Increment(),
                Enabled = false,
                OnActivated = function()
                    Selection:Set({ props.ParticleEmitter })
                end,
                SetHoveredButton = function() end,
            }),

            uIListLayout = React.createElement("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Right,
                Padding = UDim.new(0, 4),
                SortOrder = Enum.SortOrder.LayoutOrder,
            }),
        }),
    })
end

return function(props: Props)
    return React.createElement(EmitterLabel, props)
end
