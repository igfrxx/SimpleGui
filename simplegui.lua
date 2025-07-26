local UILibrary = {}

-- Default colors
UILibrary.DefaultColors = {
    TitleColor = Color3.fromRGB(255, 255, 255),
    CollapseBtnColor = Color3.fromRGB(20, 20, 20),
    ButtonColor = Color3.fromRGB(40, 40, 40),
    ToggleColor = Color3.fromRGB(40, 40, 40),
    ToggleColorOFF = Color3.fromRGB(255, 0, 0),
    ToggleColorON = Color3.fromRGB(0, 255, 0),
    MainFrameColor = Color3.fromRGB(30, 30, 30),
    SeparatorColor = Color3.fromRGB(60, 60, 60)
}

function UILibrary.new(config)
    local self = setmetatable({}, { __index = UILibrary })
    
    -- Configuration
    self.Title = config.Title or "UI Library"
    self.Size = config.Size or UDim2.new(0, 200, 0, 300)
    self.Position = config.Position or UDim2.new(0.5, -100, 0.5, -150)
    self.Colors = {}
    
    -- Apply custom colors or defaults
    for colorName, defaultColor in pairs(UILibrary.DefaultColors) do
        self.Colors[colorName] = config[colorName] or defaultColor
    end
    
    -- UI Elements
    self.Elements = {}
    self.Visible = true
    self.Minimized = false
    
    -- Create the UI
    self:CreateUI()
    
    return self
end

function UILibrary:CreateUI()
    -- Main ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "UILibrary"
    self.ScreenGui.Parent = game:GetService("CoreGui")
    
    -- Main Frame
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = self.Size
    self.MainFrame.Position = self.Position
    self.MainFrame.BackgroundColor3 = self.Colors.MainFrameColor
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Active = true
    self.MainFrame.Draggable = true
    self.MainFrame.Parent = self.ScreenGui
    
    -- Title Bar
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Name = "TitleBar"
    self.TitleBar.Size = UDim2.new(1, 0, 0, 20)
    self.TitleBar.Position = UDim2.new(0, 0, 0, 0)
    self.TitleBar.BackgroundColor3 = self.Colors.CollapseBtnColor
    self.TitleBar.BorderSizePixel = 0
    self.TitleBar.Parent = self.MainFrame
    
    -- Title Text
    self.TitleText = Instance.new("TextLabel")
    self.TitleText.Name = "TitleText"
    self.TitleText.Size = UDim2.new(0.7, 0, 1, 0)
    self.TitleText.Position = UDim2.new(0, 5, 0, 0)
    self.TitleText.BackgroundTransparency = 1
    self.TitleText.Text = self.Title
    self.TitleText.TextColor3 = self.Colors.TitleColor
    self.TitleText.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleText.Font = Enum.Font.Gotham
    self.TitleText.TextSize = 12
    self.TitleText.Parent = self.TitleBar
    
    -- Minimize Button
    self.MinimizeButton = Instance.new("TextButton")
    self.MinimizeButton.Name = "MinimizeButton"
    self.MinimizeButton.Size = UDim2.new(0, 20, 0, 20)
    self.MinimizeButton.Position = UDim2.new(1, -20, 0, 0)
    self.MinimizeButton.BackgroundColor3 = self.Colors.CollapseBtnColor
    self.MinimizeButton.BorderSizePixel = 0
    self.MinimizeButton.Text = "_"
    self.MinimizeButton.TextColor3 = self.Colors.TitleColor
    self.MinimizeButton.Font = Enum.Font.Gotham
    self.MinimizeButton.TextSize = 14
    self.MinimizeButton.Parent = self.TitleBar
    
    -- Scrolling Frame
    self.ScrollingFrame = Instance.new("ScrollingFrame")
    self.ScrollingFrame.Name = "ContentFrame"
    self.ScrollingFrame.Size = UDim2.new(1, 0, 1, -20)
    self.ScrollingFrame.Position = UDim2.new(0, 0, 0, 20)
    self.ScrollingFrame.BackgroundTransparency = 1
    self.ScrollingFrame.BorderSizePixel = 0
    self.ScrollingFrame.ScrollBarThickness = 5
    self.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.ScrollingFrame.Parent = self.MainFrame
    
    -- UIListLayout for elements
    self.UIListLayout = Instance.new("UIListLayout")
    self.UIListLayout.Padding = UDim.new(0, 5)
    self.UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    self.UIListLayout.Parent = self.ScrollingFrame
    
    -- Store original size for toggling
    self.OriginalSize = self.MainFrame.Size
    self.OriginalPosition = self.MainFrame.Position
    
    -- Connect minimize button
    self.MinimizeButton.MouseButton1Click:Connect(function()
        self:ToggleMinimize()
    end)
    
    -- Update canvas size when elements are added
    self.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, self.UIListLayout.AbsoluteContentSize.Y)
    end)
