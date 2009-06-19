;=====================================================
; IHM.class.pb
;
;classe pour l'Interface Homme Machine
;Feel the pure power
;=====================================================
Enumeration
	#WIN_Main
	#WIN_Search
	#WIN_NewProject
	#WIN_Option
	#WIN_OptionCompilation
	#WIN_OptionProject
	#WIN_TemplateMaker
EndEnumeration

Enumeration
	#Menu_Main
	#Menu_ProjectDirectory
	#Menu_ProjectFile
EndEnumeration

#NB_ToolBar = 1
#NB_Win = 10
#NB_Menu = 5
#NB_Gadget = 150
#NB_StatusBar = 1
#NB_Image = 50

Enumeration
	#New
	#NewProject
	#AutoIndent
	#Open
	#Save
	#SaveAs
	#Close
	#CloseAll
	#Quit
	#Undo
	#redo
	#cut
	#copy
	#paste
	#SlctAll
	#search
	#Compiler
	#CompilerProject
	#CompilerOptions
	#BuildCurrentFile
	#SwitchStructure
	#TabOnly
	#Option
	#KillProgram
	#UnCommentText
	#CommentText
	#TemplateMaker
	#GenerateDoc
	#DebugerOn
	#BuildSourceCurrentFile
	;Popup
	#RemoveFile
	#RemoveDirectory
	#AddFileFromFile
	#AddEmptyFile
	
	
EndEnumeration


Enumeration
	#GD_projet
	#GD_FirstPanel
	#GD_Explorer
	#GD_SecondPanel
	#GD_ListComilateur
	#GD_Scintilla
	#GD_MainPanel
	;projet
	#GD_TreeProject
	#GD_ProjectFile
	#GD_ProjectComment
	#GD_ProjectClass
	#GD_ProjectProcedure
	#GD_ProjectProject
	#GD_ProjectAddFile
	#GD_ProjectOption
	#GD_ProjectAPI
	#GD_ProjectClose
	#GD_ProjectStructure
	#GD_ProjectBuild
	#GD_ProjectDirectory
	#GD_ProjectExport
	;projet-option
	#GD_CancelProjectOption
	#GD_ConfirmProjectOption
	#GD_EnableProjectASM
	#GD_EnableProjectUnicode
	#GD_EnableProjectSafeThread
	#GD_EnableProjectOnError
	#GD_EnableProjectXPSkin
	#GD_EnableProjectAdministratorMode
	#GD_EnableProjectUserMode
	#GD_EnableProjectPrecompiler
	#GD_ProjectTypeList
	;other  interface generale
	#GD_SearchString
	#GD_SearchReplaceString
	#GD_SearchNext
	#GD_SearchReplaceAll
	#GD_SearchReplace
	
	
	#GD_TextNewPathCompiler
	#GD_SetPathAddCompiler
	#GD_ConfirmAddCompiler
	
	#GD_TreeTemplate
	#GD_SetPathNewProject
	#GD_PathNewProject
	#GD_CancelNewProject
	#GD_CreateNewProject
	#GD_NameNewProject
	
	#GD_TreeOption
	#GD_OptionConfirm
	#GD_OptionCancel
	#GD_OptionDone
	#GD_FrameLanguage
	#GD_ListLanguage
	#GD_FrameColor
	#GD_TextColor_Text
	#GD_TextColor_KeyWord
	#GD_TextColor_Function
	#GD_TextColor_Constant
	#GD_TextColor_String
	#GD_TextColor_Operator
	#GD_TextColor_Comment
	#GD_ImageColor_Text
	#GD_ImageColor_KeyWord
	#GD_ImageColor_Function
	#GD_ImageColor_Constant
	#GD_ImageColor_String
	#GD_ImageColor_Operator
	#GD_ImageColor_Comment
	#GD_FramePath
	#GD_X86Path_Text
	#GD_X64Path_Text
	#GD_X86Path
	#GD_X64Path
	#GD_X86Path_Select
	#GD_X64Path_Select
	
	#GD_ConfirmSetCompilerOption
	#GD_CancelSetCompilerOption
	#GD_EnableASM
	#GD_EnableUnicode
	#GD_EnableSafeThread
	#GD_EnableOnError
	#GD_EnableXPSkin
	#GD_EnableAdministratorMode
	#GD_EnableUserMode
	#GD_EnablePrecompiler
	
	;TemplateMaker
	#GD_SelectTemplateIcon
	#GD_SelectTemplateSourcesPath
	#GD_SelectTemplateMediaPath
	#GD_TemplateIconPath
	#GD_TemplateSourcesPath
	#GD_TemplateMediaPath
	#GD_CreateTemplate
	#GD_NewTemplateName
	#GD_ChooseTemplateType
	#GD_NewTemplateASM
	#GD_NewTemplateUnicode
	#GD_NewTemplateThreadSafe
	#GD_NewTemplateOnError
	#GD_NewTemplateXPSkin
	#GD_NewTemplateAdminMode
	#GD_NewTemplateUserMode
	#GD_NewTemplatePrecompiler
EndEnumeration

Enumeration 1
	#OptionLang
	#OptionColor
	#OptionCompiler
EndEnumeration
;-IHM-image
Enumeration
	#ImageColor_Text
	#ImageColor_KeyWord
	#ImageColor_Function
	#ImageColor_Constant
	#ImageColor_String
	#ImageColor_Operator
	#ImageColor_Comment
	
	#ImageIcon_File
	#ImageIcon_Comment
	#ImageIcon_Class
	#ImageIcon_Procedure
	#ImageIcon_Project
	#ImageIcon_AddFile
	#ImageIcon_Option
	#ImageIcon_API
	#ImageIcon_Kill
	#ImageIcon_CloseProject
	#ImageIcon_Structure
	#ImageIcon_Build
	#ImageIcon_ProjectExport
	
	#ImageIcon_Directory
	#ImageIcon_FileTree
	#ImageIcon_CodeComment
EndEnumeration

