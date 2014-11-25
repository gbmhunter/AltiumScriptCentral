'
' @file               NumberSchematics.vbs
' @author             Geoffrey Hunter <gbmhunter@gmail.com> (www.mbedded.ninja)
' @created            2013-08-08
' @last-modified      2014-11-26
' @brief              Numbers all schematic sheets for the current project. Designed to work
'                     with a schematic template which displays the sheet number and total sheets
'                     on the schematic.
' @details
'                     See README.rst in repo root dir for more info.

' @brief     Numbers all schematic sheets for the current project.
' @param     DummyVar    Dummy variable so that this sub does not show up to the user when
'                        they click "Run Script".
Sub NumberSchematics(dummyVar)
    Dim workspace           ' As IWorkspace
    Dim pcbProject          ' As IProject
    Dim document            ' As IDocument
    Dim flatHierarchy       ' As IDocument
    Dim sheet               ' As ISch_Document
    Dim docNum              ' As Integer
    Dim compIterator        ' As ISch_Iterator
    Dim component           ' As IComponent
    Dim projParameter       ' As IParameter
    Dim sheetCountParam     ' As
    Dim totalSheetsParam    ' As
    Dim schematicSheetCount ' As Integer
    Dim totalSheetCount     ' As Integer

    'StdOut("Numbering schematics...")

    ' Obtain the schematic server interface.
    If SchServer Is Nothing Then
        ShowMessage("ERROR: Schematic server not online." + VbLf + VbCr)
        Exit Sub
    End If

    ' Get pcb project interface
    Set workspace = GetWorkspace
    Set pcbProject = workspace.DM_FocusedProject

    If pcbProject Is Nothing Then
        ShowMessage("ERROR: Current Project is not a PCB Project" + VbLf + VbCr)
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
      ShowMessage("ERROR: Compile the project before running this script." + VbCr + VbLf)
      Exit Sub
   End If

   totalSheetCount = 0

   ' COUNT SCHEMATIC SHEETS

    ' Loop through all project documents to count schematic sheets
    For docNum = 0 To pcbProject.DM_LogicalDocumentCount - 1
        Set document = pcbProject.DM_LogicalDocuments(docNum)

        ' If this is SCH document
        If document.DM_DocumentKind = "SCH" Then
            Set sheet = SCHServer.GetSchDocumentByPath(document.DM_FullPath)
            If sheet Is Nothing Then
                ShowMessage("ERROR: Sheet '" + document.DM_FullPath + "' could not be retrieved." + VbCr + VbLf)
                Exit Sub
            End If
            ' Increment count
            totalSheetCount = totalSheetCount + 1
        End If ' If document.DM_DocumentKind = "SCH" Then
    Next

    ' ADD SCHEMATIC NUMBER AND TOTAL COUNT

    schematicSheetCount = 0

     ' Now loop through all project documents again to number sheets
    For docNum = 0 To pcbProject.DM_LogicalDocumentCount - 1
        Set document = pcbProject.DM_LogicalDocuments(docNum)

        ' If this is SCH document
        If document.DM_DocumentKind = "SCH" Then
            Set sheet = SCHServer.GetSchDocumentByPath(document.DM_FullPath)
            'ShowMessage(document.DM_FullPath);
            If sheet Is Nothing Then
                ShowMessage("ERROR: No sheet found." + VbCr + VbLf)
                Exit Sub
            End If

            ' Increment sheet count
            schematicSheetCount = schematicSheetCount + 1

            ' Start of undo block
            Call SchServer.ProcessControl.PreProcess(sheet, "")

            ' REMOVE EXISTING PARAMETERS IF THEY EXIST

            ' Set up iterator to look for parameter objects only
            Set paramIterator = sheet.SchIterator_Create
            If paramIterator Is Nothing Then
                ShowMessage("ERROR: Iterator could not be created.")
                Exit Sub
            End If

            ' Set up iterator mask
            paramIterator.AddFilter_ObjectSet(MkSet(eParameter))
            Set schParameters = paramIterator.FirstSchObject

            ' Iterate through exising parameters
            Do While Not (schParameters Is Nothing)
                 If schParameters.Name = SCHEMATIC_SHEET_COUNT_PARAM_NAME Or schParameters.Name = TOTAL_SHEET_PARAM_NAME Then
                       ' Remove parameter before adding again
                       sheet.RemoveSchObject(schParameters)
                       'Call SchServer.RobotManager.SendMessage(sheet.I_ObjectAddress, c_BroadCast, SCHM_PrimitiveRegistration, schParameters.I_ObjectAddress)
                 End If

                Set schParameters = paramIterator.NextSchObject
            Loop

            sheet.SchIterator_Destroy(paramIterator)

            ' Add schematic sheet number and total count as parameters

            sheetCountParam = SchServer.SchObjectFactory(eParameter, eCreate_Default)
            sheetCountParam.Name = SCHEMATIC_SHEET_COUNT_PARAM_NAME
            sheetCountParam.Text = schematicSheetCount
            sheet.AddSchObject(sheetCountParam)

            ' Tell server about change
            'Call SchServer.RobotManager.SendMessage(sheet.I_ObjectAddress, c_BroadCast, SCHM_PrimitiveRegistration, sheetCountParam.I_ObjectAddress)

            totalSheetsParam = SchServer.SchObjectFactory(eParameter, eCreate_Default)
            totalSheetsParam.Name = TOTAL_SHEET_PARAM_NAME
            totalSheetsParam.Text = totalSheetCount
            sheet.AddSchObject(totalSheetsParam)

            ' Tell server about change
            'Call SchServer.RobotManager.SendMessage(sheet.I_ObjectAddress, c_BroadCast, SCHM_PrimitiveRegistration, totalSheetsParam.I_ObjectAddress)

            ' End of undo block
            Call SchServer.ProcessControl.PostProcess(sheet, "")

        End If ' If document.DM_DocumentKind = "SCH" Then
    Next ' For docNum = 0 To pcbProject.DM_LogicalDocumentCount - 1

    ShowMessage("Schematic numbers have been added to '" + CStr(totalSheetCount) + "' sheets.")

End Sub
