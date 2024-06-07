<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageSingleMenu.Master" AutoEventWireup="true" CodeBehind="ChangeCompany.aspx.cs" Inherits="BudgetPlan.ChangeCompany" %>
<%@ Register TagPrefix="telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>

<asp:Content ID="Content0" ContentPlaceHolderID="head" Runat="Server">
    <link href="styles/default.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <telerik:RadAjaxManager runat="server" ID="RadAjaxManager1">
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="RadComboBoxCompany">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadLabelErrorMsg" />
                    <telerik:AjaxUpdatedControl ControlID="RadLabelMsg" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="RadButtonSave">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadLabelErrorMsg" />
                    <telerik:AjaxUpdatedControl ControlID="RadLabelMsg" />
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
                        <asp:Panel ID="PanelSetup" runat="server">
                        <telerik:RadLabel ID="RadLabelCompany" runat="server" Text="Current Company" AssociatedControlID="RadComboBoxCompany"></telerik:RadLabel>
                        <telerik:RadComboBox runat="server" ID="RadComboBoxCompany"  Skin="Web20" EmptyMessage="Change Company" EnableLoadOnDemand="true" DataSourceID="SqlDataSourceCompany" DataTextField="CompanyIDName" DataValueField="Company" OnTextChanged="RadComboBoxCompany_TextChanged" AutoPostBack="true"></telerik:RadComboBox>
                        <br />
                        <telerik:RadButton ID="RadButtonSave" runat="server" Text="Save" Skin="Web20" OnClick="RadButtonSave_Click"></telerik:RadButton>
                           <asp:SqlDataSource ID="SqlDataSourceCompany" runat="server" ConnectionString="<%$ ConnectionStrings:BudgetPlanConnectionString %>" SelectCommand="select [Company],[Name],'('+[Company]+')'+[Name] As CompanyIDName from Company ORDER BY [Company]"></asp:SqlDataSource>
                        <br />
                        <telerik:RadTextBox ID="RadTextBoxUserID" runat="server" Label="UserID:" ReadOnly="true" ></telerik:RadTextBox>
                        </asp:Panel>
                 </telerik:LayoutColumn>
                </Columns>
            </telerik:LayoutRow>
        </Rows>
    </telerik:RadPageLayout>



</asp:Content>