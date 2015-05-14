'
' @file               SchCompParamStamper.vbs
' @author             Geoffrey Hunter <gbmhunter@gmail.com> (www.mbedded.ninja)
' @created            2015-05-14
' @last-modified      2015-05-14
' @brief              Script allows user to quickly 'stamp' the parameter visibility
'                     settings of one schematic component to another.
' @details
'                     See README.rst in repo root dir for more info.

' Forces us to explicitly define all variables before using them
Option Explicit

' @brief     Stamps (copies) vias to user-selected locations.
' @details   Call this from AltiumScriptCentral.
Sub SchCompParamStamper(dummyVar)

    ' Obtain the schematic server interface.
    If SchServer Is Nothing Then
        ShowMessage("ERROR: Schematic server not online." + VbLf + VbCr)
        Exit Sub
    End If

    ' Get current (active) schematic
    Dim currentSch
    currentSch = SchServer.GetCurrentSchDocument
    If currentSch Is Nothing Then
        ShowMessage("ERROR: The current active document (if any) is not a schematic." + VbLf + VbCr)
        Exit Sub
    End If

    'ResetParameters
    'Call AddStringParameter("Action", "AllOpenDocuments")
    'RunProcess("Sch:DeSelect")

    '============ SOURCE COMPONENT ============'

    Dim sourceSchComp
    Set sourceSchComp = GetSchComponentFromUser(currentSch, "Choose source component.")

    If sourceSchComp Is Nothing Then
        Exit Sub
    End If

    If Not sourceSchComp.ObjectId = eSchComponent Then
        ShowMessage("ERROR: Selected object is not a schematic component!")
        Exit Sub
    End If

    '============ DESTINATION COMPONENT ============'

    Dim destSchComp
    Set destSchComp = GetSchComponentFromUser(currentSch, "Choose destination component.")

    If destSchComp Is Nothing Then
        Exit Sub
    End If

    If Not destSchComp.ObjectId = eSchComponent Then
        ShowMessage("ERROR: Selected object is not a schematic component!")
        Exit Sub
    End If

    '============ COPY ACROSS PARAMETER VISIBILITY ============'

    Call CopyParameterVisibility(sourceSchComp, destSchComp)

End Sub

Function GetSchComponentFromUser(schDoc, locationMsg)

	Set GetSchComponentFromUser = Nothing

    ' Request user to select origin component location
    Dim location' As TLocation
    location = TLocation

    If schDoc.ChooseLocationInteractively(location, locationMsg) = False Then
        ShowMessage("ERROR: A valid location was not choosen.")
        Exit Function
    End If

    'ShowMessage("location.X = '" + CStr(location.X) + "', location.Y = '" + CStr(location.Y) + "'.")

    Dim schSourcePrim
    Set schSourcePrim = Nothing

    Do While schSourcePrim Is Nothing

        Dim spatialIterator
        spatialIterator = schDoc.SchIterator_Create
        If spatialIterator Is Nothing Then
            ShowMessage("ERROR: Failed to create spatial iterator.")
            Exit Function
        End If

        Call SpatialIterator.AddFilter_Area(Location.X - 1, Location.Y - 1, Location.X + 1, Location.Y + 1)

        ' Get first object
        Dim schTempPrim
        Set schTempPrim = spatialIterator.FirstSchObject
        'schSourcePrim = schTempPrim

        ' Make sure iterator found an object
        If schTempPrim Is Nothing Then
            ShowMessage("ERROR: No schematic object was selected.")
            schDoc.SchIterator_Destroy(spatialIterator)
            Exit Function
        End If

        ' We found a schematic object
        Do While Not schTempPrim Is Nothing
            If (schTempPrim.ObjectId = eSchComponent) Then
                schSourcePrim = schTempPrim
            End If
            Set schTempPrim = spatialIterator.NextSchObject
        Loop

        ' We will get to here if either:
        '   - schematic component object found while iterating through objects at selected location,
        '       in this case we will exit from parent loop also
        '   - searched through all objects at this location and no schematic component
        '       found, in this case we will stay in parent loop

        schDoc.SchIterator_Destroy(spatialIterator)
    Loop

    ' Return schematic component (if any)
    GetSchComponentFromUser = schSourcePrim

End Function

' @brief    Copies across the parameter visibilities from the source component to the destination component.
Function CopyParameterVisibility(sourceSchComp, destSchComp)

    Dim paramIterator
    paramIterator = sourceSchComp.SchIterator_Create
    paramIterator.AddFilter_ObjectSet(MkSet(eParameter))

    Dim param
    param = paramIterator.FirstSchObject
    Do Until param Is Nothing
        'ShowMessage("param.Name = '" + param.Name + "'.")
        Call SetSchCompParamVisibility(destSchComp, param.Name, param.IsHidden)
        Set param = paramIterator.NextSchObject
    Loop

    sourceSchComp.SchIterator_Destroy(paramIterator)
End Function

Function SetSchCompParamVisibility(schComp, paramName, isHidden)
    Dim paramIterator
    paramIterator = schComp.SchIterator_Create
    paramIterator.AddFilter_ObjectSet(MkSet(eParameter))

    Dim param
    param = paramIterator.FirstSchObject
    Do Until param Is Nothing
        If param.Name = paramName Then
            ' We have found the correct parameter
            'ShowMessage("Found match!")
            ' Set the parameter visibility to whatever was provided to this funciton
            param.IsHidden = isHidden
        End If
        Set param = paramIterator.NextSchObject
    Loop

    schComp.SchIterator_Destroy(paramIterator)

End Function
