'
' @file               CurrentCalculator.vbs
' @author             Geoffrey Hunter <gbmhunter@gmail.com> (www.mbedded.ninja)
' @created            2014-11-24
' @last-modified      2014-11-24
' @brief              Script allows user to determine the maximum allowed current
'                     of a particular track for a given temperature rise.
' @details
'                     See README.rst in repo root dir for more info.

' @brief    Calcuates the maximum allowed current for a given temperature rise.
Sub CurrentCalculator(DummyVar)

    ' Load current board
    If PCBServer Is Nothing Then
        ShowMessage("Not a PCB or Footprint editor activated.")
    End If

    Set Board = PCBServer.GetCurrentPCBBoard
    If Board Is Nothing Then
        ShowMessage("Not a PCB or Footprint loaded.")
        Exit Sub
    End If

    ' Get the layer stack for the board, this will be used later
    ' to extract the layer that the track of interest is on
    LayerStack = Board.LayerStack

    ' Ask user to select first pad object
    Board.ChooseLocation x, y, "Choose a track for current calculations."
    Set ExisTrack = Board.GetObjectAtXYAskUserIfAmbiguous(x, y, MkSet(eTrackObject), AllLayers, eEditAction_Select)

    ' Make sure via was valid
    If ExisTrack Is Nothing Then
       ShowMessage("ERROR: A track was not selected.")
       Exit Sub
    End If

    PadNum = 30

    ' If here, we must have a valid track
    ' Get the layer object for this track
    ExisTrackLayer = LayerStack.LayerObject(ExisTrack.Layer)

    ' Now get thickness of track (equal to thickness of layer track is on)
    TrackThicknessMm = CoordToMms(ExisTrackLayer.CopperThickness)
    Message = Message + Pad("Track Thickness: ", PadNum) + CStr(TrackThicknessMm) + "mm." + VbCr + VbLf

    TrackWidthMm = CoordToMms(ExisTrack.Width)
    Message = Message + Pad("Track Width: ", PadNum) + CStr(TrackWidthMm) + "mm." + VbCr + VbLf

    ' Determine the constant k, which is dependent on whether track
    ' is on internal or external layer
    If IsInternalLayer(ExisTrack.Layer) Then
         k = 0.024
         Message = Message + Pad("Layer: Internal.", PadNum) + VbCr + VbLf
    Else
        k = 0.048
        Message = Message + Pad("Layer: External.", PadNum) + VbCr + VbLf
    End If

    ' Equation: I = k x dT^b x A^c
    ' where A = cross-secitonal area of track (mills^2), b = 0.44, c = 0.725, k = layer dependent
    b = 0.44
    c = 0.725

    ' Calculate cross-sectional area
    CrossSectionalAreaMm2 = TrackThicknessMm*TrackWidthMm
    Message = Message + Pad("Track Cross-sectional Area: ", PadNum) + CStr(CrossSectionalAreaMm2) + "mm^2." + VbCr + VbLf

    ' Convert mm^2 to mills^2 for equation
    CrossSectionalAreaMill2 = CrossSectionalAreaMm2 * (1000/25.4) * (1000/25.4)

    MaxCurrent = k * 20^b * CrossSectionalAreaMill2^c

    Message = Message + Pad("Maximum Current: ", PadNum) + CStr(Round(MaxCurrent, 2)) + "A." + VbCr + VbLf

    ShowMessage(Message)

End Sub
