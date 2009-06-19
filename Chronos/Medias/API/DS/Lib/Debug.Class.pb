#Error = -1
#Debug_File = 666
#Debug_FileName="log.txt"
Macro StartDebug()
	CompilerIf #Debug=1
		OpenConsole()
		If FileSize(#Debug_FileName) = -2
			DeleteDirectory(#Debug_FileName,  "*.*" , #PB_FileSystem_Recursive | #PB_FileSystem_Force  )
		EndIf
		If FileSize(#Debug_FileName) = -1
			CreateFile(#Debug_File, #Debug_FileName)
		Else
			OpenFile(#Debug_File, #Debug_FileName)
			FileSeek(#Debug_File, Lof(#Debug_File))
		EndIf
		WriteStringN(#Debug_File, "------------------"+FormatDate("%dd/%mm/%yy", Date()) + "------------------")
	CompilerEndIf
EndMacro


Macro Write(texte)
	CompilerIf #Debug=1
		WriteStringN(#Debug_File, FormatDate("(%hh:%ii:%ss) ", Date())+texte)
		FlushFileBuffers(#Debug_File)
		PrintN(texte)
	CompilerEndIf
EndMacro

