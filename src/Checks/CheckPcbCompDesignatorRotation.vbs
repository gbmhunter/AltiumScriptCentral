'
' @file               CheckPcbCompDesignatorRotation.vbs
' @author             Geoffrey Hunter <gbmhunter@gmail.com> (www.mbedded.ninja)
' @created            2015-04-30
' @last-modified      2015-04-30
' @brief              Checks that PCB designators are only rotated in two of the possible four directions
' @details
'                     See README.rst in repo root dir for more info.

' Forces us to explicitly define all variables before using them
Option Explicit

' @brief    Name of this module. Used for debugging/warning/error message purposes and for
'           saving user data.
Private Const moduleName = "CheckPcbCompDesignatorRotation.vbs"

' @brief     Checks that PCB text has the correct orientation (top-layer text not mirrored,
'            bottom layer text mirrored).
' @param     dummyVar     Dummy variable to stop function appearing in the Altium "Run Script" dialogue.
Sub CheckPcbCompDesignatorRotation(dummyVar)

    StdOut("Checking PCB designator rotation...")

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
    Dim x
    For x = 0 To 1
        pcbIterator.AddFilter_ObjectSet(MkSet(eComponentObject))
        pcbIterator.AddFilter_LayerSet(AllLayers)
        pcbIterator.AddFilter_Method(eProcessAll)

        Dim zeroDegRotation
        zeroDegRotation = False
        Dim nintyDegRotation
        nintyDegRotation = False
        Dim oneEightyDegRotation
        oneEightyDegRotation = False
        Dim twoSeventyDegRotation
        twoSeventyDegRotation = False

        Dim firstWarning1
        firstWarning1 = False
        Dim firstWarning2
        firstWarning2 = False

        ' Iterate through all found strings
        Dim pcbObject
        Set pcbObject = pcbIterator.FirstPCBObject
        While Not(pcbObject Is Nothing)
            ' Make sure that only tracks/arcs are present on this layer
            'StdOut("Exp = " + IntToStr(pcbObject.Cache.SolderMaskExpansion) + ",")
            'StdOut("Valid = " + IntToStr(pcbObject.Cache.SolderMaskExpansionValid) + ";")

            ' Get the designator
            Dim compDesignator ' As IPCB_Text
            Set compDesignator = pcbObject.Name

            'ShowMessage("Rotation = '" + FloatToStr(compDesignator.Rotation) + "'.")

            If (x = 0 And compDesignator.Layer = eTopOverlay) Or (x = 1 And compDesignator.Layer = eBottomOverlay) Then
                If compDesignator.Rotation = 0 Then
                    zeroDegRotation = True
                ElseIf compDesignator.Rotation = 90 Then
                    nintyDegRotation = True
                ElseIf compDesignator.Rotation = 180 Then
                    oneEightyDegRotation = True
                ElseIf compDesignator.Rotation = 270 Then
                    twoSeventyDegRotation = True
                End If

                If zeroDegRotation And oneEightyDegRotation Then
                    If firstWarning1 = False Then
						If compDesignator.Layer = eTopOverlay Then
                        	Call StdErr(moduleName, "Component designators have both 0 and 180 degree rotation on top silkscreen.")
						ElseIf compDesignator.Layer = eBottomOverlay Then
                            Call StdErr(moduleName, "Component designators have both 0 and 180 degree rotation on bottom silkscreen.")
						End If
                        violationCount = violationCount + 1
                        firstWarning1 = True
                    End If
                End If

                If nintyDegRotation And twoSeventyDegRotation Then
                    If firstWarning2 = False Then
                        If compDesignator.Layer = eTopOverlay Then
                        	Call StdErr(moduleName, "Component designators have both 90 and 270 degree rotation on top silkscreen.")
						ElseIf compDesignator.Layer = eBottomOverlay Then
                            Call StdErr(moduleName, "Component designators have both 90 and 270 degree rotation on bottom silkscreen.")
						End If
                        violationCount = violationCount + 1
                        firstWarning2 = True
                    End If
                End If
            End If

            Set pcbObject = pcbIterator.NextPCBObject
        WEnd
    Next

    pcbBoard.BoardIterator_Destroy(pcbIterator)

   ' If violations then print to StdOut
    If Not violationCount = 0 Then
        StdOut("ERROR: PCB component designator rotation violation(s) found. Please make sure designators are rotated in two directions only. Num. violations = " + IntToStr(violationCount) + ". ")
    End If

    ' Output
    StdOut("PCB designator rotation check complete." + vbCr + vbLf)

End Sub


