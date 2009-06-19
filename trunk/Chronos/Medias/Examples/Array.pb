;=============================================================;
;Chronos - Example 1 - Lib Array															;                                     	             																		;                                                  																		;
;=============================================================;

XIncludeImport "DS.Lib.Array"

Define.Array *array = New Array()
Define.l n

*array.addElement(23)
*array.addElement(60)
*array.addElement(40)
*array.setElement(2, 42)

For n = 1 To *array.countElement()
	Debug *array.getElement(n)
Next

*array.Free()
