'
' @file               DeleteSchematicParameters.vbs
' @author             Geoffrey Hunter <gbmhunter@gmail.com> (www.mbedded.ninja)
' @created            2013-08-08
' @last-modified      2015-04-30
' @brief              Deletes a user-selectable range of schematic parameters in the current project.
' @details
'                     See README.rst in repo root dir for more info.

' Forces us to explicitly define all variables before using them
Option Explicit

' @brief    Name of this module. Used for debugging/warning/error message purposes and for
'           saving user data.
Private Const moduleName = "DeleteSchematicParameters.vbs"

' @brief    Enables/disables debug information.
Private DEBUG
DEBUG = 0

'===== CONSTANTS ====='

Const DELETE_SPECIFIC_PARAMETER = 0
Const DELETE_ALL_PARAMETERS = 1

Const DELETE_FROM_ACTIVE_SCHEMATIC = 0
Const DELETE_FROM_ALL_SCHEMATICS_IN_ACTIVE_PROJECT = 1

'===== SUBROUTINES/FUNCTIONS ====='

' @brief     Deletes all schematic parameters.
' @param     DummyVar    Dummy variable so that this sub does not show up to the user when
'                        they click "Run Script".
Sub DeleteSchematicParameters(dummyVar)
    FormDeleteSchematicParameters.ShowModal
End Sub

' @brief     Event handler for when the Delete button is clicked.
' @details   Gets the user input, validates it, then deletes the required parameters from
'            one or many schematic sheets of the current project.
Sub ButtonDelete_Click(Sender)
    'ShowMessage("Deleting schematic parameters...")

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
        PrintDebug("ERROR: Current project is not a PCB project." + VbLf + VbCr)
        Exit Sub
    End If

    ' COMPILE PROJECT

    Call ResetParameters
    Call AddStringParameter("Action", "Compile")
    Call AddStringParameter("ObjectKind", "Project")
    Call RunProcess("WorkspaceManager:Compile")

    Dim flatHierarchy
    Set flatHierarchy = pcbProject.DM_DocumentFlattened

   ' If we couldn't get the flattened sheet, then most likely the project has
   ' not been compiled recently
   'If flatHierarchy Is Nothing Then
      'ShowMessage("ERROR: Compile the project before running this script." + VbCr + VbLf)
      'Exit Sub
   'End If

   Dim schematicCount
   schematicCount = 0

   Dim paramCount
   paramCount = 0

    Dim schematic

   ' Check if we only need to delete from the currently active schematic
   If RadioGroupWhichSchematics.ItemIndex = DELETE_FROM_ACTIVE_SCHEMATIC Then
      PrintDebug("Deleting from active schematic.")

      ' Get active schematic
      schematic = SCHServer.GetCurrentSchDocument()
      If schematic Is Nothing Then
        ShowMessage("ERROR: There is no active schematic.")
        Exit Sub
      End If

      Dim paramCountTemp
      If RadioGroupWhichParameters.ItemIndex = DELETE_SPECIFIC_PARAMETER Then
         PrintDebug("Deleting specific parameter.")
         paramCountTemp = DeleteParametersFromSchematic(schematic, DELETE_SPECIFIC_PARAMETER, TEditParameterName.Text)

         If paramCountTemp = 0 Then
            ShowMessage("ERROR: Parameter '" + TEditParameterName.Text + "' was not found on schematic.")
         End If

         ' Increment the actual parameter count
         paramCount = paramCount + paramCountTemp

      ElseIf RadioGroupWhichParameters.ItemIndex = DELETE_ALL_PARAMETERS Then
         PrintDebug("Deleting all parameters.")
         paramCountTemp = DeleteParametersFromSchematic(schematic, DELETE_ALL_PARAMETERS, TEditParameterName.Text)

         If paramCountTemp = 0 Then
            ShowMessage("ERROR: No parameters were found on schematic.")
         End If

         ' Increment the actual parameter count
         paramCount = paramCount + paramCountTemp

      Else
         ShowMessage("ERROR: Value of RadioGroupWhichParameters.ItemIndex was out of range.")
      End If

      schematicCount = schematicCount + 1

   ElseIf RadioGroupWhichSchematics.ItemIndex = DELETE_FROM_ALL_SCHEMATICS_IN_ACTIVE_PROJECT Then


       ' Loop through all project documents
        Dim docNum
        For docNum = 0 To pcbProject.DM_LogicalDocumentCount - 1
            Dim document
            Set document = pcbProject.DM_LogicalDocuments(DocNum)

            ' Check to see if this is SCH document
            If document.DM_DocumentKind = "SCH" Then

               ' Cool, it is a schematic, lets open it and then delete parameter(s) from it!

				' 2015-08-10, gbmhunter: Added this next line so that this script can work even if the
				' schematics are not open in Altium
				Call Client.OpenDocument("SCH", document.DM_FullPath)

                Set schematic = SCHServer.GetSchDocumentByPath(document.DM_FullPath)
                'ShowMessage(document.DM_FullPath);
                If schematic Is Nothing Then
                    ShowMessage("ERROR: Sheet '" + Document.DM_FullPath + "' could not be retrieved." + VbCr + VbLf)
                    Exit Sub
                End If

                If RadioGroupWhichParameters.ItemIndex = DELETE_SPECIFIC_PARAMETER Then
                   PrintDebug("Deleting specific parameter.")
                   paramCount = paramCount + DeleteParametersFromSchematic(schematic, DELETE_SPECIFIC_PARAMETER, TEditParameterName.Text)
                ElseIf RadioGroupWhichParameters.ItemIndex = DELETE_ALL_PARAMETERS Then
                   PrintDebug("Deleting all parameters.")
                   paramCount = paramCount + DeleteParametersFromSchematic(schematic, DELETE_ALL_PARAMETERS, TEditParameterName.Text)
                Else
                   ShowMessage("ERROR: Value of RadioGroupWhichParameters.ItemIndex was out of range.")
                End If

                ' Increment sheet count
                schematicCount = schematicCount + 1

            End If ' If document.DM_DocumentKind = "SCH" Then
        Next ' For docNum = 0 To pcbProject.DM_LogicalDocumentCount - 1
   Else
        ShowMessage("ERROR: Value of RadioGroupWhichSchematics.ItemIndex was out of range.")
   End If

    ShowMessage("Deleted '" + CStr(paramCount) + "' parameter(s) from '" + CStr(schematicCount) + "' schematic(s).")

    ' Finished deleting parameters, will can now close the form
    FormDeleteSchematicParameters.Close
    
