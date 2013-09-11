Sub CheckPcbTextHasCorrectOrientation()

    Dim workspace           'As IWorkspace
    Dim pcbProject          'As IProject
    Dim document            'As IDocument
    Dim pcbBoard            'As IPCB_Board
    Dim pcbObject           'As IPCB_Primitive;
    Dim docNum              'As Integer
    Dim violationCount      'As Integer

    StdOut("Checking PCB text has correct orientation...")

    violationCount = 0

    ' Obtain the PCB server interface.
    If PCBServer Is Nothing Then
        StdErr("ERROR: PCB server not online." + VbCr + VbLf)
        StdOut("PCB text orientation check complete." + vbCr + vbLf)
        Exit Sub
    End If

    ' Get pcb project interface
    Set workspace = GetWorkspace
    Set pcbProject = workspace.DM_FocusedProject

    IF pcbProject Is Nothing Then
        StdErr("Current Project is not a PCB Project." + VbCr + VbLf)
        StdOut("PCB text orientation check complete." + vbCr + vbLf)
        Exit Sub
    End If

    ' Loop through all project documents
    For docNum = 0 To pcbProject.DM_LogicalDocumentCount - 1
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
        StdErr("ERROR: No PCB document found. Path used = " + document.DM_FullPath + "." + vbCr + vbLf)
        StdOut("PCB text orientation check complete." + vbCr + vbLf)
        Exit Sub
    End If

    Dim pcbIterator

    ' Get iterator, limiting search to mech 1 layer
    Set pcbIterator = pcbBoard.BoardIterator_Create
    If pcbIterator Is Nothing Then
        StdErr("ERROR: PCB iterator could not be created."  + vbCr + vbLf)
        StdOut("PCB text orientation check complete." + vbCr + vbLf)   
        Exit Sub
    End If

    ' Look at strings
    pcbIterator.AddFilter_ObjectSet(MkSet(eTextObject))
    pcbIterator.AddFilter_LayerSet(AllLayers)
    pcbIterator.AddFilter_Method(eProcessAll)

    ' Iterate through all found strings
    Set pcbObject =  pcbIterator.FirstPCBObject
    While Not(pcbObject Is Nothing)
        ' Make sure that only tracks/arcs are present on this layer
        'StdOut("Exp = " + IntToStr(pcbObject.Cache.SolderMaskExpansion) + ",")
        'StdOut("Valid = " + IntToStr(pcbObject.Cache.SolderMaskExpansionValid) + ";")
        If(pcbObject.Layer = eTopOverlay) And (pcbObject.MirrorFlag = true) Then
            violationCount = violationCount + 1
            StdErr("ERROR: PCB text '" + pcbObject.Text + "' on the top overlay is mirrored." + VbCr + VbLf)
        End If

        If(pcbObject.Layer = eBottomOverlay) And (pcbObject.MirrorFlag = false) Then
            violationCount = violationCount + 1
            StdErr("ERROR: PCB text '" + pcbObject.Text + "' on the bottom overlay is not mirrored." + VbCr + VbLf)
        End If

        Set pcbObject =  pcbIterator.NextPCBObject
    WEnd

    pcbBoard.BoardIterator_Destroy(pcbIterator)

   ' If violations then print to StdErr
    If Not violationCount = 0 Then
        StdOut("ERROR: PCB text orientation violation(s) found. Please make sure text on the top layer is not mirrored, and text on the bottom layer is mirrored. Num. violations = " + IntToStr(violationCount) + ".")
    End If

    ' Output
    StdOut(" PCB text orientation check complete." + vbCr + vbLf)

End Sub


