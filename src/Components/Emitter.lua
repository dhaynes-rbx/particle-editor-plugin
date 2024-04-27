local Selection = game:GetService("Selection")

local Root = script.Parent.Parent
local Packages = Root.Packages
local React = require(Packages.React)
local ReactRoblox = require(Packages.ReactRoblox)
local Incrementer = require(script.Parent.Parent.Incrementer)
local Icons = require(Root.Icons)

local Button = require(script.Parent.SubComponents.Button)
local ButtonWithLabel = require(script.Parent.SubComponents.ButtonWithLabel)
local EmitterLabel = require(script.Parent.SubComponents.EmitterLabel)

type Props = {
    Name: string,
    ParticleEmitter: ParticleEmitter,
    Dragging: boolean,
    SetDragging: () -> nil,
    ShiftClickActive: boolean,
    SetHoveredButton: (string) -> nil,
    HoveredButton: string,
    OnShiftClickPlay: () -> nil,
    OnShiftClickCLear: () -> nil,
}

local function Emitter(props: Props)
    local emitterEnabled, setEmitterEnabled = React.useState(props.ParticleEmitter.Enabled)
    local previewing, setPreviewing = React.useState(false)
    local muteButtons = not props.Dragging
    local layoutOrder = Incrementer.new()

    -- React.useEffect(function()
    -- setEmitterEnabled(props.ParticleEmitter.Enabled)
    -- end, { props.ParticleEmitter.Enabled })

    return React.createElement("ImageButton", {
        Image = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        ImageTransparency = 1,
        Interactable = muteButtons,
        AutomaticSize = Enum.AutomaticSize.XY,
        AnchorPoint = Vector2.new(1, 1),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Position = UDim2.fromScale(1, 1),
        Size = UDim2.fromScale(1, 0),
    }, {

        EmitterContents = React.createElement("Frame", {
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundTransparency = 0.9,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 30),
        }, {
            uICorner = React.createElement("UICorner", {
                CornerRadius = UDim.new(0, 2),
            }),
            uIPadding = React.createElement("UIPadding", {
                PaddingLeft = UDim.new(0, 4),
                PaddingRight = UDim.new(0, 4),
            }),
            uIListLayout = React.createElement("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 4),
            }),

            EmitterLabel = EmitterLabel({
                Name = props.Name,
                ParticleEmitter = props.ParticleEmitter,
                Enabled = emitterEnabled,

                LayoutOrder = layoutOrder:Increment(),
                SetEnabled = function() end,
            }),

            Buttons = React.createElement("Frame", {
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                LayoutOrder = layoutOrder:Increment(),
                Size = UDim2.new(1, 0, 0, 26),
            }, {
                EmitButtonAndLabel = ButtonWithLabel({
                    Icon = Icons.Emit,
                    ParticleEmitter = props.ParticleEmitter,
                    Attribute = "Emit",
                    Muted = muteButtons,
                    LayoutOrder = layoutOrder:Increment(),
                    Enabled = false,
                    OnActivated = function()
                        if props.ShiftClickActive then
                            props.OnShiftClickEmit()
                        else
                            props.ParticleEmitter:Emit(props.ParticleEmitter:GetAttribute("Emit"))
                        end
                    end,
                    OnDragging = function(bool)
                        props.SetDragging(bool)
                    end,
                    ShiftClickActive = props.ShiftClickActive and props.HoveredButton == "Emit",
                    SetHoveredButton = function(bool)
                        props.SetHoveredButton(bool and "Emit" or "None")
                    end,
                }),

                ButtonsRow = React.createElement("Frame", {
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 1,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    LayoutOrder = layoutOrder:Increment(),
                    Size = UDim2.new(1, 0, 1, 0),
                }, {
                    -- visibilityButton = Button({
                    --     Icon = emitterVisible and Icons.VisibleOn or Icons.VisibleOff,
                    --     LayoutOrder = layoutOrder:Increment(),
                    --     Enabled = emitterVisible,
                    --     OnActivated = function()
                    --         props.ParticleEmitter.Enabled = not emitterEnabled
                    --         props.ParticleEmitter:Clear()
                    --         setEmitterEnabled(not emitterEnabled)
                    --         setEmitterVisible(not emitterEnabled)
                    --     end,
                    -- }),
                    PlayButton = Button({
                        Icon = Icons.Play,
                        Muted = muteButtons,
                        LayoutOrder = layoutOrder:Increment(),
                        Enabled = emitterEnabled,
                        ShiftClickActive = props.ShiftClickActive and props.HoveredButton == "Play",
                        OnActivated = function()
                            if props.ShiftClickActive then
                                props.OnShiftClickPlay(not emitterEnabled)
                            else
                                props.ParticleEmitter.Enabled = not emitterEnabled
                            end
                            setEmitterEnabled(not emitterEnabled)
                        end,
                        SetHoveredButton = function(bool)
                            props.SetHoveredButton(bool and "Play" or "None")
                        end,
                        OnHovered = function(hovered)
                            setPreviewing(hovered)
                        end,
                    }),
                    -- PauseButton = Button({
                    --     Icon = Icons.Pause,
                    --     LayoutOrder = layoutOrder:Increment(),
                    --     Enabled = emitterPaused,
                    --     OnActivated = function()
                    --         props.ParticleEmitter.TimeScale = emitterPaused and 1 or 0
                    --         setEmitterPaused(not emitterPaused)
                    --     end,
                    -- }),
                    ClearButton = Button({
                        Icon = Icons.Clear,
                        Muted = muteButtons,
                        LayoutOrder = layoutOrder:Increment(),
                        Enabled = false,
                        ShiftClickActive = props.ShiftClickActive and props.HoveredButton == "Clear",
                        OnActivated = function()
                            if props.ShiftClickActive then
                                props.OnShiftClickClear()
                            else
                                props.ParticleEmitter:Clear()
                            end
                        end,
                        SetHoveredButton = function(bool)
                            props.SetHoveredButton(bool and "Clear" or "None")
                        end,
                    }),

                    uIListLayout = React.createElement("UIListLayout", {
                        FillDirection = Enum.FillDirection.Horizontal,
                        HorizontalAlignment = Enum.HorizontalAlignment.Left,
                        Padding = UDim.new(0, 4),
                        VerticalAlignment = Enum.VerticalAlignment.Center,
                        SortOrder = Enum.SortOrder.LayoutOrder,
                    }),
                }),
            }),

            --[[ Properties
            
            Properties = React.createElement("Frame", {
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                BackgroundTransparency = 0.9,
                BorderColor3 = Color3.fromRGB(0, 0, 0),
                BorderSizePixel = 0,
                LayoutOrder = layoutOrder:Increment(),
                Size = UDim2.fromScale(1, 0),
            }, {
                Emit = React.createElement("Frame", {
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 1,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    LayoutOrder = 2,
                    Size = UDim2.new(1, 0, 0, 26),
                }, {
                    numberInput = React.createElement("Frame", {
                        AnchorPoint = Vector2.new(1, 0),
                        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                        BackgroundTransparency = 0.5,
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        BorderSizePixel = 0,
                        Position = UDim2.fromScale(1, 0),
                        Size = UDim2.new(0, 50, 1, 0),
                    }, {
                        uICorner2 = React.createElement("UICorner", {
                            CornerRadius = UDim.new(0, 4),
                        }),

                        textBox = React.createElement("TextBox", {
                            CursorPosition = -1,
                            FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
                            Text = "5",
                            TextColor3 = Color3.fromRGB(255, 255, 255),
                            TextSize = 14,
                            TextXAlignment = Enum.TextXAlignment.Right,
                            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                            BackgroundTransparency = 1,
                            BorderColor3 = Color3.fromRGB(0, 0, 0),
                            BorderSizePixel = 0,
                            Size = UDim2.fromScale(1, 1),
                        }),

                        uIPadding2 = React.createElement("UIPadding", {
                            PaddingLeft = UDim.new(0, 4),
                            PaddingRight = UDim.new(0, 4),
                        }),
                    }),

                    uIPadding3 = React.createElement("UIPadding", {
                        PaddingBottom = UDim.new(0, 4),
                        PaddingTop = UDim.new(0, 4),
                    }),

                    textButton1 = React.createElement("TextButton", {
                        FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
                        Text = "Emit",
                        TextColor3 = Color3.fromRGB(0, 0, 0),
                        TextSize = 14,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        BackgroundTransparency = 1,
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        BorderSizePixel = 0,
                        Size = UDim2.fromScale(0.5, 1),
                        [ReactRoblox.Event.Activated] = function()
                            props.ParticleEmitter:Emit(100)
                        end,
                    }),
                }),
                --]]

            --[[ TimeScale
                    -- TimeScale = React.createElement("Frame", {
                        --     BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        --     BackgroundTransparency = 1,
                        --     BorderColor3 = Color3.fromRGB(0, 0, 0),
                        --     BorderSizePixel = 0,
                        --     LayoutOrder = 3,
                        --     Size = UDim2.new(1, 0, 0, 26),
                        -- }, {
                --     numberInput1 = React.createElement("Frame", {
                    --         AnchorPoint = Vector2.new(1, 0),
                    --         BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                    --         BackgroundTransparency = 0.5,
                    --         BorderColor3 = Color3.fromRGB(0, 0, 0),
                    --         BorderSizePixel = 0,
                    --         Position = UDim2.fromScale(1, 0),
                    --         Size = UDim2.new(0, 30, 1, 0),
                    --     }, {
                --         uICorner3 = React.createElement("UICorner", {
                    --             CornerRadius = UDim.new(0, 4),
                --         }),

                --         textBox1 = React.createElement("TextBox", {
                --             FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
                --             Text = "1",
                --             TextColor3 = Color3.fromRGB(255, 255, 255),
                --             TextSize = 14,
                --             TextXAlignment = Enum.TextXAlignment.Right,
                --             BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                --             BackgroundTransparency = 1,
                --             BorderColor3 = Color3.fromRGB(0, 0, 0),
                --             BorderSizePixel = 0,
                --             Size = UDim2.fromScale(1, 1),
                --         }),

                --         uIPadding4 = React.createElement("UIPadding", {
                --             PaddingLeft = UDim.new(0, 4),
                --             PaddingRight = UDim.new(0, 4),
                --         }),
                --     }),
                
                --     uIPadding5 = React.createElement("UIPadding", {
                --         PaddingBottom = UDim.new(0, 4),
                --         PaddingTop = UDim.new(0, 4),
                --     }),
                
                --     textButton2 = React.createElement("TextButton", {
                    --         FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
                --         Text = "TimeScale",
                --         TextColor3 = Color3.fromRGB(0, 0, 0),
                --         TextSize = 14,
                --         TextXAlignment = Enum.TextXAlignment.Left,
                --         BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                --         BackgroundTransparency = 1,
                --         BorderColor3 = Color3.fromRGB(0, 0, 0),
                --         BorderSizePixel = 0,
                --         Size = UDim2.fromScale(0.5, 1),
                --         [ReactRoblox.Event.Activated] = function()
                --             local timeScale = props.ParticleEmitter.TimeScale
                --             if timeScale == 0 then
                --                 timeScale = 1
                --             else
                --                 timeScale = 0
                --             end
                --             props.ParticleEmitter.TimeScale = timeScale
                --         end,
                --     }),
                -- }),

                --Ephemerals
                uIListLayout1 = React.createElement("UIListLayout", {
                    SortOrder = Enum.SortOrder.LayoutOrder,
                }),
                uIPadding6 = React.createElement("UIPadding", {
                    PaddingLeft = UDim.new(0, 4),
                    PaddingRight = UDim.new(0, 4),
                }),
                ]]
            -- }),
            --]]
        }),
    })
end

return function(props: Props)
    return React.createElement(Emitter, props)
end
