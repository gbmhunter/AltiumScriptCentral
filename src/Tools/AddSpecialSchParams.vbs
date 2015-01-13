'
' @file               AddSpecialSchParams.vbs
' @author             Geoffrey Hunter <gbmhunter@gmail.com> (www.mbedded.ninja)
' @created            2013-08-08
' @last-modified      2015-01-13
' @brief              Adds special schematic parameters.
' @details
'                     See README.rst in repo root dir for more info.

' @param     DummyVar     Dummy variable to stop function appearing in the Altium "Run Script" dialogue.
Sub AddSpecialSchParams(DummyVar)

    Call StdOut("Adding special schematic parameters...")

    ' Show this form
    FormAddSpecialSchParams.Show

End Sub

' Called when "Add" button is clicked
Sub ButAddClick(Sender)

    If CbDocumentName.Checked = True Then
        Call AddSchParam("DocumentName", "")
    End If

    If CbModifiedDate.Checked = True Then
        Call AddSchParam("ModifiedDate", "")
    End If

    If CbProjectName.Checked = True Then
        Call AddSchParam("ProjectName", "")
    End If

    ' Close this form
    FormAddSpecialSchParams.Close

    Call StdOut("Special schematic parameters added." + VbCr + VbLf)

End Sub

' Adds a parameter given a name/value to all schematics in the currently active project
Sub AddSchParam(paramName, paramValue)
    Dim workspace           ' As IWorkspace
    Dim pcbProject          ' As IProject
    Dim document            ' As IDocument
    Dim flatHierarchy       ' As IDocument
    Dim sheet               ' As ISch_Document
    Dim docNum              ' As Integer
    Dim compIterator        ' As ISch_Iterator
    Dim component           ' As IComponent
    Dim projParameter       ' As IParameter
    Dim newParam            ' As

    'Call StdOut("Name = " + paramName)

    ' Obtain the schematic server interface.
    If SchServer Is Nothing Then
        StdErr("ERROR: Schematic server not online." + VbLf + VbCr)
        Exit Sub
    End If

    ' Get pcb project interface
    Set workspace = GetWorkspace
    Set pcbProject = workspace.DM_FocusedProject

    If pcbProject Is Nothing Then
        StdErr("ERROR: Current project is not a PCB project." + VbLf + VbCr)
        Exit Sub
    End If

    ' COMPILE PROJECT

    ResetParameters
    Call AddStringParameter("Action", "Compile")
    Call AddStringParameter("ObjectKind", "Project")
    Call RunProcess("WorkspaceManager:Compile")

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
                StdErr("ERROR: Sheet '" + document.DM_FullPath + "' could not be retrieved." + VbCr + VbLf)
                Exit Sub
            End If

            ' Start of undo block
            Call SchServer.ProcessControl.PreProcess(sheet, "")

            Set projParameter = pcbProject.DM_Parameters(paramNum)

            ' CHECK IF PARAMETER ALREADY EXISTS

            ' Set up iterator to look for parameter objects only
            Set paramIterator = sheet.SchIterator_Create
            If paramIterator Is Nothing Then
                StdErr("ERROR: Iterator could not be created.")
                Exit Sub
            End If

            paramIterator.AddFilter_ObjectSet(MkSet(eParameter))
            Set schParameters = paramIterator.FirstSchObject

           ' Call SchServer.RobotManager.SendMessage(document.I_ObjectAddress, c_BroadCast, SCHM_BeginModify, c_NoEventData)

            ' Iterate through exising parameters
            Do While Not (schParameters Is Nothing)
                 If schParameters.Name = paramName Then
                       ' Remove parameter before adding again
                       sheet.RemoveSchObject(schParameters)
                       'StdOut("Calling robot.")
                       'Call SchServer.RobotManager.SendMessage(sheet.I_ObjectAddress, c_BroadCast, SCHM_PrimitiveRegistration, schParameters.I_ObjectAddress)
                       'Call SchServer.RobotManager.SendMessage(null, null, 1, schParameters.I_ObjectAddress)
                       'StdOut("Finished robot.")
                 End If

                Set schParameters = paramIterator.NextSchObject
            Loop

            sheet.SchIterator_Destroy(paramIterator)

            ' NOW ADD PARAMETER TO SCHEMATIC

            newParam = SchServer.SchObjectFactory(eParameter, eCreate_Default)
            newParam.Name = paramName
            newParam.Text = paramValue
            sheet.AddSchObject(newParam)

            ' Redraw schematic sheet
            sheet.GraphicallyInvalidate

            ' Tell server about change
            'Call SchServer.RobotManager.SendMessage(sheet.I_ObjectAddress, c_BroadCast, SCHM_PrimitiveRegistration, newParam.I_ObjectAddress)
            'Call SchServer.RobotManager.SendMessage(document.I_ObjectAddress, c_BroadCast, SCHM_EndModify, c_NoEventData)

            ' End of undo block
            Call SchServer.ProcessControl.PostProcess(sheet, "")

        End If ' If document.DM_DocumentKind = "SCH" Then
    Next ' For docNum = 0 To pcbProject.DM_LogicalDocumentCount - 1

End Sub
