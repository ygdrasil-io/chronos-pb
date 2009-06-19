XIncludeImport "DS.Lib.Node"
XIncludeImport "DS.Lib.Array"



Class MCVEvent
	Event.l
	*Ptr.i
	Procedure MCVEvent(Event.l, *Ptr.i)
		*this\Child = New Array()
		*this\Ptr= *Ptr	
	EndProcedure
	
	
EndClass
