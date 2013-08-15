procedure CheckNoSupplierPartNumShown(textOutput : TMemo);
var
    workspace       : IWorkspace;
    pcbProject      : IProject;
    document        : IDocument;
    flatHierarchy     : IDocument;
    sheet           : ISch_Document;
    docNum          : Integer;
    iterator        : ISch_Iterator;
    compIterator    : ISch_Iterator;
    component       : IComponent;
    parameter, parameter2       : ISch_Parameter;
    violationFnd    : Boolean;
    violationCount  : Integer;
begin
	textOutput.Text := textOutput.Text + 'Looking for visible supplier part numbers...' + #13#10;

    violationFnd := false;

    // Obtain the schematic server interface.
    If SchServer = nil then
    begin
        textOutput.Text := textOutput.Text + 'Schematic server not online.' + #13#10;
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

     // Compile project
   flatHierarchy := PCBProject.DM_DocumentFlattened;

   // If we couldn't get the flattened sheet, then most likely the project has
   // not been compiled recently
   if (flatHierarchy = Nil) Then
   begin
       	// First try compiling the project
       	ResetParameters;
       	AddStringParameter( 'Action', 'Compile' );
       	AddStringParameter( 'ObjectKind', 'Project' );
       	RunProcess( 'WorkspaceManager:Compile' );

       	// Try Again to open the flattened document
       	flatHierarchy := PCBProject.DM_DocumentFlattened;
		if (flatHierarchy = nil) then
       	begin
       	   textOutput.Text := textOutput.Text + 'ERROR: Compile the project before running this script.' + #13#10;
           exit;
    	end; // If (flattenedDoc = Nil) Then
	end;

    // Loop through all project documents
    for docNum := 0 to pcbProject.DM_LogicalDocumentCount - 1 do
    begin
        document := pcbProject.DM_LogicalDocuments(docNum);

        // If this is SCH document
        if document.DM_DocumentKind = 'SCH' then
        begin
            sheet := SCHServer.GetSchDocumentByPath(document.DM_FullPath);
            //ShowMessage(document.DM_FullPath);
            if sheet = nil then
            begin
                textOutput.Text := textOutput.Text + 'ERROR: No sheet found.' + #13#10;
                exit;
            end;

             // Set up iterator to look for power port objects only
            iterator := sheet.SchIterator_Create;
            if iterator = nil then exit;

            try
                iterator.AddFilter_ObjectSet(MkSet(eSchComponent));
                component := Iterator.FirstSchObject;
                while component <> nil do
                begin
                    try
                        compIterator := component.SchIterator_Create;
                        compIterator.AddFilter_ObjectSet(MkSet(eParameter));

                        parameter := compIterator.FirstSchObject;
                        // Loop through all parameters in object
                        while parameter <> Nil Do
                        begin
                            // Check for supplier part number parameter thats visible on sheet
                            if(parameter.Name = 'Supplier Part Number 1') and (parameter.IsHidden = false) then
                            begin

                                violationFnd := true;
                                violationCount := violationCount + 1;
                            end;
                            {
                            if ((AnsiUpperCase(Parameter.Name) = 'GROUP') and (Parameter.Text <> '') and (Parameter.Text <> '*')) then
                                if StrToInt(Parameter.Text) > MaxNumber then
                                    MaxNumber := StrToInt(Parameter.Text);
                           }
                            parameter := CompIterator.NextSchObject;
                        end;
                        finally
                        component.SchIterator_Destroy(compIterator);
                    end;
                    component := iterator.NextSchObject;
                end;
                finally
                    sheet.SchIterator_Destroy(iterator);
                end;
            end;
        end;
        if(violationFnd = false) then
        	textOutput.Text := textOutput.Text + 'No supplier part number violations found.' + #13#10;
        if(violationFnd = true) then
        begin
        	textOutput.Text := textOutput.Text + 'VIOLATION: Supplier part numbers visible on sheet. Number of violations = ' + IntToStr(violationCount) + '.' + #13#10;
        end
    end;



end;
