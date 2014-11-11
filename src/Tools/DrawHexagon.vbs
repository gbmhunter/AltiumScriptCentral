'                                                                                                                 '
' @file               DrawHexagon.vbs
' @author             Geoffrey Hunter <gbmhunter@gmail.com> (www.mbedded.ninja)
' @created            2014-11-11
' @last-modified      2014-11-12
' @brief              Script draws a hexagon made from tracks.
' @details
'                     See README.rst in repo root dir for more info.

Dim Board

Sub DrawHexagon(DummyVar)

    ' Load current board
    If PCBServer Is Nothing Then
        ShowMessage("Not a PCB or Footprint editor activated.")
    End If

    Set Board = PCBServer.GetCurrentPCBBoard
    If Board Is Nothing Then
        ShowMessage("Not a PCB or Footprint loaded.")
        Exit Sub
    End If

    ' Get the current PCB layer and populate field on UI
    EditDrawLayer.Text = Layer2String(Board.CurrentLayer)

    ' Display form
    FormDrawHexagon.Show
End Sub

Sub ButtonDrawOnPcbClick(Sender)
     ' Get values from input boxes
     RadiusMm = StrToFloat(EditRadiusMm.Text)
     RotationDeg = StrToFloat(EditRotationDeg.Text)
     LineThicknessMm = StrToFloat(EditLineThicknessMm.Text)
     Layer = String2Layer(EditDrawLayer.Text)
     If Layer = 0 Then
          ' Close "DrawHexagon" form and exit
          ShowMessage("ERROR: Test in 'Draw Layer' box was not a valid layer!")
          FormDrawHexagon.Close
          Exit Sub
     End If
     'ShowMessage("Layer = " + CStr(Layer))

     ' Get the Pi constant, note that VB script has no built-in constant
     ' so this is one of the best ways to do it.
     Pi = 4 * Atn(1)

     ' Get user to choose where the centre of the hexeagon is going to go
     Call Board.ChooseLocation(xm, ym, "Select the centre of the hexagon.")

     ' Initialise systems
     Call PCBServer.PreProcess

     ' Get first points
     x1 = -RadiusMm * sin(30*Pi/180)
     y1 = RadiusMm * cos(30*Pi/180)

     x2 = RadiusMm * sin(30*Pi/180)
     y2 = RadiusMm * cos(30*Pi/180)

     ' Perform initial rotation as user specified
     newX1 = x1*cos(RotationDeg*Pi/180) + y1*sin(RotationDeg*Pi/180)
     newY1 = -x1*sin(RotationDeg*Pi/180) + y1*cos(RotationDeg*Pi/180)

     newX2 = x2*cos(RotationDeg*Pi/180) + y2*sin(RotationDeg*Pi/180)
     newY2 = -x2*sin(RotationDeg*Pi/180) + y2*cos(RotationDeg*Pi/180)

     x1 = newX1
     y1 = newY1
     x2 = newX2
     y2 = newY2


     ' Create each track seperately
     For index = 0 To 5

          ' Create a new via object
          Track = PCBServer.PCBObjectFactory(eTrackObject, eNoDimension, eCreate_Default)

          'ShowMessage("x1 = " + CStr(x1) + ", y1 = " + CStr(y1))

          ' Place track in correct position
          Track.x1 = xm + MMsToCoord(x1)
          Track.y1 = ym + MMsToCoord(y1)

          Track.x2 = xm + MMsToCoord(x2)
          Track.y2 = ym + MMsToCoord(y2)

          Track.Width = MMsToCoord(LineThicknessMm)
          Track.Layer = Layer

          ' Add track to PCB
          Board.AddPCBObject(Track)

          ' Rotate points for next iteration of loop
          newX1 = x1*cos(60*Pi/180) + y1*sin(60*Pi/180)
          newY1 = -x1*sin(60*Pi/180) + y1*cos(60*Pi/180)

          newX2 = x2*cos(60*Pi/180) + y2*sin(60*Pi/180)
          newY2 = -x2*sin(60*Pi/180) + y2*cos(60*Pi/180)

          x1 = newX1
          y1 = newY1
          x2 = newX2
          y2 = newY2

    Next

    ' Refresh the PCB screen
    Call Client.SendMessage("PCB:Zoom", "Action=Redraw" , 255, Client.CurrentView)

    ' Update the undo System in DXP that a new vIa object has been added to the board
    Call PCBServer.SendMessageToRobots(Board.I_ObjectAddress, c_Broadcast, PCBM_BoardRegisteration, Track.I_ObjectAddress)

    ' Initialise systems
    Call PCBServer.PostProcess

    ' Close "DrawHexagon" form
    FormDrawHexagon.Close

End Sub

Sub ButtonCancelClick(Sender)
    ' Close "DrawHexagon" form
    FormDrawHexagon.Close
End Sub
