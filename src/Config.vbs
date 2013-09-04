Dim BOARD_OUTLINE_LAYER
Dim PCB_INFO_LAYER
Dim TOP_DIMENSIONS_LAYER
Dim BOT_DIMENSIONS_LAYER
Dim TOP_MECH_BODY_LAYER
Dim BOT_MECH_BODY_LAYER
Dim TOP_COURTYARD_LAYER
Dim BOT_COURTYARD_LAYER
Dim MIN_TENTED_VIA_RATIO

Dim DESIGNATOR_CAPACITOR            ' As String
Dim DESIGNATOR_DIODE                ' As String
Dim DESIGNATOR_FUSE				    ' As String
Dim DESIGNATOR_FERRITE_BEAD         ' As String
Dim DESIGNATOR_FIDUCIAL             ' As String
Dim DESIGNATOR_JACK					' As String
Dim DESIGNATOR_INDUCTOR             ' As String
Dim DESIGNATOR_MOTOR                ' As String
Dim DESIGNATOR_CONNECTOR            ' As String
Dim DESIGNATOR_TRANSISTOR           ' As String
Dim DESIGNATOR_RESISTOR             ' As String
Dim DESIGNATOR_SWITCH               ' As String
Dim DESIGNATOR_IC                   ' As String
Dim DESIGNATOR_TRANSFORMER          ' As String
Dim DESIGNATOR_VARIABLE_RESISTOR    ' As String
Dim DESIGNATOR_FUSE_HOLDER			' As String

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

    MIN_TENTED_VIA_RATIO    = 0.90

    DESIGNATOR_CAPACITOR            = "C"
    DESIGNATOR_DIODE                = "D"
    DESIGNATOR_FUSE					= "F"
    DESIGNATOR_FERRITE_BEAD         = "FB"
    DESIGNATOR_FIDUCIAL             = "FD"
    DESIGNATOR_JACK					= "J"
    DESIGNATOR_INDUCTOR             = "L"
    DESIGNATOR_MOTOR                = "M"
    DESIGNATOR_CONNECTOR            = "P"
    DESIGNATOR_TRANSISTOR           = "Q"
    DESIGNATOR_RESISTOR             = "R"
    DESIGNATOR_SWITCH               = "SW"
    DESIGNATOR_IC                   = "U"
    DESIGNATOR_TRANSFORMER          = "T"
    DESIGNATOR_VARIABLE_RESISTOR    = "VR"
    DESIGNATOR_FUSE_HOLDER          = "XF"
End Sub
