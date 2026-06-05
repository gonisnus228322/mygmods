if CLIENT then return end

util.AddNetworkString("homelander_request_sv_cvars")
util.AddNetworkString("homelander_send_cvars_to_client")
util.AddNetworkString("homelander_send_sv_cvar")

local HOMELANDER_SERVER_CONVARS = {}

local function createHomelanderServerConVar(name, default, help, minValue, maxValue)
    HOMELANDER_SERVER_CONVARS[name] = {
        default = default,
        min = minValue,
        max = maxValue
    }

    if not ConVarExists(name) then
        CreateConVar(name, tostring(default), { FCVAR_ARCHIVE, FCVAR_NOTIFY }, help, minValue, maxValue)
    end
end

createHomelanderServerConVar("homelander_sv_normal_punch_damage", "80", "Damage dealt by the direct normal punch hit.", 0, 50000)
createHomelanderServerConVar("homelander_sv_strong_punch_damage", "1000", "Damage dealt by the direct strong punch hit.", 0, 50000)
createHomelanderServerConVar("homelander_sv_strong_punch_shockwave_damage", "250", "Damage dealt to entities inside the strong punch area.", 0, 50000)
createHomelanderServerConVar("homelander_sv_strong_punch_shockwave_radius", "50", "Area radius for strong punch damage and push.", 0, 3000)
createHomelanderServerConVar("homelander_sv_strong_punch_shockwave_force", "32000", "Physics force applied by the strong punch area.", 0, 250000)
createHomelanderServerConVar("homelander_sv_strong_punch_prop_destroy_radius", "200", "Props inside this radius are directly damaged/destroyed.", 0, 1500)
createHomelanderServerConVar("homelander_sv_strong_punch_prop_scatter_radius", "400", "Props inside this radius are unfrozen and pushed.", 0, 2500)
createHomelanderServerConVar("homelander_sv_strong_punch_prop_scatter_force", "27200", "Force used when scattering props from strong punch impact.", 0, 250000)
createHomelanderServerConVar("homelander_sv_strong_punch_prop_damage", "2500", "Damage applied to breakable props near strong punch impact.", 0, 50000)

createHomelanderServerConVar("homelander_sv_laser_damage", "100", "Base damage dealt by heat vision laser hits.", 1, 100000)
createHomelanderServerConVar("homelander_sv_laser_penetration_enabled", "1", "Allow heat vision to burn through entities and thin world surfaces.", 0, 1)
createHomelanderServerConVar("homelander_sv_laser_entity_penetrations", "24", "How many entities heat vision can burn through before stopping.", 0, 32)
createHomelanderServerConVar("homelander_sv_laser_world_thickness", "32", "Maximum world surface thickness heat vision can burn through, in source units.", 0, 256)
createHomelanderServerConVar("homelander_sv_dismember_debug", "0", "Print Homelander laser dismember debug events.", 0, 1)

createHomelanderServerConVar("homelander_sv_flight_damage", "1000", "Damage dealt by flight collisions and super flight impacts.", 0, 100000)
createHomelanderServerConVar("homelander_sv_flight_impact_radius", "200", "Area radius for damage after hitting a surface during super flight.", 0, 5000)
createHomelanderServerConVar("homelander_sv_flight_impact_prop_destroy_radius", "300", "Props inside this radius are directly damaged/destroyed by super flight impact.", 0, 2500)
createHomelanderServerConVar("homelander_sv_flight_impact_prop_scatter_radius", "400", "Props inside this radius are unfrozen and pushed by super flight impact.", 0, 3500)
createHomelanderServerConVar("homelander_sv_flight_impact_prop_scatter_force", "90000", "Force used when scattering props from super flight impact.", 0, 300000)
createHomelanderServerConVar("homelander_sv_flight_impact_prop_damage", "5000", "Damage applied to breakable props near super flight impact.", 0, 100000)

createHomelanderServerConVar("homelander_sv_owner_godmode", "0", "When enabled, the Homelander SWEP owner becomes fully invulnerable while holding the SWEP.", 0, 1)
createHomelanderServerConVar("homelander_sv_owner_health", "30000", "Health and max health given to the Homelander SWEP owner when god mode is disabled.", 1000, 100000)

local function sendHomelanderServerCVars(ply)
    local cvarsTable = {}

    for name in pairs(HOMELANDER_SERVER_CONVARS) do
        local cvar = GetConVar(name)
        if cvar then
            cvarsTable[name] = cvar:GetString()
        end
    end

    net.Start("homelander_send_cvars_to_client")
    net.WriteTable(cvarsTable)
    net.Send(ply)
end

net.Receive("homelander_request_sv_cvars", function(_, ply)
    if not IsValid(ply) then return end
    if not (game.SinglePlayer() or ply:IsAdmin()) then return end
    sendHomelanderServerCVars(ply)
end)

net.Receive("homelander_send_sv_cvar", function(_, ply)
    if not (game.SinglePlayer() or ply:IsAdmin()) then return end

    local name = net.ReadString()
    local rawValue = net.ReadString()
    local value = tonumber(rawValue)
    local data = name and HOMELANDER_SERVER_CONVARS[name]
    if not data or not value then return end

    if data.min ~= nil or data.max ~= nil then
        value = math.Clamp(value, data.min or value, data.max or value)
    end

    RunConsoleCommand(name, tostring(value))
end)
