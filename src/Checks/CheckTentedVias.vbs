'
' @file               CheckTentedVias.vbs
' @author             Geoffrey Hunter <gbmhunter@gmail.com> (www.mbedded.ninja)
' @created            2013-08-08
' @last-modified      2014-11-11
' @brief              Script that checks to make sure that most vias are tented on the PCB.
' @details
'                     See README.rst in repo root dir for more info.

Sub CheckTentedVias(DummyVar)
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
    TentedViaCount = 0
    NonTentedViaCount = 0

    StdOut("Checking tented vias...")
    ViolationCnt = 0

    ' Obtain the PCB server interface.
    If PCBServer Is Nothing Then
        StdErr("ERROR: PCB server not online." + VbCr + VbLf)
        StdOut("Tented via checking finished." + VbCr + VbLf)
        Exit Sub
    End If

    ' Get pcb project interface
    Set Workspace = GetWorkspace
    Set PcbProject = Workspace.DM_FocusedProject

    If PcbProject Is Nothing Then
        StdErr("Current Project is not a PCB Project." + VbCr + VbLf)
        StdOut("Tented via checking finished." + VbCr + VbLf)
        Exit Sub
    End If

    ' Loop through all project documents
    For DocNum = 0 To PcbProject.DM_LogicalDocumentCount - 1
        Set Document = PcbProject.DM_LogicalDocuments(docNum)
        ' ShowMessage(document.DM_DocumentKind)
        ' If this is PCB document
        If Document.DM_DocumentKind = "PCB" Then
            ' ShowMessage('PCB Found');
            Set PcbBoard = PCBServer.GetPCBBoardByPath(document.DM_FullPath)
            Exit For
        End If
    Next

    ' Should this be gotten from the pcbProject, not the PCB server (so it doesn't have to
    ' be open to work)
    'pcbBoard := pcbProject.DM_TopLevelPhysicalDocument;

    If PcbBoard Is Nothing Then
        StdErr("ERROR: No PCB document found. Path used = " + document.DM_FullPath + "." + vbCr + vbLf)
        StdOut("Tented via checking finished." + VbCr + VbLf)
        Exit Sub
    End If

    ' Get iterator, limiting search to mech 1 layer
    Set PcbIterator = PcbBoard.BoardIterator_Create
    If PcbIterator Is Nothing Then
        StdErr("ERROR: PCB iterator could not be created."  + vbCr + vbLf)
        StdOut("Tented via checking finished." + VbCr + VbLf)
        Exit Sub
    End If

    PcbIterator.AddFilter_ObjectSet(MkSet(eViaObject))
    PcbIterator.AddFilter_LayerSet(AllLayers)
    PcbIterator.AddFilter_Method(eProcessAll)

    ' Search  and  count  pads
    Set PcbObject = PcbIterator.FirstPCBObject
    While Not(PcbObject Is Nothing)
        ' Make sure that only tracks/arcs are present on this layer
        'StdOut("Exp = " + IntToStr(pcbObject.Cache.SolderMaskExpansion) + ",")
        'StdOut("Valid = " + IntToStr(pcbObject.Cache.SolderMaskExpansionValid) + ";")

        If PcbObject.Cache.SolderMaskExpansion*2 <= -PcbObject.Size Then
            ' Via is tented (both sides)
            TentedViaCount = RentedViaCount + 1
        Else
            ' Via is not tented (on both sides)
            NonTentedViaCount = NonTentedViaCount + 1
        End If

        Set PcbObject =  PcbIterator.NextPCBObject
    WEnd

    PcbBoard.BoardIterator_Destroy(pcbIterator)

    'StdOut("Num. tented vias = " + IntToStr(tentedViaCount) + "." + vbCr + vbLf)
    'StdOut("Num. non-tented vias = " + IntToStr(nonTentedViaCount) + "." + vbCr + vbLf)

    ' Calc percentage
    If TentedViaCount + NonTentedViaCount = 0 Then
         ' This would could divide by 0 error, so let's set this to 1
         TentedViaRatio = 1
    Else
        ' Denominator is not 0, so safe to divide
        TentedViaRatio = TentedViaCount / (TentedViaCount + NonTentedViaCount)
    End If

    ' Output
    StdOut("Tented via ratio = " + FormatNumber(tentedViaRatio) + ". Tented via check complete." + vbCr + vbLf)

    If(tentedViaRatio < MIN_TENTED_VIA_RATIO) Then
        StdErr("ERROR: Tented via ratio violation found (ratio = " + FormatNumber(tentedViaRatio) + ", minimum allowed ratio = " + FormatNumber(MIN_TENTED_VIA_RATIO) + "). Have you forgotten to tent vias?" + vbCr + vbLf)
    End If

End Sub
