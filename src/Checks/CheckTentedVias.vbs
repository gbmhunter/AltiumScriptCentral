Sub CheckTentedVias(dummyVar)
    Dim workspace           'As IWorkspace
    Dim pcbProject          'As IProject
    Dim document            'As IDocument
    Dim violationCnt        'As Integer
    Dim pcbBoard            'As IPCB_Board
    Dim pcbObject           'As IPCB_Primitive;
    Dim docNum              'As Integer
    Dim tentedViaCount      'As Integer
    Dim nonTentedViaCount   'As Integer

    ' Zero count variables
    tentedViaCount = 0
    nonTentedViaCount = 0

    StdOut("Checking tented vias...")
    violationCnt = 0

    ' Obtain the PCB server interface.
    If PCBServer Is Nothing Then
        StdErr("ERROR: PCB server not online." + VbCr + VbLf)
        StdOut("Tented via checking finished." + VbCr + VbLf)
        Exit Sub
    End If

    ' Get pcb project interface
    Set workspace = GetWorkspace
    Set pcbProject = workspace.DM_FocusedProject

    IF pcbProject Is Nothing Then
        StdErr("Current Project is not a PCB Project." + VbCr + VbLf)
        StdOut("Tented via checking finished." + VbCr + VbLf)
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
        StdOut("Tented via checking finished." + VbCr + VbLf)
        Exit Sub
    End If

    Dim pcbIterator

    ' Get iterator, limiting search to mech 1 layer
    Set pcbIterator = pcbBoard.BoardIterator_Create
    If pcbIterator Is Nothing Then
        StdErr("ERROR: PCB iterator could not be created."  + vbCr + vbLf)
        StdOut("Tented via checking finished." + VbCr + VbLf)
        Exit Sub
    End If

    pcbIterator.AddFilter_ObjectSet(MkSet(eViaObject))
    pcbIterator.AddFilter_LayerSet(AllLayers)
    pcbIterator.AddFilter_Method(eProcessAll)

    ' Search  and  count  pads
    Set pcbObject =  pcbIterator.FirstPCBObject
    While Not(pcbObject Is Nothing)
        ' Make sure that only tracks/arcs are present on this layer
        'StdOut("Exp = " + IntToStr(pcbObject.Cache.SolderMaskExpansion) + ",")
        'StdOut("Valid = " + IntToStr(pcbObject.Cache.SolderMaskExpansionValid) + ";")

        If pcbObject.Cache.SolderMaskExpansion*2 <= -pcbObject.Size Then
            ' Via is tented (both sides)
            tentedViaCount = tentedViaCount + 1
        Else
            ' Via is not tented (on both sides)
            nonTentedViaCount = nonTentedViaCount + 1
        End If

        Set pcbObject =  pcbIterator.NextPCBObject
    WEnd

    pcbBoard.BoardIterator_Destroy(pcbIterator)

    'StdOut("Num. tented vias = " + IntToStr(tentedViaCount) + "." + vbCr + vbLf)
    'StdOut("Num. non-tented vias = " + IntToStr(nonTentedViaCount) + "." + vbCr + vbLf)

    ' Calc percentage
    tentedViaRatio = tentedViaCount / (tentedViaCount + nonTentedViaCount)

    ' Output
    StdOut("Tented via ratio = " + FormatNumber(tentedViaRatio) + ". Tented via check complete." + vbCr + vbLf)

    If(tentedViaRatio < MIN_TENTED_VIA_RATIO) Then
        StdErr("ERROR: Tented via ratio violation found (ratio = " + FormatNumber(tentedViaRatio) + ", minimum allowed ratio = " + FormatNumber(MIN_TENTED_VIA_RATIO) + "). Have you forgotten to tent vias?" + vbCr + vbLf)
    End If

End Sub
