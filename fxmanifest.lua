fx_version 'cerulean'
game 'gta5'

description 'KP-Rental'
version '1.0.0'

shared_scripts {
    '@qb-core/shared/locale.lua',
    'locales/en.lua',
    'locales/*.lua',
    'config.lua'
}

client_scripts {
    'client/main.lua'
}

server_script {
    'server/main.lua'
}

dependency 'qb-target'

lua54 'yes'