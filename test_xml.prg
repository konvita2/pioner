* test xml msxml
public oxml as msxml.DOMDocument
public nodwb as msxml.IXMLDOMNode
public nodew as msxml.IXMLDOMNode
public nod as msxml.IXMLDOMNode
public nodws as msxml.IXMLDOMNode
public nodtb as msxml.IXMLDOMNode

oxml = createobject("Msxml2.Domdocument")

nod = oxml.createProcessingInstruction("xml",'version="1.0"')
oxml.appendChild(nod)

nod = oxml.createProcessingInstruction('mso-application','progid="Excel.Sheet"')
oxml.appendChild(nod)

* Workbook
nodwb = oxml.createElement("Workbook")

att = oxml.createAttribute('xmlns')
att.Value = 'urn:schemas-microsoft-com:office:spreadsheet'
nodwb.setAttributeNode(att)

att = oxml.createAttribute('xmlns:o')
att.Value = "urn:schemas-microsoft-com:office:office"
nodwb.setAttributeNode(att)

att = oxml.createAttribute('xmlns:x')
att.Value = "urn:schemas-microsoft-com:office:excel"
nodwb.setAttributeNode(att)

att = oxml.createAttribute('xmlns:ss')
att.Value = "urn:schemas-microsoft-com:office:spreadsheet"
nodwb.setAttributeNode(att)

att = oxml.createAttribute('xmlns:html')
att.Value = "http://www.w3.org/TR/REC-html40"
nodwb.setAttributeNode(att)

oxml.appendChild(nodwb)

*!*	nod = oxml.createNode(1,'root','')
*!*	oxml.appendChild(nod)

* DocumentProperties
noddp = oxml.createElement("DocumentProperties")

att = oxml.createAttribute('xmlns')
att.Value = 'urn:schemas-microsoft-com:office:spreadsheet'
noddp.setAttributeNode(att)

nodwb.appendChild(noddp)

* ExcelWorkbook
nodew = oxml.createElement("ExcelWorkbook")

	nod = oxml.createNode(1,"WindowHeight","")
	nod.text = "11640"
	nodew.appendChild(nod)

	nod = oxml.createNode(1,"WindowWidth","")
	nod.text = "15480"
	nodew.appendChild(nod)

	nod = oxml.createNode(1,"WindowTopX","")
	nod.text = "600"
	nodew.appendChild(nod)

	nod = oxml.createNode(1,"WindowTopY","")
	nod.text = "120"
	nodew.appendChild(nod)
	
	nod = oxml.createNode(1,"RefModeR1C1","")
	nodew.appendChild(nod)

	nod = oxml.createNode(1,"ProtectStructure","")
	nod.text = "False"
	nodew.appendChild(nod)
	
	nod = oxml.createNode(1,"ProtectWindows","")
	nod.text = "False"
	nodew.appendChild(nod)

nodwb.appendChild(nodew)

* Worksheet
nodws = oxml.createElement("Worksheet")

	att = oxml.createAttribute('ss:Name')
	att.Value = "Лист1"
	nodws.setAttributeNode(att)
	
	* Table
	nodtb = oxml.createElement("Table")
	att = oxml.createAttribute("ss:ExpandedColumnCount")
	att = oxml.createAttribute("ss:ExpandedRowCount")
	att = oxml.createAttribute("x:FullColumns")
	att = oxml.createAttribute("x:FullRows")
	att = oxml.createAttribute("ss:StyleID")
	att = oxml.createAttribute("ss:DefaultRawHeight")
	
	nodws.appendChild(nodtb)	

nodwb.appendChild(nodws)




oxml.save('test1.xml')