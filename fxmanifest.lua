fx_version "cerulean"
game "gta5"

name "FiveCCTV"

author "Fallcrim"
description "A simple script to add CCTV functionality"

ui_page "html/index.html"

client_scripts {
    "client.lua",
    "config.lua"
}

files {
    "html/index.html",
    "html/script.js",
}

lua54 'yes'