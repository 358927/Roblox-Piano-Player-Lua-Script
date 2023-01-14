local ps = game:GetService("Players")
local me = ps.LocalPlayer


local SoundFolder
local sounds = { "9136673401", "9136674260", "9136675154", "9136676019", "9136676980", "9136677713" }
function playNote(Note,Volume)
	local NotePitch = 1;
	if 61 < Note then
		NotePitch = 1.059463 ^ (Note - 61);
	elseif Note < 1 then
		NotePitch = 1.059463 ^ (-(1 - Note));
	end;
	if 61 < Note then
		local v53 = 61;
	elseif Note < 1 then
		v53 = 1;
	else
		v53 = Note;
	end;
	Note = v53;
	local NoteFrom1To12 = (Note - 1) % 12 + 1;
	local Octave = math.ceil(Note / 12);
	local v56 = math.ceil(NoteFrom1To12 / 2);
	local SoundInstance = Instance.new("Sound", SoundFolder);
	SoundInstance.SoundId = "https://roblox.com/asset/?id=" .. sounds[v56];
	SoundInstance.Volume = Volume;
	SoundInstance.TimePosition = 16 * (Octave - 1) + 8 * (1 - NoteFrom1To12 % 2) + 0.04;
	SoundInstance.Pitch = NotePitch;
	SoundInstance:Play();
	task.delay(5, function()
		SoundInstance:Stop();
		SoundInstance:remove();
	end);
end

function CreateRandomString()
    length = math.random(5,30)
    outStr = ""
    for _ = 1, length do
        outStr = outStr .. string.char(math.random(0,200))
    end
    return outStr
end

function CreateRandomString()
    length = math.random(25,50)
    outStr = ""
    for _ = 1, length do
        outStr = outStr .. string.char(math.random(36,127))
    end
    return outStr
end

local e = game:GetService("CoreGui"):FindFirstChild("fasdfasdfasdf",true)
if e then e.Parent.Parent:Destroy() end
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = CreateRandomString()
syn.protect_gui(ScreenGui)
ScreenGui.Parent = game:GetService("CoreGui")
--ScreenGui.Parent = me.PlayerGui
SoundFolder = Instance.new("Folder",ScreenGui)

local UIS = game:GetService("UserInputService")
local BreakBool = false
local PauseBool = false
local LoopBool = false

local BreakHotKey = Enum.KeyCode.Space
local PauseHotKey = Enum.KeyCode.Tab
local HideGuiHotKey = Enum.KeyCode.F1

local Midis = {}
if _G.close then _G.close() end
local UISConnection = UIS.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if UIS:IsKeyDown(BreakHotKey) then
		BreakBool = true
		return
	end
	if UIS:IsKeyDown(PauseHotKey) then
		PauseBool = not PauseBool
		return
	end   
	if UIS:IsKeyDown(HideGuiHotKey) then
		ScreenGui.Enabled = not ScreenGui.Enabled
		return
	end   
end)

_G.close = function()
	UISConnection:Disconnect()
end

function Play(str)
	BreakBool = true
	PauseBool = false
	task.wait()
	BreakBool = false
	repeat
		for _,string in next, str:split("\n") do
			if BreakBool then break end
			while PauseBool do task.wait() end
			local cmd = string:split(":")[1]
			local arg = string:split(":")[2]
			if cmd == "Sleep" then
				task.wait(tonumber(arg))
			elseif cmd == "Play" then
				local Note,Volume = unpack(arg:split(","))
				playNote(tonumber(Note),tonumber(Volume))
				if game.PlaceId == 10851599 then
					workspace.Pianos.RemoteEvents.GlobalPianoConnector:FireServer("play",{
						["Note"] = tonumber(Note),
						["Transposition"] = 0,
						["Volume"] = tonumber(Volume)
					})
				end
			end
		end
		task.wait()
	until not LoopBool or BreakBool
end

local Frame = Instance.new("Frame")
Frame.Name = "Gui"
Frame.Parent = ScreenGui
Frame.Active = true
Frame.Draggable = true
Frame.Position = UDim2.new(0.1, 154, 0.5, -212)
Frame.Size = UDim2.new(0, 375, 0, 426)
Frame.Draggable = true
Frame.Active = true
Frame.Visible = true

local MidiLabel = Instance.new("TextLabel")
MidiLabel.Parent = Frame
MidiLabel.Name = "fasdfasdfasdf"
MidiLabel.BackgroundColor3 = Color3.fromRGB(198, 198, 198)
MidiLabel.BorderSizePixel = 0
MidiLabel.Position = UDim2.new(0, 5, 0.600000024, 17)
MidiLabel.Size = UDim2.new(1, -10, 0, 30)
MidiLabel.Text = ""

