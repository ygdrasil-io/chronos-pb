Enumeration
	#ProjectIsApp
	#ProjectIsStaticLib
	#ProjectIsDynamicLib
EndEnumeration

Class ProjectOption Extends Amphore
	SafeThread.b
	Unicode.b
	ASM.b
	OnError.b
	ThemesXP.b
	AdminMode.b
	UserMode.b
	Precompilation.b
	
	Procedure loadOption(*node)
		Select LCase(GetXMLAttribute(*node, "name"))
			Case "safethread"
				*this\SafeThread = Val(GetXMLAttribute(*node, "value"))
			Case "unicode"
				*this\Unicode = Val(GetXMLAttribute(*node, "value"))
			Case "asm"
				*this\ASM = Val(GetXMLAttribute(*node, "value"))
			Case "onerror"
				*this\OnError = Val(GetXMLAttribute(*node, "value"))
			Case "xpskin"
				*this\ThemesXP = Val(GetXMLAttribute(*node, "value"))
			Case "adminmode"
				*this\AdminMode = Val(GetXMLAttribute(*node, "value"))
			Case "usermode"
				*this\UserMode = Val(GetXMLAttribute(*node, "value"))
			Case "precompiler"
				*this\Precompilation = Val(GetXMLAttribute(*node, "value"))
		EndSelect
	EndProcedure
	
	Procedure generateOptionNode(*node)
		Protected *child = CreateXMLNode(*node)
		SetXMLNodeName(*child, "option")
		SetXMLAttribute(*child, "name", "safethread")
		SetXMLAttribute(*child, "value", str(*this\SafeThread))
		*child = CreateXMLNode(*node)
		SetXMLNodeName(*child, "option")
		SetXMLAttribute(*child, "name", "unicode")
		SetXMLAttribute(*child, "value", str(*this\Unicode))
		*child = CreateXMLNode(*node)
		SetXMLNodeName(*child, "option")
		SetXMLAttribute(*child, "name", "asm")
		SetXMLAttribute(*child, "value", str(*this\ASM))
		*child = CreateXMLNode(*node)
		SetXMLNodeName(*child, "option")
		SetXMLAttribute(*child, "name", "onerror")
		SetXMLAttribute(*child, "value", str(*this\OnError))
		*child = CreateXMLNode(*node)
		SetXMLNodeName(*child, "option")
		SetXMLAttribute(*child, "name", "xpskin")
		SetXMLAttribute(*child, "value", str(*this\ThemesXP))
		*child = CreateXMLNode(*node)
		SetXMLNodeName(*child, "option")
		SetXMLAttribute(*child, "name", "adminmode")
		SetXMLAttribute(*child, "value", str(*this\AdminMode))
		*child = CreateXMLNode(*node)
		SetXMLNodeName(*child, "option")
		SetXMLAttribute(*child, "name", "usermode")
		SetXMLAttribute(*child, "value", str(*this\UserMode))
		*child = CreateXMLNode(*node)
		debug *child
		SetXMLNodeName(*child, "option")
		SetXMLAttribute(*child, "name", "precompiler")
		SetXMLAttribute(*child, "value", str(*this\Precompilation))
	EndProcedure
EndClass

