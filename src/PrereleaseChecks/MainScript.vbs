Sub RunMainScript
    FormMainScript.ShowModal
End Sub

Sub Button1Click(Sender)
    CheckLayers(MemoOutput)
    CheckPowerPortOrientation(MemoOutput)
    CheckNoSupplierPartNumShown(MemoOutput)
End Sub
