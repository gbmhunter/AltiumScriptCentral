'
' @file               ResizeDesignators.vbs
' @author             Geoffrey Hunter <gbmhunter@gmail.com> (www.mbedded.ninja)
' @created            2013-08-08
' @last-modified      2014-11-07
' @brief              Code to change the font size of many PCB designators all at once.
' @details
'                     See README.rst in repo root dir for more info.

' @brief    Called when 'Resize Designators' is called from the main AltiumScriptCentral form.
Function ResizeDesignators(dummyVar)
   ' Show form
   FormResizeDesignators.Show
End Function

Sub ButtonOkClick(Sender)

    Dim board       ' As IPCB_Board
    Dim iterator
    Dim component
    Dim compDes

    Set Board = PCBServer.GetCurrentPCBBoard
    If Board Is Nothing Then
        ShowMessage("Could not load current PCB board")
        Exit Sub
    End If

    NumDesignatorsModified = 0

    Set iterator = board.BoardIterator_Create
    iterator.AddFilter_ObjectSet(MkSet(eComponentObject))
    iterator.AddFilter_LayerSet(AllLayers)
    iterator.AddFilter_Method(eProcessAll)

    Set compDes = iterator.FirstPCBObject
    PCBServer.PreProcess

    Do While Not (CompDes Is Nothing)
        Call PCBServer.SendMessageToRobots(CompDes.Name.I_ObjectAddress, c_Broadcast, PCBM_BeginModify, c_NoEventData)

        If CheckBoxOnlyModifyDefaultSizedDesignators.Checked = True Then
             If (CompDes.Name.Width = MMsToCoord(0.254)) And (CompDes.Name.Size = MMsToCoord(1.524)) Then
                  ' Designator IS default sized, so lets change
                   CompDes.Name.Width = MMsToCoord(EditWidthMm.Text)
                   CompDes.Name.Size = MMsToCoord(EditHeightMm.Text)
                   NumDesignatorsModified = NumDesignatorsModified + 1
             End If
        Else
             ' Set the widths/heights
             CompDes.Name.Width = MMsToCoord(EditWidthMm.Text)
             CompDes.Name.Size = MMsToCoord(EditHeightMm.Text)
             NumDesignatorsModified = NumDesignatorsModified + 1
        End If

        Call PCBServer.SendMessageToRobots(CompDes.Name.I_ObjectAddress, c_Broadcast, PCBM_EndModify, c_NoEventData)

        Set CompDes = Iterator.NextPCBObject
    Loop

    Board.BoardIterator_Destroy(Iterator)

    Pcbserver.PostProcess
    Call AddStringParameter("Action", "Redraw")
    'Call RunProcess("PCB:Zoom")

    ShowMessage(CStr(NumDesignatorsModified) + " designators modified.")

    ' Finally close the form
    FormResizeDesignators.Close

End Sub

Sub ButtonCancelClick(Sender)
   ' Just close the form
   FormResizeDesignators.Close
End Sub
