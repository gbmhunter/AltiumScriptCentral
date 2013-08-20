Sub PushProjectParametersToSchematics()
    Dim workspace           ' As IWorkspace
    Dim pcbProject          ' As IProject
    Dim document            ' As IDocument
    Dim flatHierarchy       ' As IDocument
    Dim sheet               ' As ISch_Document
    Dim docNum              ' As Integer
    Dim compIterator        ' As ISch_Iterator
    Dim component           ' As IComponent
    Dim projParameter       ' As IParameter
    Dim newParam			' As

    StdOut("Pushing project parameters to schematics...")

    violationFnd = false

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
      Exit Sub
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

            ' Start of undo block
            Call SchServer.ProcessControl.PreProcess(sheet, "")

            ' Add all project parameters to this schematic

            ' Iterate through all project parameters
            For paramNum = 0 To pcbProject.DM_ParameterCount - 1
        		Set projParameter = pcbProject.DM_Parameters(paramNum)

				' CHECK IF PARAMETER ALREADY EXISTS

                ' Set up iterator to look for power port objects only
	            Set paramIterator = sheet.SchIterator_Create
	            If paramIterator Is Nothing Then
	                StdErr("ERROR: Iterator could not be created.")
	                Exit Sub
	            End If

	            paramIterator.AddFilter_ObjectSet(MkSet(eParameter))
	            Set schParameters = paramIterator.FirstSchObject

                ' Iterate through exising parameters
	            Do While Not (schParameters Is Nothing)
                     If schParameters.Name = projParameter.DM_Name Then
                           ' Remove parameter before adding again
                           sheet.RemoveSchObject(schParameters)
                           Call SchServer.RobotManager.SendMessage(sheet.I_ObjectAddress, c_BroadCast, SCHM_PrimitiveRegistration, schParameters.I_ObjectAddress)
                     End If

	                Set schParameters = paramIterator.NextSchObject
	            Loop

	            sheet.SchIterator_Destroy(paramIterator)

                ' NOW ADD PROJ PARAMETER TO SCHEMATIC

            	newParam = SchServer.SchObjectFactory(eParameter, eCreate_Default)
            	newParam.Name = projParameter.DM_Name
				newParam.Text = projParameter.DM_Value
				sheet.AddSchObject(newParam)

                ' Tell server about change
				Call SchServer.RobotManager.SendMessage(sheet.I_ObjectAddress, c_BroadCast, SCHM_PrimitiveRegistration, newParam.I_ObjectAddress)

            Next ' For paramNum = 0 To pcbProject.DM_ParameterCount - 1

            ' End of undo block
            Call SchServer.ProcessControl.PostProcess(sheet, "")

        End If ' If document.DM_DocumentKind = "SCH" Then
    Next ' For docNum = 0 To pcbProject.DM_LogicalDocumentCount - 1

    StdOut("Parameters have been pushed." + VbCr + VbLf)

End Sub
