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
    ["scp_heavyhazmatuniform"]         = "Anime_heavyhazmat.png",
    ["scp_liquidatorsuit"]             = "Anime_highperfhazmat.png",
    ["scp_combatmedicuniform"]         = "Anime_combatmedic.png",
    ["scp_renegadecombatmedicuniform"] = "Anime_combatmedicrenegade.png",
    ["scp_renegadeuniform"]            = "Anime_renegadeuniform.png",
    -- ["scp_renegadedivingsuit"]         = "Anime_renegadesuit.png",
    ["scp_renegadecaptainuniform"]     = "Anime_renegadecaptain.png",
    ["scp_combathardsuit"]             = "Anime_combathardsuit.png",
    ["scp_softvest"]                   = "Anime_softvest.png",
    ["scp_riotvest"]                   = "Anime_riotvest.png",
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
    ["scp_interceptorsuit"]            = "Anime_interceptsuit.png",

    ["sgt_combatrig"]                  = "Anime_FFE_HeavyGear.png",
    ["sgt_boarmorhvy"]                 = "Anime_FFE_boarmor1.png",
    ["sgt_boarmorhaz"]                 = "Anime_FFE_boarmor2.png",
    ["sgt_boarmorleg"]                 = "Anime_FFE_boarmor3.png",
    ["sgt_boarmorsap"]                 = "Anime_FFE_boarmor4.png",
    ["scp_heavymechanicsuit1"]         = "Anime_FFE_engineersuit.png",
    ["sgt_heavymechanicsuit"]          = "Anime_FFE_engineersuit2.png",
    ["sgt_lightuniform2"]              = "Anime_FFE_lightuniform2.png",
    ["sgt_lightuniform"]               = "Anime_FFE_lightuniform.png",
    ["sgt_renegadeuniform"]            = "Anime_FFE_renegadeuniform.png",
    ["sgt_combatmedicuniform"]         = "Anime_FFE_combatmedic.png",
    ["sgt_renegadecombatmedicuniform"] = "Anime_FFE_combatmedicrenegade.png",
    ["sgt_exogear"]                    = "Anime_FFE_coalexogear.png",
    -- ["sgt_trenchcoat"]                 = "Anime_FFE_trenchcoat.png",
    ["sgt_zealotrobes"]                = "Anime_FFE_HuskBenefactor.png",

    ["scp_livuniform_old"]             = "Anime_vanguarduniform.png",
    -- ["scp_livrig_old"]                 = "",
    ["scp_veronrig_old"]               = "Anime_protectrig.png",
    ["scp_veronuniform_old"]           = "Anime_protectuniform.png",
}

local exceptions = {
    --skip items that have a different texture path.
    "Heavy Security Vest Holster",
    "highperfhazmat helm Wearable",
    "intercepsuit Suit Helmet Wearable",
    "combathardsuithelmet",
    "Renegade Diving Suit Helmet Wearable",
    "HAZMAT helm Wearable",
    "CBRN helmet",
    "Cultist Head",
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
                    elementsInside.SetAttributeValue("texture", "%ModDir:3771857485%/Jobgear/" ..  spriteFileName)
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

