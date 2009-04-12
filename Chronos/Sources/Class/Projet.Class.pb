Class Project
	Path.s
	File.s
	Name.s
	*Files.Array
	Options.ProjectOption
	Mode.b
	*Constante.Array
	*Structure.Array
	*Function.Array
	
	Procedure PrecompilerIsEnable()
		ProcedureReturn *this\Options\Precompilation
	EndProcedure
EndClass

Procedure NewProject(Path.s, Name.s)
	Protected *this.Project = AllocateMemory(SizeOf(Project))
	*this\Name = Name
	*this\Path = Path
	*this\File = GetFilePart(Path)
	*this\Files = New Array()
	ProcedureReturn *this
EndProcedure

Procedure Project_IsFile(*this.Project, *file)
	ProcedureReturn Directory_IsFile(*this\Files, *file)
EndProcedure

Procedure.i GetFileList(*this.Project)
	ProcedureReturn *this\Files
EndProcedure

Procedure GetMode(*this.Project)
	ProcedureReturn *this\mode
EndProcedure

Procedure OpenProject(Path.s)
	Path = ReplaceString(Path, "\", "/")
	Protected *this.Project = NewProject(Path, ""), n = 1, i
	Protected *Ptr, *Child, XML = LoadXML(#PB_Any, Path, #PB_UTF8)
	If IsXML(XML)
		*Ptr = MainXMLNode(XML)
		*Child = ChildXMLNode(*Ptr)
		While *Child
			Select LCase(GetXMLNodeName(*Child))
				Case "name"
					*this\Name = GetXMLNodeText(*Child)
				Case "type"
					Select LCase(Trim(ReplaceString(GetXMLNodeText(*Child), Chr(9), " ")))
						Case "application"
							*this\mode = #ProjectIsApp
						Case "static library"
							*this\mode = #ProjectIsStaticLib
						Case "dynamic library"
							*this\mode = #ProjectIsDynamicLib
					EndSelect
				Case "option"
					*Ptr = *Child
					*Child = ChildXMLNode(*Ptr)
					i = 1
					While *Child
						Select LCase(GetXMLNodeName(*Child))
							Case "safethread"
								*this\Options\SafeThread = Val(GetXMLNodeText(*Child))
							Case "unicode"
								*this\Options\Unicode = Val(GetXMLNodeText(*Child))
							Case "asm"
								*this\Options\ASM = Val(GetXMLNodeText(*Child))
							Case "onerror"
								*this\Options\OnError = Val(GetXMLNodeText(*Child))
							Case "themexp"
								*this\Options\ThemesXP = Val(GetXMLNodeText(*Child))
							Case "usermode"
								*this\Options\UserMode = Val(GetXMLNodeText(*Child))
							Case "adminmode"
								*this\Options\AdminMode = Val(GetXMLNodeText(*Child))
							Case "precompilation"
								*this\Options\Precompilation = Val(GetXMLNodeText(*Child))
						EndSelect
						i + 1
						*Child = ChildXMLNode(*Ptr, i)
					Wend
					*Ptr = ParentXMLNode(*Ptr)
					
			EndSelect
			n + 1
			*Child = ChildXMLNode(*Ptr, n)
		Wend
		FreeXML(XML)
	Else
		ProcedureReturn 0
	EndIf
	*this\Files = NewDirectory(GetSourcesPath(*this))
	ProcedureReturn *this
EndProcedure

Procedure Project_FileIs(*this.Project, Number.i)
	ProcedureReturn Directory_FileIs(*this\Files, Number)
EndProcedure

Procedure Project_GetFile(*this.Project, Number.i)
	ProcedureReturn Directory_GetFile(*this\Files, Number)
EndProcedure

Procedure.s GetCompilerParamList(*this.Project)
	Protected Param.s, Struct.l
	
	CompilerIf #PB_Compiler_OS = #PB_OS_Windows
		If *this\Options\ThemesXP
			Param + " " + "/XP"
		EndIf
		If *this\Options\AdminMode
			Param + " " + "/ADMINISTRATOR"
		EndIf
		If *this\Options\UserMode
			Param + " " + "/USER"
		EndIf
	CompilerEndIf
	
	ProcedureReturn Param
EndProcedure

Procedure Project_AddNodeOption(*Parent, Name.s, Value.b)
	Protected *Child = CreateXMLNode(*Parent)
	SetXMLNodeName(*Child, Name)
	SetXMLNodeText(*Child, Str(Value))
EndProcedure

Procedure SaveProject(*this.Project)
	Protected XML = CreateXML(#PB_Any, #PB_UTF8), *Ptr, *Child
	If FileSize(*this\Path) >= 0
		DeleteFile(*this\Path)
	EndIf
	If IsXML(XML)
		*Ptr= CreateXMLNode(RootXMLNode(XML))
		If *Ptr
			SetXMLNodeName(*Ptr, "Project")
			*Child = CreateXMLNode(*Ptr)
			SetXMLNodeName(*Child, "Name")
			SetXMLNodeText(*Child, *this\Name)
			*Child = CreateXMLNode(*Ptr)
			SetXMLNodeName(*Child, "Type")
			Select *this\Mode
				Case #ProjectIsApp
					SetXMLNodeText(*Child, "Application")
				Case #ProjectIsDynamicLib
					SetXMLNodeText(*Child, "Dynamic library")
				Case #ProjectIsStaticLib
					SetXMLNodeText(*Child, "Static library")
			EndSelect
			*Ptr = CreateXMLNode(*Ptr)
			SetXMLNodeName(*Ptr, "Option")
			Project_AddNodeOption(*Ptr, "SafeThread", *this\Options\SafeThread)
			Project_AddNodeOption(*Ptr, "Unicode", *this\Options\Unicode)
			Project_AddNodeOption(*Ptr, "ASM", *this\Options\ASM)
			Project_AddNodeOption(*Ptr, "OnError", *this\Options\OnError)
			Project_AddNodeOption(*Ptr, "ThemeXP", *this\Options\ThemesXP)
			Project_AddNodeOption(*Ptr, "UserMode", *this\Options\UserMode)
			Project_AddNodeOption(*Ptr, "AdminMode", *this\Options\AdminMode)
			Project_AddNodeOption(*Ptr, "Precompilation", *this\Options\Precompilation)
		Else
			Debug "erreur"
		EndIf
		SaveXML(XML, *this\Path, #PB_XML_NoDeclaration)
	Else
		Debug "erreur"
	EndIf
EndProcedure

Procedure.s GetMediasPath(*this.Project)
	ProcedureReturn GetPathPart(*this\Path) + *this\name + "/" + "Medias" + "/"
EndProcedure

Procedure.s GetSourcesPath(*this.Project)
	ProcedureReturn GetPathPart(*this\Path) + *this\name + "/" + "Sources" + "/"
EndProcedure

Procedure.s GetGeneratedSourcesPath(*this.Project)
	ProcedureReturn GetPathPart(*this\Path) + *this\name + "/" + "Generated Sources" + "/"
EndProcedure

Procedure.s GetBinariePath(*this.Project)
	Protected retour.s
	Select *System\Prefs.GetPreference("GENERAL", "structure")
		Case "X64"
			retour = "x64 - "
		Default
			retour = "x86 - "
	EndSelect
	CompilerIf #PB_Compiler_OS = #PB_OS_Linux
		retour + "linux"
	CompilerElse
		retour + "Windows"
	CompilerEndIf
	ProcedureReturn GetPathPart(*this\Path) + *this\Name + "/" + "Binaries" + "/" + retour + "/"
EndProcedure

Procedure.s Project_GetFilePath(*this.Project, Number.l)
	ProcedureReturn GetSourcesPath(*this) + Directory_GetFilePath(*this\Files, Number)
EndProcedure

Procedure Project_RemoveFile(*this.Project, Number.l)
	Protected *File.File = Directory_RemoveFile(*this\Files, Number)
	If *File
		DeleteFile(*File\Path)
		freefile(*File)
	EndIf
EndProcedure

Procedure.s Project_GetFunctionList(*this.Project)
	Protected n,  retour.s
	;   For n = 1 To  CountEllement(*this\files)
	;     retour  + File_GetFunctionList(GetEllement(*this\files,  n))
	;   Next  n
	ProcedureReturn retour
EndProcedure

Procedure FreeProject(*this.Project)
	;FreeMemory(*this)
EndProcedure

; IDE Options = PureBasic 4.30 (Windows - x86)
; CursorPosition = 12
; Folding = fv--
; EnableXP
