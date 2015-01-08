'
' @file               RunPreReleaseChecks.vbs
' @author             Geoffrey Hunter <gbmhunter@gmail.com> (www.mbedded.ninja)
' @created            2014-11-25
' @last-modified      2015-01-08
' @brief              Main entry point for the pre-release checks.
' @details
'                     See README.rst in repo root dir for more info.

' Forces us to explicitly define all variables before using them
Option Explicit

Private ModuleName
ModuleName = "RunPreReleaseChecks.vbs"

Private DummyVar

Sub StdOut(msg)
    ' Output text
    MemoStdOut.Text = MemoStdOut.Text + msg
End Sub

Sub StdOutNl(msg)
    ' Output text
    MemoStdOut.Text = MemoStdOut.Text + msg + VbCr + VbLf
End Sub

Sub StdErr(ModuleName, Msg)
    ' Output text
    MemoStdErr.Text = MemoStdErr.Text + "ERROR (" + ModuleName + "): " + Msg + VbCr + VbLf
End Sub


'Sub StdErrNl(msg)
    ' Output text
'    MemoStdErr.Text = MemoStdErr.Text + msg + VbCr + VbLf
'End Sub

Sub FormPreReleaseChecksCreate(Sender)
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
