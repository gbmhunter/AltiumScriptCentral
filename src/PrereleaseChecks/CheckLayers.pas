procedure CheckLayers(textOutput : TMemo);
var
    workspace       : IWorkspace;
    pcbProject      : IProject;
    document        : IDocument;
    pcbBoard        : IPCB_Board;
    layerStack      : IPCB_LayerStack;
    layer           : TLayer;
    mechLayer       : IPCB_MechanicalLayer;
    pcbIterator     : IPCB_BoardIterator;
    pcbObject       : IPCB_Primitive;
    violationFnd    : Boolean;
    violationCnt  : Integer;
    LS : String;
    docNum ;
begin
    textOutput.Text := textOutput.Text + 'Checking layers...' + #13#10;
	violationCnt := 0;

    // Obtain the PCB server interface.
    If PCBServer = nil then
    begin
        textOutput.Text := textOutput.Text + 'PCB server not online.' + #13#10;
        exit;
    end;

    // Get pcb project interface
    workspace := GetWorkspace;
    pcbProject  := workspace.DM_FocusedProject;

    if(pcbProject = nil)then
    begin
        ShowMessage('Current Project is not a PCB Project');
        exit;
    end;

      // Loop through all project documents
    for docNum := 0 to pcbProject.DM_LogicalDocumentCount - 1 do
    begin
        document := pcbProject.DM_LogicalDocuments(docNum);
        ShowMessage(document.DM_DocumentKind);
        // If this is PCB document
        if document.DM_DocumentKind = 'PCB' then
        begin
        	ShowMessage('PCB Found');
        	pcbBoard := PCBServer.GetPCBBoardByPath(document.DM_FullPath);
        end;
    end;

    // Should this be gotten from the pcbProject, not the PCB server (so it doesn't have to
    // be open to work)
    //pcbBoard := pcbProject.DM_TopLevelPhysicalDocument;

    if pcbBoard = nil then
    begin
        textOutput.Text := textOutput.Text + 'ERROR: No PCB document found.' + #13#10;
        exit;
    end;

    // Get iterator, limiting search to mech 1 layer
    pcbIterator := pcbBoard.BoardIterator_Create;
    if pcbIterator = nil then
    begin
        textOutput.Text := textOutput.Text + 'ERROR: PCB iterator could not be created.' + #13#10;
        exit;
    end;

    pcbIterator.AddFilter_ObjectSet(AllObjects);
    pcbIterator.AddFilter_LayerSet(MkSet(eMechanical1));
    pcbIterator.AddFilter_Method(eProcessAll);

    //  Search  and  count  pads
    pcbObject  :=  pcbIterator.FirstPCBObject;
    while  (pcbObject  <>  nil)  do
    begin
    	// Make sure that only tracks are present on this layer
        if(pcbObject.ObjectId <> eTrackObject) then
            Inc(violationCnt);
        pcbObject  :=  pcbIterator.NextPCBObject;
    end;

    pcbBoard.BoardIterator_Destroy(pcbIterator);

    // Send output
    if(violationCnt = 0) then
        textOutput.Text := textOutput.Text + 'No layer violations found.' + #13#10;
    if(violationCnt <> 0) then
    begin
        textOutput.Text := textOutput.Text + 'VIOLATION: Layer violation found. Number of violations = ' + IntToStr(violationCnt) + '.' + #13#10;
    end;
end;
