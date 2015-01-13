'
' @file               CheckNameVersionDate.vbs
' @author             Geoffrey Hunter <gbmhunter@gmail.com> (www.mbedded.ninja)
' @created            2013-08-08
' @last-modified      2015-01-13
' @brief              Script checks the PCB for a valid name, version and date.
' @details
'                     See README.rst in repo root dir for more info.

' Forces us to explicitly define all variables before using them
Option Explicit

Private ModuleName
ModuleName = "CheckNameVersionDate.vbs"

' @brief     Checks the PCB for a valid name, version and date.
' @param     DummyVar     Dummy variable to stop function appearing in the Altium "Run Script" dialogue.
Sub CheckNameVersionDate(DummyVar)

    StdOut("Checking PCB date...")

    Dim dateFound           'As Boolean
    Dim versionFound        'As Boolean
    versionFound = false
    dateFound = false

    ' Obtain the PCB server interface.
    If PCBServer Is Nothing Then
        Call StdErr(ModuleName, "PCB server not online.")
        StdOut("Date checker complete." + vbCr + vbLf)   
        Exit Sub
    End If

    ' Get pcb project interface
    Dim workspace           'As IWorkspace
    Set workspace = GetWorkspace

    Dim pcbProject          'As IProject
    Set pcbProject = workspace.DM_FocusedProject

    If pcbProject Is Nothing Then
        Call StdErr(ModuleName, "Current Project is not a PCB project.")
        StdOut("Date checker complete." + vbCr + vbLf)
        Exit Sub
    End If

    ' Loop through all project documents
    Dim docNum              'As Integer
    For docNum = 0 To pcbProject.DM_LogicalDocumentCount - 1
        Dim document            'As IDocument
        Set document = pcbProject.DM_LogicalDocuments(docNum)
        ' ShowMessage(document.DM_DocumentKind)
        ' If this is PCB document
        If document.DM_DocumentKind = "PCB" Then
            ' ShowMessage('PCB Found');
            Dim pcbBoard            'As IPCB_Board
            Set pcbBoard = PCBServer.GetPCBBoardByPath(document.DM_FullPath)
            Exit For
        End If
    Next

    If pcbBoard Is Nothing Then
        Call StdErr(ModuleName, "No PCB document found. Path used = " + document.DM_FullPath + ".")
        StdOut("Date checker complete." + vbCr + vbLf)
        Exit Sub
    End If

    Dim pcbIterator

    ' Get iterator, limiting search to mech 1 layer
    Set pcbIterator = pcbBoard.BoardIterator_Create
    If pcbIterator Is Nothing Then
        Call StdErr(ModuleName, "PCB iterator could not be created.")
        StdOut("Date checker complete." + vbCr + vbLf)
        Exit Sub
    End If

    ' Look at strings
    pcbIterator.AddFilter_ObjectSet(MkSet(eTextObject))
    pcbIterator.AddFilter_LayerSet(AllLayers)
    pcbIterator.AddFilter_Method(eProcessAll)

    ' Search  and  count  pads
    Dim pcbObject           'As IPCB_Primitive;
    Set pcbObject =  pcbIterator.FirstPCBObject
    While Not(pcbObject Is Nothing)
        ' Make sure that only tracks/arcs are present on this layer
        'StdOut("Exp = " + IntToStr(pcbObject.Cache.SolderMaskExpansion) + ",")
        'StdOut("Valid = " + IntToStr(pcbObject.Cache.SolderMaskExpansionValid) + ";")

        ' Project and version regex
        Dim reNameVersion
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
        Dim reDate
        Set reDate = New RegExp
        reDate.IgnoreCase = True
        reDate.Global = True
        ' Look for date in pattern yyyy/mm/dd or yyyy-mm-dd
        reDate.Pattern = "[0-9][0-9][0-9][0-9][/-][0-9][0-9][/-][0-9][0-9]"

        If reDate.Test(pcbObject.Text) Then
            'StdOut("Date found!")
            dateFound = true
        End If

        Set pcbObject =  pcbIterator.NextPCBObject
    WEnd

    pcbBoard.BoardIterator_Destroy(pcbIterator)


    If Not DateFound Then
        Call StdErr(ModuleName, "Date not found violation. Please add the date to the PCB in the format yyyy/mm/dd.")
    Else
        Stdout("Date found. ")
    End If

    If Not VersionFound Then
        Call StdErr(ModuleName, "Version not found violation. Please add the version to the PCB in the format v[0-9]*\.[0-9]*")
    Else
        StdOut("Verison found. ")
    End If

    ' Output
    StdOut("Date checker complete." + vbCr + vbLf)

End Sub


