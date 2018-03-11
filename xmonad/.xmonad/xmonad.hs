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
import DBus.Client
import System.Exit
import System.IO
import System.Taffybar.TaffyPager
import System.Taffybar.Hooks.PagerHints
import XMonad
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.BinarySpacePartition (emptyBSP)
import XMonad.Layout.Gaps
import XMonad.Layout.NoBorders (noBorders)
import XMonad.Layout.ResizableTile (ResizableTall(..))
import XMonad.Layout.Spacing
import XMonad.Layout.ToggleLayouts (ToggleLayout(..), toggleLayouts)
import XMonad.Prompt
import XMonad.Prompt.ConfirmPrompt
import XMonad.Prompt.Shell
import XMonad.Util.EZConfig
import XMonad.Util.SpawnOnce
import qualified Data.Map        as M
import qualified XMonad.StackSet as W
-----------------------------------------------------------------------------}}}
-- main                                                                      {{{
main = do
  spawn "taffybar ~/.xmonad/taffybar.hs" -- Start a task bar such as xmobar.
  spawn "feh --bg-scale ~/Pictures/wallpaper/background5.jpg"
  client <- connectSession

  xmonad
    $ docks
    $ ewmh
    $ pagerHints
    $ myConfig


myConfig = def
    { modMask    = mod4Mask -- Use the "Win" key for the mod key
    , borderWidth = 0
    , manageHook = myManageHook <+> manageHook desktopConfig
    , logHook    = dynamicLogString def >>= xmonadPropLog
    , layoutHook = myLayoutHook
    , startupHook = myStartupHook
    , terminal = myTerminal
    }
-----------------------------------------------------------------------------}}}
-- Bindings                                                                  {{{
-------------------------------------------------------------------------

    `additionalKeysP` -- Add some extra key bindings:
      [ ("M-<Return>",  spawn myTerminal)
      , ("M-d",         spawn myLauncher)
      , ("M-M1-q",      kill)
      , ("M-f",         sendMessage (Toggle "Full"))
      , ("M-<Space>",   sendMessage NextLayout)
--      , ("M-M1-<Space>",setLayout $ XMonad.layoutHook conf)
      , ("M-n",         refresh)
      -- movement
      , ("M-j",         windows W.focusDown)
      , ("M-k",         windows W.focusUp)
      , ("M-h",         windows W.focusMaster)
--      , ("M-h",         windows swap)
      , ("M-M1-j",      windows W.swapDown)
      , ("M-M1-k",      windows W.swapUp)
      , ("M-M1-h",      windows W.swapMaster)
      , ("M1-l",        sendMessage Shrink)
      , ("M1-h",        sendMessage Expand)

      , ("<XF86AudioMute>",         spawn "amixer set Master toggle")
      , ("<XF86AudioLowerVolume>",  spawn "amixer set Master 5%- unmute")
      , ("<XF86AudioRaiseVolume>",  spawn "amixer set Master 5%+ unmute")

      , ("<XF86BrightnessUp>",      spawn "xbacklight -inc 15")
      , ("<XF86BrightnessDown>",    spawn "xbacklight -dec 20")
      -- Toggle status bar -> Hooks.ManageDocks ? DynamicLog
      , ("M-b",                     sendMessage ToggleStruts)
      , ("M-M1-r",                  spawn "xmonad --recompile; xmonad --restart")
--      , ("M-S-q",   confirmPrompt myXPConfig "exit" (io exitSuccess))
      -- Power
      , ("M-M1-e l",                     spawn "~/.i3/mylock.sh")
      , ("M-M1-e e",                     io (exitWith ExitSuccess))
      , ("M-M1-e r",                     spawn "systemctl reboot")
      , ("M-M1-e p",                     spawn "systemctl poweroff -i")
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
gap = 5
myGaps = gaps [(U, gap), (D, gap), (R, gap), (L, gap)]-- $ Tall 1 (3/100) (1/2) ||| Full
mySpacing = spacing gap
myLayoutHook = avoidStruts
             $ myGaps
             $ mySpacing
             $ others
      where
        others = ResizableTall 1 (1.5/100) (3/5) [] ||| emptyBSP
-----------------------------------------------------------------------------}}}
-- default-config                                                            {{{
--------------------------------------------------------------------------------
-- | Customize the way 'XMonad.Prompt' looks and behaves.  It's a
-- great replacement for dzen.
--myXPConfig = def
--  { position          = Top
--  , alwaysHighlight   = True
--  , promptBorderWidth = 0
--  , font              = "xft:monospace:size=9"
--  }

--------------------------------------------------------------------------------
-- | Manipulate windows as they are created.  The list given to
-- @composeOne@ is processed from top to bottom.  The first matching
-- rule wins.
--
-- Use the `xprop' tool to get the info you need for these matches.
-- For className, use the second value that xprop gives you.
myManageHook = composeOne
  [ className =? "Pidgin" -?> doFloat
  , className =? "XCalc"  -?> doFloat
  , className =? "mpv"    -?> doFloat
  , isDialog              -?> doCenterFloat

    -- Move transient windows to their parent:
  , transience
  ]
-----------------------------------------------------------------------------}}}
-- startup/apps                                                              {{{
myTerminal = "termite"
myLauncher = "exec rofi -show run"

myStartupHook = do
  startupHook desktopConfig
  spawnOnce "/usr/bin/stayalonetray"
  spawnOnce "nm-applet"
  spawnOnce "compton -b -f --inactive-dim 0.2 -I 0.1 -O 0.1 -D 20"
  spawnOnce "redshift -gtk"
  spawnOnce "xrdb ~/.Xresources"
  spawnOnce "~/.i3/remapKeys.sh"
-- vim: ft=haskell:foldmethod=marker:expandtab:ts=4:shiftwidth=4
