Class Project Extends Template
	File.s
	*Files.Directory
	
	
	Procedure Project(Path.s, Name.s = "")
		*this\Ressource = New Array()
		Path = ReplaceString(Path, "\", "/")
		*this\Name = Name
		*this\Path = Path
		*this\File = GetFilePart(*this\Path)
	EndProcedure
	
	
	Procedure Load()
		Protected FileID, Path.s = GetPathPart(*this\Path), *XML
		*this.CheckProjectDirectory(Path)
		If FileSize(Path + "Sources/main.pb") < 0
			FileID = CreateFile(#PB_Any, Path + "Sources/main.pb")
			If Not IsFile(FileID)
				ProcedureReturn #False
			EndIf
			CloseFile(FileID)
		EndIf
		*XML = LoadXML(#PB_Any, *this\Path, #PB_UTF8)
		If Not IsXML(*XML)
			ProcedureReturn #False
		EndIf
		Protected *Ptr = AllocateMemory(ExportXMLSize(*XML))
		ExportXML(*XML, *Ptr, MemorySize(*Ptr))
		*this.SetRessource(*Ptr, "XML", 1)
		*this.GenerateConfig()
		FreeXML(*XML)
		*this\Files = New Directory(*this.GetSourcesPath())
		ProcedureReturn #True	
	EndProcedure
	
	Procedure.b ExportMedias(Path.s, MediaPath.s = "")
		If Not MediaPath
			MediaPath = *this.GetMediasPath()
		EndIf
		Protected DirID = ExamineDirectory(#PB_Any, MediaPath, "")
		If Not DirID
			ProcedureReturn #False
		EndIf
		If Not IsDirectory(DirID)
			ProcedureReturn #False
		EndIf
		While NextDirectoryEntry(DirID)
			If Not Left(DirectoryEntryName(DirID), 1) = "."
				Select DirectoryEntryType(DirID)
					Case #PB_DirectoryEntry_File
						If Not CopyFile(MediaPath + DirectoryEntryName(DirID), Path + DirectoryEntryName(DirID))
							ProcedureReturn #False
						EndIf
					Case #PB_DirectoryEntry_Directory
						If Not CreateDirectory(Path + DirectoryEntryName(DirID))
							ProcedureReturn #False
						EndIf
						If Not *this.ExportMedias(Path + DirectoryEntryName(DirID) + "/", MediaPath + DirectoryEntryName(DirID) + "/")
							ProcedureReturn #False
						EndIf
				EndSelect
			EndIf
		Wend
		FinishDirectory(DirID)
		ProcedureReturn #True
	EndProcedure
	
	Procedure.b Export(Path.s)
		If FileSize(*this.GetBinariePath("X86")) > 0
			If FileSize(Path + "x86") = -2
				DeleteDirectory(Path + "x86", "", #PB_FileSystem_Recursive | #PB_FileSystem_Force)
			EndIf
			If CreateDirectory(Path + "x86")
				If Not *this.ExportMedias(Path + "x86/")
					ProcedureReturn #False
				EndIf
				If Not CopyFile(*this.GetBinariePath("X86"), Path + "x86/" + *this\Name + #Extension)
					ProcedureReturn #False
				EndIf
			Else
				ProcedureReturn #False
			EndIf
		EndIf
		If FileSize(*this.GetBinariePath("X64")) > 0
			If FileSize(Path + "x64") = -2
				DeleteDirectory(Path + "x64", "", #PB_FileSystem_Recursive | #PB_FileSystem_Force)
			EndIf
			If CreateDirectory(Path + "x64")
				If Not *this.ExportMedias(Path + "x64/")
					ProcedureReturn #False
				EndIf
				If Not CopyFile(*this.GetBinariePath("X64"), Path + "x64/" + *this\Name + #Extension)
					ProcedureReturn #False
				EndIf
			Else
				ProcedureReturn #False
			EndIf
		EndIf
		ProcedureReturn #True
	EndProcedure
	
	Procedure.s GetCompilerParamList()
		Protected Param.s
		If len(*this\SubSystem) > 0
			Param + " " + #CompilerSubSystem + " " + *this\SubSystem
		EndIf
		CompilerIf #PB_Compiler_OS = #PB_OS_Windows
			If *this\ThemesXP
				Param + " " + "/XP"
			EndIf
			If *this\AdminMode
				Param + " " + "/ADMINISTRATOR"
			EndIf
			If *this\UserMode
				Param + " " + "/USER"
			EndIf
		CompilerEndIf
		
		ProcedureReturn Param
	EndProcedure
	
	Procedure PrecompilerIsEnable()
		ProcedureReturn *this\Precompilation
	EndProcedure
	
	Procedure IsFile(*file)
		ProcedureReturn Directory_IsFile(*this\Files, *file)
	EndProcedure
	
	Procedure.Directory GetRootNode()
		ProcedureReturn *This\Files
	EndProcedure
	
	Procedure Free()
		FreeMemory(*this)
	EndProcedure
	
	Procedure.s GetMediasPath()
		ProcedureReturn GetPathPart(*this\Path) + "Medias" + "/"
	EndProcedure
	
	Procedure.s GetSourcesPath()
		ProcedureReturn GetPathPart(*this\Path) + "Sources" + "/"
	EndProcedure
	
	Procedure.s GetGeneratedSourcesPath()
		ProcedureReturn GetPathPart(*this\Path) + "Generated Sources" + "/"
	EndProcedure
	
	Procedure.s GetBinariePath(Architecture.s)
		Protected retour.s
		Select Architecture
			Case "X64"
				retour = "x64 - "
			Default
				retour = "x86 - "
		EndSelect
		retour + #PrefixeFile ;Windows or Linux or MacOS
		ProcedureReturn GetPathPart(*this\Path) + "Binaries" + "/" + retour + "/" + *this\Name + #Extension
	EndProcedure
	
	Procedure SaveProject()
		*this.GenerateXML()
		Protected *Ressource.Ressource = *this.GetRessource(1)
		If FileSize(*this\Path) >= 0
			DeleteFile(*this\Path)
		EndIf
		Protected FileID = CreateFile(#PB_Any, *this\Path)
		If Not IsFile(FileID)
			ProcedureReturn #False
		EndIf
		WriteData(FileID, *Ressource\Res, MemorySize(*Ressource\Res))
		CloseFile(FileID)
		ProcedureReturn #True
	EndProcedure
	
	Procedure GetMode()
		ProcedureReturn *this\mode
	EndProcedure
	
	Procedure RemoveFile(Number.l)
		Protected *Node.Node = *this\Files.removeNode(Number)
		Protected *File.File, *Directory.Directory
		If *Node
			Select *Node\Type
				Case #Node_Directory
					*Directory = *Node
					DeleteDirectory(*Directory\Name, "", #PB_FileSystem_Recursive)
				Case #Node_File
					*File = *Node
					DeleteFile(*File\Path)
			EndSelect
		EndIf
	EndProcedure
EndClass

Procedure.i GetFileList(*this.Project)
	ProcedureReturn *this\Files
EndProcedure

Procedure Project_FileIs(*this.Project, Number.i)
	ProcedureReturn Directory_FileIs(*this\Files, Number)
EndProcedure

Procedure Project_GetFile(*this.Project, Number.i)
	;	ProcedureReturn Directory_GetFile(*this\Files, Number)
EndProcedure



Procedure Project_AddNodeOption(*Parent, Name.s, Value.b)
	Protected *Child = CreateXMLNode(*Parent)
	SetXMLNodeName(*Child, Name)
	SetXMLNodeText(*Child, Str(Value))
EndProcedure

;Procedure SaveProject(*this.Project)
;	Protected XML = CreateXML(#PB_Any, #PB_UTF8), *Ptr, *Child
;	If FileSize(*this\Path) >= 0
;		DeleteFile(*this\Path)
;	EndIf
;	If IsXML(XML)
;		*Ptr= CreateXMLNode(RootXMLNode(XML))
;		If *Ptr
;			SetXMLNodeName(*Ptr, "Project")
;			*Child = CreateXMLNode(*Ptr)
;			SetXMLNodeName(*Child, "Name")
;			SetXMLNodeText(*Child, *this\Name)
;			*Child = CreateXMLNode(*Ptr)
;			SetXMLNodeName(*Child, "Type")
;			Select *this\Mode
;				Case #ProjectIsApp
;					SetXMLNodeText(*Child, "Application")
;				Case #ProjectIsDynamicLib
;					SetXMLNodeText(*Child, "Dynamic library")
;				Case #ProjectIsStaticLib
;					SetXMLNodeText(*Child, "Static library")
;			EndSelect
;			*Ptr = CreateXMLNode(*Ptr)
;			SetXMLNodeName(*Ptr, "Option")
;			Project_AddNodeOption(*Ptr, "SafeThread", *this\Options\SafeThread)
;			Project_AddNodeOption(*Ptr, "Unicode", *this\Options\Unicode)
;			Project_AddNodeOption(*Ptr, "ASM", *this\Options\ASM)
;			Project_AddNodeOption(*Ptr, "OnError", *this\Options\OnError)
;			Project_AddNodeOption(*Ptr, "ThemeXP", *this\Options\ThemesXP)
;			Project_AddNodeOption(*Ptr, "UserMode", *this\Options\UserMode)
;			Project_AddNodeOption(*Ptr, "AdminMode", *this\Options\AdminMode)
;			Project_AddNodeOption(*Ptr, "Precompilation", *this\Options\Precompilation)
;		Else
;			Debug "erreur"
;		EndIf
;		SaveXML(XML, *this\Path, #PB_XML_NoDeclaration)
;	Else
;		Debug "erreur"
;	EndIf
;EndProcedure


Procedure.s Project_GetFilePath(*this.Project, Number.l)
	ProcedureReturn *this.GetSourcesPath() + Directory_GetFilePath(*this\Files, Number)
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
