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
import System.Exit
import System.IO
import XMonad
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.BinarySpacePartition (emptyBSP)
import XMonad.Layout.NoBorders (noBorders)
import XMonad.Layout.ResizableTile (ResizableTall(..))
import XMonad.Layout.ToggleLayouts (ToggleLayout(..), toggleLayouts)
import XMonad.Prompt
import XMonad.Prompt.ConfirmPrompt
import XMonad.Prompt.Shell
import XMonad.Util.EZConfig

import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import XMonad.Hooks.ManageDocks
import XMonad.Util.SpawnOnce
import XMonad.Hooks.EwmhDesktops
import System.Taffybar.Hooks.PagerHints
import DBus.Client
import System.Taffybar.XMonadLog ( dbusLog )
-----------------------------------------------------------------------------}}}
-- main                                                                      {{{
main = do
  spawn "taffybar ~/.xmonad/taffybar.hs" -- Start a task bar such as xmobar.
  spawn "feh --bg-scale ~/Pictures/wallpaper/background5.jpg"
  client <- connectSession
  let pp = defaultPP

  xmonad
    $ docks
    $ ewmh
    $ pagerHints desktopConfig
    { modMask    = mod4Mask -- Use the "Win" key for the mod key
    , manageHook = myManageHook <+> manageHook desktopConfig
    , logHook    = dynamicLogString def >>= xmonadPropLog
--    , manageHook = manageDocks
--    , logHook    = dbusLog client pp
    , layoutHook = desktopLayoutModifiers $ myLayouts
    , startupHook = myStartupHook
    }
-----------------------------------------------------------------------------}}}
-- Bindings                                                           {{{
-------------------------------------------------------------------------

    `additionalKeysP` -- Add some extra key bindings:
      [ ("M-<Return>",  spawn "termite")
      , ("M-d",         spawn "exec rofi -show run")
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
      , ("M-M1-e",                     io (exitWith ExitSuccess))
      , ("M-M1-r",                  spawn "xmonad --recompile; xmonad --restart")
--      , ("M-S-q",   confirmPrompt myXPConfig "exit" (io exitSuccess))
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
myLayouts = toggleLayouts (noBorders Full) others
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
-- startup                                                                   {{{
myStartupHook = do
  startupHook desktopConfig
  spawnOnce "/usr/bin/stayalonetray"
  spawnOnce "nm-applet"
  spawnOnce "compton -b -f --inactive-dim 0.2 -I 0.1 -O 0.1 -D 20"
  spawnOnce "redshift -gtk"
  spawnOnce "xrdb ~/.Xresources"
  spawnOnce "~/.i3/remapKeys.sh"
-- vim: ft=haskell:foldmethod=marker:expandtab:ts=4:shiftwidth=4
