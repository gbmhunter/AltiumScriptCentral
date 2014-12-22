'
' @file               CheckWeHavePcbDocAccess.vbs
' @author             Geoffrey Hunter <gbmhunter@gmail.com> (www.mbedded.ninja)
' @created            2014-11-04
' @last-modified      2014-12-22
' @brief              Script that checks to make sure we have access to a PCB document belonging to the current project.
' @details
'                     See README.rst in repo root dir for more info.

' Forces us to explicitly define all variables before using them
Option Explicit

Private ModuleName
ModuleName = "CheckWeHavePcbDocAccess.vbs"

' @brief       Checks to make sure we have access to a PCB document belonging to the current project.
' @details
' @param     DummyVar     Dummy variable to stop function appearing in the Altium "Run Script" dialogue.
' @returns     Returns True if we have access, otherwise false.
Function CheckWeHavePcbDocAccess(DummyVar)

    StdOut("Checking we have PCB access...")

    ' Obtain the PCB server interface.
    Client.StartServer("PCB")
    If PCBServer Is Nothing Then
        Call StdErr(ModuleName, "PCB server not online and could not be started.")
        Exit Function
    End If

    ' Get pcb project interface
    Dim Workspace
    Set Workspace = GetWorkspace

    Dim PcbProject
    Set PcbProject = workspace.DM_FocusedProject

    IF PcbProject Is Nothing Then
        Call StdErr(ModuleName, "Current project is not a PCB project.")
        Exit Function
    End If

    Dim DocNum
    Dim Document
    Dim PcbDocument
    Dim PcbBoard

    ' Loop through all project documents
    For DocNum = 0 To PcbProject.DM_LogicalDocumentCount - 1
        Set Document = PcbProject.DM_LogicalDocuments(DocNum)
        ' ShowMessage(document.DM_DocumentKind)
        ' If this is PCB document
        If Document.DM_DocumentKind = "PCB" Then
            ' ShowMessage('PCB Found');

            ' Open the PCB document, so we can then can a handle for it
            PcbDocument = Client.OpenDocument("PCB", Document.DM_FullPath)
            ' Try a get the current PCB file, this will only work if
            ' it is open
            Set PcbBoard = PCBServer.GetPCBBoardByPath(Document.DM_FullPath)
            Exit For
        End If
    Next

    If PcbBoard Is Nothing Then
       Call StdErr(ModuleName, "Could not get access to PcbDoc file. Please make sure PCB file is open and run checks again.")
       CheckWeHavePcbDocAccess = False
       StdOut(" PCB access checking complete." + VbCr + VbLf)
       Exit Function
    End If

    ' If code reaches here, compilation was successful
    StdOut("We have PCB access.")
    StdOut(" PCB access checking complete." + VbCr + VbLf)
    CheckWeHavePcbDocAccess = True
End Function
