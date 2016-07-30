
local function Stats(ply)

		local plyname = ply:Nick()
		local steamid = ply:SteamID64()
		local uid = ply:UniqueID()
		local UG = ply:GetUserGroup()
		local NW = ply:GetNWString("usergroup")
		if ply:IsBot() then return end
		
		corequery("SELECT * FROM users WHERE steamid = '"..ply:SteamID64().."' ", function(data)
			if data[1] != nil then
					if !IsValid(ply) then return end
					corequery("UPDATE `users` SET `name` = '"..plyname.."', `UG` = '"..UG.."', `NW` = '"..NW.."' WHERE `steamid` = '"..ply:SteamID64().."'  ")
			else
				corequery("INSERT INTO users (steamid, uid, UG, NW, name) VALUES ('"..steamid.."', '"..uid.."', '"..UG.."', '"..NW.."', '"..plyname.."') ")
			end
		end)
end
hook.Add("PlayerInitialSpawn", "StatsTracking",  Stats)
