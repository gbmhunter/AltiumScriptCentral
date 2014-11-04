'
' @file               RenumberPads.vbs
' @author             Geoffrey Hunter <gbmhunter@gmail.com> (www.mbedded.ninja)
' @created            2013-08-08
' @last-modified      2014-11-05
' @brief              Script allows user to quickly renumber pads on a PCB component
'                     by clicking them in order.
' @details
'                     See README.rst in repo root dir for more info.

Dim Board       ' As IPCB_Board
Dim PadObject   ' As IPCB_Pad

' @brief     Call this from AltiumScriptCentral
Sub RenumberPads(DummyVar)
    ' Show form, non-modal
    ' ShowModal won't return until form is closed.
    FormRenumberPads.Show

        ' Load current board
    If PCBServer Is Nothing Then
        ShowMessage("Not a PCB or Footprint editor activated.")
    End If

    Set Board = PCBServer.GetCurrentPCBBoard
    If Board Is Nothing Then
        ShowMessage("Not a PCB or Footprint loaded.")
        Exit Sub
    End If
End Sub

Function ButtonOkClick(sender)

    ' Get the requested first index number and
    ' increment
    PadIndex = StrToInt(EditFirstPadNumber.Text)
    PadIncrement = StrToInt(EditPadIncrement.Text)

    ' 2014-11-05: I think the next line is causing bugs, so I have left
    ' the form visible
    'FormRenumberPads.Visible = 0

    ' Ask user to select first pad object
    Board.ChooseLocation x, y, "Choose a pad."
    Set PadObject = Board.GetObjectAtXYAskUserIfAmbiguous(x, y, MkSet(ePadObject), AllLayers, eEditAction_Select)

    Do While Not PadObject Is Nothing

        ' Create undo for each pad index change
        Call PCBServer.PreProcess
        Call PCBServer.SendMessageToRobots(PadObject.I_ObjectAddress, c_Broadcast, PCBM_BeginModify , c_NoEventData)

        ' Change pad index
        PadObject.Name = PadIndex

        ' This here causes the PCB view to refresh, displaying the changed PAD number
        Call PCBServer.SendMessageToRobots(PadObject.I_ObjectAddress, c_Broadcast, PCBM_EndModify , c_NoEventData)
        Call PCBServer.PostProcess

        ' Increment the pad index
        PadIndex = PadIndex + PadIncrement

        ' Ask user to select next pad in infinite loop
        Board.ChooseLocation x, y, "Choose a pad."
        Set PadObject = board.GetObjectAtXYAskUserIfAmbiguous(x, y, MkSet(ePadObject), AllLayers, eEditAction_Select)

    Loop

    ' Finally, close the form
    FormRenumberPads.Close
End Function

Sub ButtonCancelClick(sender)
    ' Close the form
    FormRenumberPads.Close
End Sub
