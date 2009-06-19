;=============================================================;
;Lib Preferences                                                                                                                                                ;
;=============================================================;
IncludeImport "DS.Lib.Array"
IncludeImport "DS.Lib.Preferences.Option"
IncludeImport "DS.Lib.Preferences.Group"

Class Preference
	Name.s
	*Group.Array = New Array()
	
	Procedure Preference(name.s)
		If  CheckFilename(name)
			*this\Name = name
			name = GetHomeDirectory() + "."+name+"/"
			If FileSize(name + "prefs.pref") > 0
				*this.LoadPreference(name + "prefs.pref")
			EndIf
			ProcedureReturn *this
		Else
			ProcedureReturn 0
		EndIf
	EndProcedure
	
	Procedure LoadPreference(file.s)
		If OpenPreferences(file)
			If ExaminePreferenceGroups()
				Protected *array.Array, *Group.Group
				While NextPreferenceGroup()
					*Group = New Group(PreferenceGroupName())
					PreferenceGroup( *Group\name)
					ExaminePreferenceKeys()
					While NextPreferenceKey()
						*Group\Option.AddElement(New Option(PreferenceKeyName(), PreferenceKeyValue()))
					Wend
					*this\Group.AddElement(*Group)
				Wend
			EndIf
			ClosePreferences()
		EndIf
		ProcedureReturn #True
	EndProcedure
	
	Procedure SavePreference()
		Protected n.l, i.l, name.s = GetHomeDirectory() + "."+*this\name+"/"
		CompilerIf #PB_Compiler_OS = #PB_OS_Windows
			Name = ReplaceString(Name, "/", "\")
		CompilerEndIf
		Protected *Option.Option, *Group.Group
		If FileSize(name)  = -1
			If Not CreateDirectory(name)
				ProcedureReturn #False
			EndIf
		EndIf
		If CreatePreferences(name+"prefs.pref")
				For n=1 To *this\Group.CountElement()
					*Group = *this\Group.GetElement(n)
					PreferenceGroup(*Group\Name)
						For i=1 To *Group\Option.CountElement()
							*Option = *Group\Option.GetElement(i)
							WritePreferenceString(*Option\Name, *Option\Value)
					Next i
			Next n
			ClosePreferences()
			ProcedureReturn #True
		EndIf
		ProcedureReturn #False
	EndProcedure
	
	Procedure CreateGroup(Group.s)
		Protected *Group.Group = New Group(Group)
		*this\Group.SetElement(*this\Group.CountElement()+1, *Group)
		ProcedureReturn *Group
	EndProcedure
	
	Procedure IsGroup(Group.s)
		Protected *Group.Group, n
			For n=1 To *this\Group.CountElement()
				*Group = *this\Group.GetElement(n)
				If LCase(*Group\Name) = LCase(Group)
					ProcedureReturn *Group
				EndIf
		Next n
		ProcedureReturn #False
	EndProcedure
	
	Procedure CountGroup()
		ProcedureReturn *this\Group.CountElement()
	EndProcedure
	
	Procedure GetGroupNumber(n)
		ProcedureReturn *this\Group.GetElement(n)
	EndProcedure
	
	Procedure SetPreference(Group.s, Key.s, Value.s)
		Protected n, *Group.Group, *Option.Option
		*Group =  *this.IsGroup(Group)
		If Not *Group
			*Group = New Group(Group)
			*Group.CreateOption(Key, Value)
			*this\Group.AddElement(*Group)
		Else
			*Option = *Group.IsKey(Key)
			If Not *Option
				*Group.CreateOption(Key, Value)
			Else
				*Option.SetValue(Value)
			EndIf
		EndIf
	EndProcedure
	
	Procedure.b IsPreference(Group.s, Key.s)
		Protected  *Group.Group =  *this.IsGroup(Group)
		If *Group
			If *Group.IsKey(Key)
				ProcedureReturn #False
			EndIf
		EndIf
		ProcedureReturn #False
	EndProcedure
	
	Procedure.s GetPreference(Group.s, Key.s)
		Protected *Group.Group = *this.IsGroup(Group), *Option.Option
		If *Group
			*Option = *Group.IsKey(Key)
			If *Option
				ProcedureReturn *Option\Value
			EndIf
		EndIf
		ProcedureReturn ""
	EndProcedure
EndClass

; IDE Options = PureBasic v3.94 (Windows - x86)
; CursorPosition = 5
; Folding = --