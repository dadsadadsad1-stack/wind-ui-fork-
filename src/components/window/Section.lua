local Section = {}


local Creator = require("../../modules/Creator")
local New = Creator.New
local Tween = Creator.Tween

local TabModule = require("./Tab")

function Section.New(SectionConfig, Parent, Folder, UIScale, Window)
    local SectionModule = {
        Title = SectionConfig.Title or "Section",
        Desc = SectionConfig.Desc,
        Badge = SectionConfig.Badge,
        Icon = SectionConfig.Icon,
        IconThemed = SectionConfig.IconThemed,
        Opened = SectionConfig.Opened or false,
        
        HeaderSize = 42,
        IconSize = 18,
        TextSize = SectionConfig.TextSize or 14,
        DescTextSize = SectionConfig.DescTextSize or 12,
        TextTransparency = SectionConfig.TextTransparency or .7,
        DescTextTransparency = SectionConfig.DescTextTransparency or .45,
        DescFontWeight = SectionConfig.DescFontWeight or Enum.FontWeight.Medium,
        
        Expandable = false,
    }
    
    local IconFrame
    if SectionModule.Icon then
        IconFrame = Creator.Image(
            SectionModule.Icon,
            SectionModule.Icon,
            0,
            Folder,
            "Section",
            true,
            SectionModule.IconThemed,
            "TabSectionIcon"
        )
        
        IconFrame.Size = UDim2.new(0,SectionModule.IconSize,0,SectionModule.IconSize)
        IconFrame.ImageLabel.ImageTransparency = .25
    end

    local TitleColumn = New("Frame", {
        Size = UDim2.new(1, IconFrame and (-SectionModule.IconSize-10)*2 or (-SectionModule.IconSize-10), 1, 0),
        BackgroundTransparency = 1,
        AutomaticSize = "Y",
    }, {})

    local TitleFrame = New("TextLabel", {
        Text = SectionModule.Title,
        TextXAlignment = "Left",
        AutomaticSize = "Y",
        Size = UDim2.new(1, 0, 0, 0),
        ThemeTag = {
            TextColor3 = "Text",
        },
        FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
        TextSize = SectionModule.TextSize,
        BackgroundTransparency = 1,
        TextTransparency = SectionModule.TextTransparency,
        TextWrapped = true
    }, {
        New("UIPadding", {
            PaddingTop = UDim.new(0, 0),
            PaddingBottom = UDim.new(0, 0),
        })
    })

    local DescFrame
    if SectionModule.Desc then
        DescFrame = New("TextLabel", {
            Text = SectionModule.Desc,
            TextXAlignment = "Left",
            AutomaticSize = "Y",
            Size = UDim2.new(1, 0, 0, 0),
            ThemeTag = {
                TextColor3 = "Text",
            },
            FontFace = Font.new(Creator.Font, SectionModule.DescFontWeight),
            TextSize = SectionModule.DescTextSize,
            BackgroundTransparency = 1,
            TextTransparency = SectionModule.DescTextTransparency,
            TextWrapped = true
        })
    end

    local function createBadge(text)
        local badgeText = tostring(text)
        return New("Frame", {
            BackgroundTransparency = 1,
            AutomaticSize = "XY",
        }, {
            New("Frame", {
                BackgroundTransparency = 0.88,
                BackgroundColor3 = Color3.new(1, 1, 1),
                AutomaticSize = "XY",
            }, {
                New("UICorner", {
                    CornerRadius = UDim.new(0, 999),
                }),
                New("TextLabel", {
                    BackgroundTransparency = 1,
                    AutomaticSize = "XY",
                    Text = badgeText,
                    TextSize = 11,
                    FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
                    TextTransparency = 0,
                    TextXAlignment = "Center",
                    TextYAlignment = "Center",
                    ThemeTag = { TextColor3 = "Text" },
                }, {
                    New("UIPadding", {
                        PaddingLeft = UDim.new(0, 8),
                        PaddingRight = UDim.new(0, 8),
                        PaddingTop = UDim.new(0, 2),
                        PaddingBottom = UDim.new(0, 2),
                    }),
                }),
            }),
        })
    end

    local BadgeFrame = SectionModule.Badge and createBadge(SectionModule.Badge) or nil
    
    local ChevronIconFrame = New("Frame", {
        Size = UDim2.new(0,SectionModule.IconSize,0,SectionModule.IconSize),
        BackgroundTransparency = 1,
        Visible = false
    }, {
        New("ImageLabel", {
            Size = UDim2.new(1,0,1,0),
            BackgroundTransparency = 1,
            Image = Creator.Icon("chevron-down")[1],
            ImageRectSize = Creator.Icon("chevron-down")[2].ImageRectSize,
            ImageRectOffset = Creator.Icon("chevron-down")[2].ImageRectPosition,
            ThemeTag = {
                ImageColor3 = "Icon",
            },
            ImageTransparency = .7,
        })
    })
    
    local TopButton = New("TextButton", {
            Size = UDim2.new(1,0,0,SectionModule.HeaderSize),
            BackgroundTransparency = 1,
            Text = "",
        }, {
            IconFrame,
            TitleColumn,
            BadgeFrame,
            New("UIListLayout", {
                FillDirection = "Horizontal",
                VerticalAlignment = "Center",
                Padding = UDim.new(0,10)
            }),
            ChevronIconFrame,
            New("UIPadding", {
                PaddingLeft = UDim.new(0,11),
                PaddingRight = UDim.new(0,11),
            })
        })

    local SectionFrame = New("Frame", {
        Size = UDim2.new(1,0,0,SectionModule.HeaderSize),
        BackgroundTransparency = 1,
        Parent = Parent,
        ClipsDescendants = true,
    }, {
        TopButton,
        New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1,0,0,0),
            AutomaticSize = "Y",
            Name = "Content",
            Visible = true,
            Position = UDim2.new(0,0,0,SectionModule.HeaderSize)
        }, {
            New("UIListLayout", {
                FillDirection = "Vertical",
                Padding = UDim.new(0,Window.Gap),
                VerticalAlignment = "Bottom",
            }),
        })
    })

    TitleFrame.Parent = TitleColumn
    if DescFrame then
        DescFrame.Parent = TitleColumn
    end
    New("UIListLayout", {
        Parent = TitleColumn,
        FillDirection = "Vertical",
        VerticalAlignment = "Center",
        Padding = UDim.new(0, 2),
    })
    
    local function UpdateHeaderSize()
        if DescFrame then
            SectionModule.HeaderSize = math.max(42, TitleFrame.AbsoluteSize.Y + DescFrame.AbsoluteSize.Y + 10)
            SectionFrame.Size = UDim2.new(1,0,0,SectionModule.Opened and SectionModule.HeaderSize + (SectionFrame.Content.AbsoluteSize.Y/UIScale) or SectionModule.HeaderSize)
            TopButton.Size = UDim2.new(1,0,0,SectionModule.HeaderSize)
        end
    end
    
    function SectionModule:Tab(TabConfig)
        if not SectionModule.Expandable then
            SectionModule.Expandable = true
            ChevronIconFrame.Visible = true
        end
        TabConfig.Parent = SectionFrame.Content
        return TabModule.New(TabConfig, UIScale)
    end

    function SectionModule:SetTitle(Title)
        SectionModule.Title = Title
        TitleFrame.Text = Title
    end

    function SectionModule:SetDesc(Desc)
        SectionModule.Desc = Desc
        if not DescFrame then
            DescFrame = New("TextLabel", {
                Text = Desc,
                TextXAlignment = "Left",
                AutomaticSize = "Y",
                Size = UDim2.new(1, 0, 0, 0),
                ThemeTag = {
                    TextColor3 = "Text",
                },
                FontFace = Font.new(Creator.Font, SectionModule.DescFontWeight),
                TextSize = SectionModule.DescTextSize,
                BackgroundTransparency = 1,
                TextTransparency = SectionModule.DescTextTransparency,
                TextWrapped = true
            })
            DescFrame.Parent = TitleColumn
        end
        DescFrame.Text = Desc
        UpdateHeaderSize()
    end

    function SectionModule:SetBadge(Badge)
        SectionModule.Badge = Badge
        if BadgeFrame then
            BadgeFrame:Destroy()
        end
        BadgeFrame = Badge and createBadge(Badge) or nil
        if BadgeFrame then
            BadgeFrame.Parent = TopButton
        end
    end
    
    function SectionModule:Open()
        if SectionModule.Expandable then
            SectionModule.Opened = true
            Tween(SectionFrame, 0.33, {
                Size = UDim2.new(1,0,0, SectionModule.HeaderSize + (SectionFrame.Content.AbsoluteSize.Y/UIScale))
            }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
            
            Tween(ChevronIconFrame.ImageLabel, 0.1, {Rotation = 180}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
        end
    end
    function SectionModule:Close()
        if SectionModule.Expandable then
            SectionModule.Opened = false
            Tween(SectionFrame, 0.26, {
                Size = UDim2.new(1,0,0, SectionModule.HeaderSize)
            }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
            Tween(ChevronIconFrame.ImageLabel, 0.1, {Rotation = 0}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
        end
    end
    
    Creator.AddSignal(TopButton.MouseButton1Click, function()
        if SectionModule.Expandable then
            if SectionModule.Opened then
                SectionModule:Close()
            else
                SectionModule:Open()
            end
        end
    end)
    
    Creator.AddSignal(SectionFrame.Content.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
        if SectionModule.Opened then
            SectionModule:Open()
        end
    end)

    if DescFrame then
        Creator.AddSignal(TitleFrame:GetPropertyChangedSignal("AbsoluteSize"), UpdateHeaderSize)
        Creator.AddSignal(DescFrame:GetPropertyChangedSignal("AbsoluteSize"), UpdateHeaderSize)
    end
    
    if SectionModule.Opened then
        task.spawn(function()
            task.wait()
            SectionModule:Open()
        end)
    end

    
    
    return SectionModule
end


return Section
