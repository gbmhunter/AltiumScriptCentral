'
' @file               Util.vbs
' @author             Geoffrey Hunter <gbmhunter@gmail.com> (www.mbedded.ninja)
' @created            2014-11-11
' @last-modified      2016-05-09
' @brief              General utility functions used across many of the modules.
' @details
'                     See README.rst in repo root dir for more info.

' Forces us to explicitly define all variables before using them
Option Explicit

Dim pi
pi = 4 * Atn(1)

' @brief   Function tests whether the input argument is an integer.
 ' @returns True if VarToTest is an integer, otherwise False.
 Function IsInt(VarToTest)
      If IsNumeric(VarToTest) Then
           ' Here, it still could be an integer or a floating point number
           ' The conversion to string is important
           If CStr(CLng(VarToTest)) = VarToTest Then
                ' Number is an integer
                IsInt = True
                Exit Function
           Else
               ' Number is not an integer
               IsInt = False
               Exit Function
           End If
      Else
           ' Number is not an integer
           IsInt = False
           Exit Function
      End If
End Function

' @brief    Function tests whether the input argument is "perfectly" numeric.
' @details  This is a stricter test than the built-in IsNumeric. This test will return false
'           for strings such as "2-", while IsNumeric will return true. UPDATE 2016-05-09: This
'           is not really true anymore, as bug was found with current implementation.
Function IsPerfectlyNumeric(VarToTest)


    ' First make sure variable is not an empty string
     If VarToTest = "" Then
          IsPerfectlyNumeric = False
          Exit Function
     End If

     ' Is numeric will return true if a valid number is at the
    ' start of the string, but doesn't detect invalid characters
    ' after the number (e.g. IsNumeric("2-") would return true).
    VarToTest = LocalizeNumberStr(VarToTest)

     If Not IsNumeric(VarToTest) Then
          IsPerfectlyNumeric = False
          Exit Function
     End If

    ' This makes sure that things like "2-" still get detected.
    ' Convert variable to double, then back to string. If it's equal
    ' to the original variable, then it is a valid number.
    ' UPDATE 2016-05-09: This code below caused valid numbers like "1.0"
    ' to fail, presumably because "1.0" was rounded to "1"
    'If CStr(CDbl(VarToTest)) = VarToTest Then
    '     IsPerfectlyNumeric = True
    '     Exit Function
   ' Else
    '     IsPerfectlyNumeric = False
    '     Exit Function
    'End If

    IsPerfectlyNumeric = True

End Function

' @brief    Determines whether a layer is an internal or external layer.
' @returns  True if layer is an internal layer, otherwise False (external layer).
Function IsInternalLayer(LayerId)
     If Not LayerId = 1 Then
        If Not LayerId = 32 Then
             IsInternalLayer = True
        Else
             IsInternalLayer = False
        End If
     Else
          IsInternalLayer = False
     End If
End Function

Function LPad(strInput, length, character)
  LPad = Right(String(length, character) & strInput, length)
End Function

Function RPad(strInput, length, character)
  RPad = Left(strInput & String(length, character), length)
End Function

' @brief    Returns input number rounded to specified number of significant figures.
' @param    dblInput   The input number.
' @param    intSF      The number of significant figures you want the number rounded to.
' @returns  The rounded number.
Function SfFormat(dblInput, intSF)

    Dim intCorrPower         'Exponent used in rounding calculation
    Dim intSign              'Holds sign of dblInput since logs are used in calculations

    ' Catch edge-case when input number is 0
    If dblInput = 0 Then
        SfFormat = 0
        Exit Function
    End If

    ' Store sign of dblInput
    intSign = Sgn(dblInput)

    ' Calculate exponent of dblInput
    intCorrPower = Int(Log10(Abs(dblInput)))

    SfFormat = Round(dblInput * 10 ^ ((intSF - 1) - intCorrPower))   'integer value with no sig fig
    SfFormat = SfFormat * 10 ^ (intCorrPower - (intSF - 1))         'raise to original power


    ' Reconsitute final answer
    SfFormat = SfFormat * intSign

    ' Answer sometimes needs padding with one or more 0's
    If InStr(SfFormat, ".") = 0 Then
        If Len(SfFormat) < intSF Then
            SfFormat = Format(SfFormat, "##0." & String(intSF - Len(SfFormat), "0"))
        End If
    End If

    If intSF > 1 And Abs(SfFormat) < 1 Then
        Do Until Left(Right(SfFormat, intSF), 1) <> "0" And Left(Right(SfFormat, intSF), 1) <> "."
            SfFormat = SfFormat & "0"
        Loop
    End If

