<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageLoginMenu.Master" AutoEventWireup="true" CodeBehind="LoginDebug.aspx.cs" Inherits="BudgetPlan.LoginDebug" %>
<%@ Register TagPrefix="telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>

<asp:Content ID="Content0" ContentPlaceHolderID="head" Runat="Server">
    <link href="styles/default.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <telerik:RadAjaxManager runat="server" ID="RadAjaxManager1">
        <AjaxSettings>            
            <telerik:AjaxSetting AjaxControlID="RadButtonLogin">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadLabelErrorMsg" />
                    <telerik:AjaxUpdatedControl ControlID="RadLabelMsg" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManager>
    
    <div>
        <telerik:RadLabel ID="RadLabelErrorMsg" runat="server" ForeColor="Red"></telerik:RadLabel>
    </div>

    <telerik:RadPageLayout runat="server" ID="JumbotronLayout" CssClass="jumbotron" GridType="Fluid">
        <Rows>
            <telerik:LayoutRow>
                <Columns>
                    <telerik:LayoutColumn Span="10" SpanMd="12" SpanSm="12" SpanXs="12">
                        <telerik:RadLabel ID="RadLabelTitle" runat="server" Text="Please login."></telerik:RadLabel>
                        <br />
                        <telerik:RadTextBox ID="RadTextBoxUserID" runat="server" EmptyMessage="UserID" ></telerik:RadTextBox>
                        <br />
                        <telerik:RadTextBox ID="RadTextBoxPassword" runat="server" EmptyMessage="Password" TextMode="Password"></telerik:RadTextBox>
                        <br />                        
                        <telerik:RadButton ID="RadButtonLogin" runat="server" Text="Login" Skin="Web20" OnClick="RadButtonLogin_Click"></telerik:RadButton>
                        <telerik:RadButton ID="RadButtonChangePW" runat="server" Text="Change password" Skin="Web20" OnClick="RadButtonChangePW_Click"></telerik:RadButton>
                        <telerik:RadLabel ID="RadLabelMsg" runat="server" ForeColor="Red"></telerik:RadLabel>
                    </telerik:LayoutColumn>
                </Columns>
            </telerik:LayoutRow>
        </Rows>
    </telerik:RadPageLayout>

</asp:Content>
