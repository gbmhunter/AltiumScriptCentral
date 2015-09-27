'                                                                                                                 '
' @file               DrawPolygon.vbs
' @author             Geoffrey Hunter <gbmhunter@gmail.com> (www.mbedded.ninja)
' @created            2014-11-11
' @last-modified      2015-09-28
' @brief              Script draws a polygon made from tracks.
'                     Ability to specify the number of edges, track width, rotation, e.t.c.
' @details
'                     See README.rst in repo root dir for more info.

' Forces us to explicitly define all variables before using them
Option Explicit

' @brief       Used to store board object.
Private Board

' @param     DummyVar     Dummy variable to stop function appearing in the Altium "Run Script" dialogue.
Sub DrawPolygon(DummyVar)

    ' Set Locale to Austria
    'SetLocale(3079)

    ' Load current board
    If PCBServer Is Nothing Then
        ShowMessage("ERROR: Not a PCB or footprint editor activated.")
    End If

    Set board = PCBServer.GetCurrentPCBBoard
    If board Is Nothing Then
        ShowMessage("ERROR: Not a PCB or footprint loaded.")
        Exit Sub
    End If

    ' Get the current PCB layer and populate field on UI
    EditDrawLayer.Text = Layer2String(Board.CurrentLayer)

    ' Display form
    FormDrawPolygon.Show
End Sub

