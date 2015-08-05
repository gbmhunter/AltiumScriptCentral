'
' @file               CheckTentedVias.vbs
' @author             Geoffrey Hunter <gbmhunter@gmail.com> (www.mbedded.ninja)
' @created            2013-08-08
' @last-modified      2015-08-05
' @brief              Script that checks to make sure that most vias are tented on the PCB.
' @details
'                     See README.rst in repo root dir for more info.

' Forces us to explicitly define all variables before using them
Option Explicit

' @brief The name of this module for logging purposes
Private moduleName
moduleName = "CheckTentedVias.vbs"

' @brief    Checks to make sure the tented via ratio of a PCB is above a certain limit.
' @param    dummyVar     Dummy variable to stop function appearing in the Altium "Run Script" dialogue.
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
    Dim pcbIterator
    Dim tentedViaRatio

    ' Zero count variables
    tentedViaCount = 0
    nonTentedViaCount = 0

    StdOut("Checking tented vias...")
    violationCnt = 0

    ' Obtain the PCB server interface.
    If PCBServer Is Nothing Then
        Call StdErr(moduleName, "PCB server not online.")
        StdOut("Tented via checking finished." + VbCr + VbLf)
        Exit Sub
    End If

    ' Get pcb project interface
    Set workspace = GetWorkspace
    Set pcbProject = Workspace.DM_FocusedProject

    If pcbProject Is Nothing Then
        Call StdErr(moduleName, "Current Project is not a PCB Project.")
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
        Call StdErr(moduleName, "No PCB document found. Path used = " + document.DM_FullPath + ".")
        StdOut("Tented via checking finished." + VbCr + VbLf)
        Exit Sub
    End If

    ' Get iterator, limiting search to mech 1 layer
    Set pcbIterator = pcbBoard.BoardIterator_Create
    If pcbIterator Is Nothing Then
        Call StdErr(moduleName, "PCB iterator could not be created.")
        StdOut("Tented via checking finished." + VbCr + VbLf)
        Exit Sub
    End If

    pcbIterator.AddFilter_ObjectSet(MkSet(eViaObject))
    pcbIterator.AddFilter_LayerSet(AllLayers)
    pcbIterator.AddFilter_Method(eProcessAll)

    ' Keeps track of how many via surfaces are not applicable to tented (i.e. all
    ' internal surfaces of buried or blind vias)
    Dim numNotApplicableSurfaces

    ' Search  and  count  pads
    Set pcbObject = pcbIterator.FirstPCBObject
    While Not(pcbObject Is Nothing)

        ' NEW METHOD (2015-08-05)

        ' This method treats the top and bottom surfaces of the via separately

		'ShowMessage("via.X = " + CStr(CoordToMMs(pcbObject.x - pcbBoard.XOrigin)) + ", via.y = " + CStr(CoordToMMs(pcbObject.y - pcbBoard.YOrigin)) + ", via.IsTentingTop = " + BoolToStr(pcbObject.GetState_IsTenting_Top) + ", via.IsTentingBottom = " + BoolToStr(pcbObject.GetState_IsTenting_Bottom))

        If pcbObject.StartLayer.LayerId = eTopLayer Then
            If (pcbObject.GetState_IsTenting_Top = True) Then
                ' Via surface is tented
                tentedViaCount = tentedViaCount + 1
            Else
                ' Via surface is not tented
                nonTentedViaCount = nonTentedViaCount + 1
            End If
        Else
            numNotApplicableSurfaces = numNotApplicableSurfaces + 1
        End If

        If pcbObject.StartLayer.LayerId = eBottomLayer Then
            If (pcbObject.GetState_IsTenting_Bottom = True) Then
                ' Via surface is tented
                tentedViaCount = tentedViaCount + 1
            Else
                ' Via surface is not tented
                nonTentedViaCount = nonTentedViaCount + 1
            End If
        Else
            numNotApplicableSurfaces = numNotApplicableSurfaces + 1
        End If

        ' NEW METHOD (2014-12-22)

        'Via.SetState_IsTenting_Top(False);
        'Via.SetState_IsTenting_Bottom(False);
        'If pcbObject.StartLayer.LayerId = eTopLayer And (pcbObject.GetState_IsTenting_Top = False) Then


        'If  And (pcbObject.GetState_IsTenting_Bottom = True) Then
            ' Via is tented (on both sides)
        '    tentedViaCount = tentedViaCount + 1
        'Else
           ' Via is not tented (on one or both sides)
        '    nonTentedViaCount = nonTentedViaCount + 1
        'End If

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

        Set pcbObject = pcbIterator.NextPCBObject
    WEnd

    pcbBoard.BoardIterator_Destroy(pcbIterator)

    'StdOut("Num. tented vias = " + IntToStr(tentedViaCount) + "." + vbCr + vbLf)
    'StdOut("Num. non-tented vias = " + IntToStr(nonTentedViaCount) + "." + vbCr + vbLf)

    ' Calc percentage
    If tentedViaCount + nonTentedViaCount = 0 Then
         ' This would could divide by 0 error, so let's set this to 1
         tentedViaRatio = 1
    Else
        ' Denominator is not 0, so safe to divide
        tentedViaRatio = tentedViaCount / (tentedViaCount + nonTentedViaCount)
    End If

    ' Output
    StdOut("Tented via surface ratio = " + FormatNumber(tentedViaRatio) + ". Number of exposed via surfaces found = " + IntToStr(tentedViaCount + nonTentedViaCount) + ". Tented via check complete." + vbCr + vbLf)

    If(tentedViaRatio < MIN_TENTED_VIA_RATIO) Then
        Call StdErr(moduleName, "Tented via surface ratio violation found (ratio = " + FormatNumber(tentedViaRatio) + ", minimum allowed ratio = " + FormatNumber(MIN_TENTED_VIA_RATIO) + "). Number of violating via surfaces = " + IntToStr(nonTentedViaCount) + ". Have you forgotten to tent vias?")
    End If

End Sub
