lparameters pDom as msxml.DOMDocument, pNod as msxml.IXMLDOMNode, ;
	pStyleID as String, pText as String, pIndex as String, ;
	pMergeAccross as String, pType as String, pFormula as String
	  
local mcell as msxml.IXMLDOMNode
local mdata as msxml.IXMLDOMNode
local att as msxml.IXMLDOMAttribute 

mcell = pDom.createElement('Cell')

xml_setattrib(pDom,mcell,'xmlns','555')

if !empty(pStyleID)
	att = pDom.createAttribute('ss:StyleID')
	att.value = pStyleID
	mcell.setAttributeNode(att)
endif

if !empty(pIndex)
	xml_setattrib(pDom,mcell,'ss:Index',pIndex)
endif

if !empty(pMergeAccross )
	xml_setattrib(pDom,mcell,'ss:MergeAcross',pMergeAccross )
endif

pNod.appendChild(mcell)

mdata = pDom.createElement('Data')

if empty(pType)
	xml_setattrib(pDom,mdata,'xmlns','555')
	att = pDom.createAttribute('ss:Type')
	att.value = 'String'
	mdata.setAttributeNode(att)
else
	xml_setattrib(pDom,mdata,'xmlns','555')
	att = pDom.createAttribute('ss:Type')
	att.value = pType
	mdata.setAttributeNode(att)
endif

if !empty(pFormula)
	atr = pDom.createAttribute('ss:Formula')
	atr.value = pFormula
	mcell.setAttributeNode(atr)	
endif

mdata.text = pText

mcell.appendChild(mdata)


