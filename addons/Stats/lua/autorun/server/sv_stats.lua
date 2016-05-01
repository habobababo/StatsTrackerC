
require( "mysqloo" )

local DATABASE_HOST = "127.0.0.1"
local DATABASE_PORT = 3306
local DATABASE_NAME = "global"
local DATABASE_USERNAME = ""
local DATABASE_PASSWORD = ""

local function ConnectToDatabase()

	database = mysqloo.connect(DATABASE_HOST, DATABASE_USERNAME, DATABASE_PASSWORD, DATABASE_NAME, DATABASE_PORT)
	
	function database:onConnected()
		print("\n*** Connectet to Mysql Database ***") 
		print("Host Info:", database:hostInfo() )
		print("\n")
	end

	function database:onConnectionFailed( err )
		print( "Connection to database failed!" )
		print( "Error:", err )
	end
	
	database:connect()
	
	timer.Simple(1, function() hook.Call("DatabaseLoaded") end)
end
hook.Add("Initialize", "Initialize_databse", ConnectToDatabase)

function statquery(querystr, callback)
	if !querystr then print("Querystr failed") return end
	if !database then ConnectToDatabase(); timer.Simple(1.5, function() statquery(querystr, callback); print("Database failed") end) end

	local status = database:status()
	if status == 2 or status == 3 then
		print("Status Failed")
		return
	end
	
	local Query = database:query(querystr)
	
	if Query == nil then timer.Simple(1, function() statquery(querystr, callback); print("Query Failed... retrying") end) return end
	
	function Query.onSuccess( userdata )
		if callback then
			callback(Query:getData()) 
		end
	end
 
    function Query:onError( err, sql )
        print( "Query errored!" )
        print( "Query:", sql )
        print( "Error:", err )
    end
 
    Query:start()
end


local function Stats(ply)

		local plyname = ply:Nick()
		local steamid = ply:SteamID64()
		local uid = ply:UniqueID()
		local UG = ply:GetUserGroup()
		local NW = ply:GetNWString("usergroup")
		
		statquery("SELECT * FROM users WHERE steamid = '"..ply:SteamID64().."' ", function(data)
			if data[1] != nil then
					if !IsValid(ply) then return end
					statquery("UPDATE `users` SET `name` = '"..plyname.."', `UG` = '"..UG.."', `NW` = '"..NW.."' WHERE `steamid` = '"..ply:SteamID64().."'  ")
			else
				statquery("INSERT INTO users (steamid, uid, UG, NW, name) VALUES ('"..steamid.."', '"..uid.."', '"..UG.."', '"..NW.."', '"..plyname.."') ")
			end
		end)
end
hook.Add("PlayerInitialSpawn", "StatsTracking",  Stats)


