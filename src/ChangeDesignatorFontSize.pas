procedure ChangeDesignatorFontSize();
Var
    board       : IPCB_Board;
    Iterator;
    Component;
    CompDes;
Begin

    board := PCBServer.GetCurrentPCBBoard;
    if (board = nil) then exit;

    Iterator := board.BoardIterator_Create;

    Iterator.AddFilter_ObjectSet(MkSet(eComponentObject));
    Iterator.AddFilter_LayerSet(AllLayers);
    Iterator.AddFilter_Method(eProcessAll);

    CompDes := Iterator.FirstPCBObject;
    PCBServer.PreProcess;

    while not (CompDes = nil) do
    begin
        PCBServer.SendMessageToRobots(
            CompDes.Name.I_ObjectAddress,
            c_Broadcast,
            PCBM_BeginModify,
            c_NoEventData);

        // Set the widths/heights
        CompDes.Name.Width := MMsToCoord(0.2);
        CompDes.Name.Size := MMsToCoord(0.7);

        PCBServer.SendMessageToRobots(
            CompDes.Name.I_ObjectAddress,
            c_Broadcast,
            PCBM_EndModify ,
            c_NoEventData);

        CompDes := Iterator.NextPCBObject;
    end;

    Board.BoardIterator_Destroy(Iterator);

    Pcbserver.PostProcess;
    AddStringParameter('Action', 'Redraw');
    RunProcess('PCB:Zoom');
end;
