'
' @file               CheckProjectCompiles.vbs
' @author             Geoffrey Hunter <gbmhunter@gmail.com> (www.mbedded.ninja)
' @created            2013-08-08
' @last-modified      2015-01-15
' @brief              Script that checks to make sure the current project compiles successfully.
' @details
'                     See README.rst in repo root dir for more info.

' Forces us to explicitly define all variables before using them
Option Explicit

Private moduleName
moduleName = "CheckProjectCompiles.vbs"

' @brief    This makes sure the project is compiled.
' @details  Note that this does not check to see whether the project compiles without errors, this
'           will still return True if it compiles with errors.
' @param     DummyVar     Dummy variable to stop function appearing in the Altium "Run Script" dialogue.
Function CheckProjectCompiles(DummyVar)

    StdOut("Checking project compiles...")

    Dim violationFnd
    violationFnd = false

    ' Obtain the schematic server interface.
    If SchServer Is Nothing Then
       ' Maybe we could use this in the future...
        ' Client.StartServer("SCH")

        Call StdErr(moduleName, "Schematic server not online.")
        CheckProjectCompiles = False
        Exit Function
    End If

    ' Get pcb project interface
    Dim workspace           ' As IWorkspace
    Set workspace = GetWorkspace

    Dim pcbProject          ' As IProject
    Set pcbProject = workspace.DM_FocusedProject

    If pcbProject Is Nothing Then
        Call StdErr(moduleName, "Current project is not a PCB project.")
        CheckProjectCompiles = False
        Exit Function
    End If

   ' Compile project
   Dim flatHierarchy       ' As IDocument
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
           Call StdErr(moduleName, "Could not compile project.")
           CheckProjectCompiles = False
           Exit Function
        End If
    End If

    ' If code reaches here, compilation was successful
    StdOut("Compilation successful." + VbCr + VbLf)
    CheckProjectCompiles = True
End Function
