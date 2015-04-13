'
' @file               Stats.vbs
' @author             Geoffrey Hunter <gbmhunter@gmail.com> (www.mbedded.ninja)
' @created            2014-11-03
' @last-modified      2015-04-14
' @brief              Code for showing PCB statistics.
' @details
'                     See README.rst in repo root dir for more info.

' Forces us to explicitly define all variables before using them
Option Explicit

Sub GetStats(DummyVar)
     'StdOut("Displaying PCB stats...")

    ' Get the current PCB board, which we will pass to all
    ' the child functions
    Dim Board
    Set Board = PCBServer.GetCurrentPCBBoard
    If Board Is Nothing Then
        ShowMessage("Could not find a PCB board, please make sure PCB file you want to use it currently open.")
        Exit Sub
    End If

    '===== GET VIA STATS ====='
    Dim viaStatsA
    viaStatsA = CountVias(board)
    LabelNumNormalVias.Caption = viaStatsA(NUM_NORMAL_VIAS)
    LabelNumBlindVias.Caption = viaStatsA(NUM_BLIND_VIAS)
    LabelNumBuriedVias.Caption = viaStatsA(NUM_BURIED_VIAS)
    LabelTotalNumOfVias.Caption = viaStatsA(TOTAL_NUM_VIAS)

    '========= GET HOLE STATS ========='

    ' Circular holes
    LabelNumOfPadsWithCircularPlatedHoles.Caption = CountNumPadsWithCircularPlatedHoles(board)
    LabelNumOfPadsWithCircularUnplatedHoles.Caption = CountNumPadsWithCircularUnplatedHoles(board)
    LabelTotalNumOfCircularHoles.Caption = CInt(LabelNumOfPadsWithCircularPlatedHoles.Caption) + CInt(LabelNumOfPadsWithCircularUnplatedHoles.Caption)

    ' Slotted holes
    LabelNumOfPadsWithSlottedPlatedHoles.Caption = CountNumPadsWithSlottedPlatedHoles(board)
    LabelNumOfPadsWithSlottedUnplatedHoles.Caption = CountNumPadsWithSlottedUnplatedHoles(board)
    LabelTotalNumOfSlottedHoles.Caption = CInt(LabelNumOfPadsWithSlottedPlatedHoles.Caption) + CInt(LabelNumOfPadsWithSlottedUnplatedHoles.Caption)

    ' TOTAL HOLES
    LabelTotalNumOfHoles.Caption = CInt(LabelTotalNumOfVias.Caption) + CInt(LabelTotalNumOfCircularHoles.Caption) + CInt(LabelTotalNumOfSlottedHoles.Caption)

    ' Get the smallest, largest and number of different hole sizes
    Dim HoleStatA
    HoleStatA = GetHoleStats(Board)
    LabelSmallestHoleSizeMm.Caption = HoleStatA(0)
    LabelLargestHoleSizeMm.Caption = HoleStatA(1)
    LabelNumDiffHoleSizes.Caption = HoleStatA(2)

    ' Minimum widths
    LabelMinAnnularRingMm.Caption = CStr(FindMinAnnularRingMm(Board))
    LabelMinTrackWidthMm.Caption = CStr(FindMinTrackWidthMm(Board))

    ' Number copper layers on PCB
    LabelNumCopperLayers.Caption = CountNumCopperLayers(Board)

    ' Get board height and width
    Dim Dimensions
    Dimensions = GetPcbBoundingRectangleDimensions(Board)
    LabelBoardWidthMm.Caption = Dimensions(0)
    LabelBoardHeightMm.Caption = Dimensions(1)
    LabelBoardAreaMm.Caption = Dimensions(2)

    ' Now that everything has been calculated, show the form, in non-modal fashion
    'FormStats.Show

    'StdOut("Finished displaying PCB stats." + VbCr + VbLf)
End Sub

