'
' @file               CheckPcbTextHasCorrectOrientation.vbs
' @author             Geoffrey Hunter <gbmhunter@gmail.com> (www.mbedded.ninja)
' @created            2013-08-08
' @last-modified      2015-01-14
' @brief              Checks that PCB text has the correct orientation (top-layer text not mirrored,
'                     bottom layer text mirrored).
' @details
'                     See README.rst in repo root dir for more info.

' Forces us to explicitly define all variables before using them
Option Explicit

Private ModuleName
ModuleName = "CheckPcbTextHasCorrectOrientation.vbs"

' @brief     Checks that PCB text has the correct orientation (top-layer text not mirrored,
'            bottom layer text mirrored).
' @param     DummyVar     Dummy variable to stop function appearing in the Altium "Run Script" dialogue.
Sub CheckPcbTextHasCorrectOrientation(DummyVar)

    StdOut("Checking PCB text has correct orientation...")

    Dim violationCount      'As Integer
    ViolationCount = 0

    ' Obtain the PCB server interface.
    If PCBServer Is Nothing Then
        Call StdErr(ModuleName, "PCB server not online.")
        StdOut("PCB text orientation check complete." + vbCr + vbLf)
        Exit Sub
    End If

    ' Get pcb project interface
    Dim workspace           'As IWorkspace
    Set workspace = GetWorkspace

    Dim pcbProject          'As IProject
    Set pcbProject = workspace.DM_FocusedProject

    If pcbProject Is Nothing Then
        Call StdErr(ModuleName, "Current project is not a PCB project.")
        StdOut("PCB text orientation check complete." + vbCr + vbLf)
        Exit Sub
    End If

    ' Loop through all project documents
    Dim docNum              'As Integer
    Dim pcbBoard            'As IPCB_Board
    For docNum = 0 To pcbProject.DM_LogicalDocumentCount - 1
        Dim document            'As IDocument
        Set document = pcbProject.DM_LogicalDocuments(docNum)
        ' ShowMessage(document.DM_DocumentKind)
        ' If this is PCB document
        If document.DM_DocumentKind = "PCB" Then
            ' ShowMessage('PCB Found');
            Set pcbBoard = PCBServer.GetPCBBoardByPath(document.DM_FullPath)
            Exit For
        End If
    Next

    If pcbBoard Is Nothing Then
        Call StdErr(ModuleName, "No PCB document found. Path used = " + document.DM_FullPath + ".")
        StdOut("PCB text orientation check complete." + vbCr + vbLf)
        Exit Sub
    End If

    Dim pcbIterator

    ' Get iterator, limiting search to mech 1 layer
    Set pcbIterator = pcbBoard.BoardIterator_Create
    If pcbIterator Is Nothing Then
        Call StdErr(ModuleName, "PCB iterator could not be created.")
        StdOut("PCB text orientation check complete." + vbCr + vbLf)   
        Exit Sub
    End If

    ' Look at strings
    pcbIterator.AddFilter_ObjectSet(MkSet(eTextObject))
    pcbIterator.AddFilter_LayerSet(AllLayers)
    pcbIterator.AddFilter_Method(eProcessAll)

    ' Iterate through all found strings
    Dim pcbObject           'As IPCB_Primitive;
    Set pcbObject =  pcbIterator.FirstPCBObject
    While Not(pcbObject Is Nothing)
        ' Make sure that only tracks/arcs are present on this layer
        'StdOut("Exp = " + IntToStr(pcbObject.Cache.SolderMaskExpansion) + ",")
        'StdOut("Valid = " + IntToStr(pcbObject.Cache.SolderMaskExpansionValid) + ";")
        If(pcbObject.Layer = eTopOverlay) And (pcbObject.MirrorFlag = true) Then
            violationCount = violationCount + 1
            Call StdErr(ModuleName, "PCB text '" + pcbObject.Text + "' on the top overlay is mirrored.")
        End If

        If(pcbObject.Layer = eBottomOverlay) And (pcbObject.MirrorFlag = false) Then
            violationCount = violationCount + 1
            Call StdErr(ModuleName, "PCB text '" + pcbObject.Text + "' on the bottom overlay is not mirrored.")
        End If

        Set pcbObject =  pcbIterator.NextPCBObject
    WEnd

    pcbBoard.BoardIterator_Destroy(pcbIterator)

   ' If violations then print to StdErr
    If Not ViolationCount = 0 Then
        StdOut("ERROR: PCB text orientation violation(s) found. Please make sure text on the top layer is not mirrored, and text on the bottom layer is mirrored. Num. violations = " + IntToStr(violationCount) + ".")
    End If

    ' Output
    StdOut(" PCB text orientation check complete." + vbCr + vbLf)

End Sub


