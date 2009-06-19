Class NewPrefs
	Group.s
	Name.s
	Value.s
EndClass

Procedure NewNewPref(Group.s, Name.s, Value.s)
	Protected *this.NewPrefs = AllocateMemory(SizeOf(NewPrefs))
	*this\Name = Name
	*this\Group = Group
	*this\Value = Value
	*system\NewPrefs.AddElement(*this)
EndProcedure




