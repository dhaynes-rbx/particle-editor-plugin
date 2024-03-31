local Selection = game:GetService("Selection")

local Root = script.Parent.Parent
local Packages = Root.Packages
local React = require(Packages.React)
local ReactRoblox = require(Packages.ReactRoblox)
local Incrementer = require(script.Parent.Parent.Incrementer)
local Icons = require(Root.Icons)

local Button = require(script.Parent.SubComponents.Button)

export type Props = {
    Name: string,
    ParticleEmitter: ParticleEmitter,
}
export type EmitterLabelProps = {
    Name: string,
    Enabled: boolean,
    SetEnabled: () -> nil,
    LayoutOrder: number,
}

local function EmitterLabel(props: Props)
    local hover, setHover = React.useState(false)
    local labelSizeX = hover and 0.7 or 1
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

            visibilityButton = Button({
                Icon = props.Enabled and Icons.VisibleOn or Icons.VisibleOff,
                ParticleEmitter = props.ParticleEmitter,
                Enabled = props.Enabled,
                OnActivated = function()
                    props.SetEnabled()
                end,
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

local function Emitter(props: Props)
    local emitterVisible, setEmitterVisible = React.useState(props.ParticleEmitter.Enabled)
    local emitterEnabled, setEmitterEnabled = React.useState(props.ParticleEmitter.Enabled)

    local layoutOrder = Incrementer.new()
    return React.createElement("ImageButton", {
        Image = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        ImageTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.XY,
        AnchorPoint = Vector2.new(1, 1),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Position = UDim2.fromScale(1, 1),
        -- Size = UDim2.new(1, 20, 0, 20),
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
                SetEnabled = function()
                    props.ParticleEmitter.Enabled = not emitterEnabled
                    props.ParticleEmitter:Clear()
                    setEmitterEnabled(not emitterEnabled)
                    setEmitterVisible(not emitterEnabled)
                end,
            }),

            ButtonsRow = emitterVisible and React.createElement("Frame", {
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 1,
                BorderColor3 = Color3.fromRGB(0, 0, 0),
                BorderSizePixel = 0,
                LayoutOrder = layoutOrder:Increment(),
                Size = UDim2.new(1, 0, 0, 0),
            }, {
                PlayButton = Button({
                    Icon = Icons.Play,
                    ParticleEmitter = props.ParticleEmitter,
                    Enabled = true,
                    OnActivated = function() end,
                }),

                uIListLayout = React.createElement("UIListLayout", {
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Right,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                }),
            }),

            Properties = emitterVisible
                and React.createElement("Frame", {
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

                    TimeScale = React.createElement("Frame", {
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        BackgroundTransparency = 1,
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        BorderSizePixel = 0,
                        LayoutOrder = 3,
                        Size = UDim2.new(1, 0, 0, 26),
                    }, {
                        numberInput1 = React.createElement("Frame", {
                            AnchorPoint = Vector2.new(1, 0),
                            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                            BackgroundTransparency = 0.5,
                            BorderColor3 = Color3.fromRGB(0, 0, 0),
                            BorderSizePixel = 0,
                            Position = UDim2.fromScale(1, 0),
                            Size = UDim2.new(0, 30, 1, 0),
                        }, {
                            uICorner3 = React.createElement("UICorner", {
                                CornerRadius = UDim.new(0, 4),
                            }),

                            textBox1 = React.createElement("TextBox", {
                                FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
                                Text = "1",
                                TextColor3 = Color3.fromRGB(255, 255, 255),
                                TextSize = 14,
                                TextXAlignment = Enum.TextXAlignment.Right,
                                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                                BackgroundTransparency = 1,
                                BorderColor3 = Color3.fromRGB(0, 0, 0),
                                BorderSizePixel = 0,
                                Size = UDim2.fromScale(1, 1),
                            }),

                            uIPadding4 = React.createElement("UIPadding", {
                                PaddingLeft = UDim.new(0, 4),
                                PaddingRight = UDim.new(0, 4),
                            }),
                        }),

                        uIPadding5 = React.createElement("UIPadding", {
                            PaddingBottom = UDim.new(0, 4),
                            PaddingTop = UDim.new(0, 4),
                        }),

                        textButton2 = React.createElement("TextButton", {
                            FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
                            Text = "TimeScale",
                            TextColor3 = Color3.fromRGB(0, 0, 0),
                            TextSize = 14,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                            BackgroundTransparency = 1,
                            BorderColor3 = Color3.fromRGB(0, 0, 0),
                            BorderSizePixel = 0,
                            Size = UDim2.fromScale(0.5, 1),
                            [ReactRoblox.Event.Activated] = function()
                                local timeScale = props.ParticleEmitter.TimeScale
                                if timeScale == 0 then
                                    timeScale = 1
                                else
                                    timeScale = 0
                                end
                                props.ParticleEmitter.TimeScale = timeScale
                            end,
                        }),
                    }),

                    --Ephemerals
                    uIListLayout1 = React.createElement("UIListLayout", {
                        SortOrder = Enum.SortOrder.LayoutOrder,
                    }),
                    uIPadding6 = React.createElement("UIPadding", {
                        PaddingLeft = UDim.new(0, 4),
                        PaddingRight = UDim.new(0, 4),
                    }),
                }),
        }),
    })
end

return function(props: Props)
    return React.createElement(Emitter, props)
end
