local awful = awful

module("autostart")

-- Autostart
function run_once(prg,arg_string,pname,screen)
    if not prg then
        do return nil end
    end

    if not pname then
       pname = prg
    end

    if not arg_string then 
        awful.util.spawn_with_shell("pgrep -f -u $USER -x '" .. pname .. "' || (" .. prg .. ")",screen)
    else
        awful.util.spawn_with_shell("pgrep -f -u $USER -x '" .. pname .. "' || (" .. prg .. " " .. arg_string .. ")",screen)
    end
end

run_once("kopete", nil, nil, 1)
run_once("skype", nil, nil, 1)
run_once("audacious", nil, nil, 1)
run_once("wicd-gtk", nil, "wicd-client", 1)
run_once("~/.dropbox-dist/dropboxd", nil, "dropboxd", 1)
