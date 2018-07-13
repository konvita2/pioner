lparameters pDom as msxml.DOMDocument, pNod as msxml.IXMLDOMNode, ;
	pAutoFitHeight as String, pHeight as String, pStyleID as String, pIndex as String  
local res as msxml.IXMLDOMNode 
local att as msxml.IXMLDOMAttribute 

res = pDom.createElement('Row')

xml_setattrib(pDom,res,'xmlns','555')

if !empty(pAutoFitHeight)
	att = pDom.createAttribute('ss:AutoFitHeight')
	att.value = pAutoFitHeight
	res.setAttributeNode(att) 
endif

if !empty(pHeight)
	att = pDom.createAttribute('ss:Height')
	att.value = pHeight
	res.setAttributeNode(att) 
endif

if !empty(pStyleID)
	att = pDom.createAttribute('ss:StyleID')
	att.value = pStyleID
	res.setAttributeNode(att) 
endif

if !empty(pIndex)
	att = pDom.createAttribute('ss:Index')
	att.value = pIndex
	res.setAttributeNode(att) 
endif

pNod.appendChild(res)

glnom = glnom + 1

return res



