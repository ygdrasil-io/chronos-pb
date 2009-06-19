XIncludeImport "DS.Lib.MCV.Event"


Class MCV
	*Event.SharedArray = New SharedArray()
	*EventType.Array = New Array()
	
	Procedure AddEventType(Type.l, *Function.i)
		*this\EventType.setElement(Type,*Function)
	EndProcedure
	
	
	Procedure EmptyStack()
		Protected n, *Event.MCVEvent
		*this\Event.Lock()
		For n = 1 To *this\Event.CountElement()
			*Event = *this\Event.GetElement(n)
			CompilerIf #MCV_Thread = #True
				CreateThread(*this\EventType.GetElement(*Event\Event), *Event\Ptr)
			CompilerElse
				CallCFunctionFast(*this\EventType.GetElement(*Event\Event), *Event\Ptr)
			CompilerEndIf
		Next n
		*this\Event.removeAll()
		*this\Event.UnLock()
	EndProcedure
EndClass	
