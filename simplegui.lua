local UILibrary = {}

-- Modern color palette
UILibrary.DefaultColors = {
    TitleColor = Color3.fromRGB(255, 255, 255),
    CollapseBtnColor = Color3.fromRGB(25, 25, 25),
    ButtonColor = Color3.fromRGB(45, 45, 45),
    ButtonHoverColor = Color3.fromRGB(60, 60, 60),
    ToggleColor = Color3.fromRGB(45, 45, 45),
    ToggleColorOFF = Color3.fromRGB(200, 50, 50),
    ToggleColorON = Color3.fromRGB(50, 200, 50),
    MainFrameColor = Color3.fromRGB(35, 35, 35),
    SeparatorColor = Color3.fromRGB(70, 70, 70),
    TextBoxColor = Color3.fromRGB(45, 45, 45),
    AccentColor = Color3.fromRGB(0, 120, 215)
}

function UILibrary.new(config)
    local self = setmetatable({}, { __index = UILibrary })
    
    -- Configuration with smaller default size
    self.Title = config.Title or "UI Library"
    self.Size = config.Size or UDim2.new(0, 180, 0, 250) -- Smaller default size
    self.Position = config.Position or UDim2.new(0.5, -90, 0.5, -125) -- Adjusted for new size
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
    
    -- Main Frame with rounded corners
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = self.Size
    self.MainFrame.Position = self.Position
    self.MainFrame.BackgroundColor3 = self.Colors.MainFrameColor
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Active = true
    self.MainFrame.Draggable = true
    
    -- Add corner rounding
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = self.MainFrame
    
    self.MainFrame.Parent = self.ScreenGui
    
    -- Title Bar with accent color
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Name = "TitleBar"
    self.TitleBar.Size = UDim2.new(1, 0, 0, 24) -- Slightly taller for better appearance
    self.TitleBar.Position = UDim2.new(0, 0, 0, 0)
    self.TitleBar.BackgroundColor3 = self.Colors.AccentColor
    self.TitleBar.BorderSizePixel = 0
    
    -- Round only top corners
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 6)
    titleCorner.Parent = self.TitleBar
    
    self.TitleBar.Parent = self.MainFrame
    
    -- Title Text with better typography
    self.TitleText = Instance.new("TextLabel")
    self.TitleText.Name = "TitleText"
    self.TitleText.Size = UDim2.new(0.7, 0, 1, 0)
    self.TitleText.Position = UDim2.new(0, 10, 0, 0)
    self.TitleText.BackgroundTransparency = 1
    self.TitleText.Text = self.Title
    self.TitleText.TextColor3 = self.Colors.TitleColor
    self.TitleText.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleText.Font = Enum.Font.GothamSemibold
    self.TitleText.TextSize = 14
    self.TitleText.Parent = self.TitleBar
    
    -- Minimize Button with better styling
    self.MinimizeButton = Instance.new("TextButton")
    self.MinimizeButton.Name = "MinimizeButton"
    self.MinimizeButton.Size = UDim2.new(0, 24, 0, 24)
    self.MinimizeButton.Position = UDim2.new(1, -24, 0, 0)
    self.MinimizeButton.BackgroundColor3 = Color3.new(1, 1, 1)
    self.MinimizeButton.BackgroundTransparency = 1
    self.MinimizeButton.BorderSizePixel = 0
    self.MinimizeButton.Text = "─"
    self.MinimizeButton.TextColor3 = self.Colors.TitleColor
    self.MinimizeButton.Font = Enum.Font.GothamBold
    self.MinimizeButton.TextSize = 16
    
    -- Button hover effect
    self.MinimizeButton.MouseEnter:Connect(function()
        self.MinimizeButton.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    end)
    
    self.MinimizeButton.MouseLeave:Connect(function()
        self.MinimizeButton.TextColor3 = self.Colors.TitleColor
    end)
    
    self.MinimizeButton.Parent = self.TitleBar
    
    -- Scrolling Frame
    self.ScrollingFrame = Instance.new("ScrollingFrame")
    self.ScrollingFrame.Name = "ContentFrame"
    self.ScrollingFrame.Size = UDim2.new(1, 0, 1, -24)
    self.ScrollingFrame.Position = UDim2.new(0, 0, 0, 24)
    self.ScrollingFrame.BackgroundTransparency = 1
    self.ScrollingFrame.BorderSizePixel = 0
    self.ScrollingFrame.ScrollBarThickness = 4
    self.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.ScrollingFrame.ScrollBarImageColor3 = self.Colors.AccentColor
    self.ScrollingFrame.Parent = self.MainFrame
    
    -- UIListLayout for elements with padding
    self.UIListLayout = Instance.new("UIListLayout")
    self.UIListLayout.Padding = UDim.new(0, 8) -- More compact spacing
    self.UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    self.UIListLayout.Parent = self.ScrollingFrame
    
    -- Add padding to the content
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 8)
    padding.PaddingRight = UDim.new(0, 8)
    padding.PaddingTop = UDim.new(0, 8)
    padding.PaddingBottom = UDim.new(0, 8)
    padding.Parent = self.ScrollingFrame
    
    -- Store original size for toggling
    self.OriginalSize = self.MainFrame.Size
    self.OriginalPosition = self.MainFrame.Position
    
    -- Connect minimize button
    self.MinimizeButton.MouseButton1Click:Connect(function()
        self:ToggleMinimize()
    end)
    
    -- Update canvas size when elements are added
    self.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, self.UIListLayout.AbsoluteContentSize.Y + 16)
    end)
