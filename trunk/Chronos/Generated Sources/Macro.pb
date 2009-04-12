Macro SetColor(Name,Type,LastColor)
Color=ColorRequester(Val(LastColor))
If Color>-1 And Color<>Val(LastColor)
IHM_OptionModified(*this)
If StartDrawing(ImageOutput(*this\Image[#ImageColor_#Type]))
Box(0,0,100,20,Color)
StopDrawing()
SetGadgetAttribute(*this\Gadget[#GD_ImageColor_#Type],#PB_Button_Image,ImageID(*this\Image[#ImageColor_#Type]))
NewNewPref("Color",Name,Str(Color))
EndIf
EndIf
EndMacro
Macro RemoveFileStructure(this)
RemoveAll(this\Comment)
EndMacro
Macro MakeFunctionListToString(this)
CompilerFunction=""
For n=1 To CountEllement(this\Function)
CompilerFunction+CompilerFunction_GetName(GetEllement(this\Function,n))+" "
Next
EndMacro
Macro MakeStructureListToString(this)
CompilerStructure=""
For n=1 To CountEllement(this\Structure)
CompilerStructure+CompilerStructure_GetName(GetEllement(this\Structure,n))+" "
Next
EndMacro
