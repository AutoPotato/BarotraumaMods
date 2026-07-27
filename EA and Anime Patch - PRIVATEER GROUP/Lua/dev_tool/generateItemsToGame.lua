-- A single cabinate can contain 35 items.
local itemList = {
    {
    "scp_heavyvest",
    "scp_heavyrig",
    "scp_specialrig",
    "scp_renegadespecialrig",
    "scp_renegadevest",
    "scp_heavyuniform",
    "scp_heavyrenuniform",
    "scp_renegadeplatecarrier",
    "scp_heavyhazmatuniform",
    "scp_liquidatorsuit",
    "scp_combatmedicuniform",
    "scp_renegadecombatmedicuniform",
    "scp_renegadeuniform",
    -- "scp_renegadedivingsuit",
    "scp_renegadecaptainuniform",
    -- "scp_combathardsuit",
    "scp_softvest",
    "scp_riotvest",
    "scp_yuirig",
    "scp_specopsuniform",
    "scp_livuniform",
    "scp_livrig",
    "scp_veronrig",
    "scp_marauderrig",
    "scp_marauderuniform",
    "scp_veronuniform",
    "scp_lightuniform",
    "scp_cbrnsuit",
    "scp_clownbatuniform",
    -- "scp_interceptorsuit",
    },
    {
    "sgt_combatrig",
    "sgt_boarmorhvy",
    "sgt_boarmorhaz",
    "sgt_boarmorleg",
    "sgt_boarmorsap",
    "scp_heavymechanicsuit1",
    "sgt_heavymechanicsuit",
    "sgt_lightuniform2",
    "sgt_lightuniform",
    "sgt_renegadeuniform",
    "sgt_combatmedicuniform",
    "sgt_renegadecombatmedicuniform",
    "sgt_exogear",
    "sgt_trenchcoat",
    "sgt_zealotrobes",


    "eaf_juggernautarmor",
    "eaf_juggernautarmor_2",
    "eaf_juggernautuniform",


    "scp_livuniform_old",
    "scp_livrig_old",
    "scp_veronrig_old",
    "scp_veronuniform_old",
    }
}

print("[EA Anime Dev Tool]Running Dev Tool.")

Hook.Add("chatMessage", "chatMessageExample", function(message)
    local targetCabinet
    local count = 0

    for orderNumber = 1, #itemList, 1 do

        for _, cabFind in ipairs(Item.ItemList) do
            if cabFind.HasTag("C" .. orderNumber) and cabFind.OwnInventory then
                targetCabinet = cabFind --locate the cabinate to spawn items
                break -- 找到了就跳出循环
            end
        end


        for index in ipairs(itemList[orderNumber]) do
            local item = ItemPrefab.GetItemPrefab(itemList[orderNumber][index])

            --             AddItemToSpawnQueue(itemPrefab, worldPosition, condition, quality, onSpawned)
            Entity.Spawner.AddItemToSpawnQueue(item, targetCabinet.OwnInventory, nil, nil,
                function()
                    print("add item " .. tostring(item) .. "  --->  " .. targetCabinet.tags)
                end
            )
            count = count + 1
        end
    end

    print(message)
    print(count)
end)
