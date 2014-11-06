'
' @file               ResizeDesignators.vbs
' @author             Geoffrey Hunter <gbmhunter@gmail.com> (www.mbedded.ninja)
' @created            2013-08-08
' @last-modified      2014-11-07
' @brief              Code to change the font size of many PCB designators all at once.
' @details
'                     See README.rst in repo root dir for more info.

Function ResizeDesignators(dummyVar)
   ' Show form
   FormResizeDesignators.Show
End Function



Sub ButtonOkClick(Sender)

    Dim board       ' As IPCB_Board
    Dim iterator
    Dim component
    Dim compDes

    Set Board = PCBServer.GetCurrentPCBBoard
    If Board Is Nothing Then
        ShowMessage("Could not load current PCB board")
        Exit Sub
    End If

    Set iterator = board.BoardIterator_Create
    iterator.AddFilter_ObjectSet(MkSet(eComponentObject))
    iterator.AddFilter_LayerSet(AllLayers)
    iterator.AddFilter_Method(eProcessAll)

    Set compDes = iterator.FirstPCBObject
    PCBServer.PreProcess

    Do While Not (CompDes Is Nothing)
        Call PCBServer.SendMessageToRobots(CompDes.Name.I_ObjectAddress, c_Broadcast, PCBM_BeginModify, c_NoEventData)

        ' Set the widths/heights
        CompDes.Name.Width = MMsToCoord(EditWidthMm.Text)
        CompDes.Name.Size = MMsToCoord(EditHeightMm.Text)

        Call PCBServer.SendMessageToRobots(CompDes.Name.I_ObjectAddress, c_Broadcast, PCBM_EndModify, c_NoEventData)

        Set CompDes = Iterator.NextPCBObject
    Loop

    Board.BoardIterator_Destroy(Iterator)

    Pcbserver.PostProcess
    Call AddStringParameter("Action", "Redraw")
    'Call RunProcess("PCB:Zoom")

    ' Finally close the form
    FormResizeDesignators.Close

End Sub

Sub ButtonCancelClick(Sender)
   ' Just close the form
   FormResizeDesignators.Close
End Sub
