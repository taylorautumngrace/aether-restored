#using script_0df8c162c8d4de02;

autoexec zm_slaylist_times_init()
{
    level thread zm_slaylist_times_start();
}

zm_slaylist_times_lengths()
{
    return [291, 274, 420, 371, 426, 491, 375, 259, 440, 431, 420, 270, 387, 234, 465, 263, 262, 420, 260, 420, 427, 284, 268];
}

zm_slaylist_times_delays()
{
    return [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1];
}

zm_slaylist_times_start()
{
    level endon(#"game_ended");
    for (tries = 0; tries < 120; tries++)
    {
        wait 0.5;
        changed = zm_slaylist_times_apply(#"default");
        changed = changed + zm_slaylist_times_apply(#"default_rbz");
        if (changed > 0)
        {
            iprintln("slaylist times applied to " + changed + " events");
            return;
        }
    }
}

zm_slaylist_times_apply(statekey)
{
    bank = audio_utility::function_72015cb5d5677cad("musicbank_bundles", statekey);
    if (!isdefined(bank) || !isarray(bank.musiceventdict))
    {
        return 0;
    }
    lengths = zm_slaylist_times_lengths();
    delays = zm_slaylist_times_delays();
    changed = 0;
    for (i = 0; i < lengths.size; i++)
    {
        number = i + 1;
        event = bank.musiceventdict[getxhash("bgb_slaylist_" + number)];
        if (!isdefined(event))
        {
            continue;
        }
        event.eventlength = lengths[i];
        if (isdefined(delays[i]))
        {
            event.eventstartdelay = delays[i];
        }
        changed++;
    }
    return changed;
}
