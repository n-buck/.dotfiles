{-# LANGUAGE PackageImports #-}
module Main where
import System.Taffybar
import System.Taffybar.Battery
import System.Taffybar.MPRIS2
import System.Taffybar.NetMonitor
import System.Taffybar.Pager
import System.Taffybar.SimpleClock
import System.Taffybar.Systray
import System.Taffybar.TaffyPager
import System.Taffybar.Weather
import System.Taffybar.Widgets.PollingGraph
import System.Information.CPU
import System.Information.Network

import qualified "gtk3" Graphics.UI.Gtk as Gtk
import qualified "gtk3" Graphics.UI.Gtk.Abstract.Widget as W
import qualified "gtk3" Graphics.UI.Gtk.Layout.Table as T

cpuCallback = do
  (_, systemLoad, totalLoad) <- cpuLoad
  return [ totalLoad, systemLoad ]
--netCallback = do
--  (b_in, b_out) <- getNetInfo

main = do
  let cpuCfg = defaultGraphConfig { graphDataColors = [arcBlue_taffy]
                                  , graphLabel = Just "cpu"
                                  }
  let battWid = batteryBarNew defaultBatteryConfig 30
  let pager = taffyPagerNew PagerConfig
                            { activeWindow     = colorize base2 "" . escape . shorten 50
                            , activeLayout     = const ""
                            , activeWorkspace  = colorize arcBlue "" . escape  -- focused
                            , hiddenWorkspace  = escape -- unfocused
                            , emptyWorkspace   = const ""
                            , visibleWorkspace = wrap "(" ")" . escape
                            , urgentWorkspace  = colorize red yellow . escape
                            , widgetSep        = " "
                            }
    -- weather broken: use this link? https://www.accuweather.com/de/ch/illnau/316471/current-weather/316471?lang=de
--      wea = weatherNew (defaultWeatherConfig "KNYC") { weatherTemplate = "$tempC$ C" } 10
      clock = textClockNew Nothing "%a %b %_d %H:%M" 1
      tray = systrayNew
      cpu = pollingGraphNew cpuCfg 0.5 cpuCallback
      mpris2 = mpris2New
      net = netMonitorNew 1 "wlp4s0"

  defaultTaffybar defaultTaffybarConfig { startWidgets = [ pager ]
                                        , endWidgets = reverse [
                                              mpris2
                                            , net
                                            , cpu
--                                            , battWid
                                            , tray
--                                            , makeContents clock "Cpu" ]
                                            , clock ]
                                        }



-- Solarized colors
base03   = "#002b36" -- (dark)  Background
base02   = "#073642" -- (dark)  Background highlights
base01   = "#586e75" -- (dark)  Comments / Secondary content | (light) Optional emphasized content
base00   = "#657b83" -- (light) Body text / Default code / Primary content
base0    = "#839496" -- (dark)  Body text / Default code / Primary content
base1    = "#93a1a1" -- (dark)  Optional emphasized content | (light) Comments / Secondary content
base2    = "#eee8d5" -- (light) Background highlights
base3    = "#fdf6e3" -- (light) Background
yellow   = "#b58900"
orange   = "#cb4b16"
red      = "#dc322f"
magenta  = "#d33682"
violet   = "#6c71c4"
blue     = "#268bd2"
cyan     = "#2aa198"
green    = "#859900"
arcBlue  = "#1793d1"
arcBlue_taffy = (23/255,147/255,193/255,1)
