local LoadTime = tick()
if not game:IsLoaded() then
    game.Loaded:Wait()
end

if not game:GetService("Players").LocalPlayer then
    repeat task.wait() until game:GetService("Players").LocalPlayer
end

_G.Config = { ["Theme"] = "drill" }

local GuiService = game:GetService("GuiService")

local TweenService, Core do
	TweenService = game:GetService("TweenService"); 
    Core = game:GetService("CoreGui");
end

local protectGui = (gethui) or (syn and syn["protect_gui"])

local New = function(Class, Properties)
	local Obj, Properties = Instance.new(Class), Properties or {}
	if Obj:IsA("GuiObject") then 
        Obj["AnchorPoint"] = Vector2.new(0.5, 0.5); 
        Obj["BorderSizePixel"] = 0 
    end;
	for I, V in pairs(Properties) do 
        if rawequal(I, "Parent") then 
            continue 
        end; 
        Obj[I] = V end
	if Properties["Parent"] then 
        Obj["Parent"] = Properties["Parent"] 
    end;
    return Obj;
end

local Tween = function(I, T, S, D, G, RT)
	local ObjTween = TweenService:Create(I, TweenInfo.new(T, Enum["EasingStyle"][S], Enum["EasingDirection"][D]), G);
	if RT then 
        return ObjTween
	else 
		coroutine.wrap(function()
			ObjTween:Play()
		end)()
	end
end

if Core:FindFirstChild("NordNotifications") then 
    Core:FindFirstChild("NordNotifications"):Destroy() 
end

local UI = New("ScreenGui", {["IgnoreGuiInset"] = true; ["Name"] = "NordNotifications"; ["ResetOnSpawn"] = false; ["ZIndexBehavior"] = "Global"}); 

protectGui(UI); UI["Parent"] = Core;

local NotificationHolder = New("Frame", {Parent = UI, BackgroundTransparency = 1, Position = UDim2.new(0.924, 0, 0.5, 0), Size = UDim2.new(0.151, 0, 1, 0)}); 

New("UIListLayout", {Parent = NotificationHolder, Padding = UDim.new(0, 15), HorizontalAlignment = "Center", VerticalAlignment = "Bottom"});
New("UIPadding", {Parent = NotificationHolder, PaddingBottom = UDim.new(0, 20), PaddingTop = UDim.new(0, 20)});

local Nord = {};

Nord["Config"] = { ["Theme"] = "Dark" }
Nord["Themes"] = {
    ["light"] = {["Frame"] = {["BackgroundColor3"] = Color3.new(1, 1, 1);},["TextLabel"] = {["TextColor3"] = Color3.new(0, 0, 0)}},
    ["dark"] = {["Frame"] = {["BackgroundColor3"] = Color3.fromRGB(70, 70, 73);},["TextLabel"] = {["TextColor3"] = Color3.new(1, 1, 1)}},
    ["discord"] = {["Frame"] = {["BackgroundColor3"] = Color3.fromRGB(44, 47, 51);},["TextLabel"] = {["TextColor3"] = Color3.fromRGB(114, 137, 218)}},
    ["spotify"] = {["Frame"] = {["BackgroundColor3"] = Color3.fromRGB(25, 20, 20);},["TextLabel"] = {["TextColor3"] = Color3.fromRGB(30, 215, 96)}},
    ["atlas"] = {["Frame"] = {["BackgroundColor3"] = Color3.fromRGB(16, 16, 16);},["TextLabel"] = {["TextColor3"] = Color3.new(1, 1, 1)}},
    ["drill"] = {["Frame"] = {["BackgroundColor3"] = Color3.fromRGB(35, 35, 35);},["TextLabel"] = {["TextColor3"] = Color3.new(255, 255, 255)}}
}

function Nord:TextConstraint(Item)
	New("UITextSizeConstraint", {Parent = Item, MaxTextSize = Item["TextSize"]}); Item["TextScaled"] = true
end

function Nord:ApplyTheme(Theme, Frame)
    local Desc = Frame:GetDescendants()
    if Nord["Themes"][Theme:lower()] then
        for i,v in next, Nord["Themes"][Theme:lower()] do
            for a,b in next, Desc do
                if b["ClassName"] == i and b["Name"] ~= "Line" then
                    for c,d in next, v do
                        b[c] = d
                    end
                elseif i == "Frame" then
                    for c,d in next, v do
                        Frame[c] = d
                    end
                end
            end
        end
    end
end

