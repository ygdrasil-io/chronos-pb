Structure Array
	*ptr.i
	number.i
EndStructure
Structure CharacterRange
	cpMin.l
	cpMax.l
EndStructure
Structure TextToFind
	chrg.CharacterRange
	lpstrText.i
	chrgText.CharacterRange
EndStructure
Structure Scintilla
	Gadget.i
EndStructure
Structure Option
	Name.s
	Value.s
EndStructure
Structure Group
	Name.s
	*Option.Array
EndStructure
Structure Preference
	Name.s
	*Group.Array
EndStructure
Structure NewPrefs
	Group.s
	Name.s
	Value.s
EndStructure
Structure TemplateName
	Name.s
	Language.s
EndStructure
Structure Template
	Path.s
	IgnoreDir.i
	IgnoreFile.i
	*Name.Array
	*Icon.i
	Mode.b
EndStructure
Structure Definition
	name.s
	line.i
	File.s
EndStructure
Structure Comment Extends Definition
EndStructure
Structure Function Extends Definition
	Declaration.s
EndStructure
Structure Structure Extends Definition
	StructureAtribut.Array
EndStructure
Structure Directory
	*File.Array
	*Dir.Array
	Name.s
EndStructure
Structure File
	Path.s
	File.s
	Text.s
	Saved.b
	*Comment.Array
	*Function.Array
EndStructure
Structure ProjectOption
	SafeThread.b
	Unicode.b
	ASM.b
	OnError.b
	ThemesXP.b
	AdminMode.b
	UserMode.b
	Precompilation.b
EndStructure
Structure Ressource
	Path.s
	include.b
EndStructure
Structure CompilerStructure
	Name.s
	*atribut.Array
EndStructure
Structure Atribut
	Name.s
	Type.s
	Array.b
EndStructure
Structure CompilerFunction
	Name.s
	Declaration.s
EndStructure
Structure Panel
	*File.File
	*ScintillaGadget.i
EndStructure
Structure IHM
	Window.i[#NB_Win]
	Menu.i[#NB_Menu]
	Gadget.i[#NB_Gadget]
	StatusBar.i[#NB_StatusBar]
	ToolBar.i[#NB_ToolBar]
	Image.i[#NB_Image]
	OptionModified.b
	ProjectTreeMode.i
EndStructure
Structure Project
	Path.s
	File.s
	Name.s
	*Files.Array
	Options.ProjectOption
	Mode.b
	*Constante.Array
	*Structure.Array
	*Function.Array
EndStructure
Structure Compiler
	Path.s
	FunctionList.s
	StructureList.s
	*Constante.Array
	*Structure.Array
	*Function.Array
EndStructure
Structure LineCode
	File.s
	Line.l
	Text.s
EndStructure
Structure Precompiler
	*Class.Array
	*Procedure.Array
	*LocalV.Array
	*GlobalV.Array
	*LocalText.Array
	*Constant.Array
	*Macro.Array
	*Structure.Array
	*String.Array
	*Body.Array
	*Compiler.Compiler
	IncludeFileX.s
	IncludeImportX.s
	Error.b
EndStructure
Structure Precompiler_Element Extends LineCode
	PrecompilerCondition.s
	CFile.s
	Cline.l
EndStructure
Structure Precompiler_Constant Extends Precompiler_Element
	Name.s
	Value.s
EndStructure
Structure Precompiler_Attribut Extends LineCode
	Name.s
	Type.s
EndStructure
Structure Precompiler_StructureAttribut Extends Precompiler_Attribut
	Array.s
	Ptr.b
EndStructure
Structure Precompiler_Structure Extends LineCode
	Name.s
	*Attribut.Array
	Extend.s
EndStructure
Structure Precompiler_ProcedureAttribut Extends Precompiler_Attribut
	DefaultValue.s
EndStructure
Structure Precompiler_Procedure Extends LineCode
	Name.s
	Type.s
	ProcedureMode.b
	*Attribut.Array
	*LocalV.Array
	*Body.Array
EndStructure
Structure Precompiler_Variable Extends Precompiler_Attribut
EndStructure
Structure Precompiler_Method Extends Precompiler_Procedure
	ClassName.s
EndStructure
Structure Precompiler_ClassAttribut Extends Precompiler_StructureAttribut
	DefaultValue.s
EndStructure
Structure Precompiler_Class Extends Precompiler_Structure
	*Method.Array
	*StaticMethod.Array
	*Constructor.Array
	*Class.Array
	ClassName.s
EndStructure
Structure Precompiler_Macro Extends LineCode
	*Body.Array
EndStructure
Structure System
	*Panel.Array
	*File.Array
	*IHM.IHM
	CurrentPanel.w
	*Prefs.Preference
	*Plugin.Array
	*Constante.Array
	*Struct.Array
	*Function.Array
	*Template.Array
	*Compiler.Compiler[2]
	*OpenProject.Project
	*NewPrefs.Array
	*Precompiler.Precompiler
EndStructure