End Sub

' @brief     Deletes one or all parameters from the provided schematic.
' @param     paramName     The name of the parameter to delete if deleteOneOrAll = DELETE_SPECIFIC_PARAMETER.
'                          If deleteOneOrAll = DELETE_ALL_PARAMETERS this variable is not used.
' @returns   The number of parameters deleted from the schematic.
Function DeleteParametersFromSchematic(schematic, deleteOneOrAll, paramName)


    PrintDebug("DeleteParametersFromSchematic() called with schematic = '" + schematic.DocumentName + "', deleteOneOrAll = '" + CStr(deleteOneOrAll) + "', paramName = '" + paramName + "'.")

    ' Start of undo block
    Call SchServer.ProcessControl.PreProcess(schematic, "")

    Dim deletedParamCount
    deletedParamCount = 0

    '===== DELETE SCHEMATIC PARAMETERS ====='

    ' Set up iterator to look for parameter objects only
    Dim paramIterator
    Set paramIterator = schematic.SchIterator_Create
    If paramIterator Is Nothing Then
          ShowMessage("ERROR: Iterator could not be created.")
          Exit Function
    End If

    paramIterator.AddFilter_ObjectSet(MkSet(eParameter))
    Dim schParameter
    Set schParameter = ParamIterator.FirstSchObject

    Call SchServer.RobotManager.SendMessage(schematic.I_ObjectAddress, c_BroadCast, SCHM_BeginModify, c_NoEventData)

    ' Iterate through schematic parameters and delete them
    Do While Not (schParameter Is Nothing)

        ' Call SchServer.RobotManager.SendMessage(document.I_ObjectAddress, c_BroadCast, SCHM_BeginModify, c_NoEventData)
        'If schParameter.IsSystemParameter = True Then
        '   ShowMessage("Parameter '" + schParameter.Name + "' is system parameter.")
        'End If

          'StdOut("Calling robot.")
          'Call SchServer.RobotManager.SendMessage(sheet.I_ObjectAddress, c_BroadCast, SCHM_PrimitiveRegistration, schParameters.I_ObjectAddress)
          'Call SchServer.RobotManager.SendMessage(null, null, 1, schParameters.I_ObjectAddress)
          'StdOut("Finished robot.")

         If deleteOneOrAll = DELETE_SPECIFIC_PARAMETER Then
              ' Make sure we only delete the requested parameter!
              'ShowMessage("Only deleting the one parameter '" + paramName + "' from schematic '" + schematic.DocumentName + ".")
              If schParameter.Name = paramName Then
                   PrintDebug("Removing parameter '" + schParameter.Name + "'.")
                   schematic.RemoveSchObject(schParameter)
                   Call SchServer.RobotManager.SendMessage(schematic.I_ObjectAddress, c_BroadCast, SCHM_PrimitiveRegistration, schParameter.I_ObjectAddress)

                   deletedParamCount = deletedParamCount + 1

               End If
         ElseIf deleteOneOrAll = DELETE_FROM_ALL_SCHEMATICS_IN_ACTIVE_PROJECT Then
              'ShowMessage("Removing parameter '" + schParameter.Name + "'.")
              schematic.RemoveSchObject(schParameter)
              deletedParamCount = deletedParamCount + 1
         Else ' If RadioGroupWhichSchematic.ItemIndex = DELETE_FROM_ALL_SCHEMATICS_IN_ACTIVE_PROJECT Then
              ShowMessage("ERROR: Invalid value for variable deleteOneOrAll.")
         End If


         Set schParameter = paramIterator.NextSchObject
    Loop

    schematic.SchIterator_Destroy(paramIterator)

    Call SchServer.RobotManager.SendMessage(schematic.I_ObjectAddress, c_BroadCast, SCHM_EndModify, c_NoEventData)

    ' End of undo block
    Call SchServer.ProcessControl.PostProcess(schematic, "")

    ' Redraw schematic sheet
    schematic.GraphicallyInvalidate

    ' Return the number of deleted parameters
    DeleteParametersFromSchematic = deletedParamCount

End Function

Sub ButtonExit_Click(Sender)
    FormDeleteSchematicParameters.Close
End Sub

Private Sub PrintDebug(msg)
    If DEBUG = 1 Then
       ShowMessage(msg)
    End If
End Sub

