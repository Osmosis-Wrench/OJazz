Scriptname OJazz_Main extends Quest
{Play song when OStim scene is running.}

; code
int property oJazzMusicLib
    int function get()
        return JDB.solveObj(".OJazz.songs")
    EndFunction
    function set(int object)
        JDB.solveObjSetter(".OJazz.songs", object, true)
    endfunction
endproperty

OSexIntegrationMain property ostim auto
Actor Property PlayerRef auto

Sound baseSound

int SongIndex
String SongTitle
String SongArtist
String SongLength
String SongLicense

OJazz_Widget OJazzWidget

Event OnInit()
    RegisterForModEvent("ostim_Start", "OnOstimStart")
    RegisterForModEvent("ostim_end", "OnOstimEnd")
    RegisterForKey(27)
    PlayerRef = Game.GetPlayer()
    SongTitle = "Osmosis-Wrench"
    ostim = outils.GetOStim()
    baseSound = game.getformfromfile(0x00080B, "OBowChikkaBowWow.esp") as Sound
    OJazzWidget = (Self as Quest) as OJazz_Widget
EndEvent

Event OnKeyDown(int keycode)
    if SongIndex
        Sound.StopInstance(SongIndex)
    endif
    if keycode == 27
        MainController()
    endif
endEvent

Function MainController()
    ;todo send song data to widget.
    int randomvalid = JValue.evalLuaObj(oJazzMusicLib, "return ojazz.getValidRandom(jobject, '"+SongTitle+"')")
    SongIndex = (JMap.GetForm(randomvalid, "Form") as sound).play(PlayerRef)
    SongTitle = JMap.GetStr(randomvalid, "Title")
    SongArtist = JMap.GetStr(randomvalid, "Artist")
    SongLength = JMap.GetStr(randomvalid, "Length")
    SongLicense = JMap.GetStr(randomvalid, "License")
    Writelog("Playing: "+SongTitle+" by "+SongArtist+" | "+ SongLength +" | License: "+SongLicense)
    if OJazzWidget.StartOJazzWidget(SongTitle, SongArtist, SongLength, SongLicense)
        Writelog("Widget Started")
    Else
        Writelog("Widget Failed")
    endif
endFunction

Event OnOstimStart(string eventName, string strArg, float numArg, Form sender)
    MainController()
endEvent

Event OnOstimEnd(string eventName, string strArg, float numArg, Form sender)
    ;Double check the song was stopped.
    Sound.StopInstance(SongIndex)
    Writelog("Stopping Music")
    OJazzWidget.FlashVisibililty()
endEvent

; This just makes life easier sometimes.
Function WriteLog(String OutputLog, bool error = false)
    MiscUtil.PrintConsole("OBowChikkaBowWow: " + OutputLog)
    Debug.Trace("OBowChikkaBowWow: " + OutputLog)
    if (error == true)
        Debug.Notification("OBowChikkaBowWow: " + OutputLog)
    endIF
EndFunction



