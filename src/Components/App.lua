local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Root = script.Parent.Parent
local Packages = Root.Packages
local React = require(Packages.React)

local Dash = require(Packages.Dash)
local Panel = require(script.Parent.SubComponents.Panel)
local Emitter = require(script.Parent.Emitter)
local SelectionService = game:GetService("Selection")

local App = React.Component:extend("PluginGui")

local HoveredButtons = {
    Play = "Play",
    Clear = "Clear",
    Emit = "Emit",
    None = "None",
}

function resetRibbonTool()
    -- task.delay(0.5, function()
    -- print("Resetting...")
    -- local thisPlugin: Plugin = getfenv(0).plugin
    -- thisPlugin:SelectRibbonTool(Enum.RibbonTool.Select, UDim2.new())
    -- print("Ribbon tool is:", thisPlugin:GetSelectedRibbonTool(), thisPlugin.Name)
    -- end)
end

function App:init()
    self.selectionChangedConnection = SelectionService.SelectionChanged:Connect(function()
        resetRibbonTool()
        self:setState({
            numSelected = 0,
            selectedObject = #SelectionService:Get() > 0 and SelectionService:Get()[1] or nil,
        })
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
        selectedObject = nil,
    })

    local thisPlugin: Plugin = getfenv(0).plugin
    self.debug = RunService.Heartbeat:Connect(function()
        print("Tool:", thisPlugin:GetSelectedRibbonTool())
    end)
end

function App:render()
    local shiftClickActive = not self.state.dragging and self.state.shiftDown
    local selectedObjectId = self.state.selectedObject and self.state.selectedObject:GetDebugId() or ""
    print("App re-render", getfenv(0).plugin:GetSelectedRibbonTool())
    resetRibbonTool()

    local emitters = {}
    local emitterComponents = {}
    for _, selection in SelectionService:Get() do
        if selection:IsA("ParticleEmitter") then
            table.insert(emitters, selection)
        end
        -- for _, descendant in selection:GetDescendants() do
        --     if descendant:IsA("ParticleEmitter") then
        --         table.insert(emitters, descendant)
        --     end
        -- end
    end
    for i, emitter: ParticleEmitter in emitters do
        emitterComponents[selectedObjectId .. emitter.Name .. emitter:GetDebugId() .. i] = Emitter({
            Name = emitter.Name,
            ParticleEmitter = emitter,
            Dragging = self.state.dragging,
            HoveredButton = self.state.hoveredButton,
            ShiftClickActive = shiftClickActive,
            OnShiftClickPlay = function(enabled)
                for _, e in emitters do
                    if e:GetAttribute("Visible") then
                        e.Enabled = enabled
                    end
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
            OnSetVisibility = function(emitterInstance)
                self:setState({ numSelected = #SelectionService:Get() })
            end,
            SetSelection = function(emitterInstance)
                SelectionService:Set({ emitterInstance })
                resetRibbonTool()
            end,
        })
    end

    local showUI: boolean = #Dash.keys(emitterComponents) > 0

    return React.createElement("ScreenGui", {}, {
        MainWidget = showUI and Panel({}, emitterComponents),

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
    if self.selectionChangedConnection then
        self.selectionChangedConnection:Disconnect()
    end
    if self.debug then
        self.debug:Disconnect()
    end
end

return App
