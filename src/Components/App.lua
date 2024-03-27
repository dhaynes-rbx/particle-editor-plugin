local Root = script.Parent.Parent
local Packages = Root.Packages
local React = require(Packages.React)

local Dash = require(Packages.Dash)
local Panel = require(script.Parent.SubComponents.Panel)
local Emitter = require(script.Parent.Emitter)
local Selection = require(script.Parent.Selection)

local App = React.Component:extend("PluginGui")

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
    end)
    self:setState({})
end

function App:render()
    local emitters = {}
    for _, selection in self.selection:Get() do
        if selection:IsA("ParticleEmitter") then
            table.insert(
                emitters,
                Emitter({
                    Name = selection.Name,
                    ParticleEmitter = selection,
                })
            )
        end
        for _, descendant in selection:GetDescendants() do
            if descendant:IsA("ParticleEmitter") then
                table.insert(
                    emitters,
                    Emitter({
                        Name = descendant.Name,
                        ParticleEmitter = descendant,
                    })
                )
            end
        end
    end

    local showUI: boolean = self.state.numSelected and self.state.numSelected > 0

    return React.createElement("ScreenGui", {}, {
        MainWidget = showUI and Panel({}, emitters),

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
