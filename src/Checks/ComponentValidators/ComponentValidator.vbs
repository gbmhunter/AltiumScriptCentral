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
                If matchColl.Count = 1 Then
                     ' Extract letters from designator
                    regex.Pattern = "^[A-Z][A-Z]*"
                    Set matchColl = regex.Execute(matchColl.Item(0).Value)

                    ' Make sure the designator letter(s) is valid
                    Select Case matchColl.Item(0).Value
                        Case DESIGNATOR_DIODE
                        Case DESIGNATOR_CAPACITOR
                            If ValidateCapacitor(component) = False Then
                                violationCount = violationCount + 1
                            End If
                        Case DESIGNATOR_FUSE
                        Case DESIGNATOR_FERRITE_BEAD
                        Case DESIGNATOR_FIDUCIAL
                        Case DESIGNATOR_JACK
                        Case DESIGNATOR_INDUCTOR
                            Call ValidateInductor(component)
                        Case DESIGNATOR_MOTOR
                        Case DESIGNATOR_CONNECTOR
                        Case DESIGNATOR_TRANSISTOR
                        Case DESIGNATOR_RESISTOR
                            Call ValidateResistor(component)
                        Case DESIGNATOR_SWITCH
                        Case DESIGNATOR_IC
                        Case DESIGNATOR_TRANSFORMER
                        Case DESIGNATOR_TEST_POINT
                        Case DESIGNATOR_VARIABLE_RESISTOR
                        Case DESIGNATOR_FUSE_HOLDER
                        Case Else
                            StdErr("ERROR: '" + matchColl.Item(0).Value + "' is not a recognised designator." + VbCr + VbLf)
                    End Select
                Else
                    StdErr("ERROR: Designator was not valid." + VbCr + VbLf)
                End If

                ' Go to next schematic component
                Set component = iterator.NextSchObject
            Loop ' Do While Not (component Is Nothing)

            sheet.SchIterator_Destroy(iterator)

        End If ' If document.DM_DocumentKind = "SCH" Then

    Next ' For docNum = 0 To pcbProject.DM_LogicalDocumentCount - 1

    If violationCount = 0 Then
        StdOut("No component violations found. ")
    Else
        StdOut("ERROR: Component violation(s) found. Number of violations = '" + IntToStr(violationCount) + "'. ")
    End If

    StdOut("Component validating finished." + VbCr + VbLf)
End Sub
