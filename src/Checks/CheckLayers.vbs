'
' @file               Main.vbs
' @author             Geoffrey Hunter <gbmhunter@gmail.com> (www.mbedded.ninja)
' @created            2013-08-08
' @last-modified      2014-11-04
' @brief              Script functions which check the PCB layers for violating objects.
' @details
'                     See README.rst in repo root dir for more info.

Function CheckLayers(dummyVar)
    Dim workspace       ' As IWorkspace
    Dim pcbProject      ' As IProject
    Dim document        ' As IDocument
    Dim violationCnt    ' As Integer

    Dim pcbObject       ' As IPCB_Primitive
    Dim docNum          ' As Integer

    violationCnt = 0

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
            Set pcbBoard = PCBServer.GetPCBBoardByPath(document.DM_FullPath)
            Exit For
        End If
    Next

    ' Should this be gotten from the pcbProject, not the PCB server (so it doesn't have to
    ' be open to work)
    'pcbBoard = pcbProject.DM_TopLevelPhysicalDocument

    If pcbBoard Is Nothing Then
        StdErr("ERROR: No open PCB document found. Path used = '" + document.DM_FullPath + "'. Please open PCB file." + vbCr + vbLf)
        Exit Function
    End If

    CheckBoardOutlineLayer(pcbBoard)
    CheckTopDimensionsLayer(pcbBoard)
    CheckBotDimensionsLayer(pcbBoard)
    CheckTopMechBodyLayer(pcbBoard)
    CheckBotMechBodyLayer(pcbBoard)
    CheckUnusedLayers(pcbBoard)

End Function

Sub CheckBoardOutlineLayer(pcbBoard)
    Dim pcbIterator
    Dim pcbObject
    Dim violationCnt    'As Integer

    StdOut("Checking board outline layer...")

    ' Init violation count
    violationCnt = 0

    ' Get iterator, limiting search to mech 1 layer
    Set pcbIterator = pcbBoard.BoardIterator_Create
    If pcbIterator Is Nothing Then
        StdErr("ERROR: PCB iterator could not be created."  + vbCr + vbLf)
        Exit Sub
    End If

    pcbIterator.AddFilter_ObjectSet(AllObjects)
    pcbIterator.AddFilter_LayerSet(MkSet(BOARD_OUTLINE_LAYER))
    pcbIterator.AddFilter_Method(eProcessAll)

    ' Search  and  count  pads
    Set pcbObject =  pcbIterator.FirstPCBObject
    While Not(pcbObject Is Nothing)
        ' Make sure that only tracks/arcs are present on this layer
        If(pcbObject.ObjectId <> eTrackObject) and (pcbObject.ObjectId <> eArcObject) Then
            violationCnt = violationCnt + 1
        End If
        Set pcbObject =  pcbIterator.NextPCBObject
    WEnd

    pcbBoard.BoardIterator_Destroy(pcbIterator)

    ' OUTPUT
    StdOut(" Board outline layer check complete." + vbCr + vbLf)

    If(violationCnt <> 0) Then
        StdErr("ERROR: Board outline layer violation(s) found. Number of violations = " + IntToStr(violationCnt) + "." + vbCr + vbLf)
    End If
End Sub

Sub CheckTopDimensionsLayer(pcbBoard)
    Dim pcbIterator
    Dim pcbObject
    Dim violationCnt    'As Integer

    StdOut("Checking top dimension layer...")

    ' Get iterator, limiting search to specific layer
    Set pcbIterator = pcbBoard.BoardIterator_Create
    If pcbIterator Is Nothing Then
        StdErr("ERROR: PCB iterator could not be created."  + vbCr + vbLf)
        Exit Sub
    End If

    pcbIterator.AddFilter_ObjectSet(AllObjects)
    pcbIterator.AddFilter_LayerSet(MkSet(TOP_DIMENSIONS_LAYER))
    pcbIterator.AddFilter_Method(eProcessAll)

    ' Search  and  count  pads
    Set pcbObject =  pcbIterator.FirstPCBObject
    While Not(pcbObject Is Nothing)
        ' Make sure that only tracks/arcs/linear dimensions/angular dimensions are present on this layer
        If(pcbObject.ObjectId <> eTrackObject) And (pcbObject.ObjectId <> eArcObject) And (pcbObject.ObjectId <> eDimensionObject) And (pcbObject.ObjectId <> eLine) Then
            violationCnt = violationCnt + 1
            StdOut("Enum = " + IntToStr(pcbObject.ObjectId))
        End If
        Set pcbObject =  pcbIterator.NextPCBObject
    WEnd

    pcbBoard.BoardIterator_Destroy(pcbIterator)

    ' OUTPUT
    StdOut(" Top dimension layer check complete." + vbCr + vbLf)

    If(violationCnt <> 0) Then
        StdErr("ERROR: Top dimension layer violation(s) found. Number of violations = " + IntToStr(violationCnt) + "." + vbCr + vbLf)
    End If
End Sub