Sub ButtonDrawOnPcbClick(Sender)

     '======================================================'
     '========== RETRIEVE AND VALIDATE USER INPUT =========='
     '======================================================'

     Dim numEdges
     numEdges = EditNumEdges.Text
     ' Validate
     If Not IsInt(numEdges) Then
          ShowMessage("ERROR: 'Num. Edges' input must be an integer")
          Exit Sub
     End If

     If numEdges < 3 Then
         ShowMessage("ERROR: 'Num. Edges' input must be equal to or greater than 3.")
         Exit Sub
     End If

     Dim vertexRadiusSelected
	 Dim edgeRadiusSelected
	 Dim edgeLengthSelected

     ' Get values of radio buttons, only one of these should be checked
     vertexRadiusSelected = RadioButtonVertexRadiusMm.Checked
     edgeRadiusSelected = RadioButtonEdgeRadiusMm.Checked
     edgeLengthSelected = RadioButtonEdgeLengthMm.Checked

     If vertexRadiusSelected Then
        If Not IsPerfectlyNumeric(EditVertexRadiusMm.Text) Then
            ShowMessage("ERROR: 'Vertex Radius (mm)' input must be a valid number.")
            Exit Sub
        End If
        If CDbl(EditVertexRadiusMm.Text) <= 0 Then
            ShowMessage("ERROR: 'Vertex Radius (mm)' input must be greater than 0.")
            Exit Sub
        End If
     ElseIf edgeRadiusSelected Then
        If Not IsPerfectlyNumeric(EditEdgeRadiusMm.Text) Then
            ShowMessage("ERROR: 'Edge Radius (mm)' input must be a valid number.")
            Exit Sub
        End If
        If CDbl(EditEdgeRadiusMm.Text) <= 0 Then
            ShowMessage("ERROR: 'Edge Radius (mm)' input must be greater than 0.")
            Exit Sub
        End If
     ElseIf edgeLengthSelected Then
        If Not IsPerfectlyNumeric(EditEdgeLengthMm.Text) Then
            ShowMessage("ERROR: 'Edge Length (mm)' input must be a valid number.")
            Exit Sub
        End If
        If CDbl(EditEdgeLengthMm.Text) <= 0 Then
            ShowMessage("ERROR: 'Edge Length (mm)' input must be greater than 0.")
            Exit Sub
        End If
     End If

     ' Rotation
     If Not IsPerfectlyNumeric(EditRotationDeg.Text) Then
         ShowMessage("ERROR: 'Rotation' input must be a valid number.")
         Exit Sub
     End If
     Dim rotationDeg
     rotationDeg = StrToFloat(EditRotationDeg.Text)

     ' Line thickness
     If Not IsPerfectlyNumeric(EditLineThicknessMm.Text) Then
         ShowMessage("ERROR: 'Line Thickness (mm)' input must be a valid number.")
         Exit Sub
     End If
     Dim lineThicknessMm
     lineThicknessMm = StrToFloat(EditLineThicknessMm.Text)
     If lineThicknessMm < 0 Then
         ShowMessage("ERROR: 'Line Thickness (mm)' input must be greater than 0.")
         Exit Sub
     End If

     Dim layer
     ' Convert the string to a valid Altium layer
     layer = String2Layer(EditDrawLayer.Text)
     If layer = 0 Then
          ' Show error msg, close "DrawPolygon" form and exit
          ShowMessage("ERROR: '" + EditDrawLayer.Text + "' in 'Draw Layer' box is not a valid layer!")
          'FormDrawPolygon.Close
          Exit Sub
     End If
     'ShowMessage("Layer = " + CStr(Layer))

     ' Get the Pi constant, note that VB script has no built-in constant
     ' so this is one of the best ways to do it.
     Dim Pi
     Pi = 4 * Atn(1)

     ' Get user to choose where the centre of the hexeagon is going to go
     Dim xm, ym
     Call board.ChooseLocation(xm, ym, "Select the centre of the hexagon.")

     ' Initialise systems
     Call PCBServer.PreProcess

     ' Calculate the sector angle. This is the angle a single sector of the polygon encompasses, as
     ' measured around the origin of the polygon.
     Dim sectorAngle
     sectorAngle = 360.0/numEdges

     ' Get first points, this depends on the method choosen to define the
     ' polygon's size
     Dim vertexRadiusMm
	 Dim edgeRadiusMm
	 Dim EdgeLengthMm
     Dim x1
	 Dim y1
	 Dim x2
	 Dim y2
     If vertexRadiusSelected Then
        vertexRadiusMm = CDbl(EditVertexRadiusMm.Text)
        x1 = -vertexRadiusMm * sin((sectorAngle/2)*Pi/180)
        y1 = vertexRadiusMm * cos((sectorAngle/2)*Pi/180)

        x2 = vertexRadiusMm * sin((sectorAngle/2)*Pi/180)
        y2 = vertexRadiusMm * cos((sectorAngle/2)*Pi/180)
     ElseIf edgeRadiusSelected Then
        edgeRadiusMm = CDbl(EditEdgeRadiusMm.Text)
        x1 = -edgeRadiusMm * tan((SectorAngle/2)*Pi/180)
        y1 = edgeRadiusMm

        x2 = edgeRadiusMm * tan((SectorAngle/2)*Pi/180)
        y2 = edgeRadiusMm
     ElseIf edgeLengthSelected Then
        edgeLengthMm = CDbl(EditEdgeLengthMm.Text)
        x1 = -edgeLengthMm/2
        y1 = edgeLengthMm/(2*tan((SectorAngle/2)*Pi/180))

        x2 = edgeLengthMm/2
        y2 = edgeLengthMm/(2*tan((SectorAngle/2)*Pi/180))
     End If

     ' Perform initial rotation as user specified
     Dim newX1, newY1, newX2, newY2
     newX1 = x1*cos(RotationDeg*Pi/180) + y1*sin(RotationDeg*Pi/180)
     newY1 = -x1*sin(RotationDeg*Pi/180) + y1*cos(RotationDeg*Pi/180)

     newX2 = x2*cos(RotationDeg*Pi/180) + y2*sin(RotationDeg*Pi/180)
     newY2 = -x2*sin(RotationDeg*Pi/180) + y2*cos(RotationDeg*Pi/180)

     x1 = newX1
     y1 = newY1
     x2 = newX2
     y2 = newY2


     ' Create each track seperately
     Dim index
     For index = 0 To (NumEdges - 1)

          ' Create a new track object
          Dim track
          track = PCBServer.PCBObjectFactory(eTrackObject, eNoDimension, eCreate_Default)

          'ShowMessage("x1 = " + CStr(x1) + ", y1 = " + CStr(y1))

          ' Place track in correct position
          track.x1 = xm + MMsToCoord(x1)
          track.y1 = ym + MMsToCoord(y1)

          track.x2 = xm + MMsToCoord(x2)
          track.y2 = ym + MMsToCoord(y2)

          track.Width = MMsToCoord(LineThicknessMm)
          track.Layer = Layer

          ' Add track to PCB
          board.AddPCBObject(Track)

          ' Rotate points for next iteration of loop
          newX1 = x1*cos(SectorAngle*Pi/180) + y1*sin(SectorAngle*Pi/180)
          newY1 = -x1*sin(SectorAngle*Pi/180) + y1*cos(SectorAngle*Pi/180)

          newX2 = x2*cos(SectorAngle*Pi/180) + y2*sin(SectorAngle*Pi/180)
          newY2 = -x2*sin(SectorAngle*Pi/180) + y2*cos(SectorAngle*Pi/180)

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

    ' Close form
    FormDrawPolygon.Close

End Sub

Sub ButtonCancelClick(Sender)
    ' Close form
    FormDrawPolygon.Close
End Sub
