<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageLoginMenu.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="BudgetPlan.Login" %>
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
                        <table style="width: 100%;">
                            <tr>
                                <td style="width: 40%;"></td>
                                <td style="width: 30%;">
                        <telerik:RadLabel ID="RadLabelTitle" runat="server" Text="Please login." Width="300"></telerik:RadLabel>
                        <br />
                        <telerik:RadTextBox ID="RadTextBoxUserID" runat="server" Label="UserID" Width="300"></telerik:RadTextBox>
                        <br />
                        <telerik:RadTextBox ID="RadTextBoxPassword" runat="server" Label="Password" TextMode="Password"  Width="300"></telerik:RadTextBox>
                        <br /> 

                        <telerik:RadButton ID="RadButtonLogin" runat="server" Text="Login" Skin="Web20" OnClick="RadButtonLogin_Click"></telerik:RadButton>
                        
                        <telerik:RadButton ID="RadButtonChangePW" runat="server" Text="Change password" Skin="Web20" OnClick="RadButtonChangePW_Click"></telerik:RadButton>
                        <telerik:RadLabel ID="RadLabelMsg" runat="server" ForeColor="Red"></telerik:RadLabel>

                                </td>
                                <td style="width: 30%;"></td>
                            </tr>
                        </table>

                      
                    </telerik:LayoutColumn>
                </Columns>
            </telerik:LayoutRow>
        </Rows>
    </telerik:RadPageLayout>

</asp:Content>

