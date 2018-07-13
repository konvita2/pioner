public oxml as MSXML.DOMDocument
public nod as MSXML.IXMLDOMNode 

oxml = createobject('Msxml2.Domdocument')
oxml.load(sys(5)+sys(2003)+'\msl_pattern.xml')

nod = oxml.selectSingleNode('//Worksheet')
if nod = null
	wait window 'not found'
else
	wait window 'found'	
endif

a = 1
