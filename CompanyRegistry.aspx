﻿<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageSingleMenu.Master" AutoEventWireup="true" CodeBehind="CompanyRegistry.aspx.cs" Inherits="BudgetPlan.CompanyRegistry" %>
<%@ Register TagPrefix="telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>

<asp:Content ID="Content0" ContentPlaceHolderID="head" Runat="Server">
    <link href="styles/default.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <telerik:RadAjaxManager runat="server" ID="RadAjaxManager1">
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="RadButtonCreate">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxCompany" />
                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxName" />
                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxERPCompany" />
                    <telerik:AjaxUpdatedControl ControlID="RadGridCompanyList" />
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

    <telerik:RadPageLayout runat="server" ID="JumbotronLayout" CssClass="jumbotron" GridType="Fluid">
        <Rows>
            <telerik:LayoutRow>
                <Columns>
                    <telerik:LayoutColumn Span="10" SpanMd="12" SpanSm="12" SpanXs="12">
                        <telerik:RadLabel ID="RadLabelCompany" runat="server" AssociatedControlID="RadTextBoxCompany" >Company</telerik:RadLabel><telerik:RadTextBox ID="RadTextBoxCompany" runat="server" Skin="Web20" ></telerik:RadTextBox>                        
                        <telerik:RadLabel ID="RadLabelName" runat="server" AssociatedControlID="RadTextBoxName" >Name</telerik:RadLabel><telerik:RadTextBox ID="RadTextBoxName" runat="server" Skin="Web20" ></telerik:RadTextBox>
                        <br />
                        <telerik:RadLabel ID="RadLabelERPCompany" runat="server" AssociatedControlID="RadTextBoxERPCompany" >ERPCompany</telerik:RadLabel><telerik:RadTextBox ID="RadTextBoxERPCompany" runat="server" Skin="Web20" ></telerik:RadTextBox>
                        <br />
                        <telerik:RadButton ID="RadButtonCreate" runat="server" Text="Create" Skin="Web20" OnClick="RadButtonCreate_Click"></telerik:RadButton>
                        <br />
                        <br />
                        <telerik:RadGrid ID="RadGridCompanyList" runat="server" AllowFilteringByColumn="True" AllowPaging="True" AllowSorting="True" DataSourceID="SqlDataSourceCompanyList" Skin="Web20" AllowAutomaticDeletes="True" AutoGenerateDeleteColumn="true" >
                            <GroupingSettings CollapseAllTooltip="Collapse all groups"></GroupingSettings>
                            <ClientSettings>
                                <Scrolling AllowScroll="True" UseStaticHeaders="True" />
                            </ClientSettings>
                            <MasterTableView AutoGenerateColumns="false" DataKeyNames="Company" DataSourceID="SqlDataSourceCompanyList">
                                <Columns>
                                    <telerik:GridBoundColumn DataField="Company" FilterControlAltText="Filter Company column" HeaderText="Company" ReadOnly="True" SortExpression="Company" UniqueName="Company">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="Name" FilterControlAltText="Filter Name column" HeaderText="Name" ReadOnly="True" SortExpression="Name" UniqueName="Name">
                                    </telerik:GridBoundColumn>     
                                    <telerik:GridBoundColumn DataField="ERPCompany" FilterControlAltText="Filter ERPCompany column" HeaderText="ERPCompany" ReadOnly="True" SortExpression="ERPCompany" UniqueName="ERPCompany">
                                    </telerik:GridBoundColumn>   
                                </Columns>
                            </MasterTableView>
                        </telerik:RadGrid>

                            <asp:SqlDataSource ID="SqlDataSourceCompanyList" runat="server" ConnectionString="<%$ ConnectionStrings:BudgetPlanConnectionString %>" 
                                SelectCommand="SELECT Company,[Name],ERPCompany from Company ORDER BY Company"
                                DeleteCommand="DELETE FROM [Company] WHERE [Company] = @Company"
                                ></asp:SqlDataSource>


                        <br />
                        <telerik:RadTextBox ID="RadTextBoxUserID" runat="server" Skin="Glow"  Label="UserID:" ReadOnly="true" ></telerik:RadTextBox>

                    </telerik:LayoutColumn>
                </Columns>
            </telerik:LayoutRow>
        </Rows>
    </telerik:RadPageLayout>

</asp:Content>