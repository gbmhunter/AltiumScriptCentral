{
type TextOutput = Class
	private

    // These methods and properties are all usable by instances of the class
    published
    // Called when creating an instance (object) from this class
    // The passed string is the one that is operated on by the methods below
    constructor Create(Text : String);

    // Utility to replace all occurences of a substring in the string
    // The number of replacements is returned
    // This utility is CASE SENSITIVE
    function Write(msg : String) : Integer;


implementation
    function TextOutput.Write(msg : String) : Integer;
    begin
       // MemoInfo.Text := MemoInfo.Text + msg;
    end;
             }

Procedure RunMainScript;
Begin
    FormMainScript.ShowModal;
End;

procedure TFormMainScript.ButRunPreReleaseChecksClick(Sender: TObject);
var
	textOutput : TextOutput;
begin
    // Run pre-release checks

    CheckPowerPortOrientation(MemoInfo);
    CheckNoSupplierPartNumShown(MemoInfo);
end;


