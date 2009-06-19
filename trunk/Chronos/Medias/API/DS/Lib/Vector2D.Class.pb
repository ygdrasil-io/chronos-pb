Class Vector2D
	x.l
	y.l
	
	Procedure.Vector2D Add(*Vector.Vector2D)
		*this\x + *Vector\x
		*this\y + *Vector\y
		ProcedureReturn *this
	EndProcedure
	
	Procedure.Vector2D Sub(*Vector.Vector2D)
		*this\x - *Vector\x
		*this\y - *Vector\y
		ProcedureReturn *this
	EndProcedure
	
	Procedure.d Norme()
		ProcedureReturn Sqr(Pow(*this\x, 2) + Pow(*this\y, 2))
	EndProcedure
	
	Procedure.Vector2D Scalaire(*Vector.Vector2D)
		ProcedureReturn (*this\x * *Vector\x) + (*this\y * *Vector\y)
	EndProcedure	
EndClass

Class SharedVector2D Extends Vector2D
	Mutex.i
	
	Procedure SharedVector2D
		*this\Mutex = CreateMutex()
	EndProcedure
	
	
EndClass	
