'
' @file               CheckPcbCompPrimitivesLocked.vbs
' @author             Geoffrey Hunter <gbmhunter@gmail.com> (www.mbedded.ninja)
' @created            2015-08-06
' @last-modified      2015-08-06
' @brief              Checks to make sure all PCB component primitives are locked.
' @details
'                     See README.rst in repo root dir for more info.

' Forces us to explicitly define all variables before using them
Option Explicit

' @brief    Name of this module. Used for debugging/warning/error message purposes and for
'           saving user data.
Private Const moduleName = "CheckPcbCompPrimitivesLocked.vbs"

' @brief     Checks to make sure all PCB component primitives are locked
' @param     dummyVar     Dummy variable to stop function appearing in the Altium "Run Script" dialogue.
Sub CheckPcbCompPrimitivesLocked(dummyVar)

    StdOut("Making sure all PCB component primitives are locked...")

    Dim violationCount      'As Integer
    violationCount = 0

    ' Obtain the PCB server interface.
    If PCBServer Is Nothing Then
        Call StdErr(moduleName, "PCB server not online.")
        StdOut("PCB designator rotation check complete." + vbCr + vbLf)
        Exit Sub
    End If

    ' Get pcb project interface
    Dim workspace           'As IWorkspace
    Set workspace = GetWorkspace

    Dim pcbProject          'As IProject
    Set pcbProject = workspace.DM_FocusedProject

    If pcbProject Is Nothing Then
        Call StdErr(moduleName, "Current project is not a PCB project.")
        StdOut("PCB designator rotation check complete." + vbCr + vbLf)
        Exit Sub
    End If

    ' Loop through all project documents
    Dim docNum              'As Integer
    Dim pcbBoard            'As IPCB_Board
    For docNum = 0 To pcbProject.DM_LogicalDocumentCount - 1
        Dim document            'As IDocument
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
        Call StdErr(moduleName, "No PCB document found. Path used = " + document.DM_FullPath + ".")
        StdOut("PCB designator rotation check complete." + vbCr + vbLf)
        Exit Sub
    End If

    Dim pcbIterator

    ' Get iterator
    Set pcbIterator = pcbBoard.BoardIterator_Create
    If pcbIterator Is Nothing Then
        Call StdErr(moduleName, "PCB iterator could not be created.")
        StdOut("PCB designator rotation check complete." + vbCr + vbLf)
        Exit Sub
    End If

    ' Look at the rotation of designators on top and bottom layers separately

    pcbIterator.AddFilter_ObjectSet(MkSet(eComponentObject))
    pcbIterator.AddFilter_LayerSet(AllLayers)
    pcbIterator.AddFilter_Method(eProcessAll)

    ' Iterate through all found strings
    Dim pcbComponent ' As IPCB_Component
    Set pcbComponent = pcbIterator.FirstPCBObject
    While Not(pcbComponent Is Nothing)

		' Check for unlocked primitives
		If Not pcbComponent.PrimitiveLock Then
		    Call StdErr(moduleName, "Component '" + pcbComponent.Name + "' has unlocked primitives.")
			violationCount = violationCount + 1
		End If

        Set pcbComponent = pcbIterator.NextPCBObject
    WEnd ' While Not(pcbObject Is Nothing)

    pcbBoard.BoardIterator_Destroy(pcbIterator)

   ' If violations then print to StdOut
    If Not violationCount = 0 Then
        StdOut("ERROR: PCB components with unlocked primitives found. Num. violations = '" + CStr(violationCount) + "'. ")
    End If

    ' Output
    StdOut("PCB component primitive check complete." + vbCr + vbLf)

End Sub


