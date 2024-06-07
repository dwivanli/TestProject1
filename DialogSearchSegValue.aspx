<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DialogSearchSegValue.aspx.cs" Inherits="BudgetPlan.DialogSearchSegValue" %>
<%@ Register TagPrefix="telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Select Segment Value</title>
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

            var id = "";
            var SegValue = "";
            var grid = $find("<%=RadGridSearch.ClientID %>");
            var MasterTable = grid.get_masterTableView();
            var selectedRows = MasterTable.get_selectedItems();
            for (var i = 0; i < selectedRows.length; i++) {
                var row = selectedRows[i];
                var cell = MasterTable.getCellByColumnUniqueName(row, "SegmentCode")

                SegValue = cell.innerText.replace(' ', '');
            }
            //alert("Cell Value: " + id);

            //alert("SegValue Cell Value: " + GLAccount);
            oArg.SegValue = SegValue;

            //get a reference to the current RadWindow
            var oWnd = GetRadWindow();

            //Close the RadWindow and send the argument to the parent page
            oWnd.close(oArg);

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
            <telerik:RadLabel ID="RadLabelSegCode" runat="server" AssociatedControlID="RadTextSegCode">SegmentCode StartsWith</telerik:RadLabel>
            <telerik:RadTextBox ID="RadTextSegCode" runat="server" ></telerik:RadTextBox>
            <telerik:RadButton ID="RadButtonSearch" runat="server" Text="Search" Skin="Web20" OnClick="RadButtonSearch_Click"></telerik:RadButton>
        </div>
        <div>
            <telerik:RadGrid ID="RadGridSearch" runat="server" Visible="true" AllowFilteringByColumn="True" AllowPaging="True" AllowSorting="True" DataSourceID="SqlDataSourceSearch" OnItemCommand="RadGridSearch_ItemCommand">
                <GroupingSettings CollapseAllTooltip="Collapse all groups"></GroupingSettings>
                <ClientSettings>
                    <Selecting AllowRowSelect="True" />
                    <Scrolling AllowScroll="True" UseStaticHeaders="True" />
                </ClientSettings>
                <MasterTableView CommandItemDisplay="None" AutoGenerateColumns="False" DataKeyNames="SegmentCode" DataSourceID="SqlDataSourceSearch">
                    <CommandItemTemplate>
                        <telerik:RadButton ID="RadButtonSearchOK" runat="server" Text="OK" CommandName="RadButtonSearchOK" ></telerik:RadButton>
                        <telerik:RadButton ID="RadButtonSearchCancel" runat="server" Text="Cancel" CommandName="RadButtonSearchCancel" ></telerik:RadButton>
                    </CommandItemTemplate>
                    <Columns>
                    <telerik:GridClientSelectColumn Reorderable="False" Resizable="False" ShowSortIcon="False" 
                    UniqueName="column">  
                    </telerik:GridClientSelectColumn> 
                        <telerik:GridBoundColumn DataField="SegmentCode" FilterControlAltText="Filter SegmentCode column" HeaderText="SegmentCode" ReadOnly="True" SortExpression="SegmentCode" UniqueName="SegmentCode">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="SegmentName" FilterControlAltText="Filter SegmentName column" HeaderText="SegmentName" ReadOnly="True" SortExpression="SegmentName" UniqueName="SegmentName">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="SegmentNbr" FilterControlAltText="Filter SegmentNbr column" HeaderText="SegmentNbr" ReadOnly="True" SortExpression="SegmentNbr" UniqueName="SegmentNbr">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="COACode" FilterControlAltText="Filter COACode column" HeaderText="COACode" ReadOnly="True" SortExpression="COACode" UniqueName="COACode">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Company" FilterControlAltText="Filter Company column" HeaderText="Company" ReadOnly="True" SortExpression="Company" UniqueName="Company">
                        </telerik:GridBoundColumn>
                    </Columns>
                </MasterTableView>
            </telerik:RadGrid>

            <asp:SqlDataSource ID="SqlDataSourceSearch" runat="server" ConnectionString="<%$ ConnectionStrings:EpicorConnectionString %>" SelectCommand="select SegmentCode,SegmentName,SegmentNbr,COACode,Company from erp.COASegValues where SegmentNbr=@SegmentNbr and Company=@Company and COACode=@COACode and SegmentCode like @SegmentCode+'%' order by SegmentCode">
                <SelectParameters>
                    <asp:SessionParameter Name="Company" SessionField="Company" DefaultValue="" Type="String"/>
                    <asp:SessionParameter Name="COACode" SessionField="COACode" DefaultValue="" Type="String"/>
                    <asp:SessionParameter Name="SegmentNbr" SessionField="SegmentNbr" DefaultValue="0" Type="String"/>
                    <asp:SessionParameter Name="SegmentCode" SessionField="SegmentCode" DefaultValue="" Type="String"/>
                </SelectParameters>
            </asp:SqlDataSource>
        </div>
        <telerik:RadButton ID="RadButtonOK" runat="server" Text="OK" Skin="Web20" OnClientClicked="function (button,args){returnToParent();}"></telerik:RadButton>
    </form>
</body>
</html>

