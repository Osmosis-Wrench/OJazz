Scriptname OJazz_MCM extends nl_mcm_module
{MCM for OJazz}

; code
String Blue = "#6699ff"
String Pink = "#ff3389"

bool enabled

int property nextsong auto
int property playsong auto
int property stopsong auto
int property hidewidget auto
int property showwidget auto
int property volume auto
bool property NPC_Scenes_Enabled auto

ojazz_main property main auto

int property oJazzMusicLib
    int function get()
        return JDB.solveObj(".OJazz.songs")
    EndFunction
    function set(int object)
        JDB.solveObjSetter(".OJazz.songs", object, true)
    endfunction
endproperty

event OnInit()
    RegisterModule("Core Options")
endEvent

event OnPageInit()
    SetModName("OJazz  ")
    SetLandingPage("Core Options")
    Writelog("Installing...")
    BuildDatabase()
    enabled = true
    NPC_Scenes_Enabled = false
    nextsong = 0
    playsong = 0
    stopsong = 0
    hidewidget = 0
    showwidget = 0
    Writelog("Installed!")
endEvent

event OnPageDraw()
    SetCursorFillMode(TOP_TO_BOTTOM)
    AddHeaderOption(FONT_CUSTOM("Main Options:", Blue))
    AddToggleOptionST("mod_enabled_state", "Mod Enabled", enabled)
    AddTextOptionST("rebuild_database_state", "Rebuild Database", "Click")
    AddSliderOptionST("volume_slider_state", "Music Volume", volume)
    AddToggleOPtionST("NPC_Scenes_Enabled_State", "Play for NPC/NPC Scenes", NPC_Scenes_Enabled)
    AddHeaderOption(FONT_CUSTOM("Keybinds:", pink))
    AddKeyMapOptionST("keybind_nextsong_state", "Next Song", nextsong)
    AddKeyMapOptionST("keybind_stopsong_state", "Stop Song", stopsong)
    AddKeyMapOptionST("keybind_hidewidget_state", "Hide Widget", hidewidget)
    AddKeyMapOptionST("keybind_showwidget_state", "Show Widget", showwidget)
    SetCursorPosition(1)
    AddHeaderOption(FONT_CUSTOM("Songs:", Blue))
    BuildPageContents()
endEvent

function BuildPageContents()
    string songKey = JMap.NextKey(oJazzMusicLib)
    while songKey
        bool songEnabled = Jvalue.SolveInt(oJazzMusicLib, "." + songKey + ".Enabled") as bool
        AddToggleOptionST("song_toggle_state___" + songKey, songKey, songEnabled)
        songKey = Jmap.nextKey(oJazzMusicLib, songKey)
    endwhile
endFunction

function BuildDatabase()
    JDB.SetObj("OJazz", 0)
    Writelog("Building Database...")
    int songFileList = JValue.readFromDirectory("Data/Interface/exported/widgets/ojazz/", ".json")
    JValue.Retain(songFileList)
    int songData
    string songFileKey = Jmap.NextKey(songFileList)
    while songFileKey
        songData = Jmap.GetObj(songFileList, songFileKey)
        string songKey = Jmap.NextKey(songData)
        while songKey
            int obj = JValue.SolveObj(songData, "." + songKey)
            form formvalue = JValue.SolveForm(obj, ".Form")
            if (!oJazzMusicLib && (formvalue == true))
                int firstObj = jmap.object()
                Jmap.SetObj(firstObj, songKey, obj)
                oJazzMusicLib = firstObj
            elseif (formvalue == true)
                JMap.SetObj(oJazzMusicLib, songKey, obj)
            endif
            songKey = Jmap.NextKey(songData, songKey)
        endwhile
        songFileKey = Jmap.NextKey(songFileList, songFileKey)
    endwhile
    JValue.Release(songFileList)
    Writelog("Database Built!")
endFunction

