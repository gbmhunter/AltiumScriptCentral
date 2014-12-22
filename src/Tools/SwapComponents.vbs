'
' @file               SwapComponents.vbs
' @author             Geoffrey Hunter <gbmhunter@gmail.com> (www.mbedded.ninja)
' @created            2014-12-08
' @last-modified      2014-12-22
' @brief              Script allows user to quickly switch two components on a PCB.
' @details
'                     See README.rst in repo root dir for more info.

' Forces us to explicitly define all variables before using them
Option Explicit

Private ModuleName
ModuleName = "SwapComponents.vbs"

' @brief    Allows the user to quickly switch two components on a PCB.
' @param     DummyVar     Dummy variable to stop function appearing in the Altium "Run Script" dialogue. 
Sub SwapComponents(DummyVar)

     Set Board = PCBServer.GetCurrentPCBBoard
     If Board is Nothing Then
        ShowMessage("ERROR: PCB board could not be found. Please make sure a PCB file has current focus.")
        Exit Sub
     End If

     Pcbserver.PreProcess

     Dim x
     Dim y

     ' Get first component to swap (loop allows user to do many swaps in sequential order)
     While Board.ChooseLocation(x,y, "Select first component to swap") = True

          Dim CompA
          Set CompA = Board.GetObjectAtXYAskUserIfAmbiguous(_
                x,_
                y,_
                MkSet(eComponentObject),_
                AllLayers,_
                eEditAction_Select)

           ' If no component was selected then exit
          If CompA Is Nothing Then
             Pcbserver.PostProcess
             ShowMessage("ERROR: No component was selected.")
             Exit Sub
          End If

          ' Get second component to swap
          Call Board.ChooseLocation(x,y, "Select second component to swap.")

          Dim CompB
          Set CompB = Board.GetObjectAtXYAskUserIfAmbiguous(_
              x,_
              y,_
              MkSet(eComponentObject),_
              AllLayers,_
              eEditAction_Select)

          ' If no component was selected then exit
          If CompB Is Nothing Then
             Pcbserver.PostProcess
             ShowMessage("ERROR: No component was selected.")
             Exit Sub
          End If

          ' Now lets perform the actual swapping of the components

          ' Create temp vars to hold values of first component
          Dim CompX, CompY, CompR, DesX, DesY, DesR

          CompX = CompA.X
          CompY = CompA.Y
          CompR = CompA.Rotation
          DesX  = CompA.Name.XLocation
          DesY  = CompA.Name.YLocation
          DesR  = CompA.Name.Rotation

          Call PCBServer.SendMessageToRobots(_
               CompA.I_ObjectAddress,_
               c_Broadcast,_
               PCBM_BeginModify,_
               c_NoEventData)
           CompA.X = CompB.X
           CompA.Y = CompB.Y
           CompA.Rotation = CompB.Rotation
           CompA.ChangeNameAutoposition = eAutoPos_Manual
           Call PCBServer.SendMessageToRobots(_
                CompA.I_ObjectAddress,_
                c_Broadcast,_
                PCBM_EndModify,_
                c_NoEventData)

           Call PCBServer.SendMessageToRobots(_
                CompA.Name.I_ObjectAddress,_
                c_Broadcast,_
                PCBM_BeginModify,_
                c_NoEventData)
           CompA.Name.XLocation = CompB.Name.XLocation
           CompA.Name.YLocation = CompB.Name.YLocation
           CompA.Name.Rotation = CompB.Name.Rotation
           Call PCBServer.SendMessageToRobots(_
                CompA.Name.I_ObjectAddress,_
                c_Broadcast,_
                PCBM_EndModify,_
                c_NoEventData)

           Call PCBServer.SendMessageToRobots(_
                CompB.I_ObjectAddress,_
                c_Broadcast,_
                PCBM_BeginModify,_
                c_NoEventData)
           CompB.X = CompX
           CompB.Y = CompY
           CompB.Rotation = CompR
           CompB.ChangeNameAutoposition = eAutoPos_Manual
           Call PCBServer.SendMessageToRobots(_
                CompB.I_ObjectAddress,_
                c_Broadcast,_
                PCBM_EndModify,_
                c_NoEventData)

           Call PCBServer.SendMessageToRobots(_
                CompB.Name.I_ObjectAddress,_
                c_Broadcast,_
                PCBM_BeginModify,_
                c_NoEventData)
           CompB.Name.XLocation = DesX
           CompB.Name.YLocation = DesY
           CompB.Name.Rotation = DesR
           Call PCBServer.SendMessageToRobots(_
                CompB.Name.I_ObjectAddress,_
                c_Broadcast,_
                PCBM_EndModify,_
                c_NoEventData)

        Wend

     Pcbserver.PostProcess
     ResetParameters
     Call AddStringParameter("Action", "Redraw")
     RunProcess("PCB:Zoom")

End Sub
