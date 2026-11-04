#using scripts\common\callbacks;
#using scripts\common\utility;
#using scripts\mp\armor;
#using scripts\mp\common\utility\game_utility;

autoexec zm_armor_health_rework_init()
{
    level thread zm_armor_health_rework_start();
    level thread zm_turtle_shell_armor_start();
    level thread zm_armormatic_always_on_start();
    level thread zm_plate_heal_start();
    level thread zm_armor_wallbuy_start();
    level thread zm_armor_t3_block_start();
    level thread zm_special_damage_start();
}

autoexec bo3_health_init()
{
    setdvar( "zombie_melee_damage_override", "50" );
    setdvar( "zombie_melee_damage_multiplier", "1.0" );
}

function private wait_for_gametype()
{
    level endon( #"game_ended" );

    mode = undefined;
    while ( !isdefined( mode ) )
    {
        mode = level.gametype;

        if ( !isdefined( mode ) && isdefined( level.gametypebundle ) )
        {
            mode = game_utility::getgametype();
        }

        if ( !isdefined( mode ) )
        {
            waitframe();
        }
    }

    return mode;
}

function private zm_armor_health_rework_start()
{
    level endon( #"game_ended" );

    wait_for_gametype();

    if ( !supported_mode() )
    {
        return;
    }

    level callback::add( #"player_spawned", &on_player_spawned );
    level callback::add( "wallbuy_armor_purchased", &on_armor_purchased );
    level callback::add( #"player_damaged", &zm_armor_regen_on_damaged );
    level thread maintain_no_starting_armor();

    foreach ( player in level.players )
    {
        if ( isplayer( player ) && isalive( player ) )
        {
            player on_player_spawned( undefined );
        }
    }
}

function private supported_mode()
{
    mode = game_utility::getgametype();

    return mode == "zm_rb_r_mod" || mode == "zm_rb_r_mod_survival" || mode == "zm_rb_rh_mod" || mode == "zm_rb" || mode == "zm_rb_survival";
}

function private empty_starting_armor( player )
{
    return [ 0, 0 ];
}

function private maintain_no_starting_armor()
{
    level endon( #"game_ended" );
    while ( supported_mode() )
    {
        level.var_89173a04bb110bf3 = &empty_starting_armor;

        if ( isdefined( level.zm_mode_modifiers ) )
        {
            level.zm_mode_modifiers.var_2dc492758425fa76 = 0;
        }
        wait 0.10;
    }
}

function private on_player_spawned( params )
{
    if ( !supported_mode() || !isplayer( self ) )
    {
        return;
    }
    self.fresh_armor_bought_this_life = 0;
    self thread clear_spawn_armor();
    self thread zm_armor_regen_loop();
}

function private zm_is_game_start()
{
    return ( level.round_number ?? 1 ) <= 1;
}

function private clear_spawn_armor()
{
    self endon( #"disconnect" );
    wait 0.20;

    if ( !zm_is_game_start() )
    {
        if ( ( self.platecarrierlevel ?? 1 ) >= 2 )
        {
            self.fresh_armor_bought_this_life = 1;
            return;
        }

        if ( !self.fresh_armor_bought_this_life )
        {
            self force_armor_zero();
        }
        wait 0.50;

        if ( ( self.platecarrierlevel ?? 1 ) >= 2 )
        {
            self.fresh_armor_bought_this_life = 1;
            return;
        }

        if ( !self.fresh_armor_bought_this_life )
        {
            self force_armor_zero();
        }
        return;
    }

    if ( !self.fresh_armor_bought_this_life )
    {
        self force_armor_zero();
    }
    wait 0.50;

    if ( !zm_is_game_start() )
    {
        if ( ( self.platecarrierlevel ?? 1 ) >= 2 )
        {
            self.fresh_armor_bought_this_life = 1;
            return;
        }

        if ( !self.fresh_armor_bought_this_life )
        {
            self force_armor_zero();
        }
        return;
    }

    if ( !self.fresh_armor_bought_this_life )
    {
        self force_armor_zero();
    }
}

function private force_armor_zero()
{
    self.platecarrierlevel = 1;
    self.maxarmorhealth = 0;
    self.var_a1faa64d8c07872e = 0;
    self setclientomnvar( "ui_armor_current_level", 0 );
    self armor::setarmorhealth( 0, 1, 1 );
    self armor::function_b359444c252374fc( 0 );
}

function private on_armor_purchased( params )
{
    if ( !isplayer( self ) )
    {
        return;
    }
    self.fresh_armor_bought_this_life = 1;

    if ( isdefined( params ) && isdefined( params.armor_level ) && params.armor_level >= 3 )
    {
        self zm_armor_keep_at_t2();
    }
}

function private zm_armor_keep_at_t2()
{
    t2_max = 100;
    if ( isdefined( level.var_1e9e024bcfca2274 ) && isdefined( level.var_1e9e024bcfca2274.var_ba2fc513d06dd9d5 ) )
    {
        t2_max = level.var_1e9e024bcfca2274.var_ba2fc513d06dd9d5;
    }

    self.platecarrierlevel = 2;
    self.maxarmorhealth = t2_max;
    self armor::setarmorhealth( t2_max );
    self setclientomnvar( "ui_armor_current_level", 2 );
}

function private zm_turtle_shell_armor_start()
{
    level endon( #"game_ended" );

    mode = wait_for_gametype();

    if ( getsubstr( mode, 0, 3 ) != "zm_" )
    {
        return;
    }

    while ( !isdefined( level.var_6f8b7a2e996178a8 ) || !isdefined( level.var_21038aca0aba3c4a ) )
    {
        waitframe();
    }

    if ( isdefined( level.zm_turtle_shell_wrapped ) )
    {
        return;
    }
    level.zm_turtle_shell_wrapped = 1;

    level.zm_turtle_shell_orig_absorbed = level.var_6f8b7a2e996178a8;
    level.zm_turtle_shell_orig_post = level.var_21038aca0aba3c4a;
    level.var_6f8b7a2e996178a8 = &turtle_shell_armor_absorbed;
    level.var_21038aca0aba3c4a = &turtle_shell_armor_post;
}

function private turtle_shell_native_active()
{
    return utility::callsharedfunc( #"hash_e7a7d049d5f06935", #"hash_81cf46be569bf3bb", "specialty_juggernog" ) && utility::callsharedfunc( #"zombie", #"player_has_augment", #"juggernog_turtle_shell" );
}

function private turtle_shell_armor_absorbed( damage, eattacker, einflictor, smeansofdeath )
{
    front_mitigation_scale = 0;
    ignore_shell = 0;

    if ( isdefined( eattacker ) && ( eattacker.ignore_turtle_shell || ( smeansofdeath == "MOD_BLEEDOUT" && eattacker.var_f968344e6801d0c1 ) ) )
    {
        ignore_shell = 1;
    }

    if ( isdefined( einflictor ) && einflictor.ignore_turtle_shell )
    {
        ignore_shell = 1;
    }

    native_active = turtle_shell_native_active();
    prior_ignore = undefined;

    if ( native_active && isdefined( eattacker ) )
    {
        prior_ignore = eattacker.ignore_turtle_shell;
        eattacker.ignore_turtle_shell = 1;
        eattacker.var_84f354484bf84831 = undefined;
    }

    absorbed_damage = self [[ level.zm_turtle_shell_orig_absorbed ]]( damage, eattacker, einflictor, smeansofdeath );

    if ( native_active && isdefined( eattacker ) )
    {
        eattacker.ignore_turtle_shell = prior_ignore;
    }

    if ( ignore_shell || !isdefined( eattacker ) )
    {
        return absorbed_damage;
    }

    attack_origin = eattacker.turtle_shell_attack_origin ?? eattacker.origin;

    if ( !isdefined( attack_origin ) || eattacker == self || attack_origin == self.origin )
    {
        return absorbed_damage;
    }

    to_attacker = vectornormalize( attack_origin - self.origin );
    playerforward = vectornormalize( anglestoforward( self.angles ) );
    dot = vectordot( playerforward, to_attacker );

    if ( dot <= 0 )
    {
        eattacker.var_84f354484bf84831 = 1;
        absorbed_damage = damage;

        self setentitysoundcontext( "zm_plr_impact_armored", "on" );
        self thread clear_armored_sound_context();
    }
    else
    {
        absorbed_damage *= front_mitigation_scale;
    }

    return absorbed_damage;
}

function private clear_armored_sound_context()
{
    self endon( #"disconnect" );
    wait 0.1;
    self setentitysoundcontext( "zm_plr_impact_armored", "" );
}

function private turtle_shell_armor_post( damageabsorbed, attacker, smeansofdeath )
{
    if ( isdefined( attacker ) && attacker.var_84f354484bf84831 )
    {
        attacker.var_84f354484bf84831 = undefined;

        if ( isdefined( attacker.type ) && attacker.type == "zombie" )
        {
            damageabsorbed *= 0.5;
        }
    }

    native_active = turtle_shell_native_active();
    prior_ignore = undefined;

    if ( native_active && isdefined( attacker ) )
    {
        prior_ignore = attacker.ignore_turtle_shell;
        attacker.ignore_turtle_shell = 1;
    }

    result = self [[ level.zm_turtle_shell_orig_post ]]( damageabsorbed, attacker, smeansofdeath );

    if ( native_active && isdefined( attacker ) )
    {
        attacker.ignore_turtle_shell = prior_ignore;
    }

    return result;
}

function private zm_armormatic_always_on_start()
{
    level endon( #"game_ended" );

    mode = wait_for_gametype();

    if ( getsubstr( mode, 0, 3 ) != "zm_" )
    {
        return;
    }

    while ( !utility::issharedfuncdefined( #"zombie", #"hash_3930894d8d2f0ee6" ) )
    {
        waitframe();
    }

    if ( isdefined( level.zm_armormatic_wrapped ) )
    {
        return;
    }
    level.zm_armormatic_wrapped = 1;

    level.zm_armormatic_orig_check = level.sharedfuncs[ #"zombie" ][ #"hash_3930894d8d2f0ee6" ];
    level.sharedfuncs[ #"zombie" ][ #"hash_3930894d8d2f0ee6" ] = &zm_armormatic_check;
}

function private zm_armormatic_check( perkname, augmentname )
{
    if ( perkname == "specialty_vulture_aid" && augmentname == #"vulture_aid_replate" )
    {
        return 1;
    }

    return self [[ level.zm_armormatic_orig_check ]]( perkname, augmentname );
}

function private zm_plate_heal_start()
{
    level endon( #"game_ended" );

    mode = wait_for_gametype();

    if ( getsubstr( mode, 0, 3 ) != "zm_" )
    {
        return;
    }

    while ( !isdefined( level.var_6b5a5711823ede8c ) )
    {
        waitframe();
    }

    if ( isdefined( level.zm_plate_heal_wrapped ) )
    {
        return;
    }
    level.zm_plate_heal_wrapped = 1;

    level.zm_plate_heal_orig = level.var_6b5a5711823ede8c;
    level.var_6b5a5711823ede8c = &zm_plate_heal_repair;
}

function private zm_plate_heal_repair()
{
    heal_fraction = 0.20;

    if ( isdefined( level.zm_armormatic_orig_check ) && self [[ level.zm_armormatic_orig_check ]]( "specialty_vulture_aid", #"vulture_aid_replate" ) )
    {
        heal_fraction = 0.50;
    }

    old_health = self.armorhealth ?? 0;

    stock_new_health = self [[ level.zm_plate_heal_orig ]]();

    if ( !isdefined( self.platecarrierlevel ) || self.platecarrierlevel <= 0 || !isdefined( self.maxarmorhealth ) )
    {
        return stock_new_health;
    }

    plate_size = self.maxarmorhealth / self.platecarrierlevel;

    return clamp( old_health + plate_size * heal_fraction, 0, self.maxarmorhealth );
}

function private zm_armor_regen_on_damaged( params )
{
    self.zm_armor_regen_last_hit = gettime();
}

function private zm_armor_regen_loop()
{
    self notify( #"zm_armor_regen_restart" );
    self endon( #"zm_armor_regen_restart" );
    self endon( #"disconnect" );
    self endon( #"death" );
    level endon( #"game_ended" );

    self.zm_armor_regen_last_hit = gettime();

    base_amount = 3;

    if ( isdefined( level.zombie_augments ) && isdefined( level.zombie_augments[ #"juggernog_shielded" ] ) )
    {
        base_amount = level.zombie_augments[ #"juggernog_shielded" ].var_840d64e41ac5801a ?? 3;
    }

    delay = 6500;
    amount = base_amount * 1.25;
    tick_time = 0.35;

    prev_health = self.armorhealth ?? 0;

    while ( 1 )
    {
        wait tick_time;

        if ( !isalive( self ) )
        {
            continue;
        }

        current = self.armorhealth ?? 0;

        if ( current < prev_health )
        {
            self.zm_armor_regen_last_hit = gettime();
        }

        prev_health = current;

        if ( !turtle_shell_native_active() )
        {
            continue;
        }

        if ( self.var_a1faa64d8c07872e )
        {
            continue;
        }

        if ( !isdefined( self.maxarmorhealth ) || self.maxarmorhealth <= 0 || current >= self.maxarmorhealth )
        {
            continue;
        }

        if ( gettime() - self.zm_armor_regen_last_hit < delay )
        {
            continue;
        }

        new_health = clamp( current + amount, 0, self.maxarmorhealth );
        self armor::setarmorhealth( new_health );

        prev_health = self.armorhealth ?? new_health;
    }
}

function private zm_armor_wallbuy_start()
{
    level endon( #"game_ended" );

    wait_for_gametype();

    if ( !supported_mode() )
    {
        return;
    }

    ns = hashcat( #"hash_98a94353ec1044cc", "armor" );

    while ( !utility::issharedfuncdefined( ns, #"hash_aabdea2170a670c7" ) || !utility::issharedfuncdefined( ns, #"hash_eb2053cea864e5ab" ) )
    {
        waitframe();
    }

    if ( isdefined( level.zm_armor_wallbuy_wrapped ) )
    {
        return;
    }
    level.zm_armor_wallbuy_wrapped = 1;

    level.zm_armor_wallbuy_orig_purchase = level.sharedfuncs[ ns ][ #"hash_aabdea2170a670c7" ];
    level.zm_armor_wallbuy_orig_hint = level.sharedfuncs[ ns ][ #"hash_eb2053cea864e5ab" ];
    level.sharedfuncs[ ns ][ #"hash_aabdea2170a670c7" ] = &zm_armor_wallbuy_purchase;
    level.sharedfuncs[ ns ][ #"hash_eb2053cea864e5ab" ] = &zm_armor_wallbuy_hint;
}

function private zm_armor_t3_block_start()
{
    level endon( #"game_ended" );

    wait_for_gametype();

    if ( !supported_mode() )
    {
        return;
    }

    while ( 1 )
    {
        if ( isdefined( level.var_1e9e024bcfca2274 ) )
        {
            level.var_1e9e024bcfca2274.var_c02aad60bddb8f16 = level.var_1e9e024bcfca2274.var_ba2fc513d06dd9d5 ?? 100;
        }

        if ( isdefined( level.var_139e91e252a2df0c ) && isdefined( level.var_139e91e252a2df0c[ 2 ] ) && isdefined( level.var_139e91e252a2df0c[ 3 ] ) && isdefined( level.var_139e91e252a2df0c[ 2 ].costrefill ) )
        {
            level.var_139e91e252a2df0c[ 3 ].costbase = level.var_139e91e252a2df0c[ 2 ].costrefill;
        }

        if ( isdefined( level.var_139e91e252a2df0c ) && isdefined( level.var_139e91e252a2df0c[ 2 ] ) )
        {
            level.var_139e91e252a2df0c[ 2 ].costbase = 5000;
        }

        wait 0.1;
    }
}

function private zm_armor_wallbuy_tier( player )
{
    if ( self.var_7ffbc1821f2b0602 == #"wallbuy_zm_t10_armor_epic" )
    {
        return 3;
    }

    return 2;
}

function private zm_player_has_armor_carrier()
{
    if ( self.fresh_armor_bought_this_life )
    {
        return 1;
    }

    if ( ( self.maxarmorhealth ?? 0 ) > 0 )
    {
        return 1;
    }

    if ( ( self.platecarrierlevel ?? 1 ) >= 2 )
    {
        return 1;
    }

    return 0;
}

function private zm_armor_wallbuy_t2_price( player, tier )
{
    if ( !isdefined( self.zm_armor_orig_cost ) )
    {
        self.zm_armor_orig_cost = self.cost;
    }

    if ( tier == 2 && !( player zm_player_has_armor_carrier() ) )
    {
        self.cost = 5000;
    }
    else if ( isdefined( self.zm_armor_orig_cost ) )
    {
        self.cost = self.zm_armor_orig_cost;
    }
}

function private zm_armor_wallbuy_purchase( player )
{
    if ( isplayer( player ) )
    {
        tier = self zm_armor_wallbuy_tier( player );

        if ( tier == 3 )
        {
            player playsoundtoplayer( #"ui_zm_core_purchase_deny", player );
            return;
        }

        self zm_armor_wallbuy_t2_price( player, tier );
    }

    self [[ level.zm_armor_wallbuy_orig_purchase ]]( player );
}

function private zm_armor_wallbuy_hint( usable, player )
{
    owns_carrier = 0;

    if ( isplayer( player ) )
    {
        tier = usable zm_armor_wallbuy_tier( player );

        if ( tier == 3 )
        {
            hint_data = spawnstruct();
            hint_data.string = &"";
            hint_data.type = "HINT_NOBUTTON";
            return hint_data;
        }

        usable zm_armor_wallbuy_t2_price( player, tier );
        owns_carrier = player zm_player_has_armor_carrier();
    }

    hint_data = self [[ level.zm_armor_wallbuy_orig_hint ]]( usable, player );

    if ( owns_carrier && isdefined( hint_data ) && hint_data.type == "HINT_BUTTON" )
    {
        hint_data.title = &"cp_zmb/armor_repair";
        hint_data.description = &"cp_zmb/armor_repair_desc";

        t2_max = 100;
        if ( isdefined( level.var_1e9e024bcfca2274 ) && isdefined( level.var_1e9e024bcfca2274.var_ba2fc513d06dd9d5 ) )
        {
            t2_max = level.var_1e9e024bcfca2274.var_ba2fc513d06dd9d5;
        }

        if ( ( player.armorhealth ?? 0 ) >= t2_max )
        {
            hint_data.aux_text = &"cp_zmb/armor_full";
            hint_data.interactable = 0;
        }
    }

    return hint_data;
}

function private zm_special_damage_start()
{
    level endon( #"game_ended" );

    mode = wait_for_gametype();

    if ( getsubstr( mode, 0, 3 ) != "zm_" )
    {
        return;
    }

    if ( utility::issharedfuncdefined( #"zm", #"hash_364bf98dfc68dd24" ) )
    {
        level.zm_special_damage_orig = level.sharedfuncs[ #"zm" ][ #"hash_364bf98dfc68dd24" ];
    }

    utility::registersharedfunc( #"zm", #"hash_364bf98dfc68dd24", &zm_special_damage_remap );
}

function private zm_special_damage_remap( dmg_struct )
{
    damage = dmg_struct.idamage;

    if ( isdefined( level.zm_special_damage_orig ) )
    {
        damage = self [[ level.zm_special_damage_orig ]]( dmg_struct ) ?? damage;
    }

    attacker = dmg_struct.eattacker;
    if ( isdefined( attacker ) && isdefined( attacker.gunner ) )
    {
        attacker = attacker.gunner;
    }

    if ( !isdefined( attacker ) || isplayer( attacker ) || !isdefined( damage ) )
    {
        return damage;
    }

    category = attacker.aicategory;

    if ( !isdefined( category ) || ( category != "special" && category != "elite" && category != "hvt" && category != "boss" ) )
    {
        return damage;
    }

    full_pool = self.maxhealth + ( self.maxarmorhealth ?? 0 );

    if ( damage >= full_pool )
    {
        return damage;
    }

    chip_damage = 15;
    weak_attack = 35;
    strong_attack = 90;

    if ( damage < chip_damage )
    {
        return damage;
    }

    if ( damage <= weak_attack )
    {
        return 25;
    }

    if ( damage >= strong_attack )
    {
        return 75;
    }

    return 50;
}
