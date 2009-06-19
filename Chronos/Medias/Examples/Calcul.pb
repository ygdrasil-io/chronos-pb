;=============================================================;
;Chronos - Example 2 - Lib Calcul															;                                     	             																		;                                                  																		;
;=============================================================;

XIncludeImport "DS.Lib.Chaos.Calcul"

Procedure.q ElapsedCycles()
	!rdtsc
	ProcedureReturn
EndProcedure

#ForCycle = 1
Define.q Result1, Result2


Define *Chaos.Chaos
Define.Operation *Example1, *Example2, *Example3
Define *Var.i, n, temp.d

*Chaos = New Chaos() ;init chaos script engine

*Example1 = New Operation(*Chaos , "3+20/100")
*Example2 = New Operation(*Chaos, "Cos(24)*4")
*Example3 = New Operation(*Chaos, "$1 * $2")

*var = AllocateMemory(SizeOf(double)*2)
PokeD(*var, 10)
PokeD(*var + SizeOf(double), 24)



EnableDebugger
Debug "Result :"
Debug "3+20/100 = "
Debug *Example1.Execute()
Debug 3+20/100
Debug "Cos(24)*4 = "
Debug *Example2.Execute()
Debug Cos(24)*4
Debug "$1 = 10, $2 = 24  : $1 * $2 = "
Debug *Example3.Execute(*var)
Debug 10*24
Debug "Now CPU usage with " + Str(#ForCycle) +" cycles :"
DisableDebugger

Result1 = ElapsedCycles()
For n = 1 To #ForCycle
	temp = *Example1.Execute()
Next
Result1 = ElapsedCycles() - Result1

Result2 = ElapsedCycles()
For n = 1 To #ForCycle
	temp = 3+20/100
Next
Result2 = ElapsedCycles() - Result2

EnableDebugger
Debug "3+20/100"
Debug "Chaos :" + str(Result1)
Debug "ASM : " + str(Result2)
Debug "Factor : " + str(Result1/Result2/#ForCycle)
DisableDebugger

Result1 = ElapsedCycles()
For n = 1 To #ForCycle
	temp = *Example2.Execute()
Next
Result1 = ElapsedCycles() - Result1

Result2 = ElapsedCycles()
For n = 1 To #ForCycle
	temp = Cos(24)*4
Next
Result2 = ElapsedCycles() - Result2

EnableDebugger
Debug "Cos(24)*4"
Debug "Chaos :" + str(Result1)
Debug "ASM : " + str(Result2)
Debug "Factor : " + str(Result1/Result2/#ForCycle)
DisableDebugger

Result1 = ElapsedCycles()
For n = 1 To #ForCycle
	temp = *Example3.Execute(*var)
Next
Result1 = ElapsedCycles() - Result1

Result2 = ElapsedCycles()
For n = 1 To #ForCycle
	temp = 10*24
Next
Result2 = ElapsedCycles() - Result2

EnableDebugger
Debug "10*24"
Debug "Chaos :" + str(Result1)
Debug "ASM : " + str(Result2)
Debug "Factor : " + str(Result1/Result2/#ForCycle)

