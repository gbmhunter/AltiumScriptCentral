'
' @file               ResizeDesignators.vbs
' @author             Geoffrey Hunter <gbmhunter@gmail.com> (www.mbedded.ninja)
' @created            2013-08-08
' @last-modified      2014-12-22
' @brief              Code to change the font size of many PCB designators all at once.
' @details
'                     See README.rst in repo root dir for more info.

' Forces us to explicitly define all variables before using them
Option Explicit

Private ModuleName
ModuleName = "ResizeDesignators.vbs"

' @brief    Called when 'Resize Designators' is called from the main AltiumScriptCentral form.
Function ResizeDesignators(dummyVar)
   ' Show form
   FormResizeDesignators.Show
End Function

Sub ButtonOkClick(Sender)

    Dim Board       ' As IPCB_Board
    Dim Component
    Dim CompDes

    Set Board = PCBServer.GetCurrentPCBBoard
    If Board Is Nothing Then
        ShowMessage("Could not load current PCB board")
        Exit Sub
    End If

    '========== VALIDATE INPUTS =========='

    If Not IsPerfectlyNumeric(EditHeightMm.Text) Then
        ShowMessage("ERROR: 'Height' input must be a valid number.")
        Exit Sub
    End If

    If Not IsPerfectlyNumeric(EditWidthMm.Text) Then
        ShowMessage("ERROR: 'Width' input must be a valid number.")
        Exit Sub
    End If



    Dim NumDesignatorsModified
    NumDesignatorsModified = 0

    Dim Iterator
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
    'Pcbserver.PostProcess
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
