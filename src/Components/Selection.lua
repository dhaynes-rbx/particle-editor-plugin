local Root = script.Parent.Parent
local Packages = Root.Packages
local React = require(Packages.React)

export type Props = {}

local function Selection(props: Props)
    React.useEffect(function()
        print("Init selection component")
        return function()
            print("Cleanup selection component")
        end
    end, {})

    return React.createElement(React.Fragment, {})
end

return function(props: Props)
    return React.createElement(Selection, props)
end
