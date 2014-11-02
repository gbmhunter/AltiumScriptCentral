
Function DisplayPcbStats(dummyVar)

    StdOut("Displaying PCB stats...")

    Set board = PCBServer.GetCurrentPCBBoard
    If board Is Nothing Then
        ShowMessage("Could not load current PCB board")
        Exit Function
    End If

    ' Count the number of holes on PCB
    LabelNumOfVias.Caption = CountVias(board)
    LabelNumOfPadsWithHoles.Caption = CountNumPadsWithHoles(board)
    LabelTotalNumOfHoles.Caption = CInt(LabelNumOfVias.Caption) + CInt(LabelNumOfPadsWithHoles.Caption)

    ' Show the form, in non-modal fashion
    FormStats.Show

    StdOut("Finished displaying PCB stats.")

End Function

Function CountVias(board)
    Dim count                ' As Integer

    Set iterator = board.BoardIterator_Create
    iterator.AddFilter_ObjectSet(MkSet(eViaObject))
    iterator.AddFilter_LayerSet(AllLayers)
    iterator.AddFilter_Method(eProcessAll)

    Set compDes = iterator.FirstPCBObject

    count = 0

    ' Iterate through all objects
    Do While Not (CompDes Is Nothing)
        count = count + 1

        Set CompDes = Iterator.NextPCBObject
    Loop

    board.BoardIterator_Destroy(Iterator)

    'LabelNumOfVias.Caption = count
    CountVias = count

End Function

Function CountNumPadsWithHoles(board)

    Set iterator = board.BoardIterator_Create
    iterator.AddFilter_ObjectSet(MkSet(ePadObject))
    iterator.AddFilter_LayerSet(AllLayers)
    iterator.AddFilter_Method(eProcessAll)

    Set compDes = iterator.FirstPCBObject

    count = 0

    ' Iterate through all pads
    Do While Not (CompDes Is Nothing)
       ' Note that unlike vias, not all pads will have holes in them, we have to find this out now...
       If compDes.HoleSize > 0 Then
          ' We have found a pad with a hole in it!
          count = count + 1
       End If

       Set CompDes = Iterator.NextPCBObject
    Loop

    board.BoardIterator_Destroy(Iterator)

    CountNumPadsWithHoles = count

End Function


