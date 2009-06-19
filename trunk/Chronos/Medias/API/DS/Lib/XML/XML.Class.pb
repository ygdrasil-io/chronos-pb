Class XML

	Class Node
		Declare GetName As GetXMLNodeName($1)
		Declare GetText As GetXMLNodeText($1)
		Declare GetType As XMLNodeType($1)
		Declare GetAttribute As GetXMLAttribute($1, $2)
		Declare GetChild As ChildXMLNode($1, $2)
	EndClass
	
	Declare XMl As CreateXML($1, $2)
	Declare GetMainNode As MainXMLNode($1)
	Declare Is As IsXML($1)
EndClass



