'
' @file               ValidateCapacitor.vbs
' @author             Geoffrey Hunter <gbmhunter@gmail.com> (www.mbedded.ninja)
' @created            2013-08-08
' @last-modified      2015-01-08
' @brief              Validates a capacitor component that is on a schematic.
' @details
'                     See README.rst in repo root dir for more info.

' Forces us to explicitly define all variables before using them
Option Explicit

Private ModuleName
ModuleName = "ValidateCapacitor.vbs"

Function ValidateCapacitor(component)
    Dim CapacitanceFound    ' As Boolean
    Dim VoltageFound        ' As Boolean

    ' Create component iterator, masking only parameters
    Dim CompIterator
    CompIterator = Component.SchIterator_Create
    CompIterator.AddFilter_ObjectSet(MkSet(eParameter))

    Dim Parameter
    Set Parameter = CompIterator.FirstSchObject

    ' Reset flags
    CapacitanceFound = false
    VoltageFound = false

    ' Loop through all parameters in object
    Do While Not (Parameter Is Nothing)
        ' Check for supplier part number parameter thats visible on sheet

        ' Project and version regex
        Dim Regex
        Set Regex = New RegExp
        Regex.IgnoreCase = False
        Regex.Global = True
        ' Look for date in pattern yyyy/mm/dd
        Regex.Pattern = "^[0-9]*\.?[0-9]*V$"

        If Regex.Test(Parameter.Text) And Parameter.IsHidden = false Then
            VoltageFound = true
        End If

        ' Look for capacitance
        Regex.Pattern = "^[0-9]*\.?[0-9]*[pnum]?F$"

        If Regex.Test(Parameter.Text) And Parameter.IsHidden = false Then
            CapacitanceFound = true
        End If

        'if ((AnsiUpperCase(Parameter.Name) = 'GROUP') and (Parameter.Text <> '') and (Parameter.Text <> '*')) then
         '   if StrToInt(Parameter.Text) > MaxNumber then
          '      MaxNumber := StrToInt(Parameter.Text);

        Set Parameter = CompIterator.NextSchObject
    Loop ' Do While Not (parameter Is Nothing)

    Component.SchIterator_Destroy(CompIterator)

    If(CapacitanceFound = false) Then
        Call StdErr(ModuleName, "'" + Component.Designator.Text + "' does not show it's capacitance.")
    End If

    If(VoltageFound = false) Then
        Call StdErr(ModuleName, "'" + Component.Designator.Text + "' does not show it's voltage.")
    End If

    If(CapacitanceFound = false) Or (VoltageFound = false) Then
        ValidateCapacitor = false
    Else
        ValidateCapacitor = true
    End If
End Function
