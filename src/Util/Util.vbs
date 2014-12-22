'
' @file               Util.vbs
' @author             Geoffrey Hunter <gbmhunter@gmail.com> (www.mbedded.ninja)
' @created            2014-11-11
' @last-modified      2014-12-22
' @brief              
' @details
'                     See README.rst in repo root dir for more info.

' Forces us to explicitly define all variables before using them
Option Explicit

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
Function SfFormat(dblInput, intSF)

    Dim intCorrPower         'Exponent used in rounding calculation
    Dim intSign              'Holds sign of dblInput since logs are used in calculations

    '-- Store sign of dblInput --
    intSign = Sgn(dblInput)

    '-- Calculate exponent of dblInput --
    intCorrPower = Int(Log10(Abs(dblInput)))

    SfFormat = Round(dblInput * 10 ^ ((intSF - 1) - intCorrPower))   'integer value with no sig fig
    SfFormat = SfFormat * 10 ^ (intCorrPower - (intSF - 1))         'raise to original power


    '-- Reconsitute final answer --
    SfFormat = SfFormat * intSign

    '-- Answer sometimes needs padding with 0s --
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
