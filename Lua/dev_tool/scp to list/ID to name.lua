local xml2lua = require("xml2lua")
local handler = require("xmlhandler.tree")
local Files = {
    [[D:\Developer Project\EA and Anime Patch - PRIVATEER GROUP\Example\xml\EA armor.xml]],
    [[D:\Developer Project\EA and Anime Patch - PRIVATEER GROUP\Example\xml\EAFFE Enhanced_Equipment.xml]],
    [[D:\Developer Project\EA and Anime Patch - PRIVATEER GROUP\Example\xml\EAF juggernaut.xml]],
    [[D:\Developer Project\EA and Anime Patch - PRIVATEER GROUP\Example\xml\EAF lagacy armor.xml]],
}

local function removeDuplicates(arr)
    local hash = {}
    local res = {}
    for _, v in ipairs(arr) do
        if not hash[v] then
            hash[v] = true
            table.insert(res, v)
        end
    end
    return res
end

local function safeMax(t)
    if nil then
        return "not table"
    end
    if type(t)~="table" then
        return "not table"
    else
        local count = 0
        for _ in pairs(t) do
            count = count + 1
        end
        return count
    end
end

local function dump_tb(o)
    if type(o) == 'table' then
        for i, element in pairs(o) do
            print(element)
        end
    else
      return tostring(o)
    end
end


local function getItemID(filePath)
    local EAmodXmlFile = io.open(filePath, "r")
    if EAmodXmlFile == nil then 
        return   
    end
    EAmodXmlFile:read("*l")
    local EAmodXML = EAmodXmlFile:read("*a")
    io.close(EAmodXmlFile)
    
    --Instantiates the XML parser
    local listHandler = handler:new()
    local parser = xml2lua.parser(listHandler)
    local rawListOutput = {}
    parser:parse(EAmodXML)

    for i = 1, safeMax(listHandler.root.Items.Item), 1 do
            -- print(listHandler.root.Items.Item[i].Wearable._attr.name)
            print(string.format(listHandler.root.Items.Item[i]._attr.identifier))
            
            for k = 1, safeMax(listHandler.root.Items.Item[i].Wearable.sprite), 1 do
                -- print("item"..i .." Wearable.".. "sprite" ..k )
                if listHandler.root.Items.Item[i].Wearable.sprite[k] == nil then
                    table.insert(rawListOutput, "          "..listHandler.root.Items.Item[i].Wearable.sprite._attr.texture)
                else
                    table.insert(rawListOutput, "          "..listHandler.root.Items.Item[i].Wearable.sprite[k]._attr.texture)
                end
            end

        rawListOutput = removeDuplicates(rawListOutput)
        dump_tb(rawListOutput)
        rawListOutput = {}
    end
end

local function printwithIndex()
    for total = 1, #Files, 1 do
        print("")
        getItemID(Files[total])
    end
end

printwithIndex()