Const NUM_NORMAL_VIAS = 0
Const NUM_BLIND_VIAS = 1
Const NUM_BURIED_VIAS = 2
Const TOTAL_NUM_VIAS = 3

Function CountVias(Board)
    'Dim Count                ' As Integer

    ' (0): num. of normal vias
    ' (1): num. of blind vias
    ' (2): num. of buried vias
    ' (3): total num. of vias
    Dim viaStatA(4)

    Dim iterator
    Set iterator = board.BoardIterator_Create
    iterator.AddFilter_ObjectSet(MkSet(eViaObject))
    iterator.AddFilter_LayerSet(AllLayers)
    iterator.AddFilter_Method(eProcessAll)

    Dim via
    Set via = Iterator.FirstPCBObject

    viaStatA(NUM_NORMAL_VIAS) = 0
    viaStatA(NUM_BLIND_VIAS) = 0
    viaStatA(NUM_BURIED_VIAS) = 0
    viaStatA(TOTAL_NUM_VIAS) = 0

    ' Iterate through all objects
    Do While Not (via Is Nothing)
        'Count = Count + 1
        'If viaStatA(TOTAL_NUM_VIAS) = 0 Then
        '   ShowMessage("via.HighLayer = '" + Layer2String(via.HighLayer) + "', via.LowLayer = '" + Layer2String(via.LowLayer) + "'.")
        'End If

        If (via.HighLayer = eTopLayer And via.LowLayer = eBottomLayer) Or (via.HighLayer = eBottomLayer And via.LowLayer = eTopLayer) Then
           ' Must be a normal via
           viaStatA(NUM_NORMAL_VIAS) = viaStatA(NUM_NORMAL_VIAS) + 1
        ElseIf via.HighLayer = eTopLayer Or via.HighLayer = eBottomLayer Or via.LowLayer = eTopLayer Or via.LowLayer = eBottomLayer Then
           ' If not a normal via but one of the end-points is still on the top or bottom layers,
           ' then must be a blind via
           viaStatA(NUM_BLIND_VIAS) = viaStatA(NUM_BLIND_VIAS) + 1
        Else
           ' If not a normal or buried via, Must be a buried via
           viaStatA(NUM_BURIED_VIAS) = viaStatA(NUM_BURIED_VIAS) + 1
        End If

        ' Increment total count no matter what type of via it is
        viaStatA(TOTAL_NUM_VIAS) = viaStatA(TOTAL_NUM_VIAS) + 1

        Set via = Iterator.NextPCBObject
    Loop

    board.BoardIterator_Destroy(iterator)

    ' Return via stats array
    CountVias = viaStatA

End Function

Function CountNumPadsWithCircularPlatedHoles(Board)

     Dim Iterator
     Set Iterator = Board.BoardIterator_Create
     Iterator.AddFilter_ObjectSet(MkSet(ePadObject))
     Iterator.AddFilter_LayerSet(AllLayers)
     Iterator.AddFilter_Method(eProcessAll)

     Dim PadObj
     Set PadObj = Iterator.FirstPCBObject

     Dim Count
     Count = 0

    ' Iterate through all pads
    Do While Not (PadObj Is Nothing)
       ' Note that unlike vias, not all pads will have holes in them, we have to find this out now...
       If PadObj.HoleSize > 0 And PadObj.Plated = True And PadObj.HoleType = eRoundHole Then
          ' We have found a pad with a circular plated hole in it!
          Count = Count + 1
       End If

       Set PadObj = Iterator.NextPCBObject
    Loop

    Board.BoardIterator_Destroy(Iterator)

    CountNumPadsWithCircularPlatedHoles = Count

End Function

