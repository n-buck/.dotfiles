{-# LANGUAGE ScopedTypeVariables, ExistentialQuantification, RankNTypes, PackageImports #-}
-----------------------------------------------------------------------------
-- |
-- Module      : System.Taffybar.WorkspaceHUD
-- Copyright   : (c) Ivan A. Malison
-- License     : BSD3-style (see LICENSE)
--
-- Maintainer  : Ivan A. Malison
-- Stability   : unstable
-- Portability : unportable
--
-- Composite widget that displays all currently configured workspaces and
-- allows to switch to any of them by clicking on its label. Supports also
-- urgency hints and (with an additional hook) display of other visible
-- workspaces besides the active one (in Xinerama or XRandR installations).
--
-- N.B. If you're just looking for a drop-in replacement for the
-- "System.Taffybar.XMonadLog" widget that is clickable and doesn't require
-- DBus, you may want to see first "System.Taffybar.TaffyPager".
--
-----------------------------------------------------------------------------

module System.Taffybar.WorkspaceHUD (
  Workspace(..),
  WorkspaceWidgetController(..),
  WorkspaceHUDConfig(..),
  WorkspaceWidget(..),
  buildWorkspaces,
  getWorkspaceToWindows
) where

import qualified Control.Concurrent.MVar as MV
import           Control.Monad
import qualified Data.Map as M
import qualified Data.MultiMap as MM
import qualified "gtk3" Graphics.UI.Gtk as Gtk
import           System.Information.EWMHDesktopInfo
import           System.Information.EWMHDesktopInfo
import           System.Taffybar.Pager

data WorkspaceState = Active | Visible | Hidden | Empty deriving (Show, Eq)

data Workspace =
  Workspace { workspaceIdx :: WorkspaceIdx
            , workspaceName :: String
            , workspaceState :: WorkspaceState
            , windowIds :: [X11Window]
            } deriving (Show, Eq)

class WorkspaceWidgetController wc where
  updateWidget :: wc -> Workspace -> IO wc

data WorkspaceWidget =
  forall a. WorkspaceWidgetController a =>
            WorkspaceWidget a

data WorkspaceHUDConfig =
  forall wc. WorkspaceWidgetController wc =>
         WorkspaceHUDConfig
         { widgetBuilder :: Gtk.EventBox -> WorkspaceHUDConfig -> Workspace -> wc
         , widgetGap :: Int
         }

-- | Get a list of windows for each workspace.
getWorkspaceToWindows :: IO (MM.MultiMap WorkspaceIdx X11Window)
getWorkspaceToWindows =
  withDefaultCtx getWindows >>=
  foldM
    (\theMap window ->
       MM.insert <$> withDefaultCtx (getWorkspace window)
                 <*> pure window <*> pure theMap)
    MM.empty

buildWorkspaces :: IO (M.Map WorkspaceIdx Workspace)
buildWorkspaces = do
  names <- withDefaultCtx getWorkspaceNames
  workspaceToWindows <- getWorkspaceToWindows
  active:visible <- withDefaultCtx getVisibleWorkspaces

  let getWorkspaceState idx windows
        | idx == active = Active
        | elem idx visible = Visible
        | null windows = Empty
        | otherwise = Hidden

  return $ foldl (\theMap (idx, name) ->
                    let windows = MM.lookup idx workspaceToWindows in
                    M.insert idx
                     Workspace { workspaceIdx = idx
                               , workspaceName = name
                               , workspaceState = getWorkspaceState idx windows
                               , windowIds = windows
                               } theMap) M.empty names

buildWorkspaceHUD :: WorkspaceHUDConfig -> Pager -> IO Gtk.Widget
buildWorkspaceHUD config pager = do
  widget <- Gtk.hBoxNew False (widgetGap config)

  workspaces <- buildWorkspaces
  -- controllersRef <- MV.newMVar

  return $ Gtk.toWidget widget
  -- let cfg = config pager
  --     activecb = activeCallback cfg deskRef
  --     activefastcb = activeFastCallback cfg deskRef
  --     redrawcb = redrawCallback pager deskRef switcher
  --     urgentcb = urgentCallback cfg deskRef
  -- subscribe pager activecb "_NET_CURRENT_DESKTOP"
  -- subscribe pager activefastcb "_NET_WM_DESKTOP"
  -- subscribe pager redrawcb "_NET_DESKTOP_NAMES"
  -- subscribe pager redrawcb "_NET_NUMBER_OF_DESKTOPS"
  -- subscribe pager urgentcb "WM_HINTS"

  -- return $ Gtk.toWidget switcher
