'
' @file               CurrentCalculator.vbs
' @author             Geoffrey Hunter <gbmhunter@gmail.com> (www.mbedded.ninja)
' @created            2014-11-24
' @last-modified      2014-12-23
' @brief              Script allows user to determine the maximum allowed current
'                     of a particular track for a given temperature rise.
' @details
'                     See README.rst in repo root dir for more info.

' Forces us to explicitly define all variables before using them
Option Explicit

Private b
b = 0.44
Private c
c = 0.725

Private k

' @brief       Asks user to select a track and then updates associated form values.
Sub GetTrackAndUpdateVals(DummyVar)
    ' Load current board
    If PCBServer Is Nothing Then
        ShowMessage("ERROR: Could not load the PCB server.")
    End If

    Dim Board
    Set Board = PCBServer.GetCurrentPCBBoard
    If Board Is Nothing Then
        ShowMessage("ERROR: Could not load a PCB or footprint library. Please make sure one of these has focus.")
        Exit Sub
    End If

    ' Get the layer stack for the board, this will be used later
    ' to extract the layer that the track of interest is on
    Dim LayerStack
    LayerStack = Board.LayerStack

    ' Ask user to select first pad object
    Dim x, y
    Board.ChooseLocation x, y, "Choose a track for current calculations."
    Dim ExisTrack
    Set ExisTrack = Board.GetObjectAtXYAskUserIfAmbiguous(x, y, MkSet(eTrackObject), AllLayers, eEditAction_Select)

    ' Make sure via was valid
    If ExisTrack Is Nothing Then
       ShowMessage("ERROR: A track was not selected.")
       Exit Sub
    End If

    ' If here, we must have a valid track
    ' Get the layer object for this track
    Dim ExisTrackLayer
    ExisTrackLayer = LayerStack.LayerObject(ExisTrack.Layer)

    ' Now get thickness of track (equal to thickness of layer track is on)
    Dim TrackThicknessMm
    TrackThicknessMm = CoordToMms(ExisTrackLayer.CopperThickness)
    LabelTrackThicknessUm.Caption = TrackThicknessMm*1000

    Dim TrackWidthMm
    TrackWidthMm = CoordToMms(ExisTrack.Width)
    LabelTrackWidthMm.Caption = TrackWidthMm

    ' Determine the constant k, which is dependent on whether track
    ' is on internal or external layer
    If IsInternalLayer(ExisTrack.Layer) Then
         k = 0.024
         LabelLayer.Caption = "Internal"
    Else
        k = 0.048
        LabelLayer.Caption = "External"
    End If

    ' Equation: I = k x dT^b x A^c
    ' where A = cross-secitonal area of track (mills^2), b = 0.44, c = 0.725, k = layer dependent

    ' Calculate cross-sectional area
    Dim CrossSectionalAreaMm2
    CrossSectionalAreaMm2 = TrackThicknessMm*TrackWidthMm
    LabelTrackCrosssectionalAreaMm2.Caption = CrossSectionalAreaMm2

    ' Convert mm^2 to mills^2 for equation
    'Dim CrossSectionalAreaMill2
    'CrossSectionalAreaMill2 = CrossSectionalAreaMm2 * (1000/25.4) * (1000/25.4)

    Dim AllowedTempRise
    AllowedTempRise = StrToFloat(EditAllowedTempRise.Text)

   ' Dim MaxCurrentA
    'MaxCurrentA = k * AllowedTempRise^b * CrossSectionalAreaMill2^c
    'LabelMaxCurrentA.Caption = SfFormat(MaxCurrentA, 3)

     Call CalcMaxCurrentA(StrToFloat(EditAllowedTempRise.Text), StrToFloat(LabelTrackCrosssectionalAreaMm2.Caption))
End Sub

' @brief    Calcuates the maximum allowed current for a given temperature rise.
' @param     DummyVar     Dummy variable to stop function appearing in the Altium "Run Script" dialogue.
Sub CurrentCalculator(DummyVar)


    GetTrackAndUpdateVals(DummyVar)
    'FormMainScript.Visible = True

    ' Now lets show the form
    FormCurrentCalculator.ShowModal

End Sub

Function CalcMaxCurrentA(AllowedTempRise, CrossSectionalAreaMm2)

     If(IsNumeric(AllowedTempRise) = False) Then
          LabelMaxCurrentA.Caption = "NaN"
          Exit Function
     End If

     If CDbl(AllowedTempRise) <= 0 Then
          LabelMaxCurrentA.Caption = "NaN"
          Exit Function
     End If

     Dim CrossSectionalAreaMill2
     CrossSectionalAreaMill2 = StrToFloat(CrossSectionalAreaMm2) * (1000/25.4) * (1000/25.4)

     Dim MaxCurrentA
     MaxCurrentA = k * CDbl(AllowedTempRise)^b * CrossSectionalAreaMill2^c
     LabelMaxCurrentA.Caption = SfFormat(MaxCurrentA, 3)
End Function

Sub EditAllowedTempRiseChange(Sender)

     ' Allowed temp range has changed, so re-calculate the max current
     Call CalcMaxCurrentA(EditAllowedTempRise.Text, LabelTrackCrosssectionalAreaMm2.Caption)
End Sub

Sub ButtonFindAnotherTrackClick(Sender)

     ' Hide the form so the user can easily select a new track
     FormCurrentCalculator.Hide

     ' Call subroutine which asks user for a track and updates
     ' form values
     Dim DummyVar
     Call GetTrackAndUpdateVals(DummyVar)

     ' Now show the form again
     FormCurrentCalculator.Show
End Sub