function Nord:Notify(Title, Message, Type, Duration)
    Nord["Config"] = _G.Config
	local Type2Color = {['error'] = Color3.fromRGB(255, 87, 87), ['warn'] = Color3.fromRGB(255, 255, 127), ['success'] = Color3.fromRGB(85, 255, 127), ['normal'] = Color3.fromRGB(255, 255, 255)}
	local Frame = New("Frame", {Name = "MainFrame", Parent = NotificationHolder, BackgroundColor3 = Color3.fromRGB(70, 70, 73),
		Size = UDim2.new(0.9, 0, 0.097, 0), ZIndex = 2, BackgroundTransparency = 1
	}); local DropShadow = New("ImageLabel", {Parent = Frame, BackgroundTransparency = 1, Position = UDim2.new(0.5, 0, 0.512, 0), Size = UDim2.new(1.053, 0, 1.135, 0), Image = "rbxassetid://7912134082",
		ImageColor3 = Type2Color[Type:lower()], ImageTransparency = 1, ScaleType = "Slice", SliceCenter = Rect.new(95, 95, 205, 205)
	}); New("UICorner", {Parent = Frame, CornerRadius = UDim.new(0, 5)}); New("UICorner", {Parent = DropShadow, CornerRadius = UDim.new(0, 5)});
	local Header = New("TextLabel", {Parent = Frame, BackgroundTransparency = 1, Position = UDim2.new(0.237, 0, 0.172, 0), Size = UDim2.new(0.4, 0, 0.358, 0), ZIndex = 2, Font = "GothamMedium",
		Text = Title or "Nord", TextSize = 14, TextXAlignment = "Left", TextScaled = true, TextColor3 = Color3.new(1, 1, 1)
	}); Nord:TextConstraint(Header);
	local Msg = New("TextLabel", {Parent = Frame, BackgroundTransparency = 1, Position = UDim2.new(0.5, 0, 0.563, 0), Size = UDim2.new(0.927, 0, 0.5, 0), ZIndex = 2, Font = "Gotham",
		Text = Message, TextSize = 12, TextXAlignment = "Left", TextScaled = true, TextColor3 = Color3.new(1, 1, 1)
	}); Nord:TextConstraint(Msg);
	local LineHolder = New("Frame", {Parent = Frame, BackgroundTransparency = 1, Position = UDim2.new(0.5, 0, 0.93, 0), Size = UDim2.new(0.9278, 0, 0, 1), ZIndex = 2})
	New("UIListLayout", {Parent = LineHolder, HorizontalAlignment = "Left", VerticalAlignment = "Center"});
	local Line = New("Frame", {Name = "Line", Parent = LineHolder, BackgroundColor3 = Type2Color[Type:lower()], Size = UDim2.new(0, 0, 1, 0), ZIndex = 2});
	local Hover = New("TextButton", {Parent = Frame, BackgroundTransparency = 1, Text = "", Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0.5, 0, 0.5, 0), ZIndex = 3});
    Nord:ApplyTheme((Nord["Config"]["Theme"]), Frame)
    if Nord["Config"]["Theme"]:lower() == "light" and Type:lower() == "normal" then 
        Line["BackgroundColor3"] = Color3.new(0, 0, 0);
        DropShadow["ImageColor3"] = Color3.new(0, 0, 0)
    end

    coroutine.wrap(function()
        Tween(Frame, 0.25, "Quad", "In", {BackgroundTransparency = 0});
        Tween(DropShadow, 0.25, "Quad", "In", {ImageTransparency = 0.5}); wait(0.5);
        Tween(Header, 0.5, "Quad", "Out", {TextTransparency = 0}); wait(0.25);
        Tween(Msg, 0.5, "Quad", "Out", {TextTransparency = 0}); wait(0.25);
        
        local MainTween = Tween(Line, Duration, "Sine", "InOut", {Size = UDim2.new(1, 0, 1, 0)}, "true"); MainTween:Play();
        Hover["MouseEnter"]:Connect(function()
            if MainTween["PlaybackState"] == Enum["PlaybackState"]["Playing"] then
                MainTween:Pause()
            end
        end); 
        Hover["MouseLeave"]:Connect(function()
            if MainTween["PlaybackState"] == Enum["PlaybackState"]["Paused"] then
                MainTween:Play()
            end
        end);
        repeat wait() until MainTween["PlaybackState"] == Enum["PlaybackState"]["Completed"]
        Tween(Line, 0.25, "Quad", "Out", {Size = UDim2.new(0, 0, 1, 0)});
        Tween(Msg, 0.25, "Quad", "Out", {TextTransparency = 1}); 
        Tween(Header, 0.25, "Quint", "Out", {TextTransparency = 1}); wait(0.4);
        Tween(DropShadow, 0.25, "Quint", "Out", {ImageTransparency = 1});
        Tween(Frame, 0.25, "Quint", "Out", {BackgroundTransparency = 1}); wait(0.25); Frame:Destroy();
    end)()
end

local Notify = function(Message)
    Nord:Notify("Atlas Admin v3", Message, "success", 3);
end

local FirstExecute = false
local Passed = false

Notify('Loaded script in ' .. string.format('%.4f', tostring(os.clock() - LoadTime)) .. ' seconds', 2)

if game.CoreGui:FindFirstChild("AtlasAdminv3Welcome") then
    print("It appears you are already running this script, destroying old gui.")
    game.CoreGui:FindFirstChild("AtlasAdminv3Welcome"):Destroy()
end

if not isfolder("AtlasAdminv3") then
    FirstExecute = true
    makefolder("AtlasAdminv3")
end

if not isfile("AtlasAdminv3/Prefix.txt") then
    FirstExecute = true
    writefile("AtlasAdminv3/Prefix.txt", ";")
end

local drawingTween do -- obj property dest time 
    local function numLerp(a, b, c)
        return (1 - c) * a + c * b
    end
    local tweenTypes = {}
    tweenTypes.Vector2 = Vector2.zero.Lerp
    tweenTypes.number = numLerp
    tweenTypes.Color3 = Color3.new().Lerp
    function drawingTween(obj, property, dest, duration) 
        task.spawn(function()
            local initialVal = obj[property]
            local tweenTime = 0
            local lerpFunc = tweenTypes[typeof(dest)]
            while ( tweenTime < duration ) do 
                obj[property] = lerpFunc(initialVal, dest, 1 - math.pow(2, -10 * tweenTime / duration))
                local deltaTime = task.wait()
                tweenTime += deltaTime
            end
            obj[property] = dest
        end)
    end
end

