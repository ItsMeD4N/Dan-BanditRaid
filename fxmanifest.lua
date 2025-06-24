fx_version 'cerulean'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
game 'rdr3'
author 'DAN'
description 'Bandit Raid system for RSG Framework'
version '1.0.1'

dependencies {
    'rsg-core',
    'ox_lib'
}

server_script 'server/server.lua'
client_script 'client/client.lua'
shared_script 'config.lua'