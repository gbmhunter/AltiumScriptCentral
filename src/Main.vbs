'
' @file               Main.vbs
' @author             Geoffrey Hunter <gbmhunter@gmail.com> (www.mbedded.ninja)
' @created            2013-08-08
' @last-modified      2014-11-26
' @brief              Main entry point for AltiumScriptCentral.
' @details
'                     See README.rst in repo root dir for more info.

Sub RunMainScript
    FormMainScript.ShowModal
End Sub

' Called when FormMain is created
Sub FormMain_Create(Sender)
    ' Initialise global variables
    ConfigInit(dummyVar)
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
    DeleteAllSchematicParameters(DummyVar)
    FormMainScript.Close
End Sub

' Called when the "Add Special Schematic Parameters" button is clicked
Sub ButAddSpecialSchematicParametersClick(Sender)
    AddSpecialSchParams(dummyVar)
End Sub

' Called when the "Display PCB Stats" button is clicked
Sub ButtonDisplayPcbStatsClick(Sender)
    FormMainScript.Hide

    FormStats.Create
    ' Show PCB stats form
    FormStats.ShowModal

    FormMainScript.Close
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
    FormMainScript.Hide
    ' Close main form
    FormMainScript.Close

    Call CurrentCalculator(DummyVar)
End Sub

Sub ButtonRunPreReleaseChecksClick(Sender)

     ' Hide main form
    FormMainScript.Hide

    ' Show form, do not return until form is closed
    FormPreReleaseChecks.ShowModal

    ' Close main form
    FormMainScript.Close
End Sub
