Dim BOARD_OUTLINE_LAYER
Dim PCB_INFO_LAYER
Dim TOP_DIMENSIONS_LAYER
Dim BOT_DIMENSIONS_LAYER
Dim TOP_MECH_BODY_LAYER
Dim BOT_MECH_BODY_LAYER
Dim TOP_COURTYARD_LAYER
Dim BOT_COURTYARD_LAYER
Dim UNUSED_LAYERS 

Dim MIN_TENTED_VIA_RATIO

Dim DESIGNATOR_BATTERY              ' As String
Dim DESIGNATOR_CAPACITOR            ' As String
Dim DESIGNATOR_DIODE                ' As String
Dim DESIGNATOR_ANTENNA              ' As String
Dim DESIGNATOR_FUSE                 ' As String
Dim DESIGNATOR_FERRITE_BEAD         ' As String
Dim DESIGNATOR_FIDUCIAL             ' As String
Dim DESIGNATOR_JACK                 ' As String
Dim DESIGNATOR_INDUCTOR             ' As String
Dim DESIGNATOR_MOTOR                ' As String
Dim DESIGNATOR_CONNECTOR            ' As String
Dim DESIGNATOR_SOLAR_PANEL          ' As String
Dim DESIGNATOR_TRANSISTOR           ' As String
Dim DESIGNATOR_RESISTOR             ' As String
Dim DESIGNATOR_SWITCH               ' As String
Dim DESIGNATOR_IC                   ' As String
Dim DESIGNATOR_TRANSFORMER          ' As String
Dim DESIGNATOR_TEST_POINT           ' As String
Dim DESIGNATOR_VARIABLE_RESISTOR    ' As String
Dim DESIGNATOR_CABLE                ' As String
Dim DESIGNATOR_FUSE_HOLDER          ' As String

Dim TOTAL_SHEET_PARAM_NAME              ' As String
Dim SCHEMATIC_SHEET_COUNT_PARAM_NAME    ' As String

Sub ConfigInit()
    ' BOARD LAYERS
    BOARD_OUTLINE_LAYER     = eMechanical1
    PCB_INFO_LAYER          = eMechanical2
    TOP_DIMENSIONS_LAYER    = eMechanical11
    BOT_DIMENSIONS_LAYER    = eMechanical12
    TOP_MECH_BODY_LAYER     = eMechanical13
    BOT_MECH_BODY_LAYER     = eMechanical14
    TOP_COURTYARD_LAYER     = eMechanical15
    BOT_COURTYARD_LAYER     = eMechanical16
    UNUSED_LAYERS           = MkSet(eMechanical3, eMechanical4)

    MIN_TENTED_VIA_RATIO    = 0.90

    DESIGNATOR_BATTERY              = "BT"
    DESIGNATOR_CAPACITOR            = "C"
    DESIGNATOR_DIODE                = "D"
    DESIGNATOR_ANTENNA              = "E"
    DESIGNATOR_FUSE                 = "F"
    DESIGNATOR_FERRITE_BEAD         = "FB"
    DESIGNATOR_FIDUCIAL             = "FD"
    DESIGNATOR_JACK                 = "J"
    DESIGNATOR_INDUCTOR             = "L"
    DESIGNATOR_MOTOR                = "M"
    DESIGNATOR_CONNECTOR            = "P"
    DESIGNATOR_SOLAR_PANEL          = "PV"
    DESIGNATOR_TRANSISTOR           = "Q"
    DESIGNATOR_RESISTOR             = "R"
    DESIGNATOR_SWITCH               = "SW"
    DESIGNATOR_IC                   = "U"
    DESIGNATOR_TRANSFORMER          = "T"
    DESIGNATOR_TEST_POINT           = "TP"
    DESIGNATOR_VARIABLE_RESISTOR    = "VR"
    DESIGNATOR_CABLE                = "W"
    DESIGNATOR_FUSE_HOLDER          = "XF"

    ' The parameter name for the scheamtic number
    SCHEMATIC_SHEET_COUNT_PARAM_NAME    = "SheetNumber"
    ' The parameter name for the total number of schematic sheets
    TOTAL_SHEET_PARAM_NAME              = "SheetTotal"
End Sub
