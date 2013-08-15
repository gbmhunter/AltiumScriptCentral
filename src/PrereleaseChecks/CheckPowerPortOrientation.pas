function CheckPowerPortOrientation(output : TMemo) : Boolean;
var
    workspace       : IWorkspace;
    pcbProject      : IProject;
    powerObj        : ISch_PowerObject;
    document        : IDocument;
    sheet           : ISch_Document;
    iterator        : ISch_Iterator;
    docNum          : Integer;
    violationCnt    : Integer;
begin

    violationCnt := 0;

    output.Text := output.Text + ('Check power port orientations...' + #13#10);
    // Obtain the schematic server interface.
    If SchServer = Nil Then Exit;

    // Get pcb project interface
    workspace := GetWorkspace;
    pcbProject  := workspace.DM_FocusedProject;

    // Initialize the robots in Schematic editor.
    //SchServer.ProcessControl.PreProcess(CurrentSheet, '');

    // Loop through all project documents
    for docNum := 0 to pcbProject.DM_LogicalDocumentCount - 1 do
    begin
        document := pcbProject.DM_LogicalDocuments(docNum);

        // If this is SCH document
        if document.DM_DocumentKind = 'SCH' then
        begin

            sheet := SCHServer.GetSchDocumentByPath(document.DM_FullPath);
            if sheet = nil then exit;

            // Set up iterator to look for popwer port objects only
            iterator := sheet.SchIterator_Create;
            if iterator = nil then exit;
            iterator.AddFilter_ObjectSet(MkSet(ePowerObject));

            powerObj := iterator.FirstSchObject;

            while powerObj <> Nil Do
            begin
                if(powerObj.Style = ePowerGndPower) or (powerObj.Style = ePowerGndSignal) or (powerObj.Style = ePowerGndEarth) then
                begin
                    // Make sure they are facing downwards
                    if not(powerObj.Orientation = eRotate270) then
                    begin
                        violationCnt := violationCnt + 1;
                    end;
                end;
                if (powerObj.Style = ePowerBar) then
                begin
                    // Make sure they are facing upwards
                    if not(powerObj.Orientation = eRotate90) then
                    begin
                        violationCnt := violationCnt + 1;
                    end;
                end;

                // Go to next object
                powerObj := iterator.NextSchObject;
            end;
        end;
    end;

    if(violationCnt > 0) then
    begin
    	output.Text := output.Text + 'VIOLATION: Power ports with incorrect orientation found! Number = ' + IntToStr(violationCnt) + '.' + #13#10;
    end;
    if(violationCnt = 0) then
        output.Text := output.Text + 'No power port violations found.' + #13#10;

end;

