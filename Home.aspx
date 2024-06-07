<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageSingleMenu.Master" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="BudgetPlan.Home" %>
<%@ Register TagPrefix="telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>

<asp:Content ID="Content0" ContentPlaceHolderID="head" Runat="Server">
    <link href="styles/default.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

   <telerik:RadAjaxManager runat="server" ID="RadAjaxManager1">
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="RadButtonRefreshPlanEntry">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGridSearchPlanEntry"/>
                    <telerik:AjaxUpdatedControl ControlID="RadLabelMsg"/>
                    <telerik:AjaxUpdatedControl ControlID="RadLabelErrorMsg" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="RadButtonRefreshPlanApv">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGridSearchPlanApproval"/>
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

    <telerik:RadPageLayout runat="server" ID="JumbotronLayout" CssClass="jumbotron" GridType="Fluid">
        <Rows>
            <telerik:LayoutRow>
                <Columns>
                    <telerik:LayoutColumn Span="10" SpanMd="12" SpanSm="12" SpanXs="12">
                        <telerik:RadLabel ID="RadLabelUserID" runat="server" Text="Hello, " Font-Size="Larger"></telerik:RadLabel>
                    </telerik:LayoutColumn>
                </Columns>
            </telerik:LayoutRow>
        </Rows>
    </telerik:RadPageLayout>


    <div>
    <h3><telerik:RadLabel ID="RadLabelPlanPendingEntry" runat="server" Text="Pending Budget Entry Assigned To Me" Font-Size="Medium"></telerik:RadLabel></h3>
    <h5><telerik:RadButton ID="RadButtonRefreshPlanEntry" runat="server" Text="Refresh" OnClick="RadButtonRefreshPlanEntry_Click"></telerik:RadButton></h5>           
    </div>

    <div>
        <telerik:RadGrid ID="RadGridSearchPlanEntry" runat="server" Skin="Web20" Visible="true" AllowFilteringByColumn="True" AllowPaging="True" AllowSorting="True" DataSourceID="SqlDataSourceSearchPlanHed">
            <GroupingSettings CollapseAllTooltip="Collapse all groups"></GroupingSettings>
            <ClientSettings>
                <Selecting AllowRowSelect="True" />
                <Scrolling AllowScroll="True" UseStaticHeaders="True" />
            </ClientSettings>
            <MasterTableView AutoGenerateColumns="False" DataKeyNames="Company,EntryNum,Revision" DataSourceID="SqlDataSourceSearchPlanHed">
                <Columns>
                    <telerik:GridBoundColumn DataField="Company" FilterControlAltText="Filter Company column" HeaderText="Company" ReadOnly="True" SortExpression="Company" UniqueName="Company">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="EntryNum" FilterControlAltText="Filter EntryNum column" HeaderText="EntryNum" ReadOnly="True" SortExpression="EntryNum" UniqueName="EntryNum">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="Revision" DataType="System.Int32" FilterControlAltText="Filter Revision column" HeaderText="Revision" SortExpression="Revision" UniqueName="Revision">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="PreparedBy" FilterControlAltText="Filter PreparedBy column" HeaderText="PreparedBy" SortExpression="PreparedBy" UniqueName="PreparedBy">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="SubmissionDueDate" DataType="System.DateTime" FilterControlAltText="Filter SubmissionDueDate column" HeaderText="SubmissionDueDate" SortExpression="SubmissionDueDate" UniqueName="SubmissionDueDate">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="AssignTo" FilterControlAltText="Filter AssignTo column" HeaderText="AssignTo" SortExpression="AssignTo" UniqueName="AssignTo">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="SubmitTo" FilterControlAltText="Filter SubmitTo column" HeaderText="SubmitTo" SortExpression="SubmitTo" UniqueName="SubmitTo">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="Status" FilterControlAltText="Filter Status column" HeaderText="Status" SortExpression="Status" UniqueName="Status">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="COACode" FilterControlAltText="Filter COACode column" HeaderText="COACode" SortExpression="COACode" UniqueName="COACode">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="BookID" FilterControlAltText="Filter BookID column" HeaderText="BookID" SortExpression="BookID" UniqueName="BookID">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="FiscalYear" DataType="System.Int32" FilterControlAltText="Filter FiscalYear column" HeaderText="FiscalYear" SortExpression="FiscalYear" UniqueName="FiscalYear">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="BudgetCode" FilterControlAltText="Filter BudgetCode column" HeaderText="BudgetCode" SortExpression="BudgetCode" UniqueName="BudgetCode">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="BudgetTitle" FilterControlAltText="Filter BudgetTitle column" HeaderText="BudgetTitle" SortExpression="BudgetTitle" UniqueName="BudgetTitle">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="CreatedBy" FilterControlAltText="Filter CreatedBy column" HeaderText="CreatedBy" SortExpression="CreatedBy" UniqueName="CreatedBy">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="CreatedDate" DataType="System.DateTime" FilterControlAltText="Filter CreatedDate column" HeaderText="CreatedDate" SortExpression="CreatedDate" UniqueName="CreatedDate">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="ChangedBy" FilterControlAltText="Filter ChangedBy column" HeaderText="ChangedBy" SortExpression="ChangedBy" UniqueName="ChangedBy">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="ChangedDate" DataType="System.DateTime" FilterControlAltText="Filter ChangedDate column" HeaderText="ChangedDate" SortExpression="ChangedDate" UniqueName="ChangedDate">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="SysRowID" Visible="false" DataType="System.Guid" FilterControlAltText="Filter SysRowID column" HeaderText="SysRowID" SortExpression="SysRowID" UniqueName="SysRowID">
                    </telerik:GridBoundColumn>
                </Columns>
            </MasterTableView>
        </telerik:RadGrid>

        <asp:SqlDataSource ID="SqlDataSourceSearchPlanHed" runat="server" ConnectionString="<%$ ConnectionStrings:BudgetPlanConnectionString %>" SelectCommand="SELECT * FROM [BudgetPlanHed] WHERE Status='Pending Budget Entry' and [Company]=@Company and [AssignTo]=@AssignTo ORDER BY [Company], [EntryNum], [Revision]">
            <SelectParameters>
                <asp:SessionParameter Name="Company" SessionField="Company" DefaultValue="" Type="String"/>
                <asp:SessionParameter Name="AssignTo" SessionField="AssignTo" DefaultValue="" Type="String"/>
            </SelectParameters>
        </asp:SqlDataSource>

    </div>    

    <div>
        <h3><telerik:RadLabel ID="RadLabelPlanPendingApv" runat="server" Text="Pending Budget Approval Assigned To Me" Font-Size="Medium"></telerik:RadLabel></h3>
        <h5><telerik:RadButton ID="RadButtonRefreshPlanApv" runat="server" Text="Refresh" OnClick="RadButtonRefreshPlanApv_Click"></telerik:RadButton></h5>                            
    </div>

    <div>
            <telerik:RadGrid ID="RadGridSearchPlanApproval" runat="server" Skin="Web20" Visible="true" AllowFilteringByColumn="True" AllowPaging="True" AllowSorting="True" DataSourceID="SqlDataSourceSearchPlanHed2">
                <GroupingSettings CollapseAllTooltip="Collapse all groups"></GroupingSettings>
                <ClientSettings>
                    <Selecting AllowRowSelect="True" />
                    <Scrolling AllowScroll="True" UseStaticHeaders="True" />
                </ClientSettings>
                <MasterTableView AutoGenerateColumns="False" DataKeyNames="Company,EntryNum,Revision" DataSourceID="SqlDataSourceSearchPlanHed2">
                    <Columns>
                        <telerik:GridBoundColumn DataField="Company" FilterControlAltText="Filter Company column" HeaderText="Company" ReadOnly="True" SortExpression="Company" UniqueName="Company">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="EntryNum" FilterControlAltText="Filter EntryNum column" HeaderText="EntryNum" ReadOnly="True" SortExpression="EntryNum" UniqueName="EntryNum">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Revision" DataType="System.Int32" FilterControlAltText="Filter Revision column" HeaderText="Revision" SortExpression="Revision" UniqueName="Revision">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="PreparedBy" FilterControlAltText="Filter PreparedBy column" HeaderText="PreparedBy" SortExpression="PreparedBy" UniqueName="PreparedBy">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="SubmissionDueDate" DataType="System.DateTime" FilterControlAltText="Filter SubmissionDueDate column" HeaderText="SubmissionDueDate" SortExpression="SubmissionDueDate" UniqueName="SubmissionDueDate">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="AssignTo" FilterControlAltText="Filter AssignTo column" HeaderText="AssignTo" SortExpression="AssignTo" UniqueName="AssignTo">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="SubmitTo" FilterControlAltText="Filter SubmitTo column" HeaderText="SubmitTo" SortExpression="SubmitTo" UniqueName="SubmitTo">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="Status" FilterControlAltText="Filter Status column" HeaderText="Status" SortExpression="Status" UniqueName="Status">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="COACode" FilterControlAltText="Filter COACode column" HeaderText="COACode" SortExpression="COACode" UniqueName="COACode">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="BookID" FilterControlAltText="Filter BookID column" HeaderText="BookID" SortExpression="BookID" UniqueName="BookID">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="FiscalYear" DataType="System.Int32" FilterControlAltText="Filter FiscalYear column" HeaderText="FiscalYear" SortExpression="FiscalYear" UniqueName="FiscalYear">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="BudgetCode" FilterControlAltText="Filter BudgetCode column" HeaderText="BudgetCode" SortExpression="BudgetCode" UniqueName="BudgetCode">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="BudgetTitle" FilterControlAltText="Filter BudgetTitle column" HeaderText="BudgetTitle" SortExpression="BudgetTitle" UniqueName="BudgetTitle">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="CreatedBy" FilterControlAltText="Filter CreatedBy column" HeaderText="CreatedBy" SortExpression="CreatedBy" UniqueName="CreatedBy">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="CreatedDate" DataType="System.DateTime" FilterControlAltText="Filter CreatedDate column" HeaderText="CreatedDate" SortExpression="CreatedDate" UniqueName="CreatedDate">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="ChangedBy" FilterControlAltText="Filter ChangedBy column" HeaderText="ChangedBy" SortExpression="ChangedBy" UniqueName="ChangedBy">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="ChangedDate" DataType="System.DateTime" FilterControlAltText="Filter ChangedDate column" HeaderText="ChangedDate" SortExpression="ChangedDate" UniqueName="ChangedDate">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="SysRowID" Visible="false" DataType="System.Guid" FilterControlAltText="Filter SysRowID column" HeaderText="SysRowID" SortExpression="SysRowID" UniqueName="SysRowID">
                        </telerik:GridBoundColumn>
                    </Columns>
                </MasterTableView>
            </telerik:RadGrid>

            <asp:SqlDataSource ID="SqlDataSourceSearchPlanHed2" runat="server" ConnectionString="<%$ ConnectionStrings:BudgetPlanConnectionString %>" SelectCommand="SELECT * FROM [BudgetPlanHed] WHERE Status='Pending Approval' and [Company]=@Company and [SubmitTo]=@SubmitTo ORDER BY [Company], [EntryNum], [Revision]">
                <SelectParameters>
                    <asp:SessionParameter Name="Company" SessionField="Company" DefaultValue="" Type="String"/>
                    <asp:SessionParameter Name="SubmitTo" SessionField="SubmitTo" DefaultValue="" Type="String"/>
                </SelectParameters>
            </asp:SqlDataSource>

        </div>


    <h6><telerik:RadTextBox ID="RadTextBoxCurrentCompany" runat="server" Label="CompanyID:" ReadOnly="true" Display="false"></telerik:RadTextBox><telerik:RadTextBox ID="RadTextBoxCurrentCompanyName" runat="server" Label="Company:" ReadOnly="true" ></telerik:RadTextBox><telerik:RadTextBox ID="RadTextBoxUserID" runat="server" Label="UserID:" ReadOnly="true" ></telerik:RadTextBox></h6>

</asp:Content>