local UICorner = Instance.new("UICorner")
UICorner.Parent = MidiLabel

local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Parent = Frame
ScrollFrame.BorderSizePixel = 0
ScrollFrame.Position = UDim2.new(0, 5, 0, 10)
ScrollFrame.Size = UDim2.new(1, -10, 0.600000024, 0)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.ScrollBarThickness = 1

Index = 1

function RefreshList()
	ScrollFrame:ClearAllChildren()
	Midis = listfiles('RobloxMidiPlayer')
	if #Midis == 0 then Midis = {"No Midis loaded"} return end
	for i,file in next, Midis do
		local NewButton = Instance.new("TextButton")
		NewButton.Parent = ScrollFrame
		NewButton.Size = UDim2.new(1,0,0,35)
		NewButton.Position = UDim2.new(0,0,0,35*(i-1))
		NewButton.Text = file:sub(18,#file-4)
		NewButton.Activated:Connect(function()
			Index = i
			MidiLabel.Text = file:sub(18,#file-4)
		end)
	end
	if #Midis <= 5 then
		ScrollFrame.CanvasSize = UDim2.new(0,0,0,0)
	else
		ScrollFrame.CanvasSize = UDim2.new(0,0,0,35*(#Midis))
	end
end

RefreshList()

MidiLabel.Text = Midis[Index]:sub(18,#Midis[Index]-4)

local PlayButton = Instance.new("TextButton")
PlayButton.Name = "Play"
PlayButton.Parent = Frame
PlayButton.AnchorPoint = Vector2.new(0.5, 1)
PlayButton.BackgroundColor3 = Color3.fromRGB(198, 198, 198)
PlayButton.Position = UDim2.new(0.25, 0, 1, -5)
PlayButton.Size = UDim2.new(0.5, -10, 0, 50)
PlayButton.Text = "Play"
PlayButton.Activated:Connect(function()
	Play(readfile(Midis[Index]))
end)

UICorner:Clone().Parent = PlayButton

local StopButton = Instance.new("TextButton")
StopButton.Name = "Stop"
StopButton.Parent = Frame
StopButton.AnchorPoint = Vector2.new(0.5, 1)
StopButton.BackgroundColor3 = Color3.fromRGB(198, 198, 198)
StopButton.Position = UDim2.new(0.75, 0, 1, -5)
StopButton.Size = UDim2.new(0.5, -10, 0, 50)
StopButton.Text = "Stop"
StopButton.Activated:Connect(function()
	BreakBool = true
end)

UICorner:Clone().Parent = StopButton

local RefreshButton = Instance.new("TextButton")
RefreshButton.Name = "Refresh"
RefreshButton.Parent = Frame
RefreshButton.AnchorPoint = Vector2.new(0.5, 1)
RefreshButton.BackgroundColor3 = Color3.fromRGB(198, 198, 198)
RefreshButton.Position = UDim2.new(0.25, 0, 0.860000014, -5)
RefreshButton.Size = UDim2.new(0.5, -10, 0, 50)
RefreshButton.Text = "Refresh"
RefreshButton.Activated:Connect(function()
	Index = 1
	RefreshList()
	MidiLabel.Text = Midis[Index]:sub(18,#Midis[Index]-4)
end)

UICorner:Clone().Parent = RefreshButton

local LoopButton = Instance.new("TextButton")
LoopButton.Name = "Loop"
LoopButton.Parent = Frame
LoopButton.AnchorPoint = Vector2.new(0.5, 1)
LoopButton.BackgroundColor3 = Color3.fromRGB(198, 198, 198)
LoopButton.Position = UDim2.new(0.748666644, 0, 0.860000014, -5)
LoopButton.Size = UDim2.new(0.5, -10, 0, 50)
LoopButton.Text = "Loop Off"
LoopButton.Activated:Connect(function()
	LoopBool = not LoopBool
	if LoopBool then LoopButton.Text = "Loop On" else LoopButton.Text = "Loop Off" end
end)

UICorner:Clone().Parent = LoopButton

local PauseAndUnpuase = Instance.new("ImageButton")
PauseAndUnpuase.Parent = MidiLabel
PauseAndUnpuase.AnchorPoint = Vector2.new(0, 0.5)
PauseAndUnpuase.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
PauseAndUnpuase.BackgroundTransparency = 1.000
PauseAndUnpuase.Position = UDim2.new(0, 5, 0.5, 0)
PauseAndUnpuase.Size = UDim2.new(0, 25, 0, 25)
PauseAndUnpuase.Image = "rbxassetid://11931491169"
PauseAndUnpuase.Activated:Connect(function()
	PauseBool = not PauseBool
end)