
pcall(require, "luarocks.loader")
-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
--local hotkeys_popup = require("awful.hotkeys_popup")
-- Widget and layout library
local wibox = require("wibox")

mediaPlayer="ncmpcpp"
visualizer="cava"

function createMediaWindow()
    
    ncmpcppPID,_ = awful.spawn(terminal .. " -e "..mediaPlayer, { callback = setupMediaWindow })
    cavaPID,_ = awful.spawn(terminal .. " -e "..visualizer, { callback = setupMediaWindow})
    --I create the 2 callbacks on spawning the windows due to sometimes one calling before the other/before the client was created.
    
    cavaPIDTable.insert(ncmpcppPID,cavaPID)
end

--preform initial setup stuff after the windows have spawned
function setupMediaWindow(c)
    ncmpcppClient, cavaClient = cavaPIDTable.getClients(c.pid)
    if ncmpcppClient ~= nil and cavaClient ~= nil then
        moveMediaWindow(ncmpcppClient,cavaClient)
    end
end

--handle the actual movement
function moveMediaWindow(ncmpcppClient,cavaClient)    
    cavaClient.focus=true
    cavaClient.x = ncmpcppClient.x
    cavaClient.y = ncmpcppClient.y
    cavaClient.above=true
    ncmpcppClient.above=true
    cavaClient.width = ncmpcppClient.width
    cavaClient.height = ncmpcppClient.height
    cavaClient.minimized = ncmpcppClient.minimized
    cavaClient.maximized = ncmpcppClient.maximized
    
end

--move media player and visualizer at the same time
client.connect_signal("property::position", function(c)
    if (c.name == mediaPlayer) then
        ncmpcppClient, cavaClient = cavaPIDTable.getClients(c.pid)
        if ncmpcppClient ~= nil and cavaClient ~= nil then
            moveMediaWindow(ncmpcppClient,cavaClient)
        end
    end
end)


