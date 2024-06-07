<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageSingleMenu.Master" AutoEventWireup="true" CodeBehind="UserRegistry.aspx.cs" Inherits="BudgetPlan.UserRegistry" %>
<%@ Register TagPrefix="telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>

<asp:Content ID="Content0" ContentPlaceHolderID="head" Runat="Server">
    <link href="styles/default.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <telerik:RadAjaxManager runat="server" ID="RadAjaxManager1">
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="RadButtonSearch">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGridSearch" />
                    <telerik:AjaxUpdatedControl ControlID="RadLabelMsg" />
                    <telerik:AjaxUpdatedControl ControlID="RadLabelErrorMsg" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="RadGridSearch">
                <UpdatedControls>                        
                    <telerik:AjaxUpdatedControl ControlID="RadGridSearch"/>                                               
                    <telerik:AjaxUpdatedControl ControlID="RadLabelMsg"/>
                    <telerik:AjaxUpdatedControl ControlID="RadLabelErrorMsg" />

                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxCreateUserID" />
                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxName" />
                    <telerik:AjaxUpdatedControl ControlID="RadCheckBoxIsSysAdmin" />
                    <telerik:AjaxUpdatedControl ControlID="RadCheckBoxIsBudgetTemplate" />
                    <telerik:AjaxUpdatedControl ControlID="RadCheckBoxIsBudgetPlan" />
                    <telerik:AjaxUpdatedControl ControlID="RadCheckBoxIsBudgetEntry" />
                    <telerik:AjaxUpdatedControl ControlID="RadCheckBoxIsBudgetApproval" />
                    <telerik:AjaxUpdatedControl ControlID="RadCheckBoxInactive" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="RadButtonNew">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxCreateUserID" />
                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxName" />
                    <telerik:AjaxUpdatedControl ControlID="RadCheckBoxIsSysAdmin" />
                    <telerik:AjaxUpdatedControl ControlID="RadCheckBoxIsBudgetTemplate" />
                    <telerik:AjaxUpdatedControl ControlID="RadCheckBoxIsBudgetPlan" />
                    <telerik:AjaxUpdatedControl ControlID="RadCheckBoxIsBudgetEntry" />
                    <telerik:AjaxUpdatedControl ControlID="RadCheckBoxIsBudgetApproval" />
                    <telerik:AjaxUpdatedControl ControlID="RadCheckBoxInactive" />

                    <telerik:AjaxUpdatedControl ControlID="RadLabelMsg" />
                    <telerik:AjaxUpdatedControl ControlID="RadLabelErrorMsg" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="RadButtonSave">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxCreateUserID" />
                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxName" />
                    <telerik:AjaxUpdatedControl ControlID="RadCheckBoxIsSysAdmin" />
                    <telerik:AjaxUpdatedControl ControlID="RadCheckBoxIsBudgetTemplate" />
                    <telerik:AjaxUpdatedControl ControlID="RadCheckBoxIsBudgetPlan" />
                    <telerik:AjaxUpdatedControl ControlID="RadCheckBoxIsBudgetEntry" />
                    <telerik:AjaxUpdatedControl ControlID="RadCheckBoxIsBudgetApproval" />
                    <telerik:AjaxUpdatedControl ControlID="RadCheckBoxInactive" />

                    <telerik:AjaxUpdatedControl ControlID="RadLabelMsg" />
                    <telerik:AjaxUpdatedControl ControlID="RadLabelErrorMsg" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="RadButtonDelete">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxCreateUserID" />
                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxName" />
                    <telerik:AjaxUpdatedControl ControlID="RadCheckBoxIsSysAdmin" />
                    <telerik:AjaxUpdatedControl ControlID="RadCheckBoxIsBudgetTemplate" />
                    <telerik:AjaxUpdatedControl ControlID="RadCheckBoxIsBudgetPlan" />
                    <telerik:AjaxUpdatedControl ControlID="RadCheckBoxIsBudgetEntry" />
                    <telerik:AjaxUpdatedControl ControlID="RadCheckBoxIsBudgetApproval" />
                    <telerik:AjaxUpdatedControl ControlID="RadCheckBoxInactive" />

                    <telerik:AjaxUpdatedControl ControlID="RadLabelMsg" />
                    <telerik:AjaxUpdatedControl ControlID="RadLabelErrorMsg" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="RadButtonResetPassword">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadLabelMsg" />
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
        <telerik:RadButton ID="RadButtonSearch" runat="server" Text="Search..." OnClick="RadButtonSearch_Click">
        </telerik:RadButton>            
    </div>

    <telerik:RadPageLayout runat="server" ID="JumbotronLayout" CssClass="jumbotron" GridType="Fluid">
        <Rows>
            <telerik:LayoutRow>
	            <Columns>
		            <telerik:LayoutColumn Span="10" SpanMd="12" SpanSm="12" SpanXs="12">

                    <div>
                            <telerik:RadGrid ID="RadGridSearch" runat="server" Visible="false" AllowFilteringByColumn="True" AllowPaging="True" AllowSorting="True" DataSourceID="SqlDataSourceUserList" OnItemCommand="RadGridSearch_ItemCommand">
                                <GroupingSettings CollapseAllTooltip="Collapse all groups"></GroupingSettings>
                                <ClientSettings>
                                    <Selecting AllowRowSelect="True" />
                                    <Scrolling AllowScroll="True" UseStaticHeaders="True" />
                                </ClientSettings>
                                <MasterTableView CommandItemDisplay="Bottom" AutoGenerateColumns="False" DataKeyNames="UserID" DataSourceID="SqlDataSourceUserList">
                                    <CommandItemTemplate>
                                        <telerik:RadButton ID="RadButtonSearchOK" runat="server" Text="OK" CommandName="RadButtonSearchOK" ></telerik:RadButton>
                                        <telerik:RadButton ID="RadButtonSearchCancel" runat="server" Text="Cancel" CommandName="RadButtonSearchCancel" ></telerik:RadButton>
                                    </CommandItemTemplate>
                                    <Columns>
                                       <telerik:GridBoundColumn DataField="UserID" FilterControlAltText="Filter UserID column" HeaderText="UserID" ReadOnly="True" SortExpression="UserID" UniqueName="UserID">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="Name" FilterControlAltText="Filter Name column" HeaderText="Name" ReadOnly="True" SortExpression="Name" UniqueName="Name">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="IsSysAdmin" FilterControlAltText="Filter IsSysAdmin column" HeaderText="IsSysAdmin" ReadOnly="True" SortExpression="IsSysAdmin" UniqueName="IsSysAdmin">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="IsBudgetTemplate" FilterControlAltText="Filter IsBudgetTemplate column" HeaderText="IsBudgetTemplate" ReadOnly="True" SortExpression="IsBudgetTemplate" UniqueName="IsBudgetTemplate">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="IsBudgetPlan" FilterControlAltText="Filter IsBudgetPlan column" HeaderText="IsBudgetPlan" ReadOnly="True" SortExpression="IsBudgetPlan" UniqueName="IsBudgetPlan">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="IsBudgetEntry" FilterControlAltText="Filter IsBudgetEntry column" HeaderText="IsBudgetEntry" ReadOnly="True" SortExpression="IsBudgetEntry" UniqueName="IsBudgetEntry">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="IsBudgetApproval" FilterControlAltText="Filter IsBudgetApproval column" HeaderText="IsBudgetApproval" ReadOnly="True" SortExpression="IsBudgetApproval" UniqueName="IsBudgetApproval">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="Inactive" FilterControlAltText="Filter Inactive column" HeaderText="Inactive" ReadOnly="True" SortExpression="Inactive" UniqueName="Inactive">
                                        </telerik:GridBoundColumn>
                                    </Columns>
                                </MasterTableView>
                            </telerik:RadGrid>

                            <asp:SqlDataSource ID="SqlDataSourceUserList" runat="server" ConnectionString="<%$ ConnectionStrings:BudgetPlanConnectionString %>" 
                                SelectCommand="SELECT [UserID], [Name], [IsSysAdmin], [IsBudgetTemplate], [IsBudgetPlan], [IsBudgetEntry], [IsBudgetApproval], [Inactive] FROM [UserFile] WHERE 1=1 ORDER BY [UserID]"
                            ></asp:SqlDataSource>

                        </div>

		            </telerik:LayoutColumn>
	            </Columns>
            </telerik:LayoutRow>
            <telerik:LayoutRow>
                <Columns>
                    <telerik:LayoutColumn Span="10" SpanMd="12" SpanSm="12" SpanXs="12">

                        <table style="width: 100%;">
                            <tr>
                                <td style="width: 10%"><telerik:RadLabel ID="RadLabelUserID" runat="server" >UserID</telerik:RadLabel></td>
                                <td style="width: 50%"><telerik:RadTextBox ID="RadTextBoxCreateUserID" runat="server" Skin="Web20" ></telerik:RadTextBox></td>
                                <td>&nbsp;</td>
                            </tr>
                            <tr>
                                <td><telerik:RadLabel ID="RadLabelName" runat="server" >Name</telerik:RadLabel></td>
                                <td><telerik:RadTextBox ID="RadTextBoxName" runat="server" Skin="Web20" ></telerik:RadTextBox></td>
                                <td>&nbsp;</td>
                            </tr>
                            <tr>
                                <td><telerik:RadLabel ID="RadLabelIsSysAdmin" runat="server" >System Admin</telerik:RadLabel></td>
                                <td style="float: left"><telerik:RadCheckBox ID="RadCheckBoxIsSysAdmin" runat="server" Skin="Web20" ></telerik:RadCheckBox></td>
                                <td>&nbsp;</td>
                            </tr>
                            <tr>
                                <td><telerik:RadLabel ID="RadLabelIsBudgetTemplate" runat="server" >Budget Template</telerik:RadLabel></td>
                                <td style="float: left"><telerik:RadCheckBox ID="RadCheckBoxIsBudgetTemplate" runat="server" Skin="Web20" ></telerik:RadCheckBox></td>
                                <td>&nbsp;</td>
                            </tr>
                            <tr>
                                <td><telerik:RadLabel ID="RadLabelIsBudgetPlan" runat="server" >Budget Plan</telerik:RadLabel></td>
                                <td style="float: left"><telerik:RadCheckBox ID="RadCheckBoxIsBudgetPlan" runat="server" Skin="Web20" ></telerik:RadCheckBox></td>
                                <td>&nbsp;</td>
                            </tr>
                            <tr>
                                <td><telerik:RadLabel ID="RadLabelIsBudgetEntry" runat="server" >Budget Entry</telerik:RadLabel></td>
                                <td style="float: left"><telerik:RadCheckBox ID="RadCheckBoxIsBudgetEntry" runat="server" Skin="Web20" ></telerik:RadCheckBox></td>
                                <td>&nbsp;</td>
                            </tr>
                            <tr>
                                <td><telerik:RadLabel ID="RadLabelIsBudgetApproval" runat="server" >Budget Approval</telerik:RadLabel></td>
                                <td style="float: left"><telerik:RadCheckBox ID="RadCheckBoxIsBudgetApproval" runat="server" Skin="Web20" ></telerik:RadCheckBox></td>
                                <td>&nbsp;</td>
                            </tr>
                            <tr>
                                <td><telerik:RadLabel ID="RadLabelInactive" runat="server" >Inactive</telerik:RadLabel></td>
                                <td style="float: left"><telerik:RadCheckBox ID="RadCheckBoxInactive" runat="server" Skin="Web20" ></telerik:RadCheckBox></td>
                                <td>&nbsp;</td>
                            </tr>
                        </table>


                        <telerik:RadTextBox ID="RadTextBoxUserID" runat="server" Skin="Web20"  Label="UserID:" ReadOnly="true" ></telerik:RadTextBox>

                    </telerik:LayoutColumn>
                </Columns>
            </telerik:LayoutRow>
            <telerik:LayoutRow>
	            <Columns>
		            <telerik:LayoutColumn Span="10" SpanMd="12" SpanSm="12" SpanXs="12">
                        <telerik:RadButton ID="RadButtonResetPassword" runat="server" Text="Reset Password" Skin="Web20" OnClick="RadButtonResetPassword_Click">
                        </telerik:RadButton>
                        <telerik:RadButton ID="RadButtonDelete" runat="server" Text="Delete" Skin="Web20" OnClick="RadButtonDelete_Click">
                        </telerik:RadButton>
                        <telerik:RadButton ID="RadButtonSave" runat="server" Text="Save" Skin="Web20" OnClick="RadButtonSave_Click">
                        </telerik:RadButton>
                        <telerik:RadButton ID="RadButtonNew" runat="server" Text="New" Skin="Web20" OnClick="RadButtonNew_Click">
                        </telerik:RadButton>
		            </telerik:LayoutColumn>
	            </Columns>
            </telerik:LayoutRow>
        </Rows>
    </telerik:RadPageLayout>

</asp:Content>
