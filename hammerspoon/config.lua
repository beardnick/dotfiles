-- Specify Spoons which will be loaded
hspoon_list = {
    "AClock",
    "BingDaily",
    -- "Calendar",
    --"CircleClock",
    "ClipShow",
    "CountDown",
    "FnMate",
    --"HCalendar",
    "HSaria2",
    "HSearch",
    -- "KSheet",
    "SpeedMenu",
    -- "TimeFlow",
    -- "UnsplashZ",
    "WinWin",
}



-- appM environment keybindings. Bundle `id` is prefered, but application `name` will be ok.
hsapp_list = {
    {key = 'a', name = 'Atom'},
    {key = 'g', id = 'com.google.Chrome'},
    {key = 'd', name = 'Dash'},
    {key = 'c', name = 'TickTick'},
    {key = 'f', name = 'Finder'},
    {key = 't', name = 'iTerm'},
    {key = 'k', name = 'KeyCastr'},
    {key = 'l', name = 'Telegram'},
    {key = 'o', name = 'QQMusic'},
    {key = 's', name = 'Safari'},
    {key = 'm', id = 'com.apple.ActivityMonitor'},
    {key = 'w', name = '企业微信'},
    {key = 'p', id = 'com.apple.systempreferences'},
    {key = 'q', name = 'QQ'},
    {key = 'n', name = '印象笔记'},
    --{key = 'i', name = 'IntelliJ IDEA 2020.1 EAP'},
}

-- Modal supervisor keybinding, which can be used to temporarily disable ALL modal environments.
hsupervisor_keys = {{"cmd", "shift", "ctrl"}, "Q"}

-- Reload Hammerspoon configuration
hsreload_keys = {{"cmd", "shift", "ctrl"}, "R"}

-- Toggle help panel of this configuration.
hshelp_keys = {{"alt", "shift"}, "/"}

-- aria2 RPC host address
hsaria2_host = "http://localhost:6800/jsonrpc"
-- aria2 RPC host secret
hsaria2_secret = "token"

----------------------------------------------------------------------------------------------------
-- Those keybindings below could be disabled by setting to {"", ""} or {{}, ""}

-- Window hints keybinding: Focuse to any window you want
hswhints_keys = {"alt", "tab"}

-- appM environment keybinding: Application Launcher
hsappM_keys = {"alt", "A"}

-- clipshowM environment keybinding: System clipboard reader
hsclipsM_keys = {"alt", "C"}

-- Toggle the display of aria2 frontend
hsaria2_keys = {"alt", "D"}

-- Launch Hammerspoon Search
hsearch_keys = {"alt", "G"}

-- Read Hammerspoon and Spoons API manual in default browser
hsman_keys = {"alt", "H"}

-- countdownM environment keybinding: Visual countdown
hscountdM_keys = {"alt", "I"}

-- Lock computer's screen
hslock_keys = {"alt", "L"}

-- resizeM environment keybinding: Windows manipulation
hsresizeM_keys = {"alt", "R"}

-- cheatsheetM environment keybinding: Cheatsheet copycat
hscheats_keys = {"alt", "S"}

-- Show digital clock above all windows
hsaclock_keys = {"alt", "T"}

-- Type the URL and title of the frontmost web page open in Google Chrome or Safari.
hstype_keys = {"alt", "V"}

-- Toggle Hammerspoon console
hsconsole_keys = {"alt", "Z"}

--1Keyboard.app
--Adobe Creative Cloud
--Adobe Photoshop CC 2015.5
--Alfred 4.app
--Anaconda-Navigator.app
--Android Studio.app
--Anki.app
--App Store.app
--Automator.app
--BaiduNetdisk_mac.app
--Books.app
--Burp Suite Community Edition.app
--Cakebrew.app
--Calculator.app
--Calendar.app
--CheatSheet.app
--Chess.app
--Chrome Remote Desktop Host Uninstaller.app
--Cisco
--Contacts.app
--Countdowns.app
--Dash.app
--Dashboard.app
--Dictionary.app
--Emacs.app
--FaceTime.app
--Font Book.app
--GIF Brewery 3.app
--Geekbench 4.app
--Gitter.app
--Google Chrome.app
--HBuilderX.app
--Hammerspoon.app
--Home.app
--IINA.app
--Image Capture.app
--InsomniaX.app
--IntelliJ IDEA 2020.1 EAP.app
--Keyboard Maestro.app
--Kite.app
--Launchpad.app
--Leanote.app
--Mail.app
--Maps.app
--MarginNote 3.app
--Messages.app
--Microsoft Excel.app
--Microsoft Office 2011
--Microsoft OneNote.app
--Microsoft Outlook.app
--Microsoft PowerPoint.app
--Microsoft Word.app
--Mission Control.app
--News.app
--Notes.app
--OhMyStar.app
--OneDrive.app
--Oni.app
--PDFelement.app
--PP助手.app
--Paste.app
--Photo Booth.app
--Photos.app
--Pocket.app
--Postman.app
--Preview.app
--QQ.app
--QQMusic.app
--QSpace.app
--QuickTime Player.app
--Reminders.app
--Safari.app
--Siri.app
--Skim.app
--Snip.app
--Snipaste.app
--SoapUI-5.5.0.app
--Stickies.app
--Stocks.app
--Swift Note.app
--System Preferences.app
--TeX
--Telegram.app
--TextEdit.app
--The Unarchiver.app
--Thunder.app
--TickTick.app
--Time Machine.app
--Today Scripts.app
--Typora.app
--Utilities
--V2rayU.app
--VoiceMemos.app
--WeChat.app
--XLPlayer.app
--Xcode.app
--Yoink.app
--i4Tools.app
--iTerm.app
--iTools Pro.app
--iTunes.app
--pap.er.app
--scitools
--wechatwebdevtools.app
--xdm.app
--企业云盘.app
--企业微信.app
--印象笔记.app
