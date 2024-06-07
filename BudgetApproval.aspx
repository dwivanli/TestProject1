<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageSingleMenu.Master" AutoEventWireup="true" CodeBehind="BudgetApproval.aspx.cs" Inherits="BudgetPlan.BudgetApproval" %>
<%@ Register TagPrefix="telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>

<asp:Content ID="Content0" ContentPlaceHolderID="head" Runat="Server">
    <link href="styles/default.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <telerik:RadCodeBlock ID="RadCodeBlock1" runat="server">
    <script type="text/javascript">
        //Put your JavaScript code here.

    </script>
    </telerik:RadCodeBlock>

    <telerik:RadAjaxManager runat="server" ID="RadAjaxManager1">
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="RadGridDtl">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGridDtl"/>
                    <telerik:AjaxUpdatedControl ControlID="RadLabelMsg"/>
                    <telerik:AjaxUpdatedControl ControlID="RadLabelErrorMsg" />
                </UpdatedControls>
            </telerik:AjaxSetting>
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

                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxCompany"/> 
                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxEntryNum"/> 
                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxRevision"/> 
                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxPreparedBy"/> 
                    <telerik:AjaxUpdatedControl ControlID="RadDatePickerSubmissionDueDate"/>
                    <telerik:AjaxUpdatedControl ControlID="RadComboBoxSubmitTo"/>
                    <telerik:AjaxUpdatedControl ControlID="RadComboBoxCOACode"/> 
                    <telerik:AjaxUpdatedControl ControlID="RadComboBoxBookID"/> 
                    <telerik:AjaxUpdatedControl ControlID="RadComboBoxFiscalYear"/> 
                    <telerik:AjaxUpdatedControl ControlID="RadComboBoxBudgetCode"/> 
                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxBudgetTitle"/> 
 
                    <telerik:AjaxUpdatedControl ControlID="RadGridDtl"/>
                    
                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxStatus"/> 
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="RadButtonApprove">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadLabelMsg"/>
                    <telerik:AjaxUpdatedControl ControlID="RadLabelErrorMsg" />
                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxStatus"/> 
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="RadButtonReject">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadLabelMsg"/>
                    <telerik:AjaxUpdatedControl ControlID="RadLabelErrorMsg" />
                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxStatus"/> 
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManager>

    <div>
        <telerik:RadLabel ID="RadLabelErrorMsg" runat="server" ForeColor="Red"></telerik:RadLabel>
        <telerik:RadLabel ID="RadLabelMsg" runat="server" ForeColor="Red"></telerik:RadLabel>
    </div>

    <div>
        <telerik:RadButton ID="RadButtonSearch" runat="server" Skin="Web20" Text="Search..." OnClick="RadButtonSearch_Click">
        </telerik:RadButton>            
    </div>

    <telerik:RadPageLayout runat="server" ID="JumbotronLayout" CssClass="jumbotron" GridType="Fluid">
        <Rows>
            <telerik:LayoutRow>
	            <Columns>
		            <telerik:LayoutColumn Span="10" SpanMd="12" SpanSm="12" SpanXs="12">
                    <div>
                            <telerik:RadGrid ID="RadGridSearch" runat="server" Skin="Web20" Visible="false" AllowFilteringByColumn="True" AllowPaging="True" AllowSorting="True" DataSourceID="SqlDataSourceSearchPlanHed" OnItemCommand="RadGridSearch_ItemCommand">
                                <GroupingSettings CollapseAllTooltip="Collapse all groups"></GroupingSettings>
                                <ClientSettings>
                                    <Selecting AllowRowSelect="True" />
                                    <Scrolling AllowScroll="True" UseStaticHeaders="True" />
                                </ClientSettings>
                                <MasterTableView CommandItemDisplay="Bottom" AutoGenerateColumns="False" DataKeyNames="Company,EntryNum,Revision" DataSourceID="SqlDataSourceSearchPlanHed">
                                    <CommandItemTemplate>
                                        <telerik:RadButton ID="RadButtonSearchOK" runat="server" Text="OK" CommandName="RadButtonSearchOK" ></telerik:RadButton>
                                        <telerik:RadButton ID="RadButtonSearchCancel" runat="server" Text="Cancel" CommandName="RadButtonSearchCancel" ></telerik:RadButton>
                                    </CommandItemTemplate>
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

                            <asp:SqlDataSource ID="SqlDataSourceSearchPlanHed" runat="server" ConnectionString="<%$ ConnectionStrings:BudgetPlanConnectionString %>" SelectCommand="SELECT * FROM [BudgetPlanHed] WHERE [Company]=@Company and [SubmitTo]=@SubmitTo and [Status]='Pending Approval' and [InactiveRevision]=0 ORDER BY [Company], [EntryNum], [Revision]">
                                <SelectParameters>
                                    <asp:SessionParameter Name="Company" SessionField="Company" DefaultValue="" Type="String"/>
                                    <asp:SessionParameter Name="SubmitTo" SessionField="SubmitTo" DefaultValue="" Type="String"/>
                                </SelectParameters>
                            </asp:SqlDataSource>

                        </div>
		            </telerik:LayoutColumn>
	            </Columns>
            </telerik:LayoutRow>
            <telerik:LayoutRow>
                <Columns>
                    <telerik:LayoutColumn Span="10" SpanMd="12" SpanSm="12" SpanXs="12">
                        <table style="width: 100%;">
                            <tr>
                                <td>
                                    <telerik:RadLabel ID="RadLabelEntryNum" runat="server" AssociatedControlID="RadTextBoxEntryNum">
                                    Entry#
                                    </telerik:RadLabel>
                                    <telerik:RadTextBox ID="RadTextBoxEntryNum" Runat="server" LabelWidth="64px" Resize="None" Text="" Width="100%" ReadOnly="true">
                                    </telerik:RadTextBox>
                                </td>
                                <td>
                                    <telerik:RadLabel ID="RadLabelRevision" runat="server" AssociatedControlID="RadTextBoxRevision">
                                        Revision
                                    </telerik:RadLabel>
                                    <telerik:RadTextBox ID="RadTextBoxRevision" Runat="server" LabelWidth="64px" Resize="None" Text="" Width="100%" ReadOnly="true">
                                    </telerik:RadTextBox>
                                </td>
                                <td>
                                    <telerik:RadLabel ID="RadLabelPreparedBy" runat="server" AssociatedControlID="RadTextBoxPreparedBy">
                                        Budget Preparer
                                    </telerik:RadLabel>
                                    <telerik:RadTextBox ID="RadTextBoxPreparedBy" Runat="server" LabelWidth="64px" Resize="None" Text="" Width="100%" ReadOnly="true">
                                    </telerik:RadTextBox>
                                </td>
                                <td>
                                    <telerik:RadLabel ID="RadLabelSubmissionDueDate" runat="server" AssociatedControlID="RadTextBoxSubmissionDueDate" >
                                        Submission Due Date
                                    </telerik:RadLabel>
                                    <telerik:RadDatePicker ID="RadDatePickerSubmissionDueDate" runat="server" Resize="None" Width="100%" Enabled="false"></telerik:RadDatePicker>
                                </td>
                                <td>
                                    <telerik:RadLabel ID="RadLabelSubmitTo" runat="server" AssociatedControlID="RadComboBoxSubmitTo">
                                        Submit To Approver
                                    </telerik:RadLabel>
                                    <telerik:RadComboBox runat="server" ID="RadComboBoxSubmitTo"  EnableLoadOnDemand="true" DataSourceID="SqlDataSourceSubmitTo" DataTextField="Name" DataValueField="UserID" AutoPostBack="true" Enabled="false"></telerik:RadComboBox>
                                        <asp:SqlDataSource ID="SqlDataSourceSubmitTo" runat="server" ConnectionString="<%$ ConnectionStrings:BudgetPlanConnectionString %>" SelectCommand="select [UserID],[Name] from UserFile union select '','' Order by [Name]">
                                        </asp:SqlDataSource>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <telerik:RadLabel ID="RadLabelCompany" runat="server" AssociatedControlID="RadTextBoxCompany">
                                        Company
                                    </telerik:RadLabel>
                                    <telerik:RadTextBox ID="RadTextBoxCompany" Runat="server" LabelWidth="64px" Resize="None" Text="" ReadOnly="true" Width="100%" >
                                    </telerik:RadTextBox>
                                </td>
                                <td>
                                    <telerik:RadLabel ID="RadLabelCOACode" runat="server" AssociatedControlID="RadComboBoxCOACode" >
                                        COA
                                    </telerik:RadLabel>                                    
                                    <telerik:RadComboBox runat="server" ID="RadComboBoxCOACode"  EnableLoadOnDemand="true" DataSourceID="SqlDataSourceCOACode" DataTextField="Description" DataValueField="COACode" AutoPostBack="true" Enabled="false"></telerik:RadComboBox>
                                        <asp:SqlDataSource ID="SqlDataSourceCOACode" runat="server" ConnectionString="<%$ ConnectionStrings:EpicorConnectionString %>" SelectCommand="select [COACode],[Description] from erp.COA where Company=@Company union select '','' Order by [Description]">
                                            <SelectParameters>
                                                <asp:SessionParameter Name="Company" SessionField="Company" DefaultValue="" Type="String"/>
                                            </SelectParameters>
                                        </asp:SqlDataSource>                                    
                                </td>
                                <td>
                                    <telerik:RadLabel ID="RadLabelBookID" runat="server" AssociatedControlID="RadComboBoxBookID" >
                                        Book
                                    </telerik:RadLabel>
                                    <telerik:RadComboBox runat="server" ID="RadComboBoxBookID"  EnableLoadOnDemand="true" DataSourceID="SqlDataSourceBookID" DataTextField="Description" DataValueField="BookID" AutoPostBack="true" Enabled="false"></telerik:RadComboBox>
                                        <asp:SqlDataSource ID="SqlDataSourceBookID" runat="server" ConnectionString="<%$ ConnectionStrings:EpicorConnectionString %>" SelectCommand="select [BookID],[Description] from erp.GLBook A where Company=@Company union select '','' Order by [Description]">
                                            <SelectParameters>
                                                <asp:SessionParameter Name="Company" SessionField="Company" DefaultValue="" Type="String"/>
                                            </SelectParameters>
                                        </asp:SqlDataSource> 
                                </td>
                                <td>
                                    <telerik:RadLabel ID="RadLabelFiscalYear" runat="server" AssociatedControlID="RadComboBoxFiscalYear" >
                                        Fiscal Year
                                    </telerik:RadLabel>
                                    <telerik:RadComboBox runat="server" ID="RadComboBoxFiscalYear"  EnableLoadOnDemand="true" DataSourceID="SqlDataSourceFiscalYear" DataTextField="FiscalYear" DataValueField="FiscalYear" AutoPostBack="true" Enabled="false"></telerik:RadComboBox>
                                        <asp:SqlDataSource ID="SqlDataSourceFiscalYear" runat="server" ConnectionString="<%$ ConnectionStrings:EpicorConnectionString %>" SelectCommand="select distinct FiscalYear from erp.FiscalYr A where Company=@Company union select 0 Order by [FiscalYear]">
                                            <SelectParameters>
                                                <asp:SessionParameter Name="Company" SessionField="Company" DefaultValue="" Type="String"/>
                                            </SelectParameters>
                                        </asp:SqlDataSource> 
                                </td>
                                <td>
                                    <telerik:RadLabel ID="RadLabelBudgetCode" runat="server" AssociatedControlID="RadTextBoxBudgetCode">
                                        Budget Code
                                    </telerik:RadLabel>
                                    <telerik:RadComboBox runat="server" ID="RadComboBoxBudgetCode"  EnableLoadOnDemand="true" DataSourceID="SqlDataSourceBudgetCode" DataTextField="BudgetCodeDesc" DataValueField="BudgetCodeID" AutoPostBack="true" Enabled="false"></telerik:RadComboBox>
                                        <asp:SqlDataSource ID="SqlDataSourceBudgetCode" runat="server" ConnectionString="<%$ ConnectionStrings:EpicorConnectionString %>" SelectCommand="select BudgetCodeID,BudgetCodeDesc from erp.BudgetCode A where Inactive=0 and Company=@Company union select '','' Order by [BudgetCodeDesc]">
                                            <SelectParameters>
                                                <asp:SessionParameter Name="Company" SessionField="Company" DefaultValue="" Type="String"/>
                                            </SelectParameters>
                                        </asp:SqlDataSource> 
                                </td>
                            </tr>
                        </table>
                    </telerik:LayoutColumn>
                </Columns>
            </telerik:LayoutRow>
            <telerik:LayoutRow>
                <Columns>
                    <telerik:LayoutColumn Span="10" SpanMd="12" SpanSm="12" SpanXs="12">
                        <div>
                            <telerik:RadLabel ID="RadLabelBudgetTitle" runat="server" AssociatedControlID="RadTextBoxBudgetTitle">
                                Budget Title
                            </telerik:RadLabel>
                            <telerik:RadTextBox ID="RadTextBoxBudgetTitle" Runat="server" Resize="None" Text="" Width="100%" Font-Bold="True" ReadOnly="true">
                            </telerik:RadTextBox>
                            <telerik:RadLabel ID="RadLabelStatus" runat="server" AssociatedControlID="RadTextBoxStatus">
                                Status
                            </telerik:RadLabel>
                            <telerik:RadTextBox ID="RadTextBoxStatus" runat="server" ReadOnly="true" ></telerik:RadTextBox>
                        </div>                        
                    </telerik:LayoutColumn>
                </Columns>
            </telerik:LayoutRow>
            <telerik:LayoutRow>
                <Columns>
                    <telerik:LayoutColumn Span="10" SpanMd="12" SpanSm="12" SpanXs="12">
                        <div>
                            <telerik:RadButton ID="RadButtonDownload" runat="server" Text="Download" Skin="Web20" AutoPostBack="true" OnClick="RadButtonDownload_Click">
                            </telerik:RadButton>
                            <telerik:RadButton ID="RadButtonApprove" runat="server" Text="Approve" Skin="Telerik" OnClick="RadButtonApprove_Click">
                            </telerik:RadButton>
                            <telerik:RadButton ID="RadButtonReject" runat="server" Text="Reject" Skin="Sunset" OnClick="RadButtonReject_Click">
                            </telerik:RadButton>
                            <telerik:RadButton ID="RadButtonApprovalLog" runat="server" Text="Approval Log" Skin="Web20" Visible="false">
                            </telerik:RadButton>
                            <telerik:RadButton ID="RadButtonAttachment" runat="server" Text="Attachment" Skin="Web20" Visible="false">
                            </telerik:RadButton>
                        </div>                        
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

        <telerik:RadGrid ID="RadGridDtl" runat="server" AllowFilteringByColumn="True" AllowPaging="false" AllowSorting="True" DataSourceID="SqlDataSourceDtl" ShowGroupPanel="True" Skin="Web20" Height="600px" PageSize="6" ClientSettings-Scrolling-FrozenColumnsCount="3" ShowFooter="True">
            <GroupingSettings CollapseAllTooltip="Collapse all groups"></GroupingSettings>
            <ClientSettings AllowDragToGroup="false">
                <Scrolling AllowScroll="True" UseStaticHeaders="True" />
            </ClientSettings>
            <MasterTableView AutoGenerateColumns="False" DataKeyNames="Company,EntryNum,Revision,Line" DataSourceID="SqlDataSourceDtl" >
                <Columns>
                        
                    <telerik:GridBoundColumn DataField="Line" HeaderStyle-Width="100" FilterControlWidth="50" DataType="System.Int32" FilterControlAltText="Filter Line column" HeaderText="Line" ReadOnly="true" SortExpression="Line" UniqueName="Line" >
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="Budget_Item" HeaderStyle-Width="200" FilterControlWidth="100" FilterControlAltText="Filter Budget_Item column" HeaderText="Budget_Item"  ReadOnly="true" SortExpression="Budget_Item" UniqueName="Budget_Item" DataFormatString="{0:@}">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="AccountCode" HeaderStyle-Width="200" FilterControlWidth="100" FilterControlAltText="Filter AccountCode column" HeaderText="AccountCode"  ReadOnly="true" SortExpression="AccountCode" UniqueName="AccountCode" DataFormatString="{0:@}">
                    </telerik:GridBoundColumn>                                    
                    <telerik:GridBoundColumn DataField="AccountDesc" HeaderStyle-Width="200" FilterControlWidth="100" FilterControlAltText="Filter AccountDesc column" HeaderText="AccountDesc"  ReadOnly="true" SortExpression="AccountDesc" UniqueName="AccountDesc" DataFormatString="{0:@}">
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

                    <telerik:GridBoundColumn DataField="GLAccount" HeaderStyle-Width="200" FilterControlWidth="100" FilterControlAltText="Filter GLAccount column" HeaderText="GLAccount"  ReadOnly="true" SortExpression="GLAccount" UniqueName="GLAccount" Display="false">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="SegValue1" HeaderStyle-Width="150" FilterControlWidth="100" FilterControlAltText="Filter SegValue1 column" HeaderText="SegValue1"  ReadOnly="true" SortExpression="SegValue1" UniqueName="SegValue1" Display="false">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="SegValue2" HeaderStyle-Width="150" FilterControlWidth="100" FilterControlAltText="Filter SegValue2 column" HeaderText="SegValue2"  ReadOnly="true" SortExpression="SegValue2" UniqueName="SegValue2" Display="false">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="SegValue3" HeaderStyle-Width="150" FilterControlWidth="100" FilterControlAltText="Filter SegValue3 column" HeaderText="SegValue3"  ReadOnly="true" SortExpression="SegValue3" UniqueName="SegValue3" Display="false">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="SegValue4" HeaderStyle-Width="150" FilterControlWidth="100" FilterControlAltText="Filter SegValue4 column" HeaderText="SegValue4"  ReadOnly="true" SortExpression="SegValue4" UniqueName="SegValue4" Display="false">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="SegValue5" HeaderStyle-Width="150" FilterControlWidth="100" FilterControlAltText="Filter SegValue5 column" HeaderText="SegValue5"  ReadOnly="true" SortExpression="SegValue5" UniqueName="SegValue5" Display="false">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="SegValue6" HeaderStyle-Width="150" FilterControlWidth="100" FilterControlAltText="Filter SegValue6 column" HeaderText="SegValue6"  ReadOnly="true" SortExpression="SegValue6" UniqueName="SegValue6" Display="false">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="SegValue7" HeaderStyle-Width="150" FilterControlWidth="100" FilterControlAltText="Filter SegValue7 column" HeaderText="SegValue7"  ReadOnly="true" SortExpression="SegValue7" UniqueName="SegValue7" Display="false">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="SegValue8" HeaderStyle-Width="150" FilterControlWidth="100" FilterControlAltText="Filter SegValue8 column" HeaderText="SegValue8"  ReadOnly="true" SortExpression="SegValue8" UniqueName="SegValue8" Display="false">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="SegValue9" HeaderStyle-Width="150" FilterControlWidth="100" FilterControlAltText="Filter SegValue9 column" HeaderText="SegValue9"  ReadOnly="true" SortExpression="SegValue9" UniqueName="SegValue9" Display="false">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="SegValue10" HeaderStyle-Width="150" FilterControlWidth="100" FilterControlAltText="Filter SegValue10 column" HeaderText="SegValue10"  ReadOnly="true" SortExpression="SegValue10" UniqueName="SegValue10" Display="false">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="CreatedBy" FilterControlAltText="Filter CreatedBy column" HeaderText="CreatedBy"  ReadOnly="true" SortExpression="CreatedBy" UniqueName="CreatedBy" Display="false">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="CreatedDate" DataType="System.DateTime" FilterControlAltText="Filter CreatedDate column" HeaderText="CreatedDate"  ReadOnly="true" SortExpression="CreatedDate" UniqueName="CreatedDate" Display="false">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="ChangedBy" FilterControlAltText="Filter ChangedBy column" HeaderText="ChangedBy"  ReadOnly="true" SortExpression="ChangedBy" UniqueName="ChangedBy" Display="false">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="ChangedDate" DataType="System.DateTime" FilterControlAltText="Filter ChangedDate column" HeaderText="ChangedDate"  ReadOnly="true" SortExpression="ChangedDate" UniqueName="ChangedDate" Display="false">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="SysRowID" DataType="System.Guid" FilterControlAltText="Filter SysRowID column" HeaderText="SysRowID"  ReadOnly="true" SortExpression="SysRowID" UniqueName="SysRowID" Visible="false">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="Company" FilterControlAltText="Filter Company column" HeaderText="Company" ReadOnly="true" SortExpression="Company" UniqueName="Company"  Display="false">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="EntryNum" FilterControlAltText="Filter EntryNum column" HeaderText="EntryNum" ReadOnly="true" SortExpression="EntryNum" UniqueName="EntryNum"  Display="false">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="Revision" DataType="System.Int32" FilterControlAltText="Filter Revision column" HeaderText="Revision" ReadOnly="true" SortExpression="Revision" UniqueName="Revision"  Display="false">
                    </telerik:GridBoundColumn>
                                    
                </Columns>
            </MasterTableView>
        </telerik:RadGrid>
        <asp:SqlDataSource ID="SqlDataSourceDtl" runat="server" ConnectionString="<%$ ConnectionStrings:BudgetPlanConnectionString %>" 
            SelectCommand="SELECT dbo.udf_GetFullAccount(SegValue1,SegValue2,SegValue3,SegValue4,SegValue5,SegValue6,SegValue7,SegValue8,SegValue9,SegValue10) as AccountCode,* FROM [BudgetPlanDtl] WHERE [Company]=@Company AND [EntryNum]=@EntryNum AND [Revision]=@Revision ORDER BY [EntryNum], [Line]"
            InsertCommand="INSERT INTO [BudgetPlanDtl] ([Company], [EntryNum], [Revision], [Line], [Budget_Item], [Period_1], [Period_2], [Period_3], [Period_4], [Period_5], [Period_6], [Period_7], [Period_8], [Period_9], [Period_10], [Period_11], [Period_12], [GLAccount], [AccountDesc], [SegValue1], [SegValue2], [SegValue3], [SegValue4], [SegValue5], [SegValue6], [SegValue7], [SegValue8], [SegValue9], [SegValue10]) VALUES (@Company, @EntryNum, @Revision, @Line, @Budget_Item, @Period_1, @Period_2, @Period_3, @Period_4, @Period_5, @Period_6, @Period_7, @Period_8, @Period_9, @Period_10, @Period_11, @Period_12, @GLAccount, @AccountDesc, @SegValue1, @SegValue2, @SegValue3, @SegValue4, @SegValue5, @SegValue6, @SegValue7, @SegValue8, @SegValue9, @SegValue10)"
            DeleteCommand="DELETE FROM [BudgetPlanDtl] WHERE [Company] = @Company AND [EntryNum] = @EntryNum AND [Revision]=@Revision AND [Line] = @Line"
            UpdateCommand="UPDATE [BudgetPlanDtl] SET [Period_1] = @Period_1, [Period_2] = @Period_2, [Period_3] = @Period_3, [Period_4] = @Period_4, [Period_5] = @Period_5, [Period_6] = @Period_6, [Period_7] = @Period_7, [Period_8] = @Period_8, [Period_9] = @Period_9, [Period_10] = @Period_10, [Period_11] = @Period_11, [Period_12] = @Period_12 WHERE [Company] = @Company AND [EntryNum] = @EntryNum AND [Revision]=@Revision AND [Line] = @Line"
            >
            <InsertParameters>
                <asp:Parameter Name="Company" Type="String"></asp:Parameter>
                <asp:Parameter Name="EntryNum" Type="String"></asp:Parameter>
                <asp:Parameter Name="Revision" Type="Int32"></asp:Parameter>
                <asp:Parameter Name="Line" Type="Int32"></asp:Parameter>                                
            </InsertParameters>
            <DeleteParameters>
                <asp:Parameter Name="Company" Type="String"></asp:Parameter>
                <asp:Parameter Name="EntryNum" Type="String"></asp:Parameter>
                <asp:Parameter Name="Revision" Type="Int32"></asp:Parameter>
                <asp:Parameter Name="Line" Type="Int32"></asp:Parameter>
            </DeleteParameters>
            <UpdateParameters>                                
                <asp:Parameter Name="Company" Type="String"></asp:Parameter>
                <asp:Parameter Name="EntryNum" Type="String"></asp:Parameter>
                <asp:Parameter Name="Revision" Type="Int32"></asp:Parameter>
                <asp:Parameter Name="Line" Type="Int32"></asp:Parameter>
            </UpdateParameters>
            <SelectParameters>
                <asp:SessionParameter Name="Company" SessionField="Company" DefaultValue="" Type="String"/>
                <asp:SessionParameter Name="EntryNum" SessionField="EntryNum" DefaultValue="" Type="String"/>
                <asp:SessionParameter Name="Revision" DefaultValue="0" Type="Int32">
                </asp:SessionParameter>
            </SelectParameters>
        </asp:SqlDataSource>

    </div>
    <h6><telerik:RadTextBox ID="RadTextBoxCurrentCompany" runat="server" Label="CompanyID:" ReadOnly="true" Display="false"></telerik:RadTextBox><telerik:RadTextBox ID="RadTextBoxCurrentCompanyName" runat="server" Label="Company:" ReadOnly="true" ></telerik:RadTextBox><telerik:RadTextBox ID="RadTextBoxUserID" runat="server" Label="UserID:" ReadOnly="true" ></telerik:RadTextBox></h6>
                    

</asp:Content>
