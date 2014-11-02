Sub PlaceNettedVia(dummyVar)
    Dim board ' As IPCB_Board
    Dim exisVia, newVia ' As IPCB_Primative
    Dim xm, ym

    Set board = PCBServer.GetCurrentPCBBoard

    If board Is Nothing Then
        Exit Sub
    End If

    exisVia = board.GetObjectAtCursor(MkSet(eViaObject), AllLayers, "Select via.")
    
    ' Not really needed since filter only allows vias to be selected anyway
    If exisVia Is Nothing Then
        ShowMessage("A via was not selected.")
        Exit Sub
    End If

    Do While (board.ChooseLocation(xm, ym, "Select where via is to be placed.") = true)

        ' Start of undo unit
        Pcbserver.PreProcess

        newVia = PCBServer.PCBObjectFactory(eViaObject, eNoDimension, eCreate_Default)

        newVia.Size = exisVia.Size
        newVia.HoleSize = exisVia.HoleSize
        newVia.LowLayer = exisVia.LowLayer
        newVia.HighLayer = exisVia.HighLayer

        ' Place at selected position
        newVia.X = xm
        newVia.Y = ym

        ' Copy net name to new via
        newVia.Net = exisVia.Net

        Board.AddPCBObject(newVia)
        ' Refresh the PCB screen
        Call Client.SendMessage("PCB:Zoom", "Action=Redraw" , 255, Client.CurrentView)

        ' End of undo unit
        Pcbserver.PostProcess
    Loop
End Sub

