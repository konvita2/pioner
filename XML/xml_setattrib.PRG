lparameters pDom as MSXML.DOMDocument, pNod as MSXML.IXMLDOMNode, pNamAttr as String, pValAttr as String 
local att as MSXML.IXMLDOMAttribute 

att = pDom.createAttribute(pNamAttr)
att.value = pValAttr
pNod.setAttributeNode(att)

return

