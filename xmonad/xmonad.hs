--
-- xmonad example config file.
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--

-- Imports

import XMonad
import Data.Monoid
import System.Exit

-- Utils
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run
import XMonad.Util.SpawnOnce

-- Hooks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.UrgencyHook

-- Layouts
import XMonad.Layout.FixedColumn
import XMonad.Layout.Named
import XMonad.Layout.NoBorders (noBorders)
import XMonad.Layout.NoFrillsDecoration
import XMonad.Layout.Renamed
import XMonad.Layout.Simplest
import XMonad.Layout.Spacing
import XMonad.Layout.SubLayouts
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns
import XMonad.Layout.WindowNavigation



-- Keyboard
import Graphics.X11.ExtraTypes.XF86

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask       = mod4Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces = ["home", "work", "text", "chat", "media", "syst"] ++ map show [7..9] ++ ["0"]

-------------------------------------------------------------------------------
-- Applications                                                              --
-------------------------------------------------------------------------------
myTerminal      = "gnome-terminal"

slackCommand  = "slack"
slackResource = "slack"
isSlack       = (resource =? slackResource)

spotifyCommand  = "spotify"
spotifyInfix    = "Spotify"
spotifyResource = "spotify"
isSpotify       = (className =? "spotify")

scratchpads = 
  [ (NS "slack"  slackCommand isSlack defaultFloating)
  ]

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)

    -- launch dmenu
    , ((modm,               xK_p     ), spawn "dmenu_run")

    -- launch gmrun
    , ((modm .|. shiftMask, xK_p     ), spawn "gmrun")

    -- close focused window
    , ((modm .|. shiftMask, xK_c     ), kill)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)

    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm,               xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Merge groups into tabs
    , ((modm .|. controlMask, xK_h), sendMessage $ pullGroup L)
    , ((modm .|. controlMask, xK_l), sendMessage $ pullGroup R)
    , ((modm .|. controlMask, xK_k), sendMessage $ pullGroup U)
    , ((modm .|. controlMask, xK_j), sendMessage $ pullGroup D)
    -- Merge/unmerge all
    , ((modm .|. controlMask, xK_m), withFocused (sendMessage . MergeAll))
    , ((modm .|. controlMask, xK_u), withFocused (sendMessage . UnMerge))
    -- Change focus into tab
    , ((modm .|. controlMask, xK_period), onGroup W.focusUp')
    , ((modm .|. controlMask, xK_comma), onGroup W.focusDown')

    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    -- , ((modm              , xK_b     ), sendMessage ToggleStruts)

    -- Lock xmonad
    , ((modm .|. shiftMask, xK_l     ), spawn "gnome-screensaver-command -l")
    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")

    -- Run xmessage with a summary of the default keybindings (useful for beginners)
    , ((modm .|. shiftMask, xK_slash ), spawn ("echo \"" ++ help ++ "\" | xmessage -file -"))
    ]
    ++

    --
    -- mod-[1..9, 0], Switch to workspace N
    -- mod-shift-[1..9, 0], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) ([xK_1 .. xK_9] ++ [xK_0])
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
    ++
    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
    ++

    -- Scratchpads
    [
      -- Open Chat app (Slack)
      ((modm, xK_c),                  namedScratchpadAction scratchpads "slack")
    ]
    ++
    -- 
    -- Media Buttons (on Keychron K3)
    -- 
    [ ((0, xF86XK_AudioMute),         spawn ("pactl set-sink-mute @DEFAULT_SINK@ toggle"))
    , ((0, xF86XK_AudioLowerVolume),  spawn ("pactl -- set-sink-volume @DEFAULT_SINK@ -5%")) 
    , ((0, xF86XK_AudioRaiseVolume),  spawn ("pactl -- set-sink-volume @DEFAULT_SINK@ +5%"))
    , ((0, xK_Print),                 spawn ("shutter -s"))
    , ((0, xF86XK_AudioPlay),         spawn ("playerctl play-pause"))
    , ((0, xF86XK_AudioPrev),         spawn ("playerctl previous"))
    , ((0, xF86XK_AudioNext),         spawn ("playerctl next"))
    ]



------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm .|. shiftMask, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--

base03  = "#002b36"
base02  = "#073642"
base01  = "#586e75"
base00  = "#657b83"
base0   = "#839496"
base1   = "#93a1a1"
base2   = "#eee8d5"
base3   = "#fdf6e3"
yellow  = "#b58900"
orange  = "#cb4b16"
red     = "#dc322f"
magenta = "#d33682"
violet  = "#6c71c4"
blue    = "#268bd2"
cyan    = "#2aa198"
green       = "#859900"

-- sizes
gap         = 10
topbar      = 10
border      = 2
prompt      = 20
status      = 20
delta       = 1/10

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#dddddd"
myFocusedBorderColor = active

active      = blue
activeWarn  = red
inactive    = base02
focusColor  = blue
unfocusColor = base02

myFont      = "-*-terminus-medium-*-*-*-*-160-*-*-*-*-*-*"
myBigFont   = "-*-terminus-medium-*-*-*-*-240-*-*-*-*-*-*"
myWideFont  = "xft:Eurostar Black Extended:"
            ++ "style=Regular:pixelsize=180:hinting=true"

-- TopBar taken from https://github.com/altercation/dotfiles-tilingwm/blob/master/.xmonad/xmonad.hs
topBarTheme = def
    { fontName              = myFont
    , inactiveBorderColor   = base03
    , inactiveColor         = base03
    , inactiveTextColor     = base03
    , activeBorderColor     = active
    , activeColor           = active
    , activeTextColor       = active
    , urgentBorderColor     = blue
    , urgentTextColor       = yellow
    , decoHeight            = topbar
    }

