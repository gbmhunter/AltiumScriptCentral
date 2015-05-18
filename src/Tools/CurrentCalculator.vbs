'
' @file               CurrentCalculator.vbs
' @author             Geoffrey Hunter <gbmhunter@gmail.com> (www.mbedded.ninja)
' @created            2014-11-24
' @last-modified      2015-05-19
' @brief              Script allows user to determine the maximum allowed current
'                     of a particular track or via for a given temperature rise.
' @details
'                     See README.rst in repo root dir for more info.

' Forces us to explicitly define all variables before using them
Option Explicit

' @brief    Module name is used for storing user data in INI file.
Private Const moduleName = "CurrentCalculator.vbs"

Private Const b = 0.44
Private Const c = 0.725

Private k

' @brief    Calcuates the maximum allowed current for a given temperature rise. Call this from Main.vbs.
' @param    dummyVar     Dummy variable to stop function appearing in the Altium "Run Script" dialogue.
Sub CurrentCalculator(dummyVar)

    Dim status

    '===== LOAD ANY SAVED VARIABLES ====='

    Dim allowedTempRiseC
    allowedTempRiseC = GetUserData(moduleName, "AllowedTempRiseC")
    'ShowMessage("Got user data AllowedTempRise = " + allowedTempRiseC)
    If allowedTempRiseC <> "" Then
        EditAllowedTempRise.Text = allowedTempRiseC
    End If

	'===== REPEATIDLY ASK FOR TRACKS UNTIL ERROR OR ESC PRESSED =====
    Dim foundTrack
    foundTrack = False
    Do While Not foundTrack
        status = GetTrackAndUpdateVals(DummyVar)

        If status = GENERAL_ERROR Or status = ESC_PRESSED Then
             Exit Sub
        ElseIf status = NO_TRACK_SELECTED Then
             foundTrack = False
        ElseIf status = TRACK_SELECTED Then
             foundTrack = True
        End If

    Loop
    'FormMainScript.Visible = True

    ' Now lets show the form
    FormCurrentCalculator.ShowModal

End Sub

' Returns codes for GetTrackAndUpdateVals()
Private Const GENERAL_ERROR = 0
Private Const ESC_PRESSED = 1
Private Const NO_TRACK_SELECTED = 2
Private Const TRACK_SELECTED = 3

