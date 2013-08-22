Sub CheckNameVersionDate()

    Dim workspace           'As IWorkspace
    Dim pcbProject          'As IProject
    Dim document            'As IDocument
    Dim pcbBoard            'As IPCB_Board
    Dim pcbObject           'As IPCB_Primitive;
    Dim docNum              'As Integer
    Dim dateFound           'As Boolean
    Dim versionFound        'As Boolean

    StdOut("Checking PCB date...")

    versionFound = false
    dateFound = false

    ' Obtain the PCB server interface.
    If PCBServer Is Nothing Then
        StdErr("ERROR: PCB server not online." + VbCr + VbLf)
        StdOut("Date checker complete." + vbCr + vbLf)   
        Exit Sub
    End If

    ' Get pcb project interface
    Set workspace = GetWorkspace
    Set pcbProject = workspace.DM_FocusedProject

    IF pcbProject Is Nothing Then
        StdErr("Current Project is not a PCB Project." + VbCr + VbLf)
        StdOut("Date checker complete." + vbCr + vbLf)
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
        StdOut("Date checker complete." + vbCr + vbLf)
        Exit Sub
    End If

    Dim pcbIterator

    ' Get iterator, limiting search to mech 1 layer
    Set pcbIterator = pcbBoard.BoardIterator_Create
    If pcbIterator Is Nothing Then
        StdErr("ERROR: PCB iterator could not be created."  + vbCr + vbLf)
        StdOut("Date checker complete." + vbCr + vbLf)
        Exit Sub
    End If

    ' Look at strings
    pcbIterator.AddFilter_ObjectSet(MkSet(eTextObject))
    pcbIterator.AddFilter_LayerSet(AllLayers)
    pcbIterator.AddFilter_Method(eProcessAll)

    ' Search  and  count  pads
    Set pcbObject =  pcbIterator.FirstPCBObject
    While Not(pcbObject Is Nothing)
        ' Make sure that only tracks/arcs are present on this layer
        'StdOut("Exp = " + IntToStr(pcbObject.Cache.SolderMaskExpansion) + ",")
        'StdOut("Valid = " + IntToStr(pcbObject.Cache.SolderMaskExpansionValid) + ";")

        ' Project and version regex
        Set reNameVersion = New RegExp
        reNameVersion.IgnoreCase = True
        reNameVersion.Global = True
        ' Look for date in pattern yyyy/mm/dd
        reNameVersion.Pattern = "v[0-9]*\.[0-9]*"

        If reNameVersion.Test(pcbObject.Text) Then
            'StdOut("Version found!")
            versionFound = true
        End If

        ' Date regex
        Set reDate = New RegExp
        reDate.IgnoreCase = True
        reDate.Global = True
        ' Look for date in pattern yyyy/mm/dd
        reDate.Pattern = "[0-9][0-9][0-9][0-9]/[0-9][0-9]/[0-9][0-9]"

        If reDate.Test(pcbObject.Text) Then
            'StdOut("Date found!")
            dateFound = true
        End If

        Set pcbObject =  pcbIterator.NextPCBObject
    WEnd

    pcbBoard.BoardIterator_Destroy(pcbIterator)


    If Not dateFound Then
        StdErr("ERROR: Date not found violation. Please add the date to the PCB in the format yyyy/mm/dd" + vbCr + vbLf)
    Else
        Stdout("Date found. ")
    End If

    If Not versionFound Then
        StdErr("ERROR: Version not found violation. Please add the version to the PCB in the format v[0-9]*\.[0-9]*" + vbCr + vbLf)
    Else
        StdOut("Verison found. ")
    End If

    ' Output
    StdOut("Date checker complete." + vbCr + vbLf)

End Sub


