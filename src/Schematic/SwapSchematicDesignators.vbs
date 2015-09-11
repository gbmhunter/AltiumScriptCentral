'
' @file               SwapSchematicDesignators.vbs
' @author             Geoffrey Hunter <gbmhunter@gmail.com> (www.mbedded.ninja)
' @created            2015-09-11
' @last-modified      2015-09-11
' @brief              Script allows user to quickly switch two designators on the schematics
'                       (useful for when adjusting PCB layout)
' @details
'                     See README.rst in repo root dir for more info.

' Forces us to explicitly define all variables before using them
Option Explicit

Private ModuleName
ModuleName = "SwapSchematicDesignators.vbs"

' @brief    Allows the user to quickly switch two components on a PCB.
' @param    dummyVar     Dummy variable to stop function appearing in the Altium "Run Script" dialogue.
Sub SwapSchematicDesignators(dummyVar)

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

	' Keep going until the user presses exit (the returned object from
	' GetSchComponentFromUser() will be nothing
	while True

	    '============ 1st COMPONENT ============'

	    Dim firstComponent

		Do
		    Set firstComponent = GetSchComponentFromUser(currentSch, "Choose source component.")

		    If firstComponent Is Nothing Then
		        Exit Sub
		    End If

		    If Not firstComponent.ObjectId = eSchComponent Then
		        ShowMessage("ERROR: Selected object is not a schematic component! Press ESC to quit.")
		        'Exit Sub
		    End If
        Loop While Not firstComponent.ObjectId = eSchComponent

	    'ShowMessage("component.Location.X = '" + CStr(firstComponent.Location.X) + "'.")

	    '============ 2nd COMPONENT ============'

	    Dim secondComponent

		Do
		    Set secondComponent = GetSchComponentFromUser(currentSch, "Choose destination component.")

		    If secondComponent Is Nothing Then
		        Exit Sub
		    End If

		    If Not secondComponent.ObjectId = eSchComponent Then
		        ShowMessage("ERROR: Selected object is not a schematic component! Press ESC to quit.")
		    End If
		Loop While Not secondComponent.ObjectId = eSchComponent

	    '=============== PERFORM THE DESIGNATOR SWAP =================='

	    'ShowMessage("Source designator = " + firstComponent.Designator.Text)

		' Save one of the designators in local variable
		Dim secondComponentDesignator
		secondComponentDesignator = secondComponent.Designator.Text

	    ' Start of undo block
        Call SchServer.ProcessControl.PreProcess(currentSch, "")
		'Call SchServer.RobotManager.SendMessage(currentSch.I_ObjectAddress, c_BroadCast, SCHM_StartModify, c_NoEventData)

		' Actual swap occurs below (schematic modifications occur)
		secondComponent.Designator.Text = firstComponent.Designator.Text
		firstComponent.Designator.Text = secondComponentDesignator

		' End of undo block
		Call SchServer.ProcessControl.PostProcess(currentSch, "")
		Call SchServer.RobotManager.SendMessage(currentSch.I_ObjectAddress, c_BroadCast, SCHM_EndModify, c_NoEventData)

	Wend

End Sub
