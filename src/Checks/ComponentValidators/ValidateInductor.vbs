'
' @file               ValidateInductor.vbs
' @author             Geoffrey Hunter <gbmhunter@gmail.com> (www.mbedded.ninja)
' @created            2013-08-08
' @last-modified      2015-01-08
' @brief              Validates a inductor component that is on a schematic.
' @details
'                     See README.rst in repo root dir for more info.

' Forces us to explicitly define all variables before using them
Option Explicit

Private ModuleName
ModuleName = "ValidateInductor.vbs"

Function ValidateInductor(Component)
    Dim InductanceFound    ' As Boolean
    Dim CurrentFound        ' As Boolean

    ' Create component iterator, masking only parameters
    Dim CompIterator
    CompIterator = Component.SchIterator_Create
    CompIterator.AddFilter_ObjectSet(MkSet(eParameter))

    Dim Parameter
    Set Parameter = CompIterator.FirstSchObject

    ' Reset flags
    InductanceFound = false
    CurrentFound = false

    ' Loop through all parameters in object
    Do While Not (Parameter Is Nothing)

        ' Project and version regex
        Dim Regex
        Set Regex = New RegExp
        Regex.IgnoreCase = False
        Regex.Global = True

          ' Look for inductance
        Regex.Pattern = "^[0-9][0-9]*(\.[0-9][0-9]*)?[um]?H$"

        If Regex.Test(Parameter.Text) And Parameter.IsHidden = false Then
            InductanceFound = true
        End If

        ' Look for current
        Regex.Pattern = "^[0-9][0-9]*(\.[0-9][0-9]*)?[m]?A$"

        If Regex.Test(Parameter.Text) And Parameter.IsHidden = false Then
            CurrentFound = true
        End If

        Set Parameter = CompIterator.NextSchObject
    Loop ' Do While Not (parameter Is Nothing)

    Component.SchIterator_Destroy(CompIterator)

    If(InductanceFound = False) Then
        Call StdErr(ModuleName, "'" + component.Designator.Text + "' does not show it's inductance.")
    End If

    If(CurrentFound = False) Then
        Call StdErr(ModuleName, "'" + component.Designator.Text + "' does not show it's current.")
    End If

    ' Return
    If(inductanceFound = False) Or (currentFound = False) Then
        ValidateInductor = False
    Else
        ValidateInductor = True
    End If
End Function
