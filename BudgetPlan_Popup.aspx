<%@ Page Language="C#" MasterPageFile="~/MasterPageSingleMenu.Master" AutoEventWireup="true" CodeBehind="BudgetPlan_Popup.aspx.cs" Inherits="BudgetPlan.BudgetPlan_Popup" %>
<%@ Register TagPrefix="telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>

<asp:Content ID="Content0" ContentPlaceHolderID="head" Runat="Server">
    <link href="styles/default.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <telerik:RadCodeBlock ID="RadCodeBlock1" runat="server">
    <script src="scripts/jquery-1.7.1.min.js"></script>
    <script type="text/javascript">
        //Put your JavaScript code here.
        function OnBatchEditOpened(sender, args) {
            args.get_tableView().get_dataItems();
            var item = args.get_row().control;
            if (item.get_itemIndex() < 0) { // new row
                // execute custom logic

                var batchEditingManager = sender.get_batchEditingManager(); //get the batch editing manager

                if (batchEditingManager.getCellValue(item.get_cell("Company")) == "") {
                    sender.remove_batchEditOpened(OnBatchEditOpened);//avoid recursion

                    //use the batch edit manager API ot change cell values
                    var CompanyValue = $find("<%= RadTextBoxCompany.ClientID %>").get_value();
                    batchEditingManager.changeCellValue(item.get_cell("Company"), CompanyValue);

                    var EntryNumValue = $find("<%= RadTextBoxEntryNum.ClientID %>").get_value();
                    batchEditingManager.changeCellValue(item.get_cell("EntryNum"), EntryNumValue);   

                    var RevisionValue = $find("<%= RadTextBoxRevision.ClientID %>").get_value();
                    batchEditingManager.changeCellValue(item.get_cell("Revision"), RevisionValue);  

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
                        url: "BudgetPlan.aspx/AjaxMethod_GetPreloadAccountDesc",//发送到本页面后台AjaxMethod方法
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




        function openWin(skinName) {
            var oWnd = radopen("DialogSearchGLAccount.aspx", "RadWindow1");
        }

        function OnClientClose(oWnd, args) {
            //get the transferred arguments
            var arg = args.get_argument();
            if (arg) {
                var GLAccount = arg.GLAccount;
                var seldate = arg.selDate;
                $get("order").innerHTML = "You chose to fly to <strong>" + GLAccount + "</strong> on <strong>" + seldate + "</strong>";

                
                var btGL = $find('<%= RadTextBoxBudgetTitle.ClientID %>');
                btGL.set_value('Test');

                var grid = $find("<%=RadGridDtl.ClientID %>");
                var MasterTable = grid.get_masterTableView();
                var selectedRows = MasterTable.get_selectedItems();
                for (var i = 0; i < selectedRows.length; i++) {
                    var row = selectedRows[i];
                    var cell = MasterTable.getCellByColumnUniqueName(row, "GLAccount")

                    //GLAccount = cell.innerText.replace(' ', '');

                    var batchManager = grd.get_batchEditingManager();
                    batchManager.changeCellValue(cell, GLAccount);

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
                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxEntryNum"/> 
                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxRevision"/> 
                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxPreparedBy"/> 
                    <telerik:AjaxUpdatedControl ControlID="RadDatePickerSubmissionDueDate"/>
                    <telerik:AjaxUpdatedControl ControlID="RadComboBoxAssignTo"/>
                    <telerik:AjaxUpdatedControl ControlID="RadComboBoxCOACode"/> 
                    <telerik:AjaxUpdatedControl ControlID="RadComboBoxBookID"/> 
                    <telerik:AjaxUpdatedControl ControlID="RadComboBoxFiscalYear"/> 
                    <telerik:AjaxUpdatedControl ControlID="RadComboBoxBudgetCode"/> 
                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxBudgetTitle"/> 
 
                    <telerik:AjaxUpdatedControl ControlID="RadGridDtl"/>
                    
                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxStatus"/> 
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="RadButtonSearchTemplate">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGridSearchTemplate"/>
                    <telerik:AjaxUpdatedControl ControlID="RadLabelMsg"/>
                    <telerik:AjaxUpdatedControl ControlID="RadLabelErrorMsg" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="RadGridSearchTemplate">
                <UpdatedControls>                        
                    <telerik:AjaxUpdatedControl ControlID="RadGridSearchTemplate"/>                                               
                    <telerik:AjaxUpdatedControl ControlID="RadLabelMsg"/>
                    <telerik:AjaxUpdatedControl ControlID="RadLabelErrorMsg" />

                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxCompany"/> 
                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxEntryNum"/> 
                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxRevision"/> 
                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxPreparedBy"/> 
                    <telerik:AjaxUpdatedControl ControlID="RadDatePickerSubmissionDueDate"/>
                    <telerik:AjaxUpdatedControl ControlID="RadComboBoxAssignTo"/>
                    <telerik:AjaxUpdatedControl ControlID="RadComboBoxCOACode"/> 
                    <telerik:AjaxUpdatedControl ControlID="RadComboBoxBookID"/> 
                    <telerik:AjaxUpdatedControl ControlID="RadComboBoxFiscalYear"/> 
                    <telerik:AjaxUpdatedControl ControlID="RadComboBoxBudgetCode"/> 
                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxBudgetTitle"/> 
 
                    <telerik:AjaxUpdatedControl ControlID="RadGridDtl"/>
                    
                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxStatus"/> 
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="RadButtonNew">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadLabelMsg"/>
                    <telerik:AjaxUpdatedControl ControlID="RadLabelErrorMsg" />

                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxCompany"/>
                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxEntryNum"/>
                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxRevision" />
                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxPreparedBy" />
                    <telerik:AjaxUpdatedControl ControlID="RadDatePickerSubmissionDueDate"/>
                    <telerik:AjaxUpdatedControl ControlID="RadComboBoxAssignTo"/>
                    <telerik:AjaxUpdatedControl ControlID="RadComboBoxCOACode" />
                    <telerik:AjaxUpdatedControl ControlID="RadComboBoxBookID" />
                    <telerik:AjaxUpdatedControl ControlID="RadComboBoxFiscalYear" />
                    <telerik:AjaxUpdatedControl ControlID="RadComboBoxBudgetCode" />
                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxBudgetTitle" />
                    <telerik:AjaxUpdatedControl ControlID="RadGridDtl" />
                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxStatus"/> 
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="RadButtonCopy">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadLabelMsg"/>
                    <telerik:AjaxUpdatedControl ControlID="RadLabelErrorMsg" />

                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxCompany"/>
                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxEntryNum"/>
                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxRevision" />
                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxPreparedBy" />
                    <telerik:AjaxUpdatedControl ControlID="RadDatePickerSubmissionDueDate"/>
                    <telerik:AjaxUpdatedControl ControlID="RadComboBoxAssignTo"/>
                    <telerik:AjaxUpdatedControl ControlID="RadComboBoxCOACode" />
                    <telerik:AjaxUpdatedControl ControlID="RadComboBoxBookID" />
                    <telerik:AjaxUpdatedControl ControlID="RadComboBoxFiscalYear" />
                    <telerik:AjaxUpdatedControl ControlID="RadComboBoxBudgetCode" />
                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxBudgetTitle" />
                    <telerik:AjaxUpdatedControl ControlID="RadGridDtl" />
                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxStatus"/> 
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="RadButtonSave">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadLabelMsg"/>
                    <telerik:AjaxUpdatedControl ControlID="RadLabelErrorMsg" />

                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxEntryNum"/>
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="RadButtonConfirmAssign">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadLabelMsg"/>
                    <telerik:AjaxUpdatedControl ControlID="RadLabelErrorMsg" />
                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxStatus"/> 
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="RadButtonVoid">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadLabelMsg"/>
                    <telerik:AjaxUpdatedControl ControlID="RadLabelErrorMsg" />

                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxCompany"/>
                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxEntryNum"/>
                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxRevision" />
                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxPreparedBy" />
                    <telerik:AjaxUpdatedControl ControlID="RadDatePickerSubmissionDueDate"/>
                    <telerik:AjaxUpdatedControl ControlID="RadComboBoxAssignTo"/>
                    <telerik:AjaxUpdatedControl ControlID="RadComboBoxCOACode" />
                    <telerik:AjaxUpdatedControl ControlID="RadComboBoxBookID" />
                    <telerik:AjaxUpdatedControl ControlID="RadComboBoxFiscalYear" />
                    <telerik:AjaxUpdatedControl ControlID="RadComboBoxBudgetCode" />
                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxBudgetTitle" />
                    <telerik:AjaxUpdatedControl ControlID="RadGridDtl" />
                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxStatus"/>

                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="RadButtonDelete">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadLabelMsg"/>
                    <telerik:AjaxUpdatedControl ControlID="RadLabelErrorMsg" />

                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxCompany"/>
                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxEntryNum"/>
                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxRevision" />
                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxPreparedBy" />
                    <telerik:AjaxUpdatedControl ControlID="RadDatePickerSubmissionDueDate"/>
                    <telerik:AjaxUpdatedControl ControlID="RadComboBoxAssignTo"/>
                    <telerik:AjaxUpdatedControl ControlID="RadComboBoxCOACode" />
                    <telerik:AjaxUpdatedControl ControlID="RadComboBoxBookID" />
                    <telerik:AjaxUpdatedControl ControlID="RadComboBoxFiscalYear" />
                    <telerik:AjaxUpdatedControl ControlID="RadComboBoxBudgetCode" />
                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxBudgetTitle" />
                    <telerik:AjaxUpdatedControl ControlID="RadGridDtl" />
                    <telerik:AjaxUpdatedControl ControlID="RadTextBoxStatus"/> 
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="RadComboBoxCOACode">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGridDtl"/>
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
                            <telerik:RadGrid ID="RadGridSearch" runat="server" Visible="false" AllowFilteringByColumn="True" AllowPaging="True" AllowSorting="True" DataSourceID="SqlDataSourceSearchPlanHed" OnItemCommand="RadGridSearch_ItemCommand">
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

                            <asp:SqlDataSource ID="SqlDataSourceSearchPlanHed" runat="server" ConnectionString="<%$ ConnectionStrings:BudgetPlanConnectionString %>" SelectCommand="SELECT * FROM [BudgetPlanHed] WHERE [Company]=@Company and [PreparedBy]=@PreparedBy and InactiveRevision=0 ORDER BY [Company], [EntryNum], [Revision]">
                                <SelectParameters>
                                    <asp:SessionParameter Name="Company" SessionField="Company" DefaultValue="" Type="String"/>
                                    <asp:SessionParameter Name="PreparedBy" SessionField="PreparedBy" DefaultValue="" Type="String"/>
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
                                    <telerik:RadTextBox ID="RadTextBoxEntryNum" Runat="server" LabelWidth="64px" Resize="None" Text="" Width="100%">
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
                                    <telerik:RadLabel ID="RadLabelSubmissionDueDate" runat="server" AssociatedControlID="RadTextBoxSubmissionDueDate">
                                        Submission Due Date
                                    </telerik:RadLabel>
                                    <telerik:RadDatePicker ID="RadDatePickerSubmissionDueDate" runat="server" Resize="None" Text="" Width="100%"></telerik:RadDatePicker>
                                </td>
                                <td>
                                    <telerik:RadLabel ID="RadLabelAssignTo" runat="server" AssociatedControlID="RadComboBoxAssignTo">
                                        Assign To
                                    </telerik:RadLabel>
                                    <telerik:RadComboBox runat="server" ID="RadComboBoxAssignTo"  EnableLoadOnDemand="true" DataSourceID="SqlDataSourceAssignTo" DataTextField="Name" DataValueField="UserID" AutoPostBack="true"></telerik:RadComboBox>
                                        <asp:SqlDataSource ID="SqlDataSourceAssignTo" runat="server" ConnectionString="<%$ ConnectionStrings:BudgetPlanConnectionString %>" SelectCommand="select [UserID],[Name] from UserFile union select '','' Order by [Name]">
                                        </asp:SqlDataSource>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <telerik:RadLabel ID="RadLabelCompany" runat="server" AssociatedControlID="RadTextBoxCompany">
                                        Company
                                    </telerik:RadLabel>
                                    <telerik:RadTextBox ID="RadTextBoxCompany" Runat="server" LabelWidth="64px" Resize="None" Text="" ReadOnly="true" Width="100%">
                                    </telerik:RadTextBox>
                                </td>
                                <td>
                                    <telerik:RadLabel ID="RadLabelCOACode" runat="server" AssociatedControlID="RadComboBoxCOACode">
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
                                    <telerik:RadLabel ID="RadLabelBookID" runat="server" AssociatedControlID="RadComboBoxBookID">
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
                                    <telerik:RadLabel ID="RadLabelFiscalYear" runat="server" AssociatedControlID="RadComboBoxFiscalYear">
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
                                    <telerik:RadLabel ID="RadLabelBudgetCode" runat="server" AssociatedControlID="RadTextBoxBudgetCode">
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
            <telerik:LayoutRow>
                <Columns>
                    <telerik:LayoutColumn Span="10" SpanMd="12" SpanSm="12" SpanXs="12">
                        <div>
                            <telerik:RadLabel ID="RadLabelBudgetTitle" runat="server" AssociatedControlID="RadTextBoxBudgetTitle">
                                Budget Title
                            </telerik:RadLabel>
                            <telerik:RadTextBox ID="RadTextBoxBudgetTitle" Runat="server" Resize="None" Text="" Width="100%" Font-Bold="True">
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
                            <telerik:RadButton ID="RadButtonDelete" runat="server" Text="Delete" Skin="Web20" OnClick="RadButtonDelete_Click">
                            </telerik:RadButton>
                            <telerik:RadButton ID="RadButtonVoid" runat="server" Text="Void" Skin="Web20" OnClick="RadButtonVoid_Click">
                            </telerik:RadButton>
                            <telerik:RadButton ID="RadButtonConfirmAssign" runat="server" Text="Confirm & Assign" Skin="Telerik" OnClick="RadButtonConfirmAssign_Click">
                            </telerik:RadButton>
                            <telerik:RadButton ID="RadButtonUpload" runat="server" Text="Upload" Skin="Web20">
                            </telerik:RadButton>
                            <telerik:RadButton ID="RadButtonDownload" runat="server" Text="Download" Skin="Web20" AutoPostBack="true" OnClick="RadButtonDownload_Click">
                            </telerik:RadButton>
                            <telerik:RadButton ID="RadButtonCopy" runat="server" Text="Copy" Skin="Web20" OnClick="RadButtonCopy_Click">
                            </telerik:RadButton>
                            <telerik:RadButton ID="RadButtonSearchTemplate" runat="server" Text="Copy by Template" Skin="Web20" OnClick="RadButtonSearchTemplate_Click">
                            </telerik:RadButton>
                            <telerik:RadButton ID="RadButtonSave" runat="server" Text="Save Entry#" Skin="Web20" OnClick="RadButtonSave_Click">
                            </telerik:RadButton>
                            <telerik:RadButton ID="RadButtonNew" runat="server" Text="New Entry#" Skin="Web20" OnClick="RadButtonNew_Click">
                            </telerik:RadButton>
                        </div>                        
                    </telerik:LayoutColumn>
                </Columns>
            </telerik:LayoutRow>
            <telerik:LayoutRow>
                <Columns>
                    <telerik:LayoutColumn Span="10" SpanMd="12" SpanSm="12" SpanXs="12">
                    <div>
                            <telerik:RadGrid ID="RadGridSearchTemplate" runat="server" Visible="false" AllowFilteringByColumn="True" AllowPaging="True" AllowSorting="True" DataSourceID="SqlDataSourceSearchTemplateHed" OnItemCommand="RadGridSearchTemplate_ItemCommand">
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
                                </SelectParameters>
                            </asp:SqlDataSource>

                    </div>                        
                    </telerik:LayoutColumn>
                </Columns>
            </telerik:LayoutRow>

            <telerik:LayoutRow>
                <Columns>
                    <telerik:LayoutColumn Span="10" SpanMd="12" SpanSm="12" SpanXs="12">

                    <div>

                        <telerik:RadGrid ID="RadGridDtl" runat="server" AllowFilteringByColumn="True" AllowPaging="false" AllowSorting="True" DataSourceID="SqlDataSourceDtl" ShowGroupPanel="True" Skin="Web20" Height="600px" PageSize="6" AllowAutomaticDeletes="True" AllowAutomaticInserts="True" AllowAutomaticUpdates="True" AutoGenerateDeleteColumn="true" OnItemDataBound="RadGridDtl_ItemDataBound">
                            <GroupingSettings CollapseAllTooltip="Collapse all groups"></GroupingSettings>
                            <ClientSettings AllowDragToGroup="false">
                                <Scrolling AllowScroll="True" UseStaticHeaders="True" />
                                <ClientEvents OnBatchEditOpened="OnBatchEditOpened" />
                                <ClientEvents OnBatchEditCellValueChanged="OnBatchEditCellValueChanged" />
                            </ClientSettings>
                            <MasterTableView CommandItemDisplay="TopAndBottom" InsertItemDisplay="Bottom" AutoGenerateColumns="False" DataKeyNames="Company,EntryNum,Revision,Line" DataSourceID="SqlDataSourceDtl" EditMode="Batch">
                            <BatchEditingSettings EditType="Row" HighlightDeletedRows="true"/>
                            <CommandItemSettings ShowAddNewRecordButton="true"/>
                                <Columns>
                        
                                    <telerik:GridBoundColumn DataField="Line" DataType="System.Int32" FilterControlAltText="Filter Line column" HeaderText="Line" ReadOnly="False" SortExpression="Line" UniqueName="Line" >
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="Budget_Item" FilterControlAltText="Filter Budget_Item column" HeaderText="Budget_Item" SortExpression="Budget_Item" UniqueName="Budget_Item">
                                    </telerik:GridBoundColumn>

                                    <telerik:GridTemplateColumn HeaderText="GLAccount" UniqueName="GLAccount" DataField="GLAccount">
                                        <ItemTemplate>
                                            <%# Eval("GLAccount") %>
                                        </ItemTemplate>
                                        <EditItemTemplate> 
                                            <telerik:RadTextBox ID="RadTextLineGLAccount" runat="server" ></telerik:RadTextBox>
                                            <asp:Button ID="PopUpSearchGLAccount" runat="server" Text="Search" OnClientClick="openWin('xxx'); return false;"/> 
                                        </EditItemTemplate>
                                    </telerik:GridTemplateColumn>

                                    <telerik:GridBoundColumn DataField="AccountDesc" FilterControlAltText="Filter AccountDesc column" HeaderText="AccountDesc" SortExpression="AccountDesc" UniqueName="AccountDesc">
                                    </telerik:GridBoundColumn>

                                    <telerik:GridTemplateColumn HeaderText="SegValue1" UniqueName="SegValue1" DataField="SegValue1">
                                        <ItemTemplate>
                                            <%# Eval("SegValue1") %>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <telerik:RadDropDownList RenderMode="Lightweight" runat="server" ID="SegValue1DropDown" DataValueField="SegmentCode" DataTextField="SegmentCode" DataSourceID="SqlDataSourceSegValue1" >
                                            </telerik:RadDropDownList>
                                        </EditItemTemplate>
                                    </telerik:GridTemplateColumn>	
                                    <telerik:GridTemplateColumn HeaderText="SegValue2" UniqueName="SegValue2" DataField="SegValue2">
                                        <ItemTemplate>
                                            <%# Eval("SegValue2") %>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <telerik:RadDropDownList RenderMode="Lightweight" runat="server" ID="SegValue2DropDown" DataValueField="SegmentCode" DataTextField="SegmentCode" DataSourceID="SqlDataSourceSegValue2" >
                                            </telerik:RadDropDownList>
                                        </EditItemTemplate>
                                    </telerik:GridTemplateColumn>							
                                    <telerik:GridTemplateColumn HeaderText="SegValue3" UniqueName="SegValue3" DataField="SegValue3">
                                        <ItemTemplate>
                                            <%# Eval("SegValue3") %>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <telerik:RadDropDownList RenderMode="Lightweight" runat="server" ID="SegValue3DropDown" DataValueField="SegmentCode" DataTextField="SegmentCode" DataSourceID="SqlDataSourceSegValue3" >
                                            </telerik:RadDropDownList>
                                        </EditItemTemplate>
                                    </telerik:GridTemplateColumn>	
                                    <telerik:GridTemplateColumn HeaderText="SegValue4" UniqueName="SegValue4" DataField="SegValue4">
                                        <ItemTemplate>
                                            <%# Eval("SegValue4") %>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <telerik:RadDropDownList RenderMode="Lightweight" runat="server" ID="SegValue4DropDown" DataValueField="SegmentCode" DataTextField="SegmentCode" DataSourceID="SqlDataSourceSegValue4" >
                                            </telerik:RadDropDownList>
                                        </EditItemTemplate>
                                    </telerik:GridTemplateColumn>	
                                    <telerik:GridTemplateColumn HeaderText="SegValue5" UniqueName="SegValue5" DataField="SegValue5">
                                        <ItemTemplate>
                                            <%# Eval("SegValue5") %>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <telerik:RadDropDownList RenderMode="Lightweight" runat="server" ID="SegValue5DropDown" DataValueField="SegmentCode" DataTextField="SegmentCode" DataSourceID="SqlDataSourceSegValue5" >
                                            </telerik:RadDropDownList>
                                        </EditItemTemplate>
                                    </telerik:GridTemplateColumn>	
                                    <telerik:GridTemplateColumn HeaderText="SegValue6" UniqueName="SegValue6" DataField="SegValue6">
                                        <ItemTemplate>
                                            <%# Eval("SegValue6") %>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <telerik:RadDropDownList RenderMode="Lightweight" runat="server" ID="SegValue6DropDown" DataValueField="SegmentCode" DataTextField="SegmentCode" DataSourceID="SqlDataSourceSegValue6" >
                                            </telerik:RadDropDownList>
                                        </EditItemTemplate>
                                    </telerik:GridTemplateColumn>	
                                    <telerik:GridTemplateColumn HeaderText="SegValue7" UniqueName="SegValue7" DataField="SegValue7">
                                        <ItemTemplate>
                                            <%# Eval("SegValue7") %>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <telerik:RadDropDownList RenderMode="Lightweight" runat="server" ID="SegValue7DropDown" DataValueField="SegmentCode" DataTextField="SegmentCode" DataSourceID="SqlDataSourceSegValue7" >
                                            </telerik:RadDropDownList>
                                        </EditItemTemplate>
                                    </telerik:GridTemplateColumn>	
                                    <telerik:GridTemplateColumn HeaderText="SegValue8" UniqueName="SegValue8" DataField="SegValue8">
                                        <ItemTemplate>
                                            <%# Eval("SegValue8") %>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <telerik:RadDropDownList RenderMode="Lightweight" runat="server" ID="SegValue8DropDown" DataValueField="SegmentCode" DataTextField="SegmentCode" DataSourceID="SqlDataSourceSegValue8" >
                                            </telerik:RadDropDownList>
                                        </EditItemTemplate>
                                    </telerik:GridTemplateColumn>	
                                    <telerik:GridTemplateColumn HeaderText="SegValue9" UniqueName="SegValue9" DataField="SegValue9">
                                        <ItemTemplate>
                                            <%# Eval("SegValue9") %>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <telerik:RadDropDownList RenderMode="Lightweight" runat="server" ID="SegValue9DropDown" DataValueField="SegmentCode" DataTextField="SegmentCode" DataSourceID="SqlDataSourceSegValue9" >
                                            </telerik:RadDropDownList>
                                        </EditItemTemplate>
                                    </telerik:GridTemplateColumn>
                                    <telerik:GridTemplateColumn HeaderText="SegValue10" UniqueName="SegValue10" DataField="SegValue10">
                                        <ItemTemplate>
                                            <%# Eval("SegValue10") %>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <telerik:RadDropDownList RenderMode="Lightweight" runat="server" ID="SegValue10DropDown" DataValueField="SegmentCode" DataTextField="SegmentCode" DataSourceID="SqlDataSourceSegValue10" >
                                            </telerik:RadDropDownList>
                                        </EditItemTemplate>
                                    </telerik:GridTemplateColumn>

                                    <telerik:GridBoundColumn DataField="Period_1" DataType="System.Decimal" FilterControlAltText="Filter Period_1 column" HeaderText="Period_1" SortExpression="Period_1" UniqueName="Period_1">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="Period_2" DataType="System.Decimal" FilterControlAltText="Filter Period_2 column" HeaderText="Period_2" SortExpression="Period_2" UniqueName="Period_2">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="Period_3" DataType="System.Decimal" FilterControlAltText="Filter Period_3 column" HeaderText="Period_3" SortExpression="Period_3" UniqueName="Period_3">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="Period_4" DataType="System.Decimal" FilterControlAltText="Filter Period_4 column" HeaderText="Period_4" SortExpression="Period_4" UniqueName="Period_4">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="Period_5" DataType="System.Decimal" FilterControlAltText="Filter Period_5 column" HeaderText="Period_5" SortExpression="Period_5" UniqueName="Period_5">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="Period_6" DataType="System.Decimal" FilterControlAltText="Filter Period_6 column" HeaderText="Period_6" SortExpression="Period_6" UniqueName="Period_6">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="Period_7" DataType="System.Decimal" FilterControlAltText="Filter Period_7 column" HeaderText="Period_7" SortExpression="Period_7" UniqueName="Period_7">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="Period_8" DataType="System.Decimal" FilterControlAltText="Filter Period_8 column" HeaderText="Period_8" SortExpression="Period_8" UniqueName="Period_8">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="Period_9" DataType="System.Decimal" FilterControlAltText="Filter Period_9 column" HeaderText="Period_9" SortExpression="Period_9" UniqueName="Period_9">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="Period_10" DataType="System.Decimal" FilterControlAltText="Filter Period_10 column" HeaderText="Period_10" SortExpression="Period_10" UniqueName="Period_10">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="Period_11" DataType="System.Decimal" FilterControlAltText="Filter Period_11 column" HeaderText="Period_11" SortExpression="Period_11" UniqueName="Period_11">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="Period_12" DataType="System.Decimal" FilterControlAltText="Filter Period_12 column" HeaderText="Period_12" SortExpression="Period_12" UniqueName="Period_12">
                                    </telerik:GridBoundColumn>                                                                                                          

                                    <telerik:GridBoundColumn DataField="CreatedBy" FilterControlAltText="Filter CreatedBy column" HeaderText="CreatedBy" SortExpression="CreatedBy" UniqueName="CreatedBy" Display="false">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="CreatedDate" DataType="System.DateTime" FilterControlAltText="Filter CreatedDate column" HeaderText="CreatedDate" SortExpression="CreatedDate" UniqueName="CreatedDate" Display="false">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="ChangedBy" FilterControlAltText="Filter ChangedBy column" HeaderText="ChangedBy" SortExpression="ChangedBy" UniqueName="ChangedBy" Display="false">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="ChangedDate" DataType="System.DateTime" FilterControlAltText="Filter ChangedDate column" HeaderText="ChangedDate" SortExpression="ChangedDate" UniqueName="ChangedDate" Display="false">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="SysRowID" DataType="System.Guid" FilterControlAltText="Filter SysRowID column" HeaderText="SysRowID" SortExpression="SysRowID" UniqueName="SysRowID" Visible="false">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="Company" FilterControlAltText="Filter Company column" HeaderText="Company" ReadOnly="False" SortExpression="Company" UniqueName="Company" Display="false">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="EntryNum" FilterControlAltText="Filter EntryNum column" HeaderText="EntryNum" ReadOnly="False" SortExpression="EntryNum" UniqueName="EntryNum" Display="false">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn DataField="Revision" DataType="System.Int32" FilterControlAltText="Filter Revision column" HeaderText="Revision" ReadOnly="False" SortExpression="Revision" UniqueName="Revision" Display="false">
                                    </telerik:GridBoundColumn>                        
                                </Columns>
                            </MasterTableView>
                        </telerik:RadGrid>
                        <asp:SqlDataSource ID="SqlDataSourceDtl" runat="server" ConnectionString="<%$ ConnectionStrings:BudgetPlanConnectionString %>" 
                            SelectCommand="SELECT * FROM [BudgetPlanDtl] WHERE [Company]=@Company AND [EntryNum]=@EntryNum AND [Revision]=@Revision ORDER BY [EntryNum], [Line]"
                            InsertCommand="INSERT INTO [BudgetPlanDtl] ([Company], [EntryNum], [Revision], [Line], [Budget_Item], [Period_1], [Period_2], [Period_3], [Period_4], [Period_5], [Period_6], [Period_7], [Period_8], [Period_9], [Period_10], [Period_11], [Period_12], [GLAccount], [AccountDesc], [SegValue1], [SegValue2], [SegValue3], [SegValue4], [SegValue5], [SegValue6], [SegValue7], [SegValue8], [SegValue9], [SegValue10], [CreatedBy], [ChangedBy]) VALUES (@Company, @EntryNum, @Revision, @Line, @Budget_Item, @Period_1, @Period_2, @Period_3, @Period_4, @Period_5, @Period_6, @Period_7, @Period_8, @Period_9, @Period_10, @Period_11, @Period_12, @GLAccount, @AccountDesc, @SegValue1, @SegValue2, @SegValue3, @SegValue4, @SegValue5, @SegValue6, @SegValue7, @SegValue8, @SegValue9, @SegValue10, @CreatedBy, @ChangedBy)"
                            DeleteCommand="DELETE FROM [BudgetPlanDtl] WHERE [Company] = @Company AND [EntryNum] = @EntryNum AND [Revision]=@Revision AND [Line] = @Line"
                            UpdateCommand="UPDATE [BudgetPlanDtl] SET [Budget_Item] = @Budget_Item, [Period_1] = @Period_1, [Period_2] = @Period_2, [Period_3] = @Period_3, [Period_4] = @Period_4, [Period_5] = @Period_5, [Period_6] = @Period_6, [Period_7] = @Period_7, [Period_8] = @Period_8, [Period_9] = @Period_9, [Period_10] = @Period_10, [Period_11] = @Period_11, [Period_12] = @Period_12, [GLAccount] = @GLAccount, [AccountDesc] = @AccountDesc, [SegValue1] = @SegValue1, [SegValue2] = @SegValue2, [SegValue3] = @SegValue3, [SegValue4] = @SegValue4, [SegValue5] = @SegValue5, [SegValue6] = @SegValue6, [SegValue7] = @SegValue7, [SegValue8] = @SegValue8, [SegValue9] = @SegValue9, [SegValue10] = @SegValue10, [ChangedBy] = @ChangedBy WHERE [Company] = @Company AND [EntryNum] = @EntryNum AND [Revision]=@Revision AND [Line] = @Line"
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
                                <asp:Parameter Name="Budget_Item" Type="String"></asp:Parameter>
                                <asp:Parameter Name="GLAccount" Type="String"></asp:Parameter>
                                <asp:Parameter Name="AccountDesc" Type="String"></asp:Parameter>
                                <asp:Parameter Name="SegValue1" Type="String"></asp:Parameter>
                                <asp:Parameter Name="SegValue2" Type="String"></asp:Parameter>
                                <asp:Parameter Name="SegValue3" Type="String"></asp:Parameter>
                                <asp:Parameter Name="SegValue4" Type="String"></asp:Parameter>
                                <asp:Parameter Name="SegValue5" Type="String"></asp:Parameter>
                                <asp:Parameter Name="SegValue6" Type="String"></asp:Parameter>
                                <asp:Parameter Name="SegValue7" Type="String"></asp:Parameter>
                                <asp:Parameter Name="SegValue8" Type="String"></asp:Parameter>
                                <asp:Parameter Name="SegValue9" Type="String"></asp:Parameter>
                                <asp:Parameter Name="SegValue10" Type="String"></asp:Parameter>
                                <asp:Parameter Name="ChangedBy" Type="String"></asp:Parameter>
                            </UpdateParameters>
                            <SelectParameters>
                                <asp:SessionParameter Name="Company" SessionField="Company" DefaultValue="" Type="String"/>
                                <asp:SessionParameter Name="EntryNum" SessionField="EntryNum" DefaultValue="" Type="String"/>
                                <asp:SessionParameter Name="Revision" SessionField="Revision" DefaultValue="0" Type="String"/>
                            </SelectParameters>
                        </asp:SqlDataSource>
                        <asp:SqlDataSource ID="SqlDataSourceGLAccount" runat="server" ConnectionString="<%$ ConnectionStrings:EpicorConnectionString %>" 
                            SelectCommand="select top 10 replace(GLAccount,'|','-') as GLAccount,AccountDesc from erp.GLAccount where Company=@Company and COACode=@COACode union select '','' order by GLAccount">
                            <SelectParameters>
                                <asp:SessionParameter Name="Company" SessionField="Company" DefaultValue="" Type="String"/>
                                <asp:SessionParameter Name="COACode" SessionField="COACode" DefaultValue="" Type="String"/>
                            </SelectParameters>
                        </asp:SqlDataSource>
                        <asp:SqlDataSource ID="SqlDataSourceSegValue1" runat="server" ConnectionString="<%$ ConnectionStrings:EpicorConnectionString %>" 
                            SelectCommand="select top 10 SegmentCode,SegmentName from erp.COASegValues where SegmentNbr=1 and Company=@Company and COACode=@COACode union select '','' order by SegmentName">
                            <SelectParameters>
                                <asp:SessionParameter Name="Company" SessionField="Company" DefaultValue="" Type="String"/>
                                <asp:SessionParameter Name="COACode" SessionField="COACode" DefaultValue="" Type="String"/>
                            </SelectParameters>
                        </asp:SqlDataSource>
                        <asp:SqlDataSource ID="SqlDataSourceSegValue2" runat="server" ConnectionString="<%$ ConnectionStrings:EpicorConnectionString %>" 
                            SelectCommand="select top 10 SegmentCode,SegmentName from erp.COASegValues where SegmentNbr=2 and Company=@Company and COACode=@COACode union select '','' order by SegmentName">
                            <SelectParameters>
                                <asp:SessionParameter Name="Company" SessionField="Company" DefaultValue="" Type="String"/>
                                <asp:SessionParameter Name="COACode" SessionField="COACode" DefaultValue="" Type="String"/>
                            </SelectParameters>
                        </asp:SqlDataSource>
                        <asp:SqlDataSource ID="SqlDataSourceSegValue3" runat="server" ConnectionString="<%$ ConnectionStrings:EpicorConnectionString %>" 
                            SelectCommand="select top 10 SegmentCode,SegmentName from erp.COASegValues where SegmentNbr=3 and Company=@Company and COACode=@COACode union select '','' order by SegmentName">
                            <SelectParameters>
                                <asp:SessionParameter Name="Company" SessionField="Company" DefaultValue="" Type="String"/>
                                <asp:SessionParameter Name="COACode" SessionField="COACode" DefaultValue="" Type="String"/>
                            </SelectParameters>
                        </asp:SqlDataSource>
                        <asp:SqlDataSource ID="SqlDataSourceSegValue4" runat="server" ConnectionString="<%$ ConnectionStrings:EpicorConnectionString %>" 
                            SelectCommand="select top 10 SegmentCode,SegmentName from erp.COASegValues where SegmentNbr=4 and Company=@Company and COACode=@COACode union select '','' order by SegmentName">
                            <SelectParameters>
                                <asp:SessionParameter Name="Company" SessionField="Company" DefaultValue="" Type="String"/>
                                <asp:SessionParameter Name="COACode" SessionField="COACode" DefaultValue="" Type="String"/>
                            </SelectParameters>
                        </asp:SqlDataSource>
                        <asp:SqlDataSource ID="SqlDataSourceSegValue5" runat="server" ConnectionString="<%$ ConnectionStrings:EpicorConnectionString %>" 
                            SelectCommand="select top 10 SegmentCode,SegmentName from erp.COASegValues where SegmentNbr=5 and Company=@Company and COACode=@COACode union select '','' order by SegmentName">
                            <SelectParameters>
                                <asp:SessionParameter Name="Company" SessionField="Company" DefaultValue="" Type="String"/>
                                <asp:SessionParameter Name="COACode" SessionField="COACode" DefaultValue="" Type="String"/>
                            </SelectParameters>
                        </asp:SqlDataSource>
                        <asp:SqlDataSource ID="SqlDataSourceSegValue6" runat="server" ConnectionString="<%$ ConnectionStrings:EpicorConnectionString %>" 
                            SelectCommand="select top 10 SegmentCode,SegmentName from erp.COASegValues where SegmentNbr=6 and Company=@Company and COACode=@COACode union select '','' order by SegmentName">
                            <SelectParameters>
                                <asp:SessionParameter Name="Company" SessionField="Company" DefaultValue="" Type="String"/>
                                <asp:SessionParameter Name="COACode" SessionField="COACode" DefaultValue="" Type="String"/>
                            </SelectParameters>
                        </asp:SqlDataSource>
                        <asp:SqlDataSource ID="SqlDataSourceSegValue7" runat="server" ConnectionString="<%$ ConnectionStrings:EpicorConnectionString %>" 
                            SelectCommand="select top 10 SegmentCode,SegmentName from erp.COASegValues where SegmentNbr=7 and Company=@Company and COACode=@COACode union select '','' order by SegmentName">
                            <SelectParameters>
                                <asp:SessionParameter Name="Company" SessionField="Company" DefaultValue="" Type="String"/>
                                <asp:SessionParameter Name="COACode" SessionField="COACode" DefaultValue="" Type="String"/>
                            </SelectParameters>
                        </asp:SqlDataSource>
                        <asp:SqlDataSource ID="SqlDataSourceSegValue8" runat="server" ConnectionString="<%$ ConnectionStrings:EpicorConnectionString %>" 
                            SelectCommand="select top 10 SegmentCode,SegmentName from erp.COASegValues where SegmentNbr=8 and Company=@Company and COACode=@COACode union select '','' order by SegmentName">
                            <SelectParameters>
                                <asp:SessionParameter Name="Company" SessionField="Company" DefaultValue="" Type="String"/>
                                <asp:SessionParameter Name="COACode" SessionField="COACode" DefaultValue="" Type="String"/>
                            </SelectParameters>
                        </asp:SqlDataSource>
                        <asp:SqlDataSource ID="SqlDataSourceSegValue9" runat="server" ConnectionString="<%$ ConnectionStrings:EpicorConnectionString %>" 
                            SelectCommand="select top 10 SegmentCode,SegmentName from erp.COASegValues where SegmentNbr=9 and Company=@Company and COACode=@COACode union select '','' order by SegmentName">
                            <SelectParameters>
                                <asp:SessionParameter Name="Company" SessionField="Company" DefaultValue="" Type="String"/>
                                <asp:SessionParameter Name="COACode" SessionField="COACode" DefaultValue="" Type="String"/>
                            </SelectParameters>
                        </asp:SqlDataSource>
                        <asp:SqlDataSource ID="SqlDataSourceSegValue10" runat="server" ConnectionString="<%$ ConnectionStrings:EpicorConnectionString %>" 
                            SelectCommand="select top 10 SegmentCode,SegmentName from erp.COASegValues where SegmentNbr=10 and Company=@Company and COACode=@COACode union select '','' order by SegmentName">
                            <SelectParameters>
                                <asp:SessionParameter Name="Company" SessionField="Company" DefaultValue="" Type="String"/>
                                <asp:SessionParameter Name="COACode" SessionField="COACode" DefaultValue="" Type="String"/>
                            </SelectParameters>
                        </asp:SqlDataSource>

                    </div>
                    <telerik:RadTextBox ID="RadTextBoxCurrentCompany" runat="server" Label="Company:" ReadOnly="true" Display="false"></telerik:RadTextBox>
                    <telerik:RadTextBox ID="RadTextBoxCurrentCompanyName" runat="server" Label="Co.Name:" ReadOnly="true" ></telerik:RadTextBox>
                    <telerik:RadTextBox ID="RadTextBoxUserID" runat="server" Label="UserID:" ReadOnly="true" ></telerik:RadTextBox>
                    
                    </telerik:LayoutColumn>
                </Columns>
            </telerik:LayoutRow>
            <telerik:LayoutRow>
                <Columns>
                    <telerik:LayoutColumn Span="10" SpanMd="12" SpanSm="12" SpanXs="12">

                    <telerik:RadWindowManager RenderMode="Lightweight" ID="RadWindowManager1" ShowContentDuringLoad="false" VisibleStatusbar="false"
                        ReloadOnShow="true" runat="server" EnableShadow="true">
                        <Windows>
                            <telerik:RadWindow RenderMode="Lightweight" ID="RadWindow1" runat="server" Behaviors="Close" OnClientClose="OnClientClose"
                                NavigateUrl="DialogSearchGLAccount.aspx">
                            </telerik:RadWindow>
                            <telerik:RadWindow RenderMode="Lightweight" ID="RadWindow2" runat="server" Width="650" Height="480" Modal="true" NavigateUrl="Dialog2.aspx">
                            </telerik:RadWindow>
                        </Windows>
                    </telerik:RadWindowManager>
                    <div class="demo-container size-narrow">
                        <p>
                            Click the button to open the Travel Planner form in a RadWindow.
                        </p>
                        <button onclick="openWin('xxx'); return false;">
                            Choose Destination and date</button>
                        <div id="order" class="orderText">
                            &nbsp;
                        </div>
                    </div>

                    </telerik:LayoutColumn>
                </Columns>
            </telerik:LayoutRow>
        </Rows>
    </telerik:RadPageLayout>

</asp:Content>
