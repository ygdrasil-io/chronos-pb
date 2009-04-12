

Structure Element
  CompilerCondition.s
EndStructure

Structure Macro
  Text.s
EndStructure

Structure Constant Extends Element
  Text.s
EndStructure

Structure Attribut
  Name.s
  Type.s
EndStructure

Structure StructureAttribut Extends Attribut
  Array.s
  Ptr.b
EndStructure

Structure Variable Extends Attribut
  
EndStructure

Structure ClassAttribut Extends StructureAttribut
  DefaultValue.s
EndStructure

Structure ProcedureAttribut Extends Attribut
  DefaultValue.s
EndStructure







; IDE Options = PureBasic 4.30 (Windows - x86)
; Folding = -
; EnableXP
; UseMainFile = main.pb