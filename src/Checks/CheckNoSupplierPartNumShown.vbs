'
' @file               CheckNoSupplierPartNumShown.vbs
' @author             Geoffrey Hunter <gbmhunter@gmail.com> (www.mbedded.ninja)
' @created            2013-08-08
' @last-modified      2014-12-22
' @brief              Checks that no supplier part numbers are shown on the schematics (you should show manufacturing part numbers!)
' @details
'                     See README.rst in repo root dir for more info.

' Forces us to explicitly define all variables before using them
Option Explicit

Private ModuleName
ModuleName = "CheckNoSupplierPartNumShown.vbs"

' @param     DummyVar     Dummy variable to stop function appearing in the Altium "Run Script" dialogue.
Sub CheckNoSupplierPartNumShown(DummyVar) ' As TMemo
    Dim Workspace           ' As IWorkspace
    Dim PcbProject          ' As IProject
    Dim Document            ' As IDocument
    Dim FlatHierarchy       ' As IDocument
    Dim Sheet               ' As ISch_Document
    Dim DocNum              ' As Integer
    Dim Iterator            ' As ISch_Iterator
    Dim CompIterator        ' As ISch_Iterator
    Dim Component           ' As IComponent
    Dim Parameter, Parameter2 ' As ISch_Parameter
    Dim ViolationCount      ' As Integer

    Call StdOut("Looking for visible supplier part numbers...")

    ViolationCount = 0

    ' Obtain the schematic server interface.
    If SchServer Is Nothing Then
        Call StdErr(ModuleName, "Schematic server not online.")
        Exit Sub
    End If

    ' Get pcb project interface
    Set workspace = GetWorkspace
    Set pcbProject = workspace.DM_FocusedProject

    If pcbProject Is Nothing Then
        Call StdErr(ModuleName, "Current Project is not a PCB Project")
        Exit Sub
    End If

   ' Compile project
   Set flatHierarchy = PCBProject.DM_DocumentFlattened

   ' If we couldn't get the flattened sheet, then most likely the project has
   ' not been compiled recently
   If flatHierarchy Is Nothing Then
        ' First try compiling the project
        ResetParameters
        Call AddStringParameter("Action", "Compile")
        Call AddStringParameter("ObjectKind", "Project")
        Call RunProcess("WorkspaceManager:Compile")

        ' Try Again to open the flattened document
        Set flatHierarchy = PCBProject.DM_DocumentFlattened
        If flatHierarchy Is Nothing Then
           Call StdErr(ModuleName, "Compile the project before running this script.")
           Exit Sub
        End If
    End If

    ' Loop through all project documents
    For docNum = 0 To pcbProject.DM_LogicalDocumentCount - 1
        Set document = pcbProject.DM_LogicalDocuments(docNum)

        ' If this is SCH document
        If document.DM_DocumentKind = "SCH" Then
            Set sheet = SCHServer.GetSchDocumentByPath(document.DM_FullPath)
            'ShowMessage(document.DM_FullPath);
            If sheet Is Nothing Then
                Call StdErr(ModuleName, "No sheet found.")
                Exit Sub
            End If

            ' Set up iterator to look for power port objects only
            Set Iterator = Sheet.SchIterator_Create
            If Iterator Is Nothing Then
                Call StdErr(ModuleName, "Iterator could not be created.")
                Exit Sub
            End If

            iterator.AddFilter_ObjectSet(MkSet(eSchComponent))
            Set component = Iterator.FirstSchObject
            Do While Not (component Is Nothing)
                compIterator = component.SchIterator_Create
                compIterator.AddFilter_ObjectSet(MkSet(eParameter))

                Set parameter = compIterator.FirstSchObject
                ' Loop through all parameters in object
                Do While Not (parameter Is Nothing)
                    ' Check for supplier part number parameter thats visible on sheet
                    If(parameter.Name = "Supplier Part Number 1") and (parameter.IsHidden = false) Then
                        violationCount = violationCount + 1
                        Call StdErr(ModuleName, "Supplier part num violation '" + parameter.Text + "' in component '" + component.Designator.Text + "'.")
                    End If

                    'if ((AnsiUpperCase(Parameter.Name) = 'GROUP') and (Parameter.Text <> '') and (Parameter.Text <> '*')) then
                     '   if StrToInt(Parameter.Text) > MaxNumber then
                      '      MaxNumber := StrToInt(Parameter.Text);

                    Set parameter = CompIterator.NextSchObject
                Loop

                component.SchIterator_Destroy(compIterator)
                Set component = iterator.NextSchObject
            Loop

            sheet.SchIterator_Destroy(iterator)

        End If ' If document.DM_DocumentKind = "SCH" Then

    Next ' For docNum = 0 To pcbProject.DM_LogicalDocumentCount - 1

    If violationCount = 0 Then
        Call StdOut("No supplier part number violations found. ")
    Else
        Call StdOut("ERROR: Supplier part number visible on sheet violation found. Number of violations = '" + IntToStr(violationCount) + "'. ")
    End If

    Call StdOut("Supplier part number checking finished." + VbCr + VbLf)
End Sub
