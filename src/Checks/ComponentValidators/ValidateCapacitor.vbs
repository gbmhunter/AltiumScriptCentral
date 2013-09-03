Function ValidateCapacitor(component)
    Dim capacitanceFound    ' As Boolean
    Dim voltageFound        ' As Boolean

    ' Create component iterator, masking only parameters
    compIterator = component.SchIterator_Create
    compIterator.AddFilter_ObjectSet(MkSet(eParameter))

    Set parameter = compIterator.FirstSchObject

    ' Reset flags
    capacitanceFound = false
    voltageFound = false

    ' Loop through all parameters in object
    Do While Not (parameter Is Nothing)
        ' Check for supplier part number parameter thats visible on sheet

        ' Project and version regex
        Set regex = New RegExp
        regex.IgnoreCase = True
        regex.Global = True
        ' Look for date in pattern yyyy/mm/dd
        regex.Pattern = "[0-9]*\.?[0-9]*V"

        If regex.Test(parameter.Text) And parameter.IsHidden = false Then
            voltageFound = true
        End If

        ' Look for capacitance
        regex.Pattern = "[0-9]*\.?[0-9]*[pnum]?F"

        If regex.Test(parameter.Text) And parameter.IsHidden = false Then
            capacitanceFound = true
        End If

        'if ((AnsiUpperCase(Parameter.Name) = 'GROUP') and (Parameter.Text <> '') and (Parameter.Text <> '*')) then
         '   if StrToInt(Parameter.Text) > MaxNumber then
          '      MaxNumber := StrToInt(Parameter.Text);

        Set parameter = CompIterator.NextSchObject
    Loop ' Do While Not (parameter Is Nothing)

    component.SchIterator_Destroy(compIterator)

    If(capacitanceFound = false) Then
        Call StdErr("ERROR: " + component.Designator.Text + " does not show it's capacitance. ")
    End If

    If(voltageFound = false) Then
        Call StdErr("ERROR: " + component.Designator.Text + " does not show it's voltage. ")
    End If

    If(capacitanceFound = false) Or (voltageFound = false) Then
        ValidateCapacitor = false
    Else
        ValidateCapacitor = true
    End If
End Function
