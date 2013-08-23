Sub CheckNoSupplierPartNumShown() ' As TMemo
    Dim workspace           ' As IWorkspace
    Dim pcbProject          ' As IProject
    Dim document            ' As IDocument
    Dim flatHierarchy       ' As IDocument
    Dim sheet               ' As ISch_Document
    Dim docNum              ' As Integer
    Dim iterator            ' As ISch_Iterator
    Dim compIterator        ' As ISch_Iterator
    Dim component           ' As IComponent
    Dim parameter, parameter2 ' As ISch_Parameter
    Dim violationCount      ' As Integer

    StdOut("Looking for visible supplier part numbers...")

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
        ' First try compiling the project
        ResetParameters
        Call AddStringParameter("Action", "Compile")
        Call AddStringParameter("ObjectKind", "Project")
        Call RunProcess("WorkspaceManager:Compile")

        ' Try Again to open the flattened document
        Set flatHierarchy = PCBProject.DM_DocumentFlattened
        If flatHierarchy Is Nothing Then
           StdErr("ERROR: Compile the project before running this script." + VbCr + VbLf)
           Exit Sub
        End If
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
                compIterator = component.SchIterator_Create
                compIterator.AddFilter_ObjectSet(MkSet(eParameter))

                Set parameter = compIterator.FirstSchObject
                ' Loop through all parameters in object
                Do While Not (parameter Is Nothing)
                    ' Check for supplier part number parameter thats visible on sheet
                    If(parameter.Name = "Supplier Part Number 1") and (parameter.IsHidden = false) Then
                        violationCount = violationCount + 1
                        StdErr("Supplier part num violation " + parameter.Text + " in component " + component.Designator.Text + "." + VbCr + VbLf)
                    End If

                    'if ((AnsiUpperCase(Parameter.Name) = 'GROUP') and (Parameter.Text <> '') and (Parameter.Text <> '*')) then
                     '   if StrToInt(Parameter.Text) > MaxNumber then
                      '      MaxNumber := StrToInt(Parameter.Text);

                    Set parameter = CompIterator.NextSchObject
                Loop

                component.SchIterator_Destroy(compIterator)
                Set component = iterator.NextSchObject
            Loop

            sheet.SchIterator_Destroy(iterator)

        End If ' If document.DM_DocumentKind = "SCH" Then

    Next ' For docNum = 0 To pcbProject.DM_LogicalDocumentCount - 1

    If violationCount = 0 Then
        StdOut("No supplier part number violations found. ")
    Else
        StdErr("ERROR: Supplier part number visible on sheet violation found. Number of violations = " + IntToStr(violationCount) + "." + VbCr + VbLf)
    End If

    StdOut("Supplier part number checking finished." + VbCr + VbLf)
End Sub
