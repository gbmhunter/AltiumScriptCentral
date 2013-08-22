Function CheckProjectCompiles()  ' As TMemo
    Dim workspace           ' As IWorkspace
    Dim pcbProject          ' As IProject
    Dim document            ' As IDocument
    Dim flatHierarchy       ' As IDocument

    StdOut("Checking project compiles...")

    violationFnd = false

    ' Obtain the schematic server interface.
    If SchServer Is Nothing Then
        StdErr("ERROR: Schematic server not online." + VbLf + VbCr)
        CheckProjectCompiles = false
        Exit Function
    End If

    ' Get pcb project interface
    Set workspace = GetWorkspace
    Set pcbProject = workspace.DM_FocusedProject

    If pcbProject Is Nothing Then
        StdErr("ERROR: Current project is not a PCB project." + VbCr + VbLf)
        CheckProjectCompiles = false
        Exit Function
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
           StdErr("ERROR: Could not compile project." + VbCr + VbLf)
           CheckProjectCompiles = false
           Exit Function
        End If
    End If

    ' If code reaches here, compilation was successful
    StdOut("Compilation successful." + VbCr + VbLf)
    CheckProjectCompiles = true
End Function
