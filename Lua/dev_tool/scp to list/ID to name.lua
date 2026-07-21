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
    local listHandler = handler:new() --create a new handler to store xml data
    local parser = xml2lua.parser(listHandler) --tell the parser to use listHandler to store the results
    parser:parse(EAmodXML) --actually parses the data then put it in listHandler
    local item = listHandler.root.Items.Item

    local rawListOutput = {}

    for item_Index in ipairs(item) do
        table.insert(rawListOutput, item[item_Index]._attr.identifier)

        for sprite_index in ipairs(item[item_Index].Wearable.sprite) do
            table.insert(rawListOutput, "    " .. item[item_Index].Wearable.sprite[sprite_index]._attr.texture)
        end

        if not item[item_Index].Wearable.sprite[1] then
            table.insert(rawListOutput, "    " .. item[item_Index].Wearable.sprite._attr.texture)
        end

        rawListOutput = removeDuplicates(rawListOutput)
        dump_tb(rawListOutput)
        rawListOutput = {}
    end
end

local function printwithIndex()
    for files_Index in ipairs(Files) do
        getItemID(Files[files_Index])
        print("")
    end
end

printwithIndex()