Function CountNumPadsWithCircularUnplatedHoles(Board)

     Dim Iterator
     Set Iterator = Board.BoardIterator_Create
     Iterator.AddFilter_ObjectSet(MkSet(ePadObject))
     Iterator.AddFilter_LayerSet(AllLayers)
     Iterator.AddFilter_Method(eProcessAll)

     Dim PadObj
     Set PadObj = Iterator.FirstPCBObject

     Dim Count
     Count = 0

     ' Iterate through all pads
     Do While Not (PadObj Is Nothing)
          ' Note that unlike vias, not all pads will have holes in them, we have to find this out now...
          If PadObj.HoleSize > 0 And PadObj.Plated = False And PadObj.HoleType = eRoundHole Then
               ' We have found a pad with a circular unplated hole in it!
               Count = Count + 1
          End If

          Set PadObj = Iterator.NextPCBObject
     Loop

     Board.BoardIterator_Destroy(Iterator)

     CountNumPadsWithCircularUnplatedHoles = Count

End Function

Function CountNumPadsWithSlottedPlatedHoles(board)

     Dim iterator
     Set iterator = board.BoardIterator_Create
     iterator.AddFilter_ObjectSet(MkSet(ePadObject))
     iterator.AddFilter_LayerSet(AllLayers)
     iterator.AddFilter_Method(eProcessAll)

     Dim padObj
     Set padObj = Iterator.FirstPCBObject

     Dim count
     count = 0

    ' Iterate through all pads
    Do While Not (padObj Is Nothing)
       ' Note that unlike vias, not all pads will have holes in them, we have to find this out now...
       If padObj.HoleSize > 0 And padObj.Plated = True And padObj.HoleType = eSlotHole Then
          ' We have found a pad with a circular plated hole in it!
          count = count + 1
       End If

       Set padObj = iterator.NextPCBObject
    Loop

    board.BoardIterator_Destroy(iterator)

    CountNumPadsWithSlottedPlatedHoles = count

End Function

Function CountNumPadsWithSlottedUnplatedHoles(board)

     Dim iterator
     Set iterator = board.BoardIterator_Create
     iterator.AddFilter_ObjectSet(MkSet(ePadObject))
     iterator.AddFilter_LayerSet(AllLayers)
     iterator.AddFilter_Method(eProcessAll)

     Dim padObj
     Set padObj = iterator.FirstPCBObject

     Dim count
     count = 0

     ' Iterate through all pads
     Do While Not (padObj Is Nothing)
          ' Note that unlike vias, not all pads will have holes in them, we have to find this out now...
          If padObj.HoleSize > 0 And padObj.Plated = False And padObj.HoleType = eSlotHole Then
               ' We have found a pad with a slotted unplated hole in it!
               count = count + 1
          End If

          Set padObj = iterator.NextPCBObject
     Loop

     board.BoardIterator_Destroy(iterator)

     CountNumPadsWithSlottedUnplatedHoles = count

End Function

Function FindMinAnnularRingMm(Board)

     Dim MinAnnularRingMm
     MinAnnularRingMm = 0

     Dim FirstTime
     FirstTime = True

     '===== CHECK VIAS ====='

     Dim Iterator
     Set Iterator = Board.BoardIterator_Create
     Iterator.AddFilter_ObjectSet(MkSet(eViaObject))
     Iterator.AddFilter_LayerSet(AllLayers)
     Iterator.AddFilter_Method(eProcessAll)

     Dim Via
     Set Via = Iterator.FirstPCBObject

     Dim AnnularRingMm

     ' Iterate through all objects
     Do While Not (Via Is Nothing)
          AnnularRingMm =  CoordToMMs((Via.Size - Via.HoleSize)/2)

          If FirstTime = True Then
               ' First time through we don't care if it's higher/lower
               ' than anything else
               MinAnnularRingMm = AnnularRingMm
               FirstTime = False
          Else
               If AnnularRingMm < MinAnnularRingMm Then
                    MinAnnularRingMm = AnnularRingMm
               End If
          End If

          Set Via = Iterator.NextPCBObject
    Loop

    Board.BoardIterator_Destroy(Iterator)

    '===== CHECK PADS ====='

    Set Iterator = Board.BoardIterator_Create
    Iterator.AddFilter_ObjectSet(MkSet(ePadObject))
    Iterator.AddFilter_LayerSet(AllLayers)
    Iterator.AddFilter_Method(eProcessAll)

    Dim Pad
    Set Pad = Iterator.FirstPCBObject

    ' Iterate through all pads
    Do While Not (Pad Is Nothing)
         ' Check annular ring in X direction
         Dim AnnularRingXMm
         AnnularRingXMm = CoordToMMs((Pad.X - Pad.HoleSize)/2)

         If AnnularRingXMm < MinAnnularRingMm Then
              MinAnnularRingMm = AnnularRingXMm
         End If

         ' Check annular ring in Y direction
         Dim AnnularRingYMm
         AnnularRingYMm =  CoordToMMs((Pad.Y - Pad.HoleSize)/2)

         If AnnularRingYMm < MinAnnularRingMm Then
              MinAnnularRingMm = AnnularRingYMm
         End If

         Set Pad = Iterator.NextPCBObject
    Loop

    Board.BoardIterator_Destroy(Iterator)

    FindMinAnnularRingMm = MinAnnularRingMm

