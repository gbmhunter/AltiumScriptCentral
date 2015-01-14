'
' @file               PushProjectParametersToSchematics.vbs
' @author             Geoffrey Hunter <gbmhunter@gmail.com> (www.mbedded.ninja)
' @created            2013-08-08
' @last-modified      2015-01-14
' @brief              Copies project parameters and pastes them as schematic parameters in every schematic in the project.
' @details
'                     See README.rst in repo root dir for more info.

' Forces us to explicitly define all variables before using them
Option Explicit

' @brief The name of this module for logging purposes
Private moduleName
moduleName = "PushProjectParametersToSchematics.vbs"


' @brief     Copies project parameters and pastes them as schematic parameters in every schematic in the project.
' @param     DummyVar     Dummy variable to stop function appearing in the Altium "Run Script" dialogue.
Sub PushProjectParametersToSchematics(DummyVar)

    'StdOut("Pushing project parameters to schematics...")

    Dim violationFnd
    violationFnd = false

    ' Obtain the schematic server interface.
    If SchServer Is Nothing Then
        ShowMessage("ERROR: Schematic server not online.")
        Exit Sub
    End If

    ' Get pcb project interface
    Dim workspace           ' As IWorkspace
    Set workspace = GetWorkspace

    Dim pcbProject          ' As IProject
    Set pcbProject = workspace.DM_FocusedProject

    If pcbProject Is Nothing Then
        ShowMessage("ERROR: Current project is not a PCB project.")
        Exit Sub
    End If

    ' COMPILE PROJECT

    ResetParameters
    Call AddStringParameter("Action", "Compile")
    Call AddStringParameter("ObjectKind", "Project")
    Call RunProcess("WorkspaceManager:Compile")

    Dim flatHierarchy       ' As IDocument
    Set flatHierarchy = PCBProject.DM_DocumentFlattened

   ' If we couldn't get the flattened sheet, then most likely the project has
   ' not been compiled recently
   If flatHierarchy Is Nothing Then
      ShowMessage("ERROR: Compile the project before running this script.")
      Exit Sub
   End If

    ' Loop through all project documents
    Dim docNum              ' As Integer
    For docNum = 0 To pcbProject.DM_LogicalDocumentCount - 1

        Dim document            ' As IDocument
        Set document = pcbProject.DM_LogicalDocuments(docNum)

        ' If this is SCH document
        If document.DM_DocumentKind = "SCH" Then
            Dim sheet               ' As ISch_Document
            Set sheet = SCHServer.GetSchDocumentByPath(document.DM_FullPath)
            'ShowMessage(document.DM_FullPath);
            If sheet Is Nothing Then
                ShowMessage("ERROR: Sheet '" + document.DM_FullPath + "' could not be retrieved.")
                Exit Sub
            End If

            ' Start of undo block
            Call SchServer.ProcessControl.PreProcess(sheet, "")

            ' Add all project parameters to this schematic

            ' Iterate through all project parameters
            Dim paramNum
            For paramNum = 0 To pcbProject.DM_ParameterCount - 1
                Dim projParameter
                Set projParameter = pcbProject.DM_Parameters(paramNum)

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

               ' Call SchServer.RobotManager.SendMessage(document.I_ObjectAddress, c_BroadCast, SCHM_BeginModify, c_NoEventData)

                ' Iterate through exising parameters
                Do While Not (schParameters Is Nothing)
                     If schParameters.Name = projParameter.DM_Name Then
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

                ' NOW ADD PROJ PARAMETER TO SCHEMATIC

                Dim newParam
                newParam = SchServer.SchObjectFactory(eParameter, eCreate_Default)
                newParam.Name = projParameter.DM_Name
                newParam.Text = projParameter.DM_Value
                sheet.AddSchObject(newParam)

                ' Redraw schematic sheet
                sheet.GraphicallyInvalidate

                ' Tell server about change
                'Call SchServer.RobotManager.SendMessage(sheet.I_ObjectAddress, c_BroadCast, SCHM_PrimitiveRegistration, newParam.I_ObjectAddress)
                'Call SchServer.RobotManager.SendMessage(document.I_ObjectAddress, c_BroadCast, SCHM_EndModify, c_NoEventData)

            Next ' For paramNum = 0 To pcbProject.DM_ParameterCount - 1

            ' End of undo block
            Call SchServer.ProcessControl.PostProcess(sheet, "")

        End If ' If document.DM_DocumentKind = "SCH" Then
    Next ' For docNum = 0 To pcbProject.DM_LogicalDocumentCount - 1

    ShowMessage("Parameters have been pushed.")

End Sub
