Config = {}

Config.RaidLocations = {
    ["cotorra"] = {
        name = "Cotorra Springs",
        coords = vector3(-836.90, -408.27, 42.01),
        radius = 10.0,
        banditModels = {
        'g_m_m_uniduster_01',
        ''
},

        waves = {
            {
                count = 4,
                weapon = "WEAPON_REPEATER_WINCHESTER"
            },
            {
                count = 6,
                weapon = "WEAPON_REPEATER_WINCHESTER"
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