End Function

' @brief    Returns the user's home folder.
' @details  Used by the UserData.vbs module.
' @returns  The user's home folder as a absolute path string.
Function GetUsersHomeFolder(dummyVar)

    ' Get the user's home folder
    Dim oShell
    Set oShell = CreateObject("WScript.Shell")
    Dim homeFolder
    homeFolder = oShell.ExpandEnvironmentStrings("%USERPROFILE%")

    ' Return the user's home folder as a string
    GetUsersHomeFolder = homeFolder
End Function

' @brief    Gets the height of either a via or hole object.
' @details  Correctly calculates the actual height of any via or hole (even blind or buried) by using it's start and stop layers
'               and iterating through the layer stack, adding up the thicknesses of everything in between.
' @note     Will return a height slightly less that the total height of the PCB for vias that go from the top
'               layer to the bottom layer, as it does not include the soldermask of silkscreen thickness.
Function GetViaOrHoleHeightMm(board, viaOrHole)


    Dim layerIterator
    layerIterator = board.ElectricalLayerIterator

    Dim startLayerFound, stopLayerFound
    Dim heightSumTCoord
    heightSumTCoord = 0

    Do While layerIterator.Next
        'ShowMessage("Layer name = '" + layerIterator.LayerObject.Name + "', layerID = '" + CStr(layerIterator.LayerObject.LayerID) + "', copper height = '" + CStr(layerIterator.LayerObject.CopperThickness) + "', di-electric Height = '" + CStr(CoordToMMs(layerIterator.LayerObject.Dielectric.DielectricHeight)) + "'.")

        'ShowMessage("Via/hole.ObjectID = " +  CStr(viaOrHole.ObjectID) + "'.")
        If viaOrHole.ObjectID = eViaObject Then
            If viaOrHole.StartLayer.LayerID = layerIterator.LayerObject.LayerID Then
                'ShowMessage("Via/hole start layer = '" + layerIterator.LayerObject.Name + "'.")
                startLayerFound = true
            End If
        ElseIf viaOrHole.ObjectID = ePadObject Then
            startLayerFound = true
        End If

        If viaOrHole.ObjectID = eViaObject Then
            If viaOrHole.StopLayer.LayerID = layerIterator.LayerObject.LayerID Then
                'ShowMessage("Via/hole stop layer = '" + layerIterator.LayerObject.Name + "'.")
                stopLayerFound = true
            End If
        End If

        If startLayerFound = true And stopLayerFound = false Then
            ' We are on OR past the layer that the via starts on, AND we are not on the layer that the via stops on.
            heightSumTCoord = heightSumTCoord + layerIterator.LayerObject.CopperThickness + layerIterator.LayerObject.Dielectric.DielectricHeight
        End If

        If stopLayerFound = true Then
            ' We are on the layer that the via stops at!
            heightSumTCoord = heightSumTCoord + layerIterator.LayerObject.CopperThickness
            GetViaOrHoleHeightMm = CoordToMMs(heightSumTCoord)
            'ShowMessage("Via/hole height = '" + CStr(CoordToMMs(heightSumTCoord)) + "mm'.")
            Exit Function
        End If

    Loop

    ' We will only get here if it is a pad!
    GetViaOrHoleHeightMm = CoordToMMs(heightSumTCoord)

End Function


' @brief    Localizes fractional separator in strings, which contains numbers
'
Function LocalizeNumberStr(str)

    ' check locale
    if( CStr(0.1) = "0,1" ) then
        LocalizeNumberStr = Replace(str,".",",")
    else
        LocalizeNumberStr = Replace(str,",",".")
    end if

End Function