if FirstExecute then
    local WelcomeScreen = Instance.new("ScreenGui")
    local BackgroundFrame = Instance.new("Frame")
    local TopBar = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local Line = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local UICorner_2 = Instance.new("UICorner")
    local UICorner_3 = Instance.new("UICorner")
    local CodeImage = Instance.new("ImageLabel")
    local WelcomeDescription = Instance.new("TextLabel")
    local Welcome = Instance.new("TextLabel")
    local CommunityInformation = Instance.new("TextLabel")
    local CommunityDescription = Instance.new("TextLabel")
    local ImageButton = Instance.new("ImageButton")
    local ImageButton_2 = Instance.new("ImageButton")
    local SideReadyFrame = Instance.new("Frame")
    local UICorner_4 = Instance.new("UICorner")
    local TextLabel = Instance.new("TextLabel")
        
    WelcomeScreen.Name = "AtlasAdminv3Welcome"
    WelcomeScreen.Parent = game:GetService("CoreGui")
    WelcomeScreen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    BackgroundFrame.Name = "BackgroundFrame"
    BackgroundFrame.Parent = WelcomeScreen
    BackgroundFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    BackgroundFrame.BackgroundTransparency = 1 -- Old = 0
    BackgroundFrame.Position = UDim2.new(0.404477596, 0, 0.218952626, 0)
    BackgroundFrame.Size = UDim2.new(0, 319, 0, 450)
    
    TopBar.Name = "TopBar"
    TopBar.Parent = BackgroundFrame
    TopBar.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
    TopBar.BackgroundTransparency = 1
    TopBar.Size = UDim2.new(0, 319, 0, 62)

    Title.Name = "Title"
    Title.Parent = TopBar
    Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1
    Title.TextTransparency = 1 -- Old = 0
    Title.Position = UDim2.new(0, 0, 0.0322580636, 0)
    Title.Size = UDim2.new(0, 319, 0, 62)
    Title.Font = Enum.Font.SourceSans
    Title.Text = "Welcome " .. tostring(game.Players.LocalPlayer.DisplayName) .. "!"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 33.000
    
    Line.Name = "Line"
    Line.Parent = TopBar
    Line.AnchorPoint = Vector2.new(0, 0.879999995)
    Line.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Line.BackgroundTransparency = 1
    Line.BorderColor3 = Color3.fromRGB(232, 232, 232)
    Line.Position = UDim2.new(0.479999989, 0, 0.860000014, 0)

    UICorner.CornerRadius = UDim.new(0, 4)
    UICorner.Parent = Line
    
    UICorner_2.CornerRadius = UDim.new(0, 4)
    UICorner_2.Parent = TopBar
    
    UICorner_3.Parent = BackgroundFrame
    
    CodeImage.Name = "CodeImage"
    CodeImage.ImageTransparency = 1 -- Old = 0
    CodeImage.Parent = BackgroundFrame
    CodeImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    CodeImage.BackgroundTransparency = 1.000
    CodeImage.Position = UDim2.new(0.427685559, 0, 0.119922616, 0)
    CodeImage.Size = UDim2.new(0, 47, 0, 47)
    CodeImage.Image = "rbxassetid://7072707514"
    
    WelcomeDescription.Name = "WelcomeDescription"
    WelcomeDescription.Parent = BackgroundFrame
    WelcomeDescription.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    WelcomeDescription.BackgroundTransparency = 1
    WelcomeDescription.TextTransparency = 1 -- Old = 0
    WelcomeDescription.Position = UDim2.new(0.122257054, 0, 0.260007173, 0)
    WelcomeDescription.Size = UDim2.new(0, 240, 0, 87)
    WelcomeDescription.Font = Enum.Font.SourceSans
    WelcomeDescription.Text = "The latest and most powerful entitlement of Atlas Admin. By using this script you are now equipped with even better performance and advanced features to enhance your experience."
    WelcomeDescription.TextColor3 = Color3.fromRGB(255, 255, 255)
    WelcomeDescription.TextScaled = true
    WelcomeDescription.TextSize = 15.000
    WelcomeDescription.TextWrapped = true
    
    Welcome.Name = "Welcome"
    Welcome.Parent = BackgroundFrame
    Welcome.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Welcome.BackgroundTransparency = 1
    Welcome.TextTransparency = 1 -- Old = 0
    Welcome.Position = UDim2.new(0.188087776, 0, 0.172613457, 0)
    Welcome.Size = UDim2.new(0, 200, 0, 50)
    Welcome.Font = Enum.Font.SourceSans
    Welcome.Text = "Welcome to Atlas Admin v3,"
    Welcome.TextColor3 = Color3.fromRGB(255, 255, 255)
    Welcome.TextSize = 24.000
    
    CommunityInformation.Name = "Community Information"
    CommunityInformation.Parent = BackgroundFrame
    CommunityInformation.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    CommunityInformation.BackgroundTransparency = 1
    CommunityInformation.TextTransparency = 1 -- Old = 0
    CommunityInformation.Position = UDim2.new(0.184952974, 0, 0.442660362, 0)
    CommunityInformation.Size = UDim2.new(0, 200, 0, 50)
    CommunityInformation.Font = Enum.Font.SourceSans
    CommunityInformation.Text = "Community Info"
    CommunityInformation.TextColor3 = Color3.fromRGB(255, 255, 255)
    CommunityInformation.TextSize = 24.000
    
    CommunityDescription.Name = "CommunityDescription"
    CommunityDescription.Parent = BackgroundFrame
    CommunityDescription.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    CommunityDescription.BackgroundTransparency = 1
    CommunityDescription.TextTransparency = 1 -- Old = 0
    CommunityDescription.Position = UDim2.new(0.125391856, 0, 0.507831872, 0)
    CommunityDescription.Size = UDim2.new(0, 240, 0, 87)
    CommunityDescription.Font = Enum.Font.SourceSans
    CommunityDescription.Text = "If you would like to join our community or need any support click any of the buttons below to join our discord server or copy a link to our roblox group."
    CommunityDescription.TextColor3 = Color3.fromRGB(255, 255, 255)
    CommunityDescription.TextScaled = true
    CommunityDescription.TextSize = 15.000
    CommunityDescription.TextWrapped = true
    
    ImageButton.Parent = BackgroundFrame
    ImageButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ImageButton.BackgroundTransparency = 1
    ImageButton.ImageTransparency = 1 -- Old = 0
    ImageButton.Position = UDim2.new(0.225705326, 0, 0.684444427, 0)
    ImageButton.Size = UDim2.new(0, 64, 0, 64)
    ImageButton.Image = "http://www.roblox.com/asset/?id=12185058934"
    
    ImageButton_2.Parent = BackgroundFrame
    ImageButton_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ImageButton_2.BackgroundTransparency = 1
    ImageButton_2.ImageTransparency = 1 -- Old = 0
    ImageButton_2.Position = UDim2.new(0.573667705, 0, 0.684444427, 0)
    ImageButton_2.Size = UDim2.new(0, 64, 0, 64)
    ImageButton_2.Image = "http://www.roblox.com/asset/?id=12474185785"
    
    SideReadyFrame.Name = "SideReadyFrame"
    SideReadyFrame.Parent = WelcomeScreen
    SideReadyFrame.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
    SideReadyFrame.BackgroundTransparency = 1 -- Old = 0
    SideReadyFrame.Position = UDim2.new(0.594626844, 0, 0.295511216, 0)
    SideReadyFrame.Size = UDim2.new(0, 237, 0, 235)
    
    UICorner_4.CornerRadius = UDim.new(0, 4)
    UICorner_4.Parent = SideReadyFrame
    
    TextLabel.Parent = SideReadyFrame
    TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.BackgroundTransparency = 1
    TextLabel.TextTransparency = 1 -- Old = 0
    TextLabel.Size = UDim2.new(0, 237, 0, 235)
    TextLabel.Font = Enum.Font.SourceSans
    TextLabel.Text = "Whenever you are ready, press your semicolon key ( ; ) to continue. Keep in mind that you can change this keybind at any time by executing the command \"changeprefix\" or \"changepf\". Enjoy using Atlas v3 to its fullest potential."
    TextLabel.TextColor3 = Color3.fromRGB(254, 254, 254)
    TextLabel.TextScaled = true
    TextLabel.TextSize = 1.000
    TextLabel.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.TextWrapped = true

    local TweenWelcomeUIAppear = function()
        wait(1)
        drawingTween(BackgroundFrame, "BackgroundTransparency", 0, 2)
        drawingTween(TopBar, "BackgroundTransparency", 0, 2)
        task.wait(.1)
        drawingTween(Line, "BackgroundTransparency", 0, 2)
        local Tween = game:GetService("TweenService"):Create(Line, TweenInfo.new(1,Enum.EasingStyle.Quint,Enum.EasingDirection.Out,0,false,0), {Size = UDim2.new(0, 124,0, 0),Position = UDim2.new(0.305, 0,0.767, 0)})
        Tween:Play()
        task.wait(.3)
        drawingTween(Title, "TextTransparency", 0, 2)
        wait(.5)
        drawingTween(CodeImage, "ImageTransparency", 0, 3)
        task.wait()
        drawingTween(Welcome, "TextTransparency", 0, 3)
        wait(.1)
        drawingTween(WelcomeDescription, "TextTransparency", 0, 3)            
        wait(.5)
        drawingTween(CommunityInformation, "TextTransparency", 0, 3)
        wait(.1)
        drawingTween(CommunityDescription, "TextTransparency", 0, 3)            
        wait(.5)
        coroutine.wrap(function()
            drawingTween(ImageButton, "ImageTransparency", 0, 2)
            drawingTween(ImageButton_2, "ImageTransparency", 0, 2)            
        end)()
    end
    
    local TweenWelcomeUIDisappear = function()
        task.wait()
        coroutine.wrap(function()
            drawingTween(ImageButton, "ImageTransparency", 1, 2)
            drawingTween(ImageButton_2, "ImageTransparency", 1, 2)            
        end)()
        wait(.2)
        drawingTween(CommunityDescription, "TextTransparency", 1, 3)            
        wait(.1)
        drawingTween(CommunityInformation, "TextTransparency", 1, 3)
        wait(.5)
        drawingTween(WelcomeDescription, "TextTransparency", 1, 3)            
        wait(.1)
        drawingTween(Welcome, "TextTransparency", 1, 3)
        task.wait()
        drawingTween(CodeImage, "ImageTransparency", 1, 3)
        wait(.2)
        Line:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.In, Enum.EasingStyle.Sine, 1)
        wait(.4)
        drawingTween(Title, "TextTransparency", 1, 2)
        wait(.3)
        drawingTween(TopBar, "BackgroundTransparency", 1, 2)
        drawingTween(BackgroundFrame, "BackgroundTransparency", 1, 2)
        drawingTween(Line, "BackgroundTransparency", 1, 2)
        drawingTween(SideReadyFrame, "BackgroundTransparency", 1, 2)
        drawingTween(TextLabel, "TextTransparency", 1, 2)
        task.wait(3)
        Passed = true
        if game.CoreGui:FindFirstChild("AtlasAdminv3Welcome") then
            game.CoreGui:FindFirstChild("AtlasAdminv3Welcome"):Destroy()
        end
    end

    getgenv().UIConnection = game:GetService("UserInputService").InputBegan:connect(function(input, Processed)
        if not Processed then
            if input.KeyCode == Enum.KeyCode.Semicolon then
                TweenWelcomeUIDisappear()
                getgenv().UIConnection:Disconnect()
            end
        end
    end)

    task.wait(5)
    drawingTween(SideReadyFrame, "BackgroundTransparency", 0, 2)
    drawingTween(TextLabel, "TextTransparency", 0, 2)
    task.wait(5)
    drawingTween(SideReadyFrame, "BackgroundTransparency", 1, 2)
    drawingTween(TextLabel, "TextTransparency", 1, 2)
