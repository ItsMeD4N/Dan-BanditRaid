Config = {}

Config.RaidLocations = {
    ["bw"] = {
        name = "Cotorra Springs",
        coords = vector3(-801.56, -1306.50, 43.48),
        radius = 100.0,
        banditModels = {
        'g_m_m_uniduster_01'
},
        waves = {
            {
                count = 10,
                weapon = "WEAPON_REPEATER_WINCHESTER"
            },
            {
                count = 60,
                weapon = "WEAPON_REPEATER_CARBINE"
            }
        }
    },
    ["hangingdog"] = {
        name = "Hanging Dog Ranch",
        coords = vec3(-598.23, -383.11, 81.13),
        radius = 50.0,
        banditModels = {
        'g_m_m_uniduster_01'
        },
        waves = {
            {
                count = 8,
                weapon = "WEAPON_REPEATER_WINCHESTER"
            }
        }
    }
}
