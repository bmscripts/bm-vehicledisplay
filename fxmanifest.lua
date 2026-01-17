fx_version 'cerulean'
game 'gta5'

author 'YourNameHere'
description 'Vehicle Spawner with Rotation and Cleanup'
version '1.0.0'

client_scripts {
    'config.lua',   -- Make sure config.lua is loaded before client.lua
    'client.lua'
}

lua54 'yes'
