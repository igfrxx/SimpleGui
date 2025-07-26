-- slider, keybind and dropdown are WIP

local UILibrary = {}

-- cool colors
UILibrary.DefaultColors = {
    TitleColor = Color3.fromRGB(255, 255, 255),
    CollapseBtnColor = Color3.fromRGB(25, 25, 25),
    ButtonColor = Color3.fromRGB(45, 45, 45),
    ButtonHoverColor = Color3.fromRGB(60, 60, 60),
    ToggleColor = Color3.fromRGB(45, 45, 45),
    ToggleColorOFF = Color3.fromRGB(200, 60, 60),
    ToggleColorON = Color3.fromRGB(60, 200, 60),
    MainFrameColor = Color3.fromRGB(35, 35, 35),
    SeparatorColor = Color3.fromRGB(70, 70, 70),
    TextBoxColor = Color3.fromRGB(45, 45, 45),
    AccentColor = Color3.fromRGB(0, 120, 215),
    SectionColor = Color3.fromRGB(80, 80, 80),
    LabelColor = Color3.fromRGB(200, 200, 200),
    SliderColor = Color3.fromRGB(60, 60, 60),
    SliderHandleColor = Color3.fromRGB(100, 100, 100)
}

UILibrary.DefaultConfig = {
    Title = "UI Library",
    TitleText = "UI Library",
    Size = UDim2.new(0, 250, 0, 350),
    Position = UDim2.new(0.5, -125, 0.5, -175),
    TitleHeight = 30,
    CornerRadius = 6,
    ElementPadding = 6,
    Font = Enum.Font.GothamSemibold,
    TextSize = 12,
    SectionHeight = 20
}

function UILibrary.new(config)
    local self = setmetatable({}, { __index = UILibrary })
    
    self.Config = {}
    for k, v in pairs(UILibrary.DefaultConfig) do
        self.Config[k] = config[k] or v
    end
    
    self.Colors = {}
    for colorName, defaultColor in pairs(UILibrary.DefaultColors) do
        self.Colors[colorName] = config[colorName] or defaultColor
    end
    
    self.Elements = {}
    self.Visible = true
    self.Minimized = false
    
    self:CreateUI()
    
    return self
end

