import 'package:cheque_print/bloc/PrintLog/PrintLog_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../commonWidget/GridDataCommonFunc.dart';
import '../../commonWidget/themeHelper.dart';
import '../../model/Excel_data_model.dart';
import '../../model/viewallcategories/ViewAllCategories_model.dart';
import '../../network/repositary.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class LogPrint extends StatefulWidget {
  const LogPrint({Key? key}) : super(key: key);

  @override
  State<LogPrint> createState() => _LogPrintState();
}

class _LogPrintState extends State<LogPrint> {


  PrintLogBloc vacBloc = PrintLogBloc(Repository.getInstance());

  List<ExcelDataModel>? allcategorymodelData;

  late AllCategoryDataSource _allCategoryDataSource;


  @override
  void initState() {
    super.initState();
    loadui1();
  }

  loadui1(){
    vacBloc.add(AllFetchDataForPrintLogPageEvent());
  }





  @override
  Widget build(BuildContext context) {

    final main_width = MediaQuery.of(context).size.width;
    final main_height = MediaQuery.of(context).size.height;

    return Scaffold(

      bottomSheet: Container(
        height: main_height * 0.06,
        width: main_height * 10,
        decoration: BoxDecoration(color: Color(0xFF3182B1)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: (){
                launch("https://feeltechsolutions.com/");
              },
              child: Text(
                "  www.feeltechsolutions.com ",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),

            Text(
              "  © FeelTech Solutions Pvt. Ltd.  |  9099240066  |  connect@feeltechsolutions.com    ",
              style: TextStyle(color: Colors.white, fontSize: 22),
            )

          ],
        ),
      ),



      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: AppBar(
          backgroundColor: Color(0xFF3182B3),
          title: Text("FTS Bulk Cheque Printing Softwere"),
        ),
      ),

      body:BlocProvider<PrintLogBloc>(
        create: (context) => vacBloc..add(PrintLogInitialEvent()),
        child: BlocConsumer<PrintLogBloc, PrintLogStates>(
          builder: (context, state) {
            if (state is PrintLogLoadingState) {
              return ThemeHelper.buildLoadingWidget();
            } else if (state is AllFetchDataForPrintLogPageState) {
              allcategorymodelData = state.allCatoModel;
              _allCategoryDataSource =
                  AllCategoryDataSource(allcategorymodelData!,context);
              return mainAllCategoryView();
            } else {
              return ThemeHelper.buildCommonInitialWidgetScreen();
            }
          },
          listener: (context, state) {
            if (state is APIFailureState) {
              print(state.exception.toString());
            }
          },
        ),
      ),

    );
  }


  Widget mainAllCategoryView(){
    final main_width = MediaQuery.of(context).size.width;
    final main_height = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Container(
            height: main_height *0.89,
            child:  Padding(
              padding: const EdgeInsets.all(5.0),
              child: SfDataGridTheme(
                data: SfDataGridThemeData(
                  headerColor: Colors.blue[300],
                  sortIconColor: Colors.white,
                ),
                child: SfDataGrid(


                  shrinkWrapRows: true,
                  // allowFiltering: true,
                  gridLinesVisibility: GridLinesVisibility.both,
                  headerGridLinesVisibility: GridLinesVisibility.both,
                  columnWidthMode: ColumnWidthMode.fitByCellValue,
                  rowHeight: 35,
                  headerRowHeight: 35,
                  footerHeight: 30,
                  isScrollbarAlwaysShown: true,
                  verticalScrollPhysics: AlwaysScrollableScrollPhysics(),
                  source: _allCategoryDataSource,

                  tableSummaryRows: [
                    GridTableSummaryRow(
                        color: Color.fromARGB(255, 189, 215, 238),
                        showSummaryInRow: false,
                        columns: [
                          const GridSummaryColumn(
                              name: 'Sum',
                              columnName: 'chequeNo',
                              summaryType: GridSummaryType.count
                          ),
                          const GridSummaryColumn(
                              name: 'Sum',
                              columnName: 'chequeDate',
                              summaryType: GridSummaryType.sum
                          ),
                          const GridSummaryColumn(
                              name: 'Sum',
                              columnName: 'chequePayname',
                              summaryType: GridSummaryType.sum
                          ),
                          const GridSummaryColumn(
                              name: 'Sum',
                              columnName: 'chequeAmount',
                              summaryType: GridSummaryType.sum
                          ),
                          const GridSummaryColumn(
                              name: 'Sum',
                              columnName: 'isAccountPay',
                              summaryType: GridSummaryType.sum
                          )
                        ],
                        position: GridTableSummaryRowPosition.bottom
                    )
                  ],

                  columns: [

                    GridDataCommonFunc.tableColumnsDataLayout(
                        columnName: 'chequeNo',
                        toolTipMessage: "chequeNo",
                        columnTitle: "chequeNo",
                        columnWidthModeData: ColumnWidthMode.fill
                    ),
                    GridDataCommonFunc.tableColumnsDataLayout(
                        columnName: 'chequeDate',
                        toolTipMessage: "chequeDate",
                        columnTitle: "chequeDate",
                        columnWidthModeData: ColumnWidthMode.fill
                    ),

                    GridDataCommonFunc.tableColumnsDataLayout(
                        columnName: 'chequePayname',
                        toolTipMessage: "chequePayname",
                        columnTitle: "chequePayname",
                        columnWidthModeData: ColumnWidthMode.fill
                    ),
                    GridDataCommonFunc.tableColumnsDataLayout(
                        columnName: 'chequeAmount',
                        toolTipMessage: "chequeAmount",
                        columnTitle: "chequeAmount",
                        columnWidthModeData: ColumnWidthMode.fill
                    ),
                    GridDataCommonFunc.tableColumnsDataLayout(
                        columnName: 'isAccountPay',
                        toolTipMessage: "isAccountPay",
                        columnTitle: "isAccountPay",
                        columnWidthModeData: ColumnWidthMode.fill
                    ),

                  ],
                ),
              ),
            ),
          ),



        ],
      ),
    );

  }

}



