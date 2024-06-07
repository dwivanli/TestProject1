<%@ Page Language="C#" MasterPageFile="~/MasterPageSingleMenu.Master" AutoEventWireup="true" CodeBehind="ChangePW.aspx.cs" Inherits="BudgetPlan.ChangePW" %>
<%@ Register TagPrefix="telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>


<asp:Content ID="Content0" ContentPlaceHolderID="head" Runat="Server">
    <link href="styles/default.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <telerik:RadAjaxManager runat="server" ID="RadAjaxManager1">
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="RadButtonChangePW">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxUserID" />
                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxNewPw" />
                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxConfirmNewPw" />

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

                    <div>
                        <telerik:RadLabel ID="RadLabelTitle" runat="server" Text="Change your passowrd."></telerik:RadLabel>
                        <br />
                        <telerik:RadLabel ID="RadLabelUserID" runat="server" AssociatedControlID="RadTextBoxUserID">UserID</telerik:RadLabel>
                        <telerik:RadTextBox ID="RadTextBoxUserID" runat="server" EmptyMessage="UserID" ReadOnly="true"></telerik:RadTextBox>
                        <br />
                        <telerik:RadLabel ID="RadLabelNewpassword" runat="server" AssociatedControlID="RadTextBoxNewPw">New password</telerik:RadLabel>
                        <telerik:RadTextBox ID="RadTextBoxNewPw" runat="server" EmptyMessage="Password" TextMode="Password"></telerik:RadTextBox>
                        <br />
                        <telerik:RadLabel ID="RadLabelConfirmNewPw" runat="server" AssociatedControlID="RadTextBoxConfirmNewPw">Confirm new password</telerik:RadLabel>
                        <telerik:RadTextBox ID="RadTextBoxConfirmNewPw" runat="server" EmptyMessage="Password" TextMode="Password"></telerik:RadTextBox>
                        <br />
                        <telerik:RadButton ID="RadButtonChangePW" runat="server" Text="Change password" Skin="Web20" OnClick="RadButtonChangePW_Click" ></telerik:RadButton>
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
            <telerik:LayoutRow>
	            <Columns>
		            <telerik:LayoutColumn Span="10" SpanMd="12" SpanSm="12" SpanXs="12">

		            </telerik:LayoutColumn>
	            </Columns>
            </telerik:LayoutRow>
        </Rows>
    </telerik:RadPageLayout>

</asp:Content>

