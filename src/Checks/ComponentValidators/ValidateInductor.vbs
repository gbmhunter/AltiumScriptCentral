Function ValidateInductor(component)
    Dim inductanceFound    ' As Boolean
    Dim currentFound        ' As Boolean

    ' Create component iterator, masking only parameters
    compIterator = component.SchIterator_Create
    compIterator.AddFilter_ObjectSet(MkSet(eParameter))

    Set parameter = compIterator.FirstSchObject

    ' Reset flags
    capacitanceFound = false
    voltageFound = false

    ' Loop through all parameters in object
    Do While Not (parameter Is Nothing)

        ' Project and version regex
        Set regex = New RegExp
        regex.IgnoreCase = False
        regex.Global = True

          ' Look for inductance
        regex.Pattern = "^[0-9][0-9]*(\.[0-9][0-9]*)?[um]?H$"

        If regex.Test(parameter.Text) And parameter.IsHidden = false Then
            inductanceFound = true
        End If

        ' Look for current
        regex.Pattern = "^[0-9][0-9]*(\.[0-9][0-9]*)?[m]?A$"

        If regex.Test(parameter.Text) And parameter.IsHidden = false Then
            currentFound = true
        End If

        Set parameter = CompIterator.NextSchObject
    Loop ' Do While Not (parameter Is Nothing)

    component.SchIterator_Destroy(compIterator)

    If(inductanceFound = false) Then
        Call StdErr("ERROR: '" + component.Designator.Text + "' does not show it's inductance." + VbCr + VbLf)
    End If

    If(currentFound = false) Then
        Call StdErr("ERROR: '" + component.Designator.Text + "' does not show it's current." + VbCr + VbLf)
    End If

    ' Return
    If(capacitanceFound = false) Or (voltageFound = false) Then
        ValidateInductor = false
    Else
        ValidateInductor = true
    End If
End Function