state rebuild_database_state
    event OnSelectST(string state_id)
        BuildDatabase()
        ForcePageReset()
    endevent

    event OnHighlightST(string state_id)
        SetInfoText("Rebuilds the song database. \n This will purge invalid songs and load new songs.")
    endevent
endState

state song_toggle_state
    event OnSelectST(string state_id)
        bool songEnabled = Jvalue.SolveInt(oJazzMusicLib, "."+state_id+".Enabled") as bool
        JValue.SolveIntSetter(oJazzMusicLib, "."+state_id+".Enabled", (!songEnabled) as int)
        SetToggleOptionValueST(!songEnabled, false, "song_toggle_state___" + state_id)
    endevent

    event OnHighlightST(string state_id)
        SetInfoText("Artist: "+ Jvalue.SolveStr(oJazzMusicLib, "." + state_id + ".Artist") + "\nLicense: " + Jvalue.SolveStr(oJazzMusicLib, "."+state_id+".License") +"\nLength: " + Jvalue.SolveStr(oJazzMusicLib, "." + state_id + ".Length"))
    endevent
endstate

state keybind_nextsong_state
    event OnKeymapChangeST(string state_id, int keycode)
        int old = nextsong
        setkeymapoptionvaluest(keycode)
        main.handleKeymap(keycode, old)
        nextsong = keycode
    endevent

    event onHighlightST(string state_id)
        SetInfoText("Button to skip to the next track. \nNote: This will only skip to a different random track, there is no \"track order\"")
    endevent
endstate


state keybind_stopsong_state
    event OnKeymapChangeST(string state_id, int keycode)
        int old = stopsong
        setkeymapoptionvaluest(keycode)
        main.handleKeymap(keycode, old)
        stopsong = keycode
    endevent

    event onHighlightST(string state_id)
        SetInfoText("Button to stop the current song.")
    endevent
endstate

state keybind_hidewidget_state
    event OnKeymapChangeST(string state_id, int keycode)
        int old = hidewidget
        setkeymapoptionvaluest(keycode)
        main.handleKeymap(keycode, old)
        hidewidget = keycode
    endevent

    event onHighlightST(string state_id)
        SetInfoText("Button to hide the widget when it's shown.")
    endevent
endstate

state keybind_showwidget_state
    event OnKeymapChangeST(string state_id, int keycode)
        int old = showwidget
        setkeymapoptionvaluest(keycode)
        main.handleKeymap(keycode, old)
        showwidget = keycode
    endevent

    event onHighlightST(string state_id)
        SetInfoText("Button to show the widget when it's hidden.")
    endevent
endstate

state volume_slider_state
    event OnSliderOpenST(string state_id)
        SetSliderDialog(volume, 0, 100, 1, 100)
    endEvent

    event OnHighlightST(string state_id)
        SetInfoText("Set the volume the music will play at in scenes.")
    endevent

    event OnSliderAcceptST(string state_id, float f)
        volume = f as Int
        SetSliderOptionValueST(volume)
        main.volumeChange()
    endevent
endstate

state NPC_Scenes_Enabled_State
    event OnSelectST(string state_id)
        NPC_Scenes_Enabled = !NPC_Scenes_Enabled
        SetToggleOptionValueST(NPC_Scenes_Enabled, false, "NPC_Scenes_Enabled_State")
    endevent

    event OnHighlightST(string state_id)
        SetInfoText("Set whether music will play during NPC only scenes.")
    endevent
endstate

state mod_enabled_state
    event OnSelectST(string state_id)
        enabled = !enabled
        SetToggleOptionValueST(enabled, false, "mod_enabled_state")
    endevent

    event OnHighlightST(string state_id)
        SetInfoText("Set whether the mod is active or not.")
    endevent
endstate

; This just makes life easier sometimes.
Function WriteLog(String OutputLog, bool error = false)
    MiscUtil.PrintConsole("OJazz: " + OutputLog)
    Debug.Trace("OJazz: " + OutputLog)
    if (error == true)
        Debug.Notification("OJazz: " + OutputLog)
    endIF
EndFunction