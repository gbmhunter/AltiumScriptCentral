'
' @file               CheckWeHavePcbDocAccess.vbs
' @author             Geoffrey Hunter <gbmhunter@gmail.com> (www.mbedded.ninja)
' @created            2014-11-04
' @last-modified      2014-11-11
' @brief              Script that checks to make sure we have access to a PCB document belonging to the current project.
' @details
'                     See README.rst in repo root dir for more info.

' @brief       Checks to make sure we have access to a PCB document belonging to the current project.
' @details
' @returns     Returns True if we have access, otherwise false.
Function CheckWeHavePcbDocAccess(dummyVar)

    StdOut("Checking we have PCB access...")

    ' Obtain the PCB server interface.
    If PCBServer Is Nothing Then
        StdErr("ERROR: PCB server not online." + VbCr + VbLf)
        Exit Function
    End If

    ' Get pcb project interface
    Set workspace = GetWorkspace
    Set pcbProject = workspace.DM_FocusedProject

    IF pcbProject Is Nothing Then
        StdErr("Current Project is not a PCB Project." + VbCr + VbLf)
        Exit Function
    End If

    ' Loop through all project documents
    For docNum = 0 To pcbProject.DM_LogicalDocumentCount - 1
        Set document = pcbProject.DM_LogicalDocuments(docNum)
        ' ShowMessage(document.DM_DocumentKind)
        ' If this is PCB document
        If document.DM_DocumentKind = "PCB" Then
            ' ShowMessage('PCB Found');
            ' Try a get the current PCB file, this will only work if
            ' it is open
            Set pcbBoard = PCBServer.GetPCBBoardByPath(document.DM_FullPath)
            Exit For
        End If
    Next

    If pcbBoard Is Nothing Then
        StdErr("ERROR: Could not get access to PcbDoc file. Please make sure PCB file is open and run checks again." + VbCr + VbLf)
       CheckWeHavePcbDocAccess = False
       StdOut(" PCB access checking complete." + VbCr + VbLf)
       Exit Function
    End If

    ' If code reaches here, compilation was successful
    StdOut("We have PCB access.")
    StdOut(" PCB access checking complete." + VbCr + VbLf)
    CheckWeHavePcbDocAccess = True
End Function
