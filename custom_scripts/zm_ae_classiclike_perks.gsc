#using script_4c770a9a4ad7659c;
#using script_692b19b8e5f8f9e8;
#using script_3b64eb40368c1450;
#using script_25a8fa2ac8997425;
#using script_3a9d7a7cfee99885;
#using script_52a6d55588cb0819;
#using scripts\mp\interaction;
#using scripts\mp\common\utility\game_utility;

autoexec zm_classic_perks_init()
{
    level thread zm_classic_perks_start();
}

zm_classic_perks_ids()
{
    if (!isdefined(level.zm_cp_perk_ids))
    {
        ids = [];
        ids[ids.size] = "specialty_juggernog";
        ids[ids.size] = "specialty_quickrevive";
        ids[ids.size] = "specialty_speedcola";
        ids[ids.size] = "specialty_staminup";
        ids[ids.size] = "specialty_deadshot";
        ids[ids.size] = "specialty_death_perception";
        ids[ids.size] = "specialty_phd_flopper";
        ids[ids.size] = "specialty_vulture_aid";
        ids[ids.size] = "specialty_elemental_pop";
        ids[ids.size] = "specialty_d_mod";
        ids[ids.size] = "specialty_m_mod";
        ids[ids.size] = "specialty_w_mod";
        ids[ids.size] = "specialty_y_mod";
        ids[ids.size] = "specialty_z_mod";
        level.zm_cp_perk_ids = ids;
    }
    return level.zm_cp_perk_ids;
}

