'
' @file               DeleteAllSchematicParameters.vbs
' @author             Geoffrey Hunter <gbmhunter@gmail.com> (www.mbedded.ninja)
' @created            2013-08-08
' @last-modified      2014-12-22
' @brief              Deletes all schematic parameters for the current project.
' @details
'                     See README.rst in repo root dir for more info.

' Forces us to explicitly define all variables before using them
Option Explicit

Private ModuleName
ModuleName = "DeleteAllSchematicParameters.vbs"

' @brief     Deletes all schematic parameters.
' @param     DummyVar    Dummy variable so that this sub does not show up to the user when
'                        they click "Run Script".
Sub DeleteAllSchematicParameters(DummyVar)

    'ShowMessage("Deleting all schematic parameters...")

    ' Obtain the schematic server interface.
    If SchServer Is Nothing Then
        ShowMessage("ERROR: Schematic server not online." + VbLf + VbCr)
        Exit Sub
    End If

    ' Get pcb project interface
    Dim Workspace
    Set Workspace = GetWorkspace

    Dim PcbProject
    Set PcbProject = Workspace.DM_FocusedProject

    If PcbProject Is Nothing Then
        ShowMessage("ERROR: Current project is not a PCB project." + VbLf + VbCr)
        Exit Sub
    End If

    ' COMPILE PROJECT

    Call ResetParameters
    Call AddStringParameter("Action", "Compile")
    Call AddStringParameter("ObjectKind", "Project")
    Call RunProcess("WorkspaceManager:Compile")

    Dim FlatHierarchy
    Set FlatHierarchy = PcbProject.DM_DocumentFlattened

   ' If we couldn't get the flattened sheet, then most likely the project has
   ' not been compiled recently
   If FlatHierarchy Is Nothing Then
      'ShowMessage("ERROR: Compile the project before running this script." + VbCr + VbLf)
      'Exit Sub
   End If

   Dim SheetCount
   SheetCount = 0

    ' Loop through all project documents
    Dim DocNum
    For DocNum = 0 To PcbProject.DM_LogicalDocumentCount - 1
        Dim Document
        Set Document = PcbProject.DM_LogicalDocuments(DocNum)

        ' If this is SCH document
        If Document.DM_DocumentKind = "SCH" Then
            Dim Sheet
            Set Sheet = SCHServer.GetSchDocumentByPath(Document.DM_FullPath)
            'ShowMessage(document.DM_FullPath);
            If Sheet Is Nothing Then
                ShowMessage("ERROR: Sheet '" + Document.DM_FullPath + "' could not be retrieved." + VbCr + VbLf)
                Exit Sub
            End If

            ' Start of undo block
            Call SchServer.ProcessControl.PreProcess(Sheet, "")

            ' Add all project parameters to this schematic


            ' DELETE SCHEMATIC PARAMETERS

            ' Set up iterator to look for parameter objects only
            Dim ParamIterator
            Set ParamIterator = Sheet.SchIterator_Create
            If ParamIterator Is Nothing Then
                ShowMessage("ERROR: Iterator could not be created.")
                Exit Sub
            End If

            ParamIterator.AddFilter_ObjectSet(MkSet(eParameter))
            Dim SchParameters
            Set SchParameters = ParamIterator.FirstSchObject

           ' Call SchServer.RobotManager.SendMessage(document.I_ObjectAddress, c_BroadCast, SCHM_BeginModify, c_NoEventData)

            ' Iterate through schematic parameters and delete them
            Do While Not (SchParameters Is Nothing)
               Sheet.RemoveSchObject(SchParameters)
               'StdOut("Calling robot.")
               'Call SchServer.RobotManager.SendMessage(sheet.I_ObjectAddress, c_BroadCast, SCHM_PrimitiveRegistration, schParameters.I_ObjectAddress)
               'Call SchServer.RobotManager.SendMessage(null, null, 1, schParameters.I_ObjectAddress)
               'StdOut("Finished robot.")

                Set SchParameters = ParamIterator.NextSchObject
            Loop

            Sheet.SchIterator_Destroy(ParamIterator)

            ' Redraw schematic sheet
            Sheet.GraphicallyInvalidate

            ' Increment sheet count
            SheetCount = SheetCount + 1

            ' End of undo block
            Call SchServer.ProcessControl.PostProcess(Sheet, "")

        End If ' If document.DM_DocumentKind = "SCH" Then
    Next ' For docNum = 0 To pcbProject.DM_LogicalDocumentCount - 1

    ShowMessage("Deleted parameters from '" + CStr(SheetCount) + "' sheets.")

End Sub
