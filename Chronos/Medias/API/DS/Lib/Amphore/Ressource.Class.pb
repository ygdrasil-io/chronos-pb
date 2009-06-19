Class Ressource
	*Res
	File.s
	ID.l
	
	Procedure Ressource(*Res.i, File.s, ID.l)
		*this\Res = *Res
		*this\File = File
		*this\ID = ID
	EndProcedure
	
	Procedure GetRessource()
		ProcedureReturn *this\Res
	EndProcedure

	Procedure Free()
		FreeMemory(*this\Res)
		FreeMemory(*this)
	EndProcedure
EndClass