End Function

Function FindMinTrackWidthMm(Board)

     Dim Iterator
     Set Iterator = Board.BoardIterator_Create
     iterator.AddFilter_ObjectSet(MkSet(eTrackObject))
     ' We only want to check copper layers for tracks
     Iterator.AddFilter_LayerSet(MkSet(eTopLayer, eMidLayer1, eMidLayer2, eMidLayer3, eMidLayer4, eMidLayer5, eMidLayer6, eMidLayer7, eMidLayer8, eMidLayer9, eMidLayer10, eMidLayer11, eMidLayer12, eMidLayer13, eMidLayer14, eMidLayer15, eMidLayer16, eMidLayer17, eMidLayer18, eMidLayer19, eMidLayer20, eMidLayer21, eMidLayer22, eMidLayer23, eMidLayer24, eMidLayer25, eMidLayer26, eMidLayer27, eMidLayer28, eMidLayer29, eMidLayer30, eBottomLayer))
     Iterator.AddFilter_Method(eProcessAll)

     Dim Track
     Set Track = Iterator.FirstPCBObject

     Dim MinTrackWidthMm
     MinTrackWidthMm = 0

     Dim FirstTime
     FirstTime = True

     ' Iterate through all objects
     Do While Not (track Is Nothing)
          Dim TrackWidthMm
          TrackWidthMm = CoordToMMs(Track.Width)

          'StdOut("Track width (mm) = " + CStr(trackWidthMm) + VbCr + VbLf)

          If FirstTime = True Then
               ' First time through we don't care if it's higher/lower
               ' than anything else
               MinTrackWidthMm = TrackWidthMm
               FirstTime = False
          Else
               If TrackWidthMm < MinTrackWidthMm Then
                    MinTrackWidthMm = TrackWidthMm
               End If
          End If

          Set Track = Iterator.NextPCBObject
    Loop

    Board.BoardIterator_Destroy(Iterator)

    FindMinTrackWidthMm = MinTrackWidthMm

End Function


Function CountNumCopperLayers(Board)

     Dim LayerClass
     LayerClass = eLayerClass_Electrical

     Dim LayerStack
     LayerStack = Board.LayerStack

     If LayerStack Is Nothing Then
          ShowMessage("ERROR: Could not get layer stack info for current PCB.")
          Exit Function
     End If

     ' Get first layer of the class type.
     Dim LayerObj
     LayerObj = LayerStack.First(LayerClass)

     ' Exit if layer type is not available in stack
     If LayerObj Is Nothing Then
          ShowMessage("ERROR: Could not get a layer object from the layer stack.")
          Exit Function
     End If

     Dim NumCopperLayers
     NumCopperLayers = 1

     ' Iterate through layers and display each layer name
     Do
          'ShowMessage(layerObj.Name)
          LayerObj = LayerStack.Next(LayerClass, LayerObj)
          NumCopperLayers = NumCopperLayers + 1

        ' For some reason we cannot compare the layer objects directly,
        ' so as a workaround I will compare the names. This will be buggy
        ' if there are two layers with the same name (and one of them is the
        ' last layer)
     Loop Until LayerObj.Name = LayerStack.Last(LayerClass).Name

  CountNumCopperLayers = NumCopperLayers