Class Panel
	*File.File
	*ScintillaGadget.Scintilla
	
	Procedure SaveFileTo(File.s)
		Protected FileID = CreateFile(#PB_Any, File), n
		TruncateFile(FileID)
		WriteStringFormat(FileID, #PB_UTF8)
		For n=0 To *this\ScintillaGadget.GETLINECOUNT() - 1
			WriteStringN(FileID, *this\ScintillaGadget.GETLINE(n), #PB_UTF8)
		Next n
		CloseFile(FileID)
	EndProcedure
	
	Procedure Free()
		FreeFile(*This\File)
		FreeMemory(*This)
	EndProcedure
EndClass


Class IHM
	Window.i[#NB_Win]
	Menu.i[#NB_Menu]
	Gadget.i[#NB_Gadget]
	StatusBar.i[#NB_StatusBar]
	ToolBar.i[#NB_ToolBar]
	Image.i[#NB_Image]
	History.i[10]
	OptionModified.b
	ProjectTreeMode.i
	
	Procedure WriteMessage(Msg.s)
		Msg = "[" + FormatDate("%hh:%ii:%ss", Date()) + "] " + Msg
		AddGadgetItem(*this\Gadget[#gd_SecondPanel], -1, Msg)
	EndProcedure
	
	Procedure Search(Text.s, Position = -1)
		Protected *Ptr.Scintilla = *System.GetCurrentScintillaGadget()
		If Position = -1
			Position = 1 + *Ptr.GetPosition()
		Endif
		Position = *Ptr.FindString(Text, Position)
		If Position >=0
			*Ptr.GoToPoS(Position)
			*Ptr.SetSel(Position, Position + Len(Text))
		Else
			If MessageRequester("", "text not found, would you want try a the beginning of the document ?", #PB_MessageRequester_YesNo) = #PB_MessageRequester_Yes
				*this.Search(Text, 0)
			Endif
		EndIf
	EndProcedure
	
	
	
	Procedure LoadIHM()
		Protected Flag.i, n.l, temp.s
		Protected MainPath.s = *System\Prefs.GetPreference("GENERAL", "MainPath")
		CompilerIf  #PB_Compiler_OS = #PB_OS_Windows
			If Not InitScintilla("Scintilla.dll")
				ProcedureReturn #False
			EndIf
		CompilerEndIf
		
		;=====================================================
		;
		;-Chargement  icons
		;
		;=====================================================
		;{
		*this\Image[#ImageIcon_Option]  = LoadImage(#PB_Any,  MainPath + "images/vcard_edit.png")
		If Not *this\Image[#ImageIcon_Option]
			MessageRequester("Error" , "Error while loading " + MainPath + "images/vcard_edit.png")
			ProcedureReturn #False
		EndIf
		*this\Image[#ImageIcon_CloseProject]  = LoadImage(#PB_Any,  MainPath + "images/cancel.png")
		If Not *this\Image[#ImageIcon_CloseProject]
			MessageRequester("Error" , "Error while loading " + MainPath + "images/cancel.png")
			ProcedureReturn #False
		EndIf
		*this\Image[#ImageIcon_Build]  = LoadImage(#PB_Any,  MainPath + "images/bricks.png")
		If Not *this\Image[#ImageIcon_Build]
			MessageRequester("Error" , "Error while loading " + MainPath + "images/bricks.png")
			ProcedureReturn #False
		EndIf
		*this\Image[#ImageIcon_Directory]  = LoadImage(#PB_Any,  MainPath + "images/folder.png")
		If Not *this\Image[#ImageIcon_Directory]
			MessageRequester("Error" , "Error while loading " + MainPath + "images/folder.png")
			ProcedureReturn #False
		EndIf
		*this\Image[#ImageIcon_FileTree]  = LoadImage(#PB_Any,  MainPath + "images/page_white_text.png")
		If Not *this\Image[#ImageIcon_FileTree]
			MessageRequester("Error" , "Error while loading " + MainPath + "images/page_white_text.png")
			ProcedureReturn #False
		EndIf
		*this\Image[#ImageIcon_CodeComment]  = LoadImage(#PB_Any,  MainPath + "images/comment.png")
		If Not *this\Image[#ImageIcon_CodeComment]
			MessageRequester("Error" , "Error while loading " + MainPath + "images/comment.png")
			ProcedureReturn #False
		EndIf
		*this\Image[#ImageIcon_ProjectExport]  = LoadImage(#PB_Any,  MainPath + "images/folder_go.png")
		If Not *this\Image[#ImageIcon_ProjectExport]
			MessageRequester("Error" , "Error while loading " + MainPath + "images/folder_go.png")
			ProcedureReturn #False
		EndIf
		;}
		;=====================================================
		;
		;-Fenetre principale
		;
		;=====================================================
		;{
		;-PopupMenu
		Flag = #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget |#PB_Window_Maximize | #PB_Window_Invisible | #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget
		*this\Window[#WIN_Main] = OpenWindow(#PB_Any , 0, 0, 800, 600, Title,  Flag)
		If *this\Window[#WIN_Main]
			AddKeyboardShortcut(*this\Window[0], #PB_Shortcut_Control |  #PB_Shortcut_N, #new)
			AddKeyboardShortcut(*this\Window[0], #PB_Shortcut_Control |  #PB_Shortcut_P, #NewProject)
			CompilerIf #PB_Compiler_OS =  #PB_OS_Windows
				AddKeyboardShortcut(*this\Window[0], #PB_Shortcut_Tab, #TabOnly)
			CompilerEndIf
			AddKeyboardShortcut(*this\Window[0], #PB_Shortcut_Control |  #PB_Shortcut_W, #close)
			AddKeyboardShortcut(*this\Window[0], #PB_Shortcut_Control |  #PB_Shortcut_S, #save)
			AddKeyboardShortcut(*this\Window[0], #PB_Shortcut_Control |  #PB_Shortcut_O, #open)
			AddKeyboardShortcut(*this\Window[0], #PB_Shortcut_Control |  #PB_Shortcut_F, #search)
			AddKeyboardShortcut(*this\Window[0], #PB_Shortcut_Control |  #PB_Shortcut_Q, #quit)
			AddKeyboardShortcut(*this\Window[0], #PB_Shortcut_Control |  #PB_Shortcut_I, #AutoIndent)
			AddKeyboardShortcut(*this\Window[0], #PB_Shortcut_Control |  #PB_Shortcut_B, #CommentText)
			AddKeyboardShortcut(*this\Window[0], #PB_Shortcut_Alt  |  #PB_Shortcut_B, #UnCommentText)
			; 		AddKeyboardShortcut(*this\Window[0], #PB_Shortcut_Control |  #PB_Shortcut_C, #Copy)
			AddKeyboardShortcut(*this\Window[0], #PB_Shortcut_F6, #CompilerProject)
			AddKeyboardShortcut(*this\Window[0], #PB_Shortcut_F5, #compiler)
			AddKeyboardShortcut(*this\Window[0], #PB_Shortcut_F9, #SwitchStructure)
			;-menu
			*this\menu[#Menu_ProjectFile] = CreatePopupMenu(#PB_Any)
			If *this\menu[#Menu_ProjectFile]
				MenuItem(#RemoveFile, GetText("ProjectMenu-DeleteFile"))
			EndIf
			*this\menu[#Menu_ProjectDirectory] = CreatePopupMenu(#PB_Any)
			If *this\menu[#Menu_ProjectDirectory]
				MenuItem(#RemoveDirectory, GetText("ProjectMenu-DeleteDirectory"))
				OpenSubMenu(GetText("ProjectMenu-AddFile"))
				MenuItem(#AddEmptyFile, GetText("ProjectMenu-AddEmptyFile") )
				MenuItem(#AddFileFromFile, GetText("ProjectMenu-AddFileFromFile") )
			EndIf
			*this\menu[#Menu_Main] =  CreateMenu(#PB_Any, WindowID(*this\Window[#WIN_Main]))
			If *this\menu[#Menu_Main]
				MenuTitle(GetText("GeneralMenu-File"))
				OpenSubMenu(GetText("GeneralMenu-New"))
				MenuItem(#New, GetText("GeneralMenu-NewSource")   +Chr(9)+"Ctrl+N")
				MenuItem(#NewProject, GetText("GeneralMenu-NewProject")   +Chr(9)+"Ctrl+P")
				CloseSubMenu()
				MenuItem(#Open, GetText("GeneralMenu-Open")   +Chr(9)+"Ctrl+O")
				MenuItem(#Save, GetText("GeneralMenu-Save")   +Chr(9)+"Ctrl+S")
				;MenuItem(#SaveAs, GetText("GeneralMenu-SaveAs"))
				MenuItem(#Close, GetText("GeneralMenu-Close") +Chr(9)+"Ctrl+W")
				;MenuItem(#CloseAll, GetText("GeneralMenu-CloseAll")  )
				MenuBar()
				MenuItem(#Option, GetText("GeneralMenu-Options"))
				MenuBar()
				OpenSubMenu(GetText("GeneralMenu-History"))
				temp = *system\Prefs.GetPreference("GENERAL", "History")
				If Len(temp)
					If FindString(temp, ";", 1) = 0
						*this\History[0] = MenuItem(#PB_Any, temp)
					Else
						For n = 1 To CountString(temp, ";") + 1
							*this\History[n - 1] = MenuItem(#PB_Any, StringField(temp, n, ";"))
						Next n
					EndIf
				EndIf
				
				CloseSubMenu()
				MenuBar()
				MenuItem(#Quit, GetText("GeneralMenu-Quit")+Chr(9)+"Ctrl+Q")
				MenuTitle(GetText("GeneralMenu-Edit"))
				MenuItem(#AutoIndent, GetText("GeneralMenu-AutoIndent")   +Chr(9)+"Ctrl+I")
				MenuBar()
				MenuItem(#Undo, GetText("GeneralMenu-Undo")   +Chr(9)+"Ctrl+Z")
				MenuItem(#Redo, GetText("GeneralMenu-Redo")   +Chr(9)+"Ctrl+Y")
				DisableMenuItem(*this\menu[0],#undo,1)
				DisableMenuItem(*this\menu[0],#redo,1)
				MenuBar()
				MenuItem(#CommentText, "Add comment"   +Chr(9)+"Ctrl+B")
				MenuItem(#UnCommentText, "Remove comment"   +Chr(9)+"Alt+B")
				;MenuBar()
				;MenuItem(#Cut, GetText("GeneralMenu-Cut")   +Chr(9)+"Ctrl+X")
				;MenuItem(#Copy, GetText("GeneralMenu-Copy")   +Chr(9)+"Ctrl+C")
				;MenuItem(#Paste, GetText("GeneralMenu-Paste")   +Chr(9)+"Ctrl+V")
				;DisableMenuItem(*this\menu[0],#Paste,1)
				MenuBar()
				MenuItem(#SlctAll, GetText("GeneralMenu-SelectAll")   +Chr(9)+"Ctrl+A")
				MenuBar()
				MenuItem(#Search, GetText("GeneralMenu-Find")+Chr(9)+"Ctrl+F")
				MenuTitle(GetText("GeneralMenu-Compiler"))
				MenuItem(#DebugerOn, "Debuger")
				SetMenuItemState(*this\menu[#Menu_Main], #DebugerOn, #True)
				MenuItem(#Compiler, GetText("GeneralMenu-CompilerFile")+Chr(9)+"F5")
				MenuItem(#CompilerProject, GetText("GeneralMenu-CompilerProject")+Chr(9)+"F6")
				MenuItem(#SwitchStructure, GetText("GeneralMenu-SwitchStructure")+Chr(9)+"F9")
				MenuItem(#CompilerOptions, GetText("GeneralMenu-CompileOption"))
				MenuItem(#BuildCurrentFile, GetText("GeneralMenu-BuildFile"))
				MenuItem(#BuildSourceCurrentFile, "Precompile Source")
				If *system\Prefs.GetPreference("GENERAL", "structure") = "X64" And FileSize(*system\Prefs.GetPreference("X64", "Compiler Path") + #PB_CompilerName) > 0
					If FileSize(*system\Prefs.GetPreference("X86", "Compiler Path") + #PB_CompilerName) < 0
						DisableMenuItem(*this\menu[0], #SwitchStructure, 1)
					EndIf
				ElseIf FileSize(*system\Prefs.GetPreference("X86", "Compiler Path") + #PB_CompilerName) > 0
					If FileSize(*system\Prefs.GetPreference("X64", "Compiler Path") + #PB_CompilerName) < 0
						DisableMenuItem(*this\menu[0], #SwitchStructure, 1)
					EndIf
				Else
					DisableMenuItem(*this\menu[0], #Compiler, 1)
					DisableMenuItem(*this\menu[0], #CompilerProject, 1)
				EndIf
				MenuTitle(GetText("GeneralMenu-Tools"))
				MenuItem(#GenerateDoc, "DocGenerator")
				DisableMenuItem(*this\menu[0], #GenerateDoc, 1)
				MenuItem(#TemplateMaker, "TemplateMaker")
			EndIf
			*this\ToolBar[0] = CreateToolBar(#PB_Any, WindowID(*this\Window[0]))
			If *this\ToolBar[0]
				ToolBarStandardButton(#new, #PB_ToolBarIcon_New)
				ToolBarStandardButton(#open, #PB_ToolBarIcon_Open)
				ToolBarStandardButton(#save, #PB_ToolBarIcon_Save)
				ToolBarStandardButton(#close, #PB_ToolBarIcon_Delete)
				ToolBarSeparator()
				ToolBarStandardButton(#search, #PB_ToolBarIcon_Find)
				;ToolBarSeparator()
				;ToolBarStandardButton(#cut, #PB_ToolBarIcon_Cut)
				;ToolBarStandardButton(#copy, #PB_ToolBarIcon_Copy)
				;ToolBarStandardButton(#paste, #PB_ToolBarIcon_Paste)
				ToolBarSeparator()
				ToolBarStandardButton(#undo, #PB_ToolBarIcon_Undo)
				ToolBarStandardButton(#redo, #PB_ToolBarIcon_Redo)
			EndIf
			*this\StatusBar[0] = CreateStatusBar(#PB_Any, WindowID(*this\Window[0]))
			If *this\StatusBar[0]
				AddStatusBarField(200)
				AddStatusBarField(#PB_Ignore)
			Else
				*System.SystemEnd()
			EndIf
			
			If UseGadgetList(WindowID(*this\Window[#WIN_Main]))
				*this\Gadget[#gd_FirstPanel] = PanelGadget(#PB_Any, 0, 0, 0, 0)
				CloseGadgetList()
				UseGadgetList(WindowID(*this\Window[#WIN_Main]))
				*this\Gadget[#gd_SecondPanel] = EditorGadget(#PB_Any, 0, 0, 0, 0, #PB_String_ReadOnly)
				UseGadgetList(WindowID(*this\Window[#WIN_Main]))
				*this\Gadget[#gd_MainPanel] = PanelGadget(#PB_Any, 0, 0, 0, 0)
				EnableGadgetDrop(*this\Gadget[#gd_MainPanel], #PB_Drop_Files, #PB_Drag_Copy)
				AddGadgetItem(*this\Gadget[#gd_FirstPanel], -1, GetText("MainWindow-Explorer"))
				*this\Gadget[#gd_Explorer] = ExplorerTreeGadget(#PB_Any, 0, 0, 0, 0, "*.pb;*.pbi;*.chp")
				CloseGadgetList()
				;*this\Gadget[#GD_FirstSplitter] = SplitterGadget(#PB_Any, 0, 0, 0, 0, *this\Gadget[#gd_MainPanel], *this\Gadget[#gd_SecondPanel], #PB_Splitter_Separator)
			EndIf
			;}
			;=====================================================
			;
			;-Creation de template
			;
			;=====================================================
			;{
			*this\Window[#WIN_TemplateMaker] = OpenWindow(#PB_Any, 392, 360, 431, 300, "",  #PB_Window_Invisible | #PB_Window_SystemMenu | #PB_Window_ScreenCentered, WindowID(*this\Window[0]))
			If *this\Window[#WIN_TemplateMaker]
				UseGadgetList(WindowID(*this\Window[#WIN_TemplateMaker]))
				TextGadget(#PB_Any, 10, 100, 90, 20, "Icon :")
				TextGadget(#PB_Any, 10, 40, 90, 20, "Sources :")
				TextGadget(#PB_Any, 10, 70, 90, 20, "Medias :")
				*this\Gadget[#GD_TemplateSourcesPath] = StringGadget(#PB_Any, 110, 40, 190, 20, "", #PB_String_ReadOnly)
				*this\Gadget[#GD_TemplateMediaPath] = StringGadget(#PB_Any, 110, 70, 190, 20, "", #PB_String_ReadOnly)
				*this\Gadget[#GD_TemplateIconPath] = StringGadget(#PB_Any, 110, 100, 190, 20, "", #PB_String_ReadOnly)
				*this\Gadget[#GD_SelectTemplateSourcesPath] = ButtonGadget(#PB_Any, 320, 40, 100, 25, "Browse")
				*this\Gadget[#GD_SelectTemplateMediaPath] = ButtonGadget(#PB_Any, 320, 70, 100, 25, "Browse")
				*this\Gadget[#GD_SelectTemplateIcon] = ButtonGadget(#PB_Any, 320, 100, 100, 25, "Browse")
				TextGadget(#PB_Any, 10, 130, 90, 20, "Type :")
				*this\Gadget[#GD_ChooseTemplateType] = ComboBoxGadget(#PB_Any, 110, 130, 190, 25)
				AddGadgetItem(*this\Gadget[#GD_ChooseTemplateType], 0, "Application")
				AddGadgetItem(*this\Gadget[#GD_ChooseTemplateType], 1, "Static library")
				AddGadgetItem(*this\Gadget[#GD_ChooseTemplateType], 2, "Dynamic library")
				SetGadgetState(*this\Gadget[#GD_ChooseTemplateType], 0)
				*this\Gadget[#GD_CreateTemplate] = ButtonGadget(#PB_Any, 320, 240, 100, 50, "Create")
				TextGadget(#PB_Any, 10, 10, 90, 20, "Name :")
				*this\Gadget[#GD_NewTemplateName] = StringGadget(#PB_Any, 110, 10, 190, 20, "")
				*this\Gadget[#GD_NewTemplateASM] = CheckBoxGadget(#PB_Any, 10, 160, 180, 20, "ASM")
				*this\Gadget[#GD_NewTemplateUnicode] = CheckBoxGadget(#PB_Any, 10, 180, 180, 20, "Unicode")
				*this\Gadget[#GD_NewTemplateThreadSafe] = CheckBoxGadget(#PB_Any, 10, 200, 180, 20, "ThreadSafe")
				*this\Gadget[#GD_NewTemplateOnError] = CheckBoxGadget(#PB_Any, 10, 220, 180, 20, "On Error")
				*this\Gadget[#GD_NewTemplateXPSkin] = CheckBoxGadget(#PB_Any, 10, 240, 180, 20, "XP Skin")
				*this\Gadget[#GD_NewTemplateAdminMode] = CheckBoxGadget(#PB_Any, 10, 260, 180, 20, "Administrator mode")
				*this\Gadget[#GD_NewTemplateUserMode] = CheckBoxGadget(#PB_Any, 210, 160, 160, 20, "User mode")
				*this\Gadget[#GD_NewTemplatePrecompiler] = CheckBoxGadget(#PB_Any, 210, 180, 160, 20, "Precompiler")
			Else
				ProcedureReturn #False
			EndIf
			;}
			;=====================================================
			;
			;-Option de compilation
			;
			;=====================================================
			;{
			*this\Window[#WIN_OptionCompilation] = OpenWindow(#PB_Any,0,0,400,230,GetText("OptionCompilation-Window"), #PB_Window_Invisible | #PB_Window_SystemMenu | #PB_Window_ScreenCentered, WindowID(*this\Window[0]))
			If *this\Window[#WIN_OptionCompilation]
				If UseGadgetList(WindowID(*this\Window[#WIN_OptionCompilation]))
					*this\Gadget[#GD_CancelSetCompilerOption] = ButtonGadget(#PB_Any, 210, 190, 180, 30, GetText("Misc-Cancel"))
					*this\Gadget[#GD_ConfirmSetCompilerOption] = ButtonGadget(#PB_Any, 20, 190, 180, 30, GetText("Misc-Confim"))
					*this\Gadget[#GD_EnableASM] = CheckBoxGadget(#PB_Any, 20, 20, 360, 20, GetText("OptionCompilation-ASM"))
					*this\Gadget[#GD_EnableUnicode] = CheckBoxGadget(#PB_Any, 20, 40, 360, 20, GetText("OptionCompilation-Unicode"))
					*this\Gadget[#GD_EnableSafeThread] = CheckBoxGadget(#PB_Any, 20, 60, 360, 20, GetText("OptionCompilation-SafeThread"))
					*this\Gadget[#GD_EnableOnError] = CheckBoxGadget(#PB_Any, 20, 80, 360, 20, GetText("OptionCompilation-OnError"))
					*this\Gadget[#GD_EnableXPSkin] = CheckBoxGadget(#PB_Any, 20, 100, 360, 20, GetText("OptionCompilation-XPSkin"))
					*this\Gadget[#GD_EnableAdministratorMode] = CheckBoxGadget(#PB_Any, 20, 120, 360, 20, GetText("OptionCompilation-Administrator"))
					*this\Gadget[#GD_EnableUserMode] = CheckBoxGadget(#PB_Any, 20, 140, 360, 20, GetText("OptionCompilation-UserMode"))
					*this\Gadget[#GD_EnablePrecompiler] = CheckBoxGadget(#PB_Any, 20, 160, 360, 20, GetText("OptionCompilation-Precompiler"))
				EndIf
			Else
				ProcedureReturn #False
			EndIf
			
			;}
			;=====================================================
			;
			;-Fenetre de recherche
			;
			;=====================================================
			;{
			*this\Window[#WIN_Search] = OpenWindow(#PB_Any,  0, 0,  425, 90, GetText("FindWindow-Find"), #PB_Window_Invisible | #PB_Window_SystemMenu | #PB_Window_ScreenCentered, WindowID(*this\Window[0]))
			If *this\Window[#WIN_Search]
				If UseGadgetList(WindowID(*this\Window[1]))
					*this\Gadget[#GD_SearchString] =StringGadget(#PB_Any, 120, 1, 300, 25, "")
					TextGadget(#PB_Any, 1, 1, 100, 40, GetText("FindWindow-Find") )
					*this\Gadget[#GD_SearchReplaceString] =StringGadget(#PB_Any, 120, 30, 300, 25, "")
					TextGadget(#PB_Any, 1, 30, 100, 40, GetText("FindWindow-ReplaceBy") )
					
					
					*this\Gadget[#GD_SearchNext] =ButtonGadget(#PB_Any, 10, 60, 125, 25, GetText("FindWindow-FindNext"))
					*this\Gadget[#GD_SearchReplace] =ButtonGadget(#PB_Any, 150, 60, 125, 25, GetText("FindWindow-Replace"))
					*this\Gadget[#GD_SearchReplaceAll] =ButtonGadget(#PB_Any, 290,60, 125, 25, GetText("FindWindow-ReplaceAll"))
				EndIf
			Else
				ProcedureReturn #False
			EndIf
			;}
			;=====================================================
			;
			;-Fenetre de creation de projet
			;
			;=====================================================
			;{
			*this\Window[#WIN_NewProject] = OpenWindow(#PB_Any,0,0,500,200,GetText("NewProjectWindow-New"), #PB_Window_Invisible | #PB_Window_SystemMenu | #PB_Window_ScreenCentered, WindowID(*this\Window[0]))
			If *this\Window[#WIN_NewProject]
				If UseGadgetList(WindowID(*this\Window[#WIN_NewProject]))
					*this\Gadget[#GD_TreeTemplate] = TreeGadget(#PB_Any, 0, 0, 200, 200 , #PB_Tree_NoLines | #PB_Tree_AlwaysShowSelection)
					TextGadget(#PB_Any, 203, 3, 200, 20, GetText("NewProjectWindow-Name"))
					*this\Gadget[#GD_NameNewProject] = StringGadget(#PB_Any, 301, 1, 198, 20, "")
					TextGadget(#PB_Any, 203, 23, 200, 20, GetText("NewProjectWindow-Directory"))
					*this\Gadget[#GD_PathNewProject] = StringGadget(#PB_Any, 301, 21, 198, 20, "")
					*this\Gadget[#GD_SetPathNewProject] = ButtonGadget(#PB_Any,  300,  50, 80, 30,GetText("NewProjectWindow-Browse"))
					*this\Gadget[#GD_CreateNewProject] = ButtonGadget(#PB_Any,  250,  165, 80, 30, GetText("NewProjectWindow-Create"))
					*this\Gadget[#GD_CancelNewProject] = ButtonGadget(#PB_Any,  350,  165, 80, 30, GetText("NewProjectWindow-Cancel"))
				EndIf
			Else
				ProcedureReturn #False
			EndIf
			;}
			;=====================================================
			;
			;-Fenetre d'option de projet
			;
			;=====================================================
			;{
			*this\Window[#WIN_OptionProject] =  OpenWindow(#PB_Any,0,0,600,400,GetText("AddCompiler-Title"), #PB_Window_Invisible | #PB_Window_ScreenCentered, WindowID(*this\Window[0]))
			If *this\Window[#WIN_OptionProject]
				If UseGadgetList(WindowID(*this\Window[#WIN_OptionProject]))
					*this\Gadget[#GD_CancelProjectOption] = ButtonGadget(#PB_Any, 320, 360, 180, 30, GetText("Misc-Cancel"))
					*this\Gadget[#GD_ConfirmProjectOption] = ButtonGadget(#PB_Any, 90, 360, 180, 30, GetText("Misc-Confim"))
					*this\Gadget[#GD_EnableProjectASM] = CheckBoxGadget(#PB_Any, 20, 20, 360, 20, GetText("OptionCompilation-ASM"))
					*this\Gadget[#GD_EnableProjectUnicode] = CheckBoxGadget(#PB_Any, 20, 40, 360, 20, GetText("OptionCompilation-Unicode"))
					*this\Gadget[#GD_EnableProjectSafeThread] = CheckBoxGadget(#PB_Any, 20, 60, 360, 20, GetText("OptionCompilation-SafeThread"))
					*this\Gadget[#GD_EnableProjectOnError] = CheckBoxGadget(#PB_Any, 20, 80, 360, 20, GetText("OptionCompilation-OnError"))
					*this\Gadget[#GD_EnableProjectXPSkin] = CheckBoxGadget(#PB_Any, 20, 100, 360, 20, GetText("OptionCompilation-XPSkin"))
					*this\Gadget[#GD_EnableProjectAdministratorMode] = CheckBoxGadget(#PB_Any, 20, 120, 360, 20, GetText("OptionCompilation-Administrator"))
					*this\Gadget[#GD_EnableProjectUserMode] = CheckBoxGadget(#PB_Any, 20, 140, 360, 20, GetText("OptionCompilation-UserMode"))
					*this\Gadget[#GD_EnableProjectPrecompiler] = CheckBoxGadget(#PB_Any, 20, 160, 360, 20, GetText("OptionCompilation-Precompiler"))
					TextGadget(#PB_Any, 20, 180, 100, 20, "Type :")
					*this\Gadget[#GD_ProjectTypeList] = ComboBoxGadget(#PB_Any, 100, 180, 100, 2)
					AddGadgetItem(*this\Gadget[#GD_ProjectTypeList], 0, "Application")
					AddGadgetItem(*this\Gadget[#GD_ProjectTypeList], 1, "Static library")
					AddGadgetItem(*this\Gadget[#GD_ProjectTypeList], 2, "Dynamic library")
				EndIf
			Else
				ProcedureReturn #False
			EndIf
			;}
			;=====================================================
			;
			;-Fenetre d'options
			;
			;=====================================================
			;{
			*this\Window[#WIN_Option] = OpenWindow(#PB_Any,0,0,600,400,GetText("AddCompiler-Title"), #PB_Window_Invisible | #PB_Window_ScreenCentered, WindowID(*this\Window[0]))
			If *this\Window[#WIN_Option]
				
				If UseGadgetList(WindowID(*this\Window[#WIN_Option]))
					*this\Gadget[#GD_TreeOption] = TreeGadget(#PB_Any, 10, 10, 150, 380)
					AddGadgetItem(*this\Gadget[#GD_TreeOption], -1, "General", 0, 0)
					AddGadgetItem(*this\Gadget[#GD_TreeOption], -1, "Language", 0, 1)
					AddGadgetItem(*this\Gadget[#GD_TreeOption], -1, "Editor", 0, 0)
					AddGadgetItem(*this\Gadget[#GD_TreeOption], -1, "Color", 0, 1)
					AddGadgetItem(*this\Gadget[#GD_TreeOption], -1, "Compiler", 0, 0)
					AddGadgetItem(*this\Gadget[#GD_TreeOption], -1, "Path", 0, 1)
					
					;=====================================================
					;
					;-Option Language
					;
					;=====================================================
					;{
					*this\Gadget[#GD_FrameLanguage] = Frame3DGadget(#PB_Any, 170, 10, 420, 55, "Language")
					*this\Gadget[#GD_ListLanguage] = ComboBoxGadget(#PB_Any, 175, 30, 400, 25)
					Protected *Group.Group
					For n = 1 To *Lang.CountGroup()
						*Group = *Lang.GetGroupNumber(n)
						AddGadgetItem(*this\Gadget[#GD_ListLanguage], -1, *Group\Name)
					Next n
					;}
					;=====================================================
					;
					;-Option Couleurs
					;
					;=====================================================
					;{
					Protected Dim ColorText.s(10), i
					ColorText(0) = "Text" + Chr(9)
					ColorText(1) = "KeyWord "
					ColorText(2) = "Function"
					ColorText(3) = "Constant"
					ColorText(4) = "String" + Chr(9)
					ColorText(5) = "Operator"
					ColorText(6) = "Comment "
					*this\Gadget[#GD_FrameColor] = Frame3DGadget(#PB_Any, 170, 10, 420, 300, "Color")
					For n = #ImageColor_Text To #ImageColor_Comment
						*this\Image[n] = CreateImage(#PB_Any, 100, 20)
						If StartDrawing(ImageOutput(*this\Image[n]))
							Box(0,0, 100, 20, RGB(255,255,255))
							StopDrawing()
						EndIf
					Next n
					
					i = #GD_ImageColor_Text
					For n = #GD_TextColor_Text To #GD_TextColor_Comment
						*this\Gadget[n] = TextGadget(#PB_Any, 180, 25 + 20*(n - #GD_TextColor_Text), 200, 20, ColorText(n - #GD_TextColor_Text) + Chr(9) + ":")
						*this\Gadget[i] = ButtonImageGadget(#PB_Any, 520, 25 + 20*(n - #GD_TextColor_Text), 50, 20, ImageID(*this\Image[n - #GD_TextColor_Text]))
						i + 1
					Next n
					;}
					;=====================================================
					;
					;-Option Chemins
					;
					;=====================================================
					;{
					*this\Gadget[#GD_FramePath] = Frame3DGadget(#PB_Any, 170, 10, 420, 75, "Path")
					*this\Gadget[#GD_X86Path_Text] = TextGadget(#PB_Any, 175, 25, 150, 20, "X86 Compiler Path :")
					*this\Gadget[#GD_X64Path_Text] = TextGadget(#PB_Any, 175, 55, 150, 20, "X64 Compiler Path :")
					*this\Gadget[#GD_X86Path] = StringGadget(#PB_Any, 330, 25, 150, 20, *system\Prefs.GetPreference("X86", "Compiler Path"), #PB_String_ReadOnly)
					*this\Gadget[#GD_X64Path] = StringGadget(#PB_Any, 330, 55, 150, 20, *system\Prefs.GetPreference("X86", "Compiler Path"), #PB_String_ReadOnly)
					*this\Gadget[#GD_X86Path_Select] = ButtonGadget(#PB_Any, 490, 25, 80, 25, GetText("Misc-Browse"))
					*this\Gadget[#GD_X64Path_Select] = ButtonGadget(#PB_Any, 490, 50, 80, 25, GetText("Misc-Browse"))
					
					;}
					*this\Gadget[#GD_OptionConfirm] = ButtonGadget(#PB_Any,  330,  WindowHeight(*this\Window[#WIN_Option]) - 40, 80, 30, GetText("Commons-Confirm"))
					*this\Gadget[#GD_OptionCancel] = ButtonGadget(#PB_Any,  420, WindowHeight(*this\Window[#WIN_Option]) - 40, 80, 30, GetText("Commons-Cancel"))
					*this\Gadget[#GD_OptionDone] = ButtonGadget(#PB_Any,  510,  WindowHeight(*this\Window[#WIN_Option]) - 40, 80, 30, GetText("Commons-Apply"))
				EndIf
			Else
				ProcedureReturn #False			
			EndIf
			;}
		Else
			ProcedureReturn #False
		EndIf
		ProcedureReturn #True
	EndProcedure
	
	Procedure AddNode(*Node.Node, Level.l = 0)
		Protected n, Count = *Node.countChild(), ImageID.l, Text.s, *Child.Node
		Protected *Directory.Directory, *File.File, *Comment.Comment::Item
		Select *Node\Type
			Case #Node_Directory
				*Directory = *Node
				ImageID = *this\Image[#ImageIcon_Directory]
				Text = *Directory.GetNodeName()
			Case #Node_RootComment
				ImageID = *this\Image[#ImageIcon_CodeComment]
				Text = "Comment"
			Case #Node_File
				ImageID = *this\Image[#ImageIcon_FileTree]
				*File = *Node
				Text = GetFilePart(*File.GetPath())
			Case #Node_Comment
				ImageID = *this\Image[#ImageIcon_CodeComment]
				*Comment = *Node
				Text = *Comment.GetName()
		EndSelect
		AddGadgetItem(*this\Gadget[#GD_TreeProject], -1, Text, ImageID(ImageID), Level)
		For n = 1 To Count
			*Child = *Node.GetChildNode(n)
			If *Child
				*this.AddNode(*Child, Level + 1)
			Else
				debug "erreur"
			EndIf
		Next n
	EndProcedure
EndClass


Procedure SetStatusBarText(*this.IHM, Champ, txt.s)
	If champ = 0
		StatusBarText(*this\StatusBar[0], Champ, txt, #PB_StatusBar_Center)
	Else
		StatusBarText(*this\StatusBar[0], Champ, txt)
	EndIf
EndProcedure

Procedure NewScintillaGadget(*this.IHM, PanelName.s)
	AddGadgetItem(*this\Gadget[#gd_MainPanel], CountGadgetItems(*this\Gadget[#gd_MainPanel]), PanelName)	
	Protected *ptr.Scintilla = New Scintilla(0, 0, GetGadgetAttribute(*this\Gadget[#gd_MainPanel], #PB_Panel_ItemWidth), GetGadgetAttribute(*this\Gadget[#gd_MainPanel], #PB_Panel_ItemHeight), @ScintillaCallBack())
	EnableGadgetDrop(*ptr, #PB_Drop_Files, #PB_Drag_Copy)
	;lexer vide
	*ptr.SetLexer(#SCLEX_CONTAINER, 0)
	
	; Set default font
	*ptr.StyleClearAll()
	*ptr.StyleSetFont(#STYLE_DEFAULT, "Courier")
	*ptr.StyleSetSize(#STYLE_DEFAULT, 10)
	
	; Set caret line colour
	*ptr.SetCaretLineBack($00FFFF)
	*ptr.SetCaretLineVisible(#True)
	
	; Set styles for custom lexer
	*ptr.StyleSetFore(#LexerState_Comment, Val(*system\Prefs.GetPreference("Color", "Comment")))
	*ptr.StyleSetFore(#LexerState_NonKeyword, 0)
	*ptr.StyleSetFore(#LexerState_Keyword, Val(*system\Prefs.GetPreference("Color", "KeyWord")))
	*ptr.StyleSetBold(#LexerState_Keyword, #True)
	*ptr.StyleSetFore(#LexerState_Constant, Val(*system\Prefs.GetPreference("Color", "Constant")))
	*ptr.StyleSetFore(#LexerState_String, Val(*system\Prefs.GetPreference("Color", "String")))
	*ptr.StyleSetFore(#LexerState_Function, Val(*system\Prefs.GetPreference("Color", "Function")))
	*ptr.StyleSetFore(#LexerState_Operator, Val(*system\Prefs.GetPreference("Color", "Operator")))
	
	; Margins
	*ptr.SetMarginTypeN(0, #SC_MARGIN_NUMBER)
	*ptr.SetMarginMaskN(2, #SC_MASK_FOLDERS)
	*ptr.SetMarginWidthN(0, 20)
	*ptr.SetMarginWidthN(1, 5)
	*ptr.SetMarginWidthN(2, 15)
	*ptr.SetMarginSensitiveN(2, #True)
	
	; Choose folding icons
	*ptr.MarkerDefine(#SC_MARKNUM_FOLDEROPEN, #SC_MARK_BOXMINUS)
	*ptr.MarkerDefine(#SC_MARKNUM_FOLDER, #SC_MARK_BOXPLUS)
	*ptr.MarkerDefine(#SC_MARKNUM_FOLDERSUB, #SC_MARK_VLINE)
	*ptr.MarkerDefine(#SC_MARKNUM_FOLDERTAIL, #SC_MARK_LCORNERCURVE)
	*ptr.MarkerDefine(#SC_MARKNUM_FOLDEREND, #SC_MARK_BOXPLUS)
	*ptr.MarkerDefine(#SC_MARKNUM_FOLDEROPENMID, #SC_MARK_BOXMINUS)
	*ptr.MarkerDefine(#SC_MARKNUM_FOLDERMIDTAIL, #SC_MARK_TCORNERCURVE)
	
	; Choose folding icon colours
	*ptr.MarkerSetFore(#SC_MARKNUM_FOLDEROPEN, $FFFFFF)
	*ptr.MarkerSetBack(#SC_MARKNUM_FOLDEROPEN, 0)
	*ptr.MarkerSetFore(#SC_MARKNUM_FOLDER, $FFFFFF)
	*ptr.MarkerSetBack(#SC_MARKNUM_FOLDER, 0)
	*ptr.MarkerSetFore(#SC_MARKNUM_FOLDERSUB, $FFFFFF)
	*ptr.MarkerSetBack(#SC_MARKNUM_FOLDERSUB, 0)
	*ptr.MarkerSetFore(#SC_MARKNUM_FOLDERTAIL, $FFFFFF)
	*ptr.MarkerSetBack(#SC_MARKNUM_FOLDERTAIL, 0)
	*ptr.MarkerSetFore(#SC_MARKNUM_FOLDEREND, $FFFFFF)
	*ptr.MarkerSetBack(#SC_MARKNUM_FOLDEREND, 0)
	*ptr.MarkerSetFore(#SC_MARKNUM_FOLDEROPENMID, $FFFFFF)
	*ptr.MarkerSetBack(#SC_MARKNUM_FOLDEROPENMID, 0)
	*ptr.MarkerSetFore(#SC_MARKNUM_FOLDERMIDTAIL, $FFFFFF)
	*ptr.MarkerSetBack(#SC_MARKNUM_FOLDERMIDTAIL, 0)
	
	*ptr.AutoIgnoreCase(#True)
	
	*ptr.SetIndent(0)
	*ptr.SetTabIdents(#True)
	*ptr.SetBackSpaceUnindents(#True)
	
	*ptr.SetEOLMode(#SC_EOL_LF)
	*ptr.SetTabWidth(3)
	*ptr.SetUseTabs(#True)
	*ptr.SetIndentationGuides(#True)
	
	SetGadgetState(*this\Gadget[#gd_MainPanel], CountGadgetItems(*this\Gadget[#gd_MainPanel]) - 1)
	ProcedureReturn *Ptr
EndProcedure

Procedure IHM_SetCurrentOption(*this.IHM, Option)
	Protected n, txt.s
	For n = #GD_FrameLanguage To #GD_X64Path_Select
		HideGadget(*this\Gadget[n], 1)
	Next n
	Select Option
		Case #OptionLang
			For n = #GD_FrameLanguage To #GD_ListLanguage
				HideGadget(*this\Gadget[n], 0)
			Next n
		Case #OptionColor
			For n = #ImageColor_Text To #ImageColor_Comment
				If StartDrawing(ImageOutput(*this\Image[n]))
					Select n
						Case #ImageColor_Text
							txt = "Text"
						Case #ImageColor_KeyWord
							txt = "KeyWord"
						Case #ImageColor_Function
							txt = "Function"
						Case #ImageColor_Constant
							txt = "Constant"
						Case #ImageColor_String
							txt = "String"
						Case #ImageColor_Operator
							txt = "Operator"
						Case #ImageColor_Comment
							txt = "Comment"
					EndSelect
					Box(0,0, 100, 20, Val(*system\Prefs.GetPreference("Color", txt)))
					StopDrawing()
				EndIf
			Next n
			For n = #GD_FrameColor To #GD_ImageColor_Comment
				If IsGadget(*this\Gadget[n])
					HideGadget(*this\Gadget[n], 0)
				EndIf
			Next n
		Case #OptionCompiler
			SetGadgetText(*this\Gadget[#GD_X86Path], *system\Prefs.GetPreference("X86", "Compiler Path"))
			SetGadgetText(*this\Gadget[#GD_X64Path], *system\Prefs.GetPreference("X64", "Compiler Path"))
			For n = #GD_FramePath To #GD_X64Path_Select
				If IsGadget(*this\Gadget[n])
					HideGadget(*this\Gadget[n], 0)
				EndIf
			Next n
	EndSelect
EndProcedure

Procedure ShowWindow(*this.IHM, numero.i)
	Protected n, *Project.Project
	Select numero
		Case #WIN_OptionProject
			*Project = *System.GetCurrentProject()
			Select *Project.GetMode()
				Case #ProjectIsApp
					SetGadgetState(*this\Gadget[#GD_ProjectTypeList], 0)
				Case #ProjectIsDynamicLib
					SetGadgetState(*this\Gadget[#GD_ProjectTypeList], 2)
				Case #ProjectIsStaticLib
					SetGadgetState(*this\Gadget[#GD_ProjectTypeList], 1)
			EndSelect
			SetGadgetState(*this\Gadget[#GD_EnableProjectSafeThread], *System\OpenProject\SafeThread )
			SetGadgetState(*this\Gadget[#GD_EnableProjectUnicode], *System\OpenProject\Unicode)
			SetGadgetState(*this\Gadget[#GD_EnableProjectASM], *System\OpenProject\ASM)
			SetGadgetState(*this\Gadget[#GD_EnableProjectOnError], *System\OpenProject\OnError)
			SetGadgetState(*this\Gadget[#GD_EnableProjectXPSkin], *System\OpenProject\ThemesXP)
			SetGadgetState(*this\Gadget[#GD_EnableProjectAdministratorMode], *System\OpenProject\AdminMode)
			SetGadgetState(*this\Gadget[#GD_EnableProjectUserMode], *System\OpenProject\UserMode)
			SetGadgetState(*this\Gadget[#GD_EnableProjectPrecompiler], *System\OpenProject\Precompilation)
			
			DisableWindow(*this\Window[#WIN_Main] , 1)
		Case #WIN_OptionCompilation
			CompilerIf #PB_Compiler_OS = #PB_OS_Linux
				DisableGadget(*this\Gadget[#GD_EnableXPSkin], 1)
				DisableGadget(*this\Gadget[#GD_EnableAdministratorMode], 1)
				DisableGadget(*this\Gadget[#GD_EnableUserMode], 1)
			CompilerEndIf
			
			If *System\Prefs.GetPreference("Compiler Options", "ASM") = "1"
				SetGadgetState(*this\Gadget[#GD_EnableASM],1)
			EndIf
			If *System\Prefs.GetPreference("Compiler Options", "Unicode") = "1"
				SetGadgetState(*this\Gadget[#GD_EnableUnicode],1)
			EndIf
			If *System\Prefs.GetPreference("Compiler Options", "SafeThread") = "1"
				SetGadgetState(*this\Gadget[#GD_EnableSafeThread],1)
			EndIf
			If *System\Prefs.GetPreference("Compiler Options", "OnError") = "1"
				SetGadgetState(*this\Gadget[#GD_EnableOnError],1)
			EndIf
			If *System\Prefs.GetPreference("Compiler Options", "XPSkin") = "1"
				SetGadgetState(*this\Gadget[#GD_EnableXPSkin],1)
			EndIf
			If *System\Prefs.GetPreference("Compiler Options", "AdministratorMode") = "1"
				SetGadgetState(*this\Gadget[#GD_EnableAdministratorMode],1)
			EndIf
			If *System\Prefs.GetPreference("Compiler Options", "UserMode") = "1"
				SetGadgetState(*this\Gadget[#GD_EnableUserMode],1)
			EndIf
			If *System\Prefs.GetPreference("Compiler Options", "Precompiler") = "1"
				SetGadgetState(*this\Gadget[#GD_EnablePrecompiler],1)
			EndIf
			DisableWindow(*this\Window[#WIN_Main] , 1)
		Case #WIN_Option
			DisableWindow(*this\Window[#WIN_Main] , 1)
			DisableGadget(*this\Gadget[#GD_OptionDone], 1)
			
			;       For n = 0 To CountGadgetItems(*this\Gadget[#GD_TreeOption]) - 1
			;         SetGadgetState(*this\Gadget[#GD_TreeOption], n)
			;       Next n
			For n = 0 To CountGadgetItems(*this\Gadget[#GD_ListLanguage]) - 1
				If GetGadgetItemText(*this\Gadget[#GD_ListLanguage], n) = *system\Prefs.GetPreference("GENERAL", "Lang")
					SetGadgetState(*this\Gadget[#GD_ListLanguage], n)
					Break
				EndIf
			Next n
			;       CompilerIf #PB_Compiler_OS = #PB_OS_Linux
			IHM_SetCurrentOption(*this, #OptionLang)
			;       CompilerElse
			;         SetGadgetState(*this\Gadget[#GD_TreeOption], 1)
			;       CompilerEndIf
		Case #WIN_NewProject
			Protected *Template.Template
			For n = 1 to *System\Template.CountElement()
				*Template = *System\Template.getElement(n)
				AddGadgetItem(*this\Gadget[#GD_TreeTemplate], n, *Template\Name, ImageID(*Template\Icon))
			Next n
			SetGadgetState(*this\Gadget[#GD_TreeTemplate], 0)
			DisableWindow(*this\Window[#WIN_Main] , 1)
		Case #WIN_Search
			SetActiveGadget(*this\Gadget[#GD_SearchString])
	EndSelect
	HideWindow(*this\Window[numero], 0)
EndProcedure

Procedure IHM_HideWindow(*this.IHM, numero.i)
	HideWindow(*this\Window[numero], 1)
	Select numero
		Case #WIN_Option, #WIN_OptionCompilation, #WIN_OptionProject
			DisableWindow(*this\Window[#WIN_Main] , 0)
		Case #WIN_NewProject
			DisableWindow(*this\Window[#WIN_Main] , 0)
			ClearGadgetItems(*this\Gadget[#GD_TreeTemplate])
	EndSelect
EndProcedure

Procedure GetGadget(*this.IHM, numero.i)
	ProcedureReturn *this\Gadget[numero]
EndProcedure

Procedure GetWindow(*this.IHM, numero.i)
	ProcedureReturn *this\Window[numero]
EndProcedure


Procedure ResizeWindows(*this.IHM, number)
	Protected HeightMax, WidthMax, n, *Ptr.Panel
	Select number
		Case  #WIN_Main
			Protected ToolBarHeight.l
			Protected PageStart.l
			
			ToolBarHeight = ToolBarHeight(*this\ToolBar[0])
			CompilerIf #PB_Compiler_OS = #PB_OS_Windows
				PageStart = ToolBarHeight
			CompilerEndIf
			HeightMax = WindowHeight(*this\Window[0]) - MenuHeight() - StatusBarHeight(*this\StatusBar[0])  - ToolBarHeight
			WidthMax = WindowWidth(*this\Window[0])
			ResizeGadget(*this\Gadget[#gd_FirstPanel], WidthMax - 200, PageStart ,  200, HeightMax)
			Protected Height =  GetGadgetAttribute(*this\Gadget[#gd_MainPanel], #PB_Panel_TabHeight ) + 1
			ResizeGadget(*this\Gadget[#gd_MainPanel], 0, PageStart ,  WidthMax - 200, HeightMax - 150)
			If IsGadget(*this\Gadget[#gd_Explorer])
				ResizeGadget(*this\Gadget[#gd_Explorer], 0, 0 ,  GetGadgetAttribute(*this\Gadget[#gd_FirstPanel], #PB_Panel_ItemWidth), GetGadgetAttribute(*this\Gadget[#gd_FirstPanel], #PB_Panel_ItemHeight ))
			EndIf
			ResizeGadget(*this\Gadget[#gd_SecondPanel], 0, HeightMax - 150 + PageStart,  WidthMax - 200, 150)
			If IsGadget(*this\Gadget[#GD_TreeProject])
				ResizeGadget(*this\Gadget[#GD_TreeProject], 0, 40 ,  GetGadgetAttribute(*this\Gadget[#gd_FirstPanel], #PB_Panel_ItemWidth), GetGadgetAttribute(*this\Gadget[#gd_FirstPanel], #PB_Panel_ItemHeight )-40)
			EndIf
			For n=1 To *System\Panel.CountElement()
				*Ptr = *System\Panel.GetElement(n)
				ResizeGadget(*Ptr\ScintillaGadget, 0, 0,   GetGadgetAttribute(*this\Gadget[#gd_MainPanel], #PB_Panel_ItemWidth), GetGadgetAttribute(*this\Gadget[#gd_MainPanel], #PB_Panel_ItemHeight))
			Next n
	EndSelect
EndProcedure

Procedure LoadFile(*this.IHM)
	Protected filename.s = OpenFileRequester("Open a file", "", #ChronosFiltre, 0)
	If filename <> ""
		If LCase(GetExtensionPart(filename)) = "chp"
			*System.OpenProject(filename)
		Else
			*System.AddPanel(filename)
		EndIf
	EndIf
EndProcedure

Procedure IHM_RemovePanel(*this.IHM, Number.w)
	RemoveGadgetItem(*this\Gadget[#gd_MainPanel], Number)
EndProcedure

Procedure IHM_SetCurrentPanel(*this.IHM, Number.w)
	SetGadgetState(*this\Gadget[#gd_MainPanel], Number)
EndProcedure

Procedure IHM_PanelModified(*this.IHM, Number.w)
	SetGadgetItemText(*this\Gadget[#gd_MainPanel], Number, GetGadgetItemText(*this\Gadget[#gd_MainPanel], Number)+"*")
EndProcedure

Procedure IHM_PanelSaved(*this.IHM, Number.w, Name.s)
	SetGadgetItemText(*this\Gadget[#gd_MainPanel], Number,  Name)
EndProcedure

Procedure IHM_ShowProjectTree(*this.IHM, *Project.Project)
	AddGadgetItem(*this\Gadget[#gd_FirstPanel], 1, GetText("MainWindow-Project"))
	*this\Gadget[#GD_TreeProject] = TreeGadget(#PB_Any, 0, 0, 0, 0)
	*this\Gadget[#GD_ProjectOption] = ButtonImageGadget(#PB_Any, 25,  0,  25, 25,  ImageID(*this\Image[#ImageIcon_Option]))
	*this\Gadget[#GD_ProjectClose] = ButtonImageGadget(#PB_Any, 0,  0,  25, 25,  ImageID(*this\Image[#ImageIcon_CloseProject]))
	*this\Gadget[#GD_ProjectBuild] = ButtonImageGadget(#PB_Any, 50,  0,  25, 25,  ImageID(*this\Image[#ImageIcon_Build]))
	*this\Gadget[#GD_ProjectDirectory] = ButtonImageGadget(#PB_Any, 75,  0,  25, 25,  ImageID(*this\Image[#ImageIcon_Directory]))
	*this\Gadget[#GD_ProjectExport] = ButtonImageGadget(#PB_Any, 100,  0,  25, 25,  ImageID(*this\Image[#ImageIcon_ProjectExport]))
	
	
	GadgetToolTip(*this\Gadget[#GD_ProjectOption], "Options")
	*this.AddNode(*Project.GetRootNode())
	;AddFilesToTree(GetFileList(*Project), *this, 0)
EndProcedure


Procedure RefreshTreeProject(*this.IHM)
	ClearGadgetItems(*this\Gadget[#GD_TreeProject])
	*this.AddNode(*System\OpenProject.GetRootNode())
EndProcedure

Procedure IHM_CloseProject(*this.IHM)
	RemoveGadgetItem(*this\Gadget[#gd_FirstPanel],  1)
EndProcedure

Procedure IHM_OptionModified(*this.IHM)
	DisableGadget(*this\Gadget[#GD_OptionDone], 0)
	*this\OptionModified = 1
EndProcedure

Macro SetColor(Name, Type, LastColor)
	Color = ColorRequester(Val(LastColor))
	If Color > -1 And Color <> Val(LastColor)
		IHM_OptionModified(*this)
		If StartDrawing(ImageOutput(*this\Image[#ImageColor_#Type]))
			Box(0,0, 100, 20, Color)
			StopDrawing()
			SetGadgetAttribute(*this\Gadget[#GD_ImageColor_#Type], #PB_Button_Image, ImageID(*this\Image[#ImageColor_#Type]))
			NewNewPref("Color", Name, Str(Color))
		EndIf
	EndIf
EndMacro

;-gadget-event
Procedure IHM_EventGadget(*this.IHM, Event.i, *System.System)
	Protected Path.s, Flag.i, ID.i, Sortie.s, txt.s, Color.l, Number.l, Position.l, *Ptr.Scintilla
	Protected *Template.Template, *XML, *XMLNode, *XMLChildNode, *Memory
	Select Event
		Case *this\Gadget[#GD_ProjectExport]
			Path = PathRequester("Select the path to export the project", "")
			If Path
				If Not *System\OpenProject.Export(Path)
					MessageRequester("Error", "Export failed")
				Else
					MessageRequester("", "Export success")
				EndIf
			EndIf
		Case *this\Gadget[#GD_ProjectDirectory]
			RunProgram(GetPathPart(*System\OpenProject\Path))
		Case *this\Gadget[#GD_ProjectBuild]
			*System.BuildProject()
		Case *this\Gadget[#GD_CreateTemplate]
			If CheckFilename(GetGadgetText(*this\Gadget[#GD_NewTemplateName]))
				If FileSize(GetGadgetText(*this\Gadget[#GD_TemplateIconPath])) > 0
					Path = GetGadgetText(*this\Gadget[#GD_TemplateIconPath])
				Else
					Path = *System.GetImagePath() + "Chronos.png"
				EndIf
				*Template = New Template()
				*Template.addFile(Path, 4)
				*Template\Name = GetGadgetText(*this\Gadget[#GD_NewTemplateName])
				*Template\Mode = GetGadgetState(*this\Gadget[#GD_ChooseTemplateType])
				*Template\SafeThread = GetGadgetState(*this\Gadget[#GD_NewTemplateThreadSafe])
				*Template\Unicode = GetGadgetState(*this\Gadget[#GD_NewTemplateUnicode])
				*Template\ASM = GetGadgetState(*this\Gadget[#GD_NewTemplateASM])
				*Template\OnError = GetGadgetState(*this\Gadget[#GD_NewTemplateOnError])
				*Template\ThemesXP = GetGadgetState(*this\Gadget[#GD_NewTemplateXPSkin])
				*Template\AdminMode = GetGadgetState(*this\Gadget[#GD_NewTemplateAdminMode])
				*Template\UserMode = GetGadgetState(*this\Gadget[#GD_NewTemplateUserMode])
				*Template\Precompilation = GetGadgetState(*this\Gadget[#GD_NewTemplatePrecompiler])
				*Template.GenerateXML()
				*Template.SetRessource(Template::LoadDirectory(GetGadgetText(*this\Gadget[#GD_TemplateSourcesPath])) , "", 2)
				*Template.SetRessource(Template::LoadDirectory(GetGadgetText(*this\Gadget[#GD_TemplateMediaPath])) , "", 3)
				*Template.save()
				*Template.loadIcon()
				*System\Template.addElement(*Template)
				IHM_HideWindow(*this, #WIN_TemplateMaker)
			Else
				MessageRequester("error", "Incorect template name")
			EndIf
		Case *this\Gadget[#GD_SelectTemplateIcon]
			SetGadgetText(*this\Gadget[#GD_TemplateIconPath], OpenFileRequester("select Icon", "", "Icon|*.png;*.bmp;*.jpg", 1))
		Case *this\Gadget[#GD_SelectTemplateSourcesPath]
			SetGadgetText(*this\Gadget[#GD_TemplateSourcesPath], PathRequester("select sources directory", ""))
		Case *this\Gadget[#GD_SelectTemplateMediaPath]
			SetGadgetText(*this\Gadget[#GD_TemplateMediaPath], PathRequester("select medias directory", ""))
		Case *this\Gadget[#GD_TemplateIconPath]
		Case *this\Gadget[#GD_TemplateSourcesPath]
		Case *this\Gadget[#GD_TemplateMediaPath]
		Case *this\Gadget[#GD_SearchNext]
			If GetGadgetText(*this\Gadget[#GD_SearchString])
				*this.Search(GetGadgetText(*this\Gadget[#GD_SearchString]))
			EndIf
		Case *this\Gadget[#GD_ConfirmProjectOption]
			
			*System\OpenProject\SafeThread = GetGadgetState(*this\Gadget[#GD_EnableProjectSafeThread])
			*System\OpenProject\Unicode = GetGadgetState(*this\Gadget[#GD_EnableProjectUnicode])
			*System\OpenProject\ASM = GetGadgetState(*this\Gadget[#GD_EnableProjectASM])
			*System\OpenProject\OnError = GetGadgetState(*this\Gadget[#GD_EnableProjectOnError])
			*System\OpenProject\ThemesXP = GetGadgetState(*this\Gadget[#GD_EnableProjectXPSkin])
			*System\OpenProject\AdminMode = GetGadgetState(*this\Gadget[#GD_EnableProjectAdministratorMode])
			*System\OpenProject\UserMode = GetGadgetState(*this\Gadget[#GD_EnableProjectUserMode])
			*System\OpenProject\Precompilation = GetGadgetState(*this\Gadget[#GD_EnableProjectPrecompiler])
			*System\OpenProject.SaveProject()
			IHM_HideWindow(*this, #WIN_OptionProject)
		Case *this\Gadget[#GD_CancelProjectOption]
			IHM_HideWindow(*this, #WIN_OptionProject)
		Case *this\Gadget[#GD_ProjectOption]
			ShowWindow(*this, #WIN_OptionProject)
		Case *this\Gadget[#GD_ProjectClose]
			System_CloseProject(*System)
		Case *this\Gadget[#GD_CancelNewProject]
			IHM_HideWindow(*this, #WIN_NewProject)
			;		Case  *this\Gadget[#GD_ProjectFile]
			;			IHM_SetCurrentProjectTree(*this,  #GD_ProjectFile)
			;		Case  *this\Gadget[#GD_ProjectComment]
			;			IHM_SetCurrentProjectTree(*this,  #GD_ProjectComment)
			;		Case  *this\Gadget[#GD_ProjectClass]
			;			IHM_SetCurrentProjectTree(*this,  #GD_ProjectClass)
			;		Case  *this\Gadget[#GD_ProjectProcedure]
			;			IHM_SetCurrentProjectTree(*this,  #GD_ProjectProcedure)
			;-Option
			;{
			;-compilation
		Case *this\Gadget[#GD_EnableASM]
			NewNewPref("Compiler Options", "ASM", Str(GetGadgetState(Event)))
		Case *this\Gadget[#GD_EnableUnicode]
			NewNewPref("Compiler Options", "Unicode", Str(GetGadgetState(Event)))
		Case *this\Gadget[#GD_EnableSafeThread]
			NewNewPref("Compiler Options", "SafeThread", Str(GetGadgetState(Event)))
		Case *this\Gadget[#GD_EnableOnError]
			NewNewPref("Compiler Options", "OnError", Str(GetGadgetState(Event)))
		Case *this\Gadget[#GD_EnableXPSkin]
			NewNewPref("Compiler Options", "XPSkin", Str(GetGadgetState(Event)))
		Case *this\Gadget[#GD_EnableAdministratorMode]
			NewNewPref("Compiler Options", "AdministratorMode", Str(GetGadgetState(Event)))
		Case *this\Gadget[#GD_EnableUserMode]
			NewNewPref("Compiler Options", "UserMode", Str(GetGadgetState(Event)))
		Case *this\Gadget[#GD_EnablePrecompiler]
			NewNewPref("Compiler Options", "Precompiler", Str(GetGadgetState(Event)))
		Case *this\Gadget[#GD_CancelSetCompilerOption]
			IHM_HideWindow(*this, #WIN_OptionCompilation)
		Case *this\Gadget[#GD_ConfirmSetCompilerOption]
			SavePreferences(*System)
			IHM_HideWindow(*this, #WIN_OptionCompilation)
			;-path
		Case *this\Gadget[#GD_X86Path_Select]
			Path = PathRequester("Select X86 Compilateur Path", "")
			If Path And Path <> *system\Prefs.GetPreference("X86", "Compiler Path")
				If FileSize(Path + #PB_CompilerName) <= 0
					MessageRequester("Error", "Compiler Not Found")
				Else
					NewNewPref("X86", "Compiler Path", Path)
					SetGadgetText(*this\Gadget[#GD_X86Path], Path)
				EndIf
				IHM_OptionModified(*this)
			EndIf
		Case *this\Gadget[#GD_X64Path_Select]
			Path = PathRequester("Select X64 Compilateur Path", "")
			If Path And Path <> *system\Prefs.GetPreference("X64", "Compiler Path")
				If FileSize(Path + #PB_CompilerName) <= 0
					MessageRequester("Error", "Compiler Not Found")
				Else
					NewNewPref("X64", "Compiler Path", Path)
					SetGadgetText(*this\Gadget[#GD_X64Path], Path)
				EndIf
				IHM_OptionModified(*this)
			EndIf
			;-Couleur
		Case *this\Gadget[#GD_ListLanguage]
			If GetGadgetText(*this\Gadget[#GD_ListLanguage]) <> *system\Prefs.GetPreference("GENERAL", "Lang")
				IHM_OptionModified(*this)
				NewNewPref("GENERAL", "Lang", GetGadgetText(*this\Gadget[#GD_ListLanguage]))
			EndIf
		Case *this\Gadget[#GD_ImageColor_Text]
			SetColor("Text", Text, *system\Prefs.GetPreference("Color", "Text"))
			
		Case *this\Gadget[#GD_ImageColor_KeyWord]
			SetColor("KeyWord", KeyWord, *system\Prefs.GetPreference("Color", "KeyWord"))
		Case *this\Gadget[#GD_ImageColor_Function]
			SetColor("Function", Function, *system\Prefs.GetPreference("Color", "Function"))
		Case *this\Gadget[#GD_ImageColor_Constant]
			SetColor("Constant", Constant, *system\Prefs.GetPreference("Color", "Constant"))
		Case *this\Gadget[#GD_ImageColor_String]
			SetColor("String", String, *system\Prefs.GetPreference("Color", "String"))
		Case *this\Gadget[#GD_ImageColor_Operator]
			SetColor("Operator", Operator, *system\Prefs.GetPreference("Color", "Operator"))
		Case *this\Gadget[#GD_ImageColor_Comment]
			SetColor("Comment", Comment, *system\Prefs.GetPreference("Color", "Comment"))
		Case *this\Gadget[#GD_OptionConfirm]
			If *this\OptionModified = 1
				SavePreferences(*System)
			Else
				RemoveNewPreferences(*System)
			EndIf
			IHM_HideWindow(*this, #WIN_Option)
			
		Case *this\Gadget[#GD_OptionDone]
			SavePreferences(*System)
			DisableGadget(*this\Gadget[#GD_OptionDone], 1)
			*this\OptionModified = 0
			
		Case *this\Gadget[#GD_OptionCancel]
			IHM_HideWindow(*this, #WIN_Option)
			RemoveNewPreferences(*System)
			;}
			
		Case *this\Gadget[#gd_SetPathAddCompiler]
			;{
			Path = PathRequester("", "")
			If Path
				SetGadgetText(*this\Gadget[#gd_TextNewPathCompiler], Path)
			EndIf
			;}
		Case *this\Gadget[#gd_ConfirmAddCompiler]
			;{
			Path = GetGadgetText(*this\Gadget[#gd_TextNewPathCompiler])
			If FileSize(Path) = -2
				If FileSize(Path + #PB_Compiler) > 0
					Flag =  #PB_Program_Read | #PB_Program_Open | #PB_Program_Hide | #PB_Program_Write
					ID = RunProgram(Path + #PB_Compiler, #CompilerFlagVersion, "", Flag)
					If ProgramRunning(ID)
						Sortie = ReadProgramString(ID)
					EndIf
					CloseProgram(ID)
					If Len(Sortie)>0
						If StringField(Sortie, 0, " ") <> "PureBasic"
							Sortie = PeekS(@Sortie, -1, #PB_Ascii )
						EndIf
						
						Protected CompilerNo = Val(*system\Prefs.GetPreference("GENERAL","Compiler")) + 1, k
						*system\Prefs.SetPreference("Compiler"+Str(CompilerNo),"Version",  Sortie)
						*system\Prefs.SetPreference("Compiler"+Str(CompilerNo),"VersionNumero",  StringField(Sortie, 2, " "))
						k = 3
						While Not Right(StringField(Sortie, k, " "), 1) = ")"
							k + 1
						Wend
						*system\Prefs.SetPreference("Compiler"+Str(CompilerNo),"Structure",  Left(StringField(Sortie, k, " "), 3))
						*system\Prefs.SetPreference("Compiler"+Str(CompilerNo),"Path",  Path)
						*system\Prefs.SetPreference("GENERAL", "Compiler", Str(CompilerNo))
						*system\Prefs.SavePreference()
						IHM_HideWindow(*this, #WIN_Option)
						ShowWindow(*this, #WIN_Main)
					EndIf
				Else
					;prob avec le compiler
				EndIf
			Else
				;le dossier n'existe pas
			EndIf
			;}
		Case *this\Gadget[#GD_SetPathNewProject]
			;{
			Path = PathRequester("Select a path", "")
			If Not Path
				ProcedureReturn
			EndIf
			SetGadgetText(*this\Gadget[#GD_PathNewProject] , Path)
			;}
		Case *this\Gadget[#gd_MainPanel]
			;{
			SetCurrentPanel(*System, GetGadgetState(*this\Gadget[#gd_MainPanel]) + 1)
			;}
		Case *this\Gadget[#GD_CreateNewProject]
			;{
			If GetGadgetText(*this\Gadget[#GD_NameNewProject]) = "" Or GetGadgetText(*this\Gadget[#GD_PathNewProject]) = ""
				MessageRequester("Error", GetText("NewProjectWindow-Error1"))
				ProcedureReturn
			EndIf
			
			*System.CreateProject(GetGadgetState(*this\Gadget[#GD_TreeTemplate]) + 1, GetGadgetText(*this\Gadget[#GD_PathNewProject]), GetGadgetText(*this\Gadget[#GD_NameNewProject]))
			*System.OpenProject(GetGadgetText(*this\Gadget[#GD_PathNewProject])+"project.chp")
			IHM_HideWindow(*this, #WIN_NewProject)
			;}
		Case *this\Gadget[#GD_TreeProject]
			;{
			Protected *Project.Project  = *System.GetCurrentProject()
			Protected *Node.Node
			Protected *File.File, n
			Protected Text.s
			Protected *Directory.Directory, *Comment.Comment::Item
			Number = GetGadgetState(*this\Gadget[#GD_TreeProject])
			If Number > - 1
				*Node = *Project\Files.GetNode(Number)
				If *Node
					Select *Node\Type
						Case #Node_Directory
							Select EventType()
								Case #PB_EventType_RightClick
									DisplayPopupMenu(*this\menu[#Menu_ProjectDirectory], WindowID(*this\window[#WIN_Main]))
							EndSelect
						Case #Node_RootComment
						Case #Node_File
							*File = *Node
							Select EventType()
								Case #PB_EventType_LeftDoubleClick
									*Comment = *Node
									*System.addPanel(*File.GetPath())
								Case #PB_EventType_RightClick
									DisplayPopupMenu(*this\menu[#Menu_ProjectFile], WindowID(*this\window[#WIN_Main]))
							EndSelect
						Case #Node_Comment
							Select EventType()
								Case #PB_EventType_LeftDoubleClick
									*Comment = *Node
									*System.addPanel(*Comment\File)
									*Ptr = *System.GetCurrentScintillaGadget()
									*Ptr.setPosition(*Ptr.PositionFromLine(*Comment\Line))
							EndSelect
					EndSelect
				Else
					debug "not found"
				EndIf
			EndIf
			;}
		Case *this\Gadget[#GD_TreeOption]
			;{
			Select GetGadgetState(*this\Gadget[#GD_TreeOption])
				Case 1
					IHM_SetCurrentOption(*this, #OptionLang)
				Case 3
					IHM_SetCurrentOption(*this, #OptionColor)
				Case 5
					IHM_SetCurrentOption(*this, #OptionCompiler)
			EndSelect
			;}
	EndSelect
EndProcedure


