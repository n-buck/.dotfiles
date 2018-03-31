{-# LANGUAGE PackageImports #-}
module Main where
import System.Taffybar.ToggleMonitor
import System.Information.CPU
import System.Information.Memory
import System.Taffybar
import System.Taffybar.DiskIOMonitor
import System.Taffybar.FreedesktopNotifications
import System.Taffybar.MPRIS
import System.Taffybar.MPRIS2
import System.Taffybar.NetMonitor
import System.Taffybar.Pager
import System.Taffybar.SimpleClock
import System.Taffybar.Systray
import System.Taffybar.TaffyPager
import System.Taffybar.Weather
import System.Taffybar.Widgets.PollingBar
import System.Taffybar.Widgets.PollingGraph
import System.Taffybar.WindowSwitcher
import System.Taffybar.WorkspaceHUD
import qualified "gtk3" Graphics.UI.Gtk as Gtk
import qualified "gtk3" Graphics.UI.Gtk.Abstract.Widget as W
import qualified "gtk3" Graphics.UI.Gtk.Layout.Table as T

main = do
  let diskCfg = defaultGraphConfig {
          graphDataColors = [archBlue_taffy]
        , graphLabel = Just "ssd"
        , graphWidth = 30
        , graphBorderColor = myBorderColor
        }
      memCfg  = defaultGraphConfig {
          graphDataColors = [archBlue_taffy]
        , graphLabel = Just "mem"
        , graphWidth = 30
        , graphBorderColor = myBorderColor
        }
      cpuCfg  = defaultGraphConfig {
          graphDataColors = [archBlue_taffy]
        , graphLabel = Just "cpu"
        , graphWidth = 30
        , graphBorderColor = myBorderColor
        }
      myPagerConf = defaultPagerConfig {
          activeWindow     = colorize base2 "" . escape . shorten 20
        , activeLayout     = colorize "gray" "" --const ""
        , activeWorkspace  = colorize archBlue "" . escape  -- focused
        , hiddenWorkspace  = escape                         -- unfocused
        , emptyWorkspace   = const ""
        , visibleWorkspace = escape
        , urgentWorkspace  = colorize red yellow . escape
        , widgetSep        = ""
        }
      taffyConfig = defaultTaffybarConfig {
          startWidgets = [ pager, note ]
        , endWidgets = reverse [ mpris2 , net , mem , disk , cpu , tray , clock ]
        , barPosition = Top
        , System.Taffybar.barPadding = 0
        , barHeight = 20
        , widgetSpacing = 15
        }

      clock       = textClockNew Nothing "%a %b %_d   %H:%M " 1
      note        = notifyAreaNew defaultNotificationConfig
      mpris       = mprisNew defaultMPRISConfig
      mem         = pollingGraphNew memCfg 1 memCallback
      cpu         = pollingGraphNew cpuCfg 0.5 cpuCallback
      tray        = systrayNew
      mpris2      = mpris2New
      net         = netMonitorNew 1 "wlp4s0"
      disk        = dioMonitorNew diskCfg 0.5 "sda"
      pager       = taffyPagerNew myPagerConf

  withToggleSupport taffyConfig

memCallback = do
  mi <- parseMeminfo
  return [memoryUsedRatio mi]

cpuCallback = do
  (userLoad, systemLoad, totalLoad) <- cpuLoad
  return [totalLoad, systemLoad]


base2    = "#eee8d5" -- (light) Background highlights
yellow   = "#b58900"
red      = "#dc322f"
archBlue  = "#1793d1"
archBlue_taffy = (23/255,147/255,193/255,1)
myBorderColor  = (50/255,56/255,66/255)