End Function

Function GetPcbBoundingRectangleDimensions(Board)

   Dim Dimensions(3)

   Dim BoundingRectangle
   BoundingRectangle = Board.BoardOutline.BoundingRectangle

   'StdOut("br.Width = " + CStr(CoordToMMs(board.BoardOutline.BoundingRectangle.Right - board.BoardOutline.BoundingRectangle.Left)) + VbCr + VbLf)
   'StdOut("br.Bottom = " + CStr(CoordToMMs(board.BoardOutline.BoundingRectangle.Top - board.BoardOutline.BoundingRectangle.Bottom)) + VbCr + VbLf)

   Dimensions(0) = CoordToMMs(Board.BoardOutline.BoundingRectangle.Right - Board.BoardOutline.BoundingRectangle.Left)
   Dimensions(1) = CoordToMMs(Board.BoardOutline.BoundingRectangle.Top - Board.BoardOutline.BoundingRectangle.Bottom)
   Dimensions(2) = CStr(Round(Dimensions(0)*Dimensions(1), 0))

   GetPcbBoundingRectangleDimensions = Dimensions

End Function

Function GetHoleStats(Board)

     ' Create a hole statistics array for returning to the calling function
     Dim HoleStatA(3)

     ' Create an ArrayList to store the unique hole sizes present on the PCB
     Dim HoleSizeList
     Set HoleSizeList = CreateObject("System.Collections.ArrayList")

     ' Create an iterator to iterate over all vias and pads on the PCBs
     Dim Iterator
     Set Iterator = Board.BoardIterator_Create
     Iterator.AddFilter_ObjectSet(MkSet(eViaObject, ePadObject))
     Iterator.AddFilter_LayerSet(AllLayers)
     Iterator.AddFilter_Method(eProcessAll)

     Dim ViaOrPad
     Set ViaOrPad = iterator.FirstPCBObject

     Dim SmallestHoleSizeMm
     Dim LargestHoleSizeMm

     Dim FirstTime
     FirstTime = True

     ' Iterate through all via/pad objects
     Do While Not (ViaOrPad Is Nothing)

          ' Cheack that hole size is not 0 (i.e. no hole)
          If Not (ViaOrPad.HoleSize = 0) Then

               If (FirstTime = True) Or (CoordToMMs(ViaOrPad.HoleSize) < SmallestHoleSizeMm) Then
                    SmallestHoleSizeMm = CoordToMMs(ViaOrPad.HoleSize)
               End If

               If (FirstTime = True) Or (CoordToMMs(ViaOrPad.HoleSize) > LargestHoleSizeMm) Then
                    LargestHoleSizeMm = CoordToMMs(ViaOrPad.HoleSize)
               End If

               ' Set first time to false, doesn't matter if this gets getting set
               FirstTime = False

               ' Check that hole is not already in list
               If (HoleSizeList.Contains(ViaOrPad.HoleSize) = False) Then
                    ' Hole size was not found in the list, and was greater than 0mm, so lets
                    ' add it to our list of unique hole sizes
                    holeSizeList.Add ViaOrPad.HoleSize
               End If

          End If

          Set ViaOrPad = Iterator.NextPCBObject
     Loop

     Board.BoardIterator_Destroy(Iterator)

     HoleStatA(0) = SmallestHoleSizeMm
     HoleStatA(1) = LargestHoleSizeMm
     HoleStatA(2) = HoleSizeList.Count

     GetHoleStats = HoleStatA

End Function
