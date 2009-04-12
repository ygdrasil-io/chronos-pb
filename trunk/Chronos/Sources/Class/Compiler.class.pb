Procedure NewFunction(fct.s)
   Protected *this.Function = AllocateMemory(SizeOf(Function))
   *this\ListAtribut = CreateArray()
   *this\Name = Trim(StringField(fct, 1, "("))
   GlobalKeyWord + " " + *this\Name + "("
   *this\desc = Trim(StringField(fct, 2, ")"))
   fct = Trim(StringField(fct, 2, "("))
   fct = Trim(StringField(fct, 1, ")"))
   *this\Atribut = fct 
   ProcedureReturn *this
EndProcedure 

Procedure NewStructure(Name.s)
   Protected *this.Struct = AllocateMemory(SizeOf(Struct))
   *this\name = Name
   *this\atribut = CreateArray()
   ProcedureReturn *this
EndProcedure

Procedure NewAtribut(name.s, type.s)
   Protected *this.Atribut = AllocateMemory(SizeOf(Atribut))
   If FindString(name, "[", 1) And FindString(name, "]", 1)
    *this\Array = #True
   EndIf
   *this\Name = name
   *this\Type = type
   ProcedureReturn *this
EndProcedure


Procedure AddAtribut(*this.Struct, Name.s)
  SetEllement(*this\atribut , CountEllement(*this\atribut)+1, NewAtribut(StringField(Name, 1, "."), StringField(Name, 2, ".")))
EndProcedure





; IDE Options = PureBasic 4.30 (Windows - x86)
; CursorPosition = 28
; Folding = -
; EnableXP