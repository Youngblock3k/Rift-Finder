local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")

local webhook = "https://discord.com/api/webhooks/YOUR_WEBHOOK_HERE" -- 🔁 replace this

-- 🔍 Chat detection: only this line for bruh egg
local BRUH_TRIGGER = "yo we are invading now"

-- 🧠 Moves player from Zen → Bottom
local function goToBottom()
	local char = LocalPlayer.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end

	print("[RIFT DEBUG] 🚶 Moving player to bottom from Zen...")
	char:PivotTo(CFrame.new(0, 400, 0)) -- midway
	task.wait(0.8)
	char:PivotTo(CFrame.new(0, 10, 0)) -- bottom
end

-- 🌀 Scan workspace for rift models
local function scanAndSendRift(riftType, displayName)
	goToBottom()
	task.wait(1.5) -- let things load

	local foundModel = nil
	for _, obj in pairs(workspace:GetDescendants()) do
		if obj:IsA("Model") and obj.Name:lower():find(riftType) then
			foundModel = obj
			break
		end
	end

	if foundModel then
		local multiplier = foundModel:FindFirstChild("Multiplier") and foundModel.Multiplier.Value or "?"
		local timeLeft = foundModel:FindFirstChild("Timer") and foundModel.Timer.Value or "?"

		local embed = {
			["title"] = "🔥 **Bruh Egg Rift Detected!**",
			["color"] = 0xFF5500,
			["fields"] = {
				{ name = "Type", value = displayName, inline = true },
				{ name = "Multiplier", value = "x" .. multiplier, inline = true },
				{ name = "Time Left", value = timeLeft .. " sec", inline = true },
				{ name = "Join Server", value = "[Click to Join](roblox://placeId=17090340993)", inline = false }
			},
			["timestamp"] = DateTime.now():ToIsoDate()
		}

		local payload = { embeds = { embed } }
		local success, err = pcall(function()
			HttpService:PostAsync(webhook, HttpService:JSONEncode(payload), Enum.HttpContentType.ApplicationJson)
		end)

		if success then
			print("[RIFT DEBUG] ✅ Sent Bruh Egg Rift to Discord!")
		else
			print("[RIFT DEBUG] ❌ Failed to send Rift: " .. tostring(err))
		end
	else
		print("[RIFT DEBUG] ❌ No rift model found in workspace.")
	end
end

-- 🧏 Chat message listener
local function onChatMessage(msg)
	if msg:lower() == BRUH_TRIGGER then
		print("[RIFT DEBUG] 🧠 Detected Bruh Egg message!")
		scanAndSendRift("bruh", "Bruh Egg")
	end
end

-- 🔁 Start chat monitoring
print("✅ Chat Monitor for Bruh Egg Ready.")
for _, p in ipairs(Players:GetPlayers()) do
	p.Chatted:Connect(onChatMessage)
end

Players.PlayerAdded:Connect(function(p)
	p.Chatted:Connect(onChatMessage)
end)