end

local ViewportSize = workspace.Camera.ViewportSize

local CommandBar = Instance.new("ScreenGui")
local Holder = Instance.new("Frame")
local ExecuteTextBox = Instance.new("TextBox")
local UICorner = Instance.new("UICorner")

CommandBar.Name = "CommandBar"
CommandBar.Parent = game:GetService("CoreGui")

Holder.Name = "Holder"
Holder.Parent = CommandBar
Holder.AnchorPoint = Vector2.new(0.5, 0, 0.8, 0)
Holder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Holder.BackgroundTransparency = 1
Holder.Position = UDim2.new(0.5, 0, 0.8, 0)
Holder.Size = UDim2.new(0, 0, 0, ViewportSize.Y / 16)

ExecuteTextBox.Name = "ExecuteTextBox"
ExecuteTextBox.Parent = Holder
ExecuteTextBox.Size = UDim2.new(0, 0, 0, ViewportSize.Y / 20)
ExecuteTextBox.AnchorPoint = Vector2.new(0.5, 0, 0.8, 0)
ExecuteTextBox.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
ExecuteTextBox.Font = Enum.Font.SourceSans
ExecuteTextBox.Text = ""
ExecuteTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
ExecuteTextBox.TextSize = 20
ExecuteTextBox.TextStrokeColor3 = Color3.new(0, 0, 127)
ExecuteTextBox.TextStrokeTransparency = 1
ExecuteTextBox.BackgroundTransparency = 1

