#!/bin/sh
# ----------------------------------------------------------------------
# this script changes my caps and tab key, addiionally the new tab-key is also a hyper key

XKBDIR=/tmp/xkb
[ -d ${XKBDIR}/symbols ] || mkdir -p ${XKBDIR}/{keymap,symbols}

# the following is generated from a setxkbmap command:
#     setxkbmap -print
# the final tweak being the addition of the "+custom(hypers)" to use my local customizations

cat > $XKBDIR/keymap/custom.xkb << EOF
xkb_keymap {
    xkb_keycodes  { include "evdev+aliases(qwerty)"	};
    xkb_types     { include "complete"	};
    xkb_compat    { include "complete"	};
    xkb_symbols   { include "pc+ch+inet(evdev)+terminate(ctrl_alt_bksp)+custom(hypers)"	};
    xkb_geometry  { include "pc(pc105)"	};
};
EOF

cat > $XKBDIR/symbols/custom << EOF
default partial
xkb_symbols "hypers" {
    key <I244>    { [ Tab,	ISO_Left_Tab ] };
    key <TAB>     { [ Caps_Lock, Caps_Lock ] };
    key <CAPS>    { [ Hyper_L, Hyper_L ] };
    key <RTSH>    { [ Hyper_R, Hyper_R ] };
};
EOF
# i252 is a unset key for me.
#    key <I252>    { [ Tab,	ISO_Left_Tab ] };
# explicitly declare the hyper-keys as Mod4 seems to break it
#    modifier_map Mod4 { Super_L, Super_R Hyper_L, Hyper_R };
xmodmap -e "add Mod4 = Hyper_L"
xmodmap -e "add Mod4 = Hyper_R"

# ----------------------------------------------------------------------
# reinitialize keyboard
# ----------------------------------------------------------------------
xkbcomp -synch -w3 -I$XKBDIR $XKBDIR/keymap/custom.xkb $DISPLAY &>/dev/null
killall -q xcape
xcape -e "Hyper_L=Tab;Hyper_R=backslash"
