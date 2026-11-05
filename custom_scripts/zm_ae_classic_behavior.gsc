#using scripts\common\callbacks;
#using scripts\common\utility;
#using scripts\mp\zm\spawners\agent_spawner;
#using scripts\mp\zm\spawners\zone_spawner;
#using scripts\mp\zm\systems\zm_round_spawning;
#using scripts\mp\zm\systems\zmaispawnlists;

autoexec zm_zombie_speed_limit_init()
{
    level thread zm_zombie_speed_limit_start();
}

function private zm_zombie_speed_wait_for_gametype()
{
    level endon( #"game_ended" );

    mode = undefined;
    while ( !isdefined( mode ) )
    {
        mode = level.gametype;

        if ( !isdefined( mode ) && isdefined( level.var_a009ab14ee0d3223 ) )
        {
            mode = "zm_";
        }

        if ( !isdefined( mode ) )
        {
            waitframe();
        }
    }

    return mode;
}

function private zm_zombie_speed_limit_start()
{
    level endon( #"game_ended" );

    mode = zm_zombie_speed_wait_for_gametype();

    if ( isstring( mode ) && getsubstr( mode, 0, 3 ) != "zm_" )
    {
        return;
    }

    if ( isdefined( level.zm_zombie_speed_limit_registered ) )
    {
        return;
    }
    level.zm_zombie_speed_limit_registered = 1;

    level callback::add( "on_move_speed_changed", &zm_zombie_speed_limit_apply );
}

function private zm_zombie_speed_limit_apply( params )
{
    if ( !isdefined( self ) || !isdefined( params ) || !isdefined( params.move_speed ) )
    {
        return;
    }

    if ( !isdefined( self.subclass ) || !isstring( self.subclass ) || getsubstr( self.subclass, 0, 11 ) != "zombie_base" )
    {
        return;
    }

    wanted_speed = getanimspeedthreshold( self, params.move_speed );
    max_speed = zm_zombie_speed_limit_max();

    if ( !isdefined( wanted_speed ) || !isdefined( max_speed ) || wanted_speed <= 0 )
    {
        return;
    }

    if ( wanted_speed > max_speed )
    {
        self setmovespeedscale( max_speed / wanted_speed );
        self.zm_zombie_speed_scaled = 1;
    }
    else if ( istrue( self.zm_zombie_speed_scaled ) )
    {
        self setmovespeedscale( 1 );
        self.zm_zombie_speed_scaled = undefined;
    }
}

function private zm_zombie_speed_limit_max()
{
    top_speed_fraction = 0.85;
    below_player_sprint_fraction = 0.90;

    top_speed = getanimspeedthreshold( self, "super_sprint" );

    if ( !isdefined( top_speed ) )
    {
        top_speed = getanimspeedthreshold( self, "sprint" );
    }

    if ( !isdefined( top_speed ) )
    {
        return undefined;
    }

    max_speed = top_speed * top_speed_fraction;
    player_limit = zm_player_default_sprint_speed() * below_player_sprint_fraction;

    if ( max_speed > player_limit )
    {
        max_speed = player_limit;
    }

    return max_speed;
}

function private zm_player_default_sprint_speed()
{
    sprint_scale = 1.5;

    return getdvarfloat( @"g_speed", 190 ) * sprint_scale;
}

autoexec zm_no_armored_zombies_init()
{
    zm_no_armored_set_replacements();
    zm_no_armored_hook_round_spawning();
    zm_no_armored_hook_agent();

    if ( isdefined( level.callbacks ) && isdefined( level.callbacks.on_zombie_ai_spawned ) )
    {
        level.callbacks.on_zombie_ai_spawned = undefined;
    }

    level thread zm_no_armored_zombies_run();
}

function zm_no_armored_is_base_subclass( name )
{
    if ( !isdefined( name ) )
    {
        return false;
    }

    return name == "zombie_base" || name == #"zombie_base";
}

function zm_no_armored_get_base_aitype()
{
    if ( isdefined( level.var_a009ab14ee0d3223 ) && isdefined( level.var_a009ab14ee0d3223.normalroundspawns ) && isdefined( level.var_a009ab14ee0d3223.normalroundspawns[ 1 ] ) && isdefined( level.var_a009ab14ee0d3223.normalroundspawns[ 1 ].ailist ) )
    {
        base_aitype = zmaispawnlists::function_d34f63bc9c24e432( level.var_a009ab14ee0d3223.normalroundspawns[ 1 ].ailist );

        if ( isdefined( base_aitype ) && !zm_no_armored_is_armored_name( base_aitype ) )
        {
            return base_aitype;
        }
    }

    if ( isdefined( level.aitype_to_subclass ) )
    {
        foreach ( k, v in level.aitype_to_subclass )
        {
            if ( zm_no_armored_is_base_subclass( v ) )
            {
                return k;
            }
        }
    }

    if ( isdefined( level.var_a706785ff83cb223 ) )
    {
        foreach ( k, v in level.var_a706785ff83cb223 )
        {
            if ( zm_no_armored_is_base_subclass( v ) )
            {
                return k;
            }
        }
    }

    return "zombie_base";
}

function zm_no_armored_add_override( fromtype, totype )
{
    if ( !isdefined( fromtype ) || !isdefined( totype ) || fromtype == totype )
    {
        return;
    }

    if ( !isdefined( level.var_a009ab14ee0d3223 ) )
    {
        return;
    }

    if ( !isdefined( level.var_a009ab14ee0d3223.aitypeoverridemap ) )
    {
        level.var_a009ab14ee0d3223.aitypeoverridemap = [];
    }

    current = level.var_a009ab14ee0d3223.aitypeoverridemap[ fromtype ];

    if ( !isdefined( current ) || current.size != 1 || current[ 0 ] != totype )
    {
        level.var_a009ab14ee0d3223.aitypeoverridemap[ fromtype ] = [ totype ];
    }
}

function zm_no_armored_sanitize_spawnlist( spawnlist, base_aitype, base_spawnlist )
{
    if ( !isdefined( spawnlist ) )
    {
        return false;
    }

    subclasses = zmaispawnlists::function_e0abfec4a095a04b( spawnlist );
    has_armored = 0;
    has_base = 0;
    only_base_or_armored = 1;

    if ( isdefined( subclasses ) && subclasses.size > 0 )
    {
        foreach ( sub in subclasses )
        {
            if ( zm_no_armored_is_armored_name( sub ) )
            {
                has_armored = 1;
                zm_no_armored_add_override( sub, base_aitype );
            }
            else if ( zm_no_armored_is_base_subclass( sub ) )
            {
                has_base = 1;
            }
            else
            {
                only_base_or_armored = 0;
            }
        }
    }
    else
    {
        only_base_or_armored = 0;
    }

    if ( has_armored )
    {
        for ( i = 0; i < 16; i++ )
        {
            sample = zmaispawnlists::function_d34f63bc9c24e432( spawnlist );

            if ( isdefined( sample ) && ( !has_base || zm_no_armored_is_armored( sample ) ) )
            {
                zm_no_armored_add_override( sample, base_aitype );
            }
        }
    }

    return has_armored && only_base_or_armored && isdefined( base_spawnlist );
}

function zm_no_armored_set_replacements()
{
    setdvar( "hash_5b9f8512308d472a", "zombie_base_armored_light->zombie_base|zombie_base_armored_heavy->zombie_base|zombie_base_armored_agni->zombie_base" );

    if ( !isdefined( level.var_a009ab14ee0d3223 ) )
    {
        return;
    }

    level.var_a009ab14ee0d3223.aitypeoverridemap = level.var_a009ab14ee0d3223.aitypeoverridemap ?? [];

    base_aitype = zm_no_armored_get_base_aitype();
    base_spawnlist = undefined;

    if ( isdefined( level.var_a009ab14ee0d3223.normalroundspawns ) && isdefined( level.var_a009ab14ee0d3223.normalroundspawns[ 1 ] ) )
    {
        base_spawnlist = level.var_a009ab14ee0d3223.normalroundspawns[ 1 ].ailist;
    }

    overrides = [
        "zombie_base_armored_light",
        "zombie_base_armored_heavy",
        "zombie_base_armored_agni",
        "light_armored_zombie",
        "heavy_armored_zombie",
        #"zombie_base_armored_light",
        #"zombie_base_armored_heavy",
        #"zombie_base_armored_agni",
        #"light_armored_zombie",
        #"heavy_armored_zombie"
    ];

    foreach ( override in overrides )
    {
        zm_no_armored_add_override( override, base_aitype );
    }

    if ( isdefined( level.aitype_to_subclass ) )
    {
        foreach ( k, v in level.aitype_to_subclass )
        {
            if ( zm_no_armored_is_armored_name( k ) || zm_no_armored_is_armored_name( v ) )
            {
                zm_no_armored_add_override( k, base_aitype );
                zm_no_armored_add_override( v, base_aitype );
            }
        }
    }

    if ( isdefined( level.var_a706785ff83cb223 ) )
    {
        foreach ( k, v in level.var_a706785ff83cb223 )
        {
            if ( zm_no_armored_is_armored_name( k ) || zm_no_armored_is_armored_name( v ) )
            {
                zm_no_armored_add_override( k, base_aitype );
                zm_no_armored_add_override( v, base_aitype );
            }
        }
    }

    if ( isdefined( level.ai_subclass_to_category ) )
    {
        foreach ( sub, _ in level.ai_subclass_to_category )
        {
            if ( zm_no_armored_is_armored_name( sub ) )
            {
                zm_no_armored_add_override( sub, base_aitype );
            }
        }
    }

    if ( isdefined( level.var_a009ab14ee0d3223.aisubclassintroround ) )
    {
        foreach ( sub, _ in level.var_a009ab14ee0d3223.aisubclassintroround )
        {
            if ( zm_no_armored_is_armored_name( sub ) )
            {
                zm_no_armored_add_override( sub, base_aitype );
            }
        }
    }

    if ( isdefined( level.var_a009ab14ee0d3223.normalroundspawns ) )
    {
        foreach ( roundindex, roundinfo in level.var_a009ab14ee0d3223.normalroundspawns )
        {
            if ( roundindex != 1 && isdefined( roundinfo ) && isdefined( roundinfo.ailist ) )
            {
                if ( zm_no_armored_sanitize_spawnlist( roundinfo.ailist, base_aitype, base_spawnlist ) )
                {
                    roundinfo.ailist = base_spawnlist;
                }
            }
        }
    }

    if ( isdefined( level.var_a009ab14ee0d3223.var_48700cdf9eaa7f9 ) )
    {
        foreach ( entry in level.var_a009ab14ee0d3223.var_48700cdf9eaa7f9 )
        {
            if ( isdefined( entry ) && isdefined( entry.mixedaispawntype ) )
            {
                if ( zm_no_armored_sanitize_spawnlist( entry.mixedaispawntype, base_aitype, base_spawnlist ) )
                {
                    entry.mixedaispawntype = base_spawnlist;
                }
            }
        }
    }

    if ( isdefined( level.var_a009ab14ee0d3223.var_8eb34c1c71c1333f ) )
    {
        foreach ( entry in level.var_a009ab14ee0d3223.var_8eb34c1c71c1333f )
        {
            if ( isdefined( entry ) && isdefined( entry.mixedaispawntype ) )
            {
                if ( zm_no_armored_sanitize_spawnlist( entry.mixedaispawntype, base_aitype, base_spawnlist ) )
                {
                    entry.mixedaispawntype = base_spawnlist;
                }
            }
        }
    }

    if ( isdefined( level.var_a009ab14ee0d3223.var_9ae086885e903c0c ) )
    {
        foreach ( entry in level.var_a009ab14ee0d3223.var_9ae086885e903c0c )
        {
            if ( isdefined( entry ) && isdefined( entry.mixedaispawntype ) )
            {
                if ( zm_no_armored_sanitize_spawnlist( entry.mixedaispawntype, base_aitype, base_spawnlist ) )
                {
                    entry.mixedaispawntype = base_spawnlist;
                }
            }
        }
    }

    if ( isdefined( level.var_a009ab14ee0d3223.var_4fcb67d418d85735 ) )
    {
        foreach ( entry in level.var_a009ab14ee0d3223.var_4fcb67d418d85735 )
        {
            if ( isdefined( entry ) && isdefined( entry.mixedaispawntype ) )
            {
                if ( zm_no_armored_sanitize_spawnlist( entry.mixedaispawntype, base_aitype, base_spawnlist ) )
                {
                    entry.mixedaispawntype = base_spawnlist;
                }
            }
        }
    }

    if ( isdefined( level._szombiecleanupinfo ) && isdefined( level._szombiecleanupinfo.zombiependingrespawn ) )
    {
        foreach ( respawn_info in level._szombiecleanupinfo.zombiependingrespawn )
        {
            if ( isdefined( respawn_info ) && isdefined( respawn_info.aitype ) && zm_no_armored_is_armored( respawn_info.aitype ) )
            {
                respawn_info.aitype = base_aitype;
            }
        }
    }
}

function zm_no_armored_zombies_run()
{
    level endon( #"game_ended" );
    waitframe();

    while ( true )
    {
        zm_no_armored_set_replacements();
        zm_no_armored_hook_round_spawning();
        zm_no_armored_hook_agent();
        wait 0.05;
    }
}

function zm_no_armored_is_armored_name( name )
{
    if ( !isdefined( name ) )
    {
        return false;
    }

    if ( name == "zombie_base_armored_light" || name == "zombie_base_armored_heavy" || name == "zombie_base_armored_agni" || name == "light_armored_zombie" || name == "heavy_armored_zombie" )
    {
        return true;
    }

    if ( name == #"zombie_base_armored_light" || name == #"zombie_base_armored_heavy" || name == #"zombie_base_armored_agni" || name == #"light_armored_zombie" || name == #"heavy_armored_zombie" )
    {
        return true;
    }

    if ( isstring( name ) )
    {
        return issubstr( name, "armored" );
    }

    return false;
}

function zm_no_armored_resolve_aitype( aitype )
{
    if ( !isdefined( aitype ) )
    {
        return aitype;
    }

    if ( isdefined( level.var_a009ab14ee0d3223 ) && isdefined( level.var_a009ab14ee0d3223.aitypeoverridemap ) && isdefined( level.var_a009ab14ee0d3223.aitypeoverridemap[ aitype ] ) && level.var_a009ab14ee0d3223.aitypeoverridemap[ aitype ].size > 0 )
    {
        count = level.var_a009ab14ee0d3223.aitypeoverridemap[ aitype ].size;
        return level.var_a009ab14ee0d3223.aitypeoverridemap[ aitype ][ randomint( count ) ];
    }

    if ( zm_no_armored_is_armored( aitype ) )
    {
        return zm_no_armored_get_base_aitype();
    }

    return aitype;
}

function zm_no_armored_hook_round_spawning()
{
    current = level.zmmaproundspawningoverride;

    if ( isfunction( current ) && current == &zm_no_armored_round_spawning_override )
    {
        return;
    }

    level.zm_no_armored_original_round_spawning_override = undefined;

    if ( isfunction( current ) )
    {
        level.zm_no_armored_original_round_spawning_override = current;
    }

    level.zmmaproundspawningoverride = &zm_no_armored_round_spawning_override;
}

function zm_no_armored_round_spawning_override( aitype )
{
    aitype = zm_no_armored_resolve_aitype( aitype );

    if ( isfunction( level.zm_no_armored_original_round_spawning_override ) )
    {
        return [[ level.zm_no_armored_original_round_spawning_override ]]( aitype );
    }

    if ( isdefined( level.mapinfobundle ) && istrue( level.mapinfobundle.var_b7bdaf6a2a733aaa ) && isdefined( level.var_d24e66b3dd54be4a ) && arraycontains( level.var_d24e66b3dd54be4a, aitype ) )
    {
        return zone_spawner::spawn_single_dog( aitype );
    }

    return agent_spawner::spawn_agent( aitype, 1 );
}

function zm_no_armored_hook_agent()
{
    current = level.var_1e2c07e345d293d1;

    if ( isfunction( current ) && current == &zm_no_armored_agent_aitype )
    {
        return;
    }

    level.zm_no_armored_original_agent_hook = undefined;

    if ( isfunction( current ) )
    {
        level.zm_no_armored_original_agent_hook = current;
    }

    level.var_1e2c07e345d293d1 = &zm_no_armored_agent_aitype;
}

function zm_no_armored_agent_aitype( aitype )
{
    if ( isfunction( level.zm_no_armored_original_agent_hook ) )
    {
        aitype = [[ level.zm_no_armored_original_agent_hook ]]( aitype );
    }

    if ( !isdefined( aitype ) )
    {
        return aitype;
    }

    bare = aitype;
    has_actor_prefix = 0;

    if ( isstring( aitype ) && isstartstr( aitype, "actor_" ) )
    {
        bare = getsubstr( aitype, 6 );
        has_actor_prefix = 1;
    }

    if ( !zm_no_armored_is_armored_name( bare ) && !zm_no_armored_is_armored_name( aitype ) && !zm_no_armored_is_armored( bare ) && !zm_no_armored_is_armored( aitype ) )
    {
        return aitype;
    }

    replacement = zm_no_armored_get_base_aitype();

    if ( has_actor_prefix && isstring( replacement ) && !isstartstr( replacement, "actor_" ) )
    {
        replacement = "actor_" + replacement;
    }

    return replacement;
}

function zm_no_armored_is_armored( aitype )
{
    if ( !isdefined( aitype ) )
    {
        return false;
    }

    if ( zm_no_armored_is_armored_name( aitype ) )
    {
        return true;
    }

    if ( isdefined( level.var_a009ab14ee0d3223 ) && isdefined( level.var_a009ab14ee0d3223.aitypeoverridemap ) && isdefined( level.var_a009ab14ee0d3223.aitypeoverridemap[ aitype ] ) )
    {
        return true;
    }

    subclass = undefined;

    if ( isdefined( level.aitype_to_subclass ) )
    {
        subclass = level.aitype_to_subclass[ aitype ];
    }

    if ( !isdefined( subclass ) && isdefined( level.var_a706785ff83cb223 ) )
    {
        subclass = level.var_a706785ff83cb223[ aitype ];
    }

    return zm_no_armored_is_armored_name( subclass );
}
