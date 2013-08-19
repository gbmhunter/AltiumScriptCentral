
Dim violationCnt    'as Integer
Dim pcbBoard        'as IPCB_Board

Sub CheckLayers()
    dim workspace 'as IWorkspace
    dim pcbProject 'as IProject
    dim document 'as IDocument
    dim violationCnt 'as Integer

    Dim pcbObject       'As IPCB_Primitive;
    dim LS 'as String
    dim docNum

    StdOut("Checking layers...")
    violationCnt = 0

    ' Obtain the PCB server interface.
    If PCBServer Is Nothing Then
        StdErr("ERROR: PCB server not online." + VbCr + VbLf)
        Exit Sub
    End If

    ' Get pcb project interface
    Set workspace = GetWorkspace
    Set pcbProject = workspace.DM_FocusedProject

    IF pcbProject Is Nothing Then
        StdErr("Current Project is not a PCB Project." + VbCr + VbLf)
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

    ' Should this be gotten from the pcbProject, not the PCB server (so it doesn't have to
    ' be open to work)
    'pcbBoard := pcbProject.DM_TopLevelPhysicalDocument;

    If pcbBoard Is Nothing Then
        StdErr("ERROR: No PCB document found. Path used = " + document.DM_FullPath + "." + vbCr + vbLf)
        Exit Sub
    End If

    ' ======================
    ' BOARD OUTLINE (Mech 1)
    ' ======================
     CheckBoardOutlineLayer()

    ' 3D Models (Mech 2)

End Sub

Sub CheckBoardOutlineLayer()
    Dim pcbIterator
    Dim pcbObject

    ' Get iterator, limiting search to mech 1 layer
    Set pcbIterator = pcbBoard.BoardIterator_Create
    If pcbIterator Is Nothing Then
        StdErr("ERROR: PCB iterator could not be created."  + vbCr + vbLf)
        Exit Sub
    End If

    pcbIterator.AddFilter_ObjectSet(AllObjects)
    pcbIterator.AddFilter_LayerSet(MkSet(eMechanical1))
    pcbIterator.AddFilter_Method(eProcessAll)

    ' Search  and  count  pads
    Set pcbObject =  pcbIterator.FirstPCBObject
    While Not(pcbObject Is Nothing)
        ' Make sure that only tracks/arcs are present on this layer
        If(pcbObject.ObjectId <> eTrackObject) and (pcbObject.ObjectId <> eArcObject) Then
            Inc(violationCnt)
        End If
        Set pcbObject =  pcbIterator.NextPCBObject
    WEnd

    pcbBoard.BoardIterator_Destroy(pcbIterator)

    ' OUTPUT
    If(violationCnt = 0) Then
        StdOut(" No board outline layer violations found." + vbCr + vbLf)
    End If
    If(violationCnt <> 0) Then
        StdErr("ERROR: Board outline layer violation(s) found. Number of violations = " + IntToStr(violationCnt) + "." + vbCr + vbLf)
    End If
End Sub