function UILibrary:CreateUI()
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "UILibrary"
    self.ScreenGui.Parent = game:GetService("CoreGui")
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = self.Config.Size
    self.MainFrame.Position = self.Config.Position
    self.MainFrame.BackgroundColor3 = self.Colors.MainFrameColor
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Active = true
    self.MainFrame.Draggable = true
    self.MainFrame.ClipsDescendants = true
    self.MainFrame.Parent = self.ScreenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, self.Config.CornerRadius)
    corner.Parent = self.MainFrame
    
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Name = "TitleBar"
    self.TitleBar.Size = UDim2.new(1, 0, 0, self.Config.TitleHeight)
    self.TitleBar.Position = UDim2.new(0, 0, 0, 0)
    self.TitleBar.BackgroundColor3 = self.Colors.CollapseBtnColor
    self.TitleBar.BorderSizePixel = 0
    self.TitleBar.ZIndex = 2
    self.TitleBar.Parent = self.MainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, self.Config.CornerRadius)
    titleCorner.Parent = self.TitleBar
    
    self.TitleText = Instance.new("TextLabel")
    self.TitleText.Name = "TitleText"
    self.TitleText.Size = UDim2.new(0.7, 0, 1, 0)
    self.TitleText.Position = UDim2.new(0, 12, 0, 0)
    self.TitleText.BackgroundTransparency = 1
    self.TitleText.Text = self.Config.TitleText
    self.TitleText.TextColor3 = self.Colors.TitleColor
    self.TitleText.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleText.Font = Enum.Font.GothamBold
    self.TitleText.TextSize = 14
    self.TitleText.ZIndex = 3
    self.TitleText.Parent = self.TitleBar
    
    self.MinimizeButton = Instance.new("TextButton")
    self.MinimizeButton.Name = "MinimizeButton"
    self.MinimizeButton.Size = UDim2.new(0, self.Config.TitleHeight, 0, self.Config.TitleHeight)
    self.MinimizeButton.Position = UDim2.new(1, -self.Config.TitleHeight, 0, 0)
    self.MinimizeButton.BackgroundColor3 = self.Colors.CollapseBtnColor
    self.MinimizeButton.BorderSizePixel = 0
    self.MinimizeButton.Text = "-"
    self.MinimizeButton.TextColor3 = self.Colors.TitleColor
    self.MinimizeButton.Font = Enum.Font.GothamBold
    self.MinimizeButton.TextSize = 18
    self.MinimizeButton.ZIndex = 3
    self.MinimizeButton.Parent = self.TitleBar
    
    local minCorner = Instance.new("UICorner")
    minCorner.CornerRadius = UDim.new(0, self.Config.CornerRadius)
    minCorner.Parent = self.MinimizeButton
    
    self.ScrollingFrame = Instance.new("ScrollingFrame")
    self.ScrollingFrame.Name = "ContentFrame"
    self.ScrollingFrame.Size = UDim2.new(1, 0, 1, -self.Config.TitleHeight)
    self.ScrollingFrame.Position = UDim2.new(0, 0, 0, self.Config.TitleHeight)
    self.ScrollingFrame.BackgroundTransparency = 1
    self.ScrollingFrame.BorderSizePixel = 0
    self.ScrollingFrame.ScrollBarThickness = 4
    self.ScrollingFrame.ScrollBarImageColor3 = self.Colors.AccentColor
    self.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.ScrollingFrame.Parent = self.MainFrame
    
    self.UIListLayout = Instance.new("UIListLayout")
    self.UIListLayout.Padding = UDim.new(0, self.Config.ElementPadding)
    self.UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    self.UIListLayout.Parent = self.ScrollingFrame
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 12)
    padding.PaddingRight = UDim.new(0, 12)
    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingBottom = UDim.new(0, 10)
    padding.Parent = self.ScrollingFrame
    
    self.OriginalSize = self.MainFrame.Size
    self.OriginalPosition = self.MainFrame.Position
    
    self.MinimizeButton.MouseButton1Click:Connect(function()
        self:ToggleMinimize()
    end)
    
    self.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, self.UIListLayout.AbsoluteContentSize.Y + 15)
    end)
    
    self.TitleBar.MouseEnter:Connect(function()
        self.TitleBar.BackgroundColor3 = Color3.new(
            self.Colors.CollapseBtnColor.R * 1.2,
            self.Colors.CollapseBtnColor.G * 1.2,
            self.Colors.CollapseBtnColor.B * 1.2
        )
    end)
    
    self.TitleBar.MouseLeave:Connect(function()
        self.TitleBar.BackgroundColor3 = self.Colors.CollapseBtnColor
    end)
end

function UILibrary:ToggleMinimize()
    self.Minimized = not self.Minimized
    if self.Minimized then
        self.MainFrame.Size = UDim2.new(0, self.OriginalSize.X.Offset, 0, self.Config.TitleHeight)
        self.MinimizeButton.Text = "+"
        self.ScrollingFrame.Visible = false
    else
        self.MainFrame.Size = self.OriginalSize
        self.MinimizeButton.Text = "-"
        self.ScrollingFrame.Visible = true
    end
end

function UILibrary:ToggleVisibility()
    self.Visible = not self.Visible
    self.ScreenGui.Enabled = self.Visible
end

function UILibrary:SetTitle(newTitle)
    self.Config.TitleText = newTitle
    self.TitleText.Text = newTitle
end

function UILibrary:AddSection(text)
    local section = Instance.new("Frame")
    section.Name = "Section_" .. text
    section.Size = UDim2.new(1, -24, 0, self.Config.SectionHeight)
    section.Position = UDim2.new(0, 12, 0, 0)
    section.BackgroundTransparency = 1
    section.LayoutOrder = #self.Elements + 1
    section.Parent = self.ScrollingFrame
    
    local sectionText = Instance.new("TextLabel")
    sectionText.Name = "TextLabel"
    sectionText.Size = UDim2.new(1, 0, 1, 0)
    sectionText.Position = UDim2.new(0, 0, 0, 0)
    sectionText.BackgroundTransparency = 1
    sectionText.Text = text
    sectionText.TextColor3 = self.Colors.SectionColor
    sectionText.TextXAlignment = Enum.TextXAlignment.Left
    sectionText.Font = Enum.Font.GothamBold
    sectionText.TextSize = self.Config.TextSize + 1
    sectionText.Parent = section
    
    table.insert(self.Elements, section)
    return section
