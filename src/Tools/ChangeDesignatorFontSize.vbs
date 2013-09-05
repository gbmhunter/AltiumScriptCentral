Sub ChangeDesignatorFontSize
    Dim board 		' As IPCB_Board
    Dim iterator
    Dim component
    Dim compDes

    Set board = PCBServer.GetCurrentPCBBoard
    If board Is Nothing Then
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
        CompDes.Name.Width = MMsToCoord(0.2)
        CompDes.Name.Size = MMsToCoord(0.7)

        Call PCBServer.SendMessageToRobots(CompDes.Name.I_ObjectAddress, c_Broadcast, PCBM_EndModify, c_NoEventData)

        Set CompDes = Iterator.NextPCBObject
    Loop

    Board.BoardIterator_Destroy(Iterator)

    Pcbserver.PostProcess
    Call AddStringParameter("Action", "Redraw")
    'Call RunProcess("PCB:Zoom")
End Sub