UICorner.CornerRadius = UDim.new(0, 4)
UICorner.Parent = ExecuteTextBox

--//\--

local Help = Instance.new("ScreenGui")
local Holder = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local HelpDescription1 = Instance.new("TextLabel")
local HelpDescription2 = Instance.new("TextLabel")
local Arrow = Instance.new("ImageLabel")

Help.Name = "Help"
Help.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
Help.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Holder.Name = "Holder"
Holder.Parent = Help
Holder.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
Holder.BackgroundTransparency = 1
Holder.Position = UDim2.new(0.620343864, 0, 0.50000006, 0)
Holder.Size = UDim2.new(0, 340, 0, 217)

UICorner.CornerRadius = UDim.new(0, 4)
UICorner.Parent = Holder

if FirstExecute == true then
    repeat task.wait() until Passed == true
end

local Focused = false

local AlreadyPassed = false

if FirstExecute == false then
    AlreadyPassed = true
end

ExecuteTextBox.FocusLost:Connect(function()
    if not Focused == false then
        Focused = false
        coroutine.wrap(function()
            drawingTween(ExecuteTextBox, "TextTransparency", 1, 0.5)
            drawingTween(ExecuteTextBox, "BackgroundTransparency", 1, 0.5)
        end)()
        ExecuteTextBox.Text = ""
        ExecuteTextBox.PlaceholderText = ""
        wait()
        ExecuteTextBox:TweenSize(UDim2.new(0, 0, 0, ViewportSize.Y / 18), Enum.EasingDirection.Out, Enum.EasingStyle.Quint, 0.1)
    end
end)

local OnBindPressed = function()
    if not Focused == true then
        Focused = true
        coroutine.wrap(function()
            drawingTween(ExecuteTextBox, "TextTransparency", 0, 1)
            drawingTween(ExecuteTextBox, "BackgroundTransparency", 0, 1)
        end)()
        local Tween = ExecuteTextBox:TweenSize(UDim2.new(0, ViewportSize.X / 8, 0, ViewportSize.Y / 18), Enum.EasingDirection.Out, Enum.EasingStyle.Quint, 0.5)
        task.wait()
        ExecuteTextBox:CaptureFocus()
        ExecuteTextBox.Text = ""
        coroutine.wrap(function()
            repeat
                ExecuteTextBox.PlaceholderText = "Type A Command..."
                task.wait(.3)
                ExecuteTextBox.PlaceholderText = "Type A Command.."
                task.wait(.3)
                ExecuteTextBox.PlaceholderText = "Type A Command."
                task.wait(.3)
                ExecuteTextBox.PlaceholderText = "Type A Command.."
                task.wait(.3)
                ExecuteTextBox.PlaceholderText = "Type A Command..."
            until Focused == false
        end)()
        if AlreadyPassed ~= true then
            drawingTween(Holder, "BackgroundTransparency", 0, 1)
            task.wait()
            drawingTween(HelpDescription1, "TextTransparency", 0, 2)
            task.wait()
            drawingTween(Arrow, "Rotation", -50, 2)
            drawingTween(Arrow, "ImageTransparency", 0, 2)
            task.wait(7)
            drawingTween(HelpDescription1, "TextTransparency", 1, 1)
            task.wait(.2)
            drawingTween(HelpDescription2, "TextTransparency", 0, 1)
            task.wait(7)
            drawingTween(HelpDescription2, "TextTransparency", 1, 1)
            drawingTween(Arrow, "Rotation", 150, 2)
            task.wait(.3)
            drawingTween(Arrow, "ImageTransparency", 1, 2)
            drawingTween(Holder, "BackgroundTransparency", 1, 1)
            if game:GetService("CoreGui"):FindFirstChild("Help") then
                game:GetService("CoreGui"):FindFirstChild("Help"):Destroy()
            end
        end
        AlreadyPassed = true
    end
end

game.ContextActionService:BindAction("keyPress", OnBindPressed, false, Enum.KeyCode.Semicolon)

--\\ CommandsUI //--
local AtlasGui = Instance.new("ScreenGui")
local Popout = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local Name = Instance.new("TextLabel")
local DropShadow = Instance.new("ImageLabel")
local CommandDescription = Instance.new("TextLabel")
local Alias = Instance.new("TextLabel")
local Aliasheader = Instance.new("TextLabel")
local DescriptionHeader = Instance.new("TextLabel")
local Background = Instance.new("Frame")
local UICorner_2 = Instance.new("UICorner")
local DropShadow_2 = Instance.new("ImageLabel")
local Scroll = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")
local SampleCommand = Instance.new("Frame")
local Command = Instance.new("TextLabel")
local UICorner_3 = Instance.new("UICorner")
local ImageButton = Instance.new("ImageButton")
local UIPadding = Instance.new("UIPadding")
local Header = Instance.new("Frame")
local UICorner_4 = Instance.new("UICorner")
local AdminName = Instance.new("TextLabel")
local CloseButton = Instance.new("ImageButton")

