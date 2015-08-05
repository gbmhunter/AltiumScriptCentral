'
' @file               CheckEmbeddedImages.vbs
' @author             Geoffrey Hunter <gbmhunter@gmail.com> (www.mbedded.ninja)
' @created            2015-08-05
' @last-modified      2015-08-05
' @brief              Script that checks to make sure that all images on the schematics are embedded
'                       (so that they will be visible on other peoples computers that don't have the image file)
' @details
'                     See README.rst in repo root dir for more info.

' Forces us to explicitly define all variables before using them
Option Explicit

' @brief The name of this module for logging purposes
Private moduleName
moduleName = "CheckEmbeddedImages.vbs"

' @brief    Checks to make sure the tented via ratio of a PCB is above a certain limit.
' @param    dummyVar     Dummy variable to stop function appearing in the Altium "Run Script" dialogue.
Sub CheckEmbeddedImages(dummyVar)



    Dim docNum              'As Integer

    StdOut("Checking that all schematic images are embedded...")

     ' Obtain the schematic server interface.
    If SchServer Is Nothing Then
        Call StdErr(ModuleName, "Schematic server not online.")
        Exit Sub
    End If

    ' Get pcb project interface
    Dim workspace           'As IWorkspace
    Set workspace = GetWorkspace
    Dim pcbProject          'As IProject
    Set pcbProject = workspace.DM_FocusedProject

    If pcbProject Is Nothing Then
        Call StdErr(ModuleName, "Current Project is not a PCB Project")
        Exit Sub
    End If

   ' Compile project
    Dim flatHierarchy
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

    Dim numImages
    numImages = 0

    Dim violationCount        'As Integer
    violationCount = 0

    ' Loop through all project documents
    For docNum = 0 To pcbProject.DM_LogicalDocumentCount - 1
        Dim document 'As IDocument
        Set document = pcbProject.DM_LogicalDocuments(docNum)

        ' If this is SCH document
        If document.DM_DocumentKind = "SCH" Then
            Dim sheet ' As ISch_Sheet
            Set sheet = SCHServer.GetSchDocumentByPath(document.DM_FullPath)
            'ShowMessage(document.DM_FullPath);
            If sheet Is Nothing Then
                Call StdErr(moduleName, "No sheet found.")
                Exit Sub
            End If

            ' Set up iterator to look for power port objects only
            Dim iterator
            Set iterator = Sheet.SchIterator_Create
            If iterator Is Nothing Then
                Call StdErr(moduleName, "Iterator could not be created.")
                Exit Sub
            End If

            iterator.AddFilter_ObjectSet(MkSet(eImage))

            Dim component ' As ISch_Component
            TLocation
            Set component = Iterator.FirstSchObject

            Do While Not (component Is Nothing)

                If Not component.EmbedImage Then
                      violationCount = violationCount + 1
					' It may seem like we need to divide by 10 here because Altium schematics seem to show the grid in centi-inches (100's of an inch), not mills.
                    Call StdErr(moduleName, "ERROR: Non-embedded image violation found. Image on '" + _
						document.DM_FileName + "' at x = '" + CStr(CoordToMils(component.Location.X)) + "mils', y = '" + CStr(CoordToMils(component.Location.Y)) + "mils'. ")
                End If

                numImages = numImages + 1

                Set component = iterator.NextSchObject
            Loop ' Do While Not (component Is Nothing)

            sheet.SchIterator_Destroy(iterator)

        End If ' If document.DM_DocumentKind = "SCH" Then

    Next ' For docNum = 0 To pcbProject.DM_LogicalDocumentCount - 1

    If violationCount = 0 Then
        Call StdOut("No non-embedded image violations found. Total number of images found = '" + CStr(numImages) + "'. ")
    Else
        Call StdOut("ERROR: Non-embedded image violation found. Number of violations = '" + CStr(violationCount) + "', total num. of images = '" + CStr(numImages) + "'. ")
    End If

    Call StdOut("Non-embedded image checking finished." + VbCr + VbLf)

End Sub
