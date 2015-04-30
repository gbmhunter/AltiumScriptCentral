'
' @file               RunPreReleaseChecks.vbs
' @author             Geoffrey Hunter <gbmhunter@gmail.com> (www.mbedded.ninja)
' @created            2014-11-25
' @last-modified      2015-04-30
' @brief              Main entry point for the pre-release checks.
' @details
'                     See README.rst in repo root dir for more info.

' @brief    Forces us to explicitly define all variables before using them
Option Explicit

' @brief    Name of this module. Used for debugging/warning/error message purposes and for
'           saving user data.
Private Const moduleName = "RunPreReleaseChecks.vbs"

Private dummyVar

Function StdOut(msg)
    ' Output text
    MemoStdOut.Text = MemoStdOut.Text + msg
End Function

Sub StdOutNl(msg)
    ' Output text
    MemoStdOut.Text = MemoStdOut.Text + msg + VbCr + VbLf
End Sub

Function StdErr(moduleName, msg)
    ' Output text
    MemoStdErr.Text = MemoStdErr.Text + "ERROR (" + moduleName + "): " + msg + VbCr + VbLf
End Function


'Sub StdErrNl(msg)
    ' Output text
'    MemoStdErr.Text = MemoStdErr.Text + msg + VbCr + VbLf
'End Sub

Sub FormPreReleaseChecksCreate(sender)
       ' PROJECT
    ' Important to check if project compiles first
    If CheckProjectCompiles(dummyVar) = False Then
        Exit Sub
    End If

    ' SCHEMATICS
    PowerPortChecker(dummyVar)
    CheckNoSupplierPartNumShown(dummyVar)
    ComponentValidator(dummyVar)

    ' ===== PCB =====

    ' First we want to make sure we have access to a PCB document
    If CheckWeHavePcbDocAccess(dummyVar) = False Then
       Exit Sub
    End If

    ' Since we have access, we can now run all PCB checks
    CheckLayers(dummyVar)
    CheckTentedVias(dummyVar)
    CheckNameVersionDate(dummyVar)
    CheckPcbTextHasCorrectOrientation(dummyVar)
    CheckPcbCompDesignatorRotation(dummyVar)
    ' 2014-11-11: CheckComponentLinks() doesn't actually check the links automatically, it
    ' just opens up the component link window for the user, so I've commented this
    ' script out
    'CheckComponentLinks(DummyVar)
End Sub
