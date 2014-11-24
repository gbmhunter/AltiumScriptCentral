'
' @file               Util.vbs
' @author             Geoffrey Hunter <gbmhunter@gmail.com> (www.mbedded.ninja)
' @created            2014-11-11
' @last-modified      2014-11-24
' @brief              
' @details
'                     See README.rst in repo root dir for more info.

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

Function Pad(ByRef Text, ByVal Length)
     Pad = Left(Text & Space(Length), Length)
End Function
