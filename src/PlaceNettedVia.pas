procedure PlaceNettedVia();
var
   board : IPCB_Board;
   exisVia, newVia : IPCB_Primative;
   xm, ym;
begin
    board := PCBServer.GetCurrentPCBBoard;
    if board = nil then exit;

    exisVia := board.GetObjectAtCursor(
        MkSet(eViaObject),
        AllLayers,
        'Select via.');

    if exisVia = nil then
    begin
        ShowMessage('A via was not selected');
        exit;
    end;

    while (board.ChooseLocation(
            xm,
            ym,
            'Select where via is to be placed.') = true) do
    begin

        // Start of undo unit
        Pcbserver.PreProcess;

        newVia := PCBServer.PCBObjectFactory(
            eViaObject,
            eNoDimension,
            eCreate_Default);

        newVia.Size := exisVia.Size;
        newVia.HoleSize := exisVia.HoleSize;
        newVia.LowLayer := exisVia.LowLayer;
        newVia.HighLayer := exisVia.HighLayer;

        // Place at selected position
        newVia.X := xm;
        newVia.Y := ym;

        // Copy net name to new via
        newVia.Net := exisVia.Net;

        Board.AddPCBObject(newVia);
        // Refresh the PCB screen
        Client.SendMessage('PCB:Zoom', 'Action=Redraw' , 255, Client.CurrentView);

         // End of undo unit
    	Pcbserver.PostProcess;
    end;


end;

