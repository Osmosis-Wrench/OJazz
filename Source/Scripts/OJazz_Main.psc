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
ojazz_mcm property ojazz auto
Actor Property PlayerRef auto
SoundCategory Property MUS auto

int SongIndex
String SongTitle
float currentWaitTime

OJazz_Widget OJazzWidget

Event OnInit()
    RegisterForModEvent("ostim_Start", "OnOstimStart")
    RegisterForModEvent("ostim_end", "OnOstimEnd")
    PlayerRef = Game.GetPlayer()
    ostim = outils.GetOStim()
    OJazzWidget = (Self as Quest) as OJazz_Widget
EndEvent

Event OnKeyDown(int keycode)
    if keycode == 0
        return
    elseIf keycode == ojazz.nextsong
        if SongIndex
            Sound.StopInstance(SongIndex)
        endif
        MainController()
    elseif keycode == ojazz.stopsong
        if SongIndex
            Sound.StopInstance(SongIndex)
            OJazzWidget.FlashVisibililty()
            Writelog("Stopping Music")
        endif
    elseif keycode == ojazz.hidewidget
        OJazzWidget.SetVisible(false)
        Writelog("Widget Hidden")
    elseif keycode == ojazz.showwidget
        OJazzWidget.SetVisible(true)
        Writelog("Widget Visible")
    endif
endEvent

Function MainController()
    MUS.Pause()
    Sound.StopInstance(SongIndex) ; put this here so we never start two songs at once, because if we do we lose the old song and can't ever stop it.
    int randomvalid = JValue.evalLuaObj(oJazzMusicLib, "return ojazz.getValidRandom(jobject, '"+SongTitle+"')")
    SongIndex = (JMap.GetForm(randomvalid, "Form") as sound).play(PlayerRef)
    volumeChange()
    SongTitle = JMap.GetStr(randomvalid, "Title")
    String SongArtist = JMap.GetStr(randomvalid, "Artist")
    String SongLength = JMap.GetStr(randomvalid, "Length")
    String SongLicense = JMap.GetStr(randomvalid, "License")
    if OJazzWidget.StartOJazzWidget(SongTitle, SongArtist, SongLength, SongLicense)
        Writelog("Playing: "+SongTitle+" by "+SongArtist+" | "+ SongLength +" | License: "+SongLicense)
    Else
        Writelog("Widget Failed")
    endif
endFunction

Event OnOstimStart(string eventName, string strArg, float numArg, Form sender)
    if (!ojazz.NPC_Scenes_Enabled && !ostim.isPlayerInvolved())
        return
    endif
    MainController()
    Utility.Wait(7)
    OJazzWidget.FlashVisibililty(5)
endEvent

Event OnOstimEnd(string eventName, string strArg, float numArg, Form sender)
    ;Double check the song was stopped.
    MUS.UnPause()
    if (!ojazz.NPC_Scenes_Enabled && !ostim.isPlayerInvolved())
        return
    endif
    Sound.StopInstance(SongIndex)
    Writelog("Stopping Music")
    if OJazzWidget.visible
        OJazzWidget.FlashVisibililty()
    endif
endEvent

function handleKeymap(int newk, int oldk)
    unregisterforkey(oldk)
    registerforkey(newk)
endfunction

function volumeChange()
    Sound.SetInstanceVolume(SongIndex, ojazz.volume as float / 100.0)
endfunction

; This just makes life easier sometimes.
Function WriteLog(String OutputLog, bool error = false)
    MiscUtil.PrintConsole("OJazz: " + OutputLog)
    Debug.Trace("OJazz: " + OutputLog)
    if (error == true)
        Debug.Notification("OJazz: " + OutputLog)
    endIF
EndFunction