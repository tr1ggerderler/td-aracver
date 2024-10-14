fx_version 'cerulean'
game 'gta5'

author 'triggerderler'
description 'ID ile araç ver'
version '1.0.0'

client_scripts {
    'config.lua',
    'client.lua' 
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

dependencies {
    'qb-core',
    'oxmysql'
}
