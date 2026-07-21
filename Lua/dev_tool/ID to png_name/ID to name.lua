local xml2lua = require("xml2lua")
local handler = require("xmlhandler.tree")
local Files = {
    [[.\xml\EA armor.xml]],
    [[.\xml\EAFFE Enhanced_Equipment.xml]],
    [[.\xml\EAF juggernaut.xml]],
    [[.\xml\EAF lagacy armor.xml]],
    -- [[.\animeArmor.xml]],
}

local exceptions = {
    'scp_simplehelmet',
    'scp_combathelmet',
    'scp_heavycombathelmet',
    'scp_renegadeheavyhelmet',
    'scp_renegadecaptainhat',
    'scp_assaultpack',
    'scp_heavypack',
    'scp_tacpack',
    'scp_fieldpack',
    'scp_protopack',
    'scp_renegadehelmet',
    'scp_yuihelmet',
    'scp_livhelmet',
    'scp_veronhelmet',
    'scp_hardeneddivingmask',
    'scp_clownbatmask',
    'scp_marauderhelmet',
    'sgt_longrangeradio',
    'sgt_bobag',
    'sgt_fieldcap',
    'sgt_cowboy',
    'sgt_blackopshelm',
    'sgt_blackopshelm2',
    'sgt_blackopshelm3',
    'sgt_blackopshelm4',
    'sgt_tachelm',
    'sgt_medhelm',
    'eaf_juggernauthelmet',
    'scp_livhelmet_old',
    'scp_veronhelmet_old',
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
            io.write(element)
        end
    else
      return tostring(o)
    end
    print()
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

    for i in ipairs(item) do
        for _2, v2 in pairs(exceptions) do
            if item[i]._attr.identifier == v2 then
                -- print('REMOVED '.. item[i]._attr.identifier)
                table.remove(item, i)
            end
        end
    end

    for item_Index in ipairs(item) do
        table.insert(rawListOutput, item[item_Index]._attr.identifier)

        for sprite_index in ipairs(item[item_Index].Wearable.sprite) do
            table.insert(rawListOutput, ";" .. item[item_Index].Wearable.sprite[sprite_index]._attr.texture)
        end

        if not item[item_Index].Wearable.sprite[1] then
            table.insert(rawListOutput, ";" .. item[item_Index].Wearable.sprite._attr.texture)
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