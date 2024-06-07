<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageSingleMenu.Master" AutoEventWireup="true" CodeBehind="UploadToEpicor.aspx.cs" Inherits="BudgetPlan.UploadToEpicor" %>
<%@ Register TagPrefix="telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>
<asp:Content ID="Content0" ContentPlaceHolderID="head" Runat="Server">
    <link href="styles/default.css" rel="stylesheet" />    
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <telerik:RadCodeBlock ID="RadCodeBlock1" runat="server">
    <script type="text/javascript">
        //Put your JavaScript code here.

    </script>
    </telerik:RadCodeBlock>

    <telerik:RadAjaxManager runat="server" ID="RadAjaxManager1" >
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="RadComboBoxFiscalYear">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadComboBoxFiscalYear"/>             
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="RadComboBoxBudgetCode">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadComboBoxBudgetCode"/>             
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="RadButtonSearch">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGridSearch"/>
                    <telerik:AjaxUpdatedControl ControlID="RadGridDtl"/>
                    <telerik:AjaxUpdatedControl ControlID="RadLabelMsg"/>
                    <telerik:AjaxUpdatedControl ControlID="RadLabelErrorMsg" />
                    <telerik:AjaxUpdatedControl ControlID="RadLabelUploadToEpicorMsg" />                
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="RadGridSearch">
                <UpdatedControls>                        
                    <telerik:AjaxUpdatedControl ControlID="RadGridSearch"/>                                               
                    <telerik:AjaxUpdatedControl ControlID="RadLabelMsg"/>
                    <telerik:AjaxUpdatedControl ControlID="RadLabelErrorMsg" />
                </UpdatedControls>    
            </telerik:AjaxSetting>
          <telerik:AjaxSetting AjaxControlID="RadButtonUploadToEpicor">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadLabelMsg"/>
                    <telerik:AjaxUpdatedControl ControlID="RadLabelErrorMsg" />
                    <telerik:AjaxUpdatedControl ControlID="RadLabelUploadToEpicorMsg" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManager>

    <div>
        <telerik:RadLabel ID="RadLabelErrorMsg" runat="server" ForeColor="Red"></telerik:RadLabel>
        <telerik:RadLabel ID="RadLabelMsg" runat="server" ForeColor="Red"></telerik:RadLabel>
        <telerik:RadLabel ID="RadLabelUploadToEpicorMsg" runat="server" ForeColor="Red"></telerik:RadLabel>


    </div>
    

    <div>
        <table>
            <tr>
                <td>
                    <telerik:RadLabel ID="RadLabelFiscalYear" runat="server" >
                        Fiscal Year
                    </telerik:RadLabel>
                </td>
                <td>
                    <telerik:RadComboBox runat="server" ID="RadComboBoxFiscalYear"  EnableLoadOnDemand="true" DataSourceID="SqlDataSourceFiscalYear" DataTextField="FiscalYear" DataValueField="FiscalYear" AutoPostBack="true" ></telerik:RadComboBox>
                        <asp:SqlDataSource ID="SqlDataSourceFiscalYear" runat="server" ConnectionString="<%$ ConnectionStrings:EpicorConnectionString %>" SelectCommand="select distinct FiscalYear from erp.FiscalYr A where Company=@Company union select 0 Order by [FiscalYear]">
                            <SelectParameters>
                                <asp:SessionParameter Name="Company" SessionField="Company" DefaultValue="" Type="String"/>
                            </SelectParameters>
                        </asp:SqlDataSource>
                </td>
                <td>
                    <telerik:RadLabel ID="RadLabelBudgetCode" runat="server" >
                        Budget Code
                    </telerik:RadLabel>                    
                </td>
                <td>                    
                    <telerik:RadComboBox runat="server" ID="RadComboBoxBudgetCode"  EnableLoadOnDemand="true" DataSourceID="SqlDataSourceBudgetCode" DataTextField="BudgetCodeDesc" DataValueField="BudgetCodeID" AutoPostBack="true" ></telerik:RadComboBox>
                        <asp:SqlDataSource ID="SqlDataSourceBudgetCode" runat="server" ConnectionString="<%$ ConnectionStrings:EpicorConnectionString %>" SelectCommand="select BudgetCodeID,BudgetCodeDesc from erp.BudgetCode A where Inactive=0 and Company=@Company union select '','' Order by [BudgetCodeDesc]">
                            <SelectParameters>
                                <asp:SessionParameter Name="Company" SessionField="Company" DefaultValue="" Type="String"/>
                            </SelectParameters>
                        </asp:SqlDataSource>
                </td>
                <td>
                    <telerik:RadButton ID="RadButtonSearch" runat="server" Skin="Web20" Text="Search..." OnClick="RadButtonSearch_Click"></telerik:RadButton>
                </td>
                <td>
                    <telerik:RadButton ID="RadButtonDownload" runat="server" Text="Download Details" Skin="Web20" AutoPostBack="true" OnClick="RadButtonDownload_Click"></telerik:RadButton>        
                </td>
                <td>
                    <telerik:RadButton ID="RadButtonDownloadSummary" runat="server" Text="Download Summary" Skin="Web20" AutoPostBack="true" OnClick="RadButtonDownloadSummary_Click"></telerik:RadButton>
                </td>
                <td>
                    <telerik:RadButton ID="RadButtonUploadToEpicor" runat="server" Text="Upload To Epicor" Skin="Web20" OnClick="RadButtonUploadToEpicor_Click"></telerik:RadButton>
                </td>
            </tr>
        </table>
    </div>
    <div>
        <telerik:RadProgressManager ID="RadProgressManager1" runat="server" />
        <telerik:RadProgressArea RenderMode="Lightweight" ID="RadProgressArea1" runat="server" Width="500px" />
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <telerik:RadPageLayout runat="server" ID="JumbotronLayout" CssClass="jumbotron" GridType="Fluid">
        <Rows>
            <telerik:LayoutRow>
                <Columns>
                    <telerik:LayoutColumn Span="10" SpanMd="12" SpanSm="12" SpanXs="12">

                    </telerik:LayoutColumn>
                </Columns>
            </telerik:LayoutRow>
            <telerik:LayoutRow>
                <Columns>
                    <telerik:LayoutColumn Span="10" SpanMd="12" SpanSm="12" SpanXs="12">

                    </telerik:LayoutColumn>
                </Columns>
            </telerik:LayoutRow>
            <telerik:LayoutRow>
                <Columns>
                    <telerik:LayoutColumn Span="10" SpanMd="12" SpanSm="12" SpanXs="12">
                                                
                    </telerik:LayoutColumn>
                </Columns>
            </telerik:LayoutRow>
            <telerik:LayoutRow>
                <Columns>
                    <telerik:LayoutColumn Span="10" SpanMd="12" SpanSm="12" SpanXs="12">

                    </telerik:LayoutColumn>
                </Columns>
            </telerik:LayoutRow>
        </Rows>
    </telerik:RadPageLayout>

        <div>
            <telerik:RadGrid ID="RadGridSearch" runat="server" Skin="Web20" AllowFilteringByColumn="True" AllowPaging="True" AllowSorting="True" DataSourceID="SqlDataSourceSearchPlanHed" OnItemCommand="RadGridSearch_ItemCommand" AllowMultiRowSelection="true" PageSize="10" ClientSettings-Scrolling-FrozenColumnsCount="6" ShowFooter="True">
                <GroupingSettings CollapseAllTooltip="Collapse all groups"></GroupingSettings>
                <ClientSettings>
                    <Selecting AllowRowSelect="True" />
                    <Scrolling AllowScroll="True" UseStaticHeaders="True" />
                </ClientSettings>
                <MasterTableView AutoGenerateColumns="False" DataKeyNames="Company,BookID,BudgetCode,FiscalYear,AccountCode,EntryNum,Revision" DataSourceID="SqlDataSourceSearchPlanHed" >
                    <Columns>

                    <telerik:GridBoundColumn DataField="FiscalYear" HeaderStyle-Width="100" FilterControlWidth="50" FilterControlAltText="Filter FiscalYear column" HeaderText="FiscalYear"  ReadOnly="true" SortExpression="FiscalYear" UniqueName="FiscalYear">
                    </telerik:GridBoundColumn> 
                    <telerik:GridBoundColumn DataField="BudgetCode" HeaderStyle-Width="150" FilterControlWidth="100" FilterControlAltText="Filter BudgetCode column" HeaderText="BudgetCode"  ReadOnly="true" SortExpression="BudgetCode" UniqueName="BudgetCode">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="EntryNum" HeaderStyle-Width="150" FilterControlWidth="100" FilterControlAltText="Filter EntryNum column" HeaderText="EntryNum"  ReadOnly="true" SortExpression="EntryNum" UniqueName="EntryNum">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="Revision" HeaderStyle-Width="100" FilterControlWidth="50" FilterControlAltText="Filter Revision column" HeaderText="Revision"  ReadOnly="true" SortExpression="Revision" UniqueName="Revision">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="Line" HeaderStyle-Width="100" FilterControlWidth="50" DataType="System.Int32" FilterControlAltText="Filter Line column" HeaderText="Line"  ReadOnly="true" SortExpression="Line" UniqueName="Line">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="Budget_Item" HeaderStyle-Width="150" FilterControlWidth="100" FilterControlAltText="Filter Budget_Item column" HeaderText="Budget_Item"  ReadOnly="true" SortExpression="Budget_Item" UniqueName="Budget_Item" DataFormatString="{0:@}">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="AccountCode" HeaderStyle-Width="150" FilterControlWidth="100" FilterControlAltText="Filter AccountCode column" HeaderText="AccountCode"  ReadOnly="true" SortExpression="AccountCode" UniqueName="AccountCode" DataFormatString="{0:@}">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="AccountDesc" HeaderStyle-Width="150" FilterControlWidth="100" FilterControlAltText="Filter AccountDesc column" HeaderText="AccountDesc"  ReadOnly="true" SortExpression="AccountDesc" UniqueName="AccountDesc" DataFormatString="{0:@}">
                    </telerik:GridBoundColumn>    
                    <telerik:GridBoundColumn DataField="Period_1" HeaderStyle-Width="150" FilterControlWidth="100" DataType="System.Decimal" FilterControlAltText="Filter Period_1 column" HeaderText="Period_1" SortExpression="Period_1" UniqueName="Period_1" Aggregate="Sum">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="Period_2" HeaderStyle-Width="150" FilterControlWidth="100" DataType="System.Decimal" FilterControlAltText="Filter Period_2 column" HeaderText="Period_2" SortExpression="Period_2" UniqueName="Period_2" Aggregate="Sum">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="Period_3" HeaderStyle-Width="150" FilterControlWidth="100" DataType="System.Decimal" FilterControlAltText="Filter Period_3 column" HeaderText="Period_3" SortExpression="Period_3" UniqueName="Period_3" Aggregate="Sum">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="Period_4" HeaderStyle-Width="150" FilterControlWidth="100" DataType="System.Decimal" FilterControlAltText="Filter Period_4 column" HeaderText="Period_4" SortExpression="Period_4" UniqueName="Period_4" Aggregate="Sum">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="Period_5" HeaderStyle-Width="150" FilterControlWidth="100" DataType="System.Decimal" FilterControlAltText="Filter Period_5 column" HeaderText="Period_5" SortExpression="Period_5" UniqueName="Period_5" Aggregate="Sum">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="Period_6" HeaderStyle-Width="150" FilterControlWidth="100" DataType="System.Decimal" FilterControlAltText="Filter Period_6 column" HeaderText="Period_6" SortExpression="Period_6" UniqueName="Period_6" Aggregate="Sum">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="Period_7" HeaderStyle-Width="150" FilterControlWidth="100" DataType="System.Decimal" FilterControlAltText="Filter Period_7 column" HeaderText="Period_7" SortExpression="Period_7" UniqueName="Period_7" Aggregate="Sum">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="Period_8" HeaderStyle-Width="150" FilterControlWidth="100" DataType="System.Decimal" FilterControlAltText="Filter Period_8 column" HeaderText="Period_8" SortExpression="Period_8" UniqueName="Period_8" Aggregate="Sum">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="Period_9" HeaderStyle-Width="150" FilterControlWidth="100" DataType="System.Decimal" FilterControlAltText="Filter Period_9 column" HeaderText="Period_9" SortExpression="Period_9" UniqueName="Period_9" Aggregate="Sum">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="Period_10" HeaderStyle-Width="150" FilterControlWidth="100" DataType="System.Decimal" FilterControlAltText="Filter Period_10 column" HeaderText="Period_10" SortExpression="Period_10" UniqueName="Period_10" Aggregate="Sum">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="Period_11" HeaderStyle-Width="150" FilterControlWidth="100" DataType="System.Decimal" FilterControlAltText="Filter Period_11 column" HeaderText="Period_11" SortExpression="Period_11" UniqueName="Period_11" Aggregate="Sum">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="Period_12" HeaderStyle-Width="150" FilterControlWidth="100" DataType="System.Decimal" FilterControlAltText="Filter Period_12 column" HeaderText="Period_12" SortExpression="Period_12" UniqueName="Period_12" Aggregate="Sum">
                    </telerik:GridBoundColumn>

                    <telerik:GridCalculatedColumn UniqueName="LineTotal" HeaderText="Total" HeaderStyle-Width="150" FilterControlWidth="100" DataFields="Period_1,Period_2,Period_3,Period_4,Period_5,Period_6,Period_7,Period_8,Period_9,Period_10,Period_11,Period_12" DataType="System.Decimal" Expression="{0}+{1}+{2}+{3}+{4}+{5}+{6}+{7}+{8}+{9}+{10}+{11}" Aggregate="Sum">
                    </telerik:GridCalculatedColumn>

                    <telerik:GridBoundColumn DataField="Company" HeaderStyle-Width="150" FilterControlWidth="100" FilterControlAltText="Filter Company column" HeaderText="Company"  ReadOnly="true" SortExpression="Company" UniqueName="Company">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="BookID" HeaderStyle-Width="150" FilterControlWidth="100" FilterControlAltText="Filter BookID column" HeaderText="BookID"  ReadOnly="true" SortExpression="BookID" UniqueName="BookID">
                    </telerik:GridBoundColumn>


                    </Columns>
                </MasterTableView>
            </telerik:RadGrid>

            <asp:SqlDataSource ID="SqlDataSourceSearchPlanHed" runat="server" ConnectionString="<%$ ConnectionStrings:BudgetPlanConnectionString %>" SelectCommand="select * from vw_BudgetApprovedDtl WHERE [Company]=@Company and [FiscalYear]=@FiscalYear and BudgetCode=@BudgetCode order by Company,BookID,BudgetCode,FiscalYear,AccountCode,EntryNum,Revision,Line">
                <SelectParameters>
                    <asp:SessionParameter Name="Company" SessionField="Company" DefaultValue="" Type="String"/>
                    <asp:SessionParameter Name="FiscalYear" SessionField="FiscalYear" DefaultValue="" Type="String"/>
                    <asp:SessionParameter Name="BudgetCode" SessionField="BudgetCode" DefaultValue="" Type="String"/>
                </SelectParameters>
            </asp:SqlDataSource>

        </div>


                    
        <div>

            <telerik:RadGrid ID="RadGridDtl" runat="server" Skin="Web20" AllowFilteringByColumn="True" AllowPaging="True" AllowSorting="True" DataSourceID="SqlDataSourceDtl" ShowGroupPanel="True" Height="600px" PageSize="10" ClientSettings-Scrolling-FrozenColumnsCount="1" ShowFooter="True">
                <GroupingSettings CollapseAllTooltip="Collapse all groups"></GroupingSettings>
                <ClientSettings AllowDragToGroup="false">
                    <Scrolling AllowScroll="True" UseStaticHeaders="True" />
                </ClientSettings>
                <MasterTableView AutoGenerateColumns="False" DataKeyNames="Company" DataSourceID="SqlDataSourceDtl" >
                    <Columns>
                        
                        <telerik:GridBoundColumn DataField="AccountCode" HeaderStyle-Width="200" FilterControlWidth="100" FilterControlAltText="Filter AccountCode column" HeaderText="AccountCode"  ReadOnly="true" SortExpression="AccountCode" UniqueName="AccountCode" DataFormatString="{0:@}">
                        </telerik:GridBoundColumn>                                    
                        <telerik:GridBoundColumn DataField="Period_1" HeaderStyle-Width="150" FilterControlWidth="100" DataType="System.Decimal" FilterControlAltText="Filter Period_1 column" HeaderText="Period_1" SortExpression="Period_1" UniqueName="Period_1" Aggregate="Sum">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Period_2" HeaderStyle-Width="150" FilterControlWidth="100" DataType="System.Decimal" FilterControlAltText="Filter Period_2 column" HeaderText="Period_2" SortExpression="Period_2" UniqueName="Period_2" Aggregate="Sum">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Period_3" HeaderStyle-Width="150" FilterControlWidth="100" DataType="System.Decimal" FilterControlAltText="Filter Period_3 column" HeaderText="Period_3" SortExpression="Period_3" UniqueName="Period_3" Aggregate="Sum">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Period_4" HeaderStyle-Width="150" FilterControlWidth="100" DataType="System.Decimal" FilterControlAltText="Filter Period_4 column" HeaderText="Period_4" SortExpression="Period_4" UniqueName="Period_4" Aggregate="Sum">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Period_5" HeaderStyle-Width="150" FilterControlWidth="100" DataType="System.Decimal" FilterControlAltText="Filter Period_5 column" HeaderText="Period_5" SortExpression="Period_5" UniqueName="Period_5" Aggregate="Sum">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Period_6" HeaderStyle-Width="150" FilterControlWidth="100" DataType="System.Decimal" FilterControlAltText="Filter Period_6 column" HeaderText="Period_6" SortExpression="Period_6" UniqueName="Period_6" Aggregate="Sum">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Period_7" HeaderStyle-Width="150" FilterControlWidth="100" DataType="System.Decimal" FilterControlAltText="Filter Period_7 column" HeaderText="Period_7" SortExpression="Period_7" UniqueName="Period_7" Aggregate="Sum">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Period_8" HeaderStyle-Width="150" FilterControlWidth="100" DataType="System.Decimal" FilterControlAltText="Filter Period_8 column" HeaderText="Period_8" SortExpression="Period_8" UniqueName="Period_8" Aggregate="Sum">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Period_9" HeaderStyle-Width="150" FilterControlWidth="100" DataType="System.Decimal" FilterControlAltText="Filter Period_9 column" HeaderText="Period_9" SortExpression="Period_9" UniqueName="Period_9" Aggregate="Sum">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Period_10" HeaderStyle-Width="150" FilterControlWidth="100" DataType="System.Decimal" FilterControlAltText="Filter Period_10 column" HeaderText="Period_10" SortExpression="Period_10" UniqueName="Period_10" Aggregate="Sum">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Period_11" HeaderStyle-Width="150" FilterControlWidth="100" DataType="System.Decimal" FilterControlAltText="Filter Period_11 column" HeaderText="Period_11" SortExpression="Period_11" UniqueName="Period_11" Aggregate="Sum">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Period_12" HeaderStyle-Width="150" FilterControlWidth="100" DataType="System.Decimal" FilterControlAltText="Filter Period_12 column" HeaderText="Period_12" SortExpression="Period_12" UniqueName="Period_12" Aggregate="Sum">
                        </telerik:GridBoundColumn>

                        <telerik:GridCalculatedColumn UniqueName="LineTotal" HeaderText="Total" HeaderStyle-Width="150" FilterControlWidth="100" DataFields="Period_1,Period_2,Period_3,Period_4,Period_5,Period_6,Period_7,Period_8,Period_9,Period_10,Period_11,Period_12" DataType="System.Decimal" Expression="{0}+{1}+{2}+{3}+{4}+{5}+{6}+{7}+{8}+{9}+{10}+{11}" Aggregate="Sum">
                        </telerik:GridCalculatedColumn>

                        <telerik:GridBoundColumn DataField="Company" HeaderStyle-Width="150" FilterControlWidth="100" FilterControlAltText="Filter Company column" HeaderText="Company"  ReadOnly="true" SortExpression="Company" UniqueName="Company">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="BookID" HeaderStyle-Width="150" FilterControlWidth="100" FilterControlAltText="Filter BookID column" HeaderText="BookID"  ReadOnly="true" SortExpression="BookID" UniqueName="BookID">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="BudgetCode" HeaderStyle-Width="150" FilterControlWidth="100" FilterControlAltText="Filter BudgetCode column" HeaderText="BudgetCode"  ReadOnly="true" SortExpression="BudgetCode" UniqueName="BudgetCode">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="FiscalYear" HeaderStyle-Width="150" FilterControlWidth="100" FilterControlAltText="Filter FiscalYear column" HeaderText="FiscalYear"  ReadOnly="true" SortExpression="FiscalYear" UniqueName="FiscalYear">
                        </telerik:GridBoundColumn>
                                    
                    </Columns>
                </MasterTableView>
            </telerik:RadGrid>
            <asp:SqlDataSource ID="SqlDataSourceDtl" runat="server" ConnectionString="<%$ ConnectionStrings:BudgetPlanConnectionString %>" 
                SelectCommand="select * from vw_BudgetApprovedSummary where [Company]=@Company AND [FiscalYear]=@FiscalYear AND [BudgetCode]=@BudgetCode"
                >
                    <SelectParameters>
                        <asp:SessionParameter Name="Company" SessionField="Company" DefaultValue="" Type="String"/>
                        <asp:SessionParameter Name="FiscalYear" SessionField="FiscalYear" DefaultValue="0" Type="String"/>
                        <asp:SessionParameter Name="BudgetCode" SessionField="BudgetCode" DefaultValue="" Type="String"/>
                    </SelectParameters>
            </asp:SqlDataSource>

        </div>


<h6><telerik:RadTextBox ID="RadTextBoxCurrentCompany" runat="server" Label="CompanyID:" ReadOnly="true" Display="false"></telerik:RadTextBox><telerik:RadTextBox ID="RadTextBoxCurrentCompanyName" runat="server" Label="Company:" ReadOnly="true" ></telerik:RadTextBox><telerik:RadTextBox ID="RadTextBoxUserID" runat="server" Label="UserID:" ReadOnly="true" ></telerik:RadTextBox></h6>

</asp:Content>
