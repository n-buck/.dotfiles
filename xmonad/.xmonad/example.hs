--------------------------------------------------------------------------------
-- | Example.hs
--
-- Example configuration file for xmonad using the latest recommended
-- features (e.g., 'desktopConfig').
module Main (main) where

--------------------------------------------------------------------------------
import System.Exit
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

--------------------------------------------------------------------------------
main = do
  spawn "xmobar" -- Start a task bar such as xmobar.

  -- Start xmonad using the main desktop configuration with a few
  -- simple overrides:
  xmonad $ desktopConfig
    { modMask    = mod4Mask -- Use the "Win" key for the mod key
    , manageHook = myManageHook <+> manageHook desktopConfig
    , layoutHook = desktopLayoutModifiers $ myLayouts
    , logHook    = dynamicLogString def >>= xmonadPropLog
    }

    `additionalKeysP` -- Add some extra key bindings:
      [ ("M-S-q",   confirmPrompt myXPConfig "exit" (io exitSuccess))
      , ("M-p",     shellPrompt myXPConfig)
      , ("M-<Esc>", sendMessage (Toggle "Full"))
--    own bindings
      , ("M-M1-q",   confirmPrompt myXPConfig "exit" (io exitSuccess))
      , ("M-<Return>", spawn "termite")
      , ("M-d", spawn "exec rofi -show run")
      , ("M-M1, d", spawn "gmrun")
      , ("M-M1, q", spawn kill)
      , ("M-<Space>", spawn sendMessage NextLayout)
      --  Reset the layouts on the current workspace to default
      , ("M-M1-<Space>", setLayout $ XMonad.layoutHook conf)
    -- Resize viewed windows to the correct size
--    , ((modMask,               xK_n     ), refresh)
    -- Move focus to the next window
    , ((modMask,               xK_j     ), windows W.focusDown)
    -- Move focus to the previous window
    , ((modMask,               xK_k     ), windows W.focusUp  )
    -- Move focus to the master window
    , ((modMask,               xK_h     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modMask .|. mod1Mask, xK_h), windows W.swapMaster)
    -- Swap the focused window with the next window
    , ((modMask .|. mod1Mask, xK_j     ), windows W.swapDown  )
    -- Swap the focused window with the previous window
    , ((modMask .|. mod1Mask, xK_k     ), windows W.swapUp    )

    -- Volume Control
    ,((0, xF86XK_AudioMute), spawn "amixer set Master toggle")
    , ((0, xF86XK_AudioLowerVolume), spawn "amixer set Master 5%- unmute")
    , ((0, xF86XK_AudioRaiseVolume), spawn "amixer set Master 5%+ unmute")
    -- Brightness Control
    , ((0, xF86XK_MonBrightnessDown), spawn "xbacklight -dec 10")
    , ((0, xF86XK_MonBrightnessUp), spawn "xbacklight -inc 10")

    -- Shrink the master area
    , ((mod1Mask,               xK_h     ), sendMessage Shrink)
    -- Expand the master area
    , ((mod1Mask,               xK_l     ), sendMessage Expand)
    -- Push window back into tiling
    , ((modask .|. mod1Mask,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modMask              , xK_comma ), sendMessage (IncMasterN 1))
    -- Deincrement the number of windows in the master area
    , ((modMask              , xK_period), sendMessage (IncMasterN (-1)))

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    -- , ((modm              , xK_b     ), sendMessage ToggleStruts)

    -- Quit xmonad
    , ((modMask .|. shiftMask, xK_c     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modMask              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")
    ]
      ]

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

--------------------------------------------------------------------------------
-- | Customize the way 'XMonad.Prompt' looks and behaves.  It's a
-- great replacement for dzen.
myXPConfig = def
  { position          = Top
  , alwaysHighlight   = True
  , promptBorderWidth = 0
  , font              = "xft:monospace:size=9"
  }

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
