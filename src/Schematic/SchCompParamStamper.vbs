'
' @file               SchCompParamStamper.vbs
' @author             Geoffrey Hunter <gbmhunter@gmail.com> (www.mbedded.ninja)
' @created            2015-05-14
' @last-modified      2015-05-18
' @brief              Script allows user to quickly 'stamp' the parameter visibility and location
'                     (relative to each component) settings of one schematic component to another.
' @details
'                     See README.rst in repo root dir for more info.

' Forces us to explicitly define all variables before using them
Option Explicit

' @brief    Test subroutine that can be called from the Altium script menu.
' @details  Comment this subroutine out when releasing project.
'Sub SchCompParamStamperTest()
'    dim dummyVar
'    SchCompParamStamper(dummyVar)
'End Sub

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

    'ShowMessage("component.Location.X = '" + CStr(sourceSchComp.Location.X) + "'.")

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

    '============ COPY ACROSS PARAMETER VISIBILITY AND LOCATION ============'

    Call CopyParameterVisibilityAndLocation(sourceSchComp, destSchComp)

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

' @brief    Copies across the parameter visibilities and locations (relative to each component) from the source component to the destination component.
' @details	If the parameter in the source component is not found in the destination component, nothing happens.
' @param	sourceSchComp	The shcematic component to copy parameter visibility and location settings from.
' @param	destSchComp		The shcematic component to copy parameter visibility and location settings to.
Function CopyParameterVisibilityAndLocation(sourceSchComp, destSchComp)

    Dim paramIterator
    ' Create an iterator from the source component
    paramIterator = sourceSchComp.SchIterator_Create
    ' Make sure the iterator mask will select on parameters
    paramIterator.AddFilter_ObjectSet(MkSet(eParameter))

    Dim param
    param = paramIterator.FirstSchObject
    ' Iterate through all of the source component parameters
    Do Until param Is Nothing
        'ShowMessage("param.Name = '" + param.Name + "'.")
        'ShowMessage("param.Location.X = '" + CStr(param.Location.X) + "'.")
        Call SetSchCompParamVisibility(destSchComp, param.Name, param.IsHidden)

        ' ===== SET PARAMETER LOCATION =====

        ' Get source parameter location relative to source component
        Dim relXLocation, relYLocation

        relXLocation = param.Location.X - sourceSchComp.Location.X
        relYLocation = param.Location.Y - sourceSchComp.Location.Y
        'ShowMessage("relXLocation = '" + CStr(relXLocation) + "'.")
        'ShowMessage("relYLocation = '" + CStr(relYLocation) + "'.")

        ' Set destination component parameters to the same relative location
        Call SetSchCompParamLocation(destSchComp, param.Name, destSchComp.Location.X + relXLocation, destSchComp.Location.Y + relYLocation)

        ' Next
        Set param = paramIterator.NextSchObject
    Loop

    sourceSchComp.SchIterator_Destroy(paramIterator)
End Function

' @brief    Changes the isHidden property (which hides or makes visible) of the specified component parameter.
' @details	If the parameter is not found in the component, nothing happens.
' @param    schComp     The schematic component to operate on.
' @param    paramName   The parameter name to change the isHidden property of.
' @param    isHidden    (boolean) The value to set the isHidden property to. True
'                       will hide the property, false will make it visible.
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

			' Notify the schematic server of the change (so we can save)
			Call SchServer.RobotManager.SendMessage(param.I_ObjectAddress, c_BroadCast, SCHM_EndModify, c_NoEventData)
        End If
        Set param = paramIterator.NextSchObject
    Loop

    schComp.SchIterator_Destroy(paramIterator)

End Function

' @brief    Changes a parameter location for a specified schematic component.
' @details	If the parameter is not found in the component, nothing happens.
' @param	schComp		The schematic component that the parameter belongs to.
' @param	paramName	(String) The name of the parameter.
' @param	xLocation	(Integer) The x-location of the to set the parameter to, in Altium units.
' @param	xLocation	(Integer) The y-location of the to set the parameter to, in Altium units.
Function SetSchCompParamLocation(schComp, paramName, xLocation, yLocation)
    Dim paramIterator
    paramIterator = schComp.SchIterator_Create
    paramIterator.AddFilter_ObjectSet(MkSet(eParameter))

    Dim param
	' Iterate through the component's parameters until we find the one whose name matches paramName
    param = paramIterator.FirstSchObject
    Do Until param Is Nothing
        If param.Name = paramName Then

            ' We have found the correct parameter
            'ShowMessage("Setting parameter '" + paramName + "' of '" + schComp.Designator.Text + "' to xLocation = '" + CStr(xLocation) + "', yLocation = '" + CStr(yLocation) + "'.")

			' NOTE: We have to create a TLocation object! We can't just go param.Location.X = xLocation, e.t.c, this does NOT work!!!
			Dim location1
			location1 = TLocation
			location1.X = xLocation
			location1.Y = yLocation

			' Start of schematic modifiation
			Call SchServer.RobotManager.SendMessage(param.I_ObjectAddress, c_BroadCast, SCHM_BeginModify, c_NoEventData)
			param.Location = location1
			' Notify the schematic server of the change (so we can save)
            Call SchServer.RobotManager.SendMessage(param.I_ObjectAddress, c_BroadCast, SCHM_EndModify, c_NoEventData)
        End If
        Set param = paramIterator.NextSchObject
    Loop

	' Get rid of the iterator
    schComp.SchIterator_Destroy(paramIterator)
End Function