class AllCategoryDataSource extends DataGridSource{
  final BuildContext _context1;

  late List<DataGridRow> dataGridRows;


  AllCategoryDataSource(List<ExcelDataModel> machineProductionTargetData, this._context1) {
    dataGridRows = machineProductionTargetData.map<DataGridRow>((dataGridRows) {
      return DataGridRow(cells: [
        DataGridCell(columnName: "chequeNo", value: dataGridRows.chequeNo),
        DataGridCell(columnName: "chequeDate", value: dataGridRows.chequeDate),
        DataGridCell(columnName: "chequePayname", value: dataGridRows.chequePayname),
        DataGridCell(columnName: "chequeAmount", value: dataGridRows.chequeAmount),
        DataGridCell(columnName: "isAccountPay", value: dataGridRows.isAccountPay),

      ]);
    }).toList();
  }

  @override
  List<DataGridRow> get rows => dataGridRows;



  @override
  Widget? buildTableSummaryCellWidget(
      GridTableSummaryRow summaryRow,
      GridSummaryColumn? summaryColumn,
      RowColumnIndex rowColumnIndex,
      String summaryValue) {
    return Container(
      alignment: Alignment.center,
      child: summaryColumn?.columnName == "chequeNo" ?
      Text(
        summaryValue == ""
            ? "Total Cheque:  0"
            : "Total Cheque:  ${double.parse(summaryValue).toStringAsFixed(2)}",
        overflow: TextOverflow.ellipsis,
        style:
        const TextStyle(color: Colors.black, fontWeight: FontWeight.w800),
      ) :summaryColumn?.columnName == "chequeAmount" ?
      Text(
        summaryValue == ""
            ? "Total Amount:  0"
            : "Total Amount:  ${double.parse(summaryValue).toStringAsFixed(2)}",
        overflow: TextOverflow.ellipsis,
        style:
        const TextStyle(color: Colors.black, fontWeight: FontWeight.w800),
      )
          : Text(
        summaryValue == ""
            ? ""
            : "",
        overflow: TextOverflow.ellipsis,
        style:
        const TextStyle(color: Colors.black, fontWeight: FontWeight.w800),
      )
      ,
    );
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {

    Color getRowBackgroundColor() {
      final int index = effectiveRows.indexOf(row);
      if (index % 2 != 0) {
        return const Color.fromARGB(150,227, 242, 253);
      }
      return const Color.fromARGB(255, 255, 255, 255);
    }

    return DataGridRowAdapter(
        color: getRowBackgroundColor(),
        cells: row.getCells().map<Widget>((dataGridCell) {
          double main_Width = MediaQuery.of(_context1).size.width;
          double main_Height = MediaQuery.of(_context1).size.height;

          return Container(
            alignment: Alignment.center,
            child: dataGridCell.columnName=="isAccountPay" ?
            Align(
              alignment: Alignment.center,
              child: Text(
                dataGridCell.value == true ?
                    "Yes" : "No"
                    .toString()
                    .replaceAll("(", "")
                    .replaceAll(")", ""),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            )
                : Align(
              alignment: Alignment.center,
              child: Text(
                dataGridCell.value
                    .toString()
                    .replaceAll("(", "")
                    .replaceAll(")", ""),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          );
        }).toList());
  }



}
