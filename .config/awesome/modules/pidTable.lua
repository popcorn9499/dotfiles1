-- keep track of one pid to another

pcall(require, "luarocks.loader")
-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
--local hotkeys_popup = require("awful.hotkeys_popup")
-- Widget and layout library
local wibox = require("wibox")


local Table={table={}} --ncmpcppPID: cavaPID



function Table.insert(pid1,pid2) --return 0 if failed 1 if worked
    result = 0
    if Table.table[pid1] == nil then --checking if it was attempted to overwrite a previous pid
        Table.table[pid1] = pid2
        result = 1
    end
    return result
end

function Table.getClients(pid1) -- return client object if found. otherwise return nil
    c = {nil,nil} --stores clients in ncmpcpp:cava order
    pid2 = Table.table[pid1]
    y = Table.getClient(pid1)
    x = Table.getClient(pid2)

    return y,x
end

function Table.getClient(pid) --get client based on its pid
    c = nil
    if pid ~= nil then
        for _,d in ipairs(client.get()) do
            if d.pid == pid then
                c = d
                break
            end
        end
    end
    return c
end

function Table.print()
    print("Printing Table")
    for key,pair in pairs(Table.table) do
        print(key.. ":"..pair)
    end
end




return Table

