Class Structure Extends LineCode
  Name.s
  *Attribut.Array = New Array()
  Extend.s
  
  
  Procedure GetField(Field.s)
    Protected n, *Attribut.Precompiler::Attribut
    For n = 1 To *this\Attribut.CountElement()
      *Attribut = *this\Attribut.GetElement(n)
      If LCase(*Attribut\Name) = LCase(Field)
        ProcedureReturn *Attribut
      EndIf
    Next n
    ProcedureReturn #Null
  EndProcedure
  
  Procedure Free()
    FreeMemory(*this)
  EndProcedure
EndClass

  Procedure LoadStructure(n)
    Protected *StructureP.PreCompiler::Structure = New PreCompiler::Structure()
    Protected *Line.LineCode = *this\LocalText.GetElement(n)
    *StructureP\name = StringField(*Line\Text, 2, " ")
    If *this\Compiler.GetStructure(*StructureP\Name)
      *System.CodeError(*Line\File, *Line\Line, "Structure already exist")
      ProcedureReturn #False
    EndIf
    *this\Structure.AddElement(*StructureP)
    *StructureP\Extend = StringField(*Line\Text, 4, " ")
    *StructureP\File = *Line\File
    *StructureP\Line = *Line\Line
    ProcedureReturn *this.LoadStructureAttribut(n, *StructureP)
  EndProcedure

  Procedure LoadStructureAttribut(n, *StructureP.Precompiler::Structure)
    Protected *Line.LineCode
    Protected *Attribut.Precompiler::StructureAttribut
    For n = n + 1 To *this\LocalText.CountElement()
      *Line = *this\LocalText.GetElement(n)
      Select LineIs(*Line\Text)
        Case #EndStructure
          ProcedureReturn n
        Default
          *Attribut = New Precompiler::StructureAttribut(*Line\Text)
          Select LCase(*Attribut\Type)
            Case "i", "l", "s", "c", "b", "w", "q", "d", "f"
            Default
              If Not *this\Compiler.GetStructure(*Attribut\Type)
                If Not *this.GetStructure(*Attribut\Type)
                *System.CodeError(*Line\File, *Line\Line, "Type not found " + *Attribut\Type)
                ProcedureReturn #False
              EndIf
            EndIf
          EndSelect
          *Attribut\Line = *Line\Line 
          *Attribut\File = *Line\File
          *StructureP\Attribut.AddElement(*Attribut)
      EndSelect
    Next n
    ProcedureReturn n
  EndProcedure

; IDE Options = PureBasic 4.30 (Windows - x86)
; CursorPosition = 46
; FirstLine = 10
; Folding = -
; EnableXP