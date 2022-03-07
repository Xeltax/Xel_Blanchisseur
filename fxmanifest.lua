fx_version 'adamant'

game 'gta5'

description 'Script de présentation de véhicule au concess par Xeltax'

version 'legacy'

client_scripts {
	'src/RageUI.lua',
    'src/Menu.lua',
    'src/MenuController.lua',
    'src/components/*.lua',
    'src/elements/*.lua',
    'src/items/*.lua',

    "client.lua",
    "config.lua"
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    "config.lua",
	'server.lua'
}