Function ValidateResistor(component)
    Dim resistanceFound    ' As Boolean

    ' Create component iterator, masking only parameters
    compIterator = component.SchIterator_Create
    compIterator.AddFilter_ObjectSet(MkSet(eParameter))

    Set parameter = compIterator.FirstSchObject

    ' Reset flags
    resistanceFound = false

    ' Loop through all parameters in object
    Do While Not (parameter Is Nothing)
        ' Check for supplier part number parameter thats visible on sheet

        ' Project and version regex
        Set regex = New RegExp
        regex.IgnoreCase = True
        regex.Global = True
        ' Look for date in pattern yyyy/mm/dd
        regex.Pattern = "[0-9]*\.?[0-9]*[RkM]"

        If regex.Test(parameter.Text) And parameter.IsHidden = false Then
            'StdOut("Resistance found!")
            resistanceFound = true
        End If

        Set parameter = CompIterator.NextSchObject
    Loop ' Do While Not (parameter Is Nothing)

    component.SchIterator_Destroy(compIterator)

    If resistanceFound = false Then
        ValidateResistor = false
    Else
        ValidateResistor = true
    End If
End Function
