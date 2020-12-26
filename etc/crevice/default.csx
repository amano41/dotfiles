﻿﻿// crevice4 setting file.
// You can use Visual Studio Code for editing this file.

#region #r direction section.
// You can use #r directive to load an assembly. #r directive must be on the top,
// above of all the other lines.
//#r "other.dll"
#endregion

#region #load directive section.
// You can use #load directive to load other csx file. #load directive must be
// on the top, above of all the other lines except #r directive.
//#load "other.csx"
#endregion

#region IDE support environment loading section.
#load "IDESupport\\Scripts\\MockEnv.csx"
#endregion

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

#region Crevice API section.
// You can use `Window` class which provides some useful functions relating
// Windows's window.
//using Crevice.WinAPI.Window;

// You can use some classes which relates Windows Core Audio API.
//using Crevice.WinAPI.CoreAudio;

// You can use windows messages, declared in `Winuser.h`, with prefix `WM_` by
// enabling the following code.
//using static Crevice.WinAPI.Constants.WindowsMessages;

// You can use virtual keys, declared in `Winuser.h`, with prefix `VK_` by
// enabling the following code.
//using static Crevice.WinAPI.Constants.VirtualKeys;
#endregion

Config.Core.GestureTimeout = 500;

// Global gestures
var Whenever = When(ctx =>
{
    return true;
});

Whenever.
On(Keys.MButton).
On(Keys.MoveLeft).
Do(ctx =>
{
    ctx.ForegroundWindow.Activate();
    SendInput.Multiple().
    ExtendedKeyDown(Keys.LWin).
    ExtendedKeyDown(Keys.ShiftKey).
    ExtendedKeyDown(Keys.Left).
    ExtendedKeyUp(Keys.Left).
    ExtendedKeyUp(Keys.ShiftKey).
    ExtendedKeyUp(Keys.LWin).
    Send(); // Move window to left monitor
});

Whenever.
On(Keys.MButton).
On(Keys.MoveRight).
Do(ctx =>
{
    ctx.ForegroundWindow.Activate();
    SendInput.Multiple().
    ExtendedKeyDown(Keys.LWin).
    ExtendedKeyDown(Keys.ShiftKey).
    ExtendedKeyDown(Keys.Right).
    ExtendedKeyUp(Keys.Right).
    ExtendedKeyUp(Keys.ShiftKey).
    ExtendedKeyUp(Keys.LWin).
    Send(); // Move window to right monitor
});

Whenever.
On(Keys.MButton).
On(Keys.MoveUp).
Do(ctx =>
{
    SendInput.Multiple().
    ExtendedKeyDown(Keys.LWin).
    ExtendedKeyDown(Keys.Tab).
    ExtendedKeyUp(Keys.Tab).
    ExtendedKeyUp(Keys.LWin).
    Send(); // Task view
});

Whenever.
On(Keys.WheelLeft).
Do(ctx =>{
    SendInput.Multiple().
    ExtendedKeyDown(Keys.LWin).
    ExtendedKeyDown(Keys.ControlKey).
    ExtendedKeyDown(Keys.Left).
    ExtendedKeyUp(Keys.Left).
    ExtendedKeyUp(Keys.ControlKey).
    ExtendedKeyUp(Keys.LWin).
    Send(); // Previous desktop
});

Whenever.
On(Keys.WheelRight).
Do(ctx =>{
    SendInput.Multiple().
    ExtendedKeyDown(Keys.LWin).
    ExtendedKeyDown(Keys.ControlKey).
    ExtendedKeyDown(Keys.Right).
    ExtendedKeyUp(Keys.Right).
    ExtendedKeyUp(Keys.ControlKey).
    ExtendedKeyUp(Keys.LWin).
    Send(); // Next desktop
});

// Gestures for standard browsers.
var Browser = When(ctx =>
{
    return ctx.ForegroundWindow.ModuleName == "chrome.exe" ||
           ctx.ForegroundWindow.ModuleName == "firefox.exe" ||
          // Firefox's ModuleName may be differ from normal ones in case waiting for restarting after it's upgrading.
          // In that case, it's name starts with `moz` and has the class name "MozillaWindowClass".
          (ctx.ForegroundWindow.ModuleName.StartsWith("moz") &&
               ctx.ForegroundWindow.ClassName == "MozillaWindowClass") ||
           ctx.ForegroundWindow.ModuleName == "opera.exe" ||
           ctx.ForegroundWindow.ModuleName == "iexplore.exe" ||
           ctx.ForegroundWindow.ModuleName == "msedge.exe" ||
          (ctx.ForegroundWindow.ModuleName == "ApplicationFrameHost.exe" &&
               ctx.PointedWindow.Text == "Microsoft Edge") ||
          (ctx.ForegroundWindow.ModuleName == "explorer.exe" &&
               ctx.PointedWindow.ClassName == "DirectUIHWND") ||
           ctx.ForegroundWindow.ModuleName == "Asr.exe";
});

