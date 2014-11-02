'==============================================================================}
' ------------------------- Renumber Pads tool --------------------------------}
'------------------------------------------------------------------------------}
'-                                                                            -}
'-  Simple tool for renumbering of placed pads of a footprint in PCB library  -}
'-  or PCB document.                                                          -}
'-  You can select number index of first pad in window which appears after    -}
'-  running of the script. All other pads will be renumbered by Increment.    -}
'-  Script is terminateed by right click or Esc key during pad selection.     -}
'-                                                                            -}
'------------------------------------------------------------------------------}
'==============================================================================}

Dim Board       ' As IPCB_Board
Dim PadObject   ' As IPCB_Pad

Sub btnOKClick(sender)

    Dim PadIndex        ' As Integer
    Dim PadIncrement    ' As Integer

    ' Get requested first index number
    PadIndex = StrToInt(edFirstPadNumber.Text)
    PadIncrement = StrToInt(edPadIncrement.Text)
    RenumberPads.Visible = 0

    ' Ask user to select first pad object
    Set PadObject = Board.GetObjectAtCursor(MkSet(ePadObject), AllLayers, "Choose a pad.")
    Do While Not PadObject Is Nothing

        ' Create undo for each pad index change
        Call PCBServer.PreProcess
        Call PCBServer.SendMessageToRobots(PadObject.I_ObjectAddress, c_Broadcast, PCBM_BeginModify , c_NoEventData)

        ' Change pad index
        PadObject.Name = PadIndex
        Call PCBServer.SendMessageToRobots(PadObject.I_ObjectAddress, c_Broadcast, PCBM_EndModify , c_NoEventData)
        Call PCBServer.PostProcess

        PadIndex = PadIndex + PadIncrement
        ' Ask user to select next pad in infinite loop
        Set PadObject = Board.GetObjectAtCursor(MkSet(ePadObject), AllLayers, "Choose a pad")
    Loop

    Close
End Sub

Sub btnCancelClick(sender)
     FormRenumberPads.Close
End Sub

Sub RenumberPads(dummyVar)
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
