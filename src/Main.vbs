'
' @file               Main.vbs
' @author             Geoffrey Hunter <gbmhunter@gmail.com> (www.mbedded.ninja)
' @created            2013-08-08
' @last-modified      2014-11-04
' @brief              Main entry point for AltiumScriptCentral.
' @details
'                     See README.rst in repo root dir for more info.

Sub RunMainScript
    FormMainScript.ShowModal
End Sub

Sub ButRunChecks(Sender)

    ' PROJECT
    ' Important to check if project compiles first
    If(CheckProjectCompiles(dummyVar) = false) Then
        Exit Sub
    End If

    ' SCHEMATICS
    PowerPortChecker(dummyVar)
    CheckNoSupplierPartNumShown(dummyVar)
    ComponentValidator(dummyVar)

    ' PCB
    CheckLayers(dummyVar)
    CheckTentedVias(dummyVar)
    CheckNameVersionDate(dummyVar)
    CheckPcbTextHasCorrectOrientation(dummyVar)
End Sub

Sub MainPushProjectParametersToSchematics(Sender)
    PushProjectParametersToSchematics(dummyVar)
End Sub

Sub StdOut(msg)
    ' Output text
    MemoStdOut.Text = MemoStdOut.Text + msg
End Sub

Sub StdOutNl(msg)
    ' Output text
    MemoStdOut.Text = MemoStdOut.Text + msg + VbCr + VbLf
End Sub

Sub StdErr(msg)
    ' Output text
    MemoStdErr.Text = MemoStdErr.Text + msg
End Sub

Sub StdErrNl(msg)
    ' Output text
    MemoStdErr.Text = MemoStdErr.Text + msg + VbCr + VbLf
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
    ChangeDesignatorFontSize(dummyVar)

    ' Close main form for good
    FormMainScript.Close
End Sub

Sub ButNumberSchematics_Click(Sender)
    NumberSchematics(dummyVar)
End Sub

' Called when FormMain is created
Sub FormMain_Create(Sender)
    ' Initialise global variables
    ConfigInit(dummyVar)
End Sub

' Called when the rotate designators button is clicked
Sub ButRotateDesignatorsClick(Sender)
    RotateDesignators(dummyVar)
End Sub

' Called when the "Delete Schematic Parameters" button is clicked
Sub ButDeleteSchParamsClick(Sender)
    DeleteAllSchematicParameters(dummyVar)
End Sub

' Called when the "Add Special Schematic Parameters" button is clicked
Sub ButAddSpecialSchematicParametersClick(Sender)
    AddSpecialSchParams(dummyVar)
End Sub

' Called when the "Display PCB Stats" button is clicked
Sub ButtonDisplayPcbStatsClick(Sender)
    ' Call external script
    DisplayPcbStats(dummyVar)
End Sub
