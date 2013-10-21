Sub RunMainScript
    FormMainScript.ShowModal
End Sub

Sub ButRunChecks(Sender)

    ' PROJECT
    ' Important to check if project compiles first
    If(CheckProjectCompiles() = false) Then
        Exit Sub
    End If

    ' SCHEMATICS
    PowerPortChecker()
    CheckNoSupplierPartNumShown()
    ComponentValidator()

    ' PCB
    CheckLayers()
    CheckTentedVias()
    CheckNameVersionDate()
    CheckPcbTextHasCorrectOrientation()
	CheckComponentLinks()
End Sub

Sub MainPushProjectParametersToSchematics(Sender)
    PushProjectParametersToSchematics()
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
    RenumberPads()

End Sub

Sub MainResizeDesignators(Sender)

    ' Call script
    ChangeDesignatorFontSize

    ' Close main form for good
    FormMainScript.Close
End Sub

Sub ButNumberSchematics_Click(Sender)
    NumberSchematics()
End Sub

' Called when FormMain is created
Sub FormMain_Create(Sender)
    ' Initialise global variables
    ConfigInit()
End Sub

' Called when the rotate designators button is clicked
Sub ButRotateDesignatorsClick(Sender)
    RotateDesignators()
End Sub

' Called when the "Delete Schematic Parameters" button is clicked 
Sub ButDeleteSchParamsClick(Sender)
    DeleteAllSchematicParameters()
End Sub

' Called when the "Add Special Schematic Parameters" button is clicked
Sub ButAddSpecialSchematicParametersClick(Sender)

    ' Close closes the form for good
    'FormMainScript.Close

    AddSpecialSchParams()
End Sub
