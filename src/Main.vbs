'
' @file               Main.vbs
' @author             Geoffrey Hunter <gbmhunter@gmail.com> (www.mbedded.ninja)
' @created            2013-08-08
' @last-modified      2014-11-11
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

Sub ButtonRunPrereleaseChecksClick(Sender)

    ' PROJECT
    ' Important to check if project compiles first
    If CheckProjectCompiles(DummyVar) = False Then
        Exit Sub
    End If

    ' SCHEMATICS
    PowerPortChecker(DummyVar)
    CheckNoSupplierPartNumShown(DummyVar)
    ComponentValidator(DummyVar)

    ' ===== PCB =====

    ' First we want to make sure we have access to a PCB document
    If CheckWeHavePcbDocAccess(DummyVar) = False Then
       Exit Sub
    End If

    ' Since we have access, we can now run all PCB checks
    CheckLayers(DummyVar)
    CheckTentedVias(DummyVar)
    CheckNameVersionDate(DummyVar)
    CheckPcbTextHasCorrectOrientation(DummyVar)
    ' 2014-11-11: CheckComponentLinks() doesn't actually check the links automatically, it
    ' just opens up the component link window for the user, so I've commented this
    ' script out
    'CheckComponentLinks(DummyVar)
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
    ResizeDesignators(dummyVar)

    ' Close main form for good
    FormMainScript.Close
End Sub

Sub ButNumberSchematics_Click(Sender)
    NumberSchematics(dummyVar)
End Sub

' Called when the "Rotate Designators" button is clicked
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

Sub ButtonViaStamperClick(Sender)

    ' Close main form for good
    FormMainScript.Hide

    ' Call via stamper script
    ViaStamper(DummyVar)

    FormMainScript.Close
End Sub
