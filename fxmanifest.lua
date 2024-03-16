fx_version 'cerulean'

game 'gta5'

lua54 'yes'

author 'Orion Store'

description 'Simple Job Center'

version '1.0'

ui_page 'html/index.html'

shared_scripts {
    'config.lua'
}

server_scripts {
    'server/main.lua'
}

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    'client/main.lua'
}

files {
    'html/*.js',
    'html/*.html',
    'html/*.css'
}
