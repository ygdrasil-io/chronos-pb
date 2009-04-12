Procedure NewTemplateName(Name.s, Language.s)
	Protected *this.TemplateName = AllocateMemory(SizeOf(TemplateName))
	*this\Name = Name
	*this\Language = Language
	ProcedureReturn *this
EndProcedure


Procedure NewTemplate(Path.s)
	If FileSize(Path) < 0
		ProcedureReturn 0
	EndIf
	Protected *this.Template = AllocateMemory(SizeOf(Template))
	*this\Path = Path
	*this\Name = New Array()
	Protected XML = LoadXML(#PB_Any, Path, #PB_UTF8), *Ptr, n = 1, *ChildNode
	If IsXML(XML)
		*Ptr = MainXMLNode(XML)
		If LCase(GetXMLNodeName(*Ptr)) = "template"
			*ChildNode = ChildXMLNode(*Ptr)
			While *ChildNode
				Select LCase(GetXMLNodeName(*ChildNode))
					Case "Name"
						*this\Name.AddElement(NewTemplateName(Trim(ReplaceString(GetXMLNodeText(*ChildNode), Chr(9), " ")), GetXMLAttribute(*ChildNode, "language")))
					Case "Type"
						Select LCase(Trim(ReplaceString(GetXMLNodeText(*ChildNode), Chr(9), " ")))
							Case "application"
								*this\mode = #ProjectIsApp
							Case "static library"
								*this\mode = #ProjectIsStaticLib
							Case "dynamic library"
								*this\mode = #ProjectIsDynamicLib
						EndSelect
				EndSelect
				n + 1
				*ChildNode = ChildXMLNode(*Ptr, n)
			Wend
			FreeXML(XML)
		Else
			ProcedureReturn 0
		EndIf
	Else
		ProcedureReturn 0
	EndIf
	ProcedureReturn *this
EndProcedure

Procedure.s Template_GetName(*this.Template, Language.s)
	Protected n, *Name.TemplateName
	For n=1 To *this\Name.CountElement()
		*Name = *this\Name.GetElement(n)
		If LCase(*Name\Language) = LCase(Language)
			ProcedureReturn *Name\Name
		EndIf
	Next n
	ProcedureReturn "name not define"
EndProcedure

Procedure GenerateTree(*this.Template, Path.s, Destination.s)
	Protected DirID = ExamineDirectory(#PB_Any, Path, "*")
	If Not DirID
		ProcedureReturn 0
	EndIf
	While NextDirectoryEntry(DirID)
		If Not DirectoryEntryName(DirID) = "." And Not DirectoryEntryName(DirID) = ".."
			Select DirectoryEntryType(DirID)
				Case #PB_DirectoryEntry_File
					CopyFile(Path + DirectoryEntryName(DirID), Destination + DirectoryEntryName(DirID))
				Case #PB_DirectoryEntry_Directory
					CreateDirectory(Destination + DirectoryEntryName(DirID) + "/")
					GenerateTree(*this, Path + DirectoryEntryName(DirID) + "/", Destination + DirectoryEntryName(DirID) + "/")
			EndSelect
		EndIf
	Wend
	FinishDirectory(DirID)
EndProcedure

Procedure.i GenerateProject(*this.Template, Path.s, Name.s)
	Protected *Project.Project = NewProject(Path, Name)
	*Project\Mode = *this\Mode
	Protected MainNode.s = GetPathPart(Path)+Name+"/"
	Protected SourceNode.s = GetPathPart(*this\Path) + Left(GetFilePart(*this\Path), Len(GetFilePart(*this\Path)) - Len(".chtp")) + "/"
	CreateDirectory(MainNode)
	GenerateTree(*this, SourceNode, MainNode)
	SaveProject(*Project)
EndProcedure
