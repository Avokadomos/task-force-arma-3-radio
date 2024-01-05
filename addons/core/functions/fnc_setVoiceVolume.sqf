#include "script_component.hpp"

/*
  Name: TFAR_fnc_setVoiceVolume

  Author: NKey
    Sets the volume for the player's voice in game

  Arguments:
    Volume - Range (0,TF_max_voice_volume) <NUMBER>

  Return Value:
    None

  Example:
    30 call TFAR_fnc_setVoiceVolume;

  Public: Yes
*/

private _localName = LSTRING(voice_normal);
TF_last_speak_volume_level = TF_speak_volume_level;
TF_last_speak_volume_meters = TF_speak_volume_meters;
TF_speak_volume_meters = TF_max_voice_volume min _this;
if (TF_speak_volume_meters <= TFAR_VOLUME_WHISPERING) then {
    TF_speak_volume_level = "Whispering";
    _localName = LSTRING(voice_whispering);
} else {
    if (TF_speak_volume_meters > TFAR_VOLUME_NORMAL) then {
        TF_speak_volume_level = "Yelling";
        _localName = LSTRING(voice_yelling);
    } else {
        TF_speak_volume_level = "Normal";
    };
};

if (TFAR_oldVolumeHint) then {
    private _hintText = format[localize LSTRING(voice_volume), localize _localName];
    [parseText (_hintText), 5] call TFAR_fnc_showHint;
} else {
    if (!TFAR_ShowVolumeHUD) then {
        (QGVAR(HUDVolumeIndicatorRsc) call BIS_fnc_rscLayer) cutRsc [QGVAR(HUDVolumeIndicatorRsc), "PLAIN", 0, true];
        TFAR_volumeIndicatorFlashIndex = TFAR_volumeIndicatorFlashIndex+1;
        [{
            if (TFAR_volumeIndicatorFlashIndex == _this select 0) then {
                (QGVAR(HUDVolumeIndicatorRsc) call BIS_fnc_rscLayer) cutText ["", "PLAIN"];
            };
        }, [TFAR_volumeIndicatorFlashIndex], 5] call CBA_fnc_waitAndExecute;
    };
};
call TFAR_fnc_updateSpeakVolumeUI;

//							unit, range
["OnSpeakVolume", [TFAR_currentUnit, TF_speak_volume_meters]] call TFAR_fnc_fireEventHandlers;
