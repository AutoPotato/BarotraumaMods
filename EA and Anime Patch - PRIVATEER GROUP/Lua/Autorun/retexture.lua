local textureRegistry = {
    -- ["itemID"]             = "spriteFileName",
    ["scp_heavyvest"]                  = "Anime_heavyarmor.png",
    ["scp_heavyrig"]                   = "Anime_heavyarmorrig.png",
    ["scp_specialrig"]                 = "Anime_specialrig.png",
    ["scp_renegadespecialrig"]         = "Anime_renegadespecialrig.png",
    ["scp_renegadevest"]               = "Anime_renegadevest.png",
    ["scp_heavyuniform"]               = "Anime_heavyuniform.png",
    ["scp_heavyrenuniform"]            = "Anime_heavyrenuniform.png",
    ["scp_renegadeplatecarrier"]       = "Anime_renegadeplatecarrier.png",
    ["scp_heavyhazmatuniform"]         = "Anime_rencbrnsuit.png",
    ["scp_liquidatorsuit"]             = "Anime_highperfhazmat.png",
    ["scp_combatmedicuniform"]         = "Anime_combatmedic.png",
    ["scp_renegadecombatmedicuniform"] = "Anime_combatmedicrenegade.png",
    ["scp_renegadeuniform"]            = "Anime_renegadeuniform.png",
    ["scp_renegadedivingsuit"]         = "Anime_renegadesuit.png",
    ["scp_renegadecaptainuniform"]     = "Anime_renegadecaptain.png",
    ["sgt_coalitioncaptainuniform"]    = "Anime_coalitioncaptain.png",
    ["scp_combathardsuit"]             = "Anime_combathardsuit.png",
    ["scp_softvest"]                   = "Anime_softvest.png",
    ["scp_riotvest"]                   = "Anime_riotvest.png",
    ["sgt_securityvest"]               = "Anime_riotsuit.png",
    ["scp_yuirig"]                     = "Anime_specopsvest.png",
    ["scp_specopsuniform"]             = "Anime_specopsuniform.png",
    ["scp_livuniform"]                 = "Anime_vanguarduniform.png",
    ["scp_livrig"]                     = "Anime_vanguardrig.png",
    ["scp_veronrig"]                   = "Anime_protectrig.png",
    ["scp_marauderrig"]                = "Anime_marauderrig.png",
    ["scp_marauderuniform"]            = "Anime_marauderuniform.png",
    ["scp_veronuniform"]               = "Anime_protectuniform.png",
    ["scp_lightuniform"]               = "Anime_lightuniform.png",
    ["scp_cbrnsuit"]                   = "Anime_cbrnsuit.png",
    ["scp_clownbatuniform"]            = "Anime_clowncombatdress.png",
    ["scp_honkmasteroutfit"]           = "Anime_clowncombatdress2.png",
    ["scp_interceptorsuit"]            = "Anime_interceptsuit.png",
    ["scp_sevasuit"]                   = "Anime_apsseva.png",
    ["sgt_banditclothes1"]             = "Anime_bandit_1.png",
}

local exceptions = {
    --skip items that have a different texture path.
    "Heavy Security Vest Holster",
    "highperfhazmat helm Wearable",
    "intercepsuit Suit Helmet Wearable",
    "combathardsuithelmet",
    "Renegade Diving Suit Helmet Wearable",
}

local function is_exception(spriteName)
    for i, exception in pairs(exceptions) do
        if spriteName == exception then
            return true
        end
    end
    return false
end

local function InjectAnimeEASprites()
    local totalItemsProcessed = 0
    --Loop through every pair of data.
    for itemID, spriteFileName in pairs(textureRegistry) do
            -- look for Item ID and get the raw data.
        local customItemPrefab = ItemPrefab.GetItemPrefab(itemID)
        if not customItemPrefab then
            print("[Anime EA Mod] Error: Could not find the item's ID(identifier).")
        else
            --Get the xml layout.
            local config = customItemPrefab.ConfigElement
            if not config then 
                print("[Anime EA Mod] Error: ConfigElement is empty.")
                return
            end
            
            -- Get <Wearable>'s every element, break when found.
            local wearableFind = nil
            for i in config.Elements() do
                if i.Name.ToString() == "Wearable" then
                    wearableFind = i
                    break
                end
            end
            
            if not wearableFind then
                print("[Anime EA Mod] Warning: No <Wearable> component found in this item.")
                return
            end
            local count = 0

            -- Replace the texture path inside <Wearable>.   
            for elementsInside in wearableFind.Elements() do
                if elementsInside.Name.ToString() == "sprite" and not is_exception(elementsInside.GetAttributeString("name", nil)) then
                    -- Direct the texture's path to this mod.
                    elementsInside.SetAttributeValue("texture", "%ModDir:3251262845%/Jobgear/" ..  spriteFileName)
                    count = count + 1
                end
            end

            wearableFind.Elements()
            totalItemsProcessed = totalItemsProcessed + 1
            --print("[Anime EA Mod]" .. itemID .. " | " .. spriteFileName.. " Successfully injected textures into " .. count .. " limbs!")
        end
    end
    print("[Anime Enhanced Armaments Patch Mod] Done. Total items retextured: " .. totalItemsProcessed)
end

print("[Anime Enhanced Armaments Patch Mod]====Beginning====")
print("[Anime Enhanced Armaments Patch Mod] Replacing EA Textures with the Anime version.")
InjectAnimeEASprites()

