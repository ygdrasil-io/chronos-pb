Class Node
	*Child.Array = New Array()
	Type.l
	
	Procedure AddChild(*node.Node)
		*this\Child.AddElement(*node)
	EndProcedure
	
	Procedure size()
		protected n, size = *this\Child.CountElement()
		protected *Child.Node
		For n = 1 to *this\Child.CountElement()
			*Child = *this\Child.GetElement(n)
			size + *Child.size()
		next n	
		ProcedureReturn size
	EndProcedure
	
	Procedure countChild()
		ProcedureReturn *this\Child.CountElement()
	EndProcedure
	
	Procedure.Node GetChildNode(n.l)
		ProcedureReturn *this\Child.GetElement(n)
	EndProcedure
	
	Procedure.Node GetNode(n.l)
		Protected Count.l = *this\Child.CountElement(), *Child.Node, i.l, ChildSize.l
		If n = 0
			ProcedureReturn *this
		EndIf
		For i = 1 to Count
			n - 1
			*Child = *this\Child.GetElement(i)
			If n = 0
				ProcedureReturn *Child
			EndIf
			ChildSize = *Child.size()
			If n > ChildSize
				n - ChildSize
			Else
				ProcedureReturn *Child.GetNode(n)
			EndIf
		Next i
		ProcedureReturn #Null
	EndProcedure
	
	Procedure.Node removeNode(n.l)
		Protected Count.l = *this\Child.CountElement(), *Child.Node, i.l, ChildSize.l
		If n = 0
			ProcedureReturn *this
		EndIf
		For i = 1 to Count
			n - 1
			*Child = *this\Child.GetElement(i)
			If n = 0
				*this\Child.FreeElement(i)
				ProcedureReturn *Child
			EndIf
			ChildSize = *Child.size()
			If n > ChildSize
				n - ChildSize
			Else
				ProcedureReturn *Child.GetNode(n)
			EndIf
		Next i
		ProcedureReturn #Null
	EndProcedure	
EndClass	


Class SharedNode Extends Node
	Mutex.i = CreateMutex()
	
	Procedure SharedNode()
		*this\Child = New Array()
	EndProcedure
	
	Declare Lock As LockMutex($1\Mutex)
	Declare UnLock As UnLockMutex($1\Mutex)
EndClass	