myTabTheme = def
    { fontName              = myFont
    , activeColor           = active
    , inactiveColor         = base02
    , activeBorderColor     = active
    , inactiveBorderColor   = base02
    , activeTextColor       = base03
    , inactiveTextColor     = base00
    }

myLayoutHook = 
  renamed [CutWordsLeft 1]
  $ avoidStruts
  $ threeColumn ||| noBorders Full
  where

    -- Add the top bar to show which window is active
    addTopBar   = noFrillsDeco shrinkText topBarTheme

    mySpacing s = spacingRaw True (Border s s s s) False (Border s s s s) True
    ---------------------------------------------------------------------------
    -- 3 Columned Layout                                                     --
    ---------------------------------------------------------------------------
    threeColumn = named "3 Column"
          $ windowNavigation
          $ addTopBar
          $ addTabs shrinkText myTabTheme
          $ subLayout [] (Simplest)
          $ mySpacing gap
          $ ThreeColMid 1 delta (1/2)

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = 
      manageSpecific
  <+> namedScratchpadManageHook scratchpads
  where
    manageSpecific = composeOne
      [
        -- className =? "Slack"          -?> doShift ( myWorkspaces !! 9 )
      -- Shitter should always float
      className =? "Shutter"          -?> doFloat
      -- Slack should always float as its a ScratchPad
      , resource =? slackResource     -?> doFloat
      -- Chrome pop-up windows should just float
      , className =? "Google-chrome" <&&> stringProperty "WM_WINDOW_ROLE" =? "pop-up"        -?> doFloat
      , resource  =? "desktop_window" -?> doIgnore
      , resource  =? "kdesktop"       -?> doIgnore ]

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook =
  -- Make sure handle Full screen events from the browser
  handleEventHook def <+> fullscreenEventHook

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
myLogHook h = dynamicLogWithPP $
  xmobarPP {
    ppOutput = hPutStrLn h
    , ppCurrent = xmobarColor "#F3F4F5" "" . wrap "[" "]"  -- Current workspace in xmobar
    , ppVisible = xmobarColor "#F3F4F5" "" . wrap "" ""    -- Visible but not current workspace
    , ppHidden = xmobarColor "#F3F4F5" ""                  -- Hidden workspaces in xmobar
    , ppHiddenNoWindows = xmobarColor "#676E7D" ""         -- Hidden workspaces (no windows)
    , ppTitle = xmobarColor "#DDCCBB" "" . shorten 80      -- Title of active window in xmobar
    , ppSep =  "<fc=#8A9C9E> :: </fc>"                     -- Separators in xmobar
    , ppUrgent = xmobarColor "#ff0000" "" . wrap "!" "!"   -- Urgent workspace
    , ppOrder  = \(ws:l:t:exs) -> [ws,l]++exs++[t]
  }

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = do
      spawnOnce "compton &"
      spawnOnce ".screenlayout/ultrawide-dual.sh &"
      -- Set the background, needs to be after screenlayout
      spawnOnce "feh --bg-fill ~/Pictures/backgrounds/wallhaven-nkjre1.jpg"

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main = do
  -- start Xmobar process
  xmproc <- spawnPipe "xmobar -x 0 /home/justin/dotfiles/xmonad/xmobar/xmobar.config"
  xmonad
    $ withUrgencyHook NoUrgencyHook
    $ docks
    $ ewmh def {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = border,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayoutHook,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        logHook            = myLogHook xmproc,
        startupHook        = myStartupHook
    }

-- | Finally, a copy of the default bindings in simple textual tabular format.
help :: String
help = unlines ["The default modifier key is 'alt'. Default keybindings:",
    "",
    "-- launching and killing programs",
    "mod-Shift-Enter  Launch xterminal",
    "mod-p            Launch dmenu",
    "mod-Shift-p      Launch gmrun",
    "mod-Shift-c      Close/kill the focused window",
    "mod-Space        Rotate through the available layout algorithms",
    "mod-Shift-Space  Reset the layouts on the current workSpace to default",
    "mod-n            Resize/refresh viewed windows to the correct size",
    "",
    "-- move focus up or down the window stack",
    "mod-Tab        Move focus to the next window",
    "mod-Shift-Tab  Move focus to the previous window",
    "mod-j          Move focus to the next window",
    "mod-k          Move focus to the previous window",
    "mod-m          Move focus to the master window",
    "",
    "-- modifying the window order",
    "mod-Return   Swap the focused window and the master window",
    "mod-Shift-j  Swap the focused window with the next window",
    "mod-Shift-k  Swap the focused window with the previous window",
    "",
    "-- resizing the master/slave ratio",
    "mod-h  Shrink the master area",
    "mod-l  Expand the master area",
    "",
    "-- floating layer support",
    "mod-t  Push window back into tiling; unfloat and re-tile it",
    "",
    "-- increase or decrease number of windows in the master area",
    "mod-comma  (mod-,)   Increment the number of windows in the master area",
    "mod-period (mod-.)   Deincrement the number of windows in the master area",
    "",
    "-- quit, or restart",
    "mod-Shift-q  Quit xmonad",
    "mod-q        Restart xmonad",
    "mod-[1..9]   Switch to workSpace N",
    "",
    "-- Workspaces & screens",
    "mod-Shift-[1..9]   Move client to workspace N",
    "mod-{w,e,r}        Switch to physical/Xinerama screens 1, 2, or 3",
    "mod-Shift-{w,e,r}  Move client to screen 1, 2, or 3",
    "",
    "-- Mouse bindings: default actions bound to mouse events",
    "mod-button1  Set the window to floating mode and move by dragging",
    "mod-button2  Raise the window to the top of the stack",
    "mod-button3  Set the window to floating mode and resize by dragging"]
