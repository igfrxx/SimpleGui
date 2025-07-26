local UILibrary = {}

-- Modern color palette
UILibrary.DefaultColors = {
    TitleColor = Color3.fromRGB(255, 255, 255),
    TitleBarColor = Color3.fromRGB(25, 25, 30),
    CollapseBtnColor = Color3.fromRGB(45, 45, 50),
    ButtonColor = Color3.fromRGB(50, 50, 60),
    ButtonHoverColor = Color3.fromRGB(65, 65, 75),
    ButtonTextColor = Color3.fromRGB(240, 240, 240),
    ToggleColor = Color3.fromRGB(50, 50, 60),
    ToggleColorOFF = Color3.fromRGB(200, 60, 60),
    ToggleColorON = Color3.fromRGB(80, 180, 80),
    MainFrameColor = Color3.fromRGB(35, 35, 40),
    SeparatorColor = Color3.fromRGB(80, 80, 90),
    TextBoxColor = Color3.fromRGB(45, 45, 55),
    TextBoxPlaceholderColor = Color3.fromRGB(150, 150, 150),
    AccentColor = Color3.fromRGB(100, 150, 255),
    ShadowColor = Color3.fromRGB(0, 0, 0, 0.5)
}

function UILibrary.new(config)
    local self = setmetatable({}, { __index = UILibrary })
    
    -- Configuration
    self.Title = config.Title or "UI Library"
    self.Size = config.Size or UDim2.new(0, 250, 0, 350)
    self.Position = config.Position or UDim2.new(0.5, -125, 0.5, -175)
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
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.Parent = game:GetService("CoreGui")
    
    -- Main Frame with drop shadow
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = self.Size
    self.MainFrame.Position = self.Position
    self.MainFrame.BackgroundColor3 = self.Colors.MainFrameColor
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Active = true
    self.MainFrame.Draggable = true
    self.MainFrame.ClipsDescendants = true
    self.MainFrame.Parent = self.ScreenGui
    
    -- Shadow effect
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 10, 1, 10)
    shadow.Position = UDim2.new(0, -5, 0, -5)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageColor3 = self.Colors.ShadowColor
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.Parent = self.MainFrame
    
    -- Title Bar with gradient
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Name = "TitleBar"
    self.TitleBar.Size = UDim2.new(1, 0, 0, 30)
    self.TitleBar.Position = UDim2.new(0, 0, 0, 0)
    self.TitleBar.BackgroundColor3 = self.Colors.TitleBarColor
    self.TitleBar.BorderSizePixel = 0
    self.TitleBar.ZIndex = 2
    self.TitleBar.Parent = self.MainFrame
    
    -- Gradient effect
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, self.Colors.TitleBarColor),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(
            math.floor(self.Colors.TitleBarColor.R * 255 * 0.8),
            math.floor(self.Colors.TitleBarColor.G * 255 * 0.8),
            math.floor(self.Colors.TitleBarColor.B * 255 * 0.8)
        ))
    }
    gradient.Rotation = 90
    gradient.Parent = self.TitleBar
    
    -- Title Text
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
    self.TitleText.ZIndex = 2
    self.TitleText.Parent = self.TitleBar
    
    -- Minimize Button
    self.MinimizeButton = Instance.new("TextButton")
    self.MinimizeButton.Name = "MinimizeButton"
    self.MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
    self.MinimizeButton.Position = UDim2.new(1, -30, 0, 0)
    self.MinimizeButton.BackgroundColor3 = self.Colors.CollapseBtnColor
    self.MinimizeButton.BorderSizePixel = 0
    self.MinimizeButton.Text = "-"
    self.MinimizeButton.TextColor3 = self.Colors.TitleColor
    self.MinimizeButton.Font = Enum.Font.GothamBold
    self.MinimizeButton.TextSize = 16
    self.MinimizeButton.ZIndex = 2
    self.MinimizeButton.Parent = self.TitleBar
    
    -- Button hover effect
    self.MinimizeButton.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(self.MinimizeButton, TweenInfo.new(0.1), {
            BackgroundColor3 = self.Colors.ButtonHoverColor
        }):Play()
    end)
    
    self.MinimizeButton.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(self.MinimizeButton, TweenInfo.new(0.1), {
            BackgroundColor3 = self.Colors.CollapseBtnColor
        }):Play()
    end)
    
    -- Scrolling Frame
    self.ScrollingFrame = Instance.new("ScrollingFrame")
    self.ScrollingFrame.Name = "ContentFrame"
    self.ScrollingFrame.Size = UDim2.new(1, 0, 1, -30)
    self.ScrollingFrame.Position = UDim2.new(0, 0, 0, 30)
    self.ScrollingFrame.BackgroundTransparency = 1
    self.ScrollingFrame.BorderSizePixel = 0
    self.ScrollingFrame.ScrollBarThickness = 5
    self.ScrollingFrame.ScrollBarImageColor3 = self.Colors.AccentColor
    self.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.ScrollingFrame.Parent = self.MainFrame
    
    -- UIListLayout for elements
    self.UIListLayout = Instance.new("UIListLayout")
    self.UIListLayout.Padding = UDim.new(0, 8)
    self.UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    self.UIListLayout.Parent = self.ScrollingFrame
    
    -- Padding
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)
    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingBottom = UDim.new(0, 10)
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
        self.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, self.UIListLayout.AbsoluteContentSize.Y + 20)
    end)
