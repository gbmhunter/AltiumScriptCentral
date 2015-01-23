'
' @file               ViaStamper.vbs
' @author             Geoffrey Hunter <gbmhunter@gmail.com> (www.mbedded.ninja)
' @created            2014-11-11
' @last-modified      2015-01-23
' @brief              Script allows user to quickly 'stamp' many copies of a via onto a PCB.
'                     Useful when placing GND vias.
' @details
'                     See README.rst in repo root dir for more info.

' Forces us to explicitly define all variables before using them
Option Explicit

' @brief     Stamps (copies) vias to user-selected locations.
' @details   Call this from AltiumScriptCentral.
Sub ViaStamper(DummyVar)

    ' Load current board
    If PCBServer Is Nothing Then
        ShowMessage("No PCB or footprint editor activated.")
    End If

    Dim board
    Set board = PCBServer.GetCurrentPCBBoard
    If board Is Nothing Then
        ShowMessage("No PCB or footprint loaded.")
        Exit Sub
    End If

    'ShowMessage("First select via you wish to copy and then click repeatidly to 'stamp'.")

    ' Ask user to select first pad object
    Dim x, y
    board.ChooseLocation x, y, "Choose a via to copy."
    Dim exisVia
    Set exisVia = Board.GetObjectAtXYAskUserIfAmbiguous(x, y, MkSet(eViaObject), AllLayers, eEditAction_Select)

    ' Make sure via was valid
    If exisVia Is Nothing Then
       ShowMessage("ERROR: A via was not selected.")
       Exit Sub
    End If

    Dim xm, ym
    Do While (board.ChooseLocation(xm, ym, "Click to stamp via.") = true)

        ' Initialise systems
        Call PCBServer.PreProcess

        ' Create a new via object
        Dim newVia
        newVia = PCBServer.PCBObjectFactory(eViaObject, eNoDimension, eCreate_Default)

        newVia.Size = exisVia.Size
        newVia.HoleSize = exisVia.HoleSize
        newVia.LowLayer = exisVia.LowLayer
        newVia.HighLayer = exisVia.HighLayer

        ' Copy across "cache" data (testpoint and soldermask settings)
        newVia.Cache = exisVia.Cache

        ' Copy across "tenting" data
        newVia.IsTenting_Top = exisVia.IsTenting_Top
        newVia.IsTenting_Bottom = exisVia.IsTenting_Bottom

        ' Place at selected position
        newVia.X = xm
        newVia.Y = ym

        ' Copy net name to new via
        newVia.Net = exisVia.Net

        board.AddPCBObject(NewVia)

        ' Refresh the PCB screen
        Call Client.SendMessage("PCB:Zoom", "Action=Redraw" , 255, Client.CurrentView)

        ' Update the undo System in DXP that a new vIa object has been added to the board
        Call PCBServer.SendMessageToRobots(Board.I_ObjectAddress, c_Broadcast, PCBM_BoardRegisteration, NewVia.I_ObjectAddress)

        ' Finalize the PCB editor systems???
        Call PCBServer.PostProcess

        ' Repeat until Esc is hit
    Loop

     ' Full PCB system update
     board.ViewManager_FullUpdate
     Call Client.SendMessage("PCB:Zoom", "Action=Redraw" , 255, Client.CurrentView) 

End Sub