end

function UILibrary:AddLabel(text)
    local label = Instance.new("TextLabel")
    label.Name = "Label_" .. text
    label.Size = UDim2.new(1, -24, 0, 18)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = self.Colors.LabelColor
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = self.Config.Font
    label.TextSize = self.Config.TextSize
    label.LayoutOrder = #self.Elements + 1
    label.Parent = self.ScrollingFrame
    
    table.insert(self.Elements, label)
    return label
end

function UILibrary:AddButton(config)
    local button = Instance.new("TextButton")
    button.Name = "Button_" .. config.Text
    button.Size = UDim2.new(1, -24, 0, 30)
    button.Position = UDim2.new(0, 12, 0, 0)
    button.BackgroundColor3 = self.Colors.ButtonColor
    button.BorderSizePixel = 0
    button.Text = config.Text
    button.TextColor3 = self.Colors.TitleColor
    button.Font = self.Config.Font
    button.TextSize = self.Config.TextSize
    button.LayoutOrder = #self.Elements + 1
    button.AutoButtonColor = false
    button.Parent = self.ScrollingFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = button
    
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = self.Colors.ButtonHoverColor
    end)
    
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = self.Colors.ButtonColor
    end)
    
    if config.Callback then
        button.MouseButton1Click:Connect(function()
            local originalSize = button.Size
            button.Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset, originalSize.Y.Scale, originalSize.Y.Offset - 2)
            task.wait(0.08)
            button.Size = originalSize
            
            config.Callback()
        end)
    end
    
    table.insert(self.Elements, button)
    return button
end

function UILibrary:AddToggle(config)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = "Toggle_" .. config.Text
    toggleFrame.Size = UDim2.new(1, -24, 0, 26)
    toggleFrame.Position = UDim2.new(0, 12, 0, 0)
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
    toggleText.Font = self.Config.Font
    toggleText.TextSize = self.Config.TextSize
    toggleText.Parent = toggleFrame
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0.25, 0, 0.8, 0)
    toggleButton.Position = UDim2.new(0.75, 0, 0.1, 0)
    toggleButton.BackgroundColor3 = self.Colors.ToggleColor
    toggleButton.BorderSizePixel = 0
    toggleButton.Text = config.Default and "ON" or "OFF"
    toggleButton.TextColor3 = config.Default and self.Colors.ToggleColorON or self.Colors.ToggleColorOFF
    toggleButton.Font = self.Config.Font
    toggleButton.TextSize = self.Config.TextSize - 1
    toggleButton.AutoButtonColor = false
    toggleButton.Parent = toggleFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = toggleButton
    
    local state = config.Default or false
    
    toggleButton.MouseEnter:Connect(function()
        toggleButton.BackgroundColor3 = Color3.new(
            self.Colors.ToggleColor.R * 1.1,
            self.Colors.ToggleColor.G * 1.1,
            self.Colors.ToggleColor.B * 1.1
        )
    end)
    
    toggleButton.MouseLeave:Connect(function()
        toggleButton.BackgroundColor3 = self.Colors.ToggleColor
    end)
    
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
    textBoxFrame.Size = UDim2.new(1, -24, 0, 50)
    textBoxFrame.Position = UDim2.new(0, 12, 0, 0)
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
    textBoxLabel.Font = self.Config.Font
    textBoxLabel.TextSize = self.Config.TextSize
    textBoxLabel.Parent = textBoxFrame
    
    local textBox = Instance.new("TextBox")
    textBox.Name = "TextBox"
    textBox.Size = UDim2.new(1, 0, 0.6, 0)
    textBox.Position = UDim2.new(0, 0, 0.4, 0)
    textBox.BackgroundColor3 = self.Colors.TextBoxColor
    textBox.BorderSizePixel = 0
    textBox.Text = config.Default or ""
    textBox.TextColor3 = self.Colors.TitleColor
    textBox.Font = self.Config.Font
    textBox.TextSize = self.Config.TextSize
    textBox.PlaceholderText = config.Placeholder or ""
    textBox.PlaceholderColor3 = Color3.new(0.7, 0.7, 0.7)
    textBox.Parent = textBoxFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = textBox
    
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
    separator.Size = UDim2.new(1, -24, 0, 1)
    separator.Position = UDim2.new(0, 12, 0, 0)
    separator.BackgroundColor3 = self.Colors.SeparatorColor
    separator.BorderSizePixel = 0
    separator.LayoutOrder = #self.Elements + 1
    separator.Parent = self.ScrollingFrame
    
    table.insert(self.Elements, separator)
    return separator
