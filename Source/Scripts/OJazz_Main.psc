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

int SongIndex
String SongTitle
float currentWaitTime

OJazz_Widget OJazzWidget

Event OnInit()
    RegisterForModEvent("ostim_Start", "OnOstimStart")
    RegisterForModEvent("ostim_end", "OnOstimEnd")
    RegisterForKey(27)
    PlayerRef = Game.GetPlayer()
    ostim = outils.GetOStim()
    OJazzWidget = (Self as Quest) as OJazz_Widget
    ojazz = (Self as Quest) as OJazz_MCM
EndEvent

Event OnKeyDown(int keycode)
    If keycode == ojazz.nextsong
        if SongIndex
            Sound.StopInstance(SongIndex)
        endif
        MainController()
    elseif keycode == ojazz.playsong
        MainController()
    elseif keycode == ojazz.stopsong
        if SongIndex
            Sound.StopInstance(SongIndex)
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
    ;todo send song data to widget.
    int randomvalid = JValue.evalLuaObj(oJazzMusicLib, "return ojazz.getValidRandom(jobject, '"+SongTitle+"')")
    SongIndex = (JMap.GetForm(randomvalid, "Form") as sound).play(PlayerRef)
    SongTitle = JMap.GetStr(randomvalid, "Title")
    String SongArtist = JMap.GetStr(randomvalid, "Artist")
    String SongLength = JMap.GetStr(randomvalid, "Length")
    String SongLicense = JMap.GetStr(randomvalid, "License")
    Writelog("Playing: "+SongTitle+" by "+SongArtist+" | "+ SongLength +" | License: "+SongLicense)
    if OJazzWidget.StartOJazzWidget(SongTitle, SongArtist, SongLength, SongLicense)
        ;Writelog("Widget Started")
        float i = stringtimetoseconds(SongLength)
        writelog(i)
        if i != -1
            registerforsingleupdate(i)
            currentWaitTime = Utility.getCurrentRealTime() + i
            writelog(currentWaitTime)
        endif
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

event OnUpdate()
    if Utility.getCurrentRealTime() >= currentWaitTime
        Sound.StopInstance(SongIndex)
        if OStim.AnimationRunning()
            MainController()
        endif
    endif
endevent

function handleKeymap(int newk, int oldk)
    unregisterforkey(oldk)
    registerforkey(newk)
endfunction

float function stringtimetoseconds(string s)
    string[] k = stringutil.split(s, ":")
    float ret
    if k.length == 0
        return -1
    elseif k.length == 1
        return k[0] as int
    elseif k.length == 2
        ret = k[0] as int
        ret += k[1] as int * 60
        return ret
    elseif k.length >= 3
        ret = k[0] as int
        ret += k[1] as int * 60
        ret += k[2] as int * 3600
        return ret
    endif
endfunction

; This just makes life easier sometimes.
Function WriteLog(String OutputLog, bool error = false)
    MiscUtil.PrintConsole("OJazz: " + OutputLog)
    Debug.Trace("OJazz: " + OutputLog)
    if (error == true)
        Debug.Notification("OJazz: " + OutputLog)
    endIF
EndFunction