end

function UILibrary:ToggleMinimize()
    self.Minimized = not self.Minimized
    if self.Minimized then
        self.MainFrame.Size = UDim2.new(0, self.OriginalSize.X.Offset, 0, 20)
        self.MinimizeButton.Text = "+"
        self.ScrollingFrame.Visible = false
    else
        self.MainFrame.Size = self.OriginalSize
        self.MinimizeButton.Text = "_"
        self.ScrollingFrame.Visible = true
    end
end

function UILibrary:ToggleVisibility()
    self.Visible = not self.Visible
    self.ScreenGui.Enabled = self.Visible
end

function UILibrary:AddButton(config)
    local button = Instance.new("TextButton")
    button.Name = "Button_" .. config.Text
    button.Size = UDim2.new(0.9, 0, 0, 30)
    button.Position = UDim2.new(0.05, 0, 0, 0)
    button.BackgroundColor3 = self.Colors.ButtonColor
    button.BorderSizePixel = 0
    button.Text = config.Text
    button.TextColor3 = self.Colors.TitleColor
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.LayoutOrder = #self.Elements + 1
    button.Parent = self.ScrollingFrame
    
    if config.Callback then
        button.MouseButton1Click:Connect(config.Callback)
    end
    
    table.insert(self.Elements, button)
    return button
end

function UILibrary:AddToggle(config)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = "Toggle_" .. config.Text
    toggleFrame.Size = UDim2.new(0.9, 0, 0, 30)
    toggleFrame.Position = UDim2.new(0.05, 0, 0, 0)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.LayoutOrder = #self.Elements + 1
    toggleFrame.Parent = self.ScrollingFrame
    
    local toggleText = Instance.new("TextLabel")
    toggleText.Name = "TextLabel"
    toggleText.Size = UDim2.new(0.7, 0, 1, 0)
    toggleText.Position = UDim2.new(0, 0, 0, 0)
    toggleText.BackgroundTransparency = 1
    toggleText.Text = config.Text
    toggleText.TextColor3 = self.Colors.TitleColor
    toggleText.TextXAlignment = Enum.TextXAlignment.Left
    toggleText.Font = Enum.Font.Gotham
    toggleText.TextSize = 14
    toggleText.Parent = toggleFrame
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0.25, 0, 0.8, 0)
    toggleButton.Position = UDim2.new(0.75, 0, 0.1, 0)
    toggleButton.BackgroundColor3 = self.Colors.ToggleColor
    toggleButton.BorderSizePixel = 0
    toggleButton.Text = config.Default and "ON" or "OFF"
    toggleButton.TextColor3 = config.Default and self.Colors.ToggleColorON or self.Colors.ToggleColorOFF
    toggleButton.Font = Enum.Font.Gotham
    toggleButton.TextSize = 12
    toggleButton.Parent = toggleFrame
    
    local state = config.Default or false
    
    toggleButton.MouseButton1Click:Connect(function()
        state = not state
        if state then
            toggleButton.Text = "ON"
            toggleButton.TextColor3 = self.Colors.ToggleColorON
        else
            toggleButton.Text = "OFF"
            toggleButton.TextColor3 = self.Colors.ToggleColorOFF
        end
        
        if config.Callback then
            config.Callback(state)
        end
    end)
    
    table.insert(self.Elements, toggleFrame)
    return toggleFrame, function() return state end
