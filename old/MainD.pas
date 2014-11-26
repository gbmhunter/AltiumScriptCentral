procedure TForm1.Form1Create(Sender: TObject);
begin
     //ShowMessage('Test');
end;

procedure TForm1.ButtonRunPreReleaseChecksClick(Sender: TObject);
begin
     ShowMessage('Testing');
end;

procedure TForm1.ButtonDisplayPcbStatsClick(Sender: TObject);
begin
     FormStatsD.ShowModal();
     Form1.Close;
end;

