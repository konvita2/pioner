lparameters dom as msxml.DOMDocument 

local nod as msxml.IXMLDOMNode 
local nodRowBreak as msxml.IXMLDOMNode 
local nodRow as msxml.IXMLDOMNode 

nod = dom.selectSingleNode('//RowBreaks')

nodRowBreak = dom.createElement('RowBreak')
xml_setattrib(dom,nodRowBreak,'xmlns','555') 
nod.appendChild(nodRowBreak)

nodRow = dom.createElement('Row')
xml_setattrib(dom,nodRow,'xmlns','555') 
nodRow.text = alltrim(str(glnom-1))
nodRowBreak.appendChild(nodRow)