AtlasGui.Name = "AtlasCMDSGui"
AtlasGui.Parent = game:GetService("CoreGui")
AtlasGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Popout.Name = "Popout"
Popout.Parent = AtlasGui
Popout.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Popout.Position = UDim2.new(0.575, 0, 0.27, 0)
Popout.Size = UDim2.new(0, 268, 0, 195)
Popout.BackgroundTransparency = 1

UICorner.CornerRadius = UDim.new(0, 4)
UICorner.Name = " "
UICorner.Parent = Popout

Name.Name = "Name"
Name.Parent = Popout
Name.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
Name.BackgroundTransparency = 1
Name.Position = UDim2.new(-0.0186574012, 0, 0, 0)
Name.Size = UDim2.new(0, 268, 0, 38)
Name.Font = Enum.Font.SourceSansSemibold
Name.Text = "Test"
Name.TextColor3 = Color3.fromRGB(255, 255, 255)
Name.TextSize = 23.000
Name.TextWrapped = true

DropShadow.Name = "DropShadow"
DropShadow.Parent = Popout
DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
DropShadow.BackgroundTransparency = 1
DropShadow.BorderSizePixel = 0
DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
DropShadow.Size = UDim2.new(1, 47, 1, 47)
DropShadow.ZIndex = 0
DropShadow.Image = "rbxassetid://6014261993"
DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
DropShadow.ImageTransparency = 1 -- Old = 0.500
DropShadow.ScaleType = Enum.ScaleType.Slice
DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)

CommandDescription.Name = "Description"
CommandDescription.Parent = Popout
CommandDescription.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
CommandDescription.BackgroundTransparency = 1
CommandDescription.Position = UDim2.new(0, 0, 0.200000003, 0)
CommandDescription.Size = UDim2.new(0, 268, 0, 74)
CommandDescription.Font = Enum.Font.SourceSansSemibold
CommandDescription.Text = "Prints Test."
CommandDescription.TextColor3 = Color3.fromRGB(255, 255, 255)
CommandDescription.TextSize = 18
CommandDescription.TextWrapped = true

Alias.Name = "Alias"
Alias.Parent = Popout
Alias.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
Alias.BackgroundTransparency = 1
Alias.Position = UDim2.new(0, 0, 0.579487205, 0)
Alias.Size = UDim2.new(0, 268, 0, 82)
Alias.Font = Enum.Font.SourceSansSemibold
Alias.Text = "{T, tt, print}"
Alias.TextColor3 = Color3.fromRGB(255, 255, 255)
Alias.TextSize = 18
Alias.TextWrapped = true

Aliasheader.Name = "Aliasheader"
Aliasheader.Parent = Popout
Aliasheader.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
Aliasheader.BackgroundTransparency = 1
Aliasheader.Position = UDim2.new(0, 0, 0.579487205, 0)
Aliasheader.Size = UDim2.new(0, 268, 0, 32)
Aliasheader.Font = Enum.Font.SourceSansSemibold
Aliasheader.Text = "↓ Alias ↓"
Aliasheader.TextColor3 = Color3.fromRGB(255, 255, 255)
Aliasheader.TextSize = 20.000
Aliasheader.TextWrapped = true

DescriptionHeader.Name = "DescriptionHeader"
DescriptionHeader.Parent = Popout
DescriptionHeader.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
DescriptionHeader.BackgroundTransparency = 1
DescriptionHeader.Position = UDim2.new(0, 0, 0.158974364, 0)
DescriptionHeader.Size = UDim2.new(0, 268, 0, 32)
DescriptionHeader.Font = Enum.Font.SourceSansSemibold
DescriptionHeader.Text = "↓ Description ↓"
DescriptionHeader.TextColor3 = Color3.fromRGB(255, 255, 255)
DescriptionHeader.TextSize = 20
DescriptionHeader.TextWrapped = true

Background.Name = "Background"
Background.Parent = AtlasGui
Background.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Background.Position = UDim2.new(0.400240362, 0, 0.228179559, 0)
Background.Size = UDim2.new(0, 332, 0, 436)

UICorner_2.CornerRadius = UDim.new(0, 4)
UICorner_2.Name = " "
UICorner_2.Parent = Background

DropShadow_2.Name = "DropShadow"
DropShadow_2.Parent = Background
DropShadow_2.AnchorPoint = Vector2.new(0.5, 0.5)
DropShadow_2.BackgroundTransparency = 1
DropShadow_2.BorderSizePixel = 0
DropShadow_2.Position = UDim2.new(0.5, 0, 0.5, 0)
DropShadow_2.Size = UDim2.new(1, 47, 1, 47)
DropShadow_2.ZIndex = 0
DropShadow_2.Image = "rbxassetid://6014261993"
DropShadow_2.ImageColor3 = Color3.fromRGB(0, 0, 0)
DropShadow_2.ImageTransparency = 1 -- Old = 0.500
DropShadow_2.ScaleType = Enum.ScaleType.Slice
DropShadow_2.SliceCenter = Rect.new(49, 49, 450, 450)

Scroll.Name = "Scroll"
Scroll.Parent = Background
Scroll.Active = true
Scroll.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.Position = UDim2.new(0, 0, 0.0917431191, 0)
Scroll.Size = UDim2.new(0, 332, 0, 396)
Scroll.ScrollBarThickness = 0

UIListLayout.Name = " "
UIListLayout.Parent = Scroll
UIListLayout.SortOrder = Enum.SortOrder.Name
UIListLayout.Padding = UDim.new(0, 2)

SampleCommand.Name = "SampleCommand"
SampleCommand.Parent = Scroll
SampleCommand.BackgroundColor3 = Color3.fromRGB(44, 44, 44)
SampleCommand.BorderSizePixel = 0
SampleCommand.Visible = false
SampleCommand.Position = UDim2.new(0.0391566232, 0, 0.051605504, 0)
SampleCommand.Size = UDim2.new(0, 316, 0, 38)