' @brief       Asks user to select a track and then updates associated form values.
' @returns     One of the returns codes listed directly above.
Function GetTrackAndUpdateVals(dummyVar)

    ' Set return value to false, unless we make it all the way to the end of this function
    GetTrackAndUpdateVals = False

    ' Load current board
    If PCBServer Is Nothing Then
        ShowMessage("ERROR: Could not load the PCB server.")
        GetTrackAndUpdateVals = GENERAL_ERROR
        Exit Function
    End If

    Dim board
    Set board = PCBServer.GetCurrentPCBBoard
    If board Is Nothing Then
        ShowMessage("ERROR: Could not load a PCB or footprint library. Please make sure one of these has focus.")
        GetTrackAndUpdateVals = GENERAL_ERROR
        Exit Function
    End If

    ' Get the layer stack for the board, this will be used later
    ' to extract the layer that the track of interest is on
    Dim layerStack
    layerStack = board.layerStack

    ' Ask user to select first pad object
    Dim x, y
    Dim escNotPressed
    If Not board.ChooseLocation(x, y, "Choose a track for current calculations.") Then
        GetTrackAndUpdateVals = ESC_PRESSED
        Exit Function
    End If


    Dim exisTrackOrVia
	' Get object at the position the user selected
	' 2015-05-19: Added ability to select eViaObject's
    Set exisTrackOrVia = Board.GetObjectAtXYAskUserIfAmbiguous(x, y, MkSet(eTrackObject, eViaObject), AllLayers, eEditAction_Select)

    ' Make sure track/via was selected
    If exisTrackOrVia Is Nothing Then
       ShowMessage("ERROR: A track was not selected.")
       GetTrackAndUpdateVals = NO_TRACK_SELECTED
       Exit Function
    End If

	If exisTrackOrVia.ObjectID = eTrackObject Then

		' Enable the track UI group and disable all other groups
	    EnableUiGroupTrack(True)
		EnableUiGroupVia(False)

	    ' If here, we must have a valid track
	    ' Get the layer object for this track
	    Dim exisTrackLayer
	    exisTrackLayer = layerStack.LayerObject(exisTrackOrVia.Layer)

	    ' Now get thickness of track (equal to thickness of layer track is on)
	    Dim trackThicknessMm
	    trackThicknessMm = CoordToMms(ExisTrackLayer.CopperThickness)
		' Convert from mm to um
	    LabelTrackThicknessUm.Caption = trackThicknessMm*1000

	    Dim trackWidthMm
	    trackWidthMm = CoordToMms(exisTrackOrVia.Width)
	    LabelTrackWidthMm.Caption = trackWidthMm

	    ' Determine the constant k, which is dependent on whether track
	    ' is on internal or external layer
	    If IsInternalLayer(exisTrackOrVia.Layer) Then
	         k = 0.024
	         LabelTrackLayer.Caption = "Internal"
	    Else
	        k = 0.048
	        LabelTrackLayer.Caption = "External"
	    End If

	    ' Equation: I = k x dT^b x A^c
	    ' where A = cross-secitonal area of track (mills^2), b = 0.44, c = 0.725, k = layer dependent

	    ' Calculate cross-sectional area
	    Dim crossSectionalAreaMm2
	    crossSectionalAreaMm2 = trackThicknessMm*trackWidthMm
	    LabelTrackCrosssectionalAreaMm2.Caption = crossSectionalAreaMm2

	    ' Convert mm^2 to mills^2 for equation
	    'Dim CrossSectionalAreaMill2
	    'CrossSectionalAreaMill2 = CrossSectionalAreaMm2 * (1000/25.4) * (1000/25.4)

	    Dim allowedTempRise
	    allowedTempRise = StrToFloat(EditAllowedTempRise.Text)

 		Call CalcMaxCurrentA(StrToFloat(EditAllowedTempRise.Text), StrToFloat(LabelTrackCrosssectionalAreaMm2.Caption))

		' Set return status
     	GetTrackAndUpdateVals = TRACK_SELECTED

	ElseIf exisTrackOrVia.ObjectID = eViaObject Then
        'ShowMessage("You selected a via!")

		' Enable the Via UI group and disable all other groups
        EnableUiGroupTrack(False)
		EnableUiGroupVia(True)

		' Assume worst-case for vias, and make the k constant equal to that of an internal
		' track
		k = 0.024

		' Display finished hole diameter and start/stop layer info
		LabelViaFinishedHoleDiameterMm.Caption = CStr(CoordToMMs(exisTrackOrVia.HoleSize))
		LabelViaStartLayer.Caption = exisTrackOrVia.StartLayer.Name
		LabelViaStopLayer.Caption = exisTrackOrVia.StopLayer.Name

		' Safe to call this as object must be a via at this point
		LabelViaHeightMm.Caption = CStr(GetViaOrHoleHeightMm(board, exisTrackOrVia))

		' The cross-sectional area of the via is pi x the average diameter x the thickness
		Dim viaCrossSectionalAreaMm2
		viaCrossSectionalAreaMm2 = pi * (CoordToMMs(exisTrackOrVia.HoleSize) + StrToFloat(EditViaPlatingThicknessUm.Text)/1000) * (StrToFloat(EditViaPlatingThicknessUm.Text)/1000)

		' Round the cross-sectional area to 4SF before displaying to the user
		LabelViaCrossSectionalAreaMm2.Caption = CStr(SfFormat(viaCrossSectionalAreaMm2,4))

		' Finally, calculate the maximum allowed current
		Call CalcMaxCurrentA(StrToFloat(EditAllowedTempRise.Text), viaCrossSectionalAreaMm2)

		' Set return status
		GetTrackAndUpdateVals = TRACK_SELECTED
	Else
    	ShowMessage("ERROR: Selected object was not a track or via! Is selection mask set incorrectly?")
	    GetTrackAndUpdateVals = GENERAL_ERROR
	End If

    '===== SAVE USER VARIABLES ====='
    'ShowMessage("Saving AllowedTempRiseC = " + EditAllowedTempRise.Text)
    Call SaveUserData(moduleName, "AllowedTempRiseC", EditAllowedTempRise.Text)


