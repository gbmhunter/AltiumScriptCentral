'
' @file               CheckProjectCompiles.vbs
' @author             Geoffrey Hunter <gbmhunter@gmail.com> (www.mbedded.ninja)
' @created            2013-08-08
' @last-modified      2014-12-22
' @brief              Script that checks to make sure the current project compiles successfully.
' @details
'                     See README.rst in repo root dir for more info.

' Forces us to explicitly define all variables before using them
Option Explicit

Private ModuleName
ModuleName = "CheckProjectCompiles.vbs"

' @brief    This makes sure the project is compiled.
' @details  Note that this does not check to see whether the project compiles without errors, this
'           will still return True if it compiles with errors.
' @param     DummyVar     Dummy variable to stop function appearing in the Altium "Run Script" dialogue.
Function CheckProjectCompiles(DummyVar)
    Dim workspace           ' As IWorkspace
    Dim pcbProject          ' As IProject
    Dim document            ' As IDocument
    Dim flatHierarchy       ' As IDocument

    StdOut("Checking project compiles...")

    Dim ViolationFnd
    ViolationFnd = false

    ' Obtain the schematic server interface.
    If SchServer Is Nothing Then
       ' Maybe we could use this in the future...
        ' Client.StartServer("SCH")

        StdErr("ERROR: Schematic server not online." + VbLf + VbCr)
        CheckProjectCompiles = False
        Exit Function
    End If

    ' Get pcb project interface
    Set workspace = GetWorkspace
    Set pcbProject = workspace.DM_FocusedProject

    If pcbProject Is Nothing Then
        StdErr("ERROR: Current project is not a PCB project." + VbCr + VbLf)
        CheckProjectCompiles = False
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
           CheckProjectCompiles = False
           Exit Function
        End If
    End If

    ' If code reaches here, compilation was successful
    StdOut("Compilation successful." + VbCr + VbLf)
    CheckProjectCompiles = True
End Function
