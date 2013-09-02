Sub CheckResShowResistance() ' As TMemo
    Dim workspace           ' As IWorkspace
    Dim pcbProject          ' As IProject
    Dim document            ' As IDocument
    Dim flatHierarchy       ' As IDocument
    Dim sheet               ' As ISch_Document
    Dim docNum              ' As Integer
    Dim iterator            ' As ISch_Iterator
    Dim compIterator        ' As ISch_Iterator
    Dim component           ' As IComponent
    Dim parameter           ' As ISch_Parameter
    Dim violationCount      ' As Integer

    StdOut("Checking resistors display their resistance...")

    violationCount = 0

    ' Obtain the schematic server interface.
    If SchServer Is Nothing Then
        StdErr("ERROR: Schematic server not online." + VbLf + VbCr)
        Exit Sub
    End If

    ' Get pcb project interface
    Set workspace = GetWorkspace
    Set pcbProject = workspace.DM_FocusedProject

    If pcbProject Is Nothing Then
        StdErr("ERROR: Current Project is not a PCB Project" + VbLf + VbCr)
        Exit Sub
    End If

   ' Compile project
   Set flatHierarchy = PCBProject.DM_DocumentFlattened

    ' If we couldn't get the flattened sheet, then most likely the project has
    ' not been compiled recently
    If flatHierarchy Is Nothing Then
        StdErr("ERROR: Compile the project before running this script." + VbCr + VbLf)
    End If

    ' Loop through all project documents
    For docNum = 0 To pcbProject.DM_LogicalDocumentCount - 1
        Set document = pcbProject.DM_LogicalDocuments(docNum)

        ' If this is SCH document
        If document.DM_DocumentKind = "SCH" Then
            Set sheet = SCHServer.GetSchDocumentByPath(document.DM_FullPath)
            'ShowMessage(document.DM_FullPath);
            If sheet Is Nothing Then
                StdErr("ERROR: No sheet found." + VbCr + VbLf)
                Exit Sub
            End If

            ' Set up iterator to look for power port objects only
            Set iterator = sheet.SchIterator_Create
            If iterator Is Nothing Then
                StdErr("ERROR: Iterator could not be created.")
                Exit Sub
            End If

            iterator.AddFilter_ObjectSet(MkSet(eSchComponent))
            Set component = Iterator.FirstSchObject
            Do While Not (component Is Nothing)

                ' First, make sure component is a resistor

                Set regex = New RegExp
                regex.IgnoreCase = True
                regex.Global = True
                ' Look for designator that starts with R and is followed by one or more numbers
                regex.Pattern = "^R[0-9][0-9]*"

                ' Check for pattern match
                If regex.Test(component.Designator.Text) Then
                    'StdOut("Resistor found!")
                    If Not LookForResistance(component) Then
                        violationCount = violationCount + 1
                    End If
                Else
                    'StdOut("Component not a resistor.")
                    ' If not resistor, go to next component
                End If

                Set component = iterator.NextSchObject
            Loop

            sheet.SchIterator_Destroy(iterator)

        End If ' If document.DM_DocumentKind = "SCH" Then

    Next ' For docNum = 0 To pcbProject.DM_LogicalDocumentCount - 1

    If violationCount = 0 Then
        StdOut("No resistor violations found." + VbCr + VbLf)
    Else
        StdErr("ERROR: Resistor violation(s) found. Make sure the resistance is displayed on the schematics for every resistor. Number of violations = " + IntToStr(violationCount) + "." + VbCr + VbLf)
    End If
End Sub

Function LookForResistance(component)
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
        LookForResistance = false
    Else
        LookForResistance = true
    End If
End Function
