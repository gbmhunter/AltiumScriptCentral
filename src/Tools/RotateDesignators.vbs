Sub RotateDesignators
    Dim board
    Dim component

    StdOut("Rotating designators...")

	' Make sure we are on a PCB
    Set board = PCBServer.GetCurrentPCBBoard
    If board Is Nothing Then
    	StdErr("ERROR: Rotating designators failed because PCB board is not active.")
		Exit Sub
	End If

	' Set up iterator
    Iterator = board.BoardIterator_Create
    Iterator.AddFilter_ObjectSet(MkSet(eComponentObject))
    Iterator.AddFilter_LayerSet(AllLayers)
    Iterator.AddFilter_Method(eProcessAll)

	' Get first component
    Set component = Iterator.FirstPCBObject
    
	' Start of undo block
	PCBServer.PreProcess

    While Not (component Is Nothing)

		' Tell Altium that we are starting modifications
        Call PCBServer.SendMessageToRobots(component.Name.I_ObjectAddress, c_Broadcast, PCBM_BeginModify, c_NoEventData)

        If component.Layer = eTopLayer Then
            Select Case component.Name.Rotation
	            Case 180, 360
	                 component.Name.Rotation  = 0
	            Case 270
	                component.Name.Rotation  = 90
            End Select
        Else
            Select Case component.Name.Rotation
	            Case 180, 360
	                 component.Name.Rotation  = 0
	            Case 90
	                 component.Name.Rotation  = 270
            End Select
        End If

		' Tell Altium that we have finished the modifications
        Call PCBServer.SendMessageToRobots(component.Name.I_ObjectAddress, c_Broadcast, PCBM_EndModify , c_NoEventData)

		' Get next component
        Set component = Iterator.NextPCBObject
    Wend

    board.BoardIterator_Destroy(Iterator)

	' End of undo block
    Pcbserver.PostProcess
	
	' Finishing commands
    Call AddStringParameter("Action", "Redraw")
    RunProcess("PCB:Zoom")

    StdOut("Designator rotation finished.")

End Sub
