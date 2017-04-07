<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm1.aspx.cs" Inherits="XBOXONEAnnotation.WebForm1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        .auto-style1 {
            color: #339933;
        }
        .auto-style2 {
            width: 116px;
        }
        .auto-style3 {
            height: 20pt;
            width: 116px;
        }
    </style>
    <link href="rte.css" rel="stylesheet" />
    <script src="scripts/richtext.js"></script>
    <script src="scripts/CommonScript.js"></script>
    <script src="scripts/jquery-1.2.1.js"></script>

    <link href="rte.css" rel="stylesheet" />
    <script type="text/javascript" language="javascript">
        window.onload = function () {
            window.resizeTo(825, 560);
            var location = new Position();
            GetPosition(document.getElementById('Buttons1_rte1'), location);
            var moveobject = document.getElementById('Buttons2_rte1');
            moveobject.style.left = location.left + 'px';
            moveobject.style.top = location.top + location.height - 32 + 'px';
            moveobject = document.getElementById('rte1');
            moveobject.style.left = location.left + 'px';
            moveobject.style.top = location.top + location.height + 20 + 'px';
            var iframe = document.getElementById('rte1');
            //iframe.contentDocument.designMode = "on";
            //iframe.contentWindow.document = "on";

            var doc = iframe.contentWindow.document;
            doc.designMode = 'on';
            //var html = '<html id="rte100"><head><style>body { background: #FFFFFF; margin: 0px; height:10px; padding: 0px; } </style> </head> <body></body></html>'
            //doc.write(html);
            //document.addEventListener("keypress", kb_handler, true);
            //document.addEventListener("mousemove", kb_handl, true);


            //if (iframe.addEventListener) {
            //    doc.addEventListener("keypress", kb_handler, true);
            //} else {
            //    doc.attachEvent('keypress', kb_handler);
            //}

            //doc.close();
            moveobject = document.getElementById('idsubmitable');
            moveobject.style.left = '140px';
            moveobject.style.top = '420px';

            var timeid = getURLParameters('Timeid');
            var subject = getURLParameters('subject');
            var body = getURLParameters('body');
            //timeid = '417151078'
            //PageMethods.load(417280865, subject, CallloadSuccess, CallFailed);
            PageMethods.load(timeid, subject, CallloadSuccess, CallFailed);
            //PageMethods.test(417280865, CallloadSuccess, CallFailed);
            if (timeid != null) {    
                document.getElementById('hdnrte1').value = timeid;
            }

            if (subject != null) {
                document.getElementById('idsubject').value = subject;
            }

            if (body != null) {
                var iframe = document.getElementById('rte1');
                var doc = iframe.contentWindow.document;
                doc.body.innerHTML = body;
            }
        }


        function CallloadSuccess(res) {
            //alert(res);
            var annotation = res.split(':$:');
            if (annotation[0].length > 0) {
                document.getElementById('rte1').contentWindow.document.body.innerHTML = annotation[0];
            }
            if (annotation[1].length > 0) {
                document.getElementById('txalias').value = annotation[1];
            }
        }

        function usersubmit() {
            var content, alias, timeid, subject;
            var iframe = document.getElementById('rte1');
            var doc = iframe.contentWindow.document;
            content = doc.body.innerHTML;
            alias = document.getElementById('txalias').value;
            timeid = document.getElementById('hdnrte1').value;
            subject = document.getElementById('idsubject').value;

            if (content.length != 0 && alias.length != 0)
                PageMethods.submit(timeid, content, alias, subject, CallUpdateSuccess, CallFailed);
            else if (content.length == 0)
                alert('Please type annotation!');
            else
                alert('Please enter alias!');
            //alert(content);
            //window.open('', '_self', '');
            //window.close();
            return false;
        }

        function CallUpdateSuccess(res) {
            //alert(res);
            window.open('', '_self', '');
            window.close();
        }

        function CallFailed(res, destCtrl) {
            //alert("res");
            return false;
        }

        function getURLParameters(paramName) {
            var sURL = window.document.URL.toString();
            if (sURL.indexOf("?") > 0) {
                var arrParams = sURL.split("?");
                var arrURLParams = arrParams[1].split("&");
                var arrParamNames = new Array(arrURLParams.length);
                var arrParamValues = new Array(arrURLParams.length);
                var i = 0;
                for (i = 0; i < arrURLParams.length; i++) {
                    var sParam = arrURLParams[i].split("=");
                    arrParamNames[i] = sParam[0];
                    if (sParam[1] != "")
                        arrParamValues[i] = unescape(sParam[1]);
                    else
                        arrParamValues[i] = "No Value";
                }

                for (i = 0; i < arrURLParams.length; i++) {
                    if (arrParamNames[i] == paramName) {
                        //alert("Param:"+arrParamValues[i]);
                        return arrParamValues[i];
                    }
                }
            }

            return null
        }

        function usercancel() {
            //alert('cancel');
            window.open('', '_self', '');
            window.close();
            return false;
        }

        function userdelete() {
            var content, alias, timeid, subject;
            var iframe = document.getElementById('rte1');
            var doc = iframe.contentWindow.document;
            content = doc.body.innerHTML;
            alias = document.getElementById('txalias').value;
            timeid = document.getElementById('hdnrte1').value;
            subject = document.getElementById('idsubject').value;
            if (content.length != 0 && alias.length != 0)
                PageMethods.userdelete(timeid, content, alias, subject, CallUpdateSuccess, CallFailed);
            else if (content.length == 0)
                alert('Please type annotation!');
            else
                alert('Please enter alias!');

            return false;
        }


    </script>
