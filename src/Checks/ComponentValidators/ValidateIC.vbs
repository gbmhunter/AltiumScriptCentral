'
' @file               ValidateIC.vbs
' @author             Geoffrey Hunter <gbmhunter@gmail.com> (www.mbedded.ninja)
' @created            2015-04-14
' @last-modified      2015-08-04
' @brief              Validates a IC component that is on a schematic.
' @details
'                     See README.rst in repo root dir for more info.

' Forces us to explicitly define all variables before using them
Option Explicit

Private ModuleName
ModuleName = "ValidateIC.vbs"

' @brief     Validates a resistor component.
Function ValidateIC(component)
    Dim manfPartNumFound    ' As Boolean

    ' Create component iterator, masking only parameters
    Dim compIterator
    compIterator = component.SchIterator_Create
    compIterator.AddFilter_ObjectSet(MkSet(eParameter))

    Dim parameter
    Set parameter = compIterator.FirstSchObject

    ' Reset flags
    manfPartNumFound = false

    ' Loop through all parameters in object
    Do While Not (parameter Is Nothing)
        ' Check for supplier part number parameter thats visible on sheet

        ' Lets use regex to find the manufacturer part number
        Dim regex
        Set regex = New RegExp
        regex.IgnoreCase = False
        regex.Global = True
        ' Look for parameter name (NOT it's value, this could be anything!)
        ' Lets not anchor the end either, some components have a " 1", " 2", e.t.c addition
        ' to the end
        regex.Pattern = "^Manufacturer Part Number"

        If regex.Test(parameter.Name) And parameter.IsHidden = false Then
            'StdOut("Resistance found!")
            manfPartNumFound = true
        End If

        Set parameter = compIterator.NextSchObject
    Loop ' Do While Not (parameter Is Nothing)

    component.SchIterator_Destroy(compIterator)

    If(manfPartNumFound = false) Then
        Call StdErr(ModuleName, "'" + component.Designator.Text + "' does not show it's manf. part number (looking for the parameter 'Manufacturer Part Number' with optional numbers at the end.")
    End If

    If manfPartNumFound = false Then
        ValidateIC = false
    Else
        ValidateIC = true
    End If
End Function