end

function UILibrary:ToggleMinimize()
    self.Minimized = not self.Minimized
    if self.Minimized then
        self.MainFrame.Size = UDim2.new(0, self.OriginalSize.X.Offset, 0, 24)
        self.MinimizeButton.Text = "+"
        self.ScrollingFrame.Visible = false
    else
        self.MainFrame.Size = self.OriginalSize
        self.MinimizeButton.Text = "─"
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
    button.Size = UDim2.new(1, 0, 0, 28) -- More compact button
    button.BackgroundColor3 = self.Colors.ButtonColor
    button.BorderSizePixel = 0
    button.Text = config.Text
    button.TextColor3 = self.Colors.TitleColor
    button.Font = Enum.Font.Gotham
    button.TextSize = 13
    button.LayoutOrder = #self.Elements + 1
    
    -- Add rounded corners
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = button
    
    -- Hover effect
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = self.Colors.ButtonHoverColor
    end)
    
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = self.Colors.ButtonColor
    end)
    
    if config.Callback then
        button.MouseButton1Click:Connect(function()
            -- Pulse effect on click
            local originalSize = button.Size
            button.Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset - 2, originalSize.Y.Scale, originalSize.Y.Offset - 2)
            task.wait(0.1)
            button.Size = originalSize
            
            config.Callback()
        end)
    end
    
    button.Parent = self.ScrollingFrame
    
    table.insert(self.Elements, button)
    return button
end

