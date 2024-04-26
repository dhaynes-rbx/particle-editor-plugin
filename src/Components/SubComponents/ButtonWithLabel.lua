local ReplicatedFirst = game:GetService("ReplicatedFirst")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Root = script.Parent.Parent.Parent
local Packages = Root.Packages
local React = require(Packages.React)
local Dash = require(Packages.Dash)
local ReactRoblox = require(Packages.ReactRoblox)
local Icons = require(Root.Icons)
local Button = require(script.Parent.Button)
local Incrementer = require(script.Parent.Parent.Parent.Incrementer)

local enabledTransparency = 0.75

export type HotSpotButtonProps = {
    Position: UDim2,
    SetDragging: (boolean) -> nil,
}

function HotspotButton(props: HotSpotButtonProps)
    local hover, setHover = React.useState(false)
    return React.createElement("ImageButton", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        AutoButtonColor = false,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, -4, 0.5, 0),
        Size = UDim2.new(0, 8, 1, 2),
        ZIndex = 10,
        [ReactRoblox.Event.MouseButton1Down] = function()
            props.SetDragging(true)
        end,
        [ReactRoblox.Event.MouseEnter] = function()
            setHover(true)
        end,
        [ReactRoblox.Event.MouseLeave] = function()
            setHover(false)
        end,
    }, {
        Frame = hover and React.createElement("Frame", {
            AnchorPoint = Vector2.new(0, 0),
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -8, 1, -8),
            Position = UDim2.new(0, 4, 0, 4),
        }, {
            UIStroke = React.createElement("UIStroke", {
                Color = Color3.fromRGB(255, 255, 255),
                Thickness = 4,
                Transparency = 0.75,
            }),
            UICorners = React.createElement("UICorner", {
                CornerRadius = UDim.new(0, 2),
            }),
        }),
    })
end

export type Props = {
    Icon: string,
    LayoutOrder: number,
    Enabled: boolean,
    Muted: boolean,
    OnActivated: () -> nil,
    OnDragging: () -> nil,
}

function ButtonWithLabel(props: Props)
    local labelValue, setLabelValue = React.useState(100)
    local dragging: boolean, setDragging = React.useState(false)
    local dragConnection: RBXScriptConnection, setDragConnection = React.useState(nil)
    local selectedRibbonTool, setSelectedRibbonTool = React.useState(getfenv(0).plugin:GetSelectedRibbonTool())

    local layoutOrder = Incrementer.new()

    React.useEffect(function()
        if dragConnection then
            dragConnection:Disconnect()
        end

        local thisPlugin: Plugin = getfenv(0).plugin

        if dragging then
            setSelectedRibbonTool(thisPlugin:GetSelectedRibbonTool())
            thisPlugin:Activate(true)
            local mouse: PluginMouse = thisPlugin:GetMouse()
            mouse.Icon = "rbxasset://SystemCursors/SizeEW"
            mouse.Button1Up:Connect(function()
                setDragging(false)
            end)

            local dragStart = mouse.X
            local dragDeltaX = dragStart - mouse.X
            local timer = 0
            setDragConnection(RunService.RenderStepped:Connect(function()
                local newDragDeltaX = dragStart - mouse.X
                if newDragDeltaX == dragDeltaX then
                    timer = timer + 1
                    if timer > 30 then
                        setDragging(false)
                    end
                else
                    timer = 0
                end

                local shiftDown = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift)
                    or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)
                local controlDown = UserInputService:IsKeyDown(Enum.KeyCode.LeftControl)
                    or UserInputService:IsKeyDown(Enum.KeyCode.RightControl)
                local dragScalar = shiftDown and 0.1 or controlDown and 10 or 1

                dragDeltaX = newDragDeltaX

                setLabelValue(math.clamp(labelValue + dragDeltaX, 0, 10000))
                print("Dragging:", newDragDeltaX)
            end))
            props.OnDragging(true)
        else
            thisPlugin:SelectRibbonTool(selectedRibbonTool, UDim2.new())
            setSelectedRibbonTool(thisPlugin:GetSelectedRibbonTool())
        end

        return function()
            if dragConnection then
                dragConnection:Disconnect()
            end
            thisPlugin:GetMouse().Icon = "rbxasset://SystemCursors/Arrow"
            thisPlugin:Activate(false)
            props.OnDragging(false)
        end
    end, { dragging })

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
            Interactable = props.Muted,
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
            Size = UDim2.new(0, 50, 1, 0),
        }, {
            uICorner2 = React.createElement("UICorner", {
                CornerRadius = UDim.new(0, 4),
            }),

            textBox = React.createElement("TextBox", {
                ClearTextOnFocus = true,
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
                    setLabelValue(tonumber(rbx.Text) or 0)
                end,
            }, {
                LeftHotspot = HotspotButton({
                    Position = UDim2.fromOffset(-4, 0),
                    SetDragging = function(bool)
                        setDragging(bool)
                    end,
                    -- AnchorPoint = Vector2.new(0.5, 0),
                    -- AutoButtonColor = false,
                    -- BackgroundTransparency = 0.75,
                    -- Position = UDim2.fromOffset(-4, 0),
                    -- Size = UDim2.new(0, 8, 1, 2),
                    -- [ReactRoblox.Event.MouseButton1Down] = function()
                    --     setDragging(true)
                    -- end,
                }),
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
