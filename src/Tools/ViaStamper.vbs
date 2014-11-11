'
' @file               ViaStamper.vbs
' @author             Geoffrey Hunter <gbmhunter@gmail.com> (www.mbedded.ninja)
' @created            2014-11-11
' @last-modified      2014-11-11
' @brief              Script allows user to quickly 'stamp' many copies of a via onto a PCB.
'                     Useful when placing GND vias.
' @details
'                     See README.rst in repo root dir for more info.

Dim Board       ' As IPCB_Board

' @brief     Call this from AltiumScriptCentral
Sub ViaStamper(DummyVar)

        ' Load current board
    If PCBServer Is Nothing Then
        ShowMessage("Not a PCB or Footprint editor activated.")
    End If

    Set Board = PCBServer.GetCurrentPCBBoard
    If Board Is Nothing Then
        ShowMessage("Not a PCB or Footprint loaded.")
        Exit Sub
    End If

    ShowMessage("First select via you wish to copy and then click repeatidly to 'stamp'.")

    ' Ask user to select first pad object
    Board.ChooseLocation x, y, "Choose a via to copy."
    Set ExisVia = Board.GetObjectAtXYAskUserIfAmbiguous(x, y, MkSet(eViaObject), AllLayers, eEditAction_Select)

    ' Make sure via was valid
    If ExisVia Is Nothing Then
       ShowMessage("ERROR: A via was not selected.")
       Exit Sub
    End If

    Do While (Board.ChooseLocation(xm, ym, "Click to stamp via.") = true)

        ' Initialise systems
        Call PCBServer.PreProcess

        ' Create a new via object
        NewVia = PCBServer.PCBObjectFactory(eViaObject, eNoDimension, eCreate_Default)

        NewVia.Size = exisVia.Size
        NewVia.HoleSize = exisVia.HoleSize
        NewVia.LowLayer = exisVia.LowLayer
        NewVia.HighLayer = exisVia.HighLayer

        ' Place at selected position
        NewVia.X = xm
        NewVia.Y = ym

        ' Copy net name to new via
        NewVia.Net = exisVia.Net

        Board.AddPCBObject(NewVia)

        ' Refresh the PCB screen
        Call Client.SendMessage("PCB:Zoom", "Action=Redraw" , 255, Client.CurrentView)

        ' Update the undo System in DXP that a new vIa object has been added to the board
        Call PCBServer.SendMessageToRobots(Board.I_ObjectAddress, c_Broadcast, PCBM_BoardRegisteration, NewVia.I_ObjectAddress)

        ' Finalize the PCB editor systems???
        Call PCBServer.PostProcess

        ' Repeat until Esc is hit
    Loop

     ' Full PCB system update
     Board.ViewManager_FullUpdate
     Call Client.SendMessage("PCB:Zoom", "Action=Redraw" , 255, Client.CurrentView) 

End Sub
