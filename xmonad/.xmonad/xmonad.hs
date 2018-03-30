---------------------------------------------------------------------------
--                                                                       --
--     _|      _|  _|      _|                                      _|    --
--       _|  _|    _|_|  _|_|    _|_|    _|_|_|      _|_|_|    _|_|_|    --
--         _|      _|  _|  _|  _|    _|  _|    _|  _|    _|  _|    _|    --
--       _|  _|    _|      _|  _|    _|  _|    _|  _|    _|  _|    _|    --
--     _|      _|  _|      _|    _|_|    _|    _|    _|_|_|    _|_|_|    --
--                                                                       --
---------------------------------------------------------------------------
-- autor: Nicolai Buck
--
---------------------------------------------------------------------------
---------------------------------------------------------------------------
module Main (main) where
-- imports                                                                   {{{
import Data.List -- for `isSuffixOf`
import DBus.Client
import System.Exit
import System.IO
--import System.Taffybar.TaffyPager
--import System.Taffybar.Hooks.PagerHints
import XMonad
import XMonad.Actions.DynamicProjects
import XMonad.Actions.DynamicWorkspaces
import XMonad.Actions.Navigation2D
import XMonad.Actions.SpawnOn
import XMonad.Actions.WindowGo
import XMonad.Config.Desktop
import XMonad.Config.Gnome
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.BinarySpacePartition (emptyBSP)
import XMonad.Layout.BoringWindows
import XMonad.Layout.Decoration
import XMonad.Layout.Gaps
import XMonad.Layout.Grid
import XMonad.Layout.Master
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace
import XMonad.Layout.ResizableTile (ResizableTall(..))
import XMonad.Layout.Spacing
import XMonad.Layout.SubLayouts
import XMonad.Layout.Tabbed
import XMonad.Layout.Simplest
import XMonad.Layout.ToggleLayouts (ToggleLayout(..), toggleLayouts)
import XMonad.Layout.WindowNavigation
import XMonad.ManageHook
import XMonad.Prompt
import XMonad.Prompt.ConfirmPrompt
import XMonad.Prompt.Shell
import XMonad.Util.EZConfig
import XMonad.Util.NamedActions
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run                      -- for spawnPipe and hPutStrLn
import XMonad.Util.SpawnOnce
import qualified Data.Map        as M
import qualified XMonad.StackSet as W
-----------------------------------------------------------------------------}}}
-- main                                                                      {{{

main = do
  client <- connectSession

  xmonad
    $ docks
    $ dynamicProjects projects
    $ withNavigation2DConfig myNav2DConf
    $ ewmh
    $ addDescrKeys' ((myModMask, xK_F1), showKeybindings) myKeys
--    $ pagerHints
    $ myConfig


myConfig = gnomeConfig
    { modMask    = myModMask
    , focusFollowsMouse = False
    , borderWidth = 0
    , workspaces = myWorkspaces
    , manageHook = myManageHook
    , logHook    = dynamicLogString def >>= xmonadPropLog
    , layoutHook = smartBorders myLayoutHook
    , startupHook = myStartupHook
    , terminal = myTerminal
    }
-----------------------------------------------------------------------------}}}
-- Bindings                                                                  {{{
-------------------------------------------------------------------------
wsKeys = map show $ [1..9] ++ [0]
showKeybindings :: [((KeyMask, KeySym), NamedAction)] -> NamedAction
showKeybindings x = addName "Show Keybindings" $ io $ do
    h <- spawnPipe "zenity --text-info --font=System San Francisco Display"
    hPutStr h (unlines $ showKm x)
    hClose h
    return ()

myKeys conf = let

    subKeys str ks = subtitle str : mkNamedKeymap conf ks
    dirKeys        = ["j","k","h","l"]
    dirs           = [ D,  U,  L,  R ]

    zipM  m nm ks as f = zipWith (\k d -> (m ++ k, addName nm $ f d)) ks as
    zipM' m nm ks as f b = zipWith (\k d -> (m ++ k, addName nm $ f d b)) ks as

    in
    subKeys "myBindings"
    (
    [ ("M-<Return>"             , addName "spawn Terminal"                $ spawn myTerminal)
    , ("M-d"                    , addName "spawn Launcher"                $ spawn myLauncher)
    , ("M-M1-q"                 , addName "close Window"                  $ kill)
    , ("M-f"                    , addName "Toggle Fullscreen"             $ sendMessage (Toggle "Full") >> spawn myToggleBar)
    , ("M-<Space>"              , addName "Next Layout"                   $ sendMessage NextLayout)
    , ("M-M1-<Space>"           , addName "Next Sub-Layout"               $ sendMessage NextLayout)
    ]
    ++ zipM "M-"                "View      ws"                            wsKeys [0..] (withNthWorkspace W.greedyView)
    ++ zipM "M-M1-"             "Move w to ws"                            wsKeys [0..] (withNthWorkspace W.shift)
    ) ^++^

    subKeys "movement"
    (
    [ ("M-m h"                  , addName "merge left to group"           $ sendMessage $ pullGroup L)
    , ("M-m j"                  , addName "Merge Tabs with Left"          $ sendMessage $ pullGroup D)
    , ("M-m k"                  , addName "Merge Tabs with Left"          $ sendMessage $ pullGroup U)
    , ("M-m l"                  , addName "Merge Tabs with Left"          $ sendMessage $ pullGroup R)
    , ("M1-j"                   , addName "Move up inTab"                 $ onGroup W.focusUp')
    , ("M1-k"                   , addName "Move up inTab"                 $ onGroup W.focusDown')
    , ("M1-h"                   , addName "Move up inTab"                 $ withFocused (sendMessage . UnMerge))
    ]
    ++ zipM' "M-"               "Move Focus"                              dirKeys dirs windowGo True
    ++ zipM' "M-M1-"            "Move Window"                             dirKeys dirs windowSwap True
--    , ("M1-l"                   , addName "Shrink focused window"         $ sendMessage Shrink)
--    , ("M1-h"                   , addName "Expand focused window"         $ sendMessage Expand)
    ) ^++^

    subKeys "Actions"
    [ ("<Print>"                , addName "Screenshot the whole display"  $ spawn "scrot '%Y-%m-%d-%H-%M-%S_$wx$h.png' -e 'mv $f ~/Pictures/Screenshots/'")
    , ("M-<Print>"              , addName "Screenshot the focused window" $ spawn "scrot -u '%Y-%m-%d-%H-%M-%S_$wx$h.png' -e 'mv $f ~/Pictures/Screenshots/'")
    , ("<XF86AudioMute>"        , addName "Mute audio"                    $ spawn "amixer set Master toggle")
    , ("<XF86AudioLowerVolume>" , addName "decrease volume"               $ spawn "amixer set Master 10%- unmute")
    , ("<XF86AudioRaiseVolume>" , addName "increase volume"               $ spawn "amixer set Master 10%+ unmute")
    , ("<XF86MonBrightnessUp>"  , addName "increase backlight"            $ spawn "xbacklight -inc 9")
    , ("<XF86MonBrightnessDown>", addName "decrease backlight"            $ spawn "xbacklight -dec 15")
    , ("M-b"                    , addName "toggle bar"                    $ spawn myToggleBar)
    , ("M-t"                    , addName "Scratchpad Terminal"           $ namedScratchpadAction scratchpads "trello")
    , ("M-c"                    , addName "Scratchpad Terminal"           $ namedScratchpadAction scratchpads "console")
    , ("M-M1-r"                 , addName "recompile xmonad"              $ spawn "xmonad --recompile; xmonad --restart")
    ] ^++^

    subKeys "Exit's"
    [ ("M-M1-e l"               , addName "Lock screen"                   $ spawn "~/.i3/mylock.sh")
    , ("M-M1-e e"               , addName "Logout"                        $ io (exitWith ExitSuccess))
    , ("M-M1-e p"               , addName "Poweroff"                      $ spawn "systemctl poweroff -i")
    , ("M-M1-e r"               , addName "Reboot"                        $ spawn "systemctl reboot")
    , ("M-S-q"                  , addName "Logout2"                       $  confirmPrompt promptConfig "exit" (io exitSuccess))
    ]

-----------------------------------------------------------------------------}}}
-- Layouts                                                                   {{{
--------------------------------------------------------------------------------
-- | Customize layouts.
--
-- This layout configuration uses two primary layouts, 'ResizableTall'
-- and 'BinarySpacePartition'.  You can also use the 'M-<Esc>' key
-- binding defined above to toggle between the current layout and a
-- full screen layout.
--myLayoutHook = desktopLayoutModifiers $ myLayouts

gap = 8
myGaps = gaps [(U, gap), (D, gap), (R, gap), (L, gap)]-- $ Tall 1 (3/100) (1/2) ||| Full
mySpacing = spacing gap
myFont = "xft:Hack-Regular:size=12:style=bold"
myTabTheme = def
  { fontName              = myFont
  , activeColor           = "#1793d0"
  , inactiveColor         = "#2f343f"
  , decoHeight            = 15
  , activeBorderColor     = "#1793d0"
  , inactiveBorderColor   = "#2f343f"
  , activeTextColor       = "#f3f4f5"
  , inactiveTextColor     = "#676e7d"
  }
myNav2DConf = def 
  { defaultTiledNavigation  = centerNavigation
  , floatNavigation         = centerNavigation
  , screenNavigation        = lineNavigation
  , layoutNavigation        = [("Full", centerNavigation)]
  , unmappedWindowRect      = [("Full", singleWindowRect)]
  }

myResizable      = mySpacing $ ResizableTall 1 (1.5/100) (3/5) []               -- for WS2 (M)
myRT1            = mySpacing $ (ResizableTall 1 (1/100) (1/2) [])
myRT2            = mySpacing $ (ResizableTall 2 (1/100) (2/3) [])
myMRT1           = mySpacing $ (Mirror (ResizableTall 1 (1/100) (2/3) []))
myMRT2           = mySpacing $ (Mirror (ResizableTall 2 (1/100) (2/3) []))
myMGR            = mySpacing $ (multimastered 2 (1/100) (1/3) $ GridRatio (16/10))
myBSP            = mySpacing $ emptyBSP
myFullTabbed     = myGaps $ (noBorders mytabbed)
mytabbed         = tabbed shrinkText myTabTheme

myWsLayout2         =  myResizable    |||  myMRT1         ||| myMRT2
myWsLayout4         =  myBSP          |||  myResizable
defaultLayout       =  myResizable    |||  myFullTabbed   ||| myBSP

myLayoutHook = avoidStruts
        $ windowNavigation
--        $ minimize
        $ toggleLayouts (noBorders Full)
--        $ mySpacing
        $ (addTabs shrinkText myTabTheme)
        $ boringWindows
        $ subLayout [] (Simplest)
        $ onWorkspace ws4 myWsLayout4
        $ onWorkspace ws2 myWsLayout2
        $ defaultLayout
-----------------------------------------------------------------------------}}}
-- default-config                                                            {{{
--------------------------------------------------------------------------------
-- | Manipulate windows as they are created.  The list given to
-- @composeOne@ is processed from top to bottom.  The first matching
-- rule wins.
myToggleBar = "dbus-send --print-reply=literal --dest=taffybar.toggle /taffybar/toggle taffybar.toggle.toggleCurrent"
myTerminal = "termite"
myBrowser = "chromium"
myLauncher = "exec rofi -show run"
myModMask = mod4Mask

promptConfig = defaultXPConfig
  { font        = "xft:System San Francisco Display:pixelsize=15"
  , borderColor = "#222832"
  , fgColor     = "#d3d4d5"
  , fgHLight    = "#ffffff"
  , bgColor     = "#222832"
  , bgHLight    = "#5f5f5f"
  , height      = 32
  , position    = Top
  }

myManageHook :: ManageHook
myManageHook = manageSpecific
    <+> manageDocks
    <+> namedScratchpadManageHook scratchpads
--    <+> fullscreenManageHook
    <+> manageSpawn
    where
      manageSpecific = composeOne -- use Just for only one match
        [ isDialog       -?> doCenterFloat
        , isFullscreen   -?> doFullFloat
        ,  className     =? "Gimp-2.8"   -?>  doShift wsGimp -- may be "Gimp" or "Gimp-2.4" instead
        , (className     =? "Gimp-2.8"   <&&> fmap ("tool" `isSuffixOf`) (stringProperty "WM_WINDOW_ROLE")) -?> doFloat
        , className      =? "Steam"      -?>  doShift ws5
        ]
-----------------------------------------------------------------------------}}}
-- workspaces scratchpads                                                    {{{
ws1 = "1:Browser"
ws2 = "2:Terminal"
ws3 = "3:Tex"
ws4 = "4:Chat"
ws5 = "5:Steam"
ws6 = "6"
ws7 = "7"
ws8 = "8"
wsGimp = "Gimp"

myWorkspaces = [ws1, ws2, ws3, ws4, ws5, ws6, ws7, ws8, wsGimp]
projects :: [Project]
projects =

  [ Project     { projectName = ws1
                , projectDirectory = "~/"
                , projectStartHook = Just $ do spawnOn ws1 myBrowser
                }
  , Project     { projectName = ws2
                , projectDirectory = "~/"
                , projectStartHook = Just $ do spawnOn ws2 myTerminal
                                               spawnOn ws2 myTerminal
                }
  , Project     { projectName = ws3
                , projectDirectory = "~/"
                , projectStartHook = Just $ do spawnOn ws3 myTerminal
                                               spawnOn ws3 "evince"
                }
  , Project     { projectName = ws4
                , projectDirectory = "~/"
                , projectStartHook = Just $ do spawnOn ws4 "telegram"
                                               spawnOn ws4 "thunderbird"
                }
  , Project     { projectName = ws5
                , projectDirectory = "~/"
                , projectStartHook = Just $ do spawnOn ws5 "steam"
                }
  , Project     { projectName = ws6
                , projectDirectory = "~/"
                , projectStartHook = Nothing
                }
  , Project     { projectName = ws2
                , projectDirectory = "~/"
                , projectStartHook = Nothing
                }
  ]

isTerminal  = (className =? "Termite") <&&> (stringProperty "WM_WINDOW_ROLE" =? "Scratchpad")
isTrello    = (className =? "Trello")  <&&> (stringProperty "WM_WINDOW_ROLE" =? "browser-window")
spTerminal  = "termite --role=Scratchpad --config=$HOME/.config/termite/config.xmonad"
spTrello    = "trello"
scratchpads =
  [ (NS "console" spTerminal isTerminal   (customFloating $ W.RationalRect (1/16) (1/16) (4/6) (3/4)) )
  , (NS "trello"  spTrello   isTrello     (customFloating $ W.RationalRect (1/56) (1/24) (6/10) (3/4)) )
  ]
-----------------------------------------------------------------------------}}}
-- startup/apps                                                              {{{

myStartupHook = do
--  startupHook gnomeConfig
  startupHook desktopConfig
--  spawnOnce "taffybar ~/.xmonad/taffybar.hs" -- Start a task bar such as xmobar.
--  spawnOnce "~/.scripts/toggleMonitor left-on"
  spawnOnce "~/.local/bin/my-taffybar" -- Start a task bar such as xmobar.
  spawnOnce "sleep 1 && feh --bg-scale ~/Pictures/wallpaper/background5.jpg"
  spawnOnce "/usr/bin/stayalonetray"
  spawnOnce "compton -b -f --inactive-dim 0.2 -I 0.1 -O 0.1 -D 20"
  spawnOnce "xrdb ~/.Xresources"
  spawnOnce "~/.i3/remapKeys.sh"
  spawnOnce "sleep 1 && nm-applet"
  spawnOnce "sleep 2 && redshift-gtk"
  spawnOnce "sleep 3 && xfce4-power-manager"
  spawnOnce "xsetroot -cursor_name left_ptr"

  activateProject $ projects !! 0
  activateProject $ projects !! 1
  activateProject $ projects !! 2
  activateProject $ projects !! 3
  activateProject $ projects !! 4

-----------------------------------------------------------------------------}}}
-- vim: ft=haskell:foldmethod=marker:expandtab:ts=4:shiftwidth=4