function UILibrary:AddToggle(config)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = "Toggle_" .. config.Text
    toggleFrame.Size = UDim2.new(1, 0, 0, 28) -- More compact
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.LayoutOrder = #self.Elements + 1
    
    local toggleText = Instance.new("TextLabel")
    toggleText.Name = "TextLabel"
    toggleText.Size = UDim2.new(0.7, 0, 1, 0)
    toggleText.Position = UDim2.new(0, 0, 0, 0)
    toggleText.BackgroundTransparency = 1
    toggleText.Text = config.Text
    toggleText.TextColor3 = self.Colors.TitleColor
    toggleText.TextXAlignment = Enum.TextXAlignment.Left
    toggleText.Font = Enum.Font.Gotham
    toggleText.TextSize = 13
    toggleText.Parent = toggleFrame
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0.25, 0, 0.7, 0)
    toggleButton.Position = UDim2.new(0.75, 0, 0.15, 0)
    toggleButton.BackgroundColor3 = self.Colors.ToggleColor
    toggleButton.BorderSizePixel = 0
    toggleButton.Text = config.Default and "ON" or "OFF"
    toggleButton.TextColor3 = config.Default and self.Colors.ToggleColorON or self.Colors.ToggleColorOFF
    toggleButton.Font = Enum.Font.GothamSemibold
    toggleButton.TextSize = 12
    
    -- Add rounded corners
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = toggleButton
    
    local state = config.Default or false
    
    toggleButton.MouseButton1Click:Connect(function()
        state = not state
        if state then
            toggleButton.Text = "ON"
            toggleButton.TextColor3 = self.Colors.ToggleColorON
            toggleButton.BackgroundColor3 = Color3.new(0.1, 0.4, 0.1)
        else
            toggleButton.Text = "OFF"
            toggleButton.TextColor3 = self.Colors.ToggleColorOFF
            toggleButton.BackgroundColor3 = Color3.new(0.4, 0.1, 0.1)
        end
        
        if config.Callback then
            config.Callback(state)
        end
    end)
    
    -- Initialize state
    if state then
        toggleButton.BackgroundColor3 = Color3.new(0.1, 0.4, 0.1)
    else
        toggleButton.BackgroundColor3 = Color3.new(0.4, 0.1, 0.1)
    end
    
    toggleButton.Parent = toggleFrame
    toggleFrame.Parent = self.ScrollingFrame
    
    table.insert(self.Elements, toggleFrame)
    return toggleFrame, function() return state end
end

function UILibrary:AddTextBox(config)
    local textBoxFrame = Instance.new("Frame")
    textBoxFrame.Name = "TextBox_" .. config.Text
    textBoxFrame.Size = UDim2.new(1, 0, 0, 50) -- More compact
    textBoxFrame.BackgroundTransparency = 1
    textBoxFrame.LayoutOrder = #self.Elements + 1
    
    local textBoxLabel = Instance.new("TextLabel")
    textBoxLabel.Name = "TextLabel"
    textBoxLabel.Size = UDim2.new(1, 0, 0.4, 0)
    textBoxLabel.Position = UDim2.new(0, 0, 0, 0)
    textBoxLabel.BackgroundTransparency = 1
    textBoxLabel.Text = config.Text
    textBoxLabel.TextColor3 = self.Colors.TitleColor
    textBoxLabel.TextXAlignment = Enum.TextXAlignment.Left
    textBoxLabel.Font = Enum.Font.Gotham
    textBoxLabel.TextSize = 13
    textBoxLabel.Parent = textBoxFrame
    
    local textBox = Instance.new("TextBox")
    textBox.Name = "TextBox"
    textBox.Size = UDim2.new(1, 0, 0.6, 0)
    textBox.Position = UDim2.new(0, 0, 0.4, 0)
    textBox.BackgroundColor3 = self.Colors.TextBoxColor
    textBox.BorderSizePixel = 0
    textBox.Text = config.Default or ""
    textBox.TextColor3 = self.Colors.TitleColor
    textBox.Font = Enum.Font.Gotham
    textBox.TextSize = 12
    textBox.PlaceholderText = config.Placeholder or ""
    textBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    
    -- Add rounded corners
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = textBox
    
    -- Add padding
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 8)
    padding.PaddingRight = UDim.new(0, 8)
    padding.Parent = textBox
    
    if config.Callback then
        textBox.FocusLost:Connect(function(enterPressed)
            if not enterPressed and config.RequireEnter then return end
            config.Callback(textBox.Text)
        end)
    end
    
    textBox.Parent = textBoxFrame
    textBoxFrame.Parent = self.ScrollingFrame
    
    table.insert(self.Elements, textBoxFrame)
    return textBoxFrame
end

function UILibrary:AddSeparator()
    local separator = Instance.new("Frame")
    separator.Name = "Separator"
    separator.Size = UDim2.new(1, 0, 0, 1)
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

return UILibrary
