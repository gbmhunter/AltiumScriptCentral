Sub CheckPowerPortOrientation() 'As TMemo
    Dim workspace   ' As IWorkspace
    Dim pcbProject  ' As IProject
    Dim powerObj    ' As ISch_PowerObject
    Dim document    ' As IDocument
    Dim sheet       ' As ISch_Document
    Dim iterator    ' As ISch_Iterator
    Dim docNum      ' As Integer
    Dim violationCnt ' As Integer

    violationCnt = 0

    StdOut("Check power port orientations...")

    ' Obtain the schematic server interface.
    If SchServer Is Nothing Then
        Exit Sub
    End If

    ' Get pcb project interface
    Set workspace = GetWorkspace
    Set pcbProject = workspace.DM_FocusedProject

    ' Initialize the robots in Schematic editor.
    ' SchServer.ProcessControl.PreProcess(CurrentSheet, '');

    ' Loop through all project documents
    For docNum = 0 To pcbProject.DM_LogicalDocumentCount - 1

        Set document = pcbProject.DM_LogicalDocuments(docNum)

        ' If this is SCH document
        If document.DM_DocumentKind = "SCH" Then

            Set sheet = SCHServer.GetSchDocumentByPath(document.DM_FullPath)
            If sheet Is Nothing Then
                StdErr("ERROR: Please compile project." + VbCr + VbLf)
                Exit Sub
            End If

            ' Set up iterator to look for popwer port objects only
            Set iterator = sheet.SchIterator_Create
            If iterator Is Nothing Then
                Exit Sub
            End If

            iterator.AddFilter_ObjectSet(MkSet(ePowerObject))

            Set powerObj = iterator.FirstSchObject

            Do While Not (powerObj Is Nothing)

                If(powerObj.Style = ePowerGndPower) Or (powerObj.Style = ePowerGndSignal) Or (powerObj.Style = ePowerGndEarth) Then

                    ' Make sure they are facing downwards
                    If Not(powerObj.Orientation = eRotate270) Then
                        violationCnt = violationCnt + 1
                    End If
                End If
                If (powerObj.Style = ePowerBar) Then

                    ' Make sure they are facing upwards
                    If Not(powerObj.Orientation = eRotate90) Then
                        violationCnt = violationCnt + 1
                    End If
                End If

                ' Go to next object
                If iterator.NextSchObject Is Nothing Then
                    Exit Do
                End If
                Set powerObj = iterator.NextSchObject
            Loop
        End If
    Next

    If(violationCnt = 0) Then
        StdOut("No power port violations found. ")
    Else
        StdErr("ERROR: Power ports with incorrect orientation violation found! Number of violations = " + IntToStr(violationCnt) + "." + VbCr + VbLf)
    End If

    StdOut("Power port checking finished." + VbCr + VbLf)
End Sub

