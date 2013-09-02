Sub ComponentValidator()
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

    StdOut("Validating components...")

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

            ' Add filter for only schematic components
            iterator.AddFilter_ObjectSet(MkSet(eSchComponent))
            Set component = Iterator.FirstSchObject

            ' ============================
            ' ===== COMPONENT LOOP =======
            ' ============================
            Do While Not (component Is Nothing)

                ' First, make sure component is a capacitor

                Set regex = New RegExp
                regex.IgnoreCase = True
                regex.Global = True
                ' Look for a designator
                ' Designators are one ore more capital letters followed by
                ' one or more numerals, with nothing else before or afterwards (i.e. anchored)
                regex.Pattern = "^[A-Z][A-Z]*[0-9][0-9]*$"

                ' Check for pattern match, using execute method.
                Set matchColl = regex.Execute(component.Designator.Text)

                ' Make sure only one match was found
                If Not matchColl.Count = 1 Then
                	Call StdErr("ERROR: Invalid or no designator found.")
                End If

                ' Extract letters from designator
                regex.Pattern = "^[A-Z][A-Z]*"
				Set matchColl = regex.Execute(matchColl.Item(0).Value)

                ' Make sure the designator letter(s) is valid
                Select Case matchColl.Item(0).Value
                    Case "D"
                	Case "R"
                		Call ValidateResistor(component)
                    Case "C"
                    	'StdOut("Capacitor found.")
                    Case "FB"
                    Case "FID"
                    Case "L"
                    Case "P"
                    Case "Q"
                    Case "U"
                    Case "VR"
                    Case Else
                    	StdErr("ERROR: " + matchColl.Item(0).Value + " is not a recognised designator.")
                End Select

                'Call StdOut(matchColl.Item(0).Value)

                ' Go to next schematic component
                Set component = iterator.NextSchObject
            Loop ' Do While Not (component Is Nothing)

            sheet.SchIterator_Destroy(iterator)

        End If ' If document.DM_DocumentKind = "SCH" Then

    Next ' For docNum = 0 To pcbProject.DM_LogicalDocumentCount - 1

    If violationCount = 0 Then
        'StdOut("No cap voltage/capacitance violations found. ")
    Else
        'StdErr("ERROR: Cap voltage/capacitance violation(s) found. Make sure both the voltage and capacitance is displayed on the schematics for every capacitor. Number of violations = " + IntToStr(violationCount) + "." + VbCr + VbLf)
    End If

    StdOut("Component validating finished." + VbCr + VbLf)
End Sub
