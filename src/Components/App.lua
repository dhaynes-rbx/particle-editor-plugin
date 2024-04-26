local UserInputService = game:GetService("UserInputService")
local Root = script.Parent.Parent
local Packages = Root.Packages
local React = require(Packages.React)

local Dash = require(Packages.Dash)
local Panel = require(script.Parent.SubComponents.Panel)
local Emitter = require(script.Parent.Emitter)
local Selection = require(script.Parent.Selection)

local App = React.Component:extend("PluginGui")

local HoveredButtons = {
    Play = "Play",
    Reset = "Reset",
    Emit = "Emit",
    None = "None",
}

function App:init()
    self.selection = game:GetService("Selection")
    self.selection.SelectionChanged:Connect(function()
        if #self.selection:Get() > 0 then
            if not self.selection:Get()[#self.selection:Get()]:FindFirstAncestorOfClass("Workspace") then
                return
            end
        end
        self:setState({
            numSelected = #self.selection:Get(),
        })
        if #self.selection:Get() == 0 then
            getfenv(0).plugin:SelectRibbonTool(Enum.RibbonTool.Select, UDim2.new())
        end
    end)
    UserInputService.InputBegan:Connect(function(input)
        self:setState({
            shiftDown = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift)
                or UserInputService:IsKeyDown(Enum.KeyCode.RightShift),
            controlDown = UserInputService:IsKeyDown(Enum.KeyCode.LeftControl)
                or UserInputService:IsKeyDown(Enum.KeyCode.RightControl),
        })
    end)

    self:setState({
        dragging = false,
        shiftDown = false,
        controlDown = false,
        hoveredButton = HoveredButtons.None,
    })
end

function App:render()
    local shiftClickActive = not self.state.dragging and self.state.shiftDown

    local emitters = {}
    local emitterComponents = {}
    for _, selection in self.selection:Get() do
        if selection:IsA("ParticleEmitter") then
            table.insert(emitters, selection)
        end
        for _, descendant in selection:GetDescendants() do
            if descendant:IsA("ParticleEmitter") then
                table.insert(emitters, descendant)
            end
        end
    end
    for _, emitter in emitters do
        table.insert(
            emitterComponents,
            Emitter({
                Name = emitter.Name,
                ParticleEmitter = emitter,
                Dragging = self.state.dragging,
                HoveredButton = self.state.hoveredButton,
                ShiftClickActive = shiftClickActive,
                SetDragging = function(bool)
                    self:setState({
                        dragging = bool,
                    })
                end,
                SetHoveredButton = function(buttonName)
                    self:setState({
                        hoveredButton = buttonName,
                    })
                end,
            })
        )
    end

    local showUI: boolean = #emitterComponents > 0

    return React.createElement("ScreenGui", {}, {
        MainWidget = showUI and Panel({}, emitterComponents),

        -- Selection = Selection({}),

        Padding = React.createElement("UIPadding", {
            PaddingBottom = UDim.new(0, 10),
            PaddingLeft = UDim.new(0, 10),
            PaddingRight = UDim.new(0, 10),
            PaddingTop = UDim.new(0, 10),
        }),
    })
end

function App:componentWillUnmount()
    --Nothing
end

return App
