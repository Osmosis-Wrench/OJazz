Scriptname OJazz_MCM extends nl_mcm_module
{MCM for OJazz/OBowChikkaBowWow}

; code

event OnInit()
    RegisterModule("Core Options")
endEvent

event OnPageInit()
    SetModName("OBowChikkaBowWow")
    SetLandingPage("Core Options")
endEvent

event OnPageDraw()

endEvent