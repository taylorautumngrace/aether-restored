#using script_4c770a9a4ad7659c;
#using script_692b19b8e5f8f9e8;
#using script_3b64eb40368c1450;
#using script_25a8fa2ac8997425;
#using script_3a9d7a7cfee99885;
#using scripts\mp\interaction;

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
    level._custom_perks["specialty_choice"].cost = 1500;
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
        level.zm_classic_perk_prices["specialty_choice"] = 3500;
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

    // Owning every perk means there is nothing to buy here, so with no power
    // hide the prompt entirely instead of showing "need power".
    if (isdefined(player) && zm_classic_perks_has_all(player) && zm_classic_perks_machine_off(usable))
    {
        return {#string:&"", #type:"HINT_NOBUTTON"};
    }

    hint = [[ orig ]](usable, player);

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
        zm_classic_perks_eternal_use(self, player, "specialty_choice");
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
        return zm_classic_perks_eternal_hint(usable, player, "specialty_choice");
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

zm_classic_perks_trace(text)
{
    iprintln("classic perks: " + text);
}

zm_classic_perks_eternal_price()
{
    return 8000;
}

zm_classic_perks_has_all(player)
{
    if (!isdefined(player))
    {
        return false;
    }
    return player zombie_perks::function_cda78d45986a51a0();
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

// Eternal perks are only on offer when the player owns every perk in the game
// and at least one of them is not eternal yet.
zm_classic_perks_can_go_eternal(player)
{
    if (!zm_classic_perks_has_all(player))
    {
        return false;
    }
    active = player zombie_perks::get_active_perks_str_array();
    if (!isarray(active))
    {
        return false;
    }
    if (isdefined(player.perma_perks))
    {
        active = arrayremove(active, player.perma_perks);
    }
    if (active.size == 0)
    {
        return false;
    }
    return true;
}

zm_classic_perks_eternal_hint(usable, player, perk)
{
    if (zm_classic_perks_machine_off(usable) || player.interactions_disabled || !zm_classic_perks_can_go_eternal(player))
    {
        return {#string:&"", #type:"HINT_NOBUTTON"};
    }

    // The reward is a random perk, so always show the generic random-perk entry
    // instead of the icon of whichever machine the player is standing at.
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

    zm_classic_perks_trace("eternal: use called");

    if (player.interactions_disabled || player.insertingarmorplate)
    {
        zm_classic_perks_trace("eternal: stopped, interactions disabled");
        return;
    }
    if (zm_classic_perks_machine_off(usable))
    {
        zm_classic_perks_trace("eternal: stopped, no power");
        return;
    }
    if (level.var_c139731c583cae6b || !player val::get("allow_zm_perks"))
    {
        zm_classic_perks_trace("eternal: stopped, perks not allowed");
        return;
    }
    if (!zm_classic_perks_can_go_eternal(player))
    {
        zm_classic_perks_trace("eternal: stopped, nothing left to make eternal");
        return;
    }

    cost = zm_classic_perks_eternal_price();
    currency = #"essence";
    if (isdefined(usable.s_perk_machine) && isdefined(usable.s_perk_machine.script_currency))
    {
        currency = usable.s_perk_machine.script_currency;
    }
    if (!player currency::attempt_purchase(currency, cost, 1, undefined, #"perk"))
    {
        zm_classic_perks_trace("eternal: stopped, purchase failed, cost " + cost);
        return;
    }

    zm_classic_perks_trace("eternal: paid " + cost);

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

    before = 0;
    if (isdefined(player.perma_perks))
    {
        before = player.perma_perks.size;
    }

    player zombie_perks::function_ab9b4123275d6153(undefined, 1, 0, 1);

    if (isdefined(player.perma_perks) && player.perma_perks.size > before)
    {
        bought = spawnstruct();
        bought.perkref = player.perma_perks[player.perma_perks.size - 1];
        bought.cost = cost;
        bought.currency = currency;
        bought.source = #"perk_machine";
        player callback::callback("zm_perk_purchased", bought);
        zm_classic_perks_trace("eternal: granted " + bought.perkref);
    }
    else
    {
        zm_classic_perks_trace("eternal: paid but no perk became eternal");
    }
}