</head>
<body>
    <form id="form1" runat="server">
    <asp:ScriptManager ID="ScriptManager" EnablePageMethods="true" runat="server"></asp:ScriptManager>
    <div>

    <table>
             <tr><td colspan="3" style="text-align:center; font-family: Verdana, Geneva, Tahoma, sans-serif; font-size:large; font-weight: bold; color: #008000">SI XBOX ONE Annotation</td></tr>

             <tr>
                 <td class="auto-style2">
                     <h3><span class="auto-style1"><strong>From:</strong></span></h3>
                 </td>
                 <td></td>
                 <td><input type="text" id="txalias" style="width:200px; height:25px;font-size:larger" value="alias" /></td>
             </tr>

             <tr>
                 <td class="auto-style2">
                     <h3><span class="auto-style1"><strong>Subject:</strong></span></h3>
                 </td>
                 <td></td>
                 <td><input type="text" id="idsubject" style="width:544px; height:25px;font-size:larger" value=""/></td>
             </tr>

             <tr>
                 <td class="auto-style2">
                     <h3><span class="auto-style1"><strong>Annotations:</strong></span></h3>
                 </td>
                 <td></td>
                 <td><div style="text-align:center">
                        <table class="rteBack" style="padding:2px; text-space-collapse:preserve; width:544px;" id="Buttons1_rte1">
                        <tr>
                            <td>
                                <select id="formatblock_rte1" onchange="selectFont('rte1', this.id);">
                        <option value="">[Style]</option>
                        <option value="<p>">Paragraph &lt;p&gt;</option>
                        <option value="<h1>">Heading 1 &lt;h1&gt;</option>
                        <option value="<h2>">Heading 2 &lt;h2&gt;</option>
                        <option value="<h3>">Heading 3 &lt;h3&gt;</option>
                        <option value="<h4>">Heading 4 &lt;h4&gt;</option>
                        <option value="<h5>">Heading 5 &lt;h5&gt;</option>
                        <option value="<h6>">Heading 6 &lt;h6&gt;</option>
                        <option value="<address>">Address &lt;ADDR&gt;</option>
                        <option value="<pre>">Formatted &lt;pre&gt;</option>
                            </select>
                            </td>
                            <td>
                            <select id="fontname_rte1" onchange="selectFont('rte1', this.id)">
                        <option value="Font" selected="selected">[Font]</option>
                        <option value="Arial, Helvetica, sans-serif">Arial</option>
                        <option value="Courier New, Courier, mono">Courier New</option>
                        <option value="Times New Roman, Times, serif">Times New Roman</option>
                        <option value="Verdana, Arial, Helvetica, sans-serif">Verdana</option>
                            </select>
                            </td>
                            <td>
                            <select id="fontsize_rte1" onchange="selectFont('rte1', this.id);">
                        <option value="Size">[Size]</option>
                        <option value="1">1</option>
                        <option value="2">2</option>
                        <option value="3">3</option>
                        <option value="4">4</option>
                        <option value="5">5</option>
                        <option value="6">6</option>
                        <option value="7">7</option>
                            </select>
                            </td>
                            <td style="width:100%">
                            </td>
                            </tr>
                            <tr>
                                <td>&nbsp;</td>
                            </tr>
                        </table>
                        <table class="rteBack" style="padding:0px; text-space-collapse:preserve; width:544px; position:absolute" id="Buttons2_rte1">
                        <tr>
                            <td><img id="bold" class="rteImage" src="images/bold.gif" width="25" height="24" alt="Bold" title="Bold" onclick="rteCommand('rte1', 'bold', '')" /></td>
                            <td><img class="rteImage" src="images/italic.gif" width="25" height="24" alt="Italic" title="Italic" onclick="rteCommand('rte1', 'italic', '')" /></td>
                            <!--<td><img class="rteImage" src="imagesPath + 'italic.gif" width="25" height="24" alt="Italic" title="Italic" onclick="rteCommand(\'' + rte + '\', \'italic\', \'\')"></td>');-->
			                <td><img class="rteImage" src="images/underline.gif" width="25" height="24" alt="Underline" title="Underline" onclick="rteCommand('rte1', 'underline', '')" /></td>
			                <td><img class="rteVertSep" src="images/blackdot.gif" width="1" height="20" border="0" alt="" /></td>
			                <td><img class="rteImage" src="images/left_just.gif" width="25" height="24" alt="Align Left" title="Align Left" onclick="rteCommand('rte1', 'justifyleft', '')" /></td>
			                <td><img class="rteImage" src="images/centre.gif" width="25" height="24" alt="Center" title="Center" onclick="rteCommand('rte1', 'justifycenter', '')" /></td>
			                <td><img class="rteImage" src="images/right_just.gif" width="25" height="24" alt="Align Right" title="Align Right" onclick="rteCommand('rte1', 'justifyright', '')" /></td>
			                <td><img class="rteVertSep" src="images/blackdot.gif" width="1" height="20" border="0" alt="" /></td>
			                <td><img class="rteImage" src="images/numbered_list.gif" width="25" height="24" alt="Ordered List" title="Ordered List" onclick="rteCommand('rte1', 'insertorderedlist', '')" /></td>
			                <td><img class="rteImage" src="images/list.gif" width="25" height="24" alt="Unordered List" title="Unordered List" onclick="rteCommand('rte1', 'insertunorderedlist', '')" /></td>
			                <td><img class="rteVertSep" src="images/blackdot.gif" width="1" height="20" border="0" alt="" /></td>
			                <td><img class="rteImage" src="images/outdent.gif" width="25" height="24" alt="Outdent" title="Outdent" onclick="rteCommand('rte1', 'outdent', '')" /></td>
			                <td><img class="rteImage" src="images/indent.gif" width="25" height="24" alt="Indent" title="Indent" onclick="rteCommand('rte1', 'indent', '')" /></td>'
			                <td><img class="rteVertSep" src="images/blackdot.gif" width="1" height="20" border="0" alt="" /></td>
			                <td><img class="rteImage" src="images/hyperlink.gif" width="25" height="24" alt="Insert Link" title="Insert Link" onclick="insertLink('rte1')" /></td>
			                <td style="width:100%"></td>
                        </tr>
                    </table>
                    <iframe id="rte1" name="rte1" style="width:545px; height:200px; position:absolute" src="blank.html"></iframe>
                    <%--<iframe width="154" height="104" id="cprte1" src="palette.htm" marginwidth="0" marginheight="0" scrolling="no" style="visibility:hidden; position: absolute;"></iframe>--%>
                    <input type="text" id="hdnrte1" name="rte1" value="", style="position:absolute; left:-1000px; top:-1000px" />
                    </div>
                 </td>
             </tr>
         </table>




    </div>


    <div style="position:absolute" id="idsubmitable">
                     <table>
                         <tr style="font-family: Verdana, Geneva, Tahoma, sans-serif; font-weight: bolder; color: #008000">
                             <td class="auto-style1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                             <td></td>
                             <td style="width:100px"></td>
                             <td><input type="button" id="btnsubmit" style="width:80px; height:25px; font-weight:bold; font-size:medium; color:#339933" onclick="usersubmit();" value="Submit" /></td>
                             <td><input type="button" id="btnCancel" style="width:80px; height:25px; font-weight:bold; font-size:medium; color:#339933" onclick="usercancel();" value="Cancel" /></td>
                             <td><input type="button" id="btndelete" style="width:80px; height:25px; font-weight:bold; font-size:medium; color:#339933" onclick="userdelete();" value="Delete" /></td>
                         </tr>
                     </table>
     </div>


    </form>
</body>
</html>
