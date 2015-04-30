'
' @file               AddSpecialSchParams.vbs
' @author             Geoffrey Hunter <gbmhunter@gmail.com> (www.mbedded.ninja)
' @created            2013-08-08
' @last-modified      2015-04-30
' @brief              Adds special schematic parameters.
' @details
'                     See README.rst in repo root dir for more info.

' @brief	Forces us to explicitly define all variables before using them
Option Explicit

' @brief    Name of this module. Used for debugging/warning/error message purposes.
Private Const moduleName = "AddSpecialSchParams.vbs"

' @param     DummyVar     Dummy variable to stop function appearing in the Altium "Run Script" dialogue.
Sub AddSpecialSchParams(dummyVar)

    'ShowMessage("Adding special schematic parameters...")

    ' Show this form
    FormAddSpecialSchParams.Show

End Sub

' @brief    Event handler for the "Add" button.
' @details	Called when "Add" button is clicked.
Sub ButAddClick(sender)

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

    ShowMessage("Special schematic parameters added." + VbCr + VbLf)

End Sub

' @brief	Adds a parameter given a name/value to all schematics in the currently active project.
' @param	paramName	The name of the parameter to add.
' @param	paramValue	The value of the parameter to add.
Sub AddSchParam(paramName, paramValue)

    'Call ShowMessage("Name = " + paramName)

    ' Obtain the schematic server interface.
    If SchServer Is Nothing Then
        ShowMessage("ERROR: Schematic server not online." + VbLf + VbCr)
        Exit Sub
    End If

    ' Get pcb project interface
	Dim workspace
    Set workspace = GetWorkspace

	Dim pcbProject
    Set pcbProject = workspace.DM_FocusedProject

    If pcbProject Is Nothing Then
        ShowMessage("ERROR: Current project is not a PCB project." + VbLf + VbCr)
        Exit Sub
    End If

    ' COMPILE PROJECT

    ResetParameters
    Call AddStringParameter("Action", "Compile")
    Call AddStringParameter("ObjectKind", "Project")
    Call RunProcess("WorkspaceManager:Compile")

	' 2015-04-30: Diabled the flatHierarchy checking bit so
	' that we could perform this operation on a .SchDot file being
	' edited from the vault
	'Dim flatHierarchy
    'Set flatHierarchy = PCBProject.DM_DocumentFlattened

	' If we couldn't get the flattened sheet, then most likely the project has
   	' not been compiled recently
   	'If flatHierarchy Is Nothing Then
    '	ShowMessage("ERROR: Compile the project before running this script.")
    '	Exit Sub
  	'End If

    ' Loop through all project documents
	Dim docNum
    For docNum = 0 To pcbProject.DM_LogicalDocumentCount - 1
		Dim document
        Set document = pcbProject.DM_LogicalDocuments(docNum)

        ' If this is SCH document
        If document.DM_DocumentKind = "SCH" Then
			Dim sheet
            Set sheet = SCHServer.GetSchDocumentByPath(document.DM_FullPath)
            'ShowMessage(document.DM_FullPath);
            If sheet Is Nothing Then
                ShowMessage("ERROR: Sheet '" + document.DM_FullPath + "' could not be retrieved." + VbCr + VbLf)
                Exit Sub
            End If

            ' Start of undo block
            Call SchServer.ProcessControl.PreProcess(sheet, "")

			'Dim projParameter
            'Set projParameter = pcbProject.DM_Parameters(paramNum)

            ' CHECK IF PARAMETER ALREADY EXISTS

            ' Set up iterator to look for parameter objects only
			Dim paramIterator
            Set paramIterator = sheet.SchIterator_Create
            If paramIterator Is Nothing Then
                ShowMessage("ERROR: Iterator could not be created.")
                Exit Sub
            End If

            paramIterator.AddFilter_ObjectSet(MkSet(eParameter))
			Dim schParameters
            Set schParameters = paramIterator.FirstSchObject

           Call SchServer.RobotManager.SendMessage(sheet.I_ObjectAddress, c_BroadCast, SCHM_BeginModify, c_NoEventData)

            ' Iterate through exising parameters
            Do While Not (schParameters Is Nothing)
                 If schParameters.Name = paramName Then
                       ' Remove parameter before adding again
                       sheet.RemoveSchObject(schParameters)
                       'ShowMessage("Calling robot.")
                       'Call SchServer.RobotManager.SendMessage(sheet.I_ObjectAddress, c_BroadCast, SCHM_PrimitiveRegistration, schParameters.I_ObjectAddress)
                       'Call SchServer.RobotManager.SendMessage(null, null, 1, schParameters.I_ObjectAddress)
                       'ShowMessage("Finished robot.")
                 End If

                Set schParameters = paramIterator.NextSchObject
            Loop

            sheet.SchIterator_Destroy(paramIterator)

            ' NOW ADD PARAMETER TO SCHEMATIC

			Dim newParam
            newParam = SchServer.SchObjectFactory(eParameter, eCreate_Default)
            newParam.Name = paramName
            newParam.Text = paramValue
            sheet.AddSchObject(newParam)

            ' Redraw schematic sheet
            sheet.GraphicallyInvalidate

            ' Tell server about change
            Call SchServer.RobotManager.SendMessage(sheet.I_ObjectAddress, c_BroadCast, SCHM_PrimitiveRegistration, newParam.I_ObjectAddress)
            Call SchServer.RobotManager.SendMessage(sheet.I_ObjectAddress, c_BroadCast, SCHM_EndModify, c_NoEventData)

            ' End of undo block
            Call SchServer.ProcessControl.PostProcess(sheet, "")

        End If ' If document.DM_DocumentKind = "SCH" Then
    Next ' For docNum = 0 To pcbProject.DM_LogicalDocumentCount - 1

End Sub