Command.Name = "Command"
Command.Parent = SampleCommand
Command.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
Command.BackgroundTransparency = 1
Command.Position = UDim2.new(0.00949367043, 0, 0, 0)
Command.Size = UDim2.new(0, 311, 0, 38)
Command.Font = Enum.Font.SourceSansSemibold
Command.Text = "%s"
Command.TextColor3 = Color3.fromRGB(255, 255, 255)
Command.TextSize = 22.000
Command.TextWrapped = true

UICorner_3.CornerRadius = UDim.new(0, 4)
UICorner_3.Name = " "
UICorner_3.Parent = SampleCommand

ImageButton.Parent = SampleCommand
ImageButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ImageButton.BackgroundTransparency = 1
ImageButton.Position = UDim2.new(0.89403975, 0, 0, 0)
ImageButton.Size = UDim2.new(0, 38, 0, 38)
ImageButton.Image = "http://www.roblox.com/asset/?id=6031090994"

UIPadding.Name = " "
UIPadding.Parent = Scroll
UIPadding.PaddingLeft = UDim.new(0, 8)

Header.Name = "Header"
Header.Parent = Background
Header.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
Header.BorderSizePixel = 0
Header.Size = UDim2.new(0, 332, 0, 38)

UICorner_4.Parent = Header

AdminName.Name = "AdminName"
AdminName.Parent = Header
AdminName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
AdminName.BackgroundTransparency = 1
AdminName.Position = UDim2.new(-0.000891628035, 0, 0, 0)
AdminName.Size = UDim2.new(0, 332, 0, 43)
AdminName.Font = Enum.Font.SourceSansSemibold
AdminName.Text = "Atlas Admin"
AdminName.TextColor3 = Color3.fromRGB(255, 255, 255)
AdminName.TextSize = 29.000
AdminName.TextWrapped = true

CloseButton.Parent = Header
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.BackgroundTransparency = 1
CloseButton.Position = UDim2.new(0.909638524, 0, 0.289473683, 0)
CloseButton.Size = UDim2.new(0, 20, 0, 20)
CloseButton.Image = "http://www.roblox.com/asset/?id=6023426928"

for i,v in pairs(AtlasGui:GetDescendants()) do
    if v:IsA("Frame") then
        v.BackgroundTransparency = 1
    end
    if v:IsA("ImageLabel") or v:IsA("ImageButton") then
        v.BackgroundTransparency = 1
        v.ImageTransparency = 1
    end
    if v:IsA("TextLabel") then
        v.TextTransparency = 1
    end
end

--\\ End //--

local Admin = {Prefix = readfile("AtlasAdminv3/Prefix.txt"), Name = "Atlas Admin", Version = "v3"}

