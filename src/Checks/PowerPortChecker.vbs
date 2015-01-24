'
' @file               PowerPortChecker.vbs
' @author             Geoffrey Hunter <gbmhunter@gmail.com> (www.mbedded.ninja)
' @created            2013-08-08
' @last-modified      2015-01-24
' @brief              Deletes all schematic parameters for the current project.
' @details
'                     See README.rst in repo root dir for more info.

' Forces us to explicitly define all variables before using them
Option Explicit

Private ModuleName
ModuleName = "PowerPortChecker.vbs"

' @param     DummyVar     Dummy variable to stop function appearing in the Altium "Run Script" dialogue. 
Function PowerPortChecker(dummyVar)
    Dim Workspace   ' As IWorkspace
    Dim PcbProject  ' As IProject
    Dim powerObj    ' As ISch_PowerObject
    Dim document    ' As IDocument
    Dim sheet       ' As ISch_Document
    Dim iterator    ' As ISch_Iterator
    Dim docNum      ' As Integer
    Dim violationCnt ' As Integer
    Dim regex

    violationCnt = 0

    StdOut("Checking power ports...")

    ' Obtain the schematic server interface.
    If SchServer Is Nothing Then
       Call StdErr(ModuleName, "ERROR: Schematic server is not online.")
       Exit Function
    End If

    ' Get pcb project interface
    Set Workspace = GetWorkspace
    Set PcbProject = Workspace.DM_FocusedProject

    ' Initialize the robots in Schematic editor.
    ' SchServer.ProcessControl.PreProcess(CurrentSheet, '');

    Dim SchDocument

    ' Loop through all project documents
    For docNum = 0 To pcbProject.DM_LogicalDocumentCount - 1

        Set document = pcbProject.DM_LogicalDocuments(docNum)

        ' If this is SCH document
        If document.DM_DocumentKind = "SCH" Then

           ' Open document first as GetSchDocumentByPath only gets document if it is open!!!
           SchDocument = Client.OpenDocument("SCH", document.DM_FullPath)
            Set sheet = SCHServer.GetSchDocumentByPath(document.DM_FullPath)
            If sheet Is Nothing Then
                Call StdErr(ModuleName, "Could not retrieve '" + document.DM_FullPath + "'. Please compile project.")
                Exit Function
            End If

            ' Set up iterator to look for popwer port objects only
            Set iterator = sheet.SchIterator_Create
            If iterator Is Nothing Then
               Call StdErr(ModuleName, "Iterator creation failed.")
               Exit Function
            End If

            iterator.AddFilter_ObjectSet(MkSet(ePowerObject))

            Set powerObj = iterator.FirstSchObject

            Do While Not (powerObj Is Nothing)

                If(powerObj.Style = ePowerGndPower) Or (powerObj.Style = ePowerGndSignal) Or (powerObj.Style = ePowerGndEarth) Then

                    ' Make sure they are facing downwards
                    If Not(powerObj.Orientation = eRotate270) Then
                        violationCnt = violationCnt + 1
                        Call StdErr(moduleName, "Gound symbol '" + powerObj.Text + "' with incorrect orientation on sheet " + document.DM_FullPath + " found. ")
                    End If
                End If
                If (powerObj.Style = ePowerBar) Then

                    ' Make sure they are facing upwards
                    If Not(powerObj.Orientation = eRotate90) Then
                        violationCnt = violationCnt + 1
                        Call StdErr(ModuleName, "Power bar '" + powerObj.Text + "' with incorrect orientation on sheet " + document.DM_FullPath + " found.")
                    End If

                    ' Check text
                    Set regex = New RegExp
                    regex.IgnoreCase = True
                    regex.Global = True
                    ' Look for a designator
                    ' Designators are one ore more capital letters followed by
                    ' one or more numerals, with nothing else before or afterwards (i.e. anchored)
                    regex.Pattern = "[\+-][0-9]+\.[0-9]+V"

                    ' Check for pattern match
                    If Not regex.Test(powerObj.Text) Then
                        'violationCnt = violationCnt + 1
                        'Call StdErr("ERROR: Power bar with incorrect text " + powerObj.Text + " on sheet " + document.DM_FullPath + " found. ")
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
        StdOut("ERROR: Power ports violations found! Number of violations = " + IntToStr(violationCnt) + ". ")
    End If

    StdOut("Power port checking finished." + VbCr + VbLf)
End Function