end

function UILibrary:AddSlider(config)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = "Slider_" .. config.Text
    sliderFrame.Size = UDim2.new(1, -24, 0, 50)
    sliderFrame.Position = UDim2.new(0, 12, 0, 0)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.LayoutOrder = #self.Elements + 1
    sliderFrame.Parent = self.ScrollingFrame
    
    local sliderText = Instance.new("TextLabel")
    sliderText.Name = "TextLabel"
    sliderText.Size = UDim2.new(1, 0, 0.4, 0)
    sliderText.Position = UDim2.new(0, 0, 0, 0)
    sliderText.BackgroundTransparency = 1
    sliderText.Text = config.Text .. ": " .. config.Default
    sliderText.TextColor3 = self.Colors.TitleColor
    sliderText.TextXAlignment = Enum.TextXAlignment.Left
    sliderText.Font = self.Config.Font
    sliderText.TextSize = self.Config.TextSize
    sliderText.Parent = sliderFrame
    
    local sliderTrack = Instance.new("Frame")
    sliderTrack.Name = "Track"
    sliderTrack.Size = UDim2.new(1, 0, 0.25, 0)
    sliderTrack.Position = UDim2.new(0, 0, 0.7, 0)
    sliderTrack.BackgroundColor3 = self.Colors.SliderColor
    sliderTrack.BorderSizePixel = 0
    sliderTrack.Parent = sliderFrame
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(1, 0)
    sliderCorner.Parent = sliderTrack
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "Fill"
    sliderFill.Size = UDim2.new((config.Default - config.Min) / (config.Max - config.Min), 0, 1, 0)
    sliderFill.BackgroundColor3 = self.Colors.AccentColor
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderTrack
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = sliderFill
    
    local sliderHandle = Instance.new("TextButton")
    sliderHandle.Name = "Handle"
    sliderHandle.Size = UDim2.new(0, 16, 0, 16)
    sliderHandle.Position = UDim2.new(sliderFill.Size.X.Scale, -8, 0.5, -8)
    sliderHandle.BackgroundColor3 = self.Colors.SliderHandleColor
    sliderHandle.BorderSizePixel = 0
    sliderHandle.Text = ""
    sliderHandle.AutoButtonColor = false
    sliderHandle.ZIndex = 2
    sliderHandle.Parent = sliderTrack
    
    local handleCorner = Instance.new("UICorner")
    handleCorner.CornerRadius = UDim.new(1, 0)
    handleCorner.Parent = sliderHandle
    
    local dragging = false
    local currentValue = config.Default
    
    local function updateSlider(value)
        value = math.clamp(value, config.Min, config.Max)
        currentValue = value
        sliderFill.Size = UDim2.new((value - config.Min) / (config.Max - config.Min), 0, 1, 0)
        sliderHandle.Position = UDim2.new(sliderFill.Size.X.Scale, -8, 0.5, -8)
        sliderText.Text = config.Text .. ": " .. math.floor(value)
        
        if config.Callback then
            config.Callback(value)
        end
    end
    
    sliderHandle.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = game:GetService("UserInputService"):GetMouseLocation()
            local trackPos = sliderTrack.AbsolutePosition
            local trackSize = sliderTrack.AbsoluteSize
            local relativeX = (mousePos.X - trackPos.X) / trackSize.X
            local value = config.Min + (config.Max - config.Min) * relativeX
            updateSlider(value)
        end
    end)
    
    table.insert(self.Elements, sliderFrame)
    return sliderFrame
end

function UILibrary:Destroy()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
    self = nil
end

return UILibrary