end

function UILibrary:ToggleMinimize()
    self.Minimized = not self.Minimized
    local tweenService = game:GetService("TweenService")
    
    if self.Minimized then
        -- Animate minimize
        tweenService:Create(self.MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, self.OriginalSize.X.Offset, 0, 30)
        }):Play()
        self.MinimizeButton.Text = "+"
        self.ScrollingFrame.Visible = false
    else
        -- Animate restore
        tweenService:Create(self.MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = self.OriginalSize
        }):Play()
        self.MinimizeButton.Text = "-"
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
    button.Size = UDim2.new(1, 0, 0, 35)
    button.BackgroundColor3 = self.Colors.ButtonColor
    button.BorderSizePixel = 0
    button.Text = config.Text
    button.TextColor3 = self.Colors.ButtonTextColor
    button.Font = Enum.Font.GothamSemibold
    button.TextSize = 14
    button.LayoutOrder = #self.Elements + 1
    button.AutoButtonColor = false
    button.Parent = self.ScrollingFrame
    
    -- Corner rounding
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = button
    
    -- Hover effects
    button.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(button, TweenInfo.new(0.1), {
            BackgroundColor3 = self.Colors.ButtonHoverColor,
            TextColor3 = self.Colors.TitleColor
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(button, TweenInfo.new(0.1), {
            BackgroundColor3 = self.Colors.ButtonColor,
            TextColor3 = self.Colors.ButtonTextColor
        }):Play()
    end)
    
    -- Click effect
    button.MouseButton1Down:Connect(function()
        game:GetService("TweenService"):Create(button, TweenInfo.new(0.05), {
            BackgroundColor3 = self.Colors.AccentColor,
            TextColor3 = Color3.new(1, 1, 1)
        }):Play()
    end)
    
    button.MouseButton1Up:Connect(function()
        game:GetService("TweenService"):Create(button, TweenInfo.new(0.1), {
            BackgroundColor3 = self.Colors.ButtonHoverColor,
            TextColor3 = self.Colors.TitleColor
        }):Play()
        
        if config.Callback then
            config.Callback()
        end
    end)
    
    table.insert(self.Elements, button)
    return button
end

function UILibrary:AddToggle(config)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = "Toggle_" .. config.Text
    toggleFrame.Size = UDim2.new(1, 0, 0, 30)
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
    toggleButton.Text = ""
    toggleButton.AutoButtonColor = false
    toggleButton.Parent = toggleFrame
    
    -- Corner rounding
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = toggleButton
    
    -- Toggle indicator
    local toggleIndicator = Instance.new("Frame")
    toggleIndicator.Name = "Indicator"
    toggleIndicator.Size = UDim2.new(0.45, 0, 0.8, 0)
    toggleIndicator.Position = config.Default and UDim2.new(0.55, 0, 0.1, 0) or UDim2.new(0, 0, 0.1, 0)
    toggleIndicator.BackgroundColor3 = config.Default and self.Colors.ToggleColorON or self.Colors.ToggleColorOFF
    toggleIndicator.BorderSizePixel = 0
    toggleIndicator.Parent = toggleButton
    
    -- Corner rounding for indicator
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(1, 0)
    indicatorCorner.Parent = toggleIndicator
    
    local state = config.Default or false
    
    -- Toggle animation
    local function animateToggle(newState)
        state = newState
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        
        if state then
            game:GetService("TweenService"):Create(toggleIndicator, tweenInfo, {
                Position = UDim2.new(0.55, 0, 0.1, 0),
                BackgroundColor3 = self.Colors.ToggleColorON
            }):Play()
        else
            game:GetService("TweenService"):Create(toggleIndicator, tweenInfo, {
                Position = UDim2.new(0, 0, 0.1, 0),
                BackgroundColor3 = self.Colors.ToggleColorOFF
            }):Play()
        end
        
        if config.Callback then
            config.Callback(state)
        end
    end
    
    -- Click handler
    toggleButton.MouseButton1Click:Connect(function()
        animateToggle(not state)
    end)
    
    -- Hover effects
    toggleButton.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(toggleButton, TweenInfo.new(0.1), {
            BackgroundColor3 = self.Colors.ButtonHoverColor
        }):Play()
    end)
    
    toggleButton.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(toggleButton, TweenInfo.new(0.1), {
            BackgroundColor3 = self.Colors.ToggleColor
        }):Play()
    end)
    
    table.insert(self.Elements, toggleFrame)
    return toggleFrame, function() return state end, function(newState) animateToggle(newState) end