local AlreadyShowingInfo
local ShowingCommandInfoFor
local Commands = {}
local TemporaryCommands = {}
local Notified = {}
getgenv().AddCommand = function(CommandName, Aliases, Description, Function)
    local Grammar = string.split(Description, " ")
	Grammar[1] = Grammar[1]:sub(1, 1):upper() .. Grammar[1]:sub(2, #Grammar[1])
	Description = table.concat(Grammar, " ")

	CommandName = CommandName:lower()
	table.insert(TemporaryCommands, CommandName)

	local Aliases2 = Aliases
	for i,v in next, Aliases do
		v = ";" .. v
	end

	table.insert(Commands, CommandName)

	for i,v in pairs(Aliases) do
		Aliases[i] = Aliases[i]:lower()
		table.insert(TemporaryCommands, v)
	end

    local CommandText = SampleCommand:Clone()
    local NewTextLabel = CommandText:FindFirstChildOfClass("TextLabel")
    local NewImageButton = CommandText:FindFirstChildOfClass("ImageButton")
	NewTextLabel.Name = CommandName
    NewTextLabel.TextTransparency = 1
	CommandText.Visible = true
    CommandText.BackgroundTransparency = 1
	CommandText.Parent = Scroll
    NewImageButton.ImageTransparency = 1

    local Tweening

    local ShowPopOutInfo = function()
        drawingTween(Popout, "BackgroundTransparency", 0, 1) -- Turning New Clicked
        drawingTween(Name, "TextTransparency", 0, 2) -- Turning New Clicked
        drawingTween(DescriptionHeader, "TextTransparency", 0, 1) -- Turning New Clicked
        drawingTween(CommandDescription, "TextTransparency", 0, 1) -- Turning New Clicked
        drawingTween(Aliasheader, "TextTransparency", 0, 1) -- Turning New Clicked
        drawingTween(Alias, "TextTransparency", 0, 1) -- Turning New Clicked
    end

    local HidePopOutInfo = function()
        drawingTween(Name, "TextTransparency", 1, 1) -- Turning New Clicked
        drawingTween(DescriptionHeader, "TextTransparency", 1, 1) -- Turning New Clicked
        drawingTween(CommandDescription, "TextTransparency", 1, 1) -- Turning New Clicked
        drawingTween(Aliasheader, "TextTransparency", 1, 1) -- Turning New Clicked
        drawingTween(Alias, "TextTransparency", 1, 1) -- Turning New Clicked
        drawingTween(Popout, "BackgroundTransparency", 1, 1) -- Turning New Clicked
    end

    local Debounce

    NewImageButton.MouseButton1Click:Connect(function()
        if AlreadyShowingInfo then
            if ShowingCommandInfoFor ~= tostring(CommandName) then
                ShowingCommandInfoFor = tostring(CommandName)
                if Popout.BackgroundTransparency == 0 then
                    if not Debounce then
                        Debounce = true
                        print("Already running attempting to change stats and reverting arrow.")
                        Name.Text = CommandName
                        CommandDescription.Text = Description
                        Alias.Text = " {" .. table.concat(Aliases, ", ") .. "}"
                        for i,v in pairs(AtlasGui:FindFirstChild("Background"):FindFirstChild("Scroll"):GetDescendants()) do -- Arrow Check
                            if v:IsA("ImageButton") and v.Rotation == 180 then
                                drawingTween(v, "Rotation", 0, 1) -- Turning
                            end
                        end
                        drawingTween(NewImageButton, "Rotation", 180, 1) -- Turning New Clicked
                        AlreadyShowingInfo = true
                        wait(1)
                        Debounce = false
                    end
                end
            else
                if not Debounce then
                    Debounce = true
                    print("Found same arrow clicked for same command now hiding.")
                    drawingTween(NewImageButton, "Rotation", 0, 1) -- Turning New Clicked
                    HidePopOutInfo()
                    AlreadyShowingInfo = false
                    wait(1)
                    Debounce = false
                end
            end
        else
            if Popout.BackgroundTransparency ~= 0 then
                if not Debounce then
                    Debounce = true
                    print("Didn't detect already existing, creating new values.")
                    Name.Text = CommandName
                    CommandDescription.Text = Description
                    Alias.Text = " {" .. table.concat(Aliases, ", ") .. "}"
                    drawingTween(NewImageButton, "Rotation", 180, 1) -- Turning New Clicked
                    ShowPopOutInfo()
                    AlreadyShowingInfo = true
                    wait(1)
                    Debounce = false
                end
            else
                if not Debounce then
                    Debounce = true
                    print("Detected already running? Attempting to change stats.")
                    Name.Text = CommandName
                    CommandDescription.Text = Description
                    Alias.Text = " {" .. table.concat(Aliases, ", ") .. "}"
                    drawingTween(NewImageButton, "Rotation", 180, 1) -- Turning New Clicked
                    ShowPopOutInfo()
                    AlreadyShowingInfo = true
                    wait(1)
                    Debounce = false
                end
            end
        end
    end)
    
	local StringValue = Instance.new("StringValue", CommandText)
	StringValue.Value = Description

	if #Aliases > 0 then
		NewTextLabel.Text = CommandName .. " {" .. table.concat(Aliases, ", ") .. "}"
	else
		NewTextLabel.Text = CommandName
	end

    ExecuteTextBox.FocusLost:Connect(function(Enter)
		if Enter then
			local Split = string.split(ExecuteTextBox.Text, " ")
			if Split[1] == CommandName or (table.find(Aliases2, Split[1])) then
				local FunctionTable = {}
				for i,v in pairs(Split) do
					if i ~= 1 then table.insert(FunctionTable, v) end
				end
				Notify(string.format("Successfully ran %s", Split[1]), "success", 3)
				Function(unpack(FunctionTable))
			else
				if not table.find(TemporaryCommands, Split[1]) and not table.find(Notified, Split[1]) and (ExecuteTextBox.Text ~= "") then
					table.insert(Notified, Split[1])
					Notify(string.format("%s is not a valid command", Split[1]), "error", 4)
				end
			end
		end
	end)
end

AddCommand("cmds",{"commands"},"Displays a list of available commands that are accessible to you.",function()
    if game:GetService("CoreGui"):FindFirstChild("AtlasCMDSGui"):FindFirstChild("Background").BackgroundTransparency == 0 then
        return Notify("Already running.")
    end
    drawingTween(DropShadow_2, "ImageTransparency", 0.500, 1)
    drawingTween(Background, "BackgroundTransparency", 0, 1)
    drawingTween(Header, "BackgroundTransparency", 0, 1)
    drawingTween(CloseButton, "ImageTransparency", 0, 1)
    drawingTween(AdminName, "TextTransparency", 0, 1)
    for i,v in pairs(AtlasGui:FindFirstChild("Background"):FindFirstChild("Scroll"):GetDescendants()) do
        if v:IsA("ImageButton") then
            drawingTween(v, "ImageTransparency", 0, 1)
        end
        if v:IsA("TextLabel") then
            drawingTween(v, "TextTransparency", 0, 1)
        end
        if v:IsA("Frame") then
            drawingTween(v, "BackgroundTransparency", 0, 1)
        end
    end
    local CommandNumber = 0
	for i,v in pairs(Commands) do 
        Scroll.CanvasSize = UDim2.new(0, UIListLayout.AbsoluteContentSize.X, 0, UIListLayout.AbsoluteContentSize.Y)
		CommandNumber += 1
	end

    Notify("There Are Currently " .. CommandNumber .. " Commands")

    CloseButton.MouseButton1Click:Connect(function()
        for i,v in pairs(AtlasGui:FindFirstChild("Background"):FindFirstChild("Scroll"):GetDescendants()) do
            if v:IsA("ImageButton") then
                drawingTween(v, "ImageTransparency", 1, 1)
            end
            if v:IsA("TextLabel") then
                drawingTween(v, "TextTransparency", 1, 1)
            end
            if v:IsA("Frame") then
                drawingTween(v, "BackgroundTransparency", 1, 1)
            end
        end
        task.wait(0.1)
        drawingTween(CloseButton, "ImageTransparency", 1, 1)
        drawingTween(AdminName, "TextTransparency", 1, 1)
        drawingTween(Header, "BackgroundTransparency", 1, 1)
        drawingTween(Background, "BackgroundTransparency", 1, 1)
        drawingTween(DropShadow_2, "ImageTransparency", 1, 1)
    end)
end)
AddCommand("rj",{"rejoin"},"Immediately attempts to reconnect you to the same server you were just in.",function()
    rejoining = true
	game:GetService('TeleportService'):TeleportToPlaceInstance(game.PlaceId, game.JobId, game:GetService("Players"))
	wait(3)
	rejoining = false
end)

AddCommand("test",{"testing"},"testing",function()
    print'atlas v3 rewritten by drill'
end)
