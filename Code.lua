local player = game.Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")
function notifyPlayer(title, text)
    StarterGui:SetCore("SendNotification", {
        Title = title;
        Text = text;
        Duration = 20;
    })
end


notifyPlayer("Booty Offender", "Originally Made By Kyutatsuki13")




local fake_transparency = 1
local Motors = {
	["Left Hip"] = 0,
	["Neck"] = 0,
	["Left Shoulder"] = 0,
	["Right Hip"] = 0,
	["Right Shoulder"] = 0
}
local TS = game:GetService("TweenService")
local function getnext(tbl, number)
	local closestDiff = math.huge
	local closestValue = 0
	for i, v in pairs(tbl) do
		if i > number and i - number < closestDiff then
			closestDiff = i - number
			closestValue = i
		end
	end
	return closestValue
end
local function kftotbl(kf)
	local tbl3 = {}
	for _, v in pairs(kf:GetDescendants()) do
		if v:IsA("Pose") then
			tbl3[string.sub(v.Name, 1, 1) .. string.sub(v.Name, #v.Name, #v.Name)] = v.CFrame
		end
	end
	return tbl3
end
local function getSpeed(lastTimeStamp, currentTimeStamp)
	if currentTimeStamp == 0 then return 0 end
	return math.abs(lastTimeStamp - currentTimeStamp)
end
local function getAnimation(animationId)
	local animationObject
	local success, errorMsg = pcall(function()
		animationObject = game:GetObjects(animationId)[1]
	end)
	if not success then
		warn("Failed to load animation: " .. errorMsg)
		return nil
	end
	return animationObject
end
local Main = {}
Main.__index = Main

function Main.LoadDummy(DummyChar)
	local metatable = {}
	setmetatable(metatable, Main)
	metatable.char = DummyChar
	return metatable
end

function Main:LoadAnimation(animationId)
	local Character = self.char
	local animationObject = getAnimation(animationId)
	if not animationObject then return end
	print(animationObject)
	local metatable = {}
	setmetatable(metatable, Main)
	metatable.char = Character
	metatable.animObject = animationObject
	return metatable
end

function Main:Play()
	local Character = self.char
	local animationObject = self.animObject
	local Looped = true
	local anim = {}

	for _, v in pairs(animationObject:GetChildren()) do
		if v:IsA("Keyframe") then
			anim[v.Time] = kftotbl(v)
		end
	end

	local LH = Character.Torso["Left Hip"].C0
	local RH = Character.Torso["Right Hip"].C0
	local LS = Character.Torso["Left Shoulder"].C0
	local RS = Character.Torso["Right Shoulder"].C0
	local RoH = Character.HumanoidRootPart["RootJoint"].C0
	local N = Character.Torso["Neck"].C0
	local count = -1
	local lastTimeStamp = 0

	self.played = false
	local times = {
		Lg = 0,
		Rg = 0,
		Lm = 0,
		Rm = 0,
		To = 0,
		Hd = 0
	}
	local lasttime = tick()

	while not self.played do
		local timepassed = tick() - lasttime
		if not Looped then 
			self.played = true
		end	
		for i, v in pairs(anim) do
			local asdf = getnext(anim, count)
			v = anim[asdf]
			count = asdf

			task.wait(asdf - count)
			-- Handle keyframe updates
			if v["Lg"] then
				local Ti = TweenInfo.new(getSpeed(lastTimeStamp, asdf) + times.Lg + getSpeed(lastTimeStamp, asdf))
				times.Lg = 0
				TS:Create(Character.Torso["Left Hip"], Ti, {C0 = LH * v["Lg"]}):Play()
			else
				times.Lg = times.Lg + getSpeed(lastTimeStamp, asdf)
			end
			if v["Rg"] then
				local Ti = TweenInfo.new(getSpeed(lastTimeStamp, asdf) + times.Rg + getSpeed(lastTimeStamp, asdf))
				times.Rg = 0
				TS:Create(Character.Torso["Right Hip"], Ti, {C0 = RH * v["Rg"]}):Play()
			else
				times.Rg = times.Rg + getSpeed(lastTimeStamp, asdf)
			end
			if v["Lm"] then
				local Ti = TweenInfo.new(getSpeed(lastTimeStamp, asdf) + times.Lm + getSpeed(lastTimeStamp, asdf))
				times.Lm = 0
				TS:Create(Character.Torso["Left Shoulder"], Ti, {C0 = LS * v["Lm"]}):Play()
			else
				times.Lm = times.Lm + getSpeed(lastTimeStamp, asdf)
			end
			if v["Rm"] then
				local Ti = TweenInfo.new(getSpeed(lastTimeStamp, asdf) + times.Rm + getSpeed(lastTimeStamp, asdf))
				times.Rm = 0
				TS:Create(Character.Torso["Right Shoulder"], Ti, {C0 = RS * v["Rm"]}):Play()
			else
				times.Rm = times.Rm + getSpeed(lastTimeStamp, asdf)
			end
			if v["To"] then
				local Ti = TweenInfo.new(getSpeed(lastTimeStamp, asdf) + times.To + getSpeed(lastTimeStamp, asdf))
				times.To = 0
				TS:Create(Character.HumanoidRootPart["RootJoint"], Ti, {C0 = RoH * v["To"]}):Play()
			else
				times.To = times.To + getSpeed(lastTimeStamp, asdf)
			end
			if v["Hd"] then
				local Ti = TweenInfo.new(getSpeed(lastTimeStamp, asdf) + times.Hd + getSpeed(lastTimeStamp, asdf))
				times.Hd = 0
				TS:Create(Character.Torso["Neck"], Ti, {C0 = N * v["Hd"]}):Play()
			else
				times.Hd = times.Hd + getSpeed(lastTimeStamp, asdf)
			end
			task.wait(getSpeed(lastTimeStamp, asdf))
			lastTimeStamp = asdf
		end
	end
	
	-- Reset character to original pose after animation ends
	Character.Torso["Left Hip"].C0 = LH
	Character.Torso["Right Hip"].C0 = RH
	Character.Torso["Left Shoulder"].C0 = LS
	Character.Torso["Right Shoulder"].C0 = RS
	Character.HumanoidRootPart["RootJoint"].C0 = RoH
	Character.Torso["Neck"].C0 = N
end

function Main:Stop()
	self.played = true
end

-- Script setup and initialization
local animationplayer = Main

local LoadedAnimationTable = {}

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local RunService = game:GetService("RunService")

game.Players.LocalPlayer.Character.Archivable = true
local FakeCharacter = game.Players.LocalPlayer.Character:Clone()

Player.Character:BreakJoints()
Player.Character = nil

local Connection
Connection = game.Workspace.DescendantAdded:Connect(function(c)
	if c.Name == "Animate" and c.Parent == Player.Character then
		c.Enabled = false   
		Connection:Disconnect()
	end
end)

repeat task.wait() until game.Players.LocalPlayer.Character
task.wait(0.1)

local RealChar = Player.Character
RealChar.Archivable = true
FakeCharacter.Name = "non"
FakeCharacter.Parent = workspace

local rig = animationplayer.LoadDummy(FakeCharacter)

-- Sigma Sigma Ayo Kita Sigma
-- Bacot Jing

-- local track = rig:LoadAnimation("rbxassetid://17603135849")
-- coroutine.wrap(function()
--     track:Play()
-- end)()

task.spawn(function()
	for _, LS in ipairs(FakeCharacter:GetChildren()) do
		if LS:IsA("LocalScript") then
			LS.Enabled = false
			task.wait(0.1)
			LS.Enabled = false
		end
	end
end)

for _, Part in ipairs(FakeCharacter:GetDescendants()) do
	if Part:IsA("BasePart") then
		Part.Transparency = fake_transparency
	end
end

for _, Decal in ipairs(FakeCharacter:GetDescendants()) do
	if Decal:IsA("Decal") then
		Decal.Transparency = fake_transparency
	end
end

Player.Character = FakeCharacter

local function MotorAngle()
	if RealChar:FindFirstChild("Torso") then
		for MotorName, Motor6DAngle in pairs(Motors) do
			if RealChar:FindFirstChild("Torso"):FindFirstChild(MotorName) then
				RealChar:FindFirstChild("Torso"):FindFirstChild(MotorName).CurrentAngle = Motor6DAngle
			end
		end
	end
end

local function SetAngles()
	if FakeCharacter:FindFirstChild("Torso") then
		for MotorName, Motor6DAngle in pairs(Motors) do
			if FakeCharacter:FindFirstChild("Torso"):FindFirstChild(MotorName) then
				local Motor = FakeCharacter:FindFirstChild("Torso"):FindFirstChild(MotorName)
				local rx, ry, rz = Motor.Part1.CFrame:ToObjectSpace(FakeCharacter:FindFirstChild("Torso").CFrame):ToOrientation()
				if Motor.Name == "Right Shoulder" then
					Motors[MotorName] = -rx
				end
				if Motor.Name == "Left Shoulder" then
					Motors[MotorName] = rx
				end
				if Motor.Name == "Right Hip" then
					Motors[MotorName] = -rx
				end
				if Motor.Name == "Left Hip" then
					Motors[MotorName] = rx
				end
				if Motor.Name == "Neck" then
					Motors[MotorName] = -ry
				end
			end
		end
	end
end

local KFFolder = Instance.new("Folder")
KFFolder.Parent = game.ReplicatedStorage

--[[local function LoadAllAnimations()
	-- Assuming AnimIDs is a table containing animation IDs
	for _, AnimID in pairs(AnimIDs) do
		local Anim = Instance.new("Animation")
		Anim.AnimationId = "rbxassetid://" .. AnimID
		local LoadedAnim = RealChar:WaitForChild("Humanoid"):LoadAnimation(Anim)
	end]]

local function BaseCol()
	for _, Part in ipairs(RealChar:GetChildren()) do
		if Part:IsA("BasePart") then
			Part.CanCollide = false
		end
	end
    for _, Part in ipairs(FakeCharacter:GetChildren()) do
		if Part:IsA("BasePart") then
			Part.CanCollide = false
		end
	end
end

RunService.Heartbeat:Connect(function()
	SetAngles()
	MotorAngle()
	pcall(function()
	RealChar.HumanoidRootPart.CFrame = FakeCharacter.Torso.CFrame
	RealChar.HumanoidRootPart.Velocity = Vector3.new(0.1, 0.1, 0.1)
	RealChar.HumanoidRootPart.RotVelocity = Vector3.new(0.1, 0.1, 0.1)
	end)
end)




RunService.PreSimulation:Connect(function()
	BaseCol()
end)

print([[
___________________________________
  
Booty Offender // A Kyutatsuki13's script

SDA Reanim
  
___________________________________
]])

warn("You're whitelisted, "..game:GetService("Players").LocalPlayer.Name.." :)")

local p = game:GetService("Players").LocalPlayer 
local char = p.Character
local mouse = p:GetMouse()
local larm = char:WaitForChild("Left Arm")
local rarm = char:WaitForChild("Right Arm")
local lleg = char:WaitForChild("Left Leg")
local rleg = char:WaitForChild("Right Leg")
local hed = char:WaitForChild("Head")
local torso = char:WaitForChild("Torso")
local root = char:WaitForChild("HumanoidRootPart")
local hum = char:FindFirstChildOfClass("Humanoid")
local debris = game:GetService("Debris")
local input = game:GetService("UserInputService")
local run = game:GetService("RunService")
local rs = run.RenderStepped
local wingpose = "Idle"
local DebrisModel = Instance.new("Model",char)
DebrisModel.Name = "Debris"
repeat rs:wait() until p.CharacterAppearanceLoaded

noidle = false
shift = false
control = false

----------------------------------------------------------------------------

function rswait(value)
  if value ~= nil and value ~= 0 then
    for i=1,value do
     rs:wait()
    end
  else
    rs:wait()
  end
end

----------------------------------------------------------------------------

local timeposition = 0

function music(id)
if id == "Stop" then
if not torso:FindFirstChild("MusicRuin") then
soundz = Instance.new("Sound",torso)
end
soundz:Stop()
else
if not torso:FindFirstChild("MusicRuin") then
soundz = Instance.new("Sound",torso)
for i=1,2 do
local equalizer = Instance.new("EqualizerSoundEffect",soundz)
equalizer.HighGain = 6
equalizer.MidGain = 0
equalizer.LowGain = 6
end
end
soundz.Volume = 10
soundz.Name = "MusicRuin"
soundz.Looped = true
soundz.PlaybackSpeed = 1
soundz.SoundId = "rbxassetid://"..id
soundz:Stop()
soundz:Play()
end
end

----------------------------------------------------------------------------

function lerp(a, b, t)
  return a + (b - a)*t
end

----------------------------------------------------------------------------

function Lerp(c1,c2,al)
  local com1 = {c1.X,c1.Y,c1.Z,c1:toEulerAnglesXYZ()}
  local com2 = {c2.X,c2.Y,c2.Z,c2:toEulerAnglesXYZ()}
  for i,v in pairs(com1) do
    com1[i] = v+(com2[i]-v)*al
  end
  return CFrame.new(com1[1],com1[2],com1[3]) * CFrame.Angles(select(4,unpack(com1)))
end

----------------------------------------------------------------------------

function slerp(a, b, t)
  dot = a:Dot(b)
  if dot > 0.99999 or dot < -0.99999 then
    return t <= 0.5 and a or b
  else
    r = math.acos(dot)
    return (a*math.sin((1 - t)*r) + b*math.sin(t*r)) / math.sin(r)
  end
end

----------------------------------------------------------------------------

function clerp(c1,c2,al)

  local com1 = {c1.X,c1.Y,c1.Z,c1:toEulerAnglesXYZ()}

  local com2 = {c2.X,c2.Y,c2.Z,c2:toEulerAnglesXYZ()}

  for i,v in pairs(com1) do

    com1[i] = lerp(v,com2[i],al)

  end

  return CFrame.new(com1[1],com1[2],com1[3]) * CFrame.Angles(select(4,unpack(com1)))

end

----------------------------------------------------------------------------

function findAllNearestTorso(pos,dist)
    local list = workspace:children()
    local torso = {}
    local temp = nil
    local human = nil
    local temp2 = nil
    for x = 1, #list do
        temp2 = list[x]
        if (temp2.className == "Model") and (temp2 ~= char) then
            temp = temp2:findFirstChild("Torso")
            human = temp2:findFirstChildOfClass("Humanoid")
            if (temp ~= nil) and (human ~= nil) and (human.Health > 0) then
                if (temp.Position - pos).magnitude < dist then
                    table.insert(torso,temp)
                    dist = (temp.Position - pos).magnitude
                end
            end
        end
    end
    return torso
end

----------------------------------------------------------------------------

function checkIfNotPlayer(model)
if model.CanCollide == true and model ~= char and model.Parent ~= char and model.Parent.Parent ~= char and model.Parent.Parent ~= char and model.Parent ~= DebrisModel and model.Parent.Parent ~= DebrisModel and model.Parent.Parent.Parent ~= DebrisModel and model ~= wings and model.Parent ~= wings and model.Parent.Parent ~= wings then
return true
else
return false
end
end

----------------------------------------------------------------------------

function newWeld(wp0, wp1, wc0x, wc0y, wc0z)

  local wld = Instance.new("Weld", wp1)

  wld.Part0 = wp0

  wld.Part1 = wp1

  wld.C0 = CFrame.new(wc0x, wc0y, wc0z)

  return wld

end

function weld(model)
  local parts,last = {}
  local function scan(parent)
    for _,v in pairs(parent:GetChildren()) do
      if (v:IsA("BasePart")) then
        if (last) then
          local w = Instance.new("Weld")
          w.Name = ("%s_Weld"):format(v.Name)
          w.Part0,w.Part1 = last,v
          w.C0 = last.CFrame:inverse()
          w.C1 = v.CFrame:inverse()
          w.Parent = last
        end
        last = v
        table.insert(parts,v)
      end
      scan(v)
    end
  end
  scan(model)
  for _,v in pairs(parts) do
        v.Anchored = false
        v.Locked = true
        v.Anchored = false
        v.BackSurface = Enum.SurfaceType.SmoothNoOutlines
        v.BottomSurface = Enum.SurfaceType.SmoothNoOutlines
        v.FrontSurface = Enum.SurfaceType.SmoothNoOutlines
        v.LeftSurface = Enum.SurfaceType.SmoothNoOutlines
        v.RightSurface = Enum.SurfaceType.SmoothNoOutlines
        v.TopSurface = Enum.SurfaceType.SmoothNoOutlines
        v.CustomPhysicalProperties = PhysicalProperties.new(0,0,0)
  end
end

----------------------------------------------------------------------------

function calculate(part,asd)
local Head = hed
local RightShoulder = asd
local RightArm = part
local MousePosition = mouse.Hit.p
local ToMouse = (MousePosition - Head.Position).unit
local Angle = math.acos(ToMouse:Dot(Vector3.new(0, 1, 0)))
local FromRightArmPos = (Head.Position + Head.CFrame:vectorToWorldSpace(Vector3.new(((Head.Size.X / 2) + (RightArm.Size.X / 2)), ((Head.Size.Y / 2) - (RightArm.Size.Z / 2)), 0)))
local ToMouseRightArm = ((MousePosition - FromRightArmPos) * Vector3.new(1 ,0, 1)).unit
local Look = (Head.CFrame.lookVector * Vector3.new(1, 0, 1)).unit
local LateralAngle = math.acos(ToMouseRightArm:Dot(Look))
if tostring(LateralAngle) == "-1.#IND" then
LateralAngle = 0
end
local Cross = Head.CFrame.lookVector:Cross(ToMouseRightArm)
if LateralAngle > (math.pi / 2) then
LateralAngle = (math.pi / 2)
local Torso = root
local Point = Torso.CFrame:vectorToObjectSpace(mouse.Hit.p-Torso.CFrame.p)
if Point.Z > 0 then
if Point.X > -0 and RightArm == rarm then
Torso.CFrame = CFrame.new(Torso.Position,Vector3.new(mouse.Hit.X,Torso.Position.Y,mouse.Hit.Z))*CFrame.Angles(0,math.rad(110),0)
elseif Point.X < 0 and RightArm == rarm then
Torso.CFrame = CFrame.new(Torso.Position,Vector3.new(mouse.Hit.X,Torso.Position.Y,mouse.Hit.Z))*CFrame.Angles(0,math.rad(-110),0)
end
end
end
if Cross.Y < 0 then
LateralAngle = -LateralAngle
end
return(CFrame.Angles(((math.pi / 2) - Angle), ((math.pi / 2) + LateralAngle), math.pi/2))
end

----------------------------------------------------------------------------

function sound(id,position,vol,pitch,start,finish)
  coroutine.resume(coroutine.create(function()

  local part = Instance.new("Part",workspace)
  part.Position = position
  part.Size = Vector3.new(0,0,0)
  part.CanCollide = false
  part.Transparency = 1

  local sound = Instance.new("Sound",part)

  sound.SoundId = "rbxassetid://"..id

  repeat rs:wait() until sound.IsLoaded
  
  if vol ~= nil then
    sound.Volume = vol
  end

  if pitch ~= nil then
    sound.PlaybackSpeed = pitch
  end

  if start ~= nil then
    sound.TimePosition = start
  end

  if finish ~= nil then
    debris:AddItem(part,finish-start)
  else
    debris:AddItem(part,sound.TimeLength)
  end
  
  sound:Play()  

  return sound

  end))
end

----------------------------------------------------------------------------

function computeDirection(vec)
local lenSquared = vec.magnitude * vec.magnitude
local invSqrt = 1 / math.sqrt(lenSquared)
return Vector3.new(vec.x * invSqrt, vec.y * invSqrt, vec.z * invSqrt)
end

----------------------------------------------------------------------------

local shaking = 0
function shake(num) if num > shaking then shaking = num end end
game:GetService("RunService").RenderStepped:connect(function()
hum.CameraOffset = Vector3.new(math.random(-1,1),math.random(-1,1),math.random(-1,1))*(shaking/100)
if shaking > 0 then shaking = shaking - 1 else shaking = 0 end
end)

plr = game:GetService("Players").LocalPlayer
DebrisModel = Instance.new("Model",plr.Character)
DebrisModel.Name = "DebrisModel"

function Effect(mesh,size,transparency,material,color,position,rotation,positionchange,sizechange,rotationchange,transparencychange,acceleration)
 
 local part = Instance.new("Part",DebrisModel)
  part.Anchored = true
  part.CanCollide = false
  part.Size = Vector3.new(1,1,1)
  part.Transparency = transparency
  part.Material = material
  part.Color = color
  part.CFrame = CFrame.new(position)*CFrame.Angles(math.rad(rotation.X),math.rad(rotation.Y),math.rad(rotation.Z))

 local partmesh = Instance.new("SpecialMesh",part)
  if tonumber(mesh) == nil then partmesh.MeshType = mesh else partmesh.MeshId = "rbxassetid://"..mesh end
  partmesh.Scale = size

 local pvalue = Instance.new("Vector3Value",part)
  pvalue.Name = "Position"
  pvalue.Value = positionchange

 local svalue = Instance.new("Vector3Value",part)
  svalue.Name = "Size"
  svalue.Value = sizechange

 local rvalue = Instance.new("Vector3Value",part)
  rvalue.Name = "Rotation"
  rvalue.Value = rotationchange
  
 local tvalue = Instance.new("NumberValue",part)
  tvalue.Name = "Transparency"
  tvalue.Value = transparencychange

 local avalue = Instance.new("NumberValue",part)
  avalue.Name = "Acceleration"
  avalue.Value = acceleration
 
 part.Name = "EFFECT"
 
 return part

end

game:GetService("RunService").RenderStepped:connect(function()
coroutine.resume(coroutine.create(function()

 for i, v in pairs(DebrisModel:GetChildren()) do
  if v:isA("BasePart") then
   v.LocalTransparencyModifier = 0
  end
 end

 if not plr.Character:FindFirstChild("DebrisModel") then
  DebrisModel = Instance.new("Model",plr.Character)
  DebrisModel.Name = "DebrisModel"
 end

 for i,v in pairs(DebrisModel:GetChildren()) do
  if v:IsA("BasePart") and v.Name == "EFFECT" then
   local pvalue = v:FindFirstChild("Position").Value
   local svalue = v:FindFirstChild("Size").Value
   local rvalue = v:FindFirstChild("Rotation").Value
   local tvalue = v:FindFirstChild("Transparency").Value
   local avalue = v:FindFirstChild("Acceleration").Value
   local mesh = v:FindFirstChild("Mesh")
   mesh.Scale = mesh.Scale + svalue
   v:FindFirstChild("Size").Value = v:FindFirstChild("Size").Value + (Vector3.new(1,1,1)*avalue)
   v.Transparency = v.Transparency + tvalue
   v.CFrame = CFrame.new(pvalue)*v.CFrame*CFrame.Angles(math.rad(rvalue.X),math.rad(rvalue.Y),math.rad(rvalue.Z))
   if v.Transparency >= 1 or mesh.Scale.X < 0 or mesh.Scale.Y < 0 or mesh.Scale.Z < 0 then
     v:Destroy()
   end
  end
 end

end))
end)

local wsback = 0
local frozen = false
function freeze()
if frozen == false then
frozen = true
wsback = hum.WalkSpeed
hum.WalkSpeed = 1
else
frozen = false
hum.WalkSpeed = wsback
end
end
hum.WalkSpeed = 25

function Lightning(Part0,Part1,Times,Offset,Color,Thickness,Trans)
    local magz = (Part0 - Part1).magnitude
    local curpos = Part0
    local trz = {-Offset,Offset} 
    for i=1,Times do
        local li = Instance.new("Part", DebrisModel)
        li.TopSurface =0
        li.Material = Enum.Material.Neon
        li.BottomSurface = 0
        li.Anchored = true
        li.Locked = true
        li.Transparency = Trans or 0.4
        li.Color = Color
        li.formFactor = "Custom"
        li.CanCollide = false
        li.Size = Vector3.new(Thickness,Thickness,magz/Times)
        local lim = Instance.new("BlockMesh",li)
        local Offzet = Vector3.new(trz[math.random(1,2)],trz[math.random(1,2)],trz[math.random(1,2)])
        local trolpos = CFrame.new(curpos,Part1)*CFrame.new(0,0,magz/Times).p+Offzet
        if Times == i then
        local magz2 = (curpos - Part1).magnitude
        li.Size = Vector3.new(Thickness,Thickness,magz2)
        li.CFrame = CFrame.new(curpos,Part1)*CFrame.new(0,0,-magz2/2)
        else
        li.CFrame = CFrame.new(curpos,trolpos)*CFrame.new(0,0,magz/Times/2)
        end
        curpos = li.CFrame*CFrame.new(0,0,magz/Times/2).p
        li.Name = "LIGHTNING"
    end
end

----------------------------------------------------------------------------
skin_color = BrickColor.new("Light orange")
--p:ClearCharacterAppearance()
--hed:WaitForChild("face"):Destroy()
hed:WaitForChild("face").Texture = "rbxassetid://407320095"
----------------------------------------------------------------------------
local size = 1

newWeld(torso, larm, -1.5, 0.5, 0)
larm.Weld.C1 = CFrame.new(0, 0.5, 0)
newWeld(torso, rarm, 1.5, 0.5, 0)
rarm.Weld.C1 = CFrame.new(0, 0.5, 0)
newWeld(torso, hed, 0, 1.5, 0)
newWeld(torso, lleg, -0.5, -1, 0)
lleg.Weld.C1 = CFrame.new(0, 1, 0)
newWeld(torso, rleg, 0.5, -1, 0)
rleg.Weld.C1 = CFrame.new(0, 1, 0)
newWeld(root, torso, 0, -1, 0)
torso.Weld.C1 = CFrame.new(0, -1, 0)

emitters={}

----------------------------------------------------------------------------------------
music(288494027)
velocityYFall=0
velocityYFall2=0
velocityYFall3=0
velocityYFall4=0
neckrotY=0
neckrotY2=0
torsorotY=0
torsorotY2=0
torsoY=0
torsoY2=0
colored = 0
sine = 0
change=0.4
movement=10
timeranim=0
running = false
jumped = false
icolor=1
imode=false

didjump = false
jumppower = 0
debounceimpact = false

function jumpimpact()
if debounceimpact == false then
debounceimpact = true
if jumppower < -150 then jumppower = -150 end
shake(-jumppower/5)
for i=1,-jumppower/20 do rs:wait()
hed.Weld.C1 = Lerp(hed.Weld.C1, CFrame.Angles(0,0,0), 0.05)
torso.Weld.C0 = Lerp(torso.Weld.C0, CFrame.new(0, (jumppower/20)-hum.HipHeight, 0) * CFrame.Angles(math.rad(0),math.rad(0), math.rad(0)), 0.05)
end
debounceimpact = false
end
end

max = 0

rs:connect(function()

for i,v in pairs(DebrisModel:GetChildren()) do
if v.Name == "LIGHTNING" then
local vm = v:FindFirstChildOfClass("BlockMesh")
vm.Scale = vm.Scale - Vector3.new(0.1,0.1,0)
if vm.Scale.X <= 0 then
v:Destroy()
end
end
end

if p.Character.Parent == nil then
local model = Instance.new("Model")
model.Name = p.Name
p.Character = model
for i,v in pairs(char:GetChildren()) do
v.Parent = p.Character
end
end

char = p.Character
if p.Character.Parent ~= workspace then
p.Character.Parent = workspace
end
for i,v in pairs(char:GetChildren()) do
if v:IsA("Accoutrement") then
if v.Handle:FindFirstChild("Mesh") then
v.Handle:FindFirstChild("Mesh").Offset = Vector3.new()
v.Handle.Transparency = 0
end
elseif v:IsA("BasePart") then
v.Anchored = false
if v:FindFirstChildOfClass("BodyPosition") then
v:FindFirstChildOfClass("BodyPosition"):Destroy()
end
if v:FindFirstChildOfClass("BodyVelocity") then
v:FindFirstChildOfClass("BodyVelocity"):Destroy()
end
if v:FindFirstChildOfClass("BodyGyro") and v:FindFirstChildOfClass("BodyGyro").Name ~= "lolnochara" then
v:FindFirstChildOfClass("BodyGyro"):Destroy()
end
if v:FindFirstChild("Mesh") then
v:FindFirstChild("Mesh").Offset = Vector3.new()
end
if not DebrisModel:FindFirstChild(v.Name.."FORCEFIELD") then
local force = Instance.new("Part",DebrisModel)
force.Name = v.Name.."FORCEFIELD"
if v ~= hed then
force.Size = v.Size+(Vector3.new(1,1,1)*0.2)
else
force.Size = (Vector3.new(1,1,1)*v.Size.Y)+(Vector3.new(1,1,1)*0.2)
end
force.CanCollide = false
force.Transparency = 1
force.Color = Color3.new(0,1,1)
force.Material = Enum.Material.Neon
newWeld(v,force,0,0,0)
else
if not DebrisModel:FindFirstChild(v.Name.."FORCEFIELD"):FindFirstChildOfClass("Weld") then
newWeld(v,DebrisModel:FindFirstChild(v.Name.."FORCEFIELD"),0,0,0)
end
end
if v.Name ~= "HumanoidRootPart" then
v.Transparency = 0
else
v.Transparency = 1
end
end
end

if -root.Velocity.Y/1.5 > -5 and -root.Velocity.Y/1.5 < 150 then
velocityYFall = root.Velocity.Y/1.5
else
if -root.Velocity.Y/1.5 < -5 then
velocityYFall = 5
elseif -root.Velocity.Y/1.5 > 150 then
velocityYFall = -150
end
end

if -root.Velocity.Y/180 > 0 and -root.Velocity.Y/180 < 1.2 then
velocityYFall2 = root.Velocity.Y/180
else
if -root.Velocity.Y/180 < 0 then
velocityYFall2 = 0
elseif -root.Velocity.Y/180 > 1.2 then
velocityYFall2 = -1.2
end
end

if -root.Velocity.Y/1.5 > -5 and -root.Velocity.Y/1.5 < 50 then
velocityYFall3 = root.Velocity.Y/1.5
else
if -root.Velocity.Y/1.5 < -5 then
velocityYFall3 = 5
elseif -root.Velocity.Y/1.5 > 50 then
velocityYFall3 = -50
end
end

if -root.Velocity.Y/1.5 > -50 and -root.Velocity.Y/1.5 < 20 then
velocityYFall4 = root.Velocity.Y/1.5
else
if -root.Velocity.Y/180 < -5 then
velocityYFall4 = 5
elseif -root.Velocity.Y/180 > 50 then
velocityYFall4 = -50
end
end

if root.RotVelocity.Y/6 < 1 and root.RotVelocity.Y/6 > -1 then
neckrotY = root.RotVelocity.Y/6
else
if root.RotVelocity.Y/6 < -1 then
neckrotY = -1
elseif root.RotVelocity.Y/6 > 1 then
neckrotY = 1
end
end

if root.RotVelocity.Y/8 < 0.6 and root.RotVelocity.Y/8 > -0.6 then
neckrotY2 = root.RotVelocity.Y/8
else
if root.RotVelocity.Y/8 < -0.6 then
neckrotY2 = -0.6
elseif root.RotVelocity.Y/8 > 0.6 then
neckrotY2 = 0.6
end
end

if root.RotVelocity.Y/6 < 0.2 and root.RotVelocity.Y/6 > -0.2 then
torsorotY = root.RotVelocity.Y/6
else
if root.RotVelocity.Y/6 < -0.2 then
torsorotY = -0.2
elseif root.RotVelocity.Y/6 > 0.2 then
torsorotY = 0.2
end
end

if root.RotVelocity.Y/8 < 0.2 and root.RotVelocity.Y/8 > -0.2 then
torsorotY2 = root.RotVelocity.Y/8
else
if root.RotVelocity.Y/8 < -0.2 then
torsorotY2 = -0.2
elseif root.RotVelocity.Y/8 > 0.2 then
torsorotY2 = 0.2
end
end

torsoY = -(torso.Velocity*Vector3.new(1, 0, 1)).magnitude/20
torsoY2 = -(torso.Velocity*Vector3.new(1, 0, 1)).magnitude/36

local ray1 = Ray.new(root.Position+Vector3.new(size,0,0),Vector3.new(0, -4, 0))
local part1, endPoint = workspace:FindPartOnRay(ray1, char)

local ray2 = Ray.new(root.Position-Vector3.new(size,0,0),Vector3.new(0, -4, 0))
local part2, endPoint = workspace:FindPartOnRay(ray2, char)

local ray3 = Ray.new(root.Position+Vector3.new(0,0,size/2),Vector3.new(0, -4, 0))
local part3, endPoint = workspace:FindPartOnRay(ray3, char)

local ray4 = Ray.new(root.Position-Vector3.new(0,0,size/2),Vector3.new(0, -4, 0))
local part4, endPoint = workspace:FindPartOnRay(ray4, char)

local ray5 = Ray.new(root.Position+Vector3.new(size,0,size/2),Vector3.new(0, -4, 0))
local part5, endPoint = workspace:FindPartOnRay(ray5, char)

local ray6 = Ray.new(root.Position-Vector3.new(size,0,size/2),Vector3.new(0, -4, 0))
local part6, endPoint = workspace:FindPartOnRay(ray6, char)

local ray7 = Ray.new(root.Position+Vector3.new(size,0,-size/2),Vector3.new(0, -4, 0))
local part7, endPoint = workspace:FindPartOnRay(ray7, char)

local ray8 = Ray.new(root.Position-Vector3.new(size,0,-size/2),Vector3.new(0, -4, 0))
local part8, endPoint = workspace:FindPartOnRay(ray8, char)

local ray = Ray.new(root.Position,Vector3.new(0, -6, 0))
local part, endPoint = workspace:FindPartOnRay(ray, char)

if part1 or part2 or part3 or part4 or part5 or part6 or part7 or part8 then jumped = false else endPoint = 0 jumped = true end

local rlegray = Ray.new(rleg.Position+Vector3.new(0,size/2,0),Vector3.new(0, -1.75, 0))
local rlegpart, rlegendPoint = workspace:FindPartOnRay(rlegray, char)

local llegray = Ray.new(lleg.Position+Vector3.new(0,size/2,0),Vector3.new(0, -1.75, 0))
local llegpart, llegendPoint = workspace:FindPartOnRay(llegray, char)

if hum.Health > 0 and noidle == false then
if hum.Sit == false then
if (torso.Velocity*Vector3.new(1, 0, 1)).magnitude >= 5 and jumped == false then
hed.Weld.C0 = Lerp(hed.Weld.C0, CFrame.new(0, 1.5, -.2) * CFrame.Angles(math.rad((torso.Velocity*Vector3.new(1, 0, 1)).magnitude/35),torsorotY, math.rad(0)+torsorotY), 0.4)
hed.Weld.C1 = Lerp(hed.Weld.C1, CFrame.Angles((change/10)*math.cos(sine/2)+0.1,-(change/10)*math.cos(sine/4)-(torsorotY/5),(change/5)*math.cos(sine/4)), 0.1)
rarm.Weld.C0 = Lerp(rarm.Weld.C0, CFrame.new(1.5,0.62-(movement/40)*math.cos(sine/4)/3,(movement/150)+(movement/40)*math.cos(sine/4))*CFrame.Angles(math.rad(-5-(movement*2)*math.cos(sine/4))+ -(movement/10)*math.sin(sine/4)*2,math.rad(0-(movement*2)*math.cos(sine/4)),math.rad(0)), 0.2)
larm.Weld.C0 = Lerp(larm.Weld.C0, CFrame.new(-1.5,0.62+(movement/40)*math.cos(sine/4)/3,(movement/150)-(movement/40)*math.cos(sine/4))*CFrame.Angles(math.rad(-5+(movement*2)*math.cos(sine/4))+ (movement/10)*math.sin(sine/4)*2,math.rad(0-(movement*2)*math.cos(sine/4)),math.rad(0)), 0.2)
torso.Weld.C0 = Lerp(torso.Weld.C0, CFrame.new(0, -0.5+(change*2)*math.sin(sine/2), 0) * CFrame.Angles(math.rad(30+(change*20)-(movement/20)*math.cos(sine/2)), torsorotY2+math.rad(0-20*math.sin(sine/4)), torsorotY2+math.rad(0-1*math.cos(sine/4))), 0.1)
lleg.Weld.C0 = Lerp(lleg.Weld.C0, CFrame.new(-0.5,(-0.85-(movement/15)*math.cos(sine/4)/2),-0.1+(movement/15)*math.cos(sine/4))*CFrame.Angles(math.rad(-50+(change*5)-movement*math.cos(sine/4))+ -(movement/10)*math.sin(sine/4),math.rad(0+(movement*2)*math.cos(sine/4)),math.rad(0)), 0.2)
rleg.Weld.C0 = Lerp(rleg.Weld.C0, CFrame.new(0.5,(-0.85+(movement/15)*math.cos(sine/4)/2),-0.1-(movement/15)*math.cos(sine/4))*CFrame.Angles(math.rad(-50+(change*5)+movement*math.cos(sine/4))+ (movement/10)*math.sin(sine/4),math.rad(0+(movement*2)*math.cos(sine/4)),math.rad(0)), 0.2)
elseif jumped == true then
didjump = true
jumppower = root.Velocity.Y
hed.Weld.C0 = Lerp(hed.Weld.C0, CFrame.new(0, 1.5, -.1) * CFrame.Angles(0,0,0), 0.4)
hed.Weld.C1 = Lerp(hed.Weld.C1, CFrame.Angles(0,0,0), 0.1)
larm.Weld.C0 = Lerp(larm.Weld.C0, CFrame.new(-1.5,0.55,0) * CFrame.Angles(math.rad(0),math.rad(0), math.rad(0)), 0.1)
rarm.Weld.C0 = Lerp(rarm.Weld.C0, CFrame.new(1.5,0.55,0) * CFrame.Angles(math.rad(0),math.rad(0), math.rad(0)), 0.1)
torso.Weld.C0 = CFrame.new(0, -1, 0) * CFrame.Angles(math.rad(math.random(-90,90)),math.rad(0), math.rad(math.random(-180,180)))
lleg.Weld.C0 = Lerp(lleg.Weld.C0, CFrame.new(-0.5,-0.925,0) * CFrame.Angles(math.rad(0),math.rad(0), math.rad(0)), 0.1)
rleg.Weld.C0 = Lerp(rleg.Weld.C0, CFrame.new(0.5,0,-0.8) * CFrame.Angles(math.rad(0),math.rad(0), math.rad(0)), 0.1)
elseif (torso.Velocity*Vector3.new(1, 0, 1)).magnitude < 5 then
hed.Weld.C0 = Lerp(hed.Weld.C0, CFrame.new(0, 1.5, -.1), 0.4)
hed.Weld.C1 = Lerp(hed.Weld.C1, CFrame.Angles(math.rad(0+50*math.sin(sine/4)),0,0), 0.1)
larm.Weld.C0 = Lerp(larm.Weld.C0, CFrame.new(-1.5,0.55,-0.05-0.2*math.cos(sine/4))*CFrame.Angles(math.rad(0+80*math.sin(sine/4)),math.rad(-5-5*math.sin(sine/8)),math.rad(-6+2*math.cos(sine/8))), 0.2)
rarm.Weld.C0 = Lerp(rarm.Weld.C0, CFrame.new(1.5,0.55,-0.05-0.2*math.cos(sine/4))*CFrame.Angles(math.rad(0+80*math.sin(sine/4)),math.rad(5+5*math.sin(sine/8)),math.rad(6-2*math.cos(sine/8))), 0.2)
torso.Weld.C0 = Lerp(torso.Weld.C0, CFrame.new(0, -1.1-hum.HipHeight, 0+2*math.cos(sine/4)) * CFrame.Angles(math.rad(0-80*math.cos(sine/4)),math.rad(0), math.rad(0-1*math.cos(sine/32))), 0.1)
lleg.Weld.C0 = Lerp(lleg.Weld.C0, CFrame.new(0,llegendPoint.Y-lleg.Position.Y,0)*CFrame.new(-0.5,0,0)*CFrame.Angles(math.rad(0+120*math.cos(sine/4)),math.rad(10),math.rad(-5+1*math.cos(sine/16))), 0.1)
rleg.Weld.C0 = Lerp(rleg.Weld.C0, CFrame.new(0,rlegendPoint.Y-rleg.Position.Y,0)*CFrame.new(0.5,0,0)*CFrame.Angles(math.rad(0+120*math.cos(sine/4)),math.rad(-10),math.rad(5+1*math.cos(sine/16))), 0.1)
end

else
hed.Weld.C0 = Lerp(hed.Weld.C0, CFrame.new(0, 1.5, -.1), 0.4)
hed.Weld.C1 = Lerp(hed.Weld.C1, CFrame.Angles(0.05*math.sin(sine/16)+0.15,0.05*math.cos(sine/32),0.01*math.cos(sine/32)), 0.1)
larm.Weld.C0 = Lerp(larm.Weld.C0, CFrame.new(-1.5,0.55-(0.1)*math.cos(sine/16)/3,-0.05-0.1*math.cos(sine/16))*CFrame.Angles(math.rad(-2+4*math.sin(sine/16)),math.rad(-5-5*math.sin(sine/16)),math.rad(-6+2*math.cos(sine/16))), 0.2)
rarm.Weld.C0 = Lerp(rarm.Weld.C0, CFrame.new(1.5,0.55-(0.1)*math.cos(sine/16)/3,-0.05-0.1*math.cos(sine/16))*CFrame.Angles(math.rad(-2+4*math.sin(sine/16)),math.rad(5+5*math.sin(sine/16)),math.rad(6-2*math.cos(sine/16))), 0.2)
torso.Weld.C0 = Lerp(torso.Weld.C0, CFrame.new(0, -1.4-(0.1)*math.cos(sine/16)-hum.HipHeight, 0) * CFrame.Angles(math.rad(0-2*math.cos(sine/16)),math.rad(0), math.rad(0-1*math.cos(sine/32))), 0.1)
lleg.Weld.C0 = Lerp(lleg.Weld.C0, CFrame.new(-0.5,-0.55+(0.1)*math.cos(sine/16),0)*CFrame.Angles(math.rad(80+2*math.cos(sine/16)),math.rad(4),math.rad(-2+1*math.cos(sine/32))), 0.2)
rleg.Weld.C0 = Lerp(rleg.Weld.C0, CFrame.new(0.5,-0.55+(0.1)*math.cos(sine/16),0)*CFrame.Angles(math.rad(80+2*math.cos(sine/16)),math.rad(-4),math.rad(2+1*math.cos(sine/32))), 0.2)
end

end
if didjump == true and jumped == false and jumppower < 0 then
didjump = false
jumpimpact()
end

sine = sine + change
hum.Health = math.huge
hum.MaxHealth = math.huge
end)


-- CamFix --
local p = game.Players.LocalPlayer
repeat wait() until p.Character
local cam = workspace.CurrentCamera
cam.CameraSubject = p.Character:FindFirstChildWhichIsA("Humanoid")
cam.CameraType = Enum.CameraType.Custom
p.CameraMinZoomDistance = 0.5
p.CameraMaxZoomDistance = 400
p.CameraMode = Enum.CameraMode.Classic