End Function



' @brief     Calculates the maximum current given an allowed temp rise and cross-sectional area.
' @details   Gets other values from the fields on the form.
Function CalcMaxCurrentA(allowedTempRise, crossSectionalAreaMm2)

     If(IsNumeric(allowedTempRise) = False) Then
          LabelMaxCurrentA.Caption = "NaN"
          Exit Function
     End If

     If CDbl(allowedTempRise) <= 0 Then
          LabelMaxCurrentA.Caption = "NaN"
          Exit Function
     End If

	 ShowMessage("Calculating current. Allowed temp rise = '" + CStr(allowedTempRise) + "', cross-sectional area mm^2 = '" + CStr(crossSectionalAreaMm2) + "'.")
     Dim crossSectionalAreaMill2
     crossSectionalAreaMill2 = StrToFloat(crossSectionalAreaMm2) * (1000/25.4) * (1000/25.4)

     Dim maxCurrentA
     maxCurrentA = k * CDbl(allowedTempRise)^b * crossSectionalAreaMill2^c
     LabelMaxCurrentA.Caption = SfFormat(maxCurrentA, 3)
End Function

Sub EditAllowedTempRiseChange(Sender)

     ' Allowed temp range has changed, so re-calculate the max current
     Call CalcMaxCurrentA(EditAllowedTempRise.Text, LabelTrackCrosssectionalAreaMm2.Caption)
End Sub

' @brief	Event handler for when the "Find Another Track" button is clicked.
Sub ButtonFindAnotherTrackClick(Sender)

    ' Hide the form so the user can easily select a new track
    FormCurrentCalculator.Hide

    ' Call subroutine which asks user for a track and updates
    ' form values
    Dim dummyVar

    Dim status

    Dim foundTrack
    foundTrack = False

    Do While Not foundTrack
        status = GetTrackAndUpdateVals(dummyVar)

        If status = GENERAL_ERROR Or status = ESC_PRESSED Then
           FormCurrentCalculator.Close
           Exit Sub
        ElseIf status = NO_TRACK_SELECTED Then
           foundTrack = False
        ElseIf status = TRACK_SELECTED Then
           foundTrack = True
        End If

    Loop

    ' Now show the form again
    FormCurrentCalculator.Show
End Sub

' @brief	Enables/disables the UI elements associated with a track.
' @param	trueFalse	Pass in True to enable the track UI elements, False to disable them.
Function EnableUiGroupTrack(trueFalse)
	LabelTrackThicknessUmText.Enabled = trueFalse
	LabelTrackThicknessUm.Enabled = trueFalse
	LabelTrackWidthMmTitle.Enabled = trueFalse
	LabelTrackWidthMm.Enabled = trueFalse
	LabelTrackLayerTitle.Enabled = trueFalse
	LabelTrackLayer.Enabled = trueFalse
	LabelTrackCrossSectionalAreaMm2Title.Enabled = trueFalse
	LabelTrackCrosssectionalAreaMm2.Enabled = trueFalse

End Function

' @brief	Enables/disables the UI elements associated with a via.
' @param	trueFalse	Pass in True to enable the via UI elements, False to disable them.
Function EnableUiGroupVia(trueFalse)
	LabelViaFinishedHoleDiameterMmTitle.Enabled = trueFalse
	LabelViaFinishedHoleDiameterMm.Enabled = trueFalse
	LabelViaStartLayerTitle.Enabled = trueFalse
    LabelViaStartLayer.Enabled = trueFalse
	LabelViaStopLayerTitle.Enabled = trueFalse
	LabelViaStopLayer.Enabled = trueFalse
	LabelViaHeightMmTitle.Enabled = trueFalse
	LabelViaHeightMm.Enabled = trueFalse
	LabelViaPlatingThicknessUmTitle.Enabled = trueFalse
	EditViaPlatingThicknessUm.Enabled = trueFalse
	LabelViaCrossSectionalAreaMm2Title.Enabled = trueFalse
	LabelViaCrossSectionalAreaMm2.Enabled = trueFalse
End Function

