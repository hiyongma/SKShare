<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Twitterprofile.aspx.cs" Inherits="XBOXONEAnnotation.Twitterprofile" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="scripts/CommonScript.js"></script>
    <script src="scripts/jquery-1.2.1.js"></script>
    <script type="text/javascript" language="javascript">
        window.onload = function () {
            PageMethods.getscreenname(CallscreennameSuccess, CallFailed);
        }

        function CallscreennameSuccess(res) {
            if (res != null) {

                var container = document.getElementById('idselection');
                var namelist = res.split(':$:');
                for (var i = 0; i < namelist.length; i++) {
                    if(namelist[i].length > 0)
                        AppendCheckbox(container, namelist[i], namelist[i], false);
                }
            }
        }

        function CallFailed(res) {

        }

        function reviewreport() {
            var screenname = document.getElementById('idinputscreenname').value;
            var viewdata = document.getElementById('idcolumn').value;
            if(screenname.length > 0 && viewdata.length > 0)
                PageMethods.calltwitterapi(screenname, viewdata, calltwitterapiSuccess, CallFailed);
        }

        function calltwitterapiSuccess(res) {

        }

        function screennameover() {
            var location = new Position();
            GetPosition(document.getElementById('idinputscreenname'), location);
            var moveobject = document.getElementById('idselection');
            moveobject.style.left = location.left + 'px';
            moveobject.style.top = location.top + location.height - 2 + 'px';
        }

        function Screennameout() {
            if (event.srcElement.id == 'idinputscreenname' && (event.toElement == null || event.toElement.id != 'idselection')) {
                element = document.getElementById('idselection');
                if (!element.contains(event.toElement)) {
                    var moveobject = document.getElementById('idselection');
                    moveobject.style.left = -1000 + 'px';
                }
            }
            else if (event.srcElement.id == 'idselection')
            {
                element = document.getElementById('idselection');
                if(event.toElement == null || (event.toElement.id != 'idselection' && event.toElement.id != 'idinputscreenname' && !element.contains(event.toElement)))
                {
                    var moveobject = document.getElementById('idselection');
                    moveobject.style.left = -1000 + 'px';
                }
            }
        }

        function checkname() {
            var src = event.srcElement;
            var des = document.getElementById('idinputscreenname');
            var value = src.value, tmpvalue;
            if (src.checked) {
                tmpvalue = des.value;
                if (tmpvalue.length > 0)
                    des.value = tmpvalue + ',' + value;
                else
                    des.value = value;
            }
            else {
                tmpvalue = des.value;
                tmpvalue = tmpvalue.replace(',' +value, '').replace(value + ',', '').replace(value, '');
                des.value = tmpvalue;
            }
        }

        function columnover() {
            var location = new Position();
            GetPosition(document.getElementById('idcolumn'), location);
            var moveobject = document.getElementById('idcolumnselect');
            moveobject.style.left = location.left + 'px';
            moveobject.style.top = location.top + location.height - 2 + 'px';
        }

        function columnout() {
            if (event.srcElement.id == 'idcolumn' && (event.toElement == null || event.toElement.id != 'idcolumnselect')) {
                element = document.getElementById('idcolumnselect');
                if (!element.contains(event.toElement)) {
                    var moveobject = document.getElementById('idcolumnselect');
                    moveobject.style.left = -1000 + 'px';
                }
            }
            else if (event.srcElement.id == 'idcolumnselect') {
                element = document.getElementById('idcolumnselect');
                if (event.toElement == null || (event.toElement.id != 'idcolumnselect' && event.toElement.id != 'idcolumn' && !element.contains(event.toElement))) {
                    var moveobject = document.getElementById('idcolumnselect');
                    moveobject.style.left = -1000 + 'px';
                }
            }
        }

        function checkcolumnname() {
            var src = event.srcElement;
            var des = document.getElementById('idcolumn');
            var value = src.value, tmpvalue;
            if (src.checked) {
                tmpvalue = des.value;
                if (tmpvalue.length > 0)
                    des.value = tmpvalue + ',' + value;
                else
                    des.value = value;
            }
            else {
                tmpvalue = des.value;
                tmpvalue = tmpvalue.replace(',' + value, '').replace(value + ',', '').replace(value, '');
                des.value = tmpvalue;
            }
        }

        function AppendCheckbox(container, text, value, selected) {
            var id = "id" + value;
            var checkbox = document.createElement('input');
            checkbox.type = "checkbox";
            //    checkbox.text = text;
            checkbox.value = value;
            checkbox.id = id;

            var label = document.createElement(value);
            label.htmlFor = id;
            label.appendChild(document.createTextNode(text));
            container.appendChild(checkbox);
            container.appendChild(label);
            container.appendChild(document.createElement("br"));
            checkbox.checked = selected;
            checkbox.name = 'Parameters';
//            checkbox.onclick = (function (td) {
//                return function () {
//                    CheckBoxOnClick(td);
//                };
//            })(td);
            checkbox.onclick = (function () {
               checkname();
            });
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <asp:ScriptManager ID="ScriptManager" EnablePageMethods="true" runat="server"></asp:ScriptManager>
    <div>
        <table>
            <tr>
                <td>Screen Name</td>
                <td><input type="text" id="idinputscreenname" style="width:400px; cursor:default" onmouseover='screennameover();' onmouseout='Screennameout();'/></td>
                <td style="width:100px"></td>
                <td>View Data</td>
                <td><input type="text" id="idcolumn" value="UserID,ScreenName,FollowerScount,FriendScount,Following" style="width:400px; cursor:default" onmouseover='columnover();' onmouseout='columnout();'/></td>
                <td style="width:100px"></td>
                <td><input type="button" value="Review Report" style="width:150px" onclick="reviewreport();"/></td>
            </tr>
        </table>
    </div>

    <div id = "idselection" style="width:403px; height:100px; border:solid 1px gray; overflow:auto; position:absolute; left:-1000px" onmouseout='Screennameout();'> 
    </div>

<%--    Createdat, id, text, source, userid, username, userlocation, userdescription, userurl, followerscount, friendscount, userlistedcount, usercreatedat,
     usertimezone, userlanguage, following--%>
    <div id = "idcolumnselect" style="width:403px; height:100px; border:solid 1px gray; overflow:auto; position:absolute; left:-1000px" onmouseout='columnout();'>
                    <input name = 'op0' type="checkbox" value="Createdat" onclick='checkcolumnname();' />
                      Createdat<br />
                    <input name="op1" type="checkbox" value="ID" onclick='checkcolumnname();' />
                      ID<br />
                    <input name="op2" type="checkbox" value="Text" onclick='checkcolumnname();' />
                      Text<br />
                    <input name="op3" type="checkbox" value="Source" onclick='checkcolumnname();' />
                      Source<br />
                    <input name="op4" type="checkbox" value="UserID" onclick='checkcolumnname();' checked="checked"/>
                      UserID<br />
                    <input name="op5" type="checkbox" value="ScreenName" onclick='checkcolumnname();' checked="checked"/>
                      ScreenName<br /> 
                    <input name = 'op6' type="checkbox" value="UserLocation" onclick='checkcolumnname();' />
                      UserLocation<br />
                    <input name="op7" type="checkbox" value="UserDescription" onclick='checkcolumnname();' />
                      UserDescription<br />
                    <input name="op8" type="checkbox" value="UserURL" onclick='checkcolumnname();' />
                      UserURL<br />
                    <input name="op9" type="checkbox" value="FollowerScount" onclick='checkcolumnname();' checked="checked"/>
                      FollowerScount<br />
                    <input name="op10" type="checkbox" value="FriendScount" onclick='checkcolumnname();' checked="checked"/>
                      FriendScount<br />
                    <input name="op11" type="checkbox" value="UserListedCount" onclick='checkcolumnname();' />
                      UserListedCount<br /> 
                    <input name = 'op12' type="checkbox" value="UserCreatedat" onclick='checkcolumnname();' />
                      UserCreatedat<br />
                    <input name="op13" type="checkbox" value="UserTimezone" onclick='checkcolumnname();' />
                      UserTimezone<br />
                    <input name="op14" type="checkbox" value="UserLanguage" onclick='checkcolumnname();' />
                      UserLanguage<br />
                    <input name="op15" type="checkbox" value="Following" onclick='checkcolumnname();' checked="checked"/>
                      Following<br />
    </div>

    </form>
</body>
</html>