Browser.
On(Keys.RButton).
On(Keys.WheelUp).
Do(ctx =>
{
    SendInput.Multiple().
    ExtendedKeyDown(Keys.ControlKey).
    ExtendedKeyDown(Keys.ShiftKey).
    ExtendedKeyDown(Keys.Tab).
    ExtendedKeyUp(Keys.Tab).
    ExtendedKeyUp(Keys.ShiftKey).
    ExtendedKeyUp(Keys.ControlKey).
    Send(); // Previous tab
});

Browser.
On(Keys.RButton).
On(Keys.WheelDown).
Do(ctx =>
{
    SendInput.Multiple().
    ExtendedKeyDown(Keys.ControlKey).
    ExtendedKeyDown(Keys.Tab).
    ExtendedKeyUp(Keys.Tab).
    ExtendedKeyUp(Keys.ControlKey).
    Send(); // Next tab
});

Browser.
On(Keys.RButton).
On(Keys.MoveUp).
Do(ctx =>
{
    SendInput.Multiple().
    ExtendedKeyDown(Keys.Home).
    ExtendedKeyUp(Keys.Home).
    Send(); // Scroll to top
});

Browser.
On(Keys.RButton).
On(Keys.MoveDown).
Do(ctx =>
{
    SendInput.Multiple().
    ExtendedKeyDown(Keys.End).
    ExtendedKeyUp(Keys.End).
    Send(); // Scroll to bottom
});

Browser.
On(Keys.RButton).
On(Keys.MoveLeft).
Do(ctx =>
{
    SendInput.Multiple().
    ExtendedKeyDown(Keys.Menu).
    ExtendedKeyDown(Keys.Left).
    ExtendedKeyUp(Keys.Left).
    ExtendedKeyUp(Keys.Menu).
    Send(); // Go back
});

Browser.
On(Keys.RButton).
On(Keys.MoveRight).
Do(ctx =>
{
    SendInput.Multiple().
    ExtendedKeyDown(Keys.Menu).
    ExtendedKeyDown(Keys.Right).
    ExtendedKeyUp(Keys.Right).
    ExtendedKeyUp(Keys.Menu).
    Send(); // Go next
});

Browser.
On(Keys.RButton).
On(Keys.MoveUp, Keys.MoveDown).
Do(ctx =>
{
    SendInput.Multiple().
    ExtendedKeyDown(Keys.F5).
    ExtendedKeyUp(Keys.F5).
    Send(); // Reload tab
});

Browser.
On(Keys.RButton).
On(Keys.MoveDown, Keys.MoveRight).
Do(ctx =>
{
    SendInput.Multiple().
    ExtendedKeyDown(Keys.ControlKey).
    ExtendedKeyDown(Keys.W).
    ExtendedKeyUp(Keys.W).
    ExtendedKeyUp(Keys.ControlKey).
    Send(); // Close tab
});

Browser.
On(Keys.RButton).
On(Keys.MoveUp, Keys.MoveRight).
Do(ctx =>
{
    SendInput.Multiple().
    ExtendedKeyDown(Keys.ControlKey).
    ExtendedKeyDown(Keys.T).
    ExtendedKeyUp(Keys.T).
    ExtendedKeyUp(Keys.ControlKey).
    Send(); // Open new tab
});

Browser.
On(Keys.RButton).
On(Keys.MoveUp, Keys.MoveLeft).
Do(ctx =>
{
    SendInput.Multiple().
    ExtendedKeyDown(Keys.ControlKey).
    ExtendedKeyDown(Keys.ShiftKey).
    ExtendedKeyDown(Keys.T).
    ExtendedKeyUp(Keys.T).
    ExtendedKeyUp(Keys.ShiftKey).
    ExtendedKeyUp(Keys.ControlKey).
    Send(); // Reopen closed tab
});

//Gestures for Excel
var Excel = When(ctx =>
{
    return ctx.ForegroundWindow.ModuleName == "EXCEL.EXE";
});

Excel.
On(Keys.RButton).
On(Keys.WheelUp).
Do(ctx =>
{
    SendInput.Multiple().
    ExtendedKeyDown(Keys.ControlKey).
    ExtendedKeyDown(Keys.PageUp).
    ExtendedKeyUp(Keys.PageUp).
    ExtendedKeyUp(Keys.ControlKey).
    Send(); // Previous sheet
});

