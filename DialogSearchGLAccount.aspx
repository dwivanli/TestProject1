<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DialogSearchGLAccount.aspx.cs" Inherits="BudgetPlan.DialogSearchGLAccount" %>
<%@ Register TagPrefix="telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Select GLAccount</title>
</head>
<body>
    <form id="form1" runat="server">
        <telerik:RadScriptManager ID="RadScriptManager1" runat="server"></telerik:RadScriptManager>

    <telerik:RadCodeBlock ID="RadCodeBlock1" runat="server">
    <script src="scripts/jquery-1.7.1.min.js"></script>
    <script type="text/javascript">
        //Put your JavaScript code here.

        function GetRadWindow() {
            var oWindow = null;
            if (window.radWindow) oWindow = window.radWindow;
            else if (window.frameElement.radWindow) oWindow = window.frameElement.radWindow;
            return oWindow;
        }

        function returnToParent() {
            //create the argument that will be returned to the parent page
            var oArg = new Object();

            //get the city's name            
            //oArg.cityName = document.getElementById("cityName").value;

            //not work, cannot find GLAccount value
            //var masterTableView = $find("<%= RadGridSearch.ClientID %>").get_masterTableView();
            //var GLAccount = masterTableView.get_selectedItems()[0].getDataKeyValue('GLAccount'); 
            //alert(GLAccount);

            var id = "";
            var GLAccount = "";
            var grid = $find("<%=RadGridSearch.ClientID %>");
            var MasterTable = grid.get_masterTableView();
            var selectedRows = MasterTable.get_selectedItems();
            for (var i = 0; i < selectedRows.length; i++) {
                var row = selectedRows[i];
                var cell = MasterTable.getCellByColumnUniqueName(row, "GLAccount")
                //here cell.innerHTML holds the value of the cell 
                /*
                if (id.length > 0) {
                    id += "," + cell.innerText.replace(' ', '');
                }
                else {
                    id += cell.innerText.replace(' ', '');
                }
                */
                GLAccount = cell.innerText.replace(' ', '');
            }
            //alert("Cell Value: " + id);

            //alert("GLAccount Cell Value: " + GLAccount);
            oArg.GLAccount = GLAccount;

            /*
            var grd = sender;
            var masterTable = grd.get_masterTableView();
            var GLAccount = masterTable.get_selectedItems()[0].getDataKeyValue('GLAccount');
            oArg.cityName = GLAccount;
            */

            //get the selected date from RadDatePicker
            //var datePicker = $find(dpId);
            //oArg.selDate = datePicker.get_selectedDate().toLocaleDateString();

            //get a reference to the current RadWindow
            var oWnd = GetRadWindow();

            //Close the RadWindow and send the argument to the parent page
            oWnd.close(oArg);
            /*
            if (oArg.selDate && oArg.cityName) {
                oWnd.close(oArg);
            }
            else {
                alert("Please fill both fields");
            }
            */
        }
    </script>
    </telerik:RadCodeBlock>

    <telerik:RadAjaxManager runat="server" ID="RadAjaxManager1">
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="RadButtonSearch">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGridSearch"/>
                    <telerik:AjaxUpdatedControl ControlID="RadLabelMsg"/>
                    <telerik:AjaxUpdatedControl ControlID="RadLabelErrorMsg" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="RadGridSearch">
                <UpdatedControls>                        
                    <telerik:AjaxUpdatedControl ControlID="RadGridSearch"/>                                               
                    <telerik:AjaxUpdatedControl ControlID="RadLabelMsg"/>
                    <telerik:AjaxUpdatedControl ControlID="RadLabelErrorMsg" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManager>

    <div>
        <telerik:RadLabel ID="RadLabelErrorMsg" runat="server" ForeColor="Red"></telerik:RadLabel>
        <telerik:RadLabel ID="RadLabelMsg" runat="server" ForeColor="Red"></telerik:RadLabel>
    </div>

        <div>
            <telerik:RadLabel ID="RadLabelGLAccount" runat="server" AssociatedControlID="RadTextBoxGLAccount">GLAccount StartsWith</telerik:RadLabel>
            <telerik:RadTextBox ID="RadTextGLAccount" runat="server" ></telerik:RadTextBox>
            <telerik:RadButton ID="RadButtonSearch" runat="server" Text="Search" Skin="Web20" OnClick="RadButtonSearch_Click"></telerik:RadButton>
        </div>
        <div>
            <telerik:RadGrid ID="RadGridSearch" runat="server" Visible="true" AllowFilteringByColumn="True" AllowPaging="True" AllowSorting="True" DataSourceID="SqlDataSourceSearch" OnItemCommand="RadGridSearch_ItemCommand">
                <GroupingSettings CollapseAllTooltip="Collapse all groups"></GroupingSettings>
                <ClientSettings>
                    <Selecting AllowRowSelect="True" />
                    <Scrolling AllowScroll="True" UseStaticHeaders="True" />
                </ClientSettings>
                <MasterTableView CommandItemDisplay="None" AutoGenerateColumns="False" DataKeyNames="GLAccount" DataSourceID="SqlDataSourceSearch">
                    <CommandItemTemplate>
                        <telerik:RadButton ID="RadButtonSearchOK" runat="server" Text="OK" CommandName="RadButtonSearchOK" ></telerik:RadButton>
                        <telerik:RadButton ID="RadButtonSearchCancel" runat="server" Text="Cancel" CommandName="RadButtonSearchCancel" ></telerik:RadButton>
                    </CommandItemTemplate>
                    <Columns>
                    <telerik:GridClientSelectColumn Reorderable="False" Resizable="False" ShowSortIcon="False" 
                    UniqueName="column">  
                    </telerik:GridClientSelectColumn> 
                        <telerik:GridBoundColumn DataField="GLAccount" FilterControlAltText="Filter GLAccount column" HeaderText="GLAccount" ReadOnly="True" SortExpression="GLAccount" UniqueName="GLAccount">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="AccountDesc" FilterControlAltText="Filter AccountDesc column" HeaderText="AccountDesc" ReadOnly="True" SortExpression="AccountDesc" UniqueName="AccountDesc">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="COACode" FilterControlAltText="Filter COACode column" HeaderText="COACode" ReadOnly="True" SortExpression="COACode" UniqueName="COACode">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Company" FilterControlAltText="Filter Company column" HeaderText="Company" ReadOnly="True" SortExpression="Company" UniqueName="Company">
                        </telerik:GridBoundColumn>
                    </Columns>
                </MasterTableView>
            </telerik:RadGrid>

            <asp:SqlDataSource ID="SqlDataSourceSearch" runat="server" ConnectionString="<%$ ConnectionStrings:EpicorConnectionString %>" SelectCommand="select GLAccount,AccountDesc,COACode,Company,SegValue1,SegValue2,SegValue3,SegValue4,SegValue5,SegValue6,SegValue7,SegValue8,SegValue9,SegValue10 from xxvw_BGPlan_GLAccount where Company=@Company and COACode=@COACode and GLAccount like @GLAccount+'%' order by GLAccount">
                <SelectParameters>
                    <asp:SessionParameter Name="Company" SessionField="Company" DefaultValue="" Type="String"/>
                    <asp:SessionParameter Name="COACode" SessionField="COACode" DefaultValue="" Type="String"/>
                    <asp:SessionParameter Name="GLAccount" SessionField="GLAccount" DefaultValue="" Type="String"/>
                </SelectParameters>
            </asp:SqlDataSource>
        </div>
        <telerik:RadButton ID="RadButtonOK" runat="server" Text="OK" Skin="Web20" OnClientClicked="function (button,args){returnToParent();}"></telerik:RadButton>
    </form>
</body>
</html>