zm_classic_perks_start()
{
    level endon(#"game_ended");

    while (!isdefined(level.perk_machine_func))
    {
        waitframe();
    }

    zm_classic_perks_price("specialty_juggernog");

    level utility::registersharedfunc(#"perk_machine", #"hash_dfdcc3fdc88af90c", &zm_classic_perks_machine_price);

    level.perk_machine_func["on_use_choice"] = &zm_classic_perks_wunderfizz_use;
    level.perk_machine_func["per_player_hint_choice"] = &zm_classic_perks_wunderfizz_hint;

    level thread zm_classic_perks_wunderfizz_watch();

    while (!isdefined(level._custom_perks) || !isdefined(level._custom_perks["specialty_choice"]))
    {
        waitframe();
    }

    mode = game_utility::getgametype();
    if (isdefined(mode) && (mode == "zm_rb_r_mod_survival" || mode == "zm_rb_survival"))
    {
        level._custom_perks["specialty_choice"].cost = 1500;
    }
    else
    {
        level._custom_perks["specialty_choice"].cost = 3500;
    }
}

zm_classic_perks_perk_from_hint(hint)
{
    if (!isstruct(hint) || !isarray(level._custom_perks))
    {
        return undefined;
    }

    ids = zm_classic_perks_ids();
    foreach (perk_id in ids)
    {
        info = level._custom_perks[perk_id];
        if (!isdefined(info))
        {
            continue;
        }
        if (isdefined(hint.title) && isdefined(info.hint_name) && hint.title == info.hint_name)
        {
            return perk_id;
        }
        if (isdefined(hint.description) && isdefined(info.buy_description) && hint.description == info.buy_description)
        {
            return perk_id;
        }
        if (isdefined(hint.icon) && isdefined(info.icon) && hint.icon == info.icon)
        {
            return perk_id;
        }
    }
    return undefined;
}

zm_classic_perks_machine_price(usable)
{
    perk = undefined;

    if (isdefined(usable))
    {
        if (isdefined(usable.zm_cp_perk))
        {
            perk = usable.zm_cp_perk;
        }

        if (!isdefined(zm_classic_perks_price(perk)))
        {
            candidate = zm_classic_perks_normalize_perk(usable.script_notify);
            if (isdefined(zm_classic_perks_price(candidate)))
            {
                perk = candidate;
            }
        }
        if (!isdefined(zm_classic_perks_price(perk)) && isdefined(usable.s_perk_machine))
        {
            candidate = zm_classic_perks_normalize_perk(usable.s_perk_machine.script_noteworthy);
            if (isdefined(zm_classic_perks_price(candidate)))
            {
                perk = candidate;
            }
        }
    }

    return zm_classic_perks_price(perk);
}

zm_classic_perks_normalize_perk(perk)
{
    if (!isdefined(perk))
    {
        return undefined;
    }
    if (!isstring(perk))
    {
        return perk;
    }

    if (perk == "talent_juggernog" || perk == "specialty_juggernog" || perk == "juggernog" || perk == "perk_juggernog")
    {
        return "specialty_juggernog";
    }

    if (perk == "talent_quickrevive" || perk == "talent_quick_revive" || perk == "specialty_quickrevive" || perk == "quickrevive" || perk == "quick_revive" || perk == "perk_quickrevive")
    {
        return "specialty_quickrevive";
    }

    if (perk == "talent_speedcola" || perk == "talent_speed_cola" || perk == "specialty_speedcola" || perk == "speedcola" || perk == "speed_cola" || perk == "perk_speedcola")
    {
        return "specialty_speedcola";
    }

    if (perk == "talent_staminup" || perk == "talent_stamin_up" || perk == "specialty_staminup" || perk == "staminup" || perk == "stamin_up" || perk == "perk_staminup")
    {
        return "specialty_staminup";
    }

    if (perk == "talent_deadshot" || perk == "talent_dead_shot" || perk == "specialty_deadshot" || perk == "deadshot" || perk == "dead_shot" || perk == "perk_deadshot")
    {
        return "specialty_deadshot";
    }

    if (perk == "talent_death_perception" || perk == "specialty_death_perception" || perk == "death_perception" || perk == "perk_death_perception")
    {
        return "specialty_death_perception";
    }

    if (perk == "talent_phd_flopper" || perk == "talent_phdflopper" || perk == "specialty_phd_flopper" || perk == "phd_flopper" || perk == "phdflopper" || perk == "perk_phd_flopper")
    {
        return "specialty_phd_flopper";
    }

    if (perk == "talent_vulture_aid" || perk == "talent_vultureaid" || perk == "specialty_vulture_aid" || perk == "vulture_aid" || perk == "vultureaid" || perk == "perk_vulture_aid")
    {
        return "specialty_vulture_aid";
    }

    if (perk == "talent_elemental_pop" || perk == "talent_elementalpop" || perk == "specialty_elemental_pop" || perk == "elemental_pop" || perk == "elementalpop" || perk == "perk_elemental_pop")
    {
        return "specialty_elemental_pop";
    }

    if (perk == "talent_d_mod" || perk == "specialty_d_mod" || perk == "d_mod" || perk == "perk_d_mod")
    {
        return "specialty_d_mod";
    }
    if (perk == "talent_m_mod" || perk == "specialty_m_mod" || perk == "m_mod" || perk == "perk_m_mod")
    {
        return "specialty_m_mod";
    }
    if (perk == "talent_w_mod" || perk == "specialty_w_mod" || perk == "w_mod" || perk == "perk_w_mod")
    {
        return "specialty_w_mod";
    }
    if (perk == "talent_y_mod" || perk == "specialty_y_mod" || perk == "y_mod" || perk == "perk_y_mod")
    {
        return "specialty_y_mod";
    }
    if (perk == "talent_z_mod" || perk == "specialty_z_mod" || perk == "z_mod" || perk == "perk_z_mod")
    {
        return "specialty_z_mod";
    }

    return perk;
}

zm_classic_perks_price(perk)
{
    if (!isdefined(perk))
    {
        return undefined;
    }

    if (!isdefined(level.zm_classic_perk_prices))
    {
        level.zm_classic_perk_prices = [];
        level.zm_classic_perk_prices["specialty_juggernog"] = 2500;
        level.zm_classic_perk_prices["specialty_quickrevive"] = 1500;
        level.zm_classic_perk_prices["specialty_speedcola"] = 3000;
        level.zm_classic_perk_prices["specialty_staminup"] = 2000;
        level.zm_classic_perk_prices["specialty_deadshot"] = 1500;
        level.zm_classic_perk_prices["specialty_death_perception"] = 1500;
        level.zm_classic_perk_prices["specialty_phd_flopper"] = 2000;
        level.zm_classic_perk_prices["specialty_vulture_aid"] = 3000;
        level.zm_classic_perk_prices["specialty_elemental_pop"] = 3500;
        level.zm_classic_perk_prices["specialty_d_mod"] = 2000;
        level.zm_classic_perk_prices["specialty_m_mod"] = 2000;
        level.zm_classic_perk_prices["specialty_w_mod"] = 2000;
        level.zm_classic_perk_prices["specialty_y_mod"] = 4000;
        level.zm_classic_perk_prices["specialty_z_mod"] = 4000;

        mode = game_utility::getgametype();
        if (isdefined(mode) && (mode == "zm_rb_r_mod_survival" || mode == "zm_rb_survival"))
        {
            level.zm_classic_perk_prices["specialty_choice"] = 1500;
        }
        else
        {
            level.zm_classic_perk_prices["specialty_choice"] = 3500;
        }
    }

    if (!isstring(perk))
    {
        foreach (key, value in level.zm_classic_perk_prices)
        {
            hashed = key;
            if (isstring(key))
            {
                hashed = getxhash(key);
            }
            if (hashed == perk)
            {
                return value;
            }
        }
        return undefined;
    }

    return level.zm_classic_perk_prices[perk];
}

zm_classic_perks_at_limit(player)
{
    if (level.gametypebundle.perklimit > 0 && isdefined(player.var_468836e5e67e15b4) && player.var_468836e5e67e15b4 >= level.gametypebundle.perklimit)
    {
        return true;
    }
    return false;
}

zm_classic_perks_wunderfizz_watch()
{
    level endon(#"game_ended");
    while (!isdefined(level.a_s_perk_machines))
    {
        waitframe();
    }

    while (true)
    {
        foreach (s_machine in level.a_s_perk_machines)
        {
            if (!isdefined(s_machine) || !isdefined(s_machine.mdl_perk_machine))
            {
                continue;
            }

            interact = s_machine.mdl_perk_machine.interact;
            if (!isdefined(interact))
            {
                continue;
            }
            if (isdefined(interact.zm_classic_perks_bound) && interact.zm_classic_perks_bound)
            {
                continue;
            }

            if (isdefined(s_machine.is_wunderfizz) && s_machine.is_wunderfizz)
            {
                interact interaction::set_interact_use_callback(&zm_classic_perks_wunderfizz_use);
                interact interaction::set_interact_hint_callback(&zm_classic_perks_wunderfizz_hint);
            }
            else
            {
                if (isfunction(interact.interact_hint_callback))
                {
                    interact.zm_cp_orig_hint = interact.interact_hint_callback;
                    interact interaction::set_interact_hint_callback(&zm_classic_perks_hint_wrapper);
                }
                if (isarray(interact.var_d8e3b07237845727) && interact.var_d8e3b07237845727.size > 0 && isfunction(interact.var_d8e3b07237845727[0]))
                {
                    interact.zm_cp_orig_use = interact.var_d8e3b07237845727[0];
                    interact interaction::set_interact_use_callback(&zm_classic_perks_use_wrapper);
                }
            }
            interact.zm_classic_perks_bound = 1;
        }

        wait 0.1;
    }
}

zm_classic_perks_hint_wrapper(usable, player)
{
    orig = usable.zm_cp_orig_hint;
    if (!isfunction(orig))
    {
        return {#string:&"", #type:"HINT_NOBUTTON"};
    }

    hint = [[ orig ]](usable, player);

    if (isdefined(player) && zm_classic_perks_has_all(player))
    {
        return zm_classic_perks_machine_eternal_hint(usable, player);
    }

    if (!isstruct(hint))
    {
        return hint;
    }

    perk = usable.zm_cp_perk;
    if (!isdefined(perk))
    {
        perk = zm_classic_perks_perk_from_hint(hint);
        if (isdefined(perk))
        {
            usable.zm_cp_perk = perk;
        }
        else
        {
            return hint;
        }
    }

    price = zm_classic_perks_price(perk);
    if (!isdefined(price))
    {
        return hint;
    }

    if (!isdefined(hint.icon_text_value))
    {
        return hint;
    }
    hint.icon_text_value = price;

    if (isdefined(player) && (!isdefined(hint.interactable) || hint.interactable != 0))
    {
        if (!player currency::can_afford(currency::get_perk_machine_currency(perk), price))
        {
            hint.aux_text = &"shared_hintstrings/not_enough_essence";
            hint.var_776a268784e089af = &"shared_hintstrings/cost_essence_not_enough";
            hint.interactable = 0;
        }
    }
    else if (isdefined(player) && isdefined(hint.aux_text) && hint.aux_text == &"shared_hintstrings/not_enough_essence")
    {
        if (player currency::can_afford(currency::get_perk_machine_currency(perk), price))
        {
            hint.aux_text = undefined;
            hint.var_776a268784e089af = &"shared_hintstrings/cost_essence";
            hint.interactable = 1;
        }
    }

    return hint;
}

zm_classic_perks_use_wrapper(player)
{
    orig = self.zm_cp_orig_use;
    if (!isfunction(orig))
    {
        return;
    }

    if (isdefined(player) && zm_classic_perks_has_all(player))
    {
        self thread zm_classic_perks_machine_eternal_use(self, player);
        return;
    }

    if (isdefined(level.gametypebundle.var_5fca731c160ce025) && level.gametypebundle.var_5fca731c160ce025 && isdefined(player))
    {
        perk = self.script_notify;
        s_machine = self.s_perk_machine;
        price = zm_classic_perks_machine_price(self);

        if (isdefined(perk) && isdefined(price) && isdefined(s_machine) && isdefined(s_machine.script_currency) && isdefined(level._custom_perks[perk]))
        {
            if (self getscriptablepartstate("base") == "power_off")
            {
                return;
            }
            if (player zombie_perks::has_perk(level._custom_perks[perk].str_perk_root))
            {
                return;
            }
            if (level.var_c139731c583cae6b || !player val::get("allow_zm_perks") || player.interactions_disabled)
            {
                return;
            }
            if (zm_classic_perks_at_limit(player) || player zombie_perks::function_cda78d45986a51a0())
            {
                return;
            }
            if (!player currency::attempt_purchase(s_machine.script_currency, price, 1, undefined, #"perk", perk))
            {
                return;
            }
        }
    }

    self [[ orig ]](player);
}

zm_classic_perks_wunderfizz_use(player)
{
    if (!isdefined(player))
    {
        return;
    }
    if (player.interactions_disabled)
    {
        return;
    }
    if (!isdefined(self.s_perk_machine) || !isdefined(self.s_perk_machine.mdl_perk_machine))
    {
        return;
    }
    if (zm_classic_perks_has_all(player))
    {
        self thread zm_classic_perks_eternal_use(self, player, "specialty_choice");
        return;
    }
    if (zm_classic_perks_at_limit(player))
    {
        return;
    }

    mdl = self.s_perk_machine.mdl_perk_machine;
    if (mdl getscriptablepartstate("base") == "power_off")
    {
        return;
    }
    if (level.var_c139731c583cae6b || !player val::get("allow_zm_perks"))
    {
        return;
    }

    valid = zombie_perks::get_perks_str_array();
    active = player zombie_perks::get_active_perks_str_array();
    if (isarray(active))
    {
        valid = arrayremove(valid, active);
    }
    if (isdefined(player.disallow_zombie_perks) && player.disallow_zombie_perks.size > 0)
    {
        valid = arrayremove(valid, player.disallow_zombie_perks);
    }
    if (!isarray(valid) || valid.size == 0)
    {
        return;
    }

    perk = zombie_perks::get_random_perk_str(valid);
    if (!isdefined(perk))
    {
        return;
    }

    cost = zm_classic_perks_price("specialty_choice");
    currency = self.s_perk_machine.script_currency;
    if (!isdefined(currency))
    {
        currency = #"essence";
    }
    if (!player currency::attempt_purchase(currency, cost, 1, undefined, #"perk"))
    {
        return;
    }
    if (mdl getscriptablehaspart("use") && mdl getscriptablepartstate("use") == "default")
    {
        mdl setscriptablepartstate("use", "purchase");
    }

    params = spawnstruct();
    params.perk_machine = self;
    player callback::callback("zm_perk_machine_used", params);

    playing = 0;
    gesture = undefined;
    if (isdefined(level._custom_perks[perk]))
    {
        gesture = level._custom_perks[perk].perk_bottle_weapon;
    }
    if (isdefined(gesture))
    {
        player thread zombie_perks::function_13cc8b1c31dda8c4(gesture);
        playing = 1;
    }
    player zombie_perks::give_perk(perk, 1, playing);
    bought = spawnstruct();
    bought.perkref = perk;
    bought.cost = cost;
    bought.currency = currency;
    bought.source = #"wunderfizz";
    player callback::callback("zm_perk_purchased", bought);
}

zm_classic_perks_wunderfizz_hint(usable, player)
{
    if (!isdefined(player) || !isdefined(usable))
    {
        return {#string:&"", #type:"HINT_NOICON"};
    }

    info = level._custom_perks["specialty_choice"];
    if (!isdefined(info))
    {
        return {#string:&"", #type:"HINT_NOICON"};
    }

    cost = zm_classic_perks_price("specialty_choice");
    hint = {#icon_text_value:cost, #var_776a268784e089af:&"shared_hintstrings/cost_essence", #buttoncallout:&"shared_hintstrings/perk_machine_buy", #icon:info.icon, #description:info.buy_description, #title:info.hint_name, #type:"HINT_BUTTON"};

    if (zm_classic_perks_has_all(player))
    {
        return zm_classic_perks_eternal_hint(usable, player, hint, "specialty_choice");
    }
    if (usable getscriptablepartstate("base") == "power_off")
    {
        hint.aux_text = usable.var_4256b14b47d5e763 ?? &"shared_hintstrings/need_power_red";
        hint.interactable = 0;
        return hint;
    }
    if (zm_classic_perks_at_limit(player))
    {
        return {#string:&"", #type:"HINT_NOBUTTON"};
    }
    if (player.interactions_disabled)
    {
        return {#string:&"", #type:"HINT_NOICON"};
    }
    if (!player currency::can_afford(currency::get_perk_machine_currency("specialty_choice"), cost))
    {
        hint.aux_text = &"shared_hintstrings/not_enough_essence";
        hint.var_776a268784e089af = &"shared_hintstrings/cost_essence_not_enough";
        hint.interactable = 0;
    }

    return hint;
}

zm_classic_perks_eternal_price()
{
    return 8000;
}

zm_classic_perks_machine_eternal_price()
{
    return 10000;
}

zm_classic_perks_has_all(player)
{
    if (!isdefined(player))
    {
        return false;
    }
    return istrue(player zombie_perks::function_cda78d45986a51a0());
}

zm_classic_perks_machine_off(usable)
{
    if (!isdefined(usable))
    {
        return true;
    }

    if (usable isscriptableinstance())
    {
        return usable getscriptablepartstate("base") == "power_off";
    }

    if (isdefined(usable.s_perk_machine) && isdefined(usable.s_perk_machine.mdl_perk_machine))
    {
        mdl = usable.s_perk_machine.mdl_perk_machine;
        if (mdl isscriptableinstance())
        {
            return mdl getscriptablepartstate("base") == "power_off";
        }
    }

    return false;
}

zm_classic_perks_is_perk_in_list(list, perk)
{
    if (!isarray(list) || !isdefined(perk))
    {
        return false;
    }

    perk_hash = isstring(perk) ? getxhash(perk) : perk;

    foreach (item in list)
    {
        if (!isdefined(item))
        {
            continue;
        }
        if (item == perk)
        {
            return true;
        }
        item_hash = isstring(item) ? getxhash(item) : item;
        if (item_hash == perk_hash)
        {
            return true;
        }
    }
    return false;
}

zm_classic_perks_get_non_eternal_perks(player)
{
    candidates = [];
    if (!isdefined(player))
    {
        return candidates;
    }

    active = player zombie_perks::get_active_perks_str_array();
    if (!isarray(active))
    {
        return candidates;
    }

    foreach (perk in active)
    {
        if (!isdefined(perk))
        {
            continue;
        }
        if (!isarray(player.perma_perks) || !zm_classic_perks_is_perk_in_list(player.perma_perks, perk))
        {
            candidates[candidates.size] = perk;
        }
    }
    return candidates;
}

zm_classic_perks_can_go_eternal(player)
{
    if (!zm_classic_perks_has_all(player))
    {
        return false;
    }
    candidates = zm_classic_perks_get_non_eternal_perks(player);
    return candidates.size > 0;
}

zm_classic_perks_eternal_hint(usable, player, orig_hint, perk)
{
    if (zm_classic_perks_machine_off(usable))
    {
        return {#string:&"", #type:"HINT_NOBUTTON"};
    }
    if (player.interactions_disabled || !zm_classic_perks_can_go_eternal(player))
    {
        return {#string:&"", #type:"HINT_NOBUTTON"};
    }

    perk = "specialty_choice";

    cost = zm_classic_perks_eternal_price();
    hint = {#icon_text_value:cost, #var_776a268784e089af:&"shared_hintstrings/cost_essence", #buttoncallout:&"shared_hintstrings/perk_machine_buy", #title:&"ZM_RB_ECHO/PORTAL_TITLE_PERMANENT_PERK", #type:"HINT_BUTTON"};

    info = undefined;
    if (isarray(level._custom_perks))
    {
        info = level._custom_perks[perk];
    }
    if (isdefined(info))
    {
        hint.icon = info.icon;
        hint.description = info.buy_description;
    }

    currency = currency::get_perk_machine_currency(perk);
    if (!player currency::can_afford(currency, cost))
    {
        hint.aux_text = &"shared_hintstrings/not_enough_essence";
        hint.var_776a268784e089af = &"shared_hintstrings/cost_essence_not_enough";
        hint.interactable = 0;
    }

    return hint;
}

zm_classic_perks_eternal_use(usable, player, perk)
{
    if (!isdefined(usable) || !isdefined(player))
    {
        return;
    }

    player endon(#"disconnect");
    player endon(#"death");
    level endon(#"game_ended");

    if (player.interactions_disabled || istrue(player.insertingarmorplate))
    {
        return;
    }
    if (zm_classic_perks_machine_off(usable))
    {
        return;
    }
    if (istrue(level.var_c139731c583cae6b) || !player val::get("allow_zm_perks"))
    {
        return;
    }

    candidates = zm_classic_perks_get_non_eternal_perks(player);
    if (candidates.size == 0)
    {
        return;
    }

    target_perk = candidates[randomint(candidates.size)];

    cost = zm_classic_perks_eternal_price();
    currency = #"essence";
    if (isdefined(usable.s_perk_machine) && isdefined(usable.s_perk_machine.script_currency))
    {
        currency = usable.s_perk_machine.script_currency;
    }
    if (!player currency::attempt_purchase(currency, cost, 1, undefined, #"perk"))
    {
        return;
    }

    mdl = usable;
    if (isdefined(usable.s_perk_machine) && isdefined(usable.s_perk_machine.mdl_perk_machine))
    {
        mdl = usable.s_perk_machine.mdl_perk_machine;
    }
    if (mdl isscriptableinstance() && mdl getscriptablehaspart("use") && mdl getscriptablepartstate("use") == "default")
    {
        mdl setscriptablepartstate("use", "purchase");
    }

    params = spawnstruct();
    params.perk_machine = usable;
    player callback::callback("zm_perk_machine_used", params);

    zm_classic_perks_make_eternal(player, target_perk);
}

zm_classic_perks_text(value)
{
    if (!isdefined(value))
    {
        return "undefined";
    }
    if (isstring(value))
    {
        return value;
    }
    ids = zm_classic_perks_ids();
    foreach (id in ids)
    {
        if (getxhash(id) == value)
        {
            return id;
        }
    }
    return "hash_value";
}

zm_classic_perks_perk_from_registry(key)
{
    if (!isdefined(key) || !isarray(level._custom_perks))
    {
        return undefined;
    }

    candidate = zm_classic_perks_normalize_perk(key);
    if (isdefined(zm_classic_perks_price(candidate)))
    {
        return candidate;
    }

    info = level._custom_perks[key];
    if (!isdefined(info) || !isdefined(info.hint_name))
    {
        return undefined;
    }

    ids = zm_classic_perks_ids();
    foreach (perk_id in ids)
    {
        other = level._custom_perks[perk_id];
        if (isdefined(other) && isdefined(other.hint_name) && other.hint_name == info.hint_name)
        {
            return perk_id;
        }
    }
    return undefined;
}

zm_classic_perks_perk_from_scriptable(text)
{
    if (!isdefined(text) || !isstring(text))
    {
        return undefined;
    }

    text = tolower(text);
    if (issubstr(text, "juggernog"))
    {
        return "specialty_juggernog";
    }
    if (issubstr(text, "quick_revive") || issubstr(text, "quickrevive"))
    {
        return "specialty_quickrevive";
    }
    if (issubstr(text, "speed_cola") || issubstr(text, "speedcola"))
    {
        return "specialty_speedcola";
    }
    if (issubstr(text, "staminup") || issubstr(text, "stamin_up"))
    {
        return "specialty_staminup";
    }
    if (issubstr(text, "death_perception"))
    {
        return "specialty_death_perception";
    }
    if (issubstr(text, "deadshot"))
    {
        return "specialty_deadshot";
    }
    if (issubstr(text, "phd_flopper") || issubstr(text, "phdflopper"))
    {
        return "specialty_phd_flopper";
    }
    if (issubstr(text, "vulture_aid") || issubstr(text, "vultureaid"))
    {
        return "specialty_vulture_aid";
    }
    if (issubstr(text, "elemental_pop") || issubstr(text, "elementalpop"))
    {
        return "specialty_elemental_pop";
    }
    if (issubstr(text, "_d_mod"))
    {
        return "specialty_d_mod";
    }
    if (issubstr(text, "_m_mod"))
    {
        return "specialty_m_mod";
    }
    if (issubstr(text, "_w_mod"))
    {
        return "specialty_w_mod";
    }
    if (issubstr(text, "_y_mod"))
    {
        return "specialty_y_mod";
    }
    if (issubstr(text, "_z_mod"))
    {
        return "specialty_z_mod";
    }
    return undefined;
}

zm_classic_perks_machine_perk(usable)
{
    if (!isdefined(usable))
    {
        return undefined;
    }

    perk = usable.zm_cp_eternal_perk;
    if (isdefined(zm_classic_perks_price(perk)))
    {
        return perk;
    }

    perk = usable.zm_cp_perk;
    if (isdefined(zm_classic_perks_price(perk)))
    {
        return perk;
    }

    perk = zm_classic_perks_perk_from_registry(usable.script_notify);

    if (!isdefined(perk) && isdefined(usable.s_perk_machine))
    {
        perk = zm_classic_perks_perk_from_registry(usable.s_perk_machine.script_noteworthy);
        if (!isdefined(perk))
        {
            perk = zm_classic_perks_perk_from_scriptable(usable.s_perk_machine.str_scriptable);
        }
    }

    if (!isdefined(perk))
    {
        perk = zm_classic_perks_perk_from_scriptable(usable.str_scriptable);
    }

    if (isdefined(perk) && !isstring(perk))
    {
        perk = zm_classic_perks_text(perk);
    }

    if (isdefined(perk) && perk != "hash_value" && perk != "undefined")
    {
        usable.zm_cp_eternal_perk = perk;
        return perk;
    }
    return undefined;
}

zm_classic_perks_can_make_eternal(player, perk)
{
    if (!isdefined(player) || !isdefined(perk))
    {
        return false;
    }
    if (!zm_classic_perks_has_all(player))
    {
        return false;
    }

    active = player zombie_perks::get_active_perks_str_array();
    if (!zm_classic_perks_is_perk_in_list(active, perk))
    {
        return false;
    }
    if (isarray(player.perma_perks) && zm_classic_perks_is_perk_in_list(player.perma_perks, perk))
    {
        return false;
    }
    return true;
}

zm_classic_perks_machine_eternal_hint(usable, player)
{
    if (zm_classic_perks_machine_off(usable))
    {
        return {#string:&"", #type:"HINT_NOBUTTON"};
    }
    if (player.interactions_disabled)
    {
        return {#string:&"", #type:"HINT_NOBUTTON"};
    }

    perk = zm_classic_perks_machine_perk(usable);
    if (!isdefined(perk) || !zm_classic_perks_can_make_eternal(player, perk))
    {
        return {#string:&"", #type:"HINT_NOBUTTON"};
    }

    cost = 10000;
    hint = {#icon_text_value:cost, #var_776a268784e089af:&"shared_hintstrings/cost_essence", #buttoncallout:&"shared_hintstrings/perk_machine_buy", #description:&"ZM_RB_ECHO/PORTAL_TITLE_PERMANENT_PERK", #type:"HINT_BUTTON"};

    info = level._custom_perks[perk];
    if (isdefined(info))
    {
        hint.icon = info.icon;
        hint.title = info.hint_name;
    }

    currency = currency::get_perk_machine_currency(perk);
    if (!player currency::can_afford(currency, cost))
    {
        hint.aux_text = &"shared_hintstrings/not_enough_essence";
        hint.var_776a268784e089af = &"shared_hintstrings/cost_essence_not_enough";
        hint.interactable = 0;
    }

    return hint;
}

zm_classic_perks_make_eternal(player, perk)
{
    if (!isdefined(player) || !isdefined(perk))
    {
        return false;
    }

    active = player zombie_perks::get_active_perks_str_array();
    if (!zm_classic_perks_is_perk_in_list(active, perk))
    {
        return false;
    }
    if (isarray(player.perma_perks) && zm_classic_perks_is_perk_in_list(player.perma_perks, perk))
    {
        return false;
    }

    entry = perk;
    foreach (item in active)
    {
        if (zm_classic_perks_is_perk_in_list([item], perk))
        {
            entry = item;
            break;
        }
    }

    if (!isarray(player.perma_perks))
    {
        player.perma_perks = [];
    }
    player.perma_perks[player.perma_perks.size] = entry;

    revive_item = undefined;
    foreach (item in player.perks_active)
    {
        if (zm_classic_perks_is_perk_in_list([item], "specialty_quickrevive"))
        {
            revive_item = item;
        }
    }

    order = [];
    if (isdefined(revive_item) && !zm_classic_perks_is_perk_in_list([entry], "specialty_quickrevive"))
    {
        order[order.size] = revive_item;
    }
    order[order.size] = entry;
    foreach (item in player.perks_active)
    {
        if (zm_classic_perks_is_perk_in_list([item], "specialty_quickrevive"))
        {
            continue;
        }
        if (zm_classic_perks_is_perk_in_list([item], entry))
        {
            continue;
        }
        order[order.size] = item;
    }
    player.perks_active = order;

    player zombie_perks::function_c11ba4bb3d0a676b();

    gesture = "cer_zm_vm_ges_001";
    info = level._custom_perks[entry];
    if (isdefined(info) && isdefined(info.perk_bottle_weapon))
    {
        gesture = info.perk_bottle_weapon;
    }

    player thread hud_message::showsplash("sat_zm_permanent_perk", 0);
    player thread zombie_perks::function_13cc8b1c31dda8c4(gesture);

    eternal_params = spawnstruct();
    eternal_params.perk = entry;
    player callback::callback(#"hash_7432621eb6a7f04", eternal_params);

    return true;
}

zm_classic_perks_machine_eternal_use(usable, player)
{
    if (!isdefined(usable) || !isdefined(player))
    {
        return;
    }

    player endon(#"disconnect");
    player endon(#"death");
    level endon(#"game_ended");

    if (player.interactions_disabled || istrue(player.insertingarmorplate))
    {
        return;
    }
    if (zm_classic_perks_machine_off(usable))
    {
        return;
    }
    if (istrue(level.var_c139731c583cae6b) || !player val::get("allow_zm_perks"))
    {
        return;
    }

    perk = zm_classic_perks_machine_perk(usable);
    if (!isdefined(perk))
    {
        return;
    }
    if (!zm_classic_perks_can_make_eternal(player, perk))
    {
        return;
    }

    cost = zm_classic_perks_machine_eternal_price();
    currency = #"essence";
    if (isdefined(usable.s_perk_machine) && isdefined(usable.s_perk_machine.script_currency))
    {
        currency = usable.s_perk_machine.script_currency;
    }
    if (!player currency::attempt_purchase(currency, cost, 1, undefined, #"perk", perk))
    {
        return;
    }

    mdl = usable;
    if (isdefined(usable.s_perk_machine) && isdefined(usable.s_perk_machine.mdl_perk_machine))
    {
        mdl = usable.s_perk_machine.mdl_perk_machine;
    }
    if (mdl isscriptableinstance() && mdl getscriptablehaspart("use") && mdl getscriptablepartstate("use") == "default")
    {
        mdl setscriptablepartstate("use", "purchase");
    }

    params = spawnstruct();
    params.perk_machine = usable;
    player callback::callback("zm_perk_machine_used", params);

    zm_classic_perks_make_eternal(player, perk);
}