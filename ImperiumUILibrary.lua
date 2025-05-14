--[[
  //Imperium NewLibrary
  //Fully coded by sentrysvc on discord, Coded in pascal case, hope you're happy laera bbg
  //Inspired by Fluent :weary:
]]

--// StartUp
local Library = {}
local Lucide 
local FontType = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
local BoldFontType = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
local Imperium = Instance.new("ScreenGui")

--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local TextService = game:GetService("TextService")

local LocalPlayer = Players.LocalPlayer

--// Usefull
local Core
local Rank = "Member"
local Version 
local RankColor
local Whitelisted 
local WhitelistedName
local IsExecutionEnv = false
local IsMobileDevice = false
local GamePlace = game.PlaceId
local IsInColorFrameDrag = false

--// Config Vars
local Config = {
	SliderSpeed = 0.2,
	ToggleSpeed = 0.3,
	GuiDragSpeed = 0.5,

	MainColor = {52, 52, 52},
	MainShadow = {15, 13, 63},
	MainShadowTransparecy = 0.48,
	GlobalDescriptionColor = {144, 144, 144},

	MinimizeKeybind = "RightControl",

	["FileSaving"] = {
		FolderName = "Imperium",
		GuiName = "Imperium Hub",
		SettingsPath = "Imperium/Settings.lua",
		ConfigPath = "Imperium/Config",
		Configs = "Imperium/Config/".. tostring(GamePlace) .. ".lua",
	},

	["Github"] = {
		Branch = "https://raw.githubusercontent.com/",
		HostName = "Severity-svc/",
		GlobalExtension = ".lua",
	},

	["Themes"] = {
		"coming soon"
	}
}

local FileBranch = Config.FileSaving

if RunService:IsStudio() then
	Core = LocalPlayer:WaitForChild("PlayerGui")
	Lucide = require(script.Parent:WaitForChild("Lucide"))
else
	Lucide = loadstring(game:HttpGet('https://raw.githubusercontent.com/saintsrevival1/imperium/refs/heads/main/icons'))()
	Core = game:GetService("CoreGui")
	Version = loadstring(game:HttpGet('https://raw.githubusercontent.com/Severity-svc/Ventures/refs/heads/main/Version.lua'))()
	
	local Analystics = game:GetService("RbxAnalyticsService")

	if not isfolder(FileBranch.FolderName) then makefolder(FileBranch.FolderName) end
	if not isfolder(FileBranch.GuiName) then makefolder(FileBranch.GuiName) end
	if not isfolder(FileBranch.ConfigPath) then makefolder(FileBranch.ConfigPath) end
	if not isfile(FileBranch.Configs) then writefile(FileBranch.Configs, "{}") end

	local function SaveGlobals()
		local success, json = pcall(function()
			return HttpService:JSONEncode(Config)
		end)
		if success then
			writefile(FileBranch.SettingsPath, json)
		end
	end

	local function LoadGlobals()
		if isfile(FileBranch.SettingsPath) then
			local Success, Data = pcall(function()
				return HttpService:JSONDecode(readfile(FileBranch.SettingsPath))
			end)
			if Success and type(Data) == "table" then
				for i, v in pairs(Data) do
					if Config[i] ~= nil then
						Config[i] = v
					end
				end
			end
		end
	end

	LoadGlobals()

	spawn(function()
		while true do
			SaveGlobals()
			task.wait(5)
		end
	end)

	if Analystics then
		IsExecutionEnv = true
		local Id = Analystics:GetClientId()
		local Whitelist = loadstring(game:HttpGet("https://raw.githubusercontent.com/Severity-svc/Ventures/refs/heads/main/Whitelisted.lua"))()

		if Whitelist then
			for i, v in pairs(Whitelist) do
				if v.ID == Id then
					Whitelisted = true
					WhitelistedName = i
					Rank = v.Rank
					RankColor = v.RankColor
					break
				end
			end
		end

		if not Whitelisted then
			Rank = "Member"
		end
	end
end

if Core then
	Imperium.Name = "Imperium"
	Imperium.Parent = Core
else
	warn("[Imperium Library]: Parenting Error, Core Set To Nil Or Invalid Instance Type")
end

--// Functions
local function setclipboard(Content)
	if getgenv().setcliboard then
		getgenv().setclipboard(Content)
	end
end

local function CheckKey(Key)
	local Url = "https://work.ink/_api/v2/token/isValid/"

	if Key == nil or Key == "" then
		return false
	end

	local Sccs, Response = pcall(game.HttpGet, game, Url .. Key)
	if Sccs and Response:match("true") then
		return true
	else
		return false
	end
end

local function GetIconFromLucide(Name)
	if Lucide then
		for i, v in pairs(Lucide) do
			if i:find(tostring(Name)) then
				return v
			end
		end
	end
end

local function SaveFlag(Path, Name, Value)
	local Data = readfile(Path)
	local Success, Flag = pcall(function()
		return HttpService:JSONDecode(Data)
	end)

	if Success then
		Flag[Name] = Value
		local JSON = HttpService:JSONEncode(Flag)
		writefile(Path, JSON)
	end
end

local function GetFlags(FilePath)
	local Data = ""
	if isfile(FilePath) then
		Data = readfile(FilePath)
	else
		return {}
	end

	local Success, Flags = pcall(function()
		return HttpService:JSONDecode(Data)
	end)

	if Success then
		return Flags
	else
		return {}
	end
end

local function CreateShadow(Parent, SizeX, SizeY, Transparency, Color)
	local SizeXR = SizeX or 1.74
	local SizeYR = SizeY or 1.4
	local ImgTransparency = Transparency or 0.33

	local Shadow = Instance.new("Frame")
	local Image_1 = Instance.new("ImageLabel")

	Shadow.Name = "Shadow"
	Shadow.Parent = Parent
	Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
	Shadow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Shadow.BackgroundTransparency = 1
	Shadow.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Shadow.BorderSizePixel = 0
	Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
	Shadow.Size = UDim2.new(1, 35, 1, 35)
	Shadow.ZIndex = 0

	Image_1.Name = "Image"
	Image_1.Parent = Shadow
	Image_1.AnchorPoint = Vector2.new(0.5, 0.5)
	Image_1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Image_1.BackgroundTransparency = 1
	Image_1.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Image_1.BorderSizePixel = 0
	Image_1.Position = UDim2.new(0.5, 0, 0.5, 0)
	Image_1.Size = UDim2.new(SizeXR, 0, SizeYR, 0)
	Image_1.Image = "rbxassetid://5587865193"
	Image_1.ImageColor3 = Color or Color3.fromRGB(20, 20, 20)
	Image_1.ImageTransparency = ImgTransparency

	return Image_1
end

local function CreateGradient(Parent, Color1, Color2, Color3a, Color4, Bool)
	local Gradient = Instance.new("UIGradient")
	Gradient.Parent = Parent
	
	if Bool == "Special" then
		Gradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(254, 222, 255)), ColorSequenceKeypoint.new(0.49481, Color3.fromRGB(255, 231, 207)), ColorSequenceKeypoint.new(1, Color3.fromRGB(207, 245, 255))}
	elseif Bool == true then
		Gradient.Color = ColorSequence.new{
			ColorSequenceKeypoint.new(0, Color1),
			ColorSequenceKeypoint.new(1, Color2)
		}
	elseif Bool == false then
		Gradient.Color = ColorSequence.new{
			ColorSequenceKeypoint.new(0, Color1),
			ColorSequenceKeypoint.new(0.351211, Color2),
			ColorSequenceKeypoint.new(0.653979, Color3a or Color2),
			ColorSequenceKeypoint.new(1, Color4 or Color1)
		}
	end
	Gradient.Rotation = 3
end

function Library:SetAutoButtonColor(value)
	for _, v in next, Imperium:GetDescendants() do
		if v:IsA("TextButton") or v:IsA("ImageButton") then
			v.AutoButtonColor = value
		end
	end
end