Excel.
On(Keys.RButton).
On(Keys.WheelDown).
Do(ctx =>
{
    SendInput.Multiple().
    ExtendedKeyDown(Keys.ControlKey).
    ExtendedKeyDown(Keys.PageDown).
    ExtendedKeyUp(Keys.PageDown).
    ExtendedKeyUp(Keys.ControlKey).
    Send(); // Next sheet
});

Excel.
On(Keys.RButton).
On(Keys.MoveUp).
Do(ctx =>
{
    SendInput.Multiple().
    ExtendedKeyDown(Keys.ControlKey).
    ExtendedKeyDown(Keys.Up).
    ExtendedKeyUp(Keys.Up).
    ExtendedKeyUp(Keys.ControlKey).
    Send(); // Move to first row
});

Excel.
On(Keys.RButton).
On(Keys.MoveDown).
Do(ctx =>
{
    SendInput.Multiple().
    ExtendedKeyDown(Keys.ControlKey).
    ExtendedKeyDown(Keys.Down).
    ExtendedKeyUp(Keys.Down).
    ExtendedKeyUp(Keys.ControlKey).
    Send(); // Move to last row
});

Excel.
On(Keys.RButton).
On(Keys.MoveLeft).
Do(ctx =>
{
    SendInput.Multiple().
    ExtendedKeyDown(Keys.ControlKey).
    ExtendedKeyDown(Keys.Left).
    ExtendedKeyUp(Keys.Left).
    ExtendedKeyUp(Keys.ControlKey).
    Send(); // Move to first column
});

Excel.
On(Keys.RButton).
On(Keys.MoveRight).
Do(ctx =>
{
    SendInput.Multiple().
    ExtendedKeyDown(Keys.ControlKey).
    ExtendedKeyDown(Keys.Right).
    ExtendedKeyUp(Keys.Right).
    ExtendedKeyUp(Keys.ControlKey).
    Send(); // Move to last column
});

/*
// Example for CoreAudio and Tooltip API.
// The system master volume will be changed by Keys.WheelUp and Keys.WheelDown
// when the cursor is on the taskbar.
// Note: Do not forget to enable the line `using Crevice.WinAPI.CoreAudio;`
// disabled by default.
var VolumeControl = new VolumeControl();
var VolumeDelta = 0.01f;

var Taskbar = When(ctx =>
{
    return ctx.PointedWindow.ModuleName == "explorer.exe" &&
              (ctx.PointedWindow.ClassName == "MSTaskListWClass" ||
               ctx.PointedWindow.ClassName == "IMEModeButton" ||
               ctx.PointedWindow.ClassName == "Button" ||
               ctx.PointedWindow.ClassName == "ToolbarWindow32" ||
               ctx.PointedWindow.ClassName == "InputIndicatorButton" ||
               ctx.PointedWindow.ClassName == "TrayShowDesktopButtonWClass" ||
               ctx.PointedWindow.ClassName == "TrayButton" ||
               ctx.PointedWindow.ClassName == "TrayClockWClass" ||
               ctx.PointedWindow.ClassName == "ClockButton" ||
               ctx.PointedWindow.ClassName == "Start" ||
               ctx.PointedWindow.ClassName == "TaskbarWindow32");
});

Taskbar.
On(Keys.WheelUp).
Do(ctx =>
{
    VolumeControl.SetMasterVolume(VolumeControl.GetMasterVolume() + VolumeDelta);
    Tooltip(string.Format("Volume: {0:D2}", (int)(VolumeControl.GetMasterVolume() * 100)));
});

Taskbar.
On(Keys.WheelDown).
Do(ctx =>
{
    VolumeControl.SetMasterVolume(VolumeControl.GetMasterVolume() - VolumeDelta);
    Tooltip(string.Format("Volume: {0:D2}", (int)(VolumeControl.GetMasterVolume() * 100)));
});
*/

/*
// Example for global gesture.
// Caution: Unfortunately, It would be impossible to send special key (e.g. Alt+Tab) ,
// no matter how hard you try on Windows 8. This is the limitation of that operating
// system. You should have upgraded it to Windows 10.
var Whenever = When(ctx =>
{
    return true;
});

Whenever.
On(Keys.XButton1).
Do(ctx =>
{
    SendInput.Multiple().
    ExtendedKeyDown(Keys.Menu).
    ExtendedKeyDown(Keys.Tab).
    ExtendedKeyUp(Keys.Tab).
    ExtendedKeyUp(Keys.Menu).
    Send(); // Assign X1Button to Alt+Tab
});

Whenever.
On(Keys.XButton2).
Do(ctx =>
{
    SendInput.Multiple().
    ExtendedKeyDown(Keys.LWin).
    ExtendedKeyDown(Keys.Tab).
    ExtendedKeyUp(Keys.Tab).
    ExtendedKeyUp(Keys.LWin).
    Send(); // Assign X2Button to Win+Tab
});
*/
