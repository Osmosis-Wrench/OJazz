Scriptname OJazz_Main extends Quest
{Play song when OStim scene is running.}

; code
Sound baseSound

Event OnInit()
    RegisterForModEvent("ostim_Start", "OnOstimStart")
    RegisterForModEvent("ostim_end", "OnOstimEnd")
    Sound baseSound = game.getformfromfile(Ox, "OBowChikkaBowWow.esp") as sound
EndEvent

Event OnOstimStart(string eventName, string strArg, float numArg, Form sender)
    ;Get a song, then start playing.

endEvent

Event OnOstimEnd(string eventName, string strArg, float numArg, Form sender)
    ;Double check the song was stopped.

endEvent



