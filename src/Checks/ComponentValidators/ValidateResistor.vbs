'
' @file               ValidateResistor.vbs
' @author             Geoffrey Hunter <gbmhunter@gmail.com> (www.mbedded.ninja)
' @created            2013-08-08
' @last-modified      2016-04-27
' @brief              Validates a resistor component that is on a schematic.
' @details
'                     See README.rst in repo root dir for more info.

' Forces us to explicitly define all variables before using them
Option Explicit

Private ModuleName
ModuleName = "ValidateResistor.vbs"

' @brief     Validates a resistor component.
Function ValidateResistor(component)
    Dim resistanceFound    ' As Boolean

    ' Create component iterator, masking only parameters
    Dim compIterator
    compIterator = component.SchIterator_Create
    compIterator.AddFilter_ObjectSet(MkSet(eParameter))

    Dim parameter
    Set parameter = compIterator.FirstSchObject

    ' Reset flags
    resistanceFound = false

    ' Loop through all parameters in object
    Do While Not (parameter Is Nothing)
        ' Check for supplier part number parameter thats visible on sheet

        ' Lets use regex to find the resistance
        Dim regex
        Set regex = New RegExp
        regex.IgnoreCase = False
        regex.Global = True
        ' Look for resistance
        ' This allows for resistances with the letters m, R, k or M at the end,
        ' OR one of those prefixes AND an Ohm symbol
        regex.Pattern = "^[0-9][0-9]*(\.[0-9][0-9]*)?([mRkM]|([mRkM]?O))$$"

        If regex.Test(parameter.Text) And parameter.IsHidden = false Then
            'StdOut("Resistance found!")
            resistanceFound = true
        End If

        Set parameter = compIterator.NextSchObject
    Loop ' Do While Not (parameter Is Nothing)

    component.SchIterator_Destroy(compIterator)

    If(resistanceFound = false) Then
        Call StdErr(ModuleName, "'" + component.Designator.Text + "' does not show it's resistance.")
    End If

    If resistanceFound = false Then
        ValidateResistor = false
    Else
        ValidateResistor = true
    End If
End Function
