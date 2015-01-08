'
' @file               Main.vbs
' @author             Geoffrey Hunter <gbmhunter@gmail.com> (www.mbedded.ninja)
' @created            2013-08-08
' @last-modified      2015-01-08
' @brief              Main entry point for AltiumScriptCentral.
' @details
'                     See README.rst in repo root dir for more info.

' Forces us to explicitly define all variables before using them
Option Explicit

Private ModuleName
ModuleName = "Main.vbs"

Private DummyVar

Sub RunMainScript
    FormMainScript.ShowModal
    'FormMainScript.Show
End Sub

' Called when FormMain is created
Sub FormMain_Create(Sender)
    ' Initialise global variables
    ConfigInit(DummyVar)
End Sub


Sub MainPushProjectParametersToSchematics(Sender)
    FormMainScript.Hide
    PushProjectParametersToSchematics(DummyVar)
    FormMainScript.Close
End Sub

Sub MainRenumberPads(Sender)
    'FormMainScript.Visible = 0

    ' Close closes the form for good
    FormMainScript.Close

    ' Open renumber pads form
    RenumberPads(dummyVar)

End Sub

Sub MainResizeDesignators(Sender)
    ' Call script
    ResizeDesignators(dummyVar)

    ' Close main form for good
    FormMainScript.Close
End Sub

Sub ButNumberSchematics_Click(Sender)
    FormMainScript.Hide
    NumberSchematics(dummyVar)
    FormMainScript.Close
End Sub

' Called when the "Rotate Designators" button is clicked
Sub ButRotateDesignatorsClick(Sender)
    FormMainScript.Hide
    RotateDesignators(dummyVar)
    FormMainScript.Close
End Sub

' Called when the "Delete Schematic Parameters" button is clicked
Sub ButDeleteSchParamsClick(Sender)
    FormMainScript.Hide
    FormMainScript.Close
    DeleteAllSchematicParameters(DummyVar)

End Sub

' Called when the "Add Special Schematic Parameters" button is clicked
Sub ButAddSpecialSchematicParametersClick(Sender)
    AddSpecialSchParams(dummyVar)
End Sub

' Called when the "Display PCB Stats" button is clicked
Sub ButtonDisplayPcbStatsClick(Sender)
    FormMainScript.Hide

    FormMainScript.Close

    ' Show PCB stats form
    Call GetStats(DummyVar)
    FormStats.ShowModal

    'FormMainScript.Close

End Sub

Sub ButtonViaStamperClick(Sender)

    ' Close main form for good
    FormMainScript.Hide

    ' Call via stamper script
    ViaStamper(DummyVar)

    FormMainScript.Close
End Sub


Sub ButtonDrawPolygonClick(Sender)
    ' Close main form
    FormMainScript.Close

    ' Call DrawPolygon script
    DrawPolygon(DummyVar)
End Sub

Sub ButtonCurrentCalculatorClick(Sender)

    ' Hide main form
    'FormMainScript.Hide
    'FormMainScript.Visible = False

    ' Make the form small enough that it is not intrusive while the user selects a
    ' track to calculate current on. Note that this is the only way I could get it to work
    ' so that events on the child form fired (e.g. ButtonClick(Sender))
    FormMainScript.Height = 100
    FormMainScript.Width = 100

    Call CurrentCalculator(DummyVar)

    FormMainScript.Close
End Sub

Sub ButtonRunPreReleaseChecksClick(Sender)

     ' Hide main form
    FormMainScript.Hide

    ' Show form, do not return until form is closed
    FormPreReleaseChecks.ShowModal

    ' Close main form
    FormMainScript.Close
End Sub

Sub ButtonSwapComponentsClick(Sender)

    ' Hide main form
    FormMainScript.Hide

    Call SwapComponents(DummyVar)

    ' Close main form
    FormMainScript.Close

End Sub
