local module = {}
local raycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Whitelist
raycastParams.FilterDescendantsInstances = {workspace.MapMain, workspace.Spawn, workspace.Lobby, workspace.Sprays}

function module:LineBetweenPoints(PointA, PointB)
	if typeof(PointA) == typeof(PointB) and (typeof(PointA) == "CFrame" or typeof(PointA) == "Vector3") then
		if typeof(PointA) == "CFrame" then
			PointA = PointA.Position
			PointB = PointB.Position
		end
		local Part = Instance.new("Part")
		
		Part.CFrame = CFrame.new(PointA:lerp(PointB, 0.5), PointB)
		Part.Size = Vector3.new(0.5,0.5,(PointA - PointB).magnitude - 2.5)
		Part.Anchored = true
		Part.Parent = workspace
		return Part
	else
		error("Both classes must match and be a Vector of any sort!")
	end
end

function module:Raycast(PointA, PointB)
	if (typeof(PointA) == "CFrame" or typeof(PointA) == "Vector3") then
		if typeof(PointA) == "CFrame" then
			PointA = PointA.Position
		end
		for _,v in pairs(game.Players:GetPlayers()) do
			if v ~= game.Players.LocalPlayer and v.Character then
				table.insert(raycastParams.FilterDescendantsInstances, v.Character)
			end
		end
		local Result = workspace:Raycast(PointA, (PointB.Position - PointA).unit * 2000, raycastParams)
		raycastParams.FilterDescendantsInstances = {workspace.MapMain, workspace.Spawn, workspace.Lobby}
		return Result or {}
	else
		error("Both classes must match and be a Vector of any sort!")
	end
end

function module:Shoot(Target, Offset)
	game.Players.LocalPlayer.Character.Revolver.ClientEvent:FireServer("WeaponFired", {game.Players.LocalPlayer.Character.Head.Position + Offset,Target.Head.Position,{["hitOffset"] = CFrame.new(),["fireOffset"] = CFrame.new(),},1})
	game:GetService("ReplicatedStorage").GameEvents.Gameplay.DamageRequest:FireServer({["attackID"] = 1,["IsHeadshot"] = true,["WeaponSkin"] = "BruhTime",["TargetCharacter"] = Target,["DamageType"] = "Knife",["Damage"] = 100})
end

return module
