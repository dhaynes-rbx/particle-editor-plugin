local Root = script.Parent.Parent
local Packages = Root.Packages
local React = require(Packages.React)
local ReactRoblox = require(Packages.ReactRoblox)
local Incrementer = require(script.Parent.Parent.Incrementer)

local Icons = {
    VisibleOn = "rbxassetid://16887929840",
    VisibleOff = "rbxassetid://16887929915",
}
export type Props = {
    Name: string,
    ParticleEmitter: ParticleEmitter,
}
export type EmitterLabelProps = {
    Name: string,
    Enabled: boolean,
    ParticleEmitter: ParticleEmitter,
    SetEnabled: () -> nil,
    LayoutOrder: number,
}
export type EmitterButtonProps = {
    ParticleEmitter: ParticleEmitter,
    Enabled: boolean,
    SetEnabled: () -> nil,
}

local function EmitterButton(props: EmitterButtonProps)
    return React.createElement("Frame", {
        -- AnchorPoint = Vector2.new(1, 0),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 1,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Position = props.Position or UDim2.fromScale(0, 0),
        Size = UDim2.fromOffset(20, 20),
    }, {
        uICorner1 = React.createElement("UICorner", {
            CornerRadius = UDim.new(0, 4),
        }),

        visibilityButton = React.createElement("ImageButton", {
            Image = props.Enabled and Icons.VisibleOn or Icons.VisibleOff,
            ImageTransparency = 0,
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundColor3 = Color3.fromRGB(255, 0, 4),
            BackgroundTransparency = 1,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
            Position = UDim2.fromScale(0, 0.5),
            Size = UDim2.fromScale(1, 1),
            [ReactRoblox.Event.Activated] = function()
                props.ParticleEmitter.Enabled = not props.ParticleEmitter.Enabled
                props.ParticleEmitter:Clear()
                props.SetEnabled(props.ParticleEmitter.Enabled)
            end,
        }, {
            aspectRatio = React.createElement("UIAspectRatioConstraint", {
                AspectRatio = 1,
            }),
        }),
    })
end

local function EmitterLabel(props: Props)
    local layoutOrder = Incrementer.new()
    return React.createElement("Frame", {
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 26),
        LayoutOrder = props.LayoutOrder,
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
            Size = UDim2.fromScale(1, 1),
        }),
    })
end

local function Emitter(props: Props)
    local enabled, setEnabled = React.useState(props.ParticleEmitter.Enabled)
    React.useEffect(function()
        return function()
            --Cleanup
        end
    end, {})

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
            }),

            EmitterLabel = EmitterLabel({
                Name = props.Name,
                ParticleEmitter = props.ParticleEmitter,
                Enabled = enabled,
                SetEnabled = function(bool: boolean)
                    setEnabled(bool)
                end,
                LayoutOrder = layoutOrder:Increment(),
            }),

            Row = React.createElement("Frame", {
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 1,
                BorderColor3 = Color3.fromRGB(0, 0, 0),
                BorderSizePixel = 0,
                LayoutOrder = layoutOrder:Increment(),
                Size = UDim2.new(1, 0, 0, 0),
            }, {
                visibilityButton = EmitterButton({
                    ParticleEmitter = props.ParticleEmitter,
                    Enabled = enabled,
                    SetEnabled = function(bool: boolean)
                        setEnabled(bool)
                    end,
                }),

                visibilityButton2 = EmitterButton({
                    ParticleEmitter = props.ParticleEmitter,
                    Enabled = enabled,
                    SetEnabled = function(bool: boolean)
                        setEnabled(bool)
                    end,
                }),

                visibilityButton3 = EmitterButton({
                    ParticleEmitter = props.ParticleEmitter,
                    Enabled = enabled,
                    SetEnabled = function(bool: boolean)
                        setEnabled(bool)
                    end,
                }),

                uIListLayout = React.createElement("UIListLayout", {
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Right,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                }),
            }),

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
