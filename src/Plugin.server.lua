if game:GetService("RunService"):IsRunMode() then
    return
end

local CoreGui = game:GetService("CoreGui")
local Packages = script.Parent.Packages
local React = require(Packages.React)
local ReactRoblox = require(Packages.ReactRoblox)

--Components
local App = require(script.Parent.Components.ParticleEditorPluginApp)

local root = nil
local guiFolder = nil
local pluginIsInitialized = false

local function cleanup()
    if root then
        root:unmount()
    end
end

local function initPlugin()
    if not pluginIsInitialized then
        print("Loading ParticleEditorPlugin")
        plugin:Activate(false)

        guiFolder = CoreGui:FindFirstChild("ParticleEditorPluginScreenGui")
        if not guiFolder then
            guiFolder = Instance.new("Folder")
            guiFolder.Name = "ParticleEditorPluginScreenGui"
            guiFolder.Parent = CoreGui
        end

        root = ReactRoblox.createRoot(guiFolder)
        root:render(React.createElement(App, {}))

        plugin:SelectRibbonTool(Enum.RibbonTool.Select, UDim2.new())

        pluginIsInitialized = true
    else
        cleanup()
        plugin:Deactivate()

        pluginIsInitialized = false
    end
end

--Create plugin toolbar and button
local toolbar = plugin:CreateToolbar("Particle Editor")
local button = toolbar:CreateButton("Particle Editor", "Start", "rbxassetid://4458901886")
button.ClickableWhenViewportHidden = true
button.Click:Connect(initPlugin)

plugin.Unloading:Connect(function()
    cleanup()
    print("Unloading Particle Editor Plugin")
end)