end

function UILibrary:AddTextBox(config)
    local textBoxFrame = Instance.new("Frame")
    textBoxFrame.Name = "TextBox_" .. config.Text
    textBoxFrame.Size = UDim2.new(0.9, 0, 0, 50)
    textBoxFrame.Position = UDim2.new(0.05, 0, 0, 0)
    textBoxFrame.BackgroundTransparency = 1
    textBoxFrame.LayoutOrder = #self.Elements + 1
    textBoxFrame.Parent = self.ScrollingFrame
    
    local textBoxLabel = Instance.new("TextLabel")
    textBoxLabel.Name = "TextLabel"
    textBoxLabel.Size = UDim2.new(1, 0, 0.4, 0)
    textBoxLabel.Position = UDim2.new(0, 0, 0, 0)
    textBoxLabel.BackgroundTransparency = 1
    textBoxLabel.Text = config.Text
    textBoxLabel.TextColor3 = self.Colors.TitleColor
    textBoxLabel.TextXAlignment = Enum.TextXAlignment.Left
    textBoxLabel.Font = Enum.Font.Gotham
    textBoxLabel.TextSize = 14
    textBoxLabel.Parent = textBoxFrame
    
    local textBox = Instance.new("TextBox")
    textBox.Name = "TextBox"
    textBox.Size = UDim2.new(1, 0, 0.6, 0)
    textBox.Position = UDim2.new(0, 0, 0.4, 0)
    textBox.BackgroundColor3 = self.Colors.ButtonColor
    textBox.BorderSizePixel = 0
    textBox.Text = config.Default or ""
    textBox.TextColor3 = self.Colors.TitleColor
    textBox.Font = Enum.Font.Gotham
    textBox.TextSize = 12
    textBox.Parent = textBoxFrame
    
    if config.Callback then
        textBox.FocusLost:Connect(function(enterPressed)
            if not enterPressed and config.RequireEnter then return end
            config.Callback(textBox.Text)
        end)
    end
    
    table.insert(self.Elements, textBoxFrame)
    return textBoxFrame
end

function UILibrary:AddSeparator()
    local separator = Instance.new("Frame")
    separator.Name = "Separator"
    separator.Size = UDim2.new(0.9, 0, 0, 1)
    separator.Position = UDim2.new(0.05, 0, 0, 0)
    separator.BackgroundColor3 = self.Colors.SeparatorColor
    separator.BorderSizePixel = 0
    separator.LayoutOrder = #self.Elements + 1
    separator.Parent = self.ScrollingFrame
    
    table.insert(self.Elements, separator)
    return separator
end

function UILibrary:Destroy()
    self.ScreenGui:Destroy()
    self = nil
end

-- Example usage:
--[[
local UI = UILibrary.new({
    Title = "CoolGui",
    TitleColor = Color3.fromRGB(255, 255, 255),
    CollapseBtnColor = Color3.fromRGB(20, 20, 20),
    ButtonColor = Color3.fromRGB(40, 40, 40),
    ToggleColor = Color3.fromRGB(40, 40, 40),
    ToggleColorOFF = Color3.fromRGB(255, 0, 0),
    ToggleColorON = Color3.fromRGB(0, 255, 0),
    MainFrameColor = Color3.fromRGB(30, 30, 30),
    SeparatorColor = Color3.fromRGB(60, 60, 60)
})

UI:AddButton({
    Text = "Button",
    Callback = function()
        print("Clicked!")
    end
})

UI:AddToggle({
    Text = "Toggle",
    Default = false,
    Callback = function(value)
        print(value)
    end
})

UI:AddSeparator()

UI:AddTextBox({
    Text = "Text Box",
    Default = "Default text",
    Callback = function(value)
        print(value)
    end
})
]]

return UILibrary
