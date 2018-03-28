-- Imports.
import XMonad
import XMonad.Layout.PerWorkspace
import XMonad.Operations
import System.IO
import System.Exit
import XMonad.Util.Run
import Graphics.X11.ExtraTypes.XF86
import XMonad.Actions.CycleWS
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks    -- dock/tray mgmt
import Data.Monoid
import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import System.Exit
import XMonad.Layout.Grid
import XMonad.Layout.NoBorders
import XMonad.Layout.Tabbed
import XMonad.Layout.Fullscreen
import XMonad.Util.SpawnOnce
--import XMonad hiding ( (|||) )  -- don't use the normal ||| operator
--import XMonad.Layout.LayoutCombinators   -- use the one from LayoutCombinators instead
--import System.Taffybar.XMonadLog ( dbusLog )

-- The main function.
main = xmonad =<< statusBar myBar myPP toggleStrutsKey myConfig

-- Command to launch the bar.
myBar = "xmobar"

-- Custom PP, configure it as you like. It determines what is being written to the bar.
myPP = xmobarPP { ppVisible = xmobarColor "#404040" "", 
                  ppCurrent = xmobarColor "#DF7401" "",  
                  ppTitle = xmobarColor "#FFB6B0" "", 
  --                ppHiddenNoWindows = xmobarColor "#222222" "", 
  --                ppLayout = xmobarColor"#790a0a" "", 
                  ppUrgent = xmobarColor "#900000" "" . wrap "[" "]" 
                }
-- Key binding to toggle the gap for the bar.
toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)
-- Main configuration, override the defaults to your liking.
myConfig = def {           modMask = mod4Mask
                         , terminal = "termite"
                         , workspaces = myWorkspaces
                         , keys = myKeys
                         , layoutHook = smartBorders $ myLayoutHook
                         , focusedBorderColor = "#2E9AFE"
                         , normalBorderColor = "#000000"
                         , manageHook = myManageHook <+> manageHook def
                         , mouseBindings = myMouseBindings
                         , borderWidth         =1
                         , startupHook = myStartupHook
                         }

myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
    [ ((modMask, xK_Return), spawn "termite")
    , ((modMask, xK_d), spawn "exec rofi -show run")
--   , ((modMask, xK_d), spawn "exe=`dmenu_path | dmenu` && eval \"exec $exe\"")
    , ((modMask .|. shiftMask, xK_d), spawn "gmrun")
    -- close focused window
    , ((modMask .|. mod1Mask, xK_q), kill)
--    , ((modMask, xK_f), sendMessage $ JumpToLayout "Full")
--    , ((modMask, xK_space), sendMessage $ JumpToLayout "Tall")
--    , ((modMask, xK_space), sendMessage NextLayout)
    --  Reset the layouts on the current workspace to default
    , ((modMask .|. mod1Mask, xK_space ), setLayout $ XMonad.layoutHook conf)
--    , ((modMask, xK_n), refresh)
    --movement:
    , ((modMask, xK_j ), windows W.focusDown)
    , ((modMask, xK_k ), windows W.focusUp)
    , ((modMask, xK_h ), windows W.focusMaster)
    , ((modMask .|. mod1Mask, xK_h), windows W.swapMaster)
    , ((modMask .|. mod1Mask, xK_j ), windows W.swapDown)
    , ((modMask .|. mod1Mask, xK_k ), windows W.swapUp)

    -- Volume Control
    ,((0, xF86XK_AudioMute), spawn "amixer set Master toggle")
    , ((0, xF86XK_AudioLowerVolume), spawn "amixer set Master 5%- unmute")
    , ((0, xF86XK_AudioRaiseVolume), spawn "amixer set Master 5%+ unmute")
    -- Brightness Control
    , ((0, xF86XK_MonBrightnessDown), spawn "xbacklight -dec 10")
    , ((0, xF86XK_MonBrightnessUp), spawn "xbacklight -inc 10")
    , ((mod1Mask, xK_h), sendMessage Shrink)
    , ((mod1Mask, xK_l), sendMessage Expand)
    -- Push window back into tiling
    , ((modMask .|. mod1Mask, xK_t), withFocused $ windows . W.sink)
    , ((modMask, xK_comma ), sendMessage (IncMasterN 1))
    , ((modMask, xK_period), sendMessage (IncMasterN (-1)))

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    , ((modMask, xK_b), sendMessage ToggleStruts)

    -- Quit xmonad
    , ((modMask .|. shiftMask, xK_c), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modMask, xK_q), spawn "xmonad --recompile; xmonad --restart")
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modMask, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++
 
    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
---spawn
--Keybindings end


-- Workspace-Layout
--myWorkspaces    = ["1:Web","2:term","3:mail","4:files","5:steam","6","7","8","9"]
xmobarEscape = concatMap doubleLts
  where doubleLts '<' = "<<"
        doubleLts x    = [x]
myWorkspaces :: [String]
myWorkspaces = clickable . (map xmobarEscape) $ ["1","2","3","4","5"]
  where
         clickable l = [ "<action=xdotool key alt+" ++ show (n) ++ ">" ++ ws ++ "</action>" |
                             (i,ws) <- zip [1..5] l,
                            let n = i ]



myStartupHook = do
  spawnOnce "/usr/bin/stalonetray"
  spawnOnce "nm-applet"
  spawnOnce "volumeicon"
--  spawnOnce "dropbox"
  spawnOnce "compton -cb"
  spawnOnce "redshift-gtk"
  spawnOnce "xrdb ~/.Xresources"
  spawnOnce "~/.i3/.i3/remapKeys.sh"


myManageHook = composeAll
    [ className =? "stalonetray"    --> doIgnore
      , className =? "Steam"        --> doFullFloat
      , title =? "LIMBO"            --> doIgnore
      , title =? "FEZ"              --> doIgnore
      , title =? "NMRIH"            --> doFullFloat
      , title =? "Portal"            --> doFullFloat
      , className =? "firefox"      --> doFullFloat
      , className =? "mpv"          --> doFullFloat
      , manageDocks
      , isFullscreen                --> (doF W.focusDown <+> doFullFloat)
    ]

-- Mouse bindings
 
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $
 
    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))
 
    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))
 
    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))
 
    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

myLayoutHook = avoidStruts (
        Grid ||| tiled ||| noBorders (fullscreenFull Full) ||| Mirror tiled)
        where
    -- default tiling algorithm partitions the screen into two panes
    tiled   = Tall nmaster delta ratio
 
    -- The default number of windows in the master pane
    nmaster = 1
 
    -- Default proportion of screen occupied by master pane
    ratio   = 1/2
 
    -- Percent of screen to increment by when resizing panes
delta = 3/100 
