'
' @file               ValidateResistor.vbs
' @author             Geoffrey Hunter <gbmhunter@gmail.com> (www.mbedded.ninja)
' @created            2013-08-08
' @last-modified      2015-01-08
' @brief              Validates a resistor component that is on a schematic.
' @details
'                     See README.rst in repo root dir for more info.

' Forces us to explicitly define all variables before using them
Option Explicit

Private ModuleName
ModuleName = "ValidateResistor.vbs"

Function ValidateResistor(Component)
    Dim ResistanceFound    ' As Boolean

    ' Create component iterator, masking only parameters
    Dim CompIterator
    CompIterator = Component.SchIterator_Create
    CompIterator.AddFilter_ObjectSet(MkSet(eParameter))

    Dim Parameter
    Set Parameter = CompIterator.FirstSchObject

    ' Reset flags
    ResistanceFound = false

    ' Loop through all parameters in object
    Do While Not (Parameter Is Nothing)
        ' Check for supplier part number parameter thats visible on sheet

        ' Project and version regex
        Dim Regex
        Set Regex = New RegExp
        Regex.IgnoreCase = False
        Regex.Global = True
        ' Look for date in pattern yyyy/mm/dd
        Regex.Pattern = "^[0-9][0-9]*(\.[0-9][0-9]*)?[mRkM]$"

        If Regex.Test(Parameter.Text) And Parameter.IsHidden = false Then
            'StdOut("Resistance found!")
            ResistanceFound = true
        End If

        Set Parameter = CompIterator.NextSchObject
    Loop ' Do While Not (parameter Is Nothing)

    Component.SchIterator_Destroy(CompIterator)

    If(ResistanceFound = false) Then
        Call StdErr(ModuleName, "'" + component.Designator.Text + "' does not show it's resistance.")
    End If

    If ResistanceFound = false Then
        ValidateResistor = false
    Else
        ValidateResistor = true
    End If
End Function
