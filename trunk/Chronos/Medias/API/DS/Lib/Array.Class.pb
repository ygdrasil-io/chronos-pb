;===========================================================
;lib Array
;===========================================================
Class Array
	*ptr = AllocateMemory(1)
	number.i = 0
	
	
	Procedure CountElement()
		ProcedureReturn *this\number
	EndProcedure
	
	Procedure SetElement(number.i, *Element)
		If number > *this\number
			*this\number = number
			*this\ptr = ReAllocateMemory(*this\ptr, number * SizeOf(integer))
		EndIf
		PokeI(*this\ptr + (number-1) * SizeOf(integer), *Element)
	EndProcedure
	
	Procedure AddElement(*Element)
		*this.SetElement(*this\number+1, *Element)
		ProcedureReturn *this\number
	EndProcedure
	
	Procedure FreeElement(number.i)
		If *this\number = 1
			*this\number = 0
		Else
			If number < *this\number
				CopyMemory(*this\ptr + SizeOf(integer)*number,  *this\ptr + SizeOf(integer)*(number - 1), SizeOf(integer)*(*this\number-number))
			EndIf
			*this\number - 1
			*this\ptr = ReAllocateMemory(*this\ptr, *this\number * SizeOf(integer))
		EndIf
	EndProcedure
	
	Procedure Remove(*Element)
		Protected n
		For n = 1 To *this\number
			If PeekI(*this\ptr + (n-1) * SizeOf(integer)) = *Element
				If *this\number = 1
					*this\number = 0
				Else
					If n < *this\number
						CopyMemory(*this\ptr + SizeOf(integer)*n,  *this\ptr + SizeOf(integer)*(n - 1), SizeOf(integer)*(*this\number-n))
					Else
						ProcedureReturn #False	
					EndIf
					*this\number - 1
					*this\ptr = ReAllocateMemory(*this\ptr, *this\number * SizeOf(integer))
				EndIf
				ProcedureReturn #True
			EndIf
		Next
		ProcedureReturn #False
	EndProcedure
	
	Procedure GetElement(number.i)
		If number <= *this\number
			ProcedureReturn PeekI(*this\ptr + (number-1) * SizeOf(integer))
		Else
			ProcedureReturn 0
		EndIf
	EndProcedure
	
	Procedure RemoveAll()
		*this\number  = 0
		*this\ptr = ReAllocateMemory(*this\ptr, 1)
	EndProcedure
	
	Procedure Free()
		FreeMemory(*this\ptr)
		FreeMemory(*this)
	EndProcedure
EndClass

Class SharedArray Extends Array
	Mutex.i = CreateMutex()
	
	Procedure SharedArray()
		*this\ptr = AllocateMemory(1)
		*this\number.i = 0
	EndProcedure
	
	Declare Lock As LockMutex($1\Mutex)
	Declare UnLock As UnLockMutex($1\Mutex)
EndClass	
