local xml2lua = require("xml2lua")
local handler = require("xmlhandler.tree")

local function getItemID()
    local EAmodXmlFile = io.open("./armor.xml", "r")
    if EAmodXmlFile == nil then 
        return   
    end
    EAmodXmlFile:read("*l")
    local EAmodXML = EAmodXmlFile:read("*a")
    io.close(EAmodXmlFile)
    
    --Instantiates the XML parser
    local parser = xml2lua.parser(handler)
    parser:parse(EAmodXML)

    --Manually prints the table (since the XML structure for this example is previously known)
    for i, p in pairs(handler.root.Items.Item) do
    --print(string.format("%-35s= \"\",", "[\"" .. p._attr.identifier .. "\"]"))
    print(string.format(p._attr.identifier))
    end
    
end


getItemID()