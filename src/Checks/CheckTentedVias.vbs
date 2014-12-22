'
' @file               CheckTentedVias.vbs
' @author             Geoffrey Hunter <gbmhunter@gmail.com> (www.mbedded.ninja)
' @created            2013-08-08
' @last-modified      2014-12-22
' @brief              Script that checks to make sure that most vias are tented on the PCB.
' @details
'                     See README.rst in repo root dir for more info.

' Forces us to explicitly define all variables before using them
Option Explicit

' @brief The name of this module for logging purposes
Private ModuleName
ModuleName = "CheckTentedVias.vbs"

' @param     DummyVar     Dummy variable to stop function appearing in the Altium "Run Script" dialogue.
Sub CheckTentedVias(DummyVar)
    Dim Workspace           'As IWorkspace
    Dim PcbProject          'As IProject
    Dim Document            'As IDocument
    Dim ViolationCnt        'As Integer
    Dim PcbBoard            'As IPCB_Board
    Dim PcbObject           'As IPCB_Primitive;
    Dim DocNum              'As Integer
    Dim TentedViaCount      'As Integer
    Dim NonTentedViaCount   'As Integer
    Dim PcbIterator
    Dim TentedViaRatio

    ' Zero count variables
    TentedViaCount = 0
    NonTentedViaCount = 0

    StdOut("Checking tented vias...")
    ViolationCnt = 0

    ' Obtain the PCB server interface.
    If PCBServer Is Nothing Then
        Call StdErr(ModuleName, "PCB server not online.")
        StdOut("Tented via checking finished." + VbCr + VbLf)
        Exit Sub
    End If

    ' Get pcb project interface
    Set Workspace = GetWorkspace
    Set PcbProject = Workspace.DM_FocusedProject

    If PcbProject Is Nothing Then
        Call StdErr(ModuleName, "Current Project is not a PCB Project.")
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
        Call StdErr(ModuleName, "No PCB document found. Path used = " + document.DM_FullPath + ".")
        StdOut("Tented via checking finished." + VbCr + VbLf)
        Exit Sub
    End If

    ' Get iterator, limiting search to mech 1 layer
    Set PcbIterator = PcbBoard.BoardIterator_Create
    If PcbIterator Is Nothing Then
        Call StdErr(ModuleName, "PCB iterator could not be created.")
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

        ' NEW METHOD (2014-12-22)

        'Via.SetState_IsTenting_Top(False);
        'Via.SetState_IsTenting_Bottom(False);

        If (PcbObject.GetState_IsTenting_Top = True) And (PcbObject.GetState_IsTenting_Bottom = True) Then
            ' Via is tented (on both sides)
            TentedViaCount = TentedViaCount + 1
        Else
           ' Via is not tented (on one or both sides)
            NonTentedViaCount = NonTentedViaCount + 1
        End If

        'Via.SetState_IsTenting_Bottom(False);

        ' OLD METHOD

        ' This was the other way of tenting vias, by adding a rule instead
        ' of selecting "Force complete tenting on top/bottom" in Via properties.
        'If PcbObject.Cache.SolderMaskExpansion*2 <= -PcbObject.Size Then
        '    ' Via is tented (both sides)
        '    TentedViaCount = TentedViaCount + 1
        'Else
        '   ' Via is not tented (on both sides)
        '    NonTentedViaCount = NonTentedViaCount + 1
        'End If

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
    StdOut("Tented via ratio = " + FormatNumber(tentedViaRatio) + ". Number of vias found = " + IntToStr(TentedViaCount + NonTentedViaCount) + ". Tented via check complete." + vbCr + vbLf)

    If(tentedViaRatio < MIN_TENTED_VIA_RATIO) Then
        Call StdErr(ModuleName, "Tented via ratio violation found (ratio = " + FormatNumber(tentedViaRatio) + ", minimum allowed ratio = " + FormatNumber(MIN_TENTED_VIA_RATIO) + "). Number of violating vias = " + IntToStr(NonTentedViaCount) + ". Have you forgotten to tent vias?")
    End If

End Sub