Class Template Extends ProjectOption
	Path.s
	Icon.i
	Mode.b
	Name.s
	Version.l
	
	Procedure Free()
		If IsImage(*this\Icon)
			FreeImage(*this\Icon)
		EndIf
		FreeMemory(*this)
	EndProcedure
	
	Procedure Template()
		*this\Ressource = New Array()
	EndProcedure
	
	Procedure save()
		*this.ToFile(*System.GetTemplatePath() + *this\Name + ".cht")
	EndProcedure
	
	Procedure Load(Path.s)
		Protected *Amphore.Amphore = New Amphore(), *Ressource.Ressource, n
		If Not *Amphore.FromFile(Path)
			ProcedureReturn #False	
		EndIf
		For n = 1 to 4	
			*Ressource = *Amphore.GetRessource(n)
			*this.setRessource(*Ressource\Res, *Ressource\File, n)
		Next n
		*this.GenerateConfig()
		*Amphore.Free()
		*this.loadIcon()
		ProcedureReturn *this.GenerateConfig()
	EndProcedure
	
	
	Procedure loadIcon()
		Protected *Ressource.Ressource = *this.GetRessource(4)
		*this\Icon = CatchImage(#PB_Any, *Ressource\Res)
	EndProcedure
	
	Procedure GenerateConfig()
		Protected *Ressource.Ressource = *this.GetRessource(1), *Node, *XML, *NodeChild, n
		*XML = CatchXML(#PB_Any,  *Ressource\Res, MemorySize(*Ressource\Res))
		If Not IsXML(*XML)
			ProcedureReturn #False
		EndIf
		*Node = MainXMLNode(*XML)
		For n = 1 To XMLChildCount(*Node)
			*NodeChild = ChildXMLNode(*Node , n)
			Select LCase(GetXMLNodeName(*NodeChild))
				Case "name"
					*this\Name = GetXMLNodeText(*NodeChild)
				case "option"
					*this.loadOption(*NodeChild)
				case "type"
					Select LCase(GetXMLNodeText(*NodeChild))
						Case "app"
							*this\Mode = #ProjectIsApp
						case "slib"
							*this\Mode = #ProjectIsStaticLib
						case "dlib"
							*this\Mode = #ProjectIsDynamicLib
					EndSelect
				Default
					ProcedureReturn #False
			EndSelect
		Next n
		ProcedureReturn #True
	EndProcedure
	
	Procedure GenerateXML()
		Protected *XML = CreateXML(#PB_Any, #PB_UTF8)
		If Not IsXML(*XML)
			ProcedureReturn #False
		EndIf
		Protected *XMLNode = RootXMLNode(*XML)
		If Not *XMLNode
			ProcedureReturn #False
		EndIf
		*XMLNode = CreateXMLNode(*XMLNode)
		SetXMLNodeName(*XMLNode, "project")
		Protected *XMLChildNode = CreateXMLNode(*XMLNode)
		If Not *XMLChildNode
			ProcedureReturn #False
		EndIf
		SetXMLNodeName(*XMLChildNode, "type")
		Select *this\Mode
			Case #ProjectIsApp
				SetXMLNodeText(*XMLChildNode, "App")
			Case #ProjectIsStaticLib
				SetXMLNodeText(*XMLChildNode, "SLib")
			Case #ProjectIsDynamicLib
				SetXMLNodeText(*XMLChildNode, "DLib")
		EndSelect
		*XMLChildNode = CreateXMLNode(*XMLNode)
		If Not *XMLChildNode
			ProcedureReturn #False
		EndIf
		SetXMLNodeName(*XMLChildNode, "name")
		SetXMLNodeText(*XMLChildNode, *this\Name)
		*this.generateOptionNode(*XMLNode)
		Protected *Memory = AllocateMemory(ExportXMLSize(*XML))
		If Not *Memory
			ProcedureReturn #False
		EndIf
		ExportXML(*XML, *Memory, MemorySize(*Memory))
		*this.SetRessource(*Memory , "XML", 1)
		ProcedureReturn #True
	EndProcedure
	
	StaticProcedure.Amphore LoadDirectory(Path.s)
		Protected *Amphore.Amphore = New Amphore()
		If Path
			*Amphore.AddDirectory(Path)
		EndIf
		ProcedureReturn *Amphore.Get()
	EndProcedure
	
	Procedure CheckProjectDirectory(Path.s)
		If Not FileSize(Path + "Binaries") = -2
			CreateDirectory(Path + "Binaries")
		EndIf
		If Not FileSize(Path + "Binaries/x86 - Windows") = -2
			CreateDirectory(Path + "Binaries/x86 - Windows")
		EndIf
		If Not FileSize(Path + "Binaries/X64 - Windows") = -2
			CreateDirectory(Path + "Binaries/x64 - Windows")
		EndIf
		If Not FileSize(Path + "Binaries/X86 - Linux") = -2
			CreateDirectory(Path + "Binaries/x86 - Linux")
		EndIf
		If Not FileSize(Path + "Medias") = -2
			CreateDirectory(Path + "Medias")
		EndIf
		If Not FileSize(Path + "Generated Sources") = -2
			CreateDirectory(Path + "Generated Sources")
		EndIf
		If Not FileSize(Path + "Sources") = -2
			CreateDirectory(Path + "Sources")
		EndIf
	EndProcedure
	
	Procedure GenerateProject(Path.s, Name.s)
		*this.CheckProjectDirectory(Path)
		Protected *Ptr = *this.GetRessource(1).GetRessource()
		Protected *XML = CatchXML(#PB_Any, *Ptr, MemorySize(*Ptr))
		If Not IsXML(*XML)
			ProcedureReturn #False
		EndIf
		SetXMLNodeText(XMLNodeFromPath(MainXMLNode(*XML), "/project/name"), Name)
		SaveXML(*XML, Path + "project.chp")
		Protected *Amphore.Amphore = New Amphore()
		*Amphore.load(*this.GetRessource(2).GetRessource())
		*Amphore.RestoreDirectory(Path+"Sources/")
		*Amphore.load(*this.GetRessource(3).GetRessource())
		*Amphore.RestoreDirectory(Path+"Medias/")
		If FileSize(Path + "Sources/main.pb") < 0
			CloseFile(CreateFile(#PB_Any, Path + "Sources/main.pb"))
		EndIf
	EndProcedure
EndClass