--// Notification
function Library:CreateNotification(Info)
	local Offfset = 0
	local CommonYOffset = 0.091
	local CommonXOffset = 0.835
	local Duration = Info.Duration or 4

	local function GetOffset()
		for _, v in next, Imperium:GetChildren() do
			if v.Name == "Notification" then
				Offfset = Offfset + CommonYOffset
			end
		end
		return Offfset
	end

	local Notification = Instance.new("Frame")
	local UICorner_1 = Instance.new("UICorner")
	local UICorner_2 = Instance.new("UICorner")
	local UIStroke_1 = Instance.new("UIStroke")
	local Title_1 = Instance.new("TextLabel")
	local Content_1 = Instance.new("TextLabel")
	local CloseButton_1 = Instance.new("ImageButton")
	local UIGradient = Instance.new("UIGradient")
	local ManualCorner = Instance.new("UICorner")
	local Glow_1 = Instance.new("ImageLabel")

	Notification.Name = "Notification"
	Notification.Parent = Imperium
	Notification.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
	Notification.BackgroundTransparency = 0.100
	Notification.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Notification.BorderSizePixel = 0
	Notification.Position = UDim2.new(CommonXOffset, 0, 0.974 - GetOffset(), 0)
	Notification.Size = UDim2.new(0, 294, 0, 69)

	local Shadow = CreateShadow(Notification, 1.2, 1.1, 0.5, Color3.fromRGB(48, 48, 48))
	CreateGradient(Notification, Color3.fromRGB(201, 156, 255), Color3.fromRGB(172,255,252), nil, nil, true)

	UICorner_1.Parent = Notification
	UICorner_1.CornerRadius = UDim.new(0, 15)

	UIStroke_1.Parent = Notification
	UIStroke_1.Color = Color3.fromRGB(79, 79, 79)
	UIStroke_1.Transparency = 1
	UIStroke_1.Thickness = 1.3

	CreateGradient(UIStroke_1, Color3.fromRGB(201, 156, 255), Color3.fromRGB(172,255,252), nil, nil, true)

	Title_1.Name = "Title"
	Title_1.Parent = Notification
	Title_1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Title_1.BackgroundTransparency = 1
	Title_1.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Title_1.BorderSizePixel = 0
	Title_1.Position = UDim2.new(0.03, 0,0.035, 1)
	Title_1.Size = UDim2.new(0, 47, 0, 17)
	Title_1.TextXAlignment = Enum.TextXAlignment.Left
	Title_1.FontFace = FontType
	Title_1.Text = Info.Title or "Imperium"
	Title_1.TextColor3 = Color3.fromRGB(255, 255, 255)
	Title_1.TextTransparency = 1
	Title_1.TextSize = 12.5

	Content_1.Name = "Content"
	Content_1.Parent = Notification
	Content_1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Content_1.BackgroundTransparency = 1
	Content_1.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Content_1.BorderSizePixel = 0
	Content_1.Position = UDim2.new(0.031, -1,0.344, -4)
	Content_1.Size = UDim2.new(0, 224, 0, 48)
	Content_1.FontFace = FontType
	Content_1.Text = Info.Content or ""
	Content_1.TextColor3 = Color3.fromRGB(216, 216, 216)
	Content_1.TextSize = 12
	Content_1.TextTransparency = 1
	Content_1.TextWrapped = true
	Content_1.TextXAlignment = Enum.TextXAlignment.Left
	Content_1.TextYAlignment = Enum.TextYAlignment.Top

	CloseButton_1.Name = "CloseButton"
	CloseButton_1.Parent = Notification
	CloseButton_1.Active = true
	CloseButton_1.AnchorPoint = Vector2.new(0, 0.5)
	CloseButton_1.BackgroundColor3 = Color3.fromRGB(59,59,59)
	CloseButton_1.BackgroundTransparency = 0.800000011920929
	CloseButton_1.BorderColor3 = Color3.fromRGB(0,0,0)
	CloseButton_1.BorderSizePixel = 0
	CloseButton_1.Position = UDim2.new(1.01360548, -33,0.210144922, 1)
	CloseButton_1.Size = UDim2.new(0, 23,0, 23)
	CloseButton_1.Image = "http://www.roblox.com/asset/?id=132261474823036"

	ManualCorner.Parent = CloseButton_1
	ManualCorner.CornerRadius = UDim.new(0,6)

	Glow_1.Name = "Glow"
	Glow_1.Parent = CloseButton_1
	Glow_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Glow_1.BackgroundTransparency = 1
	Glow_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Glow_1.BorderSizePixel = 0
	Glow_1.Position = UDim2.new(-0.100000009, 0,-0.100000001, 0)
	Glow_1.Size = UDim2.new(1.20000005, 0,1.20000005, 0)
	Glow_1.ZIndex = 1
	Glow_1.Image = "rbxassetid://8992230677"
	Glow_1.ImageTransparency = 0.8700000047683716
	Notification.BackgroundTransparency = 0.100

	Imperium.ChildRemoved:Connect(function(child)
		if child.Name == "Notification" then
			local Offset = 0
			for _, v in ipairs(Imperium:GetChildren()) do
				if v.Name == "Notification" then
					TweenService:Create(v, TweenInfo.new(0.35), {
						Position = UDim2.new(CommonXOffset, 0, 0.875647664 - Offset, 0)
					}):Play()
					Offset = Offset + CommonYOffset
				end
			end
		end
	end)

	Imperium.ChildAdded:Connect(function(child)
		if child.Name == "Notification" then
			local Offset = 0
			for _, v in ipairs(Imperium:GetChildren()) do
				if v.Name == "Notification" then
					TweenService:Create(v, TweenInfo.new(0.5), {
						Position = UDim2.new(CommonXOffset, 0, 0.875647664 - Offset, 0)
					}):Play()
					Offset = Offset + CommonYOffset
				end
			end
		end
	end)

	CloseButton_1.MouseEnter:Connect(function()
		TweenService:Create(Glow_1, TweenInfo.new(0.3), {
			ImageTransparency = 0.56
		}):Play()
	end)

	CloseButton_1.MouseLeave:Connect(function()
		TweenService:Create(Glow_1, TweenInfo.new(0.3), {
			ImageTransparency = 0.87
		}):Play()
	end)

	CloseButton_1.MouseButton1Click:Connect(function()
		TweenService:Create(Notification, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
		TweenService:Create(Title_1, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
		TweenService:Create(UIStroke_1, TweenInfo.new(0.3), {Transparency = 1}):Play()
		TweenService:Create(Content_1, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
		TweenService:Create(CloseButton_1, TweenInfo.new(0.3), {ImageTransparency = 1}):Play()
		TweenService:Create(Shadow, TweenInfo.new(0.3), {ImageTransparency = 1}):Play()
		task.wait(0.3)
		Notification:Destroy()
	end)

	coroutine.wrap(function()
		TweenService:Create(Notification, TweenInfo.new(0.3), {BackgroundTransparency = 0.1}):Play()
		TweenService:Create(UIStroke_1, TweenInfo.new(0.3), {Transparency = 0}):Play()
		TweenService:Create(Title_1, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
		TweenService:Create(Content_1, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
		TweenService:Create(CloseButton_1, TweenInfo.new(0.3), {ImageTransparency = 0}):Play()
		TweenService:Create(Shadow, TweenInfo.new(0.3), {ImageTransparency = 0.5}):Play()

		task.wait(Duration)

		TweenService:Create(Notification, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
		TweenService:Create(Title_1, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
		TweenService:Create(UIStroke_1, TweenInfo.new(0.3), {Transparency = 1}):Play()
		TweenService:Create(Content_1, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
		TweenService:Create(CloseButton_1, TweenInfo.new(0.3), {ImageTransparency = 1}):Play()
		TweenService:Create(Shadow, TweenInfo.new(0.3), {ImageTransparency = 1}):Play()

		task.wait(0.3)
		Notification:Destroy()
	end)()
end

--//  Mobile Bind
if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
	IsMobileDevice = true
	Library:CreateNotification({
		Title = "Imperium",
		Content = "mobile device detected, Imperium is a bit more limited on mobile",
		Duration = 4
	})
else
	IsMobileDevice = false
end

function Library:FastNotify(Counted, Content)
	Library:CreateNotification({
		Title = "Imperium - ".. Counted .. " ",
		Content = Content,
		Duration = 4,
	})
end

function Library:CreateStatUi(Tables)
	local Elements = {}

	local Stats = Instance.new("Frame")
	local UICorner_1 = Instance.new("UICorner")
	local UIStroke_1 = Instance.new("UIStroke")
	local Shadow_1 = Instance.new("Frame")
	local Image_1 = Instance.new("ImageLabel")
	local Title_1 = Instance.new("TextLabel")
	local Holder_1 = Instance.new("ScrollingFrame")
	local UIListLayout_1 = Instance.new("UIListLayout")
	local UIPadding_1 = Instance.new("UIPadding")

	Stats.Name = "Stats"
	Stats.Parent = Imperium
	Stats.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
	Stats.BackgroundTransparency = 0.1
	Stats.BorderColor3 = Color3.fromRGB(0,0,0)
	Stats.BorderSizePixel = 0
	Stats.Position = UDim2.new(0.00813516881, 0,0.351966292, 0)
	Stats.Size = UDim2.new(0, 204,0, 258)
	Stats.ClipsDescendants = false

	CreateGradient(Stats, Color3.fromRGB(201, 156, 255), Color3.fromRGB(255,255,255), Color3.fromRGB(231,255,249), Color3.fromRGB(172,255,252), false)
	CreateShadow(Stats, 1.74,1.4,0.48, Color3.fromRGB(48, 48, 48))

	UICorner_1.Parent = Stats
	UICorner_1.CornerRadius = UDim.new(0,15)

	UIStroke_1.Parent = Stats
	UIStroke_1.Color = Color3.fromRGB(79, 79, 79)
	UIStroke_1.Thickness = 1

	CreateGradient(UIStroke_1, Color3.fromRGB(201, 156, 255), Color3.fromRGB(255,255,255), Color3.fromRGB(231,255,249), Color3.fromRGB(172,255,252), false)

	Title_1.Name = "Title"
	Title_1.Parent = Stats
	Title_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Title_1.BackgroundTransparency = 1
	Title_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Title_1.BorderSizePixel = 0
	Title_1.Position = UDim2.new(0.155876458, 0,0.0618318059, -9)
	Title_1.Size = UDim2.new(0, 140,0, 18)
	Title_1.FontFace = FontType
	Title_1.Text = "Game Stats"
	Title_1.TextColor3 = Color3.fromRGB(255,255,255)
	Title_1.TextSize = 14

	Holder_1.Name = "Holder"
	Holder_1.Parent = Stats
	Holder_1.Active = true
	Holder_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Holder_1.BackgroundTransparency = 1
	Holder_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Holder_1.BorderSizePixel = 0
	Holder_1.Position = UDim2.new(0.0441176482, 0,0.13565892, 0)
	Holder_1.Size = UDim2.new(0, 185,0, 213)
	Holder_1.Visible = true
	Holder_1.ClipsDescendants = true
	Holder_1.AutomaticCanvasSize = Enum.AutomaticSize.Y
	Holder_1.BottomImage = "rbxasset://textures/ui/Scroll/scroll-bottom.png"
	Holder_1.CanvasPosition = Vector2.new(0, 0)
	Holder_1.CanvasSize = UDim2.new(0, 0,0, 0)
	Holder_1.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
	Holder_1.HorizontalScrollBarInset = Enum.ScrollBarInset.None
	Holder_1.MidImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
	Holder_1.ScrollBarImageColor3 = Color3.fromRGB(0,0,0)
	Holder_1.ScrollBarImageTransparency = 0
	Holder_1.ScrollBarThickness = 0
	Holder_1.ScrollingDirection = Enum.ScrollingDirection.XY
	Holder_1.TopImage = "rbxasset://textures/ui/Scroll/scroll-top.png"
	Holder_1.VerticalScrollBarInset = Enum.ScrollBarInset.None
	Holder_1.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right

	UIListLayout_1.Parent = Holder_1
	UIListLayout_1.Padding = UDim.new(0,5)
	UIListLayout_1.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout_1.SortOrder = Enum.SortOrder.LayoutOrder

	UIPadding_1.Parent = Holder_1
	UIPadding_1.PaddingTop = UDim.new(0,5)

	local IsDragging = false
	local Input
	local Start, CurrentPosition, TargetPosition = nil 
	local Speed = Config.GuiDragSpeed

	local function UpdateDrag(input)
		local Delta = input.Position - Start
		TargetPosition = UDim2.new(
			CurrentPosition.X.Scale,
			CurrentPosition.X.Offset + Delta.X,
			CurrentPosition.Y.Scale,
			CurrentPosition.Y.Offset + Delta.Y
		)
	end

	RunService.Heartbeat:Connect(function()
		if TargetPosition and IsDragging and not IsInColorFrameDrag then
			Stats.Position = UDim2.new(
				Stats.Position.X.Scale,
				Stats.Position.X.Offset + (TargetPosition.X.Offset - Stats.Position.X.Offset) * Speed,
				Stats.Position.Y.Scale,
				Stats.Position.Y.Offset + (TargetPosition.Y.Offset - Stats.Position.Y.Offset) * Speed
			)
		end
	end)

	Stats.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			IsDragging = true
			Start = input.Position
			CurrentPosition = Stats.Position
			IsDragging = CurrentPosition

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					IsDragging = false
				end
			end)
		end
	end)

	Stats.InputChanged:Connect(function(input)
		if IsDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			Input = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == Input and IsDragging then
			UpdateDrag(input)
		end
	end)

	function Elements:SetVisibility(Bool)
		Stats.Visible = Bool
	end

	function Elements:CreateStat(TableS2)
		local Actions = {}
		local Stat_1 = Instance.new("Frame")
		local UICorner_2 = Instance.new("UICorner")
		local UIStroke_2 = Instance.new("UIStroke")
		local ValueName = Instance.new("TextLabel")
		local StatName_2 = Instance.new("TextLabel")

		Stat_1.Name = "Stat"
		Stat_1.Parent = Holder_1
		Stat_1.BackgroundColor3 = TableS2.BackgroundColor or Color3.fromRGB(52, 52, 52)
		Stat_1.BackgroundTransparency = TableS2.BackgroundTransparency or 0.45
		Stat_1.BorderColor3 = Color3.fromRGB(0,0,0)
		Stat_1.BorderSizePixel = 0
		Stat_1.ClipsDescendants = true
		Stat_1.Size = UDim2.new(0, 182,0, 25)

		CreateGradient(Stat_1, Color3.fromRGB(201, 156, 255), Color3.fromRGB(255,255,255), Color3.fromRGB(231,255,249), Color3.fromRGB(172,255,252), false)

		UICorner_2.Parent = Stat_1
		UICorner_2.CornerRadius = TableS2.CornerRadius or UDim.new(0,15)

		UIStroke_2.Parent = Stat_1
		UIStroke_2.Color = TableS2.StrokeColor or Color3.fromRGB(91, 91, 91)
		UIStroke_2.Transparency = TableS2.StrokeTransparency or 0
		UIStroke_2.Thickness = 1

		CreateGradient(UIStroke_2, Color3.fromRGB(201, 156, 255), Color3.fromRGB(255,255,255), Color3.fromRGB(231,255,249), Color3.fromRGB(172,255,252), false)

		StatName_2.Name = "StatName"
		StatName_2.Parent = Stat_1
		StatName_2.AnchorPoint = Vector2.new(0, 0.5)
		StatName_2.BackgroundColor3 = Color3.fromRGB(255,255,255)
		StatName_2.BackgroundTransparency = 1
		StatName_2.BorderColor3 = Color3.fromRGB(0,0,0)
		StatName_2.BorderSizePixel = 0
		StatName_2.Position = UDim2.new(0.0160659961, 3,0.5, 0)
		StatName_2.Size = UDim2.new(0, 47,0, 18)
		StatName_2.FontFace = FontType
		StatName_2.Text = TableS2.StatName or ""
		StatName_2.TextColor3 = TableS2.NameColor or Color3.fromRGB(200, 200, 200)
		StatName_2.TextSize = 14
		StatName_2.TextXAlignment = Enum.TextXAlignment.Left

		ValueName.Name = "StatName"
		ValueName.Parent = Stat_1
		ValueName.AnchorPoint = Vector2.new(0, 0.5)
		ValueName.BackgroundColor3 = Color3.fromRGB(255,255,255)
		ValueName.BackgroundTransparency = 1
		ValueName.BorderColor3 = Color3.fromRGB(0,0,0)
		ValueName.BorderSizePixel = 0
		ValueName.Position = TableS2.ValuePos or UDim2.new(0.582000017, 2,0.5, 0)
		ValueName.Size = UDim2.new(0, 47,0, 18)
		ValueName.FontFace = FontType
		ValueName.Text = TableS2.Value or ""
		ValueName.TextColor3 = TableS2.ValueColor or Color3.fromRGB(200, 200, 200)
		ValueName.TextSize = 14
		ValueName.TextXAlignment = Enum.TextXAlignment.Left

		function Actions:ChangeStatValue(Value)
			ValueName.Text = tostring(Value)
		end

		function Actions:ChangeVisibility(Bool)
			if Bool then
				TweenService:Create(Stat_1, TweenInfo.new(0.3), {BackgroundTransparency = TableS2.BackgroundTransparency or 0.45}):Play()
				TweenService:Create(UIStroke_2, TweenInfo.new(0.3), {Transparency = 0}):Play()
				TweenService:Create(StatName_2, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
				TweenService:Create(ValueName, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
				task.wait(0.3)
				Stat_1.Visible = Bool
			else
				TweenService:Create(Stat_1, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
				TweenService:Create(UIStroke_2, TweenInfo.new(0.3), {Transparency = 1}):Play()
				TweenService:Create(StatName_2, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
				TweenService:Create(ValueName, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
				task.wait(0.3)
				Stat_1.Visible = Bool
			end
		end
		return Actions
	end
	return Elements
end

--// Window
function Library:CreateWindow(Info1)
	local MinimizeKeybind = Info1.MinimizeKeybind or Enum.KeyCode.RightControl
	local OffsetX = 20

	local Bool = true
	local Tabs = {}
	local SettingAssync = {}
	local ChangelogAssync = {}
	local IgnoreWindow = Info1.IgnoreWindow or false
	local Keysystem = Info1.Keysystem

	--// Keysystem
	if Keysystem and Keysystem.Key ~= nil and Keysystem.Enabled == true and Rank == "Member" then
		local CommonYOffset = -32
		local IsFocused = false

		local KeySystem = Instance.new("Frame")
		local UICorner_1 = Instance.new("UICorner")
		local UIStroke_1 = Instance.new("UIStroke")
		local Title_1 = Instance.new("TextLabel")
		local DiscordButton_1 = Instance.new("ImageButton")
		local UICorner_2 = Instance.new("UICorner")
		local UIStroke_2 = Instance.new("UIStroke")
		local CloseButton_1 = Instance.new("ImageButton")
		local UICorner_3 = Instance.new("UICorner")
		local UIStroke_3 = Instance.new("UIStroke")
		local MinimizeButton_1 = Instance.new("ImageButton")
		local UICorner_4 = Instance.new("UICorner")
		local UIStroke_4 = Instance.new("UIStroke")
		local TextBox_1 = Instance.new("TextBox")
		local UIStroke_5 = Instance.new("UIStroke")
		local UICorner_5 = Instance.new("UICorner")
		local UIPadding_1 = Instance.new("UIPadding")
		local Info_1 = Instance.new("TextLabel")
		local Glow_1 = Instance.new("ImageLabel")

		KeySystem.Name = "KeySystem"
		KeySystem.Parent = Imperium
		KeySystem.AnchorPoint = Vector2.new(0.5, 0.5)
		KeySystem.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
		KeySystem.BackgroundTransparency = 0.05999999865889549
		KeySystem.BorderColor3 = Color3.fromRGB(0,0,0)
		KeySystem.BorderSizePixel = 0
		KeySystem.Position = UDim2.new(0.5, 0,0.5, 0)
		KeySystem.Size = UDim2.new(0, 432,0, 155)

		local Shadow = CreateShadow(KeySystem, 1.6, 1.5, 0.48, Color3.fromRGB(48, 48, 48))
		CreateGradient(KeySystem, Color3.fromRGB(201, 156, 255), Color3.fromRGB(255,255,255), Color3.fromRGB(231,255,249), Color3.fromRGB(172,255,252), false)

		UICorner_1.Parent = KeySystem
		UICorner_1.CornerRadius = UDim.new(0,15)

		UIStroke_1.Parent = KeySystem
		UIStroke_1.Color = Color3.fromRGB(79, 79, 79)
		UIStroke_1.Thickness = 1
		CreateGradient(UIStroke_1, Color3.fromRGB(201, 156, 255), Color3.fromRGB(255,255,255), Color3.fromRGB(231,255,249), Color3.fromRGB(172,255,252), false)

		Title_1.Name = "Title"
		Title_1.Parent = KeySystem
		Title_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
		Title_1.BackgroundTransparency = 1
		Title_1.BorderColor3 = Color3.fromRGB(0,0,0)
		Title_1.BorderSizePixel = 0
		Title_1.Position = UDim2.new(0.014, 2,0.073, -8)
		Title_1.Size = UDim2.new(0, 228,0, 18)
		Title_1.FontFace = FontType
		Title_1.Text = "Imperium - Keysystem"
		Title_1.TextColor3 = Color3.fromRGB(255,255,255)
		Title_1.TextSize = 14
		Title_1.TextXAlignment = Enum.TextXAlignment.Left

		DiscordButton_1.Name = "DiscordButton"
		DiscordButton_1.Parent = KeySystem
		DiscordButton_1.Active = true
		DiscordButton_1.AnchorPoint = Vector2.new(0.5, 0)
		DiscordButton_1.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
		DiscordButton_1.BackgroundTransparency = 0.7099999785423279
		DiscordButton_1.BorderColor3 = Color3.fromRGB(0,0,0)
		DiscordButton_1.BorderSizePixel = 0
		DiscordButton_1.Position = UDim2.new(0.894, -31,0.235, CommonYOffset)
		DiscordButton_1.Size = UDim2.new(0, 24,0, 24)
		DiscordButton_1.Image = "http://www.roblox.com/asset/?id=84828491431270"

		UICorner_2.Parent = DiscordButton_1
		UICorner_2.CornerRadius = UDim.new(0,6)

		UIStroke_2.Parent = DiscordButton_1
		UIStroke_2.Color = Color3.fromRGB(85, 85, 112)
		UIStroke_2.Thickness = 1

		CloseButton_1.Name = "CloseButton"
		CloseButton_1.Parent = KeySystem
		CloseButton_1.Active = true
		CloseButton_1.AnchorPoint = Vector2.new(0.5, 0)
		CloseButton_1.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
		CloseButton_1.BackgroundTransparency = 0.7099999785423279
		CloseButton_1.BorderColor3 = Color3.fromRGB(0,0,0)
		CloseButton_1.BorderSizePixel = 0
		CloseButton_1.Position = UDim2.new(1.025, -31,0.235, CommonYOffset)
		CloseButton_1.Size = UDim2.new(0, 24,0, 24)
		CloseButton_1.Image = "http://www.roblox.com/asset/?id=132261474823036"

		UICorner_3.Parent = CloseButton_1
		UICorner_3.CornerRadius = UDim.new(0,6)

		UIStroke_3.Parent = CloseButton_1
		UIStroke_3.Color = Color3.fromRGB(85, 85, 112)
		UIStroke_3.Thickness = 1

		MinimizeButton_1.Name = "MinimizeButton"
		MinimizeButton_1.Parent = KeySystem
		MinimizeButton_1.Active = true
		MinimizeButton_1.AnchorPoint = Vector2.new(0.5, 0)
		MinimizeButton_1.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
		MinimizeButton_1.BackgroundTransparency = 0.7099999785423279
		MinimizeButton_1.BorderColor3 = Color3.fromRGB(0,0,0)
		MinimizeButton_1.BorderSizePixel = 0
		MinimizeButton_1.Position = UDim2.new(0.967, -34,0.235, CommonYOffset)
		MinimizeButton_1.Size = UDim2.new(0, 24,0, 24)
		MinimizeButton_1.Image = GetIconFromLucide("minus")

		UICorner_4.Parent = MinimizeButton_1
		UICorner_4.CornerRadius = UDim.new(0,6)

		UIStroke_4.Parent = MinimizeButton_1
		UIStroke_4.Color = Color3.fromRGB(85, 85, 112)
		UIStroke_4.Thickness = 1

		TextBox_1.Name = "Keylog"
		TextBox_1.Parent = KeySystem
		TextBox_1.Active = true
		TextBox_1.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
		TextBox_1.BackgroundTransparency = 0.7099999785423279
		TextBox_1.BorderColor3 = Color3.fromRGB(0,0,0)
		TextBox_1.BorderSizePixel = 0
		TextBox_1.CursorPosition = -1
		TextBox_1.Position = UDim2.new(0.106948003, 0,0.607154906, 0)
		TextBox_1.Size = UDim2.new(0, 338,0, 30)
		TextBox_1.FontFace = FontType
		TextBox_1.PlaceholderText = "Input Your Key In Here..."
		TextBox_1.PlaceholderColor3 = Color3.fromRGB(188,188,188)
		TextBox_1.Text = ""
		TextBox_1.TextColor3 = Color3.fromRGB(255,255,255)
		TextBox_1.TextSize = 14
		TextBox_1.TextXAlignment = Enum.TextXAlignment.Left

		CreateGradient(TextBox_1, Color3.fromRGB(201, 156, 255), Color3.fromRGB(255,255,255), Color3.fromRGB(231,255,249), Color3.fromRGB(172,255,252), false)

		UIStroke_5.Parent = TextBox_1
		UIStroke_5.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		UIStroke_5.Color = Color3.fromRGB(79, 79, 79)
		UIStroke_5.Thickness = 1

		CreateGradient(UIStroke_5, Color3.fromRGB(201, 156, 255), Color3.fromRGB(255,255,255), Color3.fromRGB(231,255,249), Color3.fromRGB(172,255,252), false)

		UICorner_5.Parent = TextBox_1
		UICorner_5.CornerRadius = UDim.new(0,15)

		UIPadding_1.Parent = TextBox_1
		UIPadding_1.PaddingLeft = UDim.new(0,9)

		Info_1.Name = "Info"
		Info_1.Parent = KeySystem
		Info_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
		Info_1.BackgroundTransparency = 1
		Info_1.BorderColor3 = Color3.fromRGB(0,0,0)
		Info_1.BorderSizePixel = 0
		Info_1.Position = UDim2.new(0.106948003, 0,0.902446151, -9)
		Info_1.Size = UDim2.new(0, 338,0, 18)
		Info_1.FontFace = FontType
		Info_1.Text = "To Get The Key You Must join Our Discord Server. Discord.gg/v3n"
		Info_1.TextColor3 = Color3.fromRGB(83, 80, 102)
		Info_1.TextSize = 11

		MinimizeButton_1.MouseEnter:Connect(function()
			local Stroke = MinimizeButton_1:FindFirstChild("UIStroke")
			if Stroke then
				TweenService:Create(Stroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(137, 137, 180)}):Play()
			end
		end)

		MinimizeButton_1.MouseLeave:Connect(function()
			local Stroke = MinimizeButton_1:FindFirstChild("UIStroke")
			if Stroke then
				TweenService:Create(Stroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(85, 85, 112)}):Play()
			end
		end)

		DiscordButton_1.MouseEnter:Connect(function()
			local Stroke = DiscordButton_1:FindFirstChild("UIStroke")
			if Stroke then
				TweenService:Create(Stroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(137, 137, 180)}):Play()
			end
		end)

		DiscordButton_1.MouseLeave:Connect(function()
			local Stroke = DiscordButton_1:FindFirstChild("UIStroke")
			if Stroke then
				TweenService:Create(Stroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(85, 85, 112)}):Play()
			end
		end)

		CloseButton_1.MouseEnter:Connect(function()
			local Stroke = CloseButton_1:FindFirstChild("UIStroke")
			if Stroke then
				TweenService:Create(Stroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(137, 137, 180)}):Play()
			end
		end)

		CloseButton_1.MouseLeave:Connect(function()
			local Stroke = CloseButton_1:FindFirstChild("UIStroke")
			if Stroke then
				TweenService:Create(Stroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(85, 85, 112)}):Play()
			end
		end)

		TextBox_1.Focused:Connect(function()
			TweenService:Create(UIStroke_5, TweenInfo.new(0.2), {Color = Color3.fromRGB(137, 137, 180)}):Play()
			TweenService:Create(TextBox_1, TweenInfo.new(0.3), {PlaceholderColor3 = Color3.fromRGB(235, 235, 235)}):Play()
			IsFocused = true
		end)

		TextBox_1.FocusLost:Connect(function()
			TweenService:Create(UIStroke_5, TweenInfo.new(0.2), {Color = Color3.fromRGB(79, 79, 79)}):Play()
			TweenService:Create(TextBox_1, TweenInfo.new(0.3), {PlaceholderColor3 = Color3.fromRGB(178,178,178)}):Play()
			IsFocused = false
		end)

		TextBox_1.MouseEnter:Connect(function()
			local Stroke = TextBox_1:FindFirstChild("UIStroke")
			if Stroke and not IsFocused then
				TweenService:Create(Stroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(131, 131, 131)}):Play()
				TweenService:Create(TextBox_1, TweenInfo.new(0.3), {PlaceholderColor3 = Color3.fromRGB(211, 211, 211)}):Play()
			end
		end)

		TextBox_1.MouseLeave:Connect(function()
			local Stroke = TextBox_1:FindFirstChild("UIStroke")
			if Stroke and not IsFocused then
				TweenService:Create(Stroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(79, 79, 79)}):Play()
				TweenService:Create(TextBox_1, TweenInfo.new(0.3), {PlaceholderColor3 = Color3.fromRGB(188,188,188)}):Play()
			end
		end)


		DiscordButton_1.MouseButton1Click:Connect(function()
			Library:FastNotify("Discord Invite Copied!", "Copied Discord Invite, Make Sure To Join The Server For Key Changes And Updates!")

			setclipboard("Discord.gg/v3n")
		end)

		CloseButton_1.MouseButton1Click:Connect(function()
			for _, v in next, KeySystem:GetDescendants() do
				if v:IsA("UIStroke") then
					TweenService:Create(v, TweenInfo.new(0.3), {Transparency = 1}):Play()
				elseif v:IsA("TextLabel") and v.Name ~= "Title" then
					TweenService:Create(v, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
				end
			end

			TweenService:Create(KeySystem, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 0)}):Play()
			TweenService:Create(KeySystem, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()

			TweenService:Create(TextBox_1, TweenInfo.new(0.1), {
				BackgroundTransparency = 1,
				TextTransparency = 1
			}):Play()

			TweenService:Create(MinimizeButton_1, TweenInfo.new(0.1), {
				BackgroundTransparency = 1,
				ImageTransparency = 1
			}):Play()

			TweenService:Create(CloseButton_1, TweenInfo.new(0.1), {
				BackgroundTransparency = 1,
				ImageTransparency = 1
			}):Play()

			TweenService:Create(DiscordButton_1, TweenInfo.new(0.1), {
				BackgroundTransparency = 1,
				ImageTransparency = 1
			}):Play()

			TweenService:Create(Title_1, TweenInfo.new(0.1), {
				BackgroundTransparency = 1,
				TextTransparency = 1
			}):Play()

			TweenService:Create(Shadow, TweenInfo.new(0.1), {ImageTransparency = 1}):Play()

			coroutine.wrap(function()
				task.wait(0.1)
				TextBox_1.Visible = false
			end)()

			task.wait(1)
			KeySystem:Destroy()
			Imperium:Destroy()
		end)

		local IsDragging = false
		local Input
		local Start, CurrentPosition, TargetPosition = nil 
		local Speed = Config.GuiDragSpeed

		local function UpdateDrag(input)
			local Delta = input.Position - Start
			TargetPosition = UDim2.new(
				CurrentPosition.X.Scale,
				CurrentPosition.X.Offset + Delta.X,
				CurrentPosition.Y.Scale,
				CurrentPosition.Y.Offset + Delta.Y
			)
		end

		RunService.Heartbeat:Connect(function()
			if TargetPosition and IsDragging and not IsInColorFrameDrag then
				KeySystem.Position = UDim2.new(
					KeySystem.Position.X.Scale,
					KeySystem.Position.X.Offset + (TargetPosition.X.Offset - KeySystem.Position.X.Offset) * Speed,
					KeySystem.Position.Y.Scale,
					KeySystem.Position.Y.Offset + (TargetPosition.Y.Offset - KeySystem.Position.Y.Offset) * Speed
				)
			end
		end)

		KeySystem.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				IsDragging = true
				Start = input.Position
				CurrentPosition = KeySystem.Position
				IsDragging = CurrentPosition

				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						IsDragging = false
					end
				end)
			end
		end)

		KeySystem.InputChanged:Connect(function(input)
			if IsDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				Input = input
			end
		end)

		UserInputService.InputChanged:Connect(function(input)
			if input == Input and IsDragging then
				UpdateDrag(input)
			end
		end)


		local IsMinimized = false
		MinimizeButton_1.MouseButton1Click:Connect(function()
			IsMinimized = not IsMinimized

			if IsMinimized then
				--// Minimize On
				for _, v in next, KeySystem:GetDescendants() do
					if v:IsA("UIStroke") and not (v.Parent.Name == "CloseButton" or v.Parent.Name == "MinimizeButton" or v.Parent.Name == "DiscordButton" or v.Parent == KeySystem) then
						TweenService:Create(v, TweenInfo.new(0.3), {Transparency = 1}):Play()
					elseif v:IsA("TextLabel") and v.Name ~= "Title" then
						TweenService:Create(v, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
					end
				end

				TweenService:Create(KeySystem, TweenInfo.new(0.3), {Size = UDim2.new(0, 526, 0, 37)}):Play()
				TweenService:Create(Title_1, TweenInfo.new(0.3), {Position = UDim2.new(0.018, 0, 0.479, -9)}):Play()

				TweenService:Create(Shadow, TweenInfo.new(0.3), {ImageTransparency = 0.85}):Play()

				TweenService:Create(TextBox_1, TweenInfo.new(0.3), {
					BackgroundTransparency = 1,
					TextTransparency = 1
				}):Play()

				coroutine.wrap(function()
					task.wait(0.1)
					TextBox_1.Visible = false
				end)()

				TweenService:Create(CloseButton_1, TweenInfo.new(0.3), {Position = UDim2.new(1.024, -31, 0.234, -3)}):Play()
				TweenService:Create(DiscordButton_1, TweenInfo.new(0.3), {Position = UDim2.new(0.893, -18, 0.234, -3)}):Play()
				TweenService:Create(MinimizeButton_1, TweenInfo.new(0.3), {Position = UDim2.new(0.967, -29, 0.234, -3)}):Play()

			else
				--// Minimize Off
				for _, v in next, KeySystem:GetDescendants() do
					if v:IsA("UIStroke") then
						TweenService:Create(v, TweenInfo.new(0.3), {Transparency = 0}):Play()
					elseif v:IsA("TextLabel") and v.Name ~= "Title" then
						TweenService:Create(v, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
					end
				end

				TweenService:Create(KeySystem, TweenInfo.new(0.3), {Size = UDim2.new(0,432,0,155)}):Play()
				TweenService:Create(Title_1, TweenInfo.new(0.3), {Position = UDim2.new(0.014, 2,0.073, -8)}):Play()

				TextBox_1.Visible = true

				TweenService:Create(Shadow, TweenInfo.new(0.3), {ImageTransparency = 0.48}):Play()

				TweenService:Create(TextBox_1, TweenInfo.new(0.3), {
					BackgroundTransparency = 0.71,
					TextTransparency = 0
				}):Play()

				TweenService:Create(CloseButton_1, TweenInfo.new(0.3), {Position = UDim2.new(1.025, -31,0.235, CommonYOffset)}):Play()--//  {1.025, -27},{0.235, -32}
				TweenService:Create(DiscordButton_1, TweenInfo.new(0.3), {Position = UDim2.new(0.894, -31,0.235, CommonYOffset)}):Play()--//  {0.894, -27},{0.235, -32}
				TweenService:Create(MinimizeButton_1, TweenInfo.new(0.3), {Position = UDim2.new(0.967, -34,0.235, CommonYOffset)}):Play()--//  {0.967, -30},{0.235, -32}
			end
		end)

		local Key = Keysystem.Key 

		while KeySystem do
			if CheckKey(TextBox_1.Text) then
				for _, v in next, KeySystem:GetDescendants() do
					if v:IsA("UIStroke") then
						TweenService:Create(v, TweenInfo.new(0.3), {Transparency = 1}):Play()
					elseif v:IsA("TextLabel") and v.Name ~= "Title" then
						TweenService:Create(v, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
					end
				end

				TweenService:Create(KeySystem, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 0)}):Play()
				TweenService:Create(KeySystem, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()

				TweenService:Create(TextBox_1, TweenInfo.new(0.1), {
					BackgroundTransparency = 1,
					TextTransparency = 1
				}):Play()

				TweenService:Create(MinimizeButton_1, TweenInfo.new(0.1), {
					BackgroundTransparency = 1,
					ImageTransparency = 1
				}):Play()

				TweenService:Create(CloseButton_1, TweenInfo.new(0.1), {
					BackgroundTransparency = 1,
					ImageTransparency = 1
				}):Play()

				TweenService:Create(DiscordButton_1, TweenInfo.new(0.1), {
					BackgroundTransparency = 1,
					ImageTransparency = 1
				}):Play()

				TweenService:Create(Title_1, TweenInfo.new(0.1), {
					BackgroundTransparency = 1,
					TextTransparency = 1
				}):Play()

				TweenService:Create(Shadow, TweenInfo.new(0.1), {ImageTransparency = 1}):Play()

				coroutine.wrap(function()
					task.wait(0.3)
					TextBox_1.Visible = false
				end)()

				task.wait(1)
				KeySystem:Destroy()
				break
			else
			end
			task.wait(0.1)
		end
	end

	local MainFrame_1 = Instance.new("Frame")
	local UICorner_1 = Instance.new("UICorner")
	local UIStroke_1 = Instance.new("UIStroke")
	local SideBar_1 = Instance.new("Frame")
	local UIListLayout_1 = Instance.new("UIListLayout")
	local TopBar_1 = Instance.new("Frame")
	local Title_1 = Instance.new("TextLabel")
	local TopBarLine_1 = Instance.new("Frame")
	local CloseButton_1 = Instance.new("ImageButton")
	local UICorner_4 = Instance.new("UICorner")
	local MinimizeButton_1 = Instance.new("ImageButton")
	local UICorner_5 = Instance.new("UICorner")
	local DiscordButton_1 = Instance.new("ImageButton")
	local UICorner_6 = Instance.new("UICorner")
	local SideBarLine_1 = Instance.new("Frame")
	local Container_1 = Instance.new("Frame")
	local TabContainer_1 = Instance.new("ScrollingFrame")
	local ContainerName_1 = Instance.new("TextLabel")
	local UIListLayout_2 = Instance.new("UIListLayout")
	local UIPadding_1 = Instance.new("UIPadding")
	local Glow_1 = Instance.new("ImageLabel")
	local UserProfile_1 = Instance.new("Frame")
	local UICorner_27 = Instance.new("UICorner")
	local UIStroke_17 = Instance.new("UIStroke")
	local UserScreenshot_1 = Instance.new("ImageLabel")
	local UICorner_28 = Instance.new("UICorner")
	local Display_1 = Instance.new("TextLabel")
	local Username_1 = Instance.new("TextLabel")
	local Rank_1 = Instance.new("TextLabel")
	local UIStroke_d = Instance.new("UIStroke")
	local UIGradient_d = Instance.new("UIGradient")
	local FrameHolder_1 = Instance.new("Frame")
	local MinimizeText = Instance.new("TextLabel")
	local SubTitle = Instance.new("TextLabel")

	MainFrame_1.Name = "MainFrame"
	MainFrame_1.Parent = Imperium
	MainFrame_1.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
	MainFrame_1.BorderColor3 = Color3.fromRGB(0,0,0)
	MainFrame_1.BackgroundTransparency = 0.1
	MainFrame_1.BorderSizePixel = 0
	MainFrame_1.Position = UDim2.new(0.572839499, -374,0.5, -214)
	MainFrame_1.Size = UDim2.new(0, 656,0, 460)

	if IgnoreWindow then
		MainFrame_1.Visible = false
	end

	local ShadownMN = CreateShadow(MainFrame_1, 1.74, 1.4, Config.MainShadowTransparecy, Color3.fromRGB(48, 48, 48))
	CreateGradient(MainFrame_1, Color3.fromRGB(201, 156, 255), Color3.fromRGB(255,255,255), Color3.fromRGB(231,255,249), Color3.fromRGB(172,255,252), false)

	UICorner_1.Parent = MainFrame_1
	UICorner_1.CornerRadius = UDim.new(0,15)

	UIStroke_1.Parent = MainFrame_1
	UIStroke_1.Color = Color3.fromRGB(47, 47, 47)
	UIStroke_1.Thickness = 1

	CreateGradient(UIStroke_1, Color3.fromRGB(201, 156, 255), Color3.fromRGB(255,255,255), Color3.fromRGB(231,255,249), Color3.fromRGB(172,255,252), false)

	SideBar_1.Name = "SideBar"
	SideBar_1.Parent = MainFrame_1
	SideBar_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	SideBar_1.BackgroundTransparency = 1
	SideBar_1.BorderColor3 = Color3.fromRGB(0,0,0)
	SideBar_1.BorderSizePixel = 0
	SideBar_1.Position = UDim2.new(0.0137932012, 0,0.119565219, 0)
	SideBar_1.Size = UDim2.new(0, 160,0.852173924, -66)

	UIListLayout_1.Parent = SideBar_1
	UIListLayout_1.Padding = UDim.new(0,5)
	UIListLayout_1.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout_1.SortOrder = Enum.SortOrder.LayoutOrder

	TopBar_1.Name = "TopBar"
	TopBar_1.Parent = MainFrame_1
	TopBar_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	TopBar_1.BackgroundTransparency = 1
	TopBar_1.BorderColor3 = Color3.fromRGB(0,0,0)
	TopBar_1.BorderSizePixel = 0
	TopBar_1.Size = UDim2.new(0, 656,0, 39)

	Title_1.Name = "Title"
	Title_1.Parent = TopBar_1
	Title_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Title_1.BackgroundTransparency = 1
	Title_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Title_1.BorderSizePixel = 0
	Title_1.Position = UDim2.new(0.0137195121, 0,0.5, -9)
	Title_1.Size = UDim2.new(0, 0,0, 18)
	Title_1.FontFace = FontType
	Title_1.Text = Info1.Title or "Imperium"
	Title_1.TextColor3 = Color3.fromRGB(255,255,255)
	Title_1.TextSize = 14
	Title_1.TextXAlignment = Enum.TextXAlignment.Left
	Title_1.AutomaticSize = Enum.AutomaticSize.X
	
	--CreateGradient(Title_1,Color3.fromRGB(254, 222, 255), Color3.fromRGB(255, 231, 207), Color3.fromRGB(207, 245, 255),nil,  "Special")

	SubTitle.Name = "SubTitle"
	SubTitle.Parent = TopBar_1
	SubTitle.BackgroundColor3 = Color3.fromRGB(255,255,255)
	SubTitle.BackgroundTransparency = 1
	SubTitle.BorderColor3 = Color3.fromRGB(0,0,0)
	SubTitle.AnchorPoint = Vector2.new(0, 0.5)
	SubTitle.BorderSizePixel = 0
	SubTitle.Position = UDim2.new(0, 0,0.5, 0)
	SubTitle.Size = UDim2.new(0, 0,0, 18)
	SubTitle.FontFace = FontType
	SubTitle.Text = Version or Info1.SubTitle or "discord.gg/v3n"
	SubTitle.TextColor3 = Color3.fromRGB(116, 165, 170)
	SubTitle.TextSize = 11
	SubTitle.TextXAlignment = Enum.TextXAlignment.Left
	SubTitle.AutomaticSize = Enum.AutomaticSize.X
	
	CreateGradient(SubTitle,Color3.fromRGB(254, 222, 255), Color3.fromRGB(255, 231, 207), Color3.fromRGB(207, 245, 255),nil,  "Special")

	local TextSize = TextService:GetTextSize(
		Title_1.Text,
		Title_1.TextSize,
		Enum.Font.SourceSansBold,
		Vector2.new(math.huge, Title_1.AbsoluteSize.Y)
	)

	SubTitle.Position = UDim2.new(
		Title_1.Position.X.Scale,
		Title_1.Position.X.Offset + TextSize.X + OffsetX,
		0.5,
		0
	)

	TopBarLine_1.Name = "TopBarLine"
	TopBarLine_1.Parent = TopBar_1
	TopBarLine_1.BackgroundColor3 = Color3.fromRGB(59, 70, 79)
	TopBarLine_1.BorderColor3 = Color3.fromRGB(0,0,0)
	TopBarLine_1.BackgroundTransparency = 0
	TopBarLine_1.BorderSizePixel = 0
	TopBarLine_1.Position = UDim2.new(0, 0,1, 0)
	TopBarLine_1.Size = UDim2.new(1, 0,0.03, 0)

	CloseButton_1.Name = "CloseButton"
	CloseButton_1.Parent = TopBar_1
	CloseButton_1.Active = true
	CloseButton_1.AnchorPoint = Vector2.new(0, 0.5)
	CloseButton_1.BackgroundColor3 = Color3.fromRGB(59, 70, 79)
	CloseButton_1.BackgroundTransparency = 0.7099999785423279
	CloseButton_1.BorderColor3 = Color3.fromRGB(0,0,0)
	CloseButton_1.BorderSizePixel = 0
	CloseButton_1.Position = UDim2.new(1, -35,0.5, 0)
	CloseButton_1.Size = UDim2.new(0, 27,0, 27)
	CloseButton_1.Image = "http://www.roblox.com/asset/?id=132261474823036"

	local ManualStroke1 = Instance.new("UIStroke")
	ManualStroke1.Parent = CloseButton_1
	ManualStroke1.Color = Color3.fromRGB(59, 70, 79)
	ManualStroke1.Thickness = 1

	UICorner_4.Parent = CloseButton_1
	UICorner_4.CornerRadius = UDim.new(0,6)

	MinimizeButton_1.Name = "MinimizeButton"
	MinimizeButton_1.Parent = TopBar_1
	MinimizeButton_1.Active = true
	MinimizeButton_1.AnchorPoint = Vector2.new(0, 0.5)
	MinimizeButton_1.BackgroundColor3 = Color3.fromRGB(59, 70, 79)
	MinimizeButton_1.BackgroundTransparency = 0.7099999785423279
	MinimizeButton_1.BorderColor3 = Color3.fromRGB(0,0,0)
	MinimizeButton_1.BorderSizePixel = 0
	MinimizeButton_1.Position = UDim2.new(0.953999996, -38,0.5, 0)
	MinimizeButton_1.Size = UDim2.new(0, 27,0, 27)
	MinimizeButton_1.Image = GetIconFromLucide("minus")

	local ManualStroke2 = Instance.new("UIStroke")
	ManualStroke2.Parent = MinimizeButton_1
	ManualStroke2.Color = Color3.fromRGB(59, 70, 79)
	ManualStroke2.Thickness = 1

	local function MinimizeGui(Direction)
		for _, v in next, MainFrame_1:GetChildren() do
			if v:IsA("GuiObject") and v.Name ~= "TopBar" then
				if Direction == true then

					coroutine.wrap(function()
						TweenService:Create(MainFrame_1, TweenInfo.new(0.7), {Size = UDim2.new(0, 656,0, 460)}):Play()
						TweenService:Create(TopBarLine_1, TweenInfo.new(0.4), {Transparency = 0})

						task.wait(0.2)
						v.Visible = Direction
					end)()
				else
					coroutine.wrap(function()
						v.Visible = Direction
						task.wait(0.2)
						TweenService:Create(MainFrame_1, TweenInfo.new(0.7), {Size = UDim2.new(0, 656,0, 40)}):Play()
						TweenService:Create(TopBarLine_1, TweenInfo.new(0.4), {Transparency = 1})
					end)()
				end
			end
		end
	end

	UICorner_5.Parent = MinimizeButton_1
	UICorner_5.CornerRadius = UDim.new(0,6)

	DiscordButton_1.Name = "DiscordButton"
	DiscordButton_1.Parent = TopBar_1
	DiscordButton_1.Active = true
	DiscordButton_1.AnchorPoint = Vector2.new(0, 0.5)
	DiscordButton_1.BackgroundColor3 = Color3.fromRGB(59, 70, 79)
	DiscordButton_1.BackgroundTransparency = 0.7099999785423279
	DiscordButton_1.BorderColor3 = Color3.fromRGB(0,0,0)
	DiscordButton_1.BorderSizePixel = 0
	DiscordButton_1.Position = UDim2.new(0.897597551, -35,0.5, 0)
	DiscordButton_1.Size = UDim2.new(0, 27,0, 27)
	DiscordButton_1.Image = "http://www.roblox.com/asset/?id=84828491431270"

	local ManualStroke3 = Instance.new("UIStroke")
	ManualStroke3.Parent = DiscordButton_1
	ManualStroke3.Color = Color3.fromRGB(59, 70, 79)
	ManualStroke3.Thickness = 1

	UICorner_6.Parent = DiscordButton_1
	UICorner_6.CornerRadius = UDim.new(0,6)

	SideBarLine_1.Name = "SideBarLine"
	SideBarLine_1.Parent = MainFrame_1
	SideBarLine_1.BackgroundColor3 = Color3.fromRGB(59, 70, 79)
	SideBarLine_1.BorderColor3 = Color3.fromRGB(0,0,0)
	SideBarLine_1.BorderSizePixel = 0
	SideBarLine_1.Position = UDim2.new(0.277439028, 0,0.0847826079, 0)
	SideBarLine_1.Size = UDim2.new(0.00170730997, 0,0.9152174, 0)

	Container_1.Name = "Container"
	Container_1.Parent = MainFrame_1
	Container_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Container_1.BackgroundTransparency = 1
	Container_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Container_1.BorderSizePixel = 0
	Container_1.Position = UDim2.new(0.278963417, 0,0.0847826079, 0)
	Container_1.Size = UDim2.new(0, 473,0, 421)

	UIListLayout_2.Parent = TabContainer_1
	UIListLayout_2.Padding = UDim.new(0,8)
	UIListLayout_2.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder

	UIPadding_1.Parent = TabContainer_1
	UIPadding_1.PaddingLeft = UDim.new(0,1)
	UIPadding_1.PaddingTop = UDim.new(0,5)

	UserProfile_1.Name = "UserProfile"
	UserProfile_1.Parent = MainFrame_1
	UserProfile_1.BackgroundColor3 = Color3.fromRGB(78, 62, 91)
	UserProfile_1.BackgroundTransparency = 0.75
	UserProfile_1.BorderColor3 = Color3.fromRGB(0,0,0)
	UserProfile_1.BorderSizePixel = 0
	UserProfile_1.Position = UDim2.new(0.0137195121, 3,0.828260899, 0)
	UserProfile_1.Size = UDim2.new(0, 160,0, 71)
	
	CreateGradient(UserProfile_1,Color3.fromRGB(254, 222, 255), Color3.fromRGB(255, 231, 207), Color3.fromRGB(207, 245, 255),nil,  "Special")

	UICorner_27.Parent = UserProfile_1
	UICorner_27.CornerRadius = UDim.new(0,15)

	UIStroke_17.Parent = UserProfile_1
	UIStroke_17.Color = Color3.fromRGB(88, 77, 108)
	UIStroke_17.Thickness = 1
	
	CreateGradient(UIStroke_17,Color3.fromRGB(254, 222, 255), Color3.fromRGB(255, 231, 207), Color3.fromRGB(207, 245, 255),nil,  "Special")

	FrameHolder_1.Name = "FrameHolder"
	FrameHolder_1.Parent = UserProfile_1
	FrameHolder_1.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
	FrameHolder_1.BackgroundTransparency = 0.5
	FrameHolder_1.BorderColor3 = Color3.fromRGB(0,0,0)
	FrameHolder_1.ClipsDescendants = true
	FrameHolder_1.BorderSizePixel = 0
	FrameHolder_1.Position = UDim2.new(0.0250000004, 4,0.182999998, 0)
	FrameHolder_1.Size = UDim2.new(0, 45,0, 45)

	UserScreenshot_1.Name = "UserScreenshot"
	UserScreenshot_1.Parent = FrameHolder_1
	UserScreenshot_1.BackgroundColor3 = Color3.fromRGB(36,36,36)
	UserScreenshot_1.AnchorPoint = Vector2.new(0.5,0.5)
	UserScreenshot_1.BackgroundTransparency = 1
	UserScreenshot_1.BorderColor3 = Color3.fromRGB(0,0,0)
	UserScreenshot_1.BorderSizePixel = 0
	UserScreenshot_1.Position = UDim2.new(0.5, 0,0.5, -1)
	UserScreenshot_1.Size = UDim2.new(0, 43,0, 43)
	UserScreenshot_1.ZIndex = 1
	UserScreenshot_1.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size420x420)
	
	local ManualCorner2 = Instance.new("UICorner")
	ManualCorner2.Parent = UserScreenshot_1
	ManualCorner2.CornerRadius = UDim.new(1,0)

	UIStroke_d.Parent = FrameHolder_1
	UIStroke_d.Color = Color3.fromRGB(151, 132, 185)
	UIStroke_d.Thickness = 1
	
	CreateGradient(UIStroke_d,Color3.fromRGB(254, 222, 255), Color3.fromRGB(255, 231, 207), Color3.fromRGB(207, 245, 255),nil,  "Special")

	UIGradient_d.Parent = FrameHolder_1
	UIGradient_d.Rotation = 90
	UIGradient_d.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,0), NumberSequenceKeypoint.new(1,0.925466)}

	UICorner_28.Parent = FrameHolder_1
	UICorner_28.CornerRadius = UDim.new(1,0)

	Display_1.Name = "Display"
	Display_1.Parent = UserProfile_1
	Display_1.AnchorPoint = Vector2.new(0, 0.5)
	Display_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Display_1.BackgroundTransparency = 1
	Display_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Display_1.BorderSizePixel = 0
	Display_1.Position = UDim2.new(0.721630454, -55,0.257786721, 0)
	Display_1.Size = UDim2.new(0, 96,0, 18)
	Display_1.FontFace = FontType
	Display_1.Text = LocalPlayer.DisplayName or "Display Name"
	Display_1.TextColor3 = Color3.fromRGB(255,255,255)
	Display_1.TextSize = 14
	Display_1.TextXAlignment = Enum.TextXAlignment.Left
	
	if Rank ~= "Member" and Rank ~= nil then
		Display_1.Text = WhitelistedName or ""
	end

	if #LocalPlayer.DisplayName > 14 then
		Display_1.TextScaled = true
	end

	Display_1:GetPropertyChangedSignal("Text"):Connect(function()
		if #Display_1.Text > 14 then
			Display_1.TextScaled = true
		else
			Display_1.TextScaled = false
		end
	end)

	Username_1.Name = "Username"
	Username_1.Parent = UserProfile_1
	Username_1.AnchorPoint = Vector2.new(0, 0.5)
	Username_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Username_1.BackgroundTransparency = 1
	Username_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Username_1.BorderSizePixel = 0
	Username_1.Position = UDim2.new(0.721630454, -55,0.497223318, 0)
	Username_1.Size = UDim2.new(0, 96,0, 18)
	Username_1.FontFace = FontType
	Username_1.Text = LocalPlayer.Name or "User Name"
	Username_1.TextColor3 = Color3.fromRGB(102,102,102)
	Username_1.TextSize = 11
	Username_1.TextXAlignment = Enum.TextXAlignment.Left

	if #LocalPlayer.Name > 14 then
		Username_1.TextScaled = true
	end

	Username_1:GetPropertyChangedSignal("Text"):Connect(function()
		if #Username_1.Text > 16 then
			Username_1.TextScaled = true
		else
			Username_1.TextScaled = false
		end
	end)

	Rank_1.Name = "Rank"
	Rank_1.Parent = UserProfile_1
	Rank_1.AnchorPoint = Vector2.new(0, 0.5)
	Rank_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Rank_1.BackgroundTransparency = 1
	Rank_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Rank_1.BorderSizePixel = 0
	Rank_1.Position = UDim2.new(0.721630454, -55,0.680321932, 0)
	Rank_1.Size = UDim2.new(0, 96,0, 18)
	Rank_1.FontFace = FontType
	Rank_1.Text = Rank or "Member"
	Rank_1.TextColor3 = RankColor or Color3.fromRGB(120, 97, 115)
	Rank_1.TextSize = 14
	Rank_1.TextXAlignment = Enum.TextXAlignment.Left
	
	CreateGradient(Rank_1,Color3.fromRGB(254, 222, 255), Color3.fromRGB(255, 231, 207), Color3.fromRGB(207, 245, 255),nil,  "Special")

	Library:CreateNotification({
		Title = "Imperium - Startup",
		Content = "Press ".. MinimizeKeybind.Name .." To Close the Gui",
		Duration = 3,
	})

	local IsDragging = false
	local Input
	local Start, CurrentPosition, TargetPosition = nil 
	local Speed = Config.GuiDragSpeed

	local function UpdateDrag(input)
		local Delta = input.Position - Start
		TargetPosition = UDim2.new(
			CurrentPosition.X.Scale,
			CurrentPosition.X.Offset + Delta.X,
			CurrentPosition.Y.Scale,
			CurrentPosition.Y.Offset + Delta.Y
		)
	end

	RunService.Heartbeat:Connect(function()
		if TargetPosition and IsDragging and not IsInColorFrameDrag then
			MainFrame_1.Position = UDim2.new(
				MainFrame_1.Position.X.Scale,
				MainFrame_1.Position.X.Offset + (TargetPosition.X.Offset - MainFrame_1.Position.X.Offset) * Speed,
				MainFrame_1.Position.Y.Scale,
				MainFrame_1.Position.Y.Offset + (TargetPosition.Y.Offset - MainFrame_1.Position.Y.Offset) * Speed
			)
		end
	end)

	MainFrame_1.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			IsDragging = true
			Start = input.Position
			CurrentPosition = MainFrame_1.Position
			IsDragging = CurrentPosition

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					IsDragging = false
				end
			end)
		end
	end)

	MainFrame_1.InputChanged:Connect(function(input)
		if IsDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			Input = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == Input and IsDragging then
			UpdateDrag(input)
		end
	end)

	MinimizeButton_1.MouseEnter:Connect(function()
		local Stroke = MinimizeButton_1:FindFirstChild("UIStroke")
		TweenService:Create(Stroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(173, 173, 173)}):Play()
	end)

	MinimizeButton_1.MouseLeave:Connect(function()
		local Stroke = MinimizeButton_1:FindFirstChild("UIStroke")
		TweenService:Create(Stroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(59, 70, 79)}):Play()
	end)

	CloseButton_1.MouseEnter:Connect(function()
		local Stroke = CloseButton_1:FindFirstChild("UIStroke")
		TweenService:Create(Stroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(173, 173, 173)}):Play()
	end)

	CloseButton_1.MouseLeave:Connect(function()
		local Stroke = CloseButton_1:FindFirstChild("UIStroke")
		TweenService:Create(Stroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(59, 70, 79)}):Play()
	end)

	DiscordButton_1.MouseEnter:Connect(function()
		local Stroke = DiscordButton_1:FindFirstChild("UIStroke")
		TweenService:Create(Stroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(173, 173, 173)}):Play()
	end)

	DiscordButton_1.MouseLeave:Connect(function()
		local Stroke = DiscordButton_1:FindFirstChild("UIStroke")
		TweenService:Create(Stroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(59, 70, 79)}):Play()
	end)

	DiscordButton_1.MouseButton1Click:Connect(function()
		Library:FastNotify("Discord Invite Copied!", "Copied Discord Invite, Make Sure To Join Us For More Updates!")

		setclipboard("Discord.gg/v3n")
	end)

	MinimizeButton_1.MouseButton1Click:Connect(function()
		Bool = not Bool
		MainFrame_1.Visible = Bool

		Library:CreateNotification({
			Title = "Imperium", 
			Content = "Press "..  MinimizeKeybind.Name  .." to open the gui",
			Duration = 4,
		})
	end)

	CloseButton_1.MouseButton1Click:Connect(function()
		MainFrame_1:Destroy()
		Imperium:Destroy()
		Bool = false
	end)

	UserInputService.InputBegan:Connect(function(Input, Procesed)
		if Procesed then return end

		if Input.KeyCode == MinimizeKeybind then 
			Bool = not Bool
			MainFrame_1.Visible = Bool
		end
	end)

	function Tabs:CreateTab(Info2)
		local SelectedTab
		local Elements = {}

		local Tab2_1 = Instance.new("Frame")
		local UICorner_2 = Instance.new("UICorner")
		local TabIcon_1 = Instance.new("ImageLabel")
		local TabName = Instance.new("TextLabel")
		local UIStroke_2 = Instance.new("UIStroke")
		local UIGradient_1 = Instance.new("UIGradient")
		local UIGradient_2 = Instance.new("UIGradient")
		local Button_1 = Instance.new("TextButton")
		local TabContainer_1 = Instance.new("ScrollingFrame")
		local ContainerName_1 = Instance.new("TextLabel")
		local UIListLayout_2 = Instance.new("UIListLayout")
		local UIPadding_1 = Instance.new("UIPadding")

		Tab2_1.Name = Info2.Name or "Tab"
		Tab2_1.Parent = SideBar_1
		Tab2_1.BackgroundColor3 = Color3.fromRGB(95, 72, 118)
		Tab2_1.BackgroundTransparency = 0.90
		Tab2_1.BorderSizePixel = 0
		Tab2_1.Position = UDim2.new(0.0759493634, 0, 0, 0)
		Tab2_1.Size = UDim2.new(1, 0, 0, 34)
		
		CreateGradient(Tab2_1 ,Color3.fromRGB(254, 222, 255), Color3.fromRGB(255, 231, 207), Color3.fromRGB(207, 245, 255),nil,  "Special")

		UICorner_2.Parent = Tab2_1
		UICorner_2.CornerRadius = UDim.new(0, 8)

		TabIcon_1.Name = "TabIcon"
		TabIcon_1.Parent = Tab2_1
		TabIcon_1.Position = UDim2.new(0.04375, 0, 0.5, -10)
		TabIcon_1.Size = UDim2.new(0, 20, 0, 20)
		TabIcon_1.BackgroundTransparency = 1
		TabIcon_1.Image = GetIconFromLucide(Info2.Icon) or "rbxasset://textures/ui/GuiImagePlaceholder.png"

		TabName.Parent = Tab2_1
		TabName.AnchorPoint = Vector2.new(0, 0.5)
		TabName.Position = UDim2.new(0.55, -55, 0.5, 0)
		TabName.Size = UDim2.new(0, 110, 0, 18)
		TabName.BackgroundTransparency = 1
		TabName.FontFace = FontType
		TabName.Text = Info2.Name or "Tab"
		TabName.TextColor3 = Color3.fromRGB(255, 255, 255)
		TabName.TextSize = 14
		TabName.TextXAlignment = Enum.TextXAlignment.Left

		UIStroke_2.Parent = Tab2_1
		UIStroke_2.Color = Color3.fromRGB(136, 109, 152)
		UIStroke_2.Thickness = 1
		UIStroke_2.Transparency = 1

		CreateGradient(UIStroke_2,Color3.fromRGB(254, 222, 255), Color3.fromRGB(255, 231, 207), Color3.fromRGB(207, 245, 255),nil,  "Special")
		
		UIGradient_2.Parent = Tab2_1
		UIGradient_2.Color = ColorSequence.new {
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(182, 182, 182))
		}
		UIGradient_2.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,0), NumberSequenceKeypoint.new(1,0.652174)}
		UIGradient_2.Enabled = false

		Button_1.Name = "Button"
		Button_1.Parent = Tab2_1
		Button_1.Active = true
		Button_1.BackgroundTransparency = 1
		Button_1.Size = UDim2.new(1, 0, 1, 0)
		Button_1.Text = ""

		TabContainer_1.Name = Info2.Name or "TabContainer"
		TabContainer_1.Visible = false
		TabContainer_1.Parent = Container_1
		TabContainer_1.Active = true
		TabContainer_1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TabContainer_1.BackgroundTransparency = 1
		TabContainer_1.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabContainer_1.BorderSizePixel = 0
		TabContainer_1.Size = UDim2.new(0, 473, 0, 421)
		TabContainer_1.ClipsDescendants = true
		TabContainer_1.BottomImage = "rbxasset://textures/ui/Scroll/scroll-bottom.png"
		TabContainer_1.CanvasPosition = Vector2.new(0, 0)
		TabContainer_1.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
		TabContainer_1.HorizontalScrollBarInset = Enum.ScrollBarInset.None
		TabContainer_1.MidImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
		TabContainer_1.ScrollBarImageColor3 = Color3.fromRGB(159, 62, 255)
		TabContainer_1.ScrollBarImageTransparency = 0
		TabContainer_1.ScrollBarThickness = 0
		TabContainer_1.ScrollingDirection = Enum.ScrollingDirection.XY
		TabContainer_1.CanvasSize = UDim2.new(0, 473,0,0)
		TabContainer_1.TopImage = "rbxasset://textures/ui/Scroll/scroll-top.png"
		TabContainer_1.VerticalScrollBarInset = Enum.ScrollBarInset.None
		TabContainer_1.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
		TabContainer_1.AutomaticCanvasSize = Enum.AutomaticSize.Y 

		ContainerName_1.Name = "ContainerName"
		ContainerName_1.Parent = TabContainer_1
		ContainerName_1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ContainerName_1.BackgroundTransparency = 1
		ContainerName_1.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ContainerName_1.BorderSizePixel = 0
		ContainerName_1.Position = UDim2.new(0.0147991544, 0, 0, 0)
		ContainerName_1.Size = UDim2.new(0, 466, 0, 23)
		ContainerName_1.FontFace = FontType
		ContainerName_1.Text = Info2.Name or "Tab"
		ContainerName_1.TextColor3 = Color3.fromRGB(255, 255, 255)
		ContainerName_1.TextSize = 14
		ContainerName_1.TextXAlignment = Enum.TextXAlignment.Left

		UIListLayout_2.Parent = TabContainer_1
		UIListLayout_2.Padding = UDim.new(0, 8)
		UIListLayout_2.HorizontalAlignment = Enum.HorizontalAlignment.Left
		UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder

		UIPadding_1.Parent = TabContainer_1
		UIPadding_1.PaddingLeft = UDim.new(0, 10)
		UIPadding_1.PaddingTop = UDim.new(0, 5)

		local function GetFirstTab()
			if #SideBar_1:GetChildren() > 1 then
				for _, v in next, SideBar_1:GetChildren() do
					if v:IsA("Frame") then return v end
					print(v)
				end
			end
			return nil
		end

		local function GetContainer(name)
			for _, v in next, Container_1:GetChildren() do
				if v.Name == name then
					return v
				end
			end
			return nil
		end

		local function Animate(Container, Direction)
			if Container then
				local Padding = Container:FindFirstChild("UIPadding")

				if  Padding then
					if Direction == "Right" then
						local Tween = TweenService:Create(Padding, TweenInfo.new(0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {PaddingLeft = UDim.new(2,0)})
						Tween:Play()
					elseif Direction == "Left" then
						local Tween = TweenService:Create(Padding, TweenInfo.new(0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {PaddingLeft = UDim.new(0,15)})
						Tween:Play()
					end
				end
			end
		end

		if GetFirstTab() then
			SelectedTab = GetFirstTab()

			local Container = GetContainer(SelectedTab.Name)
			SelectedTab.BackgroundColor3 = Color3.fromRGB(78, 62, 91)
			SelectedTab.BackgroundTransparency = 0.45

			local Gradient, Stroke = SelectedTab:FindFirstChild("UIGradient"), SelectedTab:FindFirstChild("UIStroke")

			if Container then
				Container.Visible = true
				Container:WaitForChild("UIPadding").PaddingLeft = UDim.new(0, 100)
				Animate(Container, "Left")
			end

			if Gradient then
				Gradient.Enabled = true
			end

			if Stroke then
				TweenService:Create(Stroke, TweenInfo.new(0.4), {Transparency = 0}):Play()
				TweenService:Create(Stroke, TweenInfo.new(0.4), {Color = Color3.fromRGB(126, 100, 147)}):Play()
			end
		end

		local debounce = false 

		for _, v in next, SideBar_1:GetChildren() do
			if v:IsA("Frame") and v:FindFirstChild("Button") then
				local Button = v.Button

				Button.MouseButton1Click:Connect(function()
					if debounce then return end 
					debounce = true  

					if v ~= SelectedTab then
						--// old
						SelectedTab.BackgroundTransparency = 0.9
						local PastContainer = GetContainer(SelectedTab.Name)
						local Gradient, Stroke = SelectedTab:FindFirstChild("UIGradient"), SelectedTab:FindFirstChild("UIStroke")
						SelectedTab.BackgroundColor3 = Color3.fromRGB(95, 72, 118)

						if Gradient then
							Gradient.Enabled = false
						end

						if Stroke then
							TweenService:Create(Stroke, TweenInfo.new(0.4), {Transparency = 1}):Play()
							TweenService:Create(Stroke, TweenInfo.new(0.4), {Color = Color3.fromRGB(152, 152, 152)}):Play()
						end

						if PastContainer then
							PastContainer.Visible = false
						end

						SelectedTab = v
						--// new
						SelectedTab.BackgroundTransparency = 0.45
						local NewContainer = GetContainer(SelectedTab.Name)

						local Gradient, Stroke = SelectedTab:FindFirstChild("UIGradient"), SelectedTab:FindFirstChild("UIStroke")
						SelectedTab.BackgroundColor3 = Color3.fromRGB(60, 57, 88)

						if Gradient then
							Gradient.Enabled = true
						end

						if NewContainer then
							NewContainer.Visible = true
						end

						if Stroke then
							TweenService:Create(Stroke, TweenInfo.new(0.4), {Transparency = 0}):Play()
							TweenService:Create(Stroke, TweenInfo.new(0.4), {Color = Color3.fromRGB(110, 110, 145)}):Play()
						end
					end

					task.wait(0.4) 
					debounce = false  
				end)

				coroutine.wrap(function()
					local Stroke = v:FindFirstChild("UIStroke")
					v.MouseEnter:Connect(function()
						if SelectedTab  and v ~= SelectedTab then
							TweenService:Create(Stroke, TweenInfo.new(0.3), {Transparency = 0.3}):Play()
						end
					end)

					v.MouseLeave:Connect(function()
						if SelectedTab and v ~= SelectedTab then
							TweenService:Create(Stroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
						end
					end)
				end)()
			end
		end

		--//  Toggle
		function Elements:CreateToggle(Info3)
			local SelfActions = {}

			local Callback = Info3.Callback
			local Bool = Info3.Default or false
			local Flag = Info3.Flag or ""

			local Toggle_1 = Instance.new("Frame")
			local UICorner_7 = Instance.new("UICorner")
			local UIStroke_3 = Instance.new("UIStroke")
			local UIGradient_3 = Instance.new("UIGradient")
			local ToggleDescription_1 = Instance.new("TextLabel")
			local ToggleName_1 = Instance.new("TextLabel")
			local ToggleHolder_1 = Instance.new("Frame")
			local Dot_1 = Instance.new("Frame")
			local UICorner_8 = Instance.new("UICorner")
			local UICorner_9 = Instance.new("UICorner")
			local UIStroke_4 = Instance.new("UIStroke")
			local Button_3 = Instance.new("TextButton")
			local UIGradient_4 = Instance.new("UIGradient")

			Toggle_1.Name = Info3.Flag or "Toggle"
			Toggle_1.Parent = TabContainer_1
			Toggle_1.BackgroundColor3 = Color3.fromRGB(83, 83, 86)
			Toggle_1.BackgroundTransparency = 0.6000000238418579
			Toggle_1.BorderColor3 = Color3.fromRGB(0,0,0)
			Toggle_1.BorderSizePixel = 0
			Toggle_1.Position = UDim2.new(-0.352963328, 0,0.0546318293, 0)
			Toggle_1.Size = UDim2.new(0, 453,0, 66)
			
			CreateGradient(Toggle_1,Color3.fromRGB(254, 222, 255), Color3.fromRGB(255, 231, 207), Color3.fromRGB(207, 245, 255),nil,  "Special")

			UICorner_7.Parent = Toggle_1
			UICorner_7.CornerRadius = UDim.new(0,15)

			UIStroke_3.Parent = Toggle_1
			UIStroke_3.Color = Color3.fromRGB(127, 127, 131)
			UIStroke_3.Thickness = 1

			ToggleDescription_1.Name = "ToggleDescription"
			ToggleDescription_1.Parent = Toggle_1
			ToggleDescription_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
			ToggleDescription_1.BackgroundTransparency = 1
			ToggleDescription_1.BorderColor3 = Color3.fromRGB(0,0,0)
			ToggleDescription_1.BorderSizePixel = 0
			ToggleDescription_1.Position = UDim2.new(0.0147992065, 0,0.348484844, 0)
			ToggleDescription_1.Size = UDim2.new(0, 349,0, 38)
			ToggleDescription_1.FontFace = FontType
			ToggleDescription_1.Text = Info3.Description or "ipsum dolor ist semen allah and toate cele"
			ToggleDescription_1.TextColor3  = Color3.fromRGB(unpack(Config.GlobalDescriptionColor))
			ToggleDescription_1.TextSize = 14
			ToggleDescription_1.TextWrapped = true
			ToggleDescription_1.TextXAlignment = Enum.TextXAlignment.Left
			ToggleDescription_1.TextYAlignment = Enum.TextYAlignment.Top
			
			CreateGradient(ToggleDescription_1,Color3.fromRGB(254, 222, 255), Color3.fromRGB(255, 231, 207), Color3.fromRGB(207, 245, 255),nil,  "Special")

			ToggleName_1.Name = "ToggleName"
			ToggleName_1.Parent = Toggle_1
			ToggleName_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
			ToggleName_1.BackgroundTransparency = 1
			ToggleName_1.BorderColor3 = Color3.fromRGB(0,0,0)
			ToggleName_1.BorderSizePixel = 0
			ToggleName_1.Position = UDim2.new(0.0147992065, 0,0, 0)
			ToggleName_1.Size = UDim2.new(0, 349,0, 23)
			ToggleName_1.FontFace = FontType
			ToggleName_1.Text = Info3.Name or "ToggleName"
			ToggleName_1.TextColor3 = Color3.fromRGB(255,255,255)
			ToggleName_1.TextSize = 14
			ToggleName_1.TextXAlignment = Enum.TextXAlignment.Left

			ToggleHolder_1.Name = "ToggleHolder"
			ToggleHolder_1.Parent = Toggle_1
			ToggleHolder_1.BackgroundColor3 = Color3.fromRGB(75,75,75)
			ToggleHolder_1.BackgroundTransparency = 0.8500000238418579
			ToggleHolder_1.BorderColor3 = Color3.fromRGB(0,0,0)
			ToggleHolder_1.BorderSizePixel = 0
			ToggleHolder_1.Position = UDim2.new(0.867549658, 0,0.333333343, 0)
			ToggleHolder_1.Size = UDim2.new(0, 50,0, 21)

			Dot_1.Name = "Dot"
			Dot_1.Parent = ToggleHolder_1
			Dot_1.AnchorPoint = Vector2.new(0, 0.5)
			Dot_1.BackgroundColor3 = Color3.fromRGB(114, 140, 144)
			Dot_1.BorderColor3 = Color3.fromRGB(0,0,0)
			Dot_1.BorderSizePixel = 0
			Dot_1.Position = UDim2.new(0.0599999987, 0,0.5, 0)
			Dot_1.Size = UDim2.new(0, 17,0, 17)

			UICorner_8.Parent = Dot_1
			UICorner_8.CornerRadius = UDim.new(1,0)

			UICorner_9.Parent = ToggleHolder_1
			UICorner_9.CornerRadius = UDim.new(1,0)

			UIStroke_4.Parent = ToggleHolder_1
			UIStroke_4.Color = Color3.fromRGB(114, 140, 144)
			UIStroke_4.Thickness = 1.4

			Button_3.Name = "Button"
			Button_3.Parent = ToggleHolder_1
			Button_3.Active = true
			Button_3.BackgroundColor3 = Color3.fromRGB(255,255,255)
			Button_3.BackgroundTransparency = 1
			Button_3.BorderColor3 = Color3.fromRGB(0,0,0)
			Button_3.BorderSizePixel = 0
			Button_3.Size = UDim2.new(1, 0,1, 0)
			Button_3.FontFace = FontType
			Button_3.Text = ""
			Button_3.TextSize = 14

			UIGradient_4.Parent = Toggle_1
			UIGradient_4.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(213, 213, 213)), ColorSequenceKeypoint.new(1, Color3.fromRGB(16, 16, 16))}
			UIGradient_4.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,0.335404), NumberSequenceKeypoint.new(1,0.795031)}

			if Info3.Default then
				if Info3.Default == true then
					TweenService:Create(UIStroke_4, TweenInfo.new(Config.ToggleSpeed), {Color = Color3.fromRGB(205, 253, 255)}):Play()
					TweenService:Create(Dot_1, TweenInfo.new(Config.ToggleSpeed), {BackgroundColor3 = Color3.fromRGB(205, 253, 255)}):Play()
					TweenService:Create(Dot_1, TweenInfo.new(Config.ToggleSpeed), {Position = UDim2.new(0.58, 0, 0.5, 0)}):Play()
				else
					TweenService:Create(UIStroke_4, TweenInfo.new(Config.ToggleSpeed), {Color = Color3.fromRGB(114, 140, 144)}):Play()
					TweenService:Create(Dot_1, TweenInfo.new(Config.ToggleSpeed), {BackgroundColor3 = Color3.fromRGB(114, 140, 144)}):Play()
					TweenService:Create(Dot_1, TweenInfo.new(Config.ToggleSpeed), {Position = UDim2.new(0.06, 0, 0.5, 0)}):Play()
				end

				coroutine.wrap(function()
					local Success, Error = pcall(function() Callback(Bool) end)
					if not Success then
						Library:FastNotify("Toggle Error", tostring(Error))
					end
				end)()
			end

			if type(Callback) == "function" then
				Button_3.MouseButton1Click:Connect(function()
					Bool = not Bool

					if IsExecutionEnv then
						SaveFlag(FileBranch.Configs, Flag, Bool)
					end

					if Bool then
						TweenService:Create(UIStroke_4, TweenInfo.new(Config.ToggleSpeed), {Color = Color3.fromRGB(205, 253, 255)}):Play()
						TweenService:Create(Dot_1, TweenInfo.new(Config.ToggleSpeed), {BackgroundColor3 = Color3.fromRGB(205, 253, 255)}):Play()
						TweenService:Create(Dot_1, TweenInfo.new(Config.ToggleSpeed), {Position = UDim2.new(0.58, 0, 0.5, 0)}):Play()
					else
						TweenService:Create(UIStroke_4, TweenInfo.new(Config.ToggleSpeed), {Color = Color3.fromRGB(114, 140, 144)}):Play()
						TweenService:Create(Dot_1, TweenInfo.new(Config.ToggleSpeed), {BackgroundColor3 = Color3.fromRGB(114, 140, 144)}):Play()
						TweenService:Create(Dot_1, TweenInfo.new(Config.ToggleSpeed), {Position = UDim2.new(0.06, 0, 0.5, 0)}):Play()
					end

					coroutine.wrap(function()
						local Success, Error = pcall(function() Callback(Bool) end)
						if not Success then
							Library:FastNotify("Toggle Error", tostring(Error))
						end
					end)()
				end)
			end

			SelfActions =  {
				SetValue = function(self, value)
					if type(value) == "boolean" then
						coroutine.wrap(function()
							local Success, Error = pcall(function() Callback(value) end)
							if not Success then
								Library:FastNotify("Toggle Error", tostring(Error))
							end
						end)()

						if value == true then
							TweenService:Create(UIStroke_4, TweenInfo.new(Config.ToggleSpeed), {Color = Color3.fromRGB(205, 253, 255)}):Play()
							TweenService:Create(Dot_1, TweenInfo.new(Config.ToggleSpeed), {BackgroundColor3 = Color3.fromRGB(205, 253, 255)}):Play()
							TweenService:Create(Dot_1, TweenInfo.new(Config.ToggleSpeed), {Position = UDim2.new(0.58, 0, 0.5, 0)}):Play()
						else
							TweenService:Create(UIStroke_4, TweenInfo.new(Config.ToggleSpeed), {Color = Color3.fromRGB(114, 140, 144)}):Play()
							TweenService:Create(Dot_1, TweenInfo.new(Config.ToggleSpeed), {BackgroundColor3 = Color3.fromRGB(114, 140, 144)}):Play()
							TweenService:Create(Dot_1, TweenInfo.new(Config.ToggleSpeed), {Position = UDim2.new(0.06, 0, 0.5, 0)}):Play()
						end
					else
						Library:CreateNotification({
							Title = "Imperium - action error",
							Content = "SetValue failed, make sure the value is a boolean.",
							Duration = 4
						})
					end
				end
			}

			if IsExecutionEnv then
				local Flags = GetFlags(FileBranch.Configs)

				for i, v in next, Flags do
					if i == Flag and v ~= nil then
						SelfActions:SetValue(v)
					end
				end
			end

			return SelfActions
		end

		--//  Slider
		function Elements:CreateSlider(Info4)
			local SelfActions = {}

			local Flag = Info4.Flag or ""
			local Callback = Info4.Callback
			local Default, MaxValue, MinValue, Increment = Info4.Default, Info4.MaxValue, Info4.MinValue, Info4.Increment

			local Slider_1 = Instance.new("Frame")
			local UICorner_13 = Instance.new("UICorner")
			local UIStroke_7 = Instance.new("UIStroke")
			local UIGradient_7 = Instance.new("UIGradient")
			local SliderDescription_1 = Instance.new("TextLabel")
			local SliderName_1 = Instance.new("TextLabel")
			local SliderHolder_1 = Instance.new("Frame")
			local Maximum_1 = Instance.new("Frame")
			local Percent_1 = Instance.new("Frame")
			local UICorner_14 = Instance.new("UICorner")
			local Dot_3 = Instance.new("TextButton")
			local UICorner_15 = Instance.new("UICorner")
			local UICorner_16 = Instance.new("UICorner")
			local ValueInput_1 = Instance.new("TextLabel")
			local UIGradient_8 = Instance.new("UIGradient")

			Slider_1.Name = "Slider"
			Slider_1.Parent = TabContainer_1
			Slider_1.BackgroundColor3 = Color3.fromRGB(83, 83, 86)
			Slider_1.BackgroundTransparency = 0.6000000238418579
			Slider_1.BorderColor3 = Color3.fromRGB(0,0,0)
			Slider_1.BorderSizePixel = 0
			Slider_1.Position = UDim2.new(-0.352963328, 0,0.0546318293, 0)
			Slider_1.Size = UDim2.new(0, 453,0, 66)
			
			CreateGradient(Slider_1,Color3.fromRGB(254, 222, 255), Color3.fromRGB(255, 231, 207), Color3.fromRGB(207, 245, 255),nil,  "Special")

			UICorner_13.Parent = Slider_1
			UICorner_13.CornerRadius = UDim.new(0,15)

			UIStroke_7.Parent = Slider_1
			UIStroke_7.Color = Color3.fromRGB(127, 127, 131)
			UIStroke_7.Thickness = 1
			
			CreateGradient(UIStroke_7,Color3.fromRGB(254, 222, 255), Color3.fromRGB(255, 231, 207), Color3.fromRGB(207, 245, 255),nil,  "Special")

			UIGradient_7.Parent = UIStroke_7
			UIGradient_7.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,0), NumberSequenceKeypoint.new(1,0.757764)}

			SliderDescription_1.Name = "SliderDescription"
			SliderDescription_1.Parent = Slider_1
			SliderDescription_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
			SliderDescription_1.BackgroundTransparency = 1
			SliderDescription_1.BorderColor3 = Color3.fromRGB(0,0,0)
			SliderDescription_1.BorderSizePixel = 0
			SliderDescription_1.Position = UDim2.new(0.0147996107, 0,0.348484844, 0)
			SliderDescription_1.Size = UDim2.new(0, 265,0, 38)
			SliderDescription_1.FontFace = FontType
			SliderDescription_1.Text = Info4.Description or ""
			SliderDescription_1.TextColor3 = Color3.fromRGB(unpack(Config.GlobalDescriptionColor))
			SliderDescription_1.TextSize = 14
			SliderDescription_1.TextWrapped = true
			SliderDescription_1.TextXAlignment = Enum.TextXAlignment.Left
			SliderDescription_1.TextYAlignment = Enum.TextYAlignment.Top
			
			CreateGradient(SliderDescription_1,Color3.fromRGB(254, 222, 255), Color3.fromRGB(255, 231, 207), Color3.fromRGB(207, 245, 255),nil,  "Special")

			SliderName_1.Name = "SliderName"
			SliderName_1.Parent = Slider_1
			SliderName_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
			SliderName_1.BackgroundTransparency = 1
			SliderName_1.BorderColor3 = Color3.fromRGB(0,0,0)
			SliderName_1.BorderSizePixel = 0
			SliderName_1.Position = UDim2.new(0.0147992065, 0,0, 0)
			SliderName_1.Size = UDim2.new(0, 349,0, 23)
			SliderName_1.FontFace = FontType
			SliderName_1.Text =  Info4.Name or "Slider"
			SliderName_1.TextColor3 = Color3.fromRGB(255,255,255)
			SliderName_1.TextSize = 14
			SliderName_1.TextXAlignment = Enum.TextXAlignment.Left

			SliderHolder_1.Name = "SliderHolder"
			SliderHolder_1.Parent = Slider_1
			SliderHolder_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
			SliderHolder_1.BackgroundTransparency = 1
			SliderHolder_1.BorderColor3 = Color3.fromRGB(0,0,0)
			SliderHolder_1.BorderSizePixel = 0
			SliderHolder_1.Position = UDim2.new(0.619656146, 0,0.227272734, 0)
			SliderHolder_1.Size = UDim2.new(0, 162,0, 36)

			Maximum_1.Name = "Maximum"
			Maximum_1.Parent = SliderHolder_1
			Maximum_1.BackgroundColor3 = Color3.fromRGB(92, 103, 102)
			Maximum_1.BorderColor3 = Color3.fromRGB(0,0,0)
			Maximum_1.BorderSizePixel = 0
			Maximum_1.Position = UDim2.new(-0.00666666683, 0,0.472222209, 0)
			Maximum_1.Size = UDim2.new(0, 130,0, 2)

			Percent_1.Name = "Percent"
			Percent_1.Parent = Maximum_1
			Percent_1.BackgroundColor3 = Color3.fromRGB(191, 231, 208)
			Percent_1.BorderColor3 = Color3.fromRGB(0,0,0)
			Percent_1.BorderSizePixel = 0
			Percent_1.Size = UDim2.new(0.600000024, 0,1, 0)

			UICorner_14.Parent = Percent_1
			UICorner_14.CornerRadius = UDim.new(1,0)

			Dot_3.Name = "Dot"
			Dot_3.Parent = Percent_1
			Dot_3.Active = true
			Dot_3.AnchorPoint = Vector2.new(0, 0.5)
			Dot_3.BackgroundColor3 = Color3.fromRGB(191, 231, 208)
			Dot_3.BorderColor3 = Color3.fromRGB(0,0,0)
			Dot_3.BorderSizePixel = 0
			Dot_3.Position = UDim2.new(1, 0,0.5, 0)
			Dot_3.Size = UDim2.new(0, 10,0, 10)
			Dot_3.FontFace = FontType
			Dot_3.Text = ""
			Dot_3.TextSize = 14

			UICorner_15.Parent = Dot_3
			UICorner_15.CornerRadius = UDim.new(1,0)

			UICorner_16.Parent = Maximum_1
			UICorner_16.CornerRadius = UDim.new(1,0)

			ValueInput_1.Name = "ValueInput"
			ValueInput_1.Parent = SliderHolder_1
			ValueInput_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
			ValueInput_1.BackgroundTransparency = 1
			ValueInput_1.BorderColor3 = Color3.fromRGB(0,0,0)
			ValueInput_1.BorderSizePixel = 0
			ValueInput_1.Position = UDim2.new(0.872196138, 0,0.166666672, 0)
			ValueInput_1.Size = UDim2.new(0, 25,0, 23)
			ValueInput_1.FontFace = FontType
			ValueInput_1.Text = tostring(Default) or "error!"
			ValueInput_1.TextColor3 = Color3.fromRGB(255,255,255)
			ValueInput_1.TextSize = 14
			ValueInput_1.TextWrapped = true
			ValueInput_1.TextXAlignment = Enum.TextXAlignment.Left

			UIGradient_8.Parent = Slider_1
			UIGradient_8.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(213, 213, 213)), ColorSequenceKeypoint.new(1, Color3.fromRGB(16, 16, 16))}
			UIGradient_8.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,0.335404), NumberSequenceKeypoint.new(1,0.795031)}

			local Value = Default or MinValue
			local IsDragging = false

			if Default ~= nil then
				local percentv = (Default - MinValue) / (MaxValue - MinValue)
				Percent_1.Size = UDim2.new(percentv, 0, 1, 0)
				Dot_3.Position = UDim2.new(1, 0,0.5, 0)
				ValueInput_1.Text = tostring(Default)

				if type(Callback) == "function" then
					coroutine.wrap(function()
						local Success, Error = pcall(function() Callback(Default) end)
						if not Success then
							Library:FastNotify("Slider Error", tostring(Error))
						end
					end)()
				end

			elseif MinValue ~= nil then
				Percent_1.Size = UDim2.new(0, 0, 1, 0)
				Dot_3.Position = UDim2.new(1, 0,0.5, 0)
				ValueInput_1.Text = tostring(MinValue)

				if type(Callback) == "function" then
					coroutine.wrap(function()
						local Success, Error = pcall(function() Callback(MinValue) end)
						if not Success then
							Library:FastNotify("Slider Error", tostring(Error))
						end
					end)()
				end
			end

			Dot_3.MouseButton1Down:Connect(function()
				IsDragging = true
			end)

			UserInputService.InputEnded:Connect(function(inp)
				if inp.UserInputType == Enum.UserInputType.MouseButton1 then
					IsDragging = false
				end
			end)

			RunService.Heartbeat:Connect(function()
				if IsDragging then
					local Position = UserInputService:GetMouseLocation().X
					local abss = Maximum_1.AbsolutePosition.X
					local widthq = Maximum_1.AbsoluteSize.X
					local percentv = math.clamp((Position - abss) / widthq, 0, 1)

					Value = math.floor(((MinValue + ((MaxValue - MinValue) * percentv)) / Increment) + 0.5) * Increment
					ValueInput_1.Text = string.format("%." .. tostring(math.log10(1 / Increment)) .. "f", Value)

					if IsExecutionEnv then
						SaveFlag(FileBranch.Configs, Flag, Value)
					end
					local Tween1 = TweenService:Create(Dot_3, TweenInfo.new(Config.SliderSpeed, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.new(1, 0, 0.5, 0)})
					local Tween2 = TweenService:Create(Percent_1, TweenInfo.new(Config.SliderSpeed, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(percentv, 0, 1, 0)})

					Tween1:Play()
					Tween2:Play()

					if type(Callback) == "function" then
						coroutine.wrap(function()
							local Success, Error = pcall(function() Callback(Value) end)
							if not Success then
								Library:FastNotify("Slider Error", tostring(Error))
							end
						end)()
					end
				end
			end)

			SelfActions =  {
				SetValue = function(self, value)
					value = math.clamp(value, MinValue, MaxValue)
					local percentv = (value - MinValue) / (MaxValue - MinValue)

					Value = value
					ValueInput_1.Text = string.format("%." .. tostring(math.log10(1 / Increment)) .. "f", Value)

					local Tween1 = TweenService:Create(Dot_3, TweenInfo.new(Config.SliderSpeed, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.new(percentv, 0, 0.5, 0)})
					local Tween2 = TweenService:Create(Percent_1, TweenInfo.new(Config.SliderSpeed, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(percentv, 0, 1, 0)})

					Tween1:Play()
					Tween2:Play()

					if type(Callback) == "function" then
						coroutine.wrap(function()
							local Success, Error = pcall(function() Callback(value) end)
							if not Success then
								Library:FastNotify("Slider Error", tostring(Error))
							end
						end)()
					end
				end,
			}

			if IsExecutionEnv then
				local Flags = GetFlags(FileBranch.Configs)

				for i, v in next, Flags do
					if i == Flag and v ~= nil then
						SelfActions:SetValue(v)
					end
				end
			end

			return SelfActions
		end
		--//  Section
		function Elements:CreateSection(Info5)
			local Section_1 = Instance.new("TextLabel")

			Section_1.Name = Info5.Title or "Section"
			Section_1.Parent = TabContainer_1
			Section_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
			Section_1.BackgroundTransparency = 1
			Section_1.BorderColor3 = Color3.fromRGB(0,0,0)
			Section_1.BorderSizePixel = 0
			Section_1.Position = UDim2.new(0.0201271195, 0,0.430288464, 0)
			Section_1.Size = UDim2.new(0, 453,0, 20)
			Section_1.FontFace = FontType
			Section_1.Text = Info5.Title or "Section"
			Section_1.TextColor3 = Color3.fromRGB(222,222,222)
			Section_1.TextSize = 14
			Section_1.TextXAlignment = Enum.TextXAlignment.Left
		end

		--//  Input
		function Elements:CreateInput(Info6)
			local SelfActions = {}

			local Flag = Info6.Flag or ""
			local Default = Info6.Default or "Text"
			local Placeholder = Info6.Placeholder or "Text"
			local Callback = Info6.Callback

			local Input = Instance.new("Frame")
			local UICorner_1 = Instance.new("UICorner")
			local UIStroke_1 = Instance.new("UIStroke")
			local UIGradient_1 = Instance.new("UIGradient")
			local UIGradient_2 = Instance.new("UIGradient")
			local InputDescription_1 = Instance.new("TextLabel")
			local InputHolder_1 = Instance.new("Frame")
			local Input_1 = Instance.new("TextBox")
			local UIStroke_2 = Instance.new("UIStroke")
			local UICorner_2 = Instance.new("UICorner")
			local InputName_1 = Instance.new("TextLabel")

			Input.Name = "Input"
			Input.Parent = TabContainer_1
			Input.BackgroundColor3 = Color3.fromRGB(83, 83, 86)
			Input.BackgroundTransparency = 0.6000000238418579
			Input.BorderColor3 = Color3.fromRGB(0,0,0)
			Input.BorderSizePixel = 0
			Input.Position = UDim2.new(-0.352963328, 0,0.0546318293, 0)
			Input.Size = UDim2.new(0, 453,0, 66)
			
			CreateGradient(Input,Color3.fromRGB(254, 222, 255), Color3.fromRGB(255, 231, 207), Color3.fromRGB(207, 245, 255),nil,  "Special")

			UICorner_1.Parent = Input
			UICorner_1.CornerRadius = UDim.new(0,15)

			UIStroke_1.Parent = Input
			UIStroke_1.Color = Color3.fromRGB(127, 127, 127)
			UIStroke_1.Thickness = 1
			
			CreateGradient(UIStroke_1,Color3.fromRGB(254, 222, 255), Color3.fromRGB(255, 231, 207), Color3.fromRGB(207, 245, 255),nil,  "Special")

			UIGradient_2.Parent = Input
			UIGradient_2.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(213, 213, 213)), ColorSequenceKeypoint.new(1, Color3.fromRGB(16, 16, 16))}
			UIGradient_2.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,0.335404), NumberSequenceKeypoint.new(1,0.795031)}

			InputDescription_1.Name = "InputDescription"
			InputDescription_1.Parent = Input
			InputDescription_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
			InputDescription_1.BackgroundTransparency = 1
			InputDescription_1.BorderColor3 = Color3.fromRGB(0,0,0)
			InputDescription_1.BorderSizePixel = 0
			InputDescription_1.Position = UDim2.new(0.0147992065, 0,0.348484844, 0)
			InputDescription_1.Size = UDim2.new(0, 300,0, 38)
			InputDescription_1.FontFace = FontType
			InputDescription_1.Text = Info6.Description or ""
			InputDescription_1.TextColor3  = Color3.fromRGB(unpack(Config.GlobalDescriptionColor))
			InputDescription_1.TextSize = 14
			InputDescription_1.TextWrapped = true
			InputDescription_1.TextXAlignment = Enum.TextXAlignment.Left
			InputDescription_1.TextYAlignment = Enum.TextYAlignment.Top
			
			CreateGradient(InputDescription_1,Color3.fromRGB(254, 222, 255), Color3.fromRGB(255, 231, 207), Color3.fromRGB(207, 245, 255),nil,  "Special")

			InputHolder_1.Name = "InputHolder"
			InputHolder_1.Parent = Input
			InputHolder_1.BackgroundColor3 = Color3.fromRGB(63,63,63)
			InputHolder_1.BackgroundTransparency = 1
			InputHolder_1.BorderColor3 = Color3.fromRGB(0,0,0)
			InputHolder_1.BorderSizePixel = 0
			InputHolder_1.Position = UDim2.new(0.699125648, 0,0.227272734, 0)
			InputHolder_1.Size = UDim2.new(0, 119,0, 35)

			local SpecialUiList = Instance.new("UIListLayout")
			SpecialUiList.Parent = InputHolder_1
			SpecialUiList.VerticalAlignment = Enum.VerticalAlignment.Center
			SpecialUiList.HorizontalAlignment = Enum.HorizontalAlignment.Right

			Input_1.Name = "Input"
			Input_1.Parent = InputHolder_1
			Input_1.Active = true
			Input_1.BackgroundColor3 = Color3.fromRGB(72, 82, 88)
			Input_1.BackgroundTransparency = 0.6000000238418579
			Input_1.BorderColor3 = Color3.fromRGB(0,0,0)
			Input_1.BorderSizePixel = 0
			Input_1.CursorPosition = -1
			Input_1.Position = UDim2.new(0.310255557, 0,0, 0)
			Input_1.Size = UDim2.new(0.676299095, 0,1, 0)
			Input_1.FontFace = BoldFontType
			Input_1.PlaceholderColor3 = Color3.fromRGB(255, 255, 255)
			Input_1.PlaceholderText = Placeholder or "Input"
			Input_1.Text = Default or "Input"
			Input_1.TextColor3 = Color3.fromRGB(255,255,255)
			Input_1.TextWrapped = true
			Input_1.TextSize = 14

			UIStroke_2.Parent = Input_1
			UIStroke_2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			UIStroke_2.Color = Color3.fromRGB(105, 120, 129)
			UIStroke_2.Thickness = 1.2999999523162842
			
			CreateGradient(UIStroke_2,Color3.fromRGB(254, 222, 255), Color3.fromRGB(255, 231, 207), Color3.fromRGB(207, 245, 255),nil,  "Special")

			UICorner_2.Parent = Input_1
			UICorner_2.CornerRadius = UDim.new(0,15)

			InputName_1.Name = "InputName"
			InputName_1.Parent = Input
			InputName_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
			InputName_1.BackgroundTransparency = 1
			InputName_1.BorderColor3 = Color3.fromRGB(0,0,0)
			InputName_1.BorderSizePixel = 0
			InputName_1.Position = UDim2.new(0.0147992065, 0,0, 0)
			InputName_1.Size = UDim2.new(0, 349,0, 23)
			InputName_1.FontFace = FontType
			InputName_1.Text = Info6.Name or "Input"
			InputName_1.TextColor3 = Color3.fromRGB(255,255,255)
			InputName_1.TextSize = 14
			InputName_1.TextXAlignment = Enum.TextXAlignment.Left

			if type(Callback) == "function" then
				Input_1:GetPropertyChangedSignal("Text"):Connect(function()
					if #Input_1.Text > 14 then Input_1.TextScaled = true end
				end)

				Input_1.FocusLost:Connect(function(Prsd)
					if Info6.IgnoreBlank and Input_1.Text == "" then
						return
					end
					if (not Info6.Finished or Prsd) and Info6.Callback then
						if Info6.Numeric then
							local Number = tonumber(Input_1.Text)
							if Number then
								coroutine.wrap(function()
									local Success, Error = pcall(function() Callback(Number) end)
									if IsExecutionEnv then
										SaveFlag(FileBranch.Configs, Flag, Number)
									end
									if not Success then
										Library:FastNotify("Input Error", tostring(Error))
									end
								end)()
							else
								Library:FastNotify("Input Error", "Error at Input: ".. Info6.Title .. "")
							end
						else
							coroutine.wrap(function()
								local Success, Error = pcall(function() Callback(Input_1.Text) end)
								if IsExecutionEnv then
									SaveFlag(FileBranch.Configs, Flag, Input_1.Text)
								end
								if not Success then
									Library:FastNotify("Input Error", tostring(Error))
								end
							end)()
						end
					end
				end)

				SelfActions =  {
					SetValue = function(self, value)
						Input_1.Text = value
						if Callback then
							coroutine.wrap(function()
								local Success, Error = pcall(function() Callback(value) end)
								if not Success then
									Library:FastNotify("Input Error", tostring(Error))
								end
							end)()
						end
					end,
				}
			else
				Library:FastNotify("Input Error", "Use a function for callback!")
			end

			if IsExecutionEnv then
				local Flags = GetFlags(FileBranch.Configs)

				for i, v in next, Flags do
					if i == Flag and v ~= nil then
						SelfActions:SetValue(v)
					end
				end
			end

			return SelfActions
		end

		--//  Keybind
		function Elements:CreateKeybind(Info7)
			local SelfActions = {}

			local Flag = Info7.Flag or ""
			local CurrentKeybind = Info7.Default or Enum.KeyCode.RightControl
			local IsSelecting = false
			local Callback = Info7.Callback

			local Keybind_1 = Instance.new("Frame")
			local UICorner_19 = Instance.new("UICorner")
			local UIStroke_10 = Instance.new("UIStroke")
			local UIGradient_11 = Instance.new("UIGradient")
			local UIGradient_12 = Instance.new("UIGradient")
			local KeybindDescription_1 = Instance.new("TextLabel")
			local KeybindHolder_1 = Instance.new("Frame")
			local Keybind_2 = Instance.new("TextButton")
			local UIStroke_11 = Instance.new("UIStroke")
			local UICorner_20 = Instance.new("UICorner")
			local KeybindName_1 = Instance.new("TextLabel")
			local SpecialUiList = Instance.new("UIListLayout")

			Keybind_1.Name = Info7.Name or "Keybind"
			Keybind_1.Parent = TabContainer_1
			Keybind_1.BackgroundColor3 = Color3.fromRGB(83, 83, 86)
			Keybind_1.BackgroundTransparency = 0.6000000238418579
			Keybind_1.BorderColor3 = Color3.fromRGB(0,0,0)
			Keybind_1.BorderSizePixel = 0
			Keybind_1.Position = UDim2.new(-0.352963328, 0,0.0546318293, 0)
			Keybind_1.Size = UDim2.new(0, 453,0, 66)
			
			CreateGradient(Keybind_1,Color3.fromRGB(254, 222, 255), Color3.fromRGB(255, 231, 207), Color3.fromRGB(207, 245, 255),nil,  "Special")

			UICorner_19.Parent = Keybind_1
			UICorner_19.CornerRadius = UDim.new(0,15)

			UIStroke_10.Parent = Keybind_1
			UIStroke_10.Color = Color3.fromRGB(127, 127, 131)
			UIStroke_10.Thickness = 1
			
			CreateGradient(UIStroke_10,Color3.fromRGB(254, 222, 255), Color3.fromRGB(255, 231, 207), Color3.fromRGB(207, 245, 255),nil,  "Special")

			UIGradient_12.Parent = Keybind_1
			UIGradient_12.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(213, 213, 213)), ColorSequenceKeypoint.new(1, Color3.fromRGB(16, 16, 16))}
			UIGradient_12.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,0.335404), NumberSequenceKeypoint.new(1,0.795031)}

			KeybindDescription_1.Name = "KeybindDescription"
			KeybindDescription_1.Parent = Keybind_1
			KeybindDescription_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
			KeybindDescription_1.BackgroundTransparency = 1
			KeybindDescription_1.BorderColor3 = Color3.fromRGB(0,0,0)
			KeybindDescription_1.BorderSizePixel = 0
			KeybindDescription_1.Position = UDim2.new(0.0147992065, 0,0.348484844, 0)
			KeybindDescription_1.Size = UDim2.new(0, 340,0, 38)
			KeybindDescription_1.FontFace = FontType
			KeybindDescription_1.Text = Info7.Description or ""
			KeybindDescription_1.TextColor3  = Color3.fromRGB(unpack(Config.GlobalDescriptionColor))
			KeybindDescription_1.TextSize = 14
			KeybindDescription_1.TextWrapped = true
			KeybindDescription_1.TextXAlignment = Enum.TextXAlignment.Left
			KeybindDescription_1.TextYAlignment = Enum.TextYAlignment.Top
			
			CreateGradient(KeybindDescription_1,Color3.fromRGB(254, 222, 255), Color3.fromRGB(255, 231, 207), Color3.fromRGB(207, 245, 255),nil,  "Special")

			KeybindHolder_1.Name = "KeybindHolder"
			KeybindHolder_1.Parent = Keybind_1
			KeybindHolder_1.BackgroundColor3 = Color3.fromRGB(63,63,63)
			KeybindHolder_1.BackgroundTransparency = 1
			KeybindHolder_1.BorderColor3 = Color3.fromRGB(0,0,0)
			KeybindHolder_1.BorderSizePixel = 0
			KeybindHolder_1.Position = UDim2.new(0.780627549, 0,0.227272734, 0)
			KeybindHolder_1.Size = UDim2.new(0, 85,0, 35)

			SpecialUiList.Parent = KeybindHolder_1
			SpecialUiList.VerticalAlignment = Enum.VerticalAlignment.Center
			SpecialUiList.HorizontalAlignment = Enum.HorizontalAlignment.Right

			Keybind_2.Name = "Keybind"
			Keybind_2.Parent = KeybindHolder_1
			Keybind_2.Active = true
			Keybind_2.BackgroundColor3 = Color3.fromRGB(72, 82, 88)
			Keybind_2.BackgroundTransparency = 0.6000000238418579
			Keybind_2.BorderColor3 = Color3.fromRGB(0,0,0)
			Keybind_2.BorderSizePixel = 0
			Keybind_2.Size = UDim2.new(1, 0,1, 0)
			Keybind_2.FontFace = FontType
			Keybind_2.Text = CurrentKeybind.Name or ""
			Keybind_2.TextColor3 = Color3.fromRGB(255,255,255)
			Keybind_2.TextSize = 14

			UIStroke_11.Parent = Keybind_2
			UIStroke_11.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			UIStroke_11.Color = Color3.fromRGB(105, 120, 129)
			UIStroke_11.Thickness = 1.2999999523162842
			
			CreateGradient(UIStroke_11,Color3.fromRGB(254, 222, 255), Color3.fromRGB(255, 231, 207), Color3.fromRGB(207, 245, 255),nil,  "Special")

			UICorner_20.Parent = Keybind_2
			UICorner_20.CornerRadius = UDim.new(0,15)

			KeybindName_1.Name = "KeybindName"
			KeybindName_1.Parent = Keybind_1
			KeybindName_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
			KeybindName_1.BackgroundTransparency = 1
			KeybindName_1.BorderColor3 = Color3.fromRGB(0,0,0)
			KeybindName_1.BorderSizePixel = 0
			KeybindName_1.Position = UDim2.new(0.0147992065, 0,0, 0)
			KeybindName_1.Size = UDim2.new(0, 349,0, 23)
			KeybindName_1.FontFace = FontType
			KeybindName_1.Text = Info7.Name or "Keybind"
			KeybindName_1.TextColor3 = Color3.fromRGB(255,255,255)
			KeybindName_1.TextSize = 14
			KeybindName_1.TextXAlignment = Enum.TextXAlignment.Left

			Keybind_2.MouseButton1Click:Connect(function()
				Keybind_2.Text = "Press any key..."
				IsSelecting = true
			end)

			Keybind_2:GetPropertyChangedSignal("Text"):Connect(function()
				local TextSize = Keybind_2.TextBounds.X

				TweenService:Create(Keybind_2, TweenInfo.new(0.2), {Size = UDim2.new(0, TextSize + 16, Keybind_2.Size.Y.Scale, 0)}):Play()
				TweenService:Create(Keybind_2, TweenInfo.new(0.3), {Position = UDim2.new(0, 85 - Keybind_2.Position.X.Offset, 0,0)}):Play()
			end)

			local TextSize = Keybind_2.TextBounds.X

			TweenService:Create(Keybind_2, TweenInfo.new(0.3), {Size = UDim2.new(0, TextSize + 16, Keybind_2.Size.Y.Scale, 0)}):Play()
			TweenService:Create(Keybind_2, TweenInfo.new(0.3), {Position = UDim2.new(0, 85 - Keybind_2.Position.X.Offset, 0,0)}):Play()

			UserInputService.InputBegan:Connect(function(input, procesed)
				if IsSelecting and not procesed then
					if input.UserInputType == Enum.UserInputType.Keyboard then
						CurrentKeybind = input.KeyCode
						Keybind_2.Text = input.KeyCode.Name
					elseif input.UserInputType == Enum.UserInputType.MouseButton1 or 
						input.UserInputType == Enum.UserInputType.MouseButton2 then
						CurrentKeybind = input.UserInputType
						Keybind_2.Text = input.UserInputType.Name
					end
					IsSelecting = false
				elseif input.KeyCode == CurrentKeybind and not IsSelecting then
					coroutine.wrap(function()
						local Success, Error = pcall(function() Callback(CurrentKeybind) end)

						if IsExecutionEnv then
							SaveFlag(FileBranch.Configs, Flag, CurrentKeybind)
						end

						if not Success then
							Library:FastNotify("Keybind Error", tostring(Error))
						end
					end)()
				elseif input.UserInputType == CurrentKeybind and not IsSelecting then
					coroutine.wrap(function()
						local Success, Error = pcall(function() Callback(CurrentKeybind) end)

						if IsExecutionEnv then
							SaveFlag(FileBranch.Configs, Flag, CurrentKeybind)
						end

						if not Success then
							Library:FastNotify("Keybind Error", tostring(Error))
						end
					end)()
				end
			end)

			SelfActions = {
				SetKeybind = function(self, NewKeybind)
					CurrentKeybind = NewKeybind

					if typeof(NewKeybind) == "EnumItem" then
						Keybind_2.Text = NewKeybind.Name
					else
						Keybind_2.Text = tostring(NewKeybind)
					end

					if Callback then
						local Success, Error = pcall(function() Callback(CurrentKeybind) end)
						if not Success then
							Library:FastNotify("Keybind Error", tostring(Error))
						end
					end

					if IsExecutionEnv then
						SaveFlag(FileBranch.Configs, Flag, CurrentKeybind)
					end

				end
			}

			if IsExecutionEnv then
				local Flags = GetFlags(FileBranch.Configs)

				for i, v in next, Flags do
					if i == Flag and v ~= nil then
						SelfActions:SetKeybind(v)
					end
				end
			end
			return SelfActions
		end

		--// Button
		function Elements:CreateButton(Info8)
			local Callback = Info8.Callback

			local Button_5 = Instance.new("Frame")
			local UICorner_17 = Instance.new("UICorner")
			local UIStroke_8 = Instance.new("UIStroke")
			local UIGradient_9 = Instance.new("UIGradient")
			local ButtonDescription_1 = Instance.new("TextLabel")
			local ButtonName_1 = Instance.new("TextLabel")
			local ButtonHolder_1 = Instance.new("Frame")
			local UICorner_18 = Instance.new("UICorner")
			local UIStroke_9 = Instance.new("UIStroke")
			local PickButton_1 = Instance.new("TextButton")
			local ImageLabel_1 = Instance.new("ImageLabel")
			local UIGradient_10 = Instance.new("UIGradient")

			Button_5.Name = "Button"
			Button_5.Parent = TabContainer_1
			Button_5.BackgroundColor3 = Color3.fromRGB(83, 83, 86)
			Button_5.BackgroundTransparency = 0.6000000238418579
			Button_5.BorderColor3 = Color3.fromRGB(0,0,0)
			Button_5.BorderSizePixel = 0
			Button_5.Position = UDim2.new(-0.352963328, 0,0.0546318293, 0)
			Button_5.Size = UDim2.new(0, 453,0, 66)
			
			CreateGradient(Button_5,Color3.fromRGB(254, 222, 255), Color3.fromRGB(255, 231, 207), Color3.fromRGB(207, 245, 255),nil,  "Special")

			UICorner_17.Parent = Button_5
			UICorner_17.CornerRadius = UDim.new(0,15)

			UIStroke_8.Parent = Button_5
			UIStroke_8.Color = Color3.fromRGB(127, 127, 131)
			UIStroke_8.Thickness = 1
			
			CreateGradient(UIStroke_8,Color3.fromRGB(254, 222, 255), Color3.fromRGB(255, 231, 207), Color3.fromRGB(207, 245, 255),nil,  "Special")

			ButtonDescription_1.Name = "ButtonDescription"
			ButtonDescription_1.Parent = Button_5
			ButtonDescription_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
			ButtonDescription_1.BackgroundTransparency = 1
			ButtonDescription_1.BorderColor3 = Color3.fromRGB(0,0,0)
			ButtonDescription_1.BorderSizePixel = 0
			ButtonDescription_1.Position = UDim2.new(0.0147992065, 0,0.348484844, 0)
			ButtonDescription_1.Size = UDim2.new(0, 349,0, 38)
			ButtonDescription_1.FontFace = FontType
			ButtonDescription_1.Text = Info8.Description or ""
			ButtonDescription_1.TextColor3  = Color3.fromRGB(unpack(Config.GlobalDescriptionColor))
			ButtonDescription_1.TextSize = 14
			ButtonDescription_1.TextWrapped = true
			ButtonDescription_1.TextXAlignment = Enum.TextXAlignment.Left
			ButtonDescription_1.TextYAlignment = Enum.TextYAlignment.Top
			
			CreateGradient(ButtonDescription_1,Color3.fromRGB(254, 222, 255), Color3.fromRGB(255, 231, 207), Color3.fromRGB(207, 245, 255),nil,  "Special")

			ButtonName_1.Name = "ButtonName"
			ButtonName_1.Parent = Button_5
			ButtonName_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
			ButtonName_1.BackgroundTransparency = 1
			ButtonName_1.BorderColor3 = Color3.fromRGB(0,0,0)
			ButtonName_1.BorderSizePixel = 0
			ButtonName_1.Position = UDim2.new(0.0147992065, 0,0, 0)
			ButtonName_1.Size = UDim2.new(0, 349,0, 23)
			ButtonName_1.FontFace = FontType
			ButtonName_1.Text = Info8.Name or "Button"
			ButtonName_1.TextColor3 = Color3.fromRGB(255,255,255)
			ButtonName_1.TextSize = 14
			ButtonName_1.TextXAlignment = Enum.TextXAlignment.Left

			ButtonHolder_1.Name = "ButtonHolder"
			ButtonHolder_1.Parent = Button_5
			ButtonHolder_1.BackgroundColor3 = Color3.fromRGB(63,63,63)
			ButtonHolder_1.BackgroundTransparency = 1
			ButtonHolder_1.BorderColor3 = Color3.fromRGB(0,0,0)
			ButtonHolder_1.BorderSizePixel = 0
			ButtonHolder_1.Position = UDim2.new(0.878587186, 0,0.196969703, 0)
			ButtonHolder_1.Size = UDim2.new(0, 40,0, 40)

			local SpecialUiList = Instance.new("UIListLayout")
			SpecialUiList.Parent= ButtonHolder_1
			SpecialUiList.VerticalAlignment = Enum.VerticalAlignment.Center
			SpecialUiList.HorizontalAlignment = Enum.HorizontalAlignment.Center

			PickButton_1.Name = "PickButton"
			PickButton_1.Parent = ButtonHolder_1
			PickButton_1.Active = true
			PickButton_1.AutoButtonColor = false
			PickButton_1.BackgroundColor3 = Color3.fromRGB(83, 83, 86)
			PickButton_1.BackgroundTransparency = 0.6
			PickButton_1.BorderColor3 = Color3.fromRGB(0,0,0)
			PickButton_1.BorderSizePixel = 0
			PickButton_1.Size = UDim2.new(1, 0,1, 0)
			PickButton_1.FontFace = FontType
			PickButton_1.Text = ""
			PickButton_1.TextSize = 14

			UICorner_18.Parent = PickButton_1
			UICorner_18.CornerRadius = UDim.new(0,12.5)

			UIStroke_9.Parent = PickButton_1
			UIStroke_9.Color = Color3.fromRGB(127, 127, 131)
			UIStroke_9.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			UIStroke_9.Thickness = 1.2999999523162842

			ImageLabel_1.Parent = PickButton_1
			ImageLabel_1.AnchorPoint = Vector2.new(0.5, 0.5)
			ImageLabel_1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ImageLabel_1.BackgroundTransparency = 1
			ImageLabel_1.BorderColor3 = Color3.fromRGB(0,0,0)
			ImageLabel_1.BorderSizePixel = 0
			ImageLabel_1.Position = UDim2.new(0.5, 0,0.5, 0)
			ImageLabel_1.Size = UDim2.new(0.75, 0,0.75, 0)
			ImageLabel_1.Image = "rbxassetid://10734898355"

			UIGradient_10.Parent = Button_5
			UIGradient_10.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(213, 213, 213)), ColorSequenceKeypoint.new(1, Color3.fromRGB(16, 16, 16))}
			UIGradient_10.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,0.335404), NumberSequenceKeypoint.new(1,0.795031)}

			local Debounce2 = false
			PickButton_1.MouseButton1Click:Connect(function()
				if Debounce2 then return end
				Debounce2 = true

				coroutine.wrap(function()
					local Success, Error = pcall(function() Callback() end)

					TweenService:Create(UIStroke_9, TweenInfo.new(0.1), {Color = Color3.fromRGB(134, 212, 213)}):Play()
					TweenService:Create(PickButton_1, TweenInfo.new(0.1), {Size = UDim2.new(0.96,0,0.96,0)}):Play()
					task.wait(0.1)
					TweenService:Create(UIStroke_9, TweenInfo.new(0.1), {Color = Color3.fromRGB(127, 127, 131)}):Play()
					TweenService:Create(PickButton_1, TweenInfo.new(0.11), {Size = UDim2.new(1,0,1,0)}):Play()

					if not Success then
						Library:FastNotify("Button Error", tostring(Error))
					end
				end)()

				task.wait(0.3)
				Debounce2 = false
			end)

			return {
				Click = function(self)
					coroutine.wrap(function()
						local Success, Error = pcall(function() Callback() end)

						TweenService:Create(UIStroke_9, TweenInfo.new(0.1), {Color = Color3.fromRGB(95, 85, 144)}):Play()
						TweenService:Create(PickButton_1, TweenInfo.new(0.1), {Size = UDim2.new(0.96,0,0.96,0)}):Play()
						task.wait(0.1)
						TweenService:Create(UIStroke_9, TweenInfo.new(0.1), {Color = Color3.fromRGB(127, 127, 131)}):Play()
						TweenService:Create(PickButton_1, TweenInfo.new(0.11), {Size = UDim2.new(1,0,1,0)}):Play()

						if not Success then
							Library:FastNotify("Button Error", tostring(Error))
						end
					end)()
				end,
			}
		end

		--// Dropdown
		function Elements:CreateDropdown(Info9)
			local SelfActions = {}

			local Flag = Info9.Flag or ""
			local Callback = Info9.Callback
			local Values = Info9.Values or {}
			local CallbackOnDefault = Info9.CallbackOnDefault or false

			local Dropdown_1 = Instance.new("Frame")
			local UICorner_21 = Instance.new("UICorner")
			local UIStroke_12 = Instance.new("UIStroke")
			local UIGradient_13 = Instance.new("UIGradient")
			local UIGradient_14 = Instance.new("UIGradient")
			local DropdownDescription_1 = Instance.new("TextLabel")
			local DropdownHolder_1 = Instance.new("Frame")
			local DropdownButton_1 = Instance.new("TextButton")
			local UIPadding_2 = Instance.new("UIPadding")
			local UICorner_22 = Instance.new("UICorner")
			local UIStroke_13 = Instance.new("UIStroke")
			local ClickIcon_1 = Instance.new("ImageLabel")
			local ValuesHolder_1 = Instance.new("Frame")
			local UICorner_23 = Instance.new("UICorner")
			local UIStroke_14 = Instance.new("UIStroke")
			local UIListLayout_3 = Instance.new("UIListLayout")
			local DropdownName_1 = Instance.new("TextLabel")

			Dropdown_1.Name = "Dropdown"
			Dropdown_1.Parent = TabContainer_1
			Dropdown_1.BackgroundColor3 = Color3.fromRGB(83, 83, 86)
			Dropdown_1.BackgroundTransparency = 0.6000000238418579
			Dropdown_1.BorderColor3 = Color3.fromRGB(0,0,0)
			Dropdown_1.BorderSizePixel = 0
			Dropdown_1.Position = UDim2.new(-0.352963328, 0,0.0546318293, 0)
			Dropdown_1.Size = UDim2.new(0, 453,0, 66)
			Dropdown_1.ZIndex = 2
			
			CreateGradient(Dropdown_1,Color3.fromRGB(254, 222, 255), Color3.fromRGB(255, 231, 207), Color3.fromRGB(207, 245, 255),nil,  "Special")

			UICorner_21.Parent = Dropdown_1
			UICorner_21.CornerRadius = UDim.new(0,15)

			UIStroke_12.Parent = Dropdown_1
			UIStroke_12.Color = Color3.fromRGB(127, 127, 131)
			UIStroke_12.Thickness = 1
			
			CreateGradient(UIStroke_12,Color3.fromRGB(254, 222, 255), Color3.fromRGB(255, 231, 207), Color3.fromRGB(207, 245, 255),nil,  "Special")

			UIGradient_14.Parent = Dropdown_1
			UIGradient_14.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(213, 213, 213)), ColorSequenceKeypoint.new(1, Color3.fromRGB(16, 16, 16))}
			UIGradient_14.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,0.335404), NumberSequenceKeypoint.new(1,0.795031)}

			DropdownDescription_1.Name = "DropdownDescription"
			DropdownDescription_1.Parent = Dropdown_1
			DropdownDescription_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
			DropdownDescription_1.BackgroundTransparency = 1
			DropdownDescription_1.BorderColor3 = Color3.fromRGB(0,0,0)
			DropdownDescription_1.BorderSizePixel = 0
			DropdownDescription_1.Position = UDim2.new(0.0147992065, 0,0.348484844, 0)
			DropdownDescription_1.Size = UDim2.new(0, 340,0, 38)
			DropdownDescription_1.FontFace = FontType
			DropdownDescription_1.Text = Info9.Description or ""
			DropdownDescription_1.TextColor3  = Color3.fromRGB(unpack(Config.GlobalDescriptionColor))
			DropdownDescription_1.TextSize = 14
			DropdownDescription_1.TextWrapped = true
			DropdownDescription_1.TextXAlignment = Enum.TextXAlignment.Left
			DropdownDescription_1.TextYAlignment = Enum.TextYAlignment.Top
			
			CreateGradient(DropdownDescription_1,Color3.fromRGB(254, 222, 255), Color3.fromRGB(255, 231, 207), Color3.fromRGB(207, 245, 255),nil,  "Special")

			DropdownHolder_1.Name = "DropdownHolder"
			DropdownHolder_1.Parent = Dropdown_1
			DropdownHolder_1.BackgroundColor3 = Color3.fromRGB(72, 82, 88)
			DropdownHolder_1.BackgroundTransparency = 0.6000000238418579
			DropdownHolder_1.BorderColor3 = Color3.fromRGB(0,0,0)
			DropdownHolder_1.BorderSizePixel = 0
			DropdownHolder_1.Position = UDim2.new(0.751929939, 0,0.227272734, 0)
			DropdownHolder_1.Size = UDim2.new(0, 98,0, 35)

			DropdownButton_1.Name = "DropdownButton"
			DropdownButton_1.Parent = DropdownHolder_1
			DropdownButton_1.Active = true
			DropdownButton_1.BackgroundColor3 = Color3.fromRGB(76,58,93)
			DropdownButton_1.BackgroundTransparency = 1
			DropdownButton_1.BorderColor3 = Color3.fromRGB(0,0,0)
			DropdownButton_1.BorderSizePixel = 0
			DropdownButton_1.Size = UDim2.new(0.738527894, 0,1, 0)
			DropdownButton_1.FontFace = FontType
			DropdownButton_1.Text = Values[Info9.Default] or "Select..."
			DropdownButton_1.TextColor3 = Color3.fromRGB(255,255,255)
			DropdownButton_1.ZIndex = 2
			DropdownButton_1.TextSize = 14
			DropdownButton_1.TextWrapped = true

			UIPadding_2.Parent = DropdownButton_1
			UIPadding_2.PaddingLeft = UDim.new(0,1)

			UICorner_22.Parent = DropdownHolder_1
			UICorner_22.CornerRadius = UDim.new(0,13)

			UIStroke_13.Parent = DropdownHolder_1
			UIStroke_13.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			UIStroke_13.Color = Color3.fromRGB(105, 120, 129)
			UIStroke_13.Thickness = 1.2999999523162842
			
			CreateGradient(UIStroke_13,Color3.fromRGB(254, 222, 255), Color3.fromRGB(255, 231, 207), Color3.fromRGB(207, 245, 255),nil,  "Special")

			ClickIcon_1.Name = "ClickIcon"
			ClickIcon_1.Parent = DropdownHolder_1
			ClickIcon_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
			ClickIcon_1.BackgroundTransparency = 1
			ClickIcon_1.BorderColor3 = Color3.fromRGB(0,0,0)
			ClickIcon_1.BorderSizePixel = 0
			ClickIcon_1.Position = UDim2.new(1.22619045, -39,0.614285707, -11)
			ClickIcon_1.Size = UDim2.new(0, 13,0, 13)
			ClickIcon_1.Image = "http://www.roblox.com/asset/?id=12338898398"

			ValuesHolder_1.Name = "ValuesHolder"
			ValuesHolder_1.Parent = DropdownHolder_1
			ValuesHolder_1.BackgroundColor3 = Color3.fromRGB(48, 54, 58)
			ValuesHolder_1.BackgroundTransparency = 0.06
			ValuesHolder_1.BorderColor3 = Color3.fromRGB(0,0,0)
			ValuesHolder_1.BorderSizePixel = 0
			ValuesHolder_1.ZIndex = 2
			ValuesHolder_1.Position = UDim2.new(0.5, -49,2.31428576, -35)
			ValuesHolder_1.Size = UDim2.new(0, 98,0, 40)
			ValuesHolder_1.Visible = false

			UICorner_23.Parent = ValuesHolder_1
			UICorner_23.CornerRadius = UDim.new(0,15)

			UIStroke_14.Parent = ValuesHolder_1
			UIStroke_14.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			UIStroke_14.Color = Color3.fromRGB(105, 120, 129)
			UIStroke_14.Thickness = 1.2999999523162842
			
			CreateGradient(UIStroke_14,Color3.fromRGB(254, 222, 255), Color3.fromRGB(255, 231, 207), Color3.fromRGB(207, 245, 255),nil,  "Special")

			UIListLayout_3.Parent = ValuesHolder_1
			UIListLayout_3.Padding = UDim.new(0,10)
			UIListLayout_3.HorizontalAlignment = Enum.HorizontalAlignment.Center
			UIListLayout_3.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout_3.VerticalAlignment = Enum.VerticalAlignment.Center

			DropdownName_1.Name = "DropdownName"
			DropdownName_1.Parent = Dropdown_1
			DropdownName_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
			DropdownName_1.BackgroundTransparency = 1
			DropdownName_1.BorderColor3 = Color3.fromRGB(0,0,0)
			DropdownName_1.BorderSizePixel = 0
			DropdownName_1.Position = UDim2.new(0.0147992065, 0,0, 0)
			DropdownName_1.Size = UDim2.new(0, 349,0, 23)
			DropdownName_1.FontFace = FontType
			DropdownName_1.Text = Info9.Name or "Dropdown"
			DropdownName_1.TextColor3 = Color3.fromRGB(255,255,255)
			DropdownName_1.TextSize = 14
			DropdownName_1.TextXAlignment = Enum.TextXAlignment.Left

			if Info9.Default ~= nil and CallbackOnDefault then
				local Success, Error = pcall(function() Callback(Values[Info9.Default]) end)

				if not Success then
					Library:FastNotify("Dropdown Error", tostring(Error))
				end
			end

			local function UpdateDropdown()
				for _, v in pairs(ValuesHolder_1:GetChildren()) do
					if v:IsA("TextButton") then
						v:Destroy()
					end
				end

				for _, v in ipairs(Values) do
					local Value_1 = Instance.new("TextButton")
					local UICorner_24 = Instance.new("UICorner")
					local UIStroke_15 = Instance.new("UIStroke")

					Value_1.Name = "Value"
					Value_1.Parent = ValuesHolder_1
					Value_1.Active = true
					Value_1.BackgroundColor3 = Color3.fromRGB(72, 82, 88)
					Value_1.BorderColor3 = Color3.fromRGB(0,0,0)
					Value_1.BorderSizePixel = 0
					Value_1.Position = UDim2.new(0.00510204071, 0,0, 0)
					Value_1.Size = UDim2.new(0, 86,0, 22)
					Value_1.FontFace = FontType
					Value_1.Text = v or  "Valu"
					Value_1.TextColor3 = Color3.fromRGB(255,255,255)
					Value_1.TextSize = 14
					Value_1.TextWrapped = true
					Value_1.ZIndex = 2

					UICorner_24.Parent = Value_1
					UICorner_24.CornerRadius = UDim.new(0,15)

					UIStroke_15.Parent = Value_1
					UIStroke_15.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
					UIStroke_15.Color = Color3.fromRGB(105, 120, 129)
					UIStroke_15.Transparency = 1
					UIStroke_15.Thickness = 1.2999999523162842
					
					CreateGradient(UIStroke_15,Color3.fromRGB(254, 222, 255), Color3.fromRGB(255, 231, 207), Color3.fromRGB(207, 245, 255),nil,  "Special")

					Value_1.MouseEnter:Connect(function()
						TweenService:Create(UIStroke_15, TweenInfo.new(0.2), {Transparency = 0}):Play()
						TweenService:Create(Value_1, TweenInfo.new(0.4), {BackgroundColor3 = Color3.fromRGB(107, 122, 131)}):Play()
					end)

					Value_1.MouseLeave:Connect(function()
						TweenService:Create(UIStroke_15, TweenInfo.new(0.2), {Transparency = 1}):Play()
						TweenService:Create(Value_1, TweenInfo.new(0.4), {BackgroundColor3 = Color3.fromRGB(72, 82, 88)}):Play()
					end)

					Value_1.MouseButton1Click:Connect(function()
						DropdownButton_1.Text = v

						if IsExecutionEnv then
							SaveFlag(FileBranch.Configs, Flag, v)
						end

						coroutine.wrap(function()
							local Success, Error = pcall(function() Callback(v) end)
							if not Success then
								Library:FastNotify("Dropdown Error", tostring(Error))
							end
						end)()

						ValuesHolder_1.Visible = false
						TweenService:Create(ClickIcon_1, TweenInfo.new(0.2), {Rotation = 0}):Play()
					end)
				end

				ValuesHolder_1.Size = UDim2.new(1, 0, #Values * 0.9,0)
			end

			DropdownButton_1.MouseButton1Click:Connect(function()
				local IsOpened = not ValuesHolder_1.Visible
				ValuesHolder_1.Visible = IsOpened

				if IsOpened then
					TweenService:Create(ClickIcon_1, TweenInfo.new(0.2), {Rotation = 180}):Play()
				else
					TweenService:Create(ClickIcon_1, TweenInfo.new(0.2), {Rotation = 0}):Play()
				end
			end)

			UpdateDropdown()

			SelfActions = {
				SetValue = function(self, value)
					if table.find(Values, value) then
						DropdownButton_1.Text = value
						coroutine.wrap(function()
							local Success, Error = pcall(function() Callback(value) end)
							if not Success then
								Library:FastNotify("Button Error", tostring(Error))
							end
						end)()
					else
						Library:FastNotify("Action Failed", "SetValue failed for dropdown: ".. Info9.Name .. "")
					end
				end,

				AddValue = function(self, value)
					if type(value) == "string" then
						table.insert(Values, value)
					elseif type(value) == "table" then
						for i, v in value do
							table.insert(Values, v)
						end
					end
					UpdateDropdown()
				end,
			}

			if IsExecutionEnv then
				local Flags = GetFlags(FileBranch.Configs)

				if Flags then
					for i, v in next, Flags do
						if i == Flag and v ~= nil then
							SelfActions:SetValue(v)
						end
					end
				end
			end

			return SelfActions
		end

		function Elements:CreateColorPicker(Info10)
			local SelfActions = {}

			local Flag = Info10.Flag or ""
			local Callback = Info10.Callback
			local Default = Info10.Default

			local IsOpened = false

			local ColorPicker = Instance.new("Frame")
			local UICorner_1 = Instance.new("UICorner")
			local UIStroke_1 = Instance.new("UIStroke")
			local UIGradient_1 = Instance.new("UIGradient")
			local UIGradient_2 = Instance.new("UIGradient")
			local ColorPickerDescription_1 = Instance.new("TextLabel")
			local ColorPickerName_1 = Instance.new("TextLabel")
			local ColorFrame_1 = Instance.new("Frame")
			local UICorner_2 = Instance.new("UICorner")
			local PickButton_1 = Instance.new("TextButton")
			local ColorPickingHolder_1 = Instance.new("Frame")
			local UICorner_3 = Instance.new("UICorner")
			local UIGradient_3 = Instance.new("UIGradient")
			local WhiteOverlay_1 = Instance.new("Frame")
			local UIGradient_4 = Instance.new("UIGradient")
			local UICorner_4 = Instance.new("UICorner")
			local Cursor = Instance.new("Frame")
			local UICorner_c = Instance.new("UICorner")
			local UIStroke_c = Instance.new("UIStroke")
			local DarknessFrame = Instance.new("Frame")
			local UICorner_c3 = Instance.new("UICorner")
			local UIGradient_c2 = Instance.new("UIGradient")
			local Cursor2_1 = Instance.new("Frame")
			local UICorner_c2 = Instance.new("UICorner")
			local UIStroke_c2 = Instance.new("UIStroke")

			ColorPicker.Name = "ColorPicker"
			ColorPicker.Parent = TabContainer_1
			ColorPicker.BackgroundColor3 = Color3.fromRGB(83, 83, 86)
			ColorPicker.BackgroundTransparency = 0.6000000238418579
			ColorPicker.BorderColor3 = Color3.fromRGB(0,0,0)
			ColorPicker.BorderSizePixel = 0
			ColorPicker.Position = UDim2.new(0.0149892932, 0,0.290865391, 0)
			ColorPicker.Size = UDim2.new(0, 453,0,66)   --UDim2.new(0, 453,0, 205)
			
			CreateGradient(ColorPicker,Color3.fromRGB(254, 222, 255), Color3.fromRGB(255, 231, 207), Color3.fromRGB(207, 245, 255),nil,  "Special")

			UICorner_c.Parent = ColorPicker
			UICorner_c.CornerRadius = UDim.new(0,15)

			UIStroke_c.Parent = ColorPicker
			UIStroke_c.Color = Color3.fromRGB(127, 127, 131)
			UIStroke_c.Thickness = 1

			CreateGradient(UIStroke_c,Color3.fromRGB(254, 222, 255), Color3.fromRGB(255, 231, 207), Color3.fromRGB(207, 245, 255),nil,  "Special")

			UIGradient_2.Parent = ColorPicker
			UIGradient_2.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(213, 213, 213)), ColorSequenceKeypoint.new(1, Color3.fromRGB(16, 16, 16))}
			UIGradient_2.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,0.335404), NumberSequenceKeypoint.new(1,0.795031)}

			ColorPickerDescription_1.Name = "ColorPickerDescription"
			ColorPickerDescription_1.Parent = ColorPicker
			ColorPickerDescription_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
			ColorPickerDescription_1.BackgroundTransparency = 1
			ColorPickerDescription_1.BorderColor3 = Color3.fromRGB(0,0,0)
			ColorPickerDescription_1.BorderSizePixel = 0
			ColorPickerDescription_1.Position = UDim2.new(00.015,0,0.348,0) --// UDim2.new(0.0147992065, 0,0.143606797, 0)
			ColorPickerDescription_1.Size = UDim2.new(0, 349,0, 38)
			ColorPickerDescription_1.FontFace = FontType
			ColorPickerDescription_1.Text = Info10.Description or ""
			ColorPickerDescription_1.TextColor3  = Color3.fromRGB(unpack(Config.GlobalDescriptionColor))
			ColorPickerDescription_1.TextSize = 14
			ColorPickerDescription_1.TextWrapped = true
			ColorPickerDescription_1.TextXAlignment = Enum.TextXAlignment.Left
			ColorPickerDescription_1.TextYAlignment = Enum.TextYAlignment.Top
			
			CreateGradient(ColorPickerDescription_1,Color3.fromRGB(254, 222, 255), Color3.fromRGB(255, 231, 207), Color3.fromRGB(207, 245, 255),nil,  "Special")

			ColorPickerName_1.Name = "ColorPickerName"
			ColorPickerName_1.Parent = ColorPicker
			ColorPickerName_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
			ColorPickerName_1.BackgroundTransparency = 1
			ColorPickerName_1.BorderColor3 = Color3.fromRGB(0,0,0)
			ColorPickerName_1.BorderSizePixel = 0
			ColorPickerName_1.Position = UDim2.new(0.0147992065, 0,0, 0)
			ColorPickerName_1.Size = UDim2.new(0, 349,0, 23)
			ColorPickerName_1.FontFace = FontType
			ColorPickerName_1.Text = Info10.Name or "ColorPicker"
			ColorPickerName_1.TextColor3 = Color3.fromRGB(255,255,255)
			ColorPickerName_1.TextSize = 14
			ColorPickerName_1.TextXAlignment = Enum.TextXAlignment.Left

			ColorFrame_1.Name = "ColorFrame"
			ColorFrame_1.Parent = ColorPicker
			ColorFrame_1.BackgroundColor3 = Default or Color3.fromRGB(255, 255, 255)
			ColorFrame_1.BorderColor3 = Color3.fromRGB(0,0,0)
			ColorFrame_1.BorderSizePixel = 0
			ColorFrame_1.Position = UDim2.new(0.874,0,0.136,0) --// UDim2.new(0.878587067, 0,0.0485588275, 0)
			ColorFrame_1.Size = UDim2.new(0, 47,0, 47)

			local ManualStroke = Instance.new("UIStroke")
			ManualStroke.Parent = ColorFrame_1
			ManualStroke.Thickness = 0.73
			ManualStroke.Color = Color3.fromRGB(201, 179, 255)

			UICorner_2.Parent = ColorFrame_1
			UICorner_2.CornerRadius = UDim.new(0,15)

			PickButton_1.Name = "PickButton"
			PickButton_1.Parent = ColorFrame_1
			PickButton_1.Active = true
			PickButton_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
			PickButton_1.BackgroundTransparency = 1
			PickButton_1.BorderColor3 = Color3.fromRGB(0,0,0)
			PickButton_1.BorderSizePixel = 0
			PickButton_1.Size = UDim2.new(1, 0,1, 0)
			PickButton_1.FontFace = FontType
			PickButton_1.Text = ""
			PickButton_1.TextSize = 14

			ColorPickingHolder_1.Name = "ColorPickingHolder"
			ColorPickingHolder_1.Parent = ColorPicker
			ColorPickingHolder_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
			ColorPickingHolder_1.BorderColor3 = Color3.fromRGB(0,0,0)
			ColorPickingHolder_1.Visible = false
			ColorPickingHolder_1.BorderSizePixel = 0
			ColorPickingHolder_1.Position = UDim2.new(0.0176596399, 0,0.326829255, 0)
			ColorPickingHolder_1.Size = UDim2.new(0, 390,0, 127)
			ColorPickingHolder_1.BackgroundTransparency = 1 -- 0

			UICorner_3.Parent = ColorPickingHolder_1
			UICorner_3.CornerRadius = UDim.new(0,15)

			UIGradient_3.Parent = ColorPickingHolder_1
			UIGradient_3.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 1)), ColorSequenceKeypoint.new(0.166667, Color3.fromRGB(255, 0, 255)), ColorSequenceKeypoint.new(0.333333, Color3.fromRGB(0, 0, 255)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 225)), ColorSequenceKeypoint.new(0.666667, Color3.fromRGB(0, 255, 0)), ColorSequenceKeypoint.new(0.833333, Color3.fromRGB(255, 255, 0)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))}
			UIGradient_3.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,0), NumberSequenceKeypoint.new(0.480697,0.29375), NumberSequenceKeypoint.new(1,0)}

			WhiteOverlay_1.Name = "WhiteOverlay"
			WhiteOverlay_1.Parent = ColorPickingHolder_1
			WhiteOverlay_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
			WhiteOverlay_1.BorderColor3 = Color3.fromRGB(0,0,0)
			WhiteOverlay_1.BorderSizePixel = 0
			WhiteOverlay_1.BackgroundTransparency = 1
			WhiteOverlay_1.Size = UDim2.new(1, 0,1, 0)
			WhiteOverlay_1.ZIndex = 1

			UIGradient_4.Parent = WhiteOverlay_1
			UIGradient_4.Rotation = 270
			UIGradient_4.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,0), NumberSequenceKeypoint.new(1,1)}

			UICorner_4.Parent = WhiteOverlay_1
			UICorner_4.CornerRadius = UDim.new(0,5)

			Cursor.Name = "Cursor"
			Cursor.Parent = ColorPickingHolder_1
			Cursor.BackgroundColor3 = Color3.fromRGB(255,255,255)
			Cursor.BackgroundTransparency = 1
			Cursor.BorderColor3 = Color3.fromRGB(0,0,0)
			Cursor.BorderSizePixel = 0
			Cursor.ZIndex = 2
			Cursor.Position = UDim2.new(0, 0,0, 0)
			Cursor.Size = UDim2.new(0, 10,0, 10)

			UICorner_1.Parent = Cursor
			UICorner_1.CornerRadius = UDim.new(1,0)

			UIStroke_1.Parent = Cursor
			UIStroke_1.Color = Color3.fromRGB(0, 0, 0)
			UIStroke_1.Transparency = 1
			UIStroke_1.Thickness = 1.899999976158142

			DarknessFrame.Name = "DarknessFrame"
			DarknessFrame.Parent = ColorPicker
			DarknessFrame.BackgroundColor3 = Color3.fromRGB(255,38,38)
			DarknessFrame.BorderColor3 = Color3.fromRGB(0,0,0)
			DarknessFrame.Visible = false
			DarknessFrame.BorderSizePixel = 0
			DarknessFrame.Position = UDim2.new(0.891832113, 0,0.328972638, 0)
			DarknessFrame.Size = UDim2.new(0, 39,0, 126)

			UICorner_c3.Parent = DarknessFrame
			UICorner_c3.CornerRadius = UDim.new(0,5)

			UIGradient_c2.Parent = DarknessFrame
			UIGradient_c2.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))}
			UIGradient_c2.Rotation = 90

			Cursor2_1.Name = "Cursor2"
			Cursor2_1.Parent = DarknessFrame
			Cursor2_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
			Cursor2_1.BackgroundTransparency = 1
			Cursor2_1.BorderColor3 = Color3.fromRGB(0,0,0)
			Cursor2_1.BorderSizePixel = 0
			Cursor2_1.Size = UDim2.new(0, 10,0, 10)
			Cursor2_1.ZIndex = 2

			UICorner_c2.Parent = Cursor2_1
			UICorner_c2.CornerRadius = UDim.new(1,0)

			UIStroke_c2.Parent = Cursor2_1
			UIStroke_c2.Thickness = 1.899999976158142

			local Debounce3 = false
			PickButton_1.MouseButton1Click:Connect(function()
				IsOpened = not IsOpened

				if Debounce3 then return end
				Debounce3 = true
				ColorPickingHolder_1.Visible = IsOpened
				DarknessFrame.Visible = IsOpened

				if IsOpened then
					TweenService:Create(ColorPicker, TweenInfo.new(0.3), {Size = UDim2.new(0, 453, 0, 205)}):Play()
					TweenService:Create(ColorFrame_1, TweenInfo.new(0.3), {Position = UDim2.new(0.878587067, 0,0.0485588275, 0)}):Play()
					TweenService:Create(ColorPickingHolder_1, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
					TweenService:Create(DarknessFrame, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
					TweenService:Create(ColorPickerDescription_1, TweenInfo.new(0.3), {Position = UDim2.new(0.0147992065, 0,0.143606797, 0)}):Play()
					TweenService:Create(WhiteOverlay_1, TweenInfo.new(0.3), {Transparency = 0}):Play()
					TweenService:Create(UIStroke_1, TweenInfo.new(0.3), {Transparency = 0}):Play()
				else
					TweenService:Create(ColorPicker, TweenInfo.new(0.3), {Size = UDim2.new(0, 453, 0, 66)}):Play()
					TweenService:Create(ColorFrame_1, TweenInfo.new(0.3), {Position =  UDim2.new(0.874,0,0.136,0)}):Play()
					TweenService:Create(ColorPickerDescription_1, TweenInfo.new(0.3), {Position = UDim2.new(00.015,0,0.348,0)}):Play()
					TweenService:Create(ColorPickingHolder_1, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
					TweenService:Create(DarknessFrame, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
					TweenService:Create(UIStroke_1, TweenInfo.new(0.3), {Transparency = 1}):Play()
					TweenService:Create(WhiteOverlay_1, TweenInfo.new(0.3), {Transparency = 1}):Play()
				end
				task.wait(0.3)
				Debounce3 = false
			end)

			local function GetColor(X, Y, Darkness)
				local Hue = 1 - (X / ColorPickingHolder_1.AbsoluteSize.X) 
				local Saturation = 1 - (Y / ColorPickingHolder_1.AbsoluteSize.Y)
				local Value = 1 - (Darkness / DarknessFrame.AbsoluteSize.Y)

				return Color3.fromHSV(Hue, Saturation, Value)
			end

			local function SetDefaultColor(DefaultColor)
				local H, S, V = DefaultColor:ToHSV()
				local DefaultX = (1 - H) * ColorPickingHolder_1.AbsoluteSize.X 
				local DefaultY = (1 - S) * ColorPickingHolder_1.AbsoluteSize.Y
				local DefaultDarkness = (1 - V) * DarknessFrame.AbsoluteSize.Y

				Cursor.Position = UDim2.new(0, DefaultX - 5, 0, DefaultY - 5)
				Cursor2_1.Position = UDim2.new(0.5, -5, 0, DefaultDarkness - 5)
				DarknessFrame.BackgroundColor3 = DefaultColor

				local Success, Error = pcall(function() Callback(DefaultColor) end)

				if IsExecutionEnv then
					SaveFlag(FileBranch.Configs, Flag, DefaultColor)
				end

				if not Success then
					Library:FastNotify("ColorPicker Error: ", tostring(Error))
				end
			end

			local function UpdateCursor(Input)
				local X = math.clamp(Input.Position.X - ColorPickingHolder_1.AbsolutePosition.X, 0, ColorPickingHolder_1.AbsoluteSize.X)
				local Y = math.clamp(Input.Position.Y - ColorPickingHolder_1.AbsolutePosition.Y, 0, ColorPickingHolder_1.AbsoluteSize.Y)
				local Darkness = math.clamp(Cursor2_1.Position.Y.Offset, 0, DarknessFrame.AbsoluteSize.Y)

				Cursor.Position = UDim2.new(0, X - 5, 0, Y - 5)
				local NewColor = GetColor(X, Y, Darkness)
				ColorFrame_1.BackgroundColor3 = NewColor
				DarknessFrame.BackgroundColor3 = NewColor

				local Success, Error = pcall(function() Callback(NewColor) end)

				if IsExecutionEnv then
					SaveFlag(FileBranch.Configs, Flag, NewColor)
				end

				if not Success then
					Library:FastNotify("ColorPicker Error: ", tostring(Error))
				end
			end

			local function UpdateDarkness(input)
				local Y = math.clamp(input.Position.Y - DarknessFrame.AbsolutePosition.Y, 0, DarknessFrame.AbsoluteSize.Y)
				Cursor2_1.Position = UDim2.new(0.5, -5, 0, Y - 5)

				UpdateCursor({Position = Vector2.new(Cursor.AbsolutePosition.X + 5, Cursor.AbsolutePosition.Y + 5)})
			end

			ColorPickingHolder_1.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					IsInColorFrameDrag = true  
					UpdateCursor(input)
				end
			end)

			ColorPickingHolder_1.InputChanged:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseMovement and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
					if IsInColorFrameDrag then
						UpdateCursor(input)
					end
				end
			end)

			ColorPickingHolder_1.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					IsInColorFrameDrag = false  
				end
			end)

			DarknessFrame.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					IsInColorFrameDrag = true  
					UpdateDarkness(input)
				end
			end)

			DarknessFrame.InputChanged:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseMovement and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
					if IsInColorFrameDrag then
						UpdateDarkness(input)
					end
				end
			end)

			DarknessFrame.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					IsInColorFrameDrag = false  
				end
			end)

			if Default then
				SetDefaultColor(Default)
			end

			SelfActions = {
				SetColor = function(self, Color)
					if typeof(Color) == "Color3" then
						SetDefaultColor(Default)
					end
				end,
			}

			if IsExecutionEnv then
				local Flags = GetFlags(FileBranch.Configs)

				for i, v in next, Flags do
					if i == Flag and v ~= nil then
						SelfActions:SetColor(Color3.fromRGB(v.R * 255, v.G * 255, v.B * 255))
					end
				end
			end

			return SelfActions
		end
		function Elements:CreateParagraph(Tablep)
			local Headers = {}

			local function UpdateSize(Frame, XSize, Increment, Normalized)
				local Increment2 = Increment or 5
				local TotalHeight = Normalized or 10

				for _, v in ipairs(Frame:GetChildren()) do
					if v:IsA("GuiObject") then
						TotalHeight = TotalHeight + v.AbsoluteSize.Y + 5
					end
				end


				TotalHeight = TotalHeight + Increment2
				Frame.Size = UDim2.new(0, XSize, 0, TotalHeight)
			end


			local Paragraph = Instance.new("Frame")
			local UICorner_1 = Instance.new("UICorner")
			local UIStroke_1 = Instance.new("UIStroke")
			local UIGradient_1 = Instance.new("UIGradient")
			local ParagraphTitle_1 = Instance.new("TextLabel")
			local UIGradient_2 = Instance.new("UIGradient")
			local UiListLayout_3 = Instance.new("UIListLayout")
			local UiPadding_3 = Instance.new("UIPadding")

			Paragraph.Name = "Paragraph"
			Paragraph.Parent = TabContainer_1
			Paragraph.BackgroundColor3 = Color3.fromRGB(83, 83, 86)
			Paragraph.BackgroundTransparency = 0.6
			Paragraph.BorderSizePixel = 0
			Paragraph.Position = UDim2.new(0, 0, 0.01, 0)
			Paragraph.Size = UDim2.new(0, 453, 0, 5)
			Paragraph.AutomaticSize = Enum.AutomaticSize.Y

			UiPadding_3.Parent = Paragraph
			UiPadding_3.PaddingBottom = UDim.new(0, 20)
			--UiPadding_3.PaddingTop = UDim.new(0, 2)

			UiListLayout_3.Parent = Paragraph
			UiListLayout_3.Padding = UDim.new(0, 10)
			UiListLayout_3.HorizontalAlignment = Enum.HorizontalAlignment.Center
			UiListLayout_3.SortOrder = Enum.SortOrder.LayoutOrder

			UICorner_1.Parent = Paragraph
			UICorner_1.CornerRadius = UDim.new(0, 10)

			UIStroke_1.Parent = Paragraph
			UIStroke_1.Color = Color3.fromRGB(74, 74, 74)
			UIStroke_1.Thickness = 1

			UIGradient_1.Parent = UIStroke_1
			UIGradient_1.Transparency = NumberSequence.new{
				NumberSequenceKeypoint.new(0, 0), 
				NumberSequenceKeypoint.new(1, 0.75)
			}

			ParagraphTitle_1.Name = "ParagraphTitle"
			ParagraphTitle_1.Parent = Paragraph
			ParagraphTitle_1.BackgroundTransparency = 1
			ParagraphTitle_1.Size = UDim2.new(0, 442, 0, 18)
			ParagraphTitle_1.FontFace = FontType
			ParagraphTitle_1.Text = Tablep.Name or Tablep.Title or "Paragraph"
			ParagraphTitle_1.TextColor3 = Color3.fromRGB(255, 255, 255)
			ParagraphTitle_1.TextSize = 14
			ParagraphTitle_1.TextXAlignment = Enum.TextXAlignment.Left


			UIGradient_2.Parent = Paragraph
			UIGradient_2.Color = ColorSequence.new{
				ColorSequenceKeypoint.new(0, Color3.fromRGB(213, 213, 213)), 
				ColorSequenceKeypoint.new(1, Color3.fromRGB(16, 16, 16))
			}
			UIGradient_2.Transparency = NumberSequence.new{
				NumberSequenceKeypoint.new(0, 0.33), 
				NumberSequenceKeypoint.new(1, 0.79)
			}

			function Headers:AssignHeader(Tableh)
				local Header = Instance.new("Frame")
				local HeaderTitle = Instance.new("TextLabel")
				local HeaderContent = Instance.new("TextLabel")
				local UICorner_2 = Instance.new("UICorner")
				local UIPadding_1 = Instance.new("UIPadding")
				local UIStroke_2 = Instance.new("UIStroke")
				local ManualList = Instance.new("UIListLayout")
				local ManualPadding = Instance.new("UIPadding")

				Header.Name = "Header"
				Header.Parent = Paragraph
				Header.BackgroundColor3 = Tableh.AccentColor or Color3.fromRGB(58, 58, 58)
				Header.BackgroundTransparency = Tableh.AccentTransparency or 0.8
				Header.BorderSizePixel = 0
				Header.Size = UDim2.new(0, 435, 0, 0)
				Header.AutomaticSize = Enum.AutomaticSize.Y

				if Tableh.UseShadowGrandient.Enabled then
					local Grandient = Instance.new("UIGradient")
					Grandient.Parent = Header
					Grandient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(220, 220, 207))}
					Grandient.Rotation = 90
				end

				ManualPadding.Parent = Header
				ManualPadding.PaddingBottom = UDim.new(0, 8)
				ManualPadding.PaddingTop = UDim.new(0, 2)

				HeaderTitle.Name = "HeaderTitle"
				HeaderTitle.Parent = Header
				HeaderTitle.BackgroundTransparency = 1
				HeaderTitle.Size = UDim2.new(0, 436, 0, 18)
				HeaderTitle.Position = UDim2.new(0, 6, 0, 0)
				HeaderTitle.FontFace = FontType
				HeaderTitle.Text = Tableh.Title or "Header"
				HeaderTitle.TextColor3 = Tableh.TitleAccentColor or Tableh.NameAccentColor or Color3.fromRGB(255, 255, 255)
				HeaderTitle.TextSize = 14
				HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left

				HeaderContent.Name = "HeaderContent"
				HeaderContent.Parent = Header
				HeaderContent.BackgroundTransparency = 1
				HeaderContent.Position = UDim2.new(0, 6, 0.15, 0)
				HeaderContent.Size = UDim2.new(0, 421, 0, 42)
				HeaderContent.FontFace = FontType
				HeaderContent.Text = Tableh.Content or "Content"
				HeaderContent.TextColor3 = Tableh.ContentAccentColor or Color3.fromRGB(227, 227, 227)
				HeaderContent.TextSize = 14
				HeaderContent.TextWrapped = true
				HeaderContent.TextXAlignment = Enum.TextXAlignment.Left
				HeaderContent.TextYAlignment = Enum.TextYAlignment.Top
				HeaderContent.Position = UDim2.new(0, 6, HeaderTitle.Position.Y.Offset + 0.15, HeaderTitle.Position.Y.Offset + 5)

				local TextSize = TextService:GetTextSize(HeaderContent.Text, HeaderContent.TextSize, Enum.Font.SourceSans, Vector2.new(HeaderContent.Size.X.Offset, math.huge))
				HeaderContent.Size = UDim2.new(0, 421, 0, TextSize.Y)

				UICorner_2.Parent = Header
				UICorner_2.CornerRadius = UDim.new(0, 10)

				UIPadding_1.Parent = Header
				UIPadding_1.PaddingLeft = UDim.new(0, 7)
				UIPadding_1.PaddingTop = UDim.new(0, 3)

				UIStroke_2.Parent = Header
				UIStroke_2.Color = Tableh.StrokeAccentColor or Color3.fromRGB(74, 74, 74)
				UIStroke_2.Thickness = 1

				if Tableh.CustomImage then
					HeaderContent.Size = Tableh.CustomImage.NewSize
					HeaderContent.Position = Tableh.CustomImage.NewPos
					task.spawn(function()
						while true do
							TweenService:Create(Header,TweenInfo.new(0.3), {Size = Tableh.CustomImage.NewHeaderSize}):Play()
							task.wait(0.2)
						end
					end)

					local ImageButton = Instance.new("ImageButton")
					local UICorner_5 = Instance.new("UICorner")
					local UIStroke_5 = Instance.new("UIStroke")

					ImageButton.Parent = Header
					ImageButton.BackgroundColor3 = Tableh.CustomImage.BackgroundColor or Color3.fromRGB(255, 255, 255)
					ImageButton.BackgroundTransparency = Tableh.CustomImage.BackgroundTransparency or 0
					ImageButton.Size = UDim2.new(0, 57, 0, 57)
					ImageButton.AnchorPoint = Vector2.new(0,0.5)
					ImageButton.Position = UDim2.new(0.85, 0, 0.53, 0)
					ImageButton.AutoButtonColor = false
					ImageButton.Image = Tableh.CustomImage.Icon or ""

					UICorner_5.Parent = ImageButton
					UICorner_5.CornerRadius = Tableh.CustomImage.CornerRadius or UDim.new(0, 10)

					UIStroke_5.Parent = ImageButton
					UIStroke_5.Enabled = Tableh.CustomImage.Stroke.Enabled or false
					UIStroke_5.Color = Tableh.CustomImage.Stroke and Tableh.CustomImage.Stroke.Color or Color3.fromRGB(255, 255, 255)
					UIStroke_5.Thickness = Tableh.CustomImage.Stroke and Tableh.CustomImage.Stroke.Thickness or 1
					UIStroke_5.Transparency = Tableh.CustomImage.Stroke and Tableh.CustomImage.Stroke.Transparency or 0

					if Tableh.CustomImage.Callback and type(Tableh.CustomImage.Callback) == "function" then
						ImageButton.MouseButton1Click:Connect(Tableh.CustomImage.Callback)
					end
				end
			end

			for i, v in pairs(Tablep) do
				if type(v) == "table" then
					Headers:AssignHeader(v)
				end
			end

			return Paragraph
		end

		return Elements
	end

	--// Settings
	function SettingAssync:StartupSettings()
		local Settings = Tabs:CreateTab({
			Name = "Settings",
			Icon = "settings",
		})

		local BindingSection = Settings:CreateSection({
			Title = "Binding"
		})

		local MinimizeKeybind = Settings:CreateKeybind({
			Name = "Gui Minimize Keybind", 
			Description = "Changes The Keybind For Minimizing The Gui",
			Default = Enum.KeyCode[Config.MinimizeKeybind],
			Callback = function(Keybind)
				Config.MinimizeKeybind = Keybind.Name

				MinimizeKeybind = Enum.KeyCode[Config.MinimizeKeybind]
			end,
		})

		local AnimationSection = Settings:CreateSection({
			Title = "Animations"
		})

		local GuiDragSpeed = Settings:CreateSlider({
			Name = "Gui Dragging Speed",
			Description = "Changes How Powerful The Dragging Speed Is",
			Default = Config.GuiDragSpeed,
			MinValue = 0,
			MaxValue = 2,
			Increment = 0.01,
			Callback = function(value)
				Config.GuiDragSpeed = value

				Speed = Config.GuiDragSpeed
			end
		})

		local SliderAnimationSpeed = Settings:CreateSlider({
			Name  = "Slider Animation Speed",
			Description = "Changes How Fast The Slider Animation Is",
			Default = Config.SliderSpeed,
			MinValue = 0,
			MaxValue = 2,
			Increment = 0.01,
			Callback = function(value)
				Config.SliderSpeed = value
			end
		})

		local ToggleAnimationSpeed = Settings:CreateSlider({
			Name  = "Toggle Animation Speed",
			Description = "Changes How Fast The Toggle Animation Is",
			Default = Config.ToggleSpeed,
			MinValue = 0,
			MaxValue = 2,
			Increment = 0.01,
			Callback = function(value)
				Config.ToggleSpeed = value
			end
		})

		local GuiAppearenceSection = Settings:CreateSection({
			Title = "Gui Appearence"
		})

		local MainGuiColor = Settings:CreateColorPicker({
			Name = "Main Gui Color",
			Description = "Changes The Color Of The MainGui",
			Default = Color3.fromRGB(unpack(Config.MainColor)),
			Callback = function(Color)
				Config.MainColor = {Color.R * 255, Color.G * 255, Color.B * 255}

				MainFrame_1.BackgroundColor3 = Color
			end,
		})

		local MainGuiShadow = Settings:CreateColorPicker({
			Name = "Main Gui Shadow Color",
			Description = "Changes The Color Of The Shadows Ui",
			Default = Color3.fromRGB(unpack(Config.MainShadow)),
			Callback = function(Color)
				Config.MainShadow = {Color.R * 255, Color.G * 255, Color.B * 255}
				ShadownMN.ImageColor3 = Color
			end,
		})

		local MainGuiShadowTrans = Settings:CreateSlider({
			Name = "Main Gui Shadow Transparency",
			Description = "Changes The Transparency Of The Shadows Ui",
			Default = Config.MainShadowTransparecy,
			MinValue = 0,
			MaxValue = 1,
			Increment = 0.01,
			Callback = function(value)
				Config.MainShadowTransparecy = value
				ShadownMN.ImageTransparency = value
			end,
		})
	end

	function Library:ConnectChangelogService(Url)
		local ExtraWrite = {}

		local ChangeLogs = Tabs:CreateTab({
			Name = "Imperium",
			Icon = "pen",
		})

		local Socials = ChangeLogs:CreateParagraph({
			Name = "Imperium | Socials",
			Discord = {
				Title = "Discord Server:",
				Content = "In Our Discord Server We Post all Updates, Scripts And Keys (And Giveaways), Join It For  More Updates And Further Support",
				TitleAccentColor = Color3.fromRGB(241, 241, 241),
				ContentAccentColor = Color3.fromRGB(206, 206, 206),
				AccentColor = Color3.fromRGB(119, 88, 163),
				AccentTransparency = 0.6,
				StrokeAccentColor = Color3.fromRGB(119, 88, 163),
				UseShadowGrandient = { Enabled = true },
				CustomImage = {
					BackgroundColor = Color3.fromRGB(157, 101, 255),
					BackgroundTransparency = 0.8,
					Icon = "http://www.roblox.com/asset/?id=84828491431270",
					NewSize = UDim2.new(0, 309,0, 42),
					NewHeaderSize = UDim2.new(0, 435,0, 70),
					NewPos = UDim2.new(0,6,0.269,0),
					Callback = function() setclipboard("Discord.gg/v3n") end,
					Stroke = {
						Enabled = true,
						Color = Color3.fromRGB(119, 88, 163),
					}
				}
			},
			Site = {
				Title = "Our Official Site",
				Content = "https://imperiumhub.sellhub.cx/ Is Our Official Site, Where You Can Get Our Latest Scripts",
				TitleAccentColor = Color3.fromRGB(241, 241, 241),
				ContentAccentColor = Color3.fromRGB(206, 206, 206),
				AccentColor = Color3.fromRGB(103, 65, 185),
				AccentTransparency = 0.45,
				StrokeAccentColor = Color3.fromRGB(98, 61, 176),
				UseShadowGrandient = { Enabled = true },
				CustomImage = {
					BackgroundColor = Color3.fromRGB(221, 180, 255),
					NewSize = UDim2.new(0, 309,0, 42),
					NewPos = UDim2.new(0,6,0.269,0),
					NewHeaderSize = UDim2.new(0, 435,0, 70),
					BackgroundTransparency = 1,
					Icon = "",
					Callback = function() setclipboard("Discord.gg/v3n") end,
					Stroke = {
						Enabled = false,
						Color = Color3.fromRGB(224, 175, 255),
					}
				}
			},
			Support = {
				Title = "Need Support?",
				Content = "In Case You Have Suggestion/Bug/Issue You Can Open a Ticket In Our Discord Server Or Dm sentrysvc (Or a Imperium Owner) on Discord.",
				TitleAccentColor = Color3.fromRGB(241, 241, 241),
				ContentAccentColor = Color3.fromRGB(206, 206, 206),
				AccentColor = Color3.fromRGB(180, 75, 75),
				AccentTransparency = 0.45,
				StrokeAccentColor = Color3.fromRGB(180, 75, 75),
				UseShadowGrandient = { Enabled = true },
				CustomImage = {
					BackgroundColor = Color3.fromRGB(221, 180, 255),
					NewSize = UDim2.new(0, 309,0, 42),
					NewPos = UDim2.new(0,6,0.269,0),
					NewHeaderSize = UDim2.new(0, 435,0, 70),
					BackgroundTransparency = 1,
					Icon = "",
					Callback = function() setclipboard("Discord.gg/v3n") end,
					Stroke = {
						Enabled = false,
						Color = Color3.fromRGB(224, 175, 255),
					}
				}
			}
		})

		if type(Url) == "string" and IsExecutionEnv then
			local NewSec2 = ChangeLogs:CreateSection({
				Title = "Library ChangeLogs",
			})
			local Write = loadstring(game:HttpGet(Url))()

			for _, v in next, Write do
				if type(v) == "table" then
					for _, v2 in next, v do
						local Paragraph = ChangeLogs:CreateParagraph({
							Name = v2.Name,
							FixHeader = v2.FixHeader,
							AddedHeader = v2.AddedHeader,
							ChangedHeader = v2.ChangedHeader,
						})
					end
				end
			end

			function ExtraWrite:CreateChangeLog(Name, NewUrl)
				local NewSec = ChangeLogs:CreateSection({
					Title = Name,
				})

				if type(NewUrl) == "string" and IsExecutionEnv then
					local NewWrite = loadstring(game:HttpGet(NewUrl))()
					for _, v in next, NewWrite do
						if type(v) == "table" then
							for _, v2 in next, v do
								local Paragraph = ChangeLogs:CreateParagraph({
									Name = v2.Name,
									FixHeader = v2.FixHeader,
									AddedHeader = v2.AddedHeader,
									ChangedHeader = v2.ChangedHeader,
								})
							end
						end
					end
				end
			end
		end
		return ExtraWrite
	end
	return Tabs, SettingAssync
end

Library:SetAutoButtonColor(false)

return Library
