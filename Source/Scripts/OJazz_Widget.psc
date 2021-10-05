Scriptname OJazz_Widget extends SKI_WidgetBase
{Lock symbol widget to indicate when OSA controls are locked.}

; code
bool Property visible
    bool Function Get()
        Return Ui.GetBool(HUD_MENU, WidgetRoot + "._visible")
    EndFunction
EndProperty

Event OnWidgetReset()
    parent.OnWidgetReset()
EndEvent

String Function GetWidgetSource()
    Return "ojazz/OJazzWidget.swf"
EndFunction

Function FlashVisibililty(float seconds = 2.0) ; Will set itself visible true when it starts, and set visible false when it ends.
    UI.InvokeFloat(HUD_MENU, WidgetRoot + ".FlashVisibility", seconds)
endfunction

bool Function ToggleVisiblity()
    return SetVisible(!visible)
endfunction 

;public function startWidget(newSongTitle:String, newSongArtist:String, newSongLength:String, newSongLicense:String):Void
bool Function StartOJazzWidget(string SongTitle, string SongArtist, string SongLength, string songLicense)
    int handle = UiCallback.Create(HUD_MENU, WidgetRoot + "startWidget")
    if handle == 0
        return false
    endif
    UiCallback.pushString(handle, SongTitle)
    UiCallback.pushString(handle, SongArtist)
    UiCallback.pushString(handle, SongLength)
    UiCallback.pushString(handle, songLicense)

    UiCallback.Send(handle)
    return true
endFunction

Bool Function SetVisible(bool IsVisible)
    UI.InvokeBool(HUD_MENU, WidgetRoot + ".setVisible", IsVisible)
    Return visible
EndFunction