Sub CheckBotDimensionsLayer(pcbBoard)
    Dim pcbIterator
    Dim pcbObject
    Dim violationCnt    'As Integer

    StdOut("Checking bottom dimension layer...")

    ' Get iterator, limiting search to specific layer
    Set pcbIterator = pcbBoard.BoardIterator_Create
    If pcbIterator Is Nothing Then
        StdErr("ERROR: PCB iterator could not be created."  + vbCr + vbLf)
        Exit Sub
    End If

    pcbIterator.AddFilter_ObjectSet(AllObjects)
    pcbIterator.AddFilter_LayerSet(MkSet(BOT_DIMENSIONS_LAYER))
    pcbIterator.AddFilter_Method(eProcessAll)

    ' Search  and  count  pads
    Set pcbObject =  pcbIterator.FirstPCBObject
    While Not(pcbObject Is Nothing)
        ' Make sure that only tracks/arcs/dimensions are present on this layer
        If(pcbObject.ObjectId <> eTrackObject) And (pcbObject.ObjectId <> eArcObject) And (pcbObject.ObjectId <> eDimensionObject) And (pcbObject.ObjectId <> eLine) Then
            violationCnt = violationCnt + 1
            StdOut("Enum = " + IntToStr(pcbObject.ObjectId))
        End If
        Set pcbObject =  pcbIterator.NextPCBObject
    WEnd

    pcbBoard.BoardIterator_Destroy(pcbIterator)

    ' OUTPUT
    StdOut(" Bottom dimension layer check complete." + vbCr + vbLf)

    If(violationCnt <> 0) Then
        StdErr("ERROR: Bottom dimension layer violation(s) found. Number of violations = " + IntToStr(violationCnt) + "." + vbCr + vbLf)
    End If
End Sub

Sub CheckTopMechBodyLayer(pcbBoard)
    Dim pcbIterator
    Dim pcbObject
    Dim violationCnt    'As Integer

    StdOut("Checking top mechanical body layer...")

    ' Get iterator, limiting search to specific layer
    Set pcbIterator = pcbBoard.BoardIterator_Create
    If pcbIterator Is Nothing Then
        StdErr("ERROR: PCB iterator could not be created."  + vbCr + vbLf)
        Exit Sub
    End If

    pcbIterator.AddFilter_ObjectSet(AllObjects)
    pcbIterator.AddFilter_LayerSet(MkSet(TOP_MECH_BODY_LAYER))
    pcbIterator.AddFilter_Method(eProcessAll)

    ' Search  and  count  pads
    Set pcbObject =  pcbIterator.FirstPCBObject
    While Not(pcbObject Is Nothing)
        ' Make sure that only tracks/arcs/3d bodies are present on this layer
        If(pcbObject.ObjectId <> eTrackObject) And (pcbObject.ObjectId <> eArcObject) And (pcbObject.ObjectId <> eComponentBodyObject) And (pcbObject.IsKeepout <> True) Then
            violationCnt = violationCnt + 1
        End If
        Set pcbObject =  pcbIterator.NextPCBObject
    WEnd

    pcbBoard.BoardIterator_Destroy(pcbIterator)

    ' OUTPUT
    StdOut(" Top mech body layer check complete." + vbCr + vbLf)

    If(violationCnt <> 0) Then
        StdErr("ERROR: Top mech body layer violation(s) found. Number of violations = " + IntToStr(violationCnt) + "." + vbCr + vbLf)
    End If
End Sub

Sub CheckBotMechBodyLayer(pcbBoard)
    Dim pcbIterator
    Dim pcbObject
    Dim violationCnt    'As Integer

    StdOut("Checking bottom mechanical body layer...")

    ' Get iterator, limiting search to specific layer
    Set pcbIterator = pcbBoard.BoardIterator_Create
    If pcbIterator Is Nothing Then
        StdErr("ERROR: PCB iterator could not be created."  + vbCr + vbLf)
        Exit Sub
    End If

    pcbIterator.AddFilter_ObjectSet(AllObjects)
    pcbIterator.AddFilter_LayerSet(MkSet(BOT_MECH_BODY_LAYER))
    pcbIterator.AddFilter_Method(eProcessAll)

    ' Search  and  count  pads
    Set pcbObject =  pcbIterator.FirstPCBObject
    While Not(pcbObject Is Nothing)
        ' Make sure that only tracks/arcs/3d bodies are present on this layer
        If(pcbObject.ObjectId <> eTrackObject) and (pcbObject.ObjectId <> eArcObject) And (pcbObject.ObjectId <> eComponentBodyObject) And (pcbObject.IsKeepout <> True) Then
            violationCnt = violationCnt + 1
        End If
        Set pcbObject =  pcbIterator.NextPCBObject
    WEnd

    pcbBoard.BoardIterator_Destroy(pcbIterator)

    ' OUTPUT
    StdOut(" Bottom mechanical body layer check complete." + vbCr + vbLf)

    If(violationCnt <> 0) Then
        StdErr("ERROR: Bottom mechanical body layer violation(s) found. Number of violations = " + IntToStr(violationCnt) + "." + vbCr + vbLf)
    End If
End Sub

Sub CheckUnusedLayers(pcbBoard)
    Dim pcbIterator
    Dim pcbObject
    Dim violationCnt    'As Integer

    StdOut("Checking unused layers...")

    ' Get iterator, limiting search to specific layer
    Set pcbIterator = pcbBoard.BoardIterator_Create
    If pcbIterator Is Nothing Then
        StdErr("ERROR: PCB iterator could not be created."  + vbCr + vbLf)
        Exit Sub
    End If

    pcbIterator.AddFilter_ObjectSet(AllObjects)
    pcbIterator.AddFilter_LayerSet(UNUSED_LAYERS)
    pcbIterator.AddFilter_Method(eProcessAll)

    ' Search  and  count  pads
    Set pcbObject =  pcbIterator.FirstPCBObject
    While Not(pcbObject Is Nothing)
        ' Nothing is allowed on usued layers
        violationCnt = violationCnt + 1
        Set pcbObject =  pcbIterator.NextPCBObject
    WEnd

    pcbBoard.BoardIterator_Destroy(pcbIterator)

    If(violationCnt <> 0) Then
        StdErr("ERROR: Unused layer violation(s) found. Number of violations = " + IntToStr(violationCnt) + "." + vbCr + vbLf)
        StdOut("ERROR: Unused layer violation(s) found.")
    End If

    ' OUTPUT
    StdOut(" Unused layer check complete." + vbCr + vbLf)
End Sub