end

function UILibrary:AddTextBox(config)
    local textBoxFrame = Instance.new("Frame")
    textBoxFrame.Name = "TextBox_" .. config.Text
    textBoxFrame.Size = UDim2.new(1, 0, 0, 60)
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
    textBox.BackgroundColor3 = self.Colors.TextBoxColor
    textBox.BorderSizePixel = 0
    textBox.Text = config.Default or ""
    textBox.PlaceholderText = config.Placeholder or ""
    textBox.TextColor3 = self.Colors.TitleColor
    textBox.PlaceholderColor3 = self.Colors.TextBoxPlaceholderColor
    textBox.Font = Enum.Font.Gotham
    textBox.TextSize = 12
    textBox.ClearTextOnFocus = false
    textBox.Parent = textBoxFrame
    
    -- Corner rounding
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = textBox
    
    -- Focus effects
    textBox.Focused:Connect(function()
        game:GetService("TweenService"):Create(textBox, TweenInfo.new(0.1), {
            BackgroundColor3 = self.Colors.ButtonHoverColor
        }):Play()
    end)
    
    textBox.FocusLost:Connect(function()
        game:GetService("TweenService"):Create(textBox, TweenInfo.new(0.1), {
            BackgroundColor3 = self.Colors.TextBoxColor
        }):Play()
        
        if config.Callback then
            local enterPressed = not config.RequireEnter or false
            config.Callback(textBox.Text, enterPressed)
        end
    end)
    
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

function UILibrary:AddLabel(text)
    local label = Instance.new("TextLabel")
    label.Name = "Label_" .. text
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = self.Colors.TitleColor
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.LayoutOrder = #self.Elements + 1
    label.Parent = self.ScrollingFrame
    
    table.insert(self.Elements, label)
    return label
end

function UILibrary:Destroy()
    self.ScreenGui:Destroy()
    self = nil
end

return UILibrary
