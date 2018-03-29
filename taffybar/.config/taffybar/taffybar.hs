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
import System.Taffybar.WorkspaceHUD
import qualified "gtk3" Graphics.UI.Gtk as Gtk
import qualified "gtk3" Graphics.UI.Gtk.Abstract.Widget as W
import qualified "gtk3" Graphics.UI.Gtk.Layout.Table as T



archBlue  = "#1793d1"
archBlue_taffy = (23/255,147/255,193/255,1)

memCallback = do
  mi <- parseMeminfo
  return [memoryUsedRatio mi]

cpuCallback = do
  (userLoad, systemLoad, totalLoad) <- cpuLoad
  return [totalLoad, systemLoad]

main = do
  let pgrConf = defaultPagerConfig { widgetSep        = " " }

      myHUDConfig =
              defaultWorkspaceHUDConfig
              { underlineHeight = 1
              , underlinePadding = 1
              , borderWidth = 0
              , minWSWidgetSize = Nothing
              , windowIconSize = 17
              , widgetGap = 3
              , showWorkspaceFn = hideEmpty
              , updateRateLimitMicroseconds = 100000
              , updateOnWMIconChange = True
              , urgentWorkspaceState = True
              , debugMode = False
--              , getIconInfo = myGetIconInfo
--              , labelSetter = workspaceNamesLabelSetter
              }

      diskCfg = defaultGraphConfig { graphDataColors = [archBlue_taffy]
                                  , graphLabel = Just "ssd"
                                  }
      memCfg  = defaultGraphConfig { graphDataColors = [archBlue_taffy]
                                  , graphLabel = Just "mem"
                                  }
      cpuCfg  = defaultGraphConfig { graphDataColors = [archBlue_taffy]
                                  , graphLabel = Just "cpu"
                                  }
      clock       = textClockNew Nothing "%a %b %_d   %H:%M " 1
      note        = notifyAreaNew defaultNotificationConfig
      mpris       = mprisNew defaultMPRISConfig
      mem         = pollingGraphNew memCfg 1 memCallback
      cpu         = pollingGraphNew cpuCfg 0.5 cpuCallback
      tray        = systrayNew
      mpris2      = mpris2New
      net         = netMonitorNew 1 "wlp4s0"
      pagerConfig = defaultPagerConfig {useImages = True, activeLayout = const "layout"}
      disk        = dioMonitorNew diskCfg 0.5 "sda"
  pgr             <- pagerNew pagerConfig
  let hud         = buildWorkspaceHUD myHUDConfig pgr

      taffyConfig =
        defaultTaffybarConfig
        { startWidgets = [ hud, note ]
        , endWidgets = reverse [
              mpris2
            , net
            , mem
            , disk
            , cpu
            , tray
            , clock ]

        , barPosition = Top
        , System.Taffybar.barPadding = 0
        , barHeight = (underlineHeight myHUDConfig + windowIconSize myHUDConfig + 15)
        , widgetSpacing = 15
        }

  withToggleSupport taffyConfig
