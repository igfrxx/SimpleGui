local UILibrary = {}

-- Default colors
UILibrary.DefaultColors = {
    TitleColor = Color3.fromRGB(255, 255, 255),
    CollapseBtnColor = Color3.fromRGB(200, 200, 200),
    ButtonColor = Color3.fromRGB(60, 60, 60),
    ToggleColor = Color3.fromRGB(80, 80, 80),
    ToggleColorOFF = Color3.fromRGB(255, 0, 0),
    ToggleColorON = Color3.fromRGB(0, 255, 0),
    MainFrameColor = Color3.fromRGB(30, 30, 30)
}

function UILibrary:Create(config)
    -- Apply config or use defaults
    local colors = {}
    for k, v in pairs(UILibrary.DefaultColors) do
        colors[k] = config[k] or v
    end
    
    -- Main UI container
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "UILibrary"
    screenGui.Parent = game:GetService("CoreGui") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    
    -- Main frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 200, 0, 250) -- Default size with room for title
    mainFrame.Position = UDim2.new(0.5, -100, 0.5, -125)
    mainFrame.BackgroundColor3 = colors.MainFrameColor
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui
    
    -- Title bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 25)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    -- Title text
    local titleText = Instance.new("TextLabel")
    titleText.Name = "TitleText"
    titleText.Size = UDim2.new(0.7, 0, 1, 0)
    titleText.Position = UDim2.new(0, 5, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = config.Title or "UI Library"
    titleText.TextColor3 = colors.TitleColor
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Font = Enum.Font.Gotham
    titleText.TextSize = 12
    titleText.Parent = titleBar
    
    -- Collapse button
    local collapseButton = Instance.new("TextButton")
    collapseButton.Name = "CollapseButton"
    collapseButton.Size = UDim2.new(0, 25, 0, 25)
    collapseButton.Position = UDim2.new(1, -25, 0, 0)
    collapseButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    collapseButton.BorderSizePixel = 0
    collapseButton.Text = "-"
    collapseButton.TextColor3 = colors.CollapseBtnColor
    collapseButton.Font = Enum.Font.Gotham
    collapseButton.TextSize = 14
    collapseButton.Parent = titleBar
    
    -- Scrolling frame for content
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Name = "ContentFrame"
    scrollFrame.Size = UDim2.new(1, 0, 1, -25)
    scrollFrame.Position = UDim2.new(0, 0, 0, 25)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.ScrollBarThickness = 5
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0) -- Will be updated as elements are added
    scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scrollFrame.Parent = mainFrame
    
    -- Layout for elements
    local layout = Instance.new("UIListLayout")
    layout.Name = "Layout"
    layout.Padding = UDim.new(0, 5)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = scrollFrame
    
    -- Track elements for collapsing
    local elements = {}
    local originalSize = mainFrame.Size
    local isCollapsed = false
    
    -- Collapse toggle function
    local function toggleCollapse()
        isCollapsed = not isCollapsed
        if isCollapsed then
            mainFrame.Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset, 0, 25)
            collapseButton.Text = "+"
            scrollFrame.Visible = false
        else
            mainFrame.Size = originalSize
            collapseButton.Text = "-"
            scrollFrame.Visible = true
        end
    end
    
    collapseButton.MouseButton1Click:Connect(toggleCollapse)
    
    -- Public methods
    local library = {}
    
    function library:Button(text, callback)
        local button = Instance.new("TextButton")
        button.Name = "Button_"..text
        button.Size = UDim2.new(0.9, 0, 0, 30)
        button.Position = UDim2.new(0.05, 0, 0, 0)
        button.BackgroundColor3 = colors.ButtonColor
        button.BorderSizePixel = 0
        button.Text = text
        button.TextColor3 = colors.TitleColor
        button.Font = Enum.Font.Gotham
        button.TextSize = 14
        button.Parent = scrollFrame
        
        button.MouseButton1Click:Connect(callback)
        
        table.insert(elements, button)
        return button
    end
    
    function library:Toggle(text, default, callback)
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Name = "Toggle_"..text
        toggleFrame.Size = UDim2.new(0.9, 0, 0, 30)
        toggleFrame.Position = UDim2.new(0.05, 0, 0, 0)
        toggleFrame.BackgroundTransparency = 1
        toggleFrame.Parent = scrollFrame
        
        local toggleText = Instance.new("TextLabel")
        toggleText.Name = "Text"
        toggleText.Size = UDim2.new(0.7, 0, 1, 0)
        toggleText.Position = UDim2.new(0, 0, 0, 0)
        toggleText.BackgroundTransparency = 1
        toggleText.Text = text
        toggleText.TextColor3 = colors.TitleColor
        toggleText.TextXAlignment = Enum.TextXAlignment.Left
        toggleText.Font = Enum.Font.Gotham
        toggleText.TextSize = 14
        toggleText.Parent = toggleFrame
        
        local toggleButton = Instance.new("TextButton")
        toggleButton.Name = "ToggleButton"
        toggleButton.Size = UDim2.new(0.25, 0, 0.8, 0)
        toggleButton.Position = UDim2.new(0.75, 0, 0.1, 0)
        toggleButton.BackgroundColor3 = colors.ToggleColor
        toggleButton.BorderSizePixel = 0
        toggleButton.Text = default and "ON" or "OFF"
        toggleButton.TextColor3 = default and colors.ToggleColorON or colors.ToggleColorOFF
        toggleButton.Font = Enum.Font.Gotham
        toggleButton.TextSize = 12
        toggleButton.Parent = toggleFrame
        
        local state = default or false
        
        toggleButton.MouseButton1Click:Connect(function()
            state = not state
            toggleButton.Text = state and "ON" or "OFF"
            toggleButton.TextColor3 = state and colors.ToggleColorON or colors.ToggleColorOFF
            callback(state)
        end)
        
        table.insert(elements, toggleFrame)
        return toggleFrame
    end
    
    function library:Separator()
        local separator = Instance.new("Frame")
        separator.Name = "Separator"
        separator.Size = UDim2.new(0.9, 0, 0, 1)
        separator.Position = UDim2.new(0.05, 0, 0, 0)
        separator.BackgroundColor3 = colors.TitleColor
        separator.BorderSizePixel = 0
        separator.Parent = scrollFrame
        
        table.insert(elements, separator)
        return separator
    end
    
    function library:TextBox(text, default, callback)
        local textBoxFrame = Instance.new("Frame")
        textBoxFrame.Name = "TextBox_"..text
        textBoxFrame.Size = UDim2.new(0.9, 0, 0, 50)
        textBoxFrame.Position = UDim2.new(0.05, 0, 0, 0)
        textBoxFrame.BackgroundTransparency = 1
        textBoxFrame.Parent = scrollFrame
        
        local textBoxLabel = Instance.new("TextLabel")
        textBoxLabel.Name = "Label"
        textBoxLabel.Size = UDim2.new(1, 0, 0.4, 0)
        textBoxLabel.Position = UDim2.new(0, 0, 0, 0)
        textBoxLabel.BackgroundTransparency = 1
        textBoxLabel.Text = text
        textBoxLabel.TextColor3 = colors.TitleColor
        textBoxLabel.TextXAlignment = Enum.TextXAlignment.Left
        textBoxLabel.Font = Enum.Font.Gotham
        textBoxLabel.TextSize = 14
        textBoxLabel.Parent = textBoxFrame
        
        local textBox = Instance.new("TextBox")
        textBox.Name = "TextBox"
        textBox.Size = UDim2.new(1, 0, 0.6, 0)
        textBox.Position = UDim2.new(0, 0, 0.4, 0)
        textBox.BackgroundColor3 = colors.ButtonColor
        textBox.BorderSizePixel = 0
        textBox.Text = default or ""
        textBox.TextColor3 = colors.TitleColor
        textBox.Font = Enum.Font.Gotham
        textBox.TextSize = 14
        textBox.Parent = textBoxFrame
        
        textBox.FocusLost:Connect(function()
            callback(textBox.Text)
        end)
        
        table.insert(elements, textBoxFrame)
        return textBoxFrame
    end
    
    function library:Destroy()
        screenGui:Destroy()
    end
    
    return library
end

-- Example usage:
--[[
local UI = UILibrary:Create({
    Title = "CoolGui",
    TitleColor = Color3.fromRGB(255, 255, 255),
    CollapseBtnColor = Color3.fromRGB(200, 200, 200),
    ButtonColor = Color3.fromRGB(60, 60, 60),
    ToggleColor = Color3.fromRGB(80, 80, 80),
    ToggleColorOFF = Color3.fromRGB(255, 0, 0),
    ToggleColorON = Color3.fromRGB(0, 255, 0),
    MainFrameColor = Color3.fromRGB(30, 30, 30)
})

UI:Button("Click Me!", function()
    print("Clicked!")
end)

UI:Toggle("Enable Feature", false, function(value)
    print(value)
end)

UI:Separator()

UI:TextBox("Enter Text", "Default", function(value)
    print(value)
end)
]]

return UILibrary
