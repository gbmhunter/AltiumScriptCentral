'
' @file               CheckLayers.vbs
' @author             Geoffrey Hunter <gbmhunter@gmail.com> (www.mbedded.ninja)
' @created            2013-08-08
' @last-modified      2014-12-22
' @brief              Script functions which check the PCB layers for violating objects.
' @details
'                     See README.rst in repo root dir for more info.

' Forces us to explicitly define all variables before using them
Option Explicit

' @brief The name of this module for logging purposes
Private ModuleName
ModuleName = "CheckLayers.vbs"

' @param     DummyVar     Dummy variable to stop function appearing in the Altium "Run Script" dialogue.
Function CheckLayers(DummyVar)
    Dim Workspace       ' As IWorkspace
    Dim PcbProject      ' As IProject
    Dim Document        ' As IDocument
    Dim ViolationCnt    ' As Integer

    Dim PcbObject       ' As IPCB_Primitive
    Dim DocNum          ' As Integer

    ViolationCnt = 0

    ' Obtain the PCB server interface.
    If PCBServer Is Nothing Then
        Call StdErr(ModuleName, "PCB server not online.")
        Exit Function
    End If

    ' Get pcb project interface
    Set Workspace = GetWorkspace
    Set PcbProject = workspace.DM_FocusedProject

    If PcbProject Is Nothing Then
        Call StdErr(ModuleName, "Current Project is not a PCB Project.")
        Exit Function
    End If

    Dim PcbBoard

    ' Loop through all project documents
    For DocNum = 0 To PcbProject.DM_LogicalDocumentCount - 1
        Set Document = PcbProject.DM_LogicalDocuments(DocNum)
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
    'pcbBoard = pcbProject.DM_TopLevelPhysicalDocument

    If PcbBoard Is Nothing Then
        Call StdErr(ModuleName, "No open PCB document found. Path used = '" + Document.DM_FullPath + "'. Please open PCB file.")
        Exit Function
    End If

    CheckBoardOutlineLayer(PcbBoard)
    CheckTopDimensionsLayer(PcbBoard)
    CheckBotDimensionsLayer(PcbBoard)
    CheckTopMechBodyLayer(PcbBoard)
    CheckBotMechBodyLayer(PcbBoard)
    CheckUnusedLayers(PcbBoard)

End Function

Sub CheckBoardOutlineLayer(PcbBoard)
    Dim PcbIterator
    Dim PcbObject
    Dim ViolationCnt    'As Integer

    StdOut("Checking board outline layer...")

    ' Init violation count
    ViolationCnt = 0

    ' Get iterator, limiting search to mech 1 layer
    Set PcbIterator = PcbBoard.BoardIterator_Create
    If PcbIterator Is Nothing Then
        Call StdErr(ModuleName, "PCB iterator could not be created.")
        Exit Sub
    End If

    PcbIterator.AddFilter_ObjectSet(AllObjects)
    PcbIterator.AddFilter_LayerSet(MkSet(BOARD_OUTLINE_LAYER))
    PcbIterator.AddFilter_Method(eProcessAll)

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
        Call StdErr(ModuleName, "Board outline layer violation(s) found. Number of violations = " + IntToStr(violationCnt) + ".")
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
        Call StdErr(ModuleName, "PCB iterator could not be created.")
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
            ' Debug information, printing out enumeration of violating object
            'StdOut("Enum = " + IntToStr(pcbObject.ObjectId))
        End If
        Set pcbObject =  pcbIterator.NextPCBObject
    WEnd

    pcbBoard.BoardIterator_Destroy(pcbIterator)

    ' OUTPUT
    StdOut(" Top dimension layer check complete." + vbCr + vbLf)

    If(violationCnt <> 0) Then
        Call StdErr(ModuleName, "Top dimension layer violation(s) found. Number of violations = " + IntToStr(violationCnt) + ".")
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
        Call StdErr(ModuleName, "PCB iterator could not be created.")
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
        Call StdErr(ModuleName, "Bottom dimension layer violation(s) found. Number of violations = " + IntToStr(violationCnt) + ".")
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
        Call StdErr(ModuleName, "PCB iterator could not be created.")
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
        Call StdErr(ModuleName, "Top mech body layer violation(s) found. Number of violations = " + IntToStr(violationCnt) + ".")
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
        Call StdErr(ModuleName, "PCB iterator could not be created.")
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
        Call StdErr(ModuleName, "Bottom mechanical body layer violation(s) found. Number of violations = " + IntToStr(violationCnt) + ".")
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
        Call StdErr(ModuleName, "PCB iterator could not be created.")
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
        Call StdErr(ModuleName, "Unused layer violation(s) found. Number of violations = " + IntToStr(violationCnt) + ".")
        StdOut("ERROR: Unused layer violation(s) found.")
    End If

    ' OUTPUT
    StdOut(" Unused layer check complete." + vbCr + vbLf)
End Sub
