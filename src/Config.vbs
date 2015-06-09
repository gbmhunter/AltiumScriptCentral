'
' @file               Config.vbs
' @author             Geoffrey Hunter <gbmhunter@gmail.com> (www.mbedded.ninja)
' @created            2013-08-08
' @last-modified      2015-04-23
' @brief              Configuration settings and variables for AltiumScriptCentral.
' @details
'                     See README.rst in repo root dir for more info.

' Forces us to explicitly define all variables before using them
Option Explicit

Private ModuleName
ModuleName = "Config.vbs"

Const DEFAULT_FILE_NAME_FOR_USER_DATA = "AltiumScriptCentral_UserData"

Dim BOARD_OUTLINE_LAYER
Dim PCB_INFO_LAYER
Dim TOP_DIMENSIONS_LAYER
Dim BOT_DIMENSIONS_LAYER
Dim TOP_MECH_BODY_LAYER
Dim BOT_MECH_BODY_LAYER
Dim TOP_COURTYARD_LAYER
Dim BOT_COURTYARD_LAYER
Dim UNUSED_LAYERS

Const MIN_TENTED_VIA_RATIO    	= 0.90

Const DESIGNATOR_BATTERY              = "BT"
Const DESIGNATOR_CAPACITOR            = "C"
Const DESIGNATOR_DIODE                = "D"
Const DESIGNATOR_ANTENNA              = "E"
Const DESIGNATOR_FUSE                 = "F"
Const DESIGNATOR_FERRITE_BEAD         = "FB"
Const DESIGNATOR_FIDUCIAL             = "FD"
Const DESIGNATOR_JACK                 = "J"
Const DESIGNATOR_INDUCTOR             = "L"
Const DESIGNATOR_MECHANICAL_PART      = "MP"
Const DESIGNATOR_MOTOR                = "M"
Const DESIGNATOR_CONNECTOR            = "P"
Const DESIGNATOR_SOLAR_PANEL          = "PV"
Const DESIGNATOR_TRANSISTOR           = "Q"
Const DESIGNATOR_RESISTOR             = "R"
Const DESIGNATOR_SWITCH               = "SW"
Const DESIGNATOR_IC                   = "U"
Const DESIGNATOR_TRANSFORMER          = "T"
Const DESIGNATOR_TEST_POINT           = "TP"
Const DESIGNATOR_VARIABLE_RESISTOR    = "VR"
Const DESIGNATOR_CABLE                = "W"
Const DESIGNATOR_CRYSTAL              = "XC"
Const DESIGNATOR_FUSE_HOLDER          = "XF"

' @brief	The parameter name for the scheamtic number
Const SCHEMATIC_SHEET_COUNT_PARAM_NAME    = "SheetNumber"

' @brief 	The parameter name for the total number of schematic sheets
Const TOTAL_SHEET_PARAM_NAME              = "SheetTotal"

' @brief     Initialisation function which sets up environment for the rest of
'            AltiumScriptCentral to work correctly.
Sub ConfigInit(dummyVar)

    ' BOARD LAYERS
    BOARD_OUTLINE_LAYER     = eMechanical1
    PCB_INFO_LAYER          = eMechanical2
    TOP_DIMENSIONS_LAYER    = eMechanical11
    BOT_DIMENSIONS_LAYER    = eMechanical12
    TOP_MECH_BODY_LAYER     = eMechanical13
    BOT_MECH_BODY_LAYER     = eMechanical14
    TOP_COURTYARD_LAYER     = eMechanical15
    BOT_COURTYARD_LAYER     = eMechanical16
    UNUSED_LAYERS           = MkSet(eMechanical3, eMechanical4, eMechanical5, eMechanical6, eMechanical7, eMechanical8, eMechanical9, eMechanical10)

End Sub
