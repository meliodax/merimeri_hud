fx_version 'adamant'
game {'gta5'}

ui_page "nui/ui.html"

files {
    "nui/ui.html",
    "nui/ui.css",
    "nui/ui.js"
}

client_script{
    "@vrp/lib/utils.lua",
    'client-side/client.lua'
}

