;=====================================================
; IHM.class.pb
;
;classe pour l'Interface Homme Machine
;Feel the pure power
;=====================================================
Class Panel
	*File.File
	*ScintillaGadget.Scintilla

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
	OptionModified.b
	ProjectTreeMode.i
	
	Procedure WriteMessage(Msg.s)
		Msg = "[" + FormatDate("%hh:%ii:%ss", Date()) + "] " + Msg
		AddGadgetItem(*this\Gadget[#gd_SecondPanel], -1, Msg)
	EndProcedure
EndClass


Procedure NewIHM()
	Protected *this.IHM = AllocateMemory(SizeOf(IHM)), Flag.i, n.l, temp.s
	Protected MainPath.s = *System\Prefs.GetPreference("GENERAL", "MainPath")
	CompilerIf  #PB_Compiler_OS = #PB_OS_Windows
		If Not InitScintilla("Scintilla.dll")
			SystemEnd(*System)
		EndIf
	CompilerEndIf
	
	;=====================================================
	;
	;-Chargement  icons
	;
	;=====================================================
	;{
	*this\Image[#ImageIcon_Option]  = LoadImage(#PB_Any,  MainPath + "images"  + "/"+ "vcard_edit.png")
	*this\Image[#ImageIcon_CloseProject]  = LoadImage(#PB_Any,  MainPath + "images"  + "/"+ "cancel.png")
	*this\Image[#ImageIcon_Build]  = LoadImage(#PB_Any,  MainPath + "images"  + "/"+ "bricks.png")
	
	*this\Image[#ImageIcon_Directory]  = LoadImage(#PB_Any,  MainPath + "images"  + "/"+ "folder.png")
	*this\Image[#ImageIcon_FileTree]  = LoadImage(#PB_Any,  MainPath + "images"  + "/"+ "page_white_text.png")
	
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
					MenuItem(#PB_Any, temp)
				Else
					For n = 1 To CountString(temp, ";") + 1
						MenuItem(#PB_Any, StringField(temp, n, ";"))
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
			; 			MenuBar()
			; 			MenuItem(#Cut, GetText("GeneralMenu-Cut")   +Chr(9)+"Ctrl+X")
			; 			MenuItem(#Copy, GetText("GeneralMenu-Copy")   +Chr(9)+"Ctrl+C")
			; 			MenuItem(#Paste, GetText("GeneralMenu-Paste")   +Chr(9)+"Ctrl+V")
			; 			DisableMenuItem(*this\menu[0],#Paste,1)
			MenuBar()
			;MenuItem(#SlctAll, GetText("GeneralMenu-SelectAll")   +Chr(9)+"Ctrl+A")
			MenuBar()
			;MenuItem(#Search, GetText("GeneralMenu-Find")+Chr(9)+"Ctrl+F")
			MenuTitle(GetText("GeneralMenu-Compiler"))
			MenuItem(#Compiler, GetText("GeneralMenu-CompilerFile")+Chr(9)+"F5")
			MenuItem(#CompilerProject, GetText("GeneralMenu-CompilerProject")+Chr(9)+"F6")
			MenuItem(#SwitchStructure, GetText("GeneralMenu-SwitchStructure")+Chr(9)+"F9")
			MenuItem(#CompilerOptions, GetText("GeneralMenu-CompileOption"))
			MenuItem(#BuildCurrentFile, GetText("GeneralMenu-BuildFile"))
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
		EndIf
		*this\ToolBar[0] = CreateToolBar(#PB_Any, WindowID(*this\Window[0]))
		If *this\ToolBar[0]
			ToolBarStandardButton(#new, #PB_ToolBarIcon_New)
			ToolBarStandardButton(#open, #PB_ToolBarIcon_Open)
			ToolBarStandardButton(#save, #PB_ToolBarIcon_Save)
			ToolBarStandardButton(#close, #PB_ToolBarIcon_Delete)
			ToolBarSeparator()
			ToolBarStandardButton(#search, #PB_ToolBarIcon_Find)
			; 			ToolBarSeparator()
			; 			ToolBarStandardButton(#cut, #PB_ToolBarIcon_Cut)
			; 			ToolBarStandardButton(#copy, #PB_ToolBarIcon_Copy)
			; 			ToolBarStandardButton(#paste, #PB_ToolBarIcon_Paste)
			ToolBarSeparator()
			ToolBarStandardButton(#undo, #PB_ToolBarIcon_Undo)
			ToolBarStandardButton(#redo, #PB_ToolBarIcon_Redo)
		EndIf
		*this\StatusBar[0] = CreateStatusBar(#PB_Any, WindowID(*this\Window[0]))
		If *this\StatusBar[0]
			AddStatusBarField(200)
			AddStatusBarField(#PB_Ignore)
		Else
			SystemEnd(*System)
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
			Debug "erreur"
			SystemEnd(*System)
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
			Debug "erreur"
			SystemEnd(*System)
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
			Debug "erreur"
			SystemEnd(*System)
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
			Debug "erreur"
			SystemEnd(*System)
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
			Debug "erreur"
			SystemEnd(*System)
		EndIf
		;}
	Else
		MessageRequester("YAPI",GetText("NewProjectWindow-Error"))
		SystemEnd(*System)
	EndIf
	ProcedureReturn *this
EndProcedure

Procedure SetStatusBarText(*this.IHM, Champ, txt.s)
	If champ = 0
		StatusBarText(*this\StatusBar[0], Champ, txt, #PB_StatusBar_Center)
	Else
		StatusBarText(*this\StatusBar[0], Champ, txt)
	EndIf
EndProcedure

Procedure NewScintillaGadget(*this.IHM, PanelName.s)
	AddGadgetItem(*this\Gadget[#gd_MainPanel], CountGadgetItems(*this\Gadget[#gd_MainPanel]), PanelName)
	
	Protected *ptr = ScintillaGadget(#PB_Any, 0, 0,   GetGadgetAttribute(*this\Gadget[#gd_MainPanel], #PB_Panel_ItemWidth), GetGadgetAttribute(*this\Gadget[#gd_MainPanel], #PB_Panel_ItemHeight), @ScintillaCallBack())
	
	; Set default font
	;ScintillaSendMessage( *ptr , #SCI_STYLESETFONT, #STYLE_DEFAULT, @"Courier New")
	;ScintillaSendMessage( *ptr , #SCI_STYLESETSIZE, #STYLE_DEFAULT, 12)
	
	; Set caret line colour
	ScintillaSendMessage( *ptr , #SCI_SETCARETLINEBACK, $00FFFF)
	ScintillaSendMessage( *ptr , #SCI_SETCARETLINEVISIBLE, #True)
	
	; Set styles for custom lexer
	ScintillaSendMessage( *ptr , #SCI_STYLESETFORE, #LexerState_Comment, Val(*system\Prefs.GetPreference("Color", "Comment")))
	ScintillaSendMessage( *ptr , #SCI_STYLESETITALIC, #LexerState_Comment, 1)
	ScintillaSendMessage( *ptr , #SCI_STYLESETFORE, #LexerState_NonKeyword, 0)
	ScintillaSendMessage( *ptr , #SCI_STYLESETFORE, #LexerState_Keyword, Val(*system\Prefs.GetPreference("Color", "KeyWord")))
	ScintillaSendMessage( *ptr , #SCI_STYLESETBOLD, #LexerState_Keyword, #True)
	ScintillaSendMessage( *ptr , #SCI_STYLESETFORE, #LexerState_Constant, Val(*system\Prefs.GetPreference("Color", "Constant")))
	ScintillaSendMessage( *ptr , #SCI_STYLESETFORE, #LexerState_String, Val(*system\Prefs.GetPreference("Color", "String")))
	ScintillaSendMessage( *ptr , #SCI_STYLESETFORE, #LexerState_Function, Val(*system\Prefs.GetPreference("Color", "Function")))
	ScintillaSendMessage( *ptr , #SCI_STYLESETFORE, #LexerState_Operator, Val(*system\Prefs.GetPreference("Color", "Operator")))
	
	; Margins
	ScintillaSendMessage( *ptr , #SCI_SETMARGINTYPEN, 0, #SC_MARGIN_NUMBER)
	ScintillaSendMessage( *ptr , #SCI_SETMARGINMASKN, 2, #SC_MASK_FOLDERS)
	;ScintillaSendMessage( *ptr , #SCI_SETMARGINWIDTHN, 0, 20)
	ScintillaSendMessage( *ptr , #SCI_SETMARGINWIDTHN, 1, 5)
	ScintillaSendMessage( *ptr , #SCI_SETMARGINWIDTHN, 2, 15)
	ScintillaSendMessage( *ptr , #SCI_SETMARGINSENSITIVEN, 2, #True)
	
	; Choose folding icons
	ScintillaSendMessage( *ptr , #SCI_MARKERDEFINE, #SC_MARKNUM_FOLDEROPEN, #SC_MARK_BOXMINUS)
	ScintillaSendMessage( *ptr , #SCI_MARKERDEFINE, #SC_MARKNUM_FOLDER, #SC_MARK_BOXPLUS)
	ScintillaSendMessage( *ptr , #SCI_MARKERDEFINE, #SC_MARKNUM_FOLDERSUB, #SC_MARK_VLINE)
	ScintillaSendMessage( *ptr , #SCI_MARKERDEFINE, #SC_MARKNUM_FOLDERTAIL, #SC_MARK_LCORNERCURVE)
	ScintillaSendMessage( *ptr , #SCI_MARKERDEFINE, #SC_MARKNUM_FOLDEREND, #SC_MARK_BOXPLUS)
	ScintillaSendMessage( *ptr , #SCI_MARKERDEFINE, #SC_MARKNUM_FOLDEROPENMID, #SC_MARK_BOXMINUS)
	ScintillaSendMessage( *ptr , #SCI_MARKERDEFINE, #SC_MARKNUM_FOLDERMIDTAIL, #SC_MARK_TCORNERCURVE)
	
	; Choose folding icon colours
	ScintillaSendMessage( *ptr , #SCI_MARKERSETFORE, #SC_MARKNUM_FOLDEROPEN, $FFFFFF)
	ScintillaSendMessage( *ptr , #SCI_MARKERSETBACK, #SC_MARKNUM_FOLDEROPEN, 0)
	ScintillaSendMessage( *ptr , #SCI_MARKERSETFORE, #SC_MARKNUM_FOLDER, $FFFFFF)
	ScintillaSendMessage( *ptr , #SCI_MARKERSETBACK, #SC_MARKNUM_FOLDER, 0)
	ScintillaSendMessage( *ptr , #SCI_MARKERSETFORE, #SC_MARKNUM_FOLDERSUB, $FFFFFF)
	ScintillaSendMessage( *ptr , #SCI_MARKERSETBACK, #SC_MARKNUM_FOLDERSUB, 0)
	ScintillaSendMessage( *ptr , #SCI_MARKERSETFORE, #SC_MARKNUM_FOLDERTAIL, $FFFFFF)
	ScintillaSendMessage( *ptr , #SCI_MARKERSETBACK, #SC_MARKNUM_FOLDERTAIL, 0)
	ScintillaSendMessage( *ptr , #SCI_MARKERSETFORE, #SC_MARKNUM_FOLDEREND, $FFFFFF)
	ScintillaSendMessage( *ptr , #SCI_MARKERSETBACK, #SC_MARKNUM_FOLDEREND, 0)
	ScintillaSendMessage( *ptr , #SCI_MARKERSETFORE, #SC_MARKNUM_FOLDEROPENMID, $FFFFFF)
	ScintillaSendMessage( *ptr , #SCI_MARKERSETBACK, #SC_MARKNUM_FOLDEROPENMID, 0)
	ScintillaSendMessage( *ptr , #SCI_MARKERSETFORE, #SC_MARKNUM_FOLDERMIDTAIL, $FFFFFF)
	ScintillaSendMessage( *ptr , #SCI_MARKERSETBACK, #SC_MARKNUM_FOLDERMIDTAIL, 0)
	
	ScintillaSendMessage( *ptr , #SCI_AUTOCSETIGNORECASE, #True)
	
	ScintillaSendMessage( *ptr , #SCI_SETTABINDENTS, #True)
	ScintillaSendMessage( *ptr , #SCI_SETBACKSPACEUNINDENTS, #True)
	ScintillaSendMessage( *ptr , #SCI_SETINDENT, 0)
	
	ScintillaSendMessage( *ptr , #SCI_SETUSETABS, #True)
	ScintillaSendMessage( *ptr , #SCI_SETTABWIDTH, 4)
	ScintillaSendMessage( *ptr , #SCI_SETEOLMODE, #SC_EOL_LF)
	SCI_SetIndentationGuides(*ptr, 1)
	
	
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
			*Project = GetCurrentProject(*System)
			Select GetMode(*Project)
				Case #ProjectIsApp
					SetGadgetState(*this\Gadget[#GD_ProjectTypeList], 0)
				Case #ProjectIsDynamicLib
					SetGadgetState(*this\Gadget[#GD_ProjectTypeList], 2)
				Case #ProjectIsStaticLib
					SetGadgetState(*this\Gadget[#GD_ProjectTypeList], 1)
			EndSelect
			SetGadgetState(*this\Gadget[#GD_EnableProjectSafeThread], *System\OpenProject\Options\SafeThread )
			SetGadgetState(*this\Gadget[#GD_EnableProjectUnicode], *System\OpenProject\Options\Unicode)
			SetGadgetState(*this\Gadget[#GD_EnableProjectASM], *System\OpenProject\Options\ASM)
			SetGadgetState(*this\Gadget[#GD_EnableProjectOnError], *System\OpenProject\Options\OnError)
			SetGadgetState(*this\Gadget[#GD_EnableProjectXPSkin], *System\OpenProject\Options\ThemesXP)
			SetGadgetState(*this\Gadget[#GD_EnableProjectAdministratorMode], *System\OpenProject\Options\AdminMode)
			SetGadgetState(*this\Gadget[#GD_EnableProjectUserMode], *System\OpenProject\Options\UserMode)
			SetGadgetState(*this\Gadget[#GD_EnableProjectPrecompiler], *System\OpenProject\Options\Precompilation)
			
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
			SetGadgetState(*this\Gadget[#GD_TreeTemplate], 0)
			DisableWindow(*this\Window[#WIN_Main] , 1)
	EndSelect
	HideWindow(*this\Window[numero], 0)
EndProcedure

Procedure IHM_HideWindow(*this.IHM, numero.i)
	Select numero
		Case #WIN_NewProject, #WIN_Option, #WIN_OptionCompilation, #WIN_OptionProject
			DisableWindow(*this\Window[#WIN_Main] , 0)
	EndSelect
	HideWindow(*this\Window[numero], 1)
EndProcedure

Procedure GetGadget(*this.IHM, numero.i)
	ProcedureReturn *this\Gadget[numero]
EndProcedure

Procedure GetWindow(*this.IHM, numero.i)
	ProcedureReturn *this\Window[numero]
EndProcedure

Procedure IHM_AddTemplate(*this.IHM, *Template.Template)
	AddGadgetItem(*this\Gadget[#GD_TreeTemplate], -1, Template_GetName(*Template, *system\Prefs.GetPreference("GENERAL", "Lang")))
EndProcedure

Procedure ResizeWindows(*this.IHM, number)
	Protected HeightMax, WidthMax, n, *Ptr.Panel
	Select number
		Case  #WIN_Main
			Protected ToolBarHeight
			CompilerIf #PB_Compiler_OS = #PB_OS_Windows
				ToolBarHeight = ToolBarHeight(*this\ToolBar[0])
			CompilerElse
				ToolBarHeight = 0
			CompilerEndIf
			HeightMax = WindowHeight(*this\Window[0]) - MenuHeight() - StatusBarHeight(*this\StatusBar[0])  - ToolBarHeight
			WidthMax = WindowWidth(*this\Window[0])
			ResizeGadget(*this\Gadget[#gd_FirstPanel], WidthMax - 200, ToolBarHeight ,  200, HeightMax)
			Protected Height =  GetGadgetAttribute(*this\Gadget[#gd_MainPanel], #PB_Panel_TabHeight ) + 1
			ResizeGadget(*this\Gadget[#gd_MainPanel], 0, ToolBarHeight ,  WidthMax - 200, HeightMax - 150)
			If IsGadget(*this\Gadget[#gd_Explorer])
				ResizeGadget(*this\Gadget[#gd_Explorer], 0, 0 ,  GetGadgetAttribute(*this\Gadget[#gd_FirstPanel], #PB_Panel_ItemWidth), GetGadgetAttribute(*this\Gadget[#gd_FirstPanel], #PB_Panel_ItemHeight ))
			EndIf
			ResizeGadget(*this\Gadget[#gd_SecondPanel], 0, HeightMax - 150 + ToolBarHeight ,  WidthMax - 200, 150)
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
	Protected filename.s = OpenFileRequester("Open a file", "", ChronosFiltre, 0)
	If filename <> ""
		If LCase(GetExtensionPart(filename)) = "chp"
			System_OpenProject(*System, filename)
			UpdateOpenFile(*System,  #Project, filename)
		Else
			UpdateOpenFile(*System,  #File, filename)
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
	GadgetToolTip(*this\Gadget[#GD_ProjectOption], "Options")
	AddFilesToTree(GetFileList(*Project), *this, 0)
	debug 1
EndProcedure

Procedure IHM_SetCurrentProjectTree(*this.IHM,  gadget.i)
	Protected *Project.Project  = GetCurrentProject(*System)
	Protected *FileList.Directory = GetFileList(*Project), *File.File, n, *Directory.Directory
	Protected j = 0, i, level.b
	AddFilesToTree(GetFileList(*Project), *this, 0)
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

Procedure IHM_EventGadget(*this.IHM, Event.i, *System.System)
	Protected Path.s, Flag.i, ID.i, Sortie.s, txt.s, Color.l, Number.l, Position.l, *Ptr
	Select Event
		Case *this\Gadget[#GD_SearchNext]
			If GetGadgetText(*this\Gadget[#GD_SearchString])
				*Ptr = GetCurrentScintillaGadget(*System)
				Position = SCI_FindString(*Ptr, GetGadgetText(*this\Gadget[#GD_SearchString]), SCI_GetPosition(*Ptr) + 1)
				If Position >=0
					SCI_GoToPoS(*Ptr, Position)
					SCI_SetSel(*Ptr, Position, Position + Len(GetGadgetText(*this\Gadget[#GD_SearchString])))
				Else
					MessageRequester("", "not found")
				EndIf
			EndIf
		Case *this\Gadget[#GD_ConfirmProjectOption]
			
			*System\OpenProject\Options\SafeThread = GetGadgetState(*this\Gadget[#GD_EnableProjectSafeThread])
			*System\OpenProject\Options\Unicode = GetGadgetState(*this\Gadget[#GD_EnableProjectUnicode])
			*System\OpenProject\Options\ASM = GetGadgetState(*this\Gadget[#GD_EnableProjectASM])
			*System\OpenProject\Options\OnError = GetGadgetState(*this\Gadget[#GD_EnableProjectOnError])
			*System\OpenProject\Options\ThemesXP = GetGadgetState(*this\Gadget[#GD_EnableProjectXPSkin])
			*System\OpenProject\Options\AdminMode = GetGadgetState(*this\Gadget[#GD_EnableProjectAdministratorMode])
			*System\OpenProject\Options\UserMode = GetGadgetState(*this\Gadget[#GD_EnableProjectUserMode])
			*System\OpenProject\Options\Precompilation = GetGadgetState(*this\Gadget[#GD_EnableProjectPrecompiler])
			SaveProject(*System\OpenProject)
			IHM_HideWindow(*this, #WIN_OptionProject)
		Case *this\Gadget[#GD_CancelProjectOption]
			IHM_HideWindow(*this, #WIN_OptionProject)
		Case *this\Gadget[#GD_ProjectOption]
			ShowWindow(*this, #WIN_OptionProject)
		Case *this\Gadget[#GD_ProjectClose]
			System_CloseProject(*System)
		Case *this\Gadget[#GD_CancelNewProject]
			IHM_HideWindow(*this, #WIN_NewProject)
		Case  *this\Gadget[#GD_ProjectFile]
			IHM_SetCurrentProjectTree(*this,  #GD_ProjectFile)
		Case  *this\Gadget[#GD_ProjectComment]
			IHM_SetCurrentProjectTree(*this,  #GD_ProjectComment)
		Case  *this\Gadget[#GD_ProjectClass]
			IHM_SetCurrentProjectTree(*this,  #GD_ProjectClass)
		Case  *this\Gadget[#GD_ProjectProcedure]
			IHM_SetCurrentProjectTree(*this,  #GD_ProjectProcedure)
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
			;Path = "C:\Program Files (x86)\PureBasic\Compilers\" ;debugage
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
			If FileSize(Path) > -2
				CreateDirectory(Path)
			EndIf
			SetGadgetText(*this\Gadget[#GD_PathNewProject] , Path)
			;}
		Case *this\Gadget[#gd_MainPanel]
			;{
			SetCurrentPanel(*System, GetGadgetState(*this\Gadget[#gd_MainPanel]) + 1)
			;}
		Case *this\Gadget[#GD_CreateNewProject]
			;{
			If GetGadgetText(*this\Gadget[#GD_NameNewProject]) = "" Or GetGadgetText(*this\Gadget[#GD_NameNewProject]) = ""
				MessageRequester("Error", GetText("NewProjectWindow-Error1"))
				ProcedureReturn
			EndIf
			If FindString(GetGadgetText(*this\Gadget[#GD_NameNewProject]) , "/", 1) Or FindString(GetGadgetText(*this\Gadget[#GD_NameNewProject]) , "\", 1)
				MessageRequester("Error", GetText("NewProjectWindow-Error2"))
				ProcedureReturn
			EndIf
			Path = GetGadgetText(*this\Gadget[#GD_PathNewProject]) + GetGadgetText(*this\Gadget[#GD_NameNewProject]) + ".chp"
			If FileSize(Path) >= 0
				DeleteFile(Path)
			EndIf
			CreateProject(*System, GetGadgetState(*this\Gadget[#GD_TreeTemplate]) + 1, Path, GetGadgetText(*this\Gadget[#GD_NameNewProject]))
			System_OpenProject(*System, Path)
			IHM_HideWindow(*this, #WIN_NewProject)
			;}
		Case *this\Gadget[#GD_TreeProject]
			;{
			Protected *Project.Project  = GetCurrentProject(*System)
			Protected *File.File, n
			
			Number = GetGadgetState(*this\Gadget[#GD_TreeProject])
			If Number > - 1
				Select Project_FileIs(*Project, Number)
					Case #Directory
						Select EventType()
							Case #PB_EventType_RightClick
								DisplayPopupMenu(*this\menu[#Menu_ProjectDirectory], WindowID(*this\window[#WIN_Main]))
						EndSelect
					Default ;c'est un fichier
						Select EventType()
							Case #PB_EventType_LeftDoubleClick
								*File = Project_GetFile(*Project, Number)
								*System.AddPanel("", *File)
							Case #PB_EventType_RightClick
								DisplayPopupMenu(*this\menu[#Menu_ProjectFile], WindowID(*this\window[#WIN_Main]))
						EndSelect
				EndSelect
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


