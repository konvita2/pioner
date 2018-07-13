lparameters pDom as msxml.DOMDocument, pNod as msxml.IXMLDOMNode, pStyle as string, pAutoFitWidth as String, pWidth as String, pSpan as String
local nod as msxml.IXMLDOMNode 
local att as msxml.IXMLDOMAttribute 

nod = pDom.createElement('Column')

xml_setattrib(pDom,nod,'xmlns','555')
att = pDom.createAttribute('ss:StyleID')
att.value = pStyle
nod.setAttributeNode(att)

att = pDom.createAttribute('ss:AutoFitWidth')
att.value = pAutoFitWidth 
nod.setAttributeNode(att)

att = pDom.createAttribute('ss:Width')
att.value = pWidth
nod.setAttributeNode(att)

if !empty(pSpan)
	att = pDom.createAttribute('ss:Span')
	att.value = pSpan
	nod.setAttributeNode(att)
endif

pNod.appendChild(nod)


