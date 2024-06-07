<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPageSingleMenu.Master" AutoEventWireup="true" CodeBehind="BudgetTemplate.aspx.cs" Inherits="BudgetPlan.BudgetTemplate" %>
<%@ Register TagPrefix="telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>

<asp:Content ID="Content0" ContentPlaceHolderID="head" Runat="Server">
    <link href="styles/default.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <telerik:RadCodeBlock ID="RadCodeBlock1" runat="server">
    <script src="scripts/jquery-1.7.1.min.js"></script>
    <script type="text/javascript">
        //Put your JavaScript code here.
        var CurrentLine = 0;
        var CurrentSegmentNbr = 0;

        function OnBatchEditOpened(sender, args) {
            args.get_tableView().get_dataItems();
            var item = args.get_row().control;

            var batchEditingManager = sender.get_batchEditingManager(); //get the batch editing manager
            CurrentLine = batchEditingManager.getCellValue(item.get_cell("Line"));

            if (item.get_itemIndex() < 0) { // new row
                // execute custom logic

                if (batchEditingManager.getCellValue(item.get_cell("Company")) == "") {
                    sender.remove_batchEditOpened(OnBatchEditOpened);//avoid recursion

                    //use the batch edit manager API ot change cell values
                    var CompanyValue = $find("<%= RadTextBoxCompany.ClientID %>").get_value();
                    batchEditingManager.changeCellValue(item.get_cell("Company"), CompanyValue);

                    var TemplateNumValue = $find("<%= RadTextBoxTemplateNum.ClientID %>").get_value();
                    batchEditingManager.changeCellValue(item.get_cell("TemplateNum"), TemplateNumValue);

                    var NextLineValue = 0;

                    var masterTable = $find("<%= RadGridDtl.ClientID %>").get_masterTableView();
                    var items = masterTable.get_dataItems();    //all rows, current page
                    var num = masterTable.get_dataItems().length;
                    var MaxLine = 0;

                    for (var index = 0; index < num; index++) {
                        var dataItem = masterTable.get_dataItems()[index];

                        var Line = batchEditingManager.getCellValue(dataItem.get_cell("Line"))

                        //alert(Line);

                        if (parseInt(Line) > parseInt(MaxLine)) {
                            MaxLine = Line;
                        }
                    }

                    NextLineValue = parseInt(MaxLine) + 1;

                    batchEditingManager.changeCellValue(item.get_cell("Line"), NextLineValue);

                    setTimeout(function () {
                        sender.add_batchEditOpened(OnBatchEditOpened);//return the event handler after a bit so it can keep working
                        batchEditingManager.openCellForEdit(item.get_cell("Budget_Item"));//open the next cell in case the cell we changed was the first - it would have lost focus
                    }, 100);

                    
                }

            }

        }

        //OnBatchEditCellValueChanged
        function OnBatchEditCellValueChanged(sender, args) {

            /*
            var data = sender.get_batchEditingManager()._getCellDataToOpenEdit(sender.get_batchEditingManager().get_currentlyEditedCell());
            var row = data.row;
            var rowIndex = row.rowIndex;
            var columnName = data.columnUniqueName;
            var cell = data.cell;
            var oldValue = args.get_cellValue();
            var newValue = args.get_editorValue();

            var batchEditingManager = sender.get_batchEditingManager(); //get the batch editing manager
            batchEditingManager.changeCellValue(item.get_cell("AccountDesc"), "abcde");
            */

            var grd = sender;
            var masterTable = grd.get_masterTableView();
            var rows = masterTable.get_dataItems();
            var rowArgs = args.get_row();




            var batchManager = grd.get_batchEditingManager();
            var colName = args.get_columnUniqueName();  // Column that's been changed

            var item = args.get_row().control;
            CurrentLine = batchManager.getCellValue(item.get_cell("Line"));
            //alert(colName);

            switch (colName) {
                case 'GLAccount':

                    /*
                    var qty = batchManager.getCellValue(row.get_cell('PurchaseOrderDetailQuantity'));
                    var unitPrice = batchManager.getCellValue(row.get_cell('UnitPrice'));
                    var result = setNumber(qty) * setNumber(unitPrice);
                    if (result !== 0) { // Never set the amount to zero.
                        batchManager.changeCellValue(row.get_cell('PurchaseOrderDetailAmount'), result);
                    }
                    */
                    var newValue = args.get_editorValue();
                    //var company = batchManager.getCellValue(row.get_cell('Company'));

                    var GLA = newValue;
                    var COACode = $find("<%= RadComboBoxCOACode.ClientID %>").get_value();

                    $.ajax({
                        url: "BudgetTemplate.aspx/AjaxMethod_GetPreloadAccountDesc",//发送到本页面后台AjaxMethod方法
                        type: "POST",
                        dataType: "json",
                        async: false,//async翻译为异步的，false表示同步，会等待执行完成，true为异步
                        contentType: "application/json; charset=utf-8",//不可少
                        data: "{paramGLA:'" + GLA + "',paramCOACode:'" + COACode + "'}",
                        success: function (data) {
                            //$("#result").html(data.d);
                            // var GLDesc = data.d;
                            var rtValueList = data.d;   //seperate by ~

                            var ArryValueList = new Array();
                            ArryValueList = rtValueList.split("~");

                            /* cannot focus on new row status
                            var rowIndex = rowArgs.sectionRowIndex;
                            var row = rows[rowIndex];                 
                            batchManager.changeCellValue(row.get_cell('AccountDesc'), GLDesc);    
                            */

                            //focus on new row or update row is working fine
                            var dataItem = $find(rowArgs.id);
                            var AccountDescCell = dataItem.get_cell("AccountDesc");
                            //batchManager.changeCellValue(AccountDescCell, GLDesc);
                            batchManager.changeCellValue(AccountDescCell, ArryValueList[0]);


                            var SegValue1Cell = dataItem.get_cell("SegValue1");
                            batchManager.changeCellValue(SegValue1Cell, ArryValueList[1]);

                            var SegValue2Cell = dataItem.get_cell("SegValue2");
                            batchManager.changeCellValue(SegValue2Cell, ArryValueList[2]);

                            var SegValue3Cell = dataItem.get_cell("SegValue3");
                            batchManager.changeCellValue(SegValue3Cell, ArryValueList[3]);

                            var SegValue4Cell = dataItem.get_cell("SegValue4");
                            batchManager.changeCellValue(SegValue4Cell, ArryValueList[4]);

                            var SegValue5Cell = dataItem.get_cell("SegValue5");
                            batchManager.changeCellValue(SegValue5Cell, ArryValueList[5]);

                            var SegValue6Cell = dataItem.get_cell("SegValue6");
                            batchManager.changeCellValue(SegValue6Cell, ArryValueList[6]);

                            var SegValue7Cell = dataItem.get_cell("SegValue7");
                            batchManager.changeCellValue(SegValue7Cell, ArryValueList[7]);

                            var SegValue8Cell = dataItem.get_cell("SegValue8");
                            batchManager.changeCellValue(SegValue8Cell, ArryValueList[8]);

                            var SegValue9Cell = dataItem.get_cell("SegValue9");
                            batchManager.changeCellValue(SegValue9Cell, ArryValueList[9]);

                            var SegValue10Cell = dataItem.get_cell("SegValue10");
                            batchManager.changeCellValue(SegValue10Cell, ArryValueList[10]);

                            /* auto call Save Changes function
                            batchManager._tryCloseEdits(sender.get_masterTableView());                            
                            setTimeout(function () {
                                batchManager.saveChanges(sender.get_masterTableView());
                            }, 10)
                            */
                        },
                        error: function () {
                            alert("Get GLAccount ajax请求出错处理");
                        }
                    });

                    break;
            }
        }

        function openWinSearchGLA() {

            var RadTextBoxCompany = $find('<%= RadTextBoxCompany.ClientID %>');
            Company = RadTextBoxCompany.get_value();

            var RadComboBoxCOACode = $find('<%= RadComboBoxCOACode.ClientID %>');
            COACode = RadComboBoxCOACode.get_value();

            var oWnd = radopen("DialogSearchGLAccount.aspx?Company=" + Company + "&COACode=" + COACode, "RadWindow1", 800, 800); //win szie width,height, win pos left,top
        }

        function OnClientCloseGLA(oWnd, args) {
            //get the transferred arguments
            var arg = args.get_argument();
            if (arg) {
                var GLAccount = arg.GLAccount;

                //alert(GLAccount);
                //alert(CurrentLine);

                //find current row cell update not work
                var grid = $find("<%=RadGridDtl.ClientID %>");
                var masterTable = grid.get_masterTableView();

                var batchEditingManager = grid.get_batchEditingManager();
                var items = masterTable.get_dataItems();    //all rows, current page
                var num = masterTable.get_dataItems().length;

                for (var index = 0; index < num; index++) {
                    var dataItem = masterTable.get_dataItems()[index];

                    var Line = batchEditingManager.getCellValue(dataItem.get_cell("Line"))
                    //alert(Line);
                    if (CurrentLine == Line) {
                        batchEditingManager.changeCellValue(dataItem.get_cell("GLAccount"), GLAccount);
                    }

                }


            }
        }

        function openWinSearchSegValue(SegmentNbr) {

            var RadTextBoxCompany = $find('<%= RadTextBoxCompany.ClientID %>');
            Company = RadTextBoxCompany.get_value();

            var RadComboBoxCOACode = $find('<%= RadComboBoxCOACode.ClientID %>');
            COACode = RadComboBoxCOACode.get_value();

            CurrentSegmentNbr = SegmentNbr;

            var oWnd = radopen("DialogSearchSegValue.aspx?Company=" + Company + "&COACode=" + COACode + "&SegmentNbr=" + SegmentNbr, "RadWindow2", 800, 800, 200, 500); //win szie width,height, win pos left,top
        }

        function OnClientCloseSegValue(oWnd, args) {
            //get the transferred arguments
            var arg = args.get_argument();
            if (arg) {

                //alert(CurrentSegmentNbr);

                var SegValue = arg.SegValue;

                //find current row cell update not work
                var grid = $find("<%=RadGridDtl.ClientID %>");
                var masterTable = grid.get_masterTableView();

                var batchEditingManager = grid.get_batchEditingManager();
                var items = masterTable.get_dataItems();    //all rows, current page
                var num = masterTable.get_dataItems().length;

                for (var index = 0; index < num; index++) {
                    var dataItem = masterTable.get_dataItems()[index];

                    var Line = batchEditingManager.getCellValue(dataItem.get_cell("Line"))
                    //alert(Line);
                    if (CurrentLine == Line) {

                        if (CurrentSegmentNbr == 1) {
                            batchEditingManager.changeCellValue(dataItem.get_cell("SegValue1"), SegValue);
                        }
                        if (CurrentSegmentNbr == 2) {
                            batchEditingManager.changeCellValue(dataItem.get_cell("SegValue2"), SegValue);
                        }
                        if (CurrentSegmentNbr == 3) {
                            batchEditingManager.changeCellValue(dataItem.get_cell("SegValue3"), SegValue);
                        }
                        if (CurrentSegmentNbr == 4) {
                            batchEditingManager.changeCellValue(dataItem.get_cell("SegValue4"), SegValue);
                        }
                        if (CurrentSegmentNbr == 5) {
                            batchEditingManager.changeCellValue(dataItem.get_cell("SegValue5"), SegValue);
                        }
                        if (CurrentSegmentNbr == 6) {
                            batchEditingManager.changeCellValue(dataItem.get_cell("SegValue6"), SegValue);
                        }
                        if (CurrentSegmentNbr == 7) {
                            batchEditingManager.changeCellValue(dataItem.get_cell("SegValue7"), SegValue);
                        }
                        if (CurrentSegmentNbr == 8) {
                            batchEditingManager.changeCellValue(dataItem.get_cell("SegValue8"), SegValue);
                        }
                        if (CurrentSegmentNbr == 9) {
                            batchEditingManager.changeCellValue(dataItem.get_cell("SegValue9"), SegValue);
                        }
                        if (CurrentSegmentNbr == 10) {
                            batchEditingManager.changeCellValue(dataItem.get_cell("SegValue10"), SegValue);
                        }
                    }

                }


            }
        }



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
                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxTemplateNum"/>
                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxCreatedBy"/>
                    <telerik:AjaxUpdatedControl ControlID="RadComboBoxCOACode"/> 
                    <telerik:AjaxUpdatedControl ControlID="RadComboBoxBookID"/> 
                    <telerik:AjaxUpdatedControl ControlID="RadComboBoxFiscalYear"/> 
                    <telerik:AjaxUpdatedControl ControlID="RadComboBoxBudgetCode"/> 
 
                    <telerik:AjaxUpdatedControl ControlID="RadGridDtl"/>
                    
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="RadComboBoxCOACode">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGridDtl"/>
                    <telerik:AjaxUpdatedControl ControlID="RadLabelMsg"/>
                    <telerik:AjaxUpdatedControl ControlID="RadLabelErrorMsg" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="RadButtonNew">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadLabelMsg"/>
                    <telerik:AjaxUpdatedControl ControlID="RadLabelErrorMsg" />

                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxCompany"/>
                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxTemplateNum"/>
                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxCreatedBy"/>
                    <telerik:AjaxUpdatedControl ControlID="RadComboBoxCOACode" />
                    <telerik:AjaxUpdatedControl ControlID="RadComboBoxBookID" />
                    <telerik:AjaxUpdatedControl ControlID="RadComboBoxFiscalYear" />
                    <telerik:AjaxUpdatedControl ControlID="RadComboBoxBudgetCode" />
                    <telerik:AjaxUpdatedControl ControlID="RadGridDtl" />
                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxStatus"/> 
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="RadButtonSave">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadLabelMsg"/>
                    <telerik:AjaxUpdatedControl ControlID="RadLabelErrorMsg" />

                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxTemplateNum"/>
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="RadButtonDelete">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadLabelMsg"/>
                    <telerik:AjaxUpdatedControl ControlID="RadLabelErrorMsg" />

                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxCompany"/> 
                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxTemplateNum"/>
                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxCreatedBy"/>
                    <telerik:AjaxUpdatedControl ControlID="RadComboBoxCOACode"/> 
                    <telerik:AjaxUpdatedControl ControlID="RadComboBoxBookID"/> 
                    <telerik:AjaxUpdatedControl ControlID="RadComboBoxFiscalYear"/> 
                    <telerik:AjaxUpdatedControl ControlID="RadComboBoxBudgetCode"/> 
 
                    <telerik:AjaxUpdatedControl ControlID="RadGridDtl"/>
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="RadButtonUpload">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadLabelMsg"/>
                    <telerik:AjaxUpdatedControl ControlID="RadLabelErrorMsg" />

                    <telerik:AjaxUpdatedControl ControlID="RadGridDtl"/>
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="RadAsyncUploadDtl">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadLabelMsg"/>
                    <telerik:AjaxUpdatedControl ControlID="RadLabelErrorMsg" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManager>

    <telerik:RadWindowManager RenderMode="Lightweight" ID="RadWindowManager2" ShowContentDuringLoad="false" VisibleStatusbar="false"
        ReloadOnShow="true" runat="server" EnableShadow="true">
        <Windows>
            <telerik:RadWindow RenderMode="Lightweight" ID="RadWindow1" runat="server" Behaviors="Close" OnClientClose="OnClientCloseGLA"
                NavigateUrl="DialogSearchGLAccount.aspx">
            </telerik:RadWindow>
            <telerik:RadWindow RenderMode="Lightweight" ID="RadWindow2" runat="server" Behaviors="Close" OnClientClose="OnClientCloseSegValue"
                NavigateUrl="DialogSearchSegValue.aspx">
            </telerik:RadWindow>
        </Windows>
    </telerik:RadWindowManager>

    <div>
        <telerik:RadLabel ID="RadLabelErrorMsg" runat="server" ForeColor="Red"></telerik:RadLabel>
        <telerik:RadLabel ID="RadLabelMsg" runat="server" ForeColor="Red"></telerik:RadLabel>
    </div>

    <div>
        <telerik:RadButton ID="RadButtonSearch" runat="server" Text="Search..." OnClick="RadButtonSearch_Click" Skin="Web20">
        </telerik:RadButton>            
    </div>



    <telerik:RadPageLayout runat="server" ID="JumbotronLayout" CssClass="jumbotron" GridType="Fluid">
        <Rows>
            <telerik:LayoutRow>
                <Columns>
                    <telerik:LayoutColumn Span="10" SpanMd="12" SpanSm="12" SpanXs="12">

                    <div>
                            <telerik:RadGrid ID="RadGridSearch" runat="server" Skin="Web20" Visible="false" AllowFilteringByColumn="True" AllowPaging="True" AllowSorting="True" DataSourceID="SqlDataSourceSearchTemplateHed" OnItemCommand="RadGridSearch_ItemCommand">
                                <GroupingSettings CollapseAllTooltip="Collapse all groups"></GroupingSettings>
                                <ClientSettings>
                                    <Selecting AllowRowSelect="True" />
                                    <Scrolling AllowScroll="True" UseStaticHeaders="True" />
                                </ClientSettings>
                                <MasterTableView CommandItemDisplay="Bottom" AutoGenerateColumns="False" DataKeyNames="Company,TemplateNum" DataSourceID="SqlDataSourceSearchTemplateHed">
                                    <CommandItemTemplate>
                                        <telerik:RadButton ID="RadButtonSearchOK" runat="server" Text="OK" CommandName="RadButtonSearchOK" ></telerik:RadButton>
                                        <telerik:RadButton ID="RadButtonSearchCancel" runat="server" Text="Cancel" CommandName="RadButtonSearchCancel" ></telerik:RadButton>
                                    </CommandItemTemplate>
                                    <Columns>
                                        <telerik:GridBoundColumn DataField="Company" FilterControlAltText="Filter Company column" HeaderText="Company" ReadOnly="True" SortExpression="Company" UniqueName="Company">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="TemplateNum" FilterControlAltText="Filter TemplateNum column" HeaderText="TemplateNum" ReadOnly="True" SortExpression="EntryNum" UniqueName="TemplateNum">
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

                            <asp:SqlDataSource ID="SqlDataSourceSearchTemplateHed" runat="server" ConnectionString="<%$ ConnectionStrings:BudgetPlanConnectionString %>" SelectCommand="SELECT * FROM [BudgetTemplateHed] WHERE [Company]=@Company ORDER BY [Company], [TemplateNum]">
                                <SelectParameters>
                                    <asp:SessionParameter Name="Company" SessionField="Company" DefaultValue="" Type="String"/>
                                    <asp:SessionParameter Name="CreatedBy" SessionField="CreatedBy" DefaultValue="" Type="String"/>
                                </SelectParameters>
                            </asp:SqlDataSource>

                        </div>

                    </telerik:LayoutColumn>
                </Columns>
            </telerik:LayoutRow>
        </Rows>
        <Rows>
            <telerik:LayoutRow>
                <Columns>
                    <telerik:LayoutColumn Span="10" SpanMd="12" SpanSm="12" SpanXs="12">

                        <table style="width: 100%;">
                            <tr>
                                <td>
                                    <telerik:RadLabel ID="RadLabelTemplateNum" runat="server" AssociatedControlID="RadTextBoxTemplateNum">
                                    Template#
                                    </telerik:RadLabel>
                                    <telerik:RadTextBox ID="RadTextBoxTemplateNum" Runat="server" LabelWidth="64px" Resize="None" Text="2020-1-10" Width="100%">
                                    </telerik:RadTextBox>
                                </td>
                                <td>
                                    <telerik:RadLabel ID="RadLabelCreatedBy" runat="server" AssociatedControlID="RadTextBoxCreatedBy">
                                        Created By
                                    </telerik:RadLabel>
                                    <telerik:RadTextBox ID="RadTextBoxCreatedBy" Runat="server" LabelWidth="64px" Resize="None" Text="" Width="100%" ReadOnly="true">
                                    </telerik:RadTextBox>                    
                                </td>
                                <td>
                    
                                </td>
                                <td>
                    
                                </td>
                                <td>
                    
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <telerik:RadLabel ID="RadLabelCompany" runat="server" AssociatedControlID="RadTextBoxCompany">
                                        Company
                                    </telerik:RadLabel>
                                    <telerik:RadTextBox ID="RadTextBoxCompany" Runat="server" LabelWidth="64px" Resize="None" Text="" Width="100%" ReadOnly="true">
                                    </telerik:RadTextBox>
                                </td>
                                <td>
                                    <telerik:RadLabel ID="RadLabelCOA" runat="server" AssociatedControlID="RadTextBoxCOA">
                                        COA
                                    </telerik:RadLabel>
                                    <telerik:RadComboBox runat="server" ID="RadComboBoxCOACode"  EnableLoadOnDemand="true" DataSourceID="SqlDataSourceCOACode" DataTextField="Description" DataValueField="COACode" AutoPostBack="true" OnSelectedIndexChanged="RadComboBoxCOACode_SelectedIndexChanged"></telerik:RadComboBox>
                                        <asp:SqlDataSource ID="SqlDataSourceCOACode" runat="server" ConnectionString="<%$ ConnectionStrings:EpicorConnectionString %>" SelectCommand="select [COACode],[Description] from erp.COA where Company=@Company union select '','' Order by [Description]">
                                            <SelectParameters>
                                                <asp:SessionParameter Name="Company" SessionField="Company" DefaultValue="" Type="String"/>
                                            </SelectParameters>
                                        </asp:SqlDataSource>   
                                </td>
                                <td>
                                    <telerik:RadLabel ID="RadLabelBook" runat="server" AssociatedControlID="RadTextBoxBook">
                                        Book
                                    </telerik:RadLabel>
                                    <telerik:RadComboBox runat="server" ID="RadComboBoxBookID"  EnableLoadOnDemand="true" DataSourceID="SqlDataSourceBookID" DataTextField="Description" DataValueField="BookID" AutoPostBack="true"></telerik:RadComboBox>
                                        <asp:SqlDataSource ID="SqlDataSourceBookID" runat="server" ConnectionString="<%$ ConnectionStrings:EpicorConnectionString %>" SelectCommand="select [BookID],[Description] from erp.GLBook A where Company=@Company union select '','' Order by [Description]">
                                            <SelectParameters>
                                                <asp:SessionParameter Name="Company" SessionField="Company" DefaultValue="" Type="String"/>
                                            </SelectParameters>
                                        </asp:SqlDataSource>
                                </td>
                                <td>
                                    <telerik:RadLabel ID="RadLabelFiscalYear" runat="server" AssociatedControlID="RadTextBoxFiscalYear">
                                        Fiscal Year
                                    </telerik:RadLabel>
                                    <telerik:RadComboBox runat="server" ID="RadComboBoxFiscalYear"  EnableLoadOnDemand="true" DataSourceID="SqlDataSourceFiscalYear" DataTextField="FiscalYear" DataValueField="FiscalYear" AutoPostBack="true"></telerik:RadComboBox>
                                        <asp:SqlDataSource ID="SqlDataSourceFiscalYear" runat="server" ConnectionString="<%$ ConnectionStrings:EpicorConnectionString %>" SelectCommand="select distinct FiscalYear from erp.FiscalYr A where Company=@Company union select 0 Order by [FiscalYear]">
                                            <SelectParameters>
                                                <asp:SessionParameter Name="Company" SessionField="Company" DefaultValue="" Type="String"/>
                                            </SelectParameters>
                                        </asp:SqlDataSource> 
                                </td>
                                <td>
                                    <telerik:RadLabel ID="RadLabelBudgetCode" runat="server" AssociatedControlID="RadComboBoxBudgetCode">
                                        Budget Code
                                    </telerik:RadLabel>
                                    <telerik:RadComboBox runat="server" ID="RadComboBoxBudgetCode"  EnableLoadOnDemand="true" DataSourceID="SqlDataSourceBudgetCode" DataTextField="BudgetCodeDesc" DataValueField="BudgetCodeID" AutoPostBack="true"></telerik:RadComboBox>
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
        </Rows>
        <Rows>
            <telerik:LayoutRow Height="100">
                <Columns>
                    <telerik:LayoutColumn Span="10" SpanMd="12" SpanSm="12" SpanXs="12">
                        <telerik:RadLabel ID="RadLabelUploadDtl" runat="server" AssociatedControlID="RadAsyncUploadDtl">Upload details from Excel</telerik:RadLabel>
                        <telerik:RadAsyncUpload ID="RadAsyncUploadDtl" runat="server" OnFileUploaded="RadAsyncUploadDtl_FileUploaded" Visible="true" Skin="Web20"></telerik:RadAsyncUpload>                     
                    </telerik:LayoutColumn>
                </Columns>
            </telerik:LayoutRow>
        </Rows>
        <Rows>
            <telerik:LayoutRow>
                <Columns>
                    <telerik:LayoutColumn Span="10" SpanMd="12" SpanSm="12" SpanXs="12">

                        <telerik:RadButton ID="RadButtonNew" runat="server" Text="New Template#" Skin="Web20" OnClick="RadButtonNew_Click">
                        </telerik:RadButton>
                        <telerik:RadButton ID="RadButtonSave" runat="server" Text="Save Template#" Skin="Web20" OnClick="RadButtonSave_Click">
                        </telerik:RadButton>
                        <telerik:RadButton ID="RadButtonCopy" runat="server" Text="Copy" Skin="Web20" Visible="false">
                        </telerik:RadButton>
                        <telerik:RadButton ID="RadButtonDownload" runat="server" Text="Download" Skin="Web20" AutoPostBack="true" OnClick="RadButtonDownload_Click">
                        </telerik:RadButton>
						
                        <telerik:RadButton ID="RadButtonUpload" runat="server" Text="Upload" Skin="Web20" OnClick="RadButtonUpload_Click">
                        </telerik:RadButton>						

                        <telerik:RadButton ID="RadButtonDelete" runat="server" Text="Delete" Skin="Web20" OnClick="RadButtonDelete_Click" OnClientClicking="function (sender, args){args.set_cancel(!window.confirm('Are you sure delete?'));}">
                                </telerik:RadButton>
                                                
                    </telerik:LayoutColumn>
                </Columns>
            </telerik:LayoutRow>
        </Rows>
        <Rows>
            <telerik:LayoutRow>
                <Columns>
                    <telerik:LayoutColumn Span="10" SpanMd="12" SpanSm="12" SpanXs="12">


                    </telerik:LayoutColumn>
                </Columns>
            </telerik:LayoutRow>
        </Rows>
    </telerik:RadPageLayout>

    <div>
        <telerik:RadGrid ID="RadGridDtl" runat="server" AllowFilteringByColumn="True" AllowPaging="false" AllowSorting="True" DataSourceID="SqlDataSourceDtl" ShowGroupPanel="True" Skin="Web20" Height="600px" PageSize="6" AllowAutomaticDeletes="True" AllowAutomaticInserts="True" AllowAutomaticUpdates="True" AutoGenerateDeleteColumn="true" ClientSettings-Scrolling-FrozenColumnsCount="3" ShowFooter="True">
            <GroupingSettings CollapseAllTooltip="Collapse all groups"></GroupingSettings>
            <ClientSettings AllowDragToGroup="false">
                <Scrolling AllowScroll="True" UseStaticHeaders="True" />
                <ClientEvents OnBatchEditOpened="OnBatchEditOpened" />
                <ClientEvents OnBatchEditCellValueChanged="OnBatchEditCellValueChanged" />
            </ClientSettings>
            <MasterTableView CommandItemDisplay="TopAndBottom" InsertItemDisplay="Bottom" AutoGenerateColumns="False" DataKeyNames="Company,TemplateNum,Line" DataSourceID="SqlDataSourceDtl" EditMode="Batch" >
            <BatchEditingSettings EditType="Row" HighlightDeletedRows="true"/>
                <Columns>
                        
                                    
                    <telerik:GridBoundColumn DataField="Line" HeaderStyle-Width="100" FilterControlWidth="50" DataType="System.Int32" FilterControlAltText="Filter Line column" HeaderText="Line" ReadOnly="False" SortExpression="Line" UniqueName="Line">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="Budget_Item" HeaderStyle-Width="200" FilterControlWidth="100" FilterControlAltText="Filter Budget_Item column" HeaderText="Budget_Item" SortExpression="Budget_Item" UniqueName="Budget_Item" DataFormatString="{0:@}">
                    </telerik:GridBoundColumn>

                    <telerik:GridBoundColumn DataField="GLAccount" HeaderStyle-Width="200"  HeaderText="GLAccount" UniqueName="GLAccountForExport"  DataFormatString="{0:@}" Display="false">
                    </telerik:GridBoundColumn>

                    <telerik:GridTemplateColumn HeaderText="GLAccount" HeaderStyle-Width="200" FilterControlWidth="100" UniqueName="GLAccount" DataField="GLAccount">
                        <ItemTemplate>
                            <%# Eval("GLAccount") %>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <telerik:RadTextBox ID="RadTextLineGLAccount" runat="server" Text='<%# Eval("GLAccount") %>'></telerik:RadTextBox>
                            <asp:Button ID="PopUpSearchGLAccount" runat="server" Text="Search" OnClientClick="openWinSearchGLA(); return false;"/>
                        </EditItemTemplate>
                    </telerik:GridTemplateColumn>

                    <telerik:GridBoundColumn DataField="AccountDesc" HeaderStyle-Width="150" FilterControlWidth="100" FilterControlAltText="Filter AccountDesc column" HeaderText="AccountDesc" SortExpression="AccountDesc" UniqueName="AccountDesc" DataFormatString="{0:@}">
                    </telerik:GridBoundColumn>

                    <telerik:GridTemplateColumn HeaderText="SegValue1" HeaderStyle-Width="150" FilterControlWidth="100" UniqueName="SegValue1" DataField="SegValue1">
                        <ItemTemplate>
                            <%# Eval("SegValue1") %>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <telerik:RadTextBox ID="RadTextLineSegValue1" runat="server" Text='<%# Eval("SegValue1") %>'></telerik:RadTextBox>
                            <asp:Button ID="PopUpSearchSegValue1" runat="server" Text="Search" OnClientClick="openWinSearchSegValue('1'); return false;"/>
                        </EditItemTemplate>
                    </telerik:GridTemplateColumn>	
                    <telerik:GridTemplateColumn HeaderText="SegValue2" HeaderStyle-Width="150" FilterControlWidth="100" UniqueName="SegValue2" DataField="SegValue2">
                        <ItemTemplate>
                            <%# Eval("SegValue2") %>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <telerik:RadTextBox ID="RadTextLineSegValue2" runat="server" Text='<%# Eval("SegValue2") %>'></telerik:RadTextBox>
                            <asp:Button ID="PopUpSearchSegValue2" runat="server" Text="Search" OnClientClick="openWinSearchSegValue('2'); return false;"/>
                        </EditItemTemplate>
                    </telerik:GridTemplateColumn>							
                    <telerik:GridTemplateColumn HeaderText="SegValue3" HeaderStyle-Width="150" FilterControlWidth="100" UniqueName="SegValue3" DataField="SegValue3">
                        <ItemTemplate>
                            <%# Eval("SegValue3") %>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <telerik:RadTextBox ID="RadTextLineSegValue3" runat="server" Text='<%# Eval("SegValue3") %>'></telerik:RadTextBox>
                            <asp:Button ID="PopUpSearchSegValue3" runat="server" Text="Search" OnClientClick="openWinSearchSegValue('3'); return false;"/>
                        </EditItemTemplate>
                    </telerik:GridTemplateColumn>	
                    <telerik:GridTemplateColumn HeaderText="SegValue4" HeaderStyle-Width="150" FilterControlWidth="100" UniqueName="SegValue4" DataField="SegValue4" Display="false">
                        <ItemTemplate>
                            <%# Eval("SegValue4") %>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <telerik:RadTextBox ID="RadTextLineSegValue4" runat="server" Text='<%# Eval("SegValue4") %>'></telerik:RadTextBox>
                            <asp:Button ID="PopUpSearchSegValue4" runat="server" Text="Search" OnClientClick="openWinSearchSegValue('4'); return false;"/>
                        </EditItemTemplate>
                    </telerik:GridTemplateColumn>	
                    <telerik:GridTemplateColumn HeaderText="SegValue5" HeaderStyle-Width="150" FilterControlWidth="100" UniqueName="SegValue5" DataField="SegValue5" Display="false">
                        <ItemTemplate>
                            <%# Eval("SegValue5") %>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <telerik:RadTextBox ID="RadTextLineSegValue5" runat="server" Text='<%# Eval("SegValue5") %>'></telerik:RadTextBox>
                            <asp:Button ID="PopUpSearchSegValue5" runat="server" Text="Search" OnClientClick="openWinSearchSegValue('5'); return false;"/>
                        </EditItemTemplate>
                    </telerik:GridTemplateColumn>	
                    <telerik:GridTemplateColumn HeaderText="SegValue6" HeaderStyle-Width="150" FilterControlWidth="100" UniqueName="SegValue6" DataField="SegValue6" Display="false">
                        <ItemTemplate>
                            <%# Eval("SegValue6") %>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <telerik:RadTextBox ID="RadTextLineSegValue6" runat="server" Text='<%# Eval("SegValue6") %>'></telerik:RadTextBox>
                            <asp:Button ID="PopUpSearchSegValue6" runat="server" Text="Search" OnClientClick="openWinSearchSegValue('6'); return false;"/>
                        </EditItemTemplate>
                    </telerik:GridTemplateColumn>	
                    <telerik:GridTemplateColumn HeaderText="SegValue7" HeaderStyle-Width="150" FilterControlWidth="100" UniqueName="SegValue7" DataField="SegValue7" Display="false">
                        <ItemTemplate>
                            <%# Eval("SegValue7") %>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <telerik:RadTextBox ID="RadTextLineSegValue7" runat="server" Text='<%# Eval("SegValue7") %>'></telerik:RadTextBox>
                            <asp:Button ID="PopUpSearchSegValue7" runat="server" Text="Search" OnClientClick="openWinSearchSegValue('7'); return false;"/>
                        </EditItemTemplate>
                    </telerik:GridTemplateColumn>	
                    <telerik:GridTemplateColumn HeaderText="SegValue8" HeaderStyle-Width="150" FilterControlWidth="100" UniqueName="SegValue8" DataField="SegValue8" Display="false">
                        <ItemTemplate>
                            <%# Eval("SegValue8") %>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <telerik:RadTextBox ID="RadTextLineSegValue8" runat="server" Text='<%# Eval("SegValue8") %>'></telerik:RadTextBox>
                            <asp:Button ID="PopUpSearchSegValue8" runat="server" Text="Search" OnClientClick="openWinSearchSegValue('8'); return false;"/>
                        </EditItemTemplate>
                    </telerik:GridTemplateColumn>	
                    <telerik:GridTemplateColumn HeaderText="SegValue9" HeaderStyle-Width="150" FilterControlWidth="100" UniqueName="SegValue9" DataField="SegValue9" Display="false">
                        <ItemTemplate>
                            <%# Eval("SegValue9") %>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <telerik:RadTextBox ID="RadTextLineSegValue9" runat="server" Text='<%# Eval("SegValue9") %>'></telerik:RadTextBox>
                            <asp:Button ID="PopUpSearchSegValue9" runat="server" Text="Search" OnClientClick="openWinSearchSegValue('9'); return false;"/>
                        </EditItemTemplate>
                    </telerik:GridTemplateColumn>
                    <telerik:GridTemplateColumn HeaderText="SegValue10" HeaderStyle-Width="150" FilterControlWidth="100" UniqueName="SegValue10" DataField="SegValue10" Display="false">
                        <ItemTemplate>
                            <%# Eval("SegValue10") %>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <telerik:RadTextBox ID="RadTextLineSegValue10" runat="server" Text='<%# Eval("SegValue10") %>'></telerik:RadTextBox>
                            <asp:Button ID="PopUpSearchSegValue10" runat="server" Text="Search" OnClientClick="openWinSearchSegValue('10'); return false;"/>
                        </EditItemTemplate>
                    </telerik:GridTemplateColumn>

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

                    <telerik:GridBoundColumn DataField="Company" FilterControlAltText="Filter Company column" HeaderText="Company" SortExpression="Company" UniqueName="Company" ReadOnly="false"  Display="false">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="TemplateNum" FilterControlAltText="Filter TemplateNum column" HeaderText="TemplateNum" SortExpression="TemplateNum" UniqueName="TemplateNum" ReadOnly="false"  Display="false">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="SysRowID" DataType="System.Guid" FilterControlAltText="Filter SysRowID column" HeaderText="SysRowID" SortExpression="SysRowID" UniqueName="SysRowID" Visible="false">
                    </telerik:GridBoundColumn>
                        
                </Columns>
            </MasterTableView>
        </telerik:RadGrid>
        <asp:SqlDataSource ID="SqlDataSourceDtl" runat="server" ConnectionString="<%$ ConnectionStrings:BudgetPlanConnectionString %>" 
            SelectCommand="SELECT * FROM [BudgetTemplateDtl] WHERE [Company]=@Company AND [TemplateNum]=@TemplateNum ORDER BY [TemplateNum], [Line]"
            InsertCommand="INSERT INTO [BudgetTemplateDtl] ([Company], [TemplateNum], [Line], [Budget_Item], [Period_1], [Period_2], [Period_3], [Period_4], [Period_5], [Period_6], [Period_7], [Period_8], [Period_9], [Period_10], [Period_11], [Period_12], [GLAccount], [AccountDesc], [SegValue1], [SegValue2], [SegValue3], [SegValue4], [SegValue5], [SegValue6], [SegValue7], [SegValue8], [SegValue9], [SegValue10]) VALUES (@Company, @TemplateNum, @Line, @Budget_Item, isnull(@Period_1,0), isnull(@Period_2,0), isnull(@Period_3,0), isnull(@Period_4,0), isnull(@Period_5,0), isnull(@Period_6,0), isnull(@Period_7,0), isnull(@Period_8,0), isnull(@Period_9,0), isnull(@Period_10,0), isnull(@Period_11,0), isnull(@Period_12,0), @GLAccount, @AccountDesc, @SegValue1, @SegValue2, @SegValue3, @SegValue4, @SegValue5, @SegValue6, @SegValue7, @SegValue8, @SegValue9, @SegValue10)"
            DeleteCommand="DELETE FROM [BudgetTemplateDtl] WHERE [Company] = @Company AND [TemplateNum] = @TemplateNum AND [Line] = @Line"
            UpdateCommand="UPDATE [BudgetTemplateDtl] SET [Budget_Item] = @Budget_Item, [Period_1] = @Period_1, [Period_2] = @Period_2, [Period_3] = @Period_3, [Period_4] = @Period_4, [Period_5] = @Period_5, [Period_6] = @Period_6, [Period_7] = @Period_7, [Period_8] = @Period_8, [Period_9] = @Period_9, [Period_10] = @Period_10, [Period_11] = @Period_11, [Period_12] = @Period_12, [GLAccount] = @GLAccount, [AccountDesc] = @AccountDesc, [SegValue1] = @SegValue1, [SegValue2] = @SegValue2, [SegValue3] = @SegValue3, [SegValue4] = @SegValue4, [SegValue5] = @SegValue5, [SegValue6] = @SegValue6, [SegValue7] = @SegValue7, [SegValue8] = @SegValue8, [SegValue9] = @SegValue9, [SegValue10] = @SegValue10 WHERE [Company] = @Company AND [TemplateNum] = @TemplateNum AND [Line] = @Line"
            >
            <InsertParameters>
                <asp:Parameter Name="Company" Type="String"></asp:Parameter>
                <asp:Parameter Name="TemplateNum" Type="String"></asp:Parameter>
                <asp:Parameter Name="Line" Type="Int32"></asp:Parameter>
            </InsertParameters>
            <DeleteParameters>
                <asp:Parameter Name="Company" Type="String"></asp:Parameter>
                <asp:Parameter Name="TemplateNum" Type="String"></asp:Parameter>
                <asp:Parameter Name="Line" Type="Int32"></asp:Parameter>
            </DeleteParameters>
            <UpdateParameters>
                <asp:Parameter Name="Company" Type="String"></asp:Parameter>
                <asp:Parameter Name="TemplateNum" Type="String"></asp:Parameter>
                <asp:Parameter Name="Line" Type="Int32"></asp:Parameter>               
            </UpdateParameters>
            <SelectParameters>
                <asp:SessionParameter Name="Company" SessionField="Company" DefaultValue="" Type="String"/>
                <asp:SessionParameter Name="TemplateNum" SessionField="TemplateNum" DefaultValue="" Type="String">
                </asp:SessionParameter>
            </SelectParameters>
        </asp:SqlDataSource>

    </div>
    <h6><telerik:RadTextBox ID="RadTextBoxCurrentCompany" runat="server" Label="CompanyID:" ReadOnly="true" Display="false"></telerik:RadTextBox><telerik:RadTextBox ID="RadTextBoxCurrentCompanyName" runat="server" Label="Company:" ReadOnly="true" ></telerik:RadTextBox><telerik:RadTextBox ID="RadTextBoxUserID" runat="server" Label="UserID:" ReadOnly="true" ></telerik:RadTextBox></h6>
                  

</asp:Content>
