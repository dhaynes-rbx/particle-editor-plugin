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
    Clear = "Clear",
    Emit = "Emit",
    None = "None",
}

function App:init()
    self.selection = game:GetService("Selection")
    self.selection.SelectionChanged:Connect(function()
        if #self.selection:Get() > 0 then
            local selection = self.selection:Get()
            if not selection[#selection]:FindFirstAncestorOfClass("Workspace") then
                return
            end
        end
        self:setState({
            numSelected = #self.selection:Get(),
        })
        if #self.selection:Get() == 0 then
            -- getfenv(0).plugin:Activate(false)
        end
        -- local thisPlugin: Plugin = getfenv(0).plugin
        -- thisPlugin:SelectRibbonTool("Select", UDim2.new())
    end)
    UserInputService.InputBegan:Connect(function(input: InputObject)
        if input.UserInputType == Enum.UserInputType.Keyboard then
            self:setState({
                shiftDown = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift)
                    or UserInputService:IsKeyDown(Enum.KeyCode.RightShift),
            })
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Keyboard then
            self:setState({
                shiftDown = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift)
                    or UserInputService:IsKeyDown(Enum.KeyCode.RightShift),
            })
        end
    end)

    self:setState({
        dragging = false,
        shiftDown = false,
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
    for i, emitter in emitters do
        emitterComponents[emitter:GetFullName() .. i] = Emitter({
            Name = emitter.Name,
            ParticleEmitter = emitter,
            Dragging = self.state.dragging,
            HoveredButton = self.state.hoveredButton,
            ShiftClickActive = shiftClickActive,
            OnShiftClickPlay = function(enabled)
                for _, e in emitters do
                    e.Enabled = enabled
                end
            end,
            OnShiftClickClear = function()
                for _, e in emitters do
                    if e:GetAttribute("Visible") then
                        e:Clear()
                    end
                end
            end,
            OnShiftClickEmit = function()
                for _, e in emitters do
                    if e:GetAttribute("Visible") then
                        e:Emit(e:GetAttribute("Emit"))
                    end
                end
            end,
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
            OnDeselect = function(selection)
                self:setState({ numSelected = #self.selection:Get() })
            end,
        })
    end

    local showUI: boolean = #Dash.keys(emitterComponents) > 0

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
