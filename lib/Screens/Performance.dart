import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class Performance extends StatefulWidget {
  const Performance({Key? key}) : super(key: key);

  @override
  State<Performance> createState() => _PerformanceState();
}

class _PerformanceState extends State<Performance> {
  TextEditingController search = TextEditingController();
  bool clear = false;
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    List barChartX=[10,20];
    //pai chart data
    Map<String, double> dataMap = {
      "Present": 50,
      "Absent": 20,

    };

    final colorList = <Color>[
      Colors.indigo,
      Colors.purpleAccent
    ];
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
          child: Container(
            height: size.height,
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.025,
              right: MediaQuery.of(context).size.width * 0.025,
              top: MediaQuery.of(context).size.height * 0.02,
              bottom: MediaQuery.of(context).size.height * 0.025,
        ),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: TextFormField(
                          textInputAction: TextInputAction.search,
                          controller: search,
                          cursorColor: Colors.white,
                          style: TextStyle(color: Colors.white.withOpacity(0.9)),
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      search.clear();
                                },
                                    );
                              },
                                  icon: const Icon(
                                    Icons.clear_outlined,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                              ),
                              prefixIcon: const Icon(
                                Icons.search_outlined,
                                color: Colors.white,
                                size: 22,
                              ),
                              label: const Text("Name or Roll Number"),
                              labelStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                              filled: true,
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              fillColor: Colors.black26.withOpacity(0.6),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(22.0),
                                  borderSide: const BorderSide(width: 0, style: BorderStyle.none),
                              ),
                          ),
                          keyboardType: TextInputType.name),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.025,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.width * 0.21,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black.withOpacity(0.5),
                              shape: const StadiumBorder()),
                          onPressed: () {},
                          child: const Text('Search')),
                )
              ],
            ),
                Divider(
                  color: Colors.white,
                  height: MediaQuery.of(context).size.height*0.03,
                  thickness: MediaQuery.of(context).size.height*0.001,
                ),
                Container(
                  height: size.height*0.42,
                  width: size.width,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                    color: Colors.black26.withOpacity(0.7)
                  ),
                  child: BarChart(
                    BarChartData(
                      barTouchData:BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          tooltipBgColor: Colors.white,
                          getTooltipItem: (a, b, c, d) => null,
                        ),




                      ) ,

                      alignment: BarChartAlignment.center,
                      barGroups: List.generate(
                        barChartX.length,
                            (i) => BarChartGroupData(
                          x: i,
                          barRods: [
                            BarChartRodData(
                              toY: 10,
                              color: Colors.white60,
                              width: 10.0,
                              borderRadius: BorderRadius.circular(10),
                              backDrawRodData: BackgroundBarChartRodData(
                                show: true,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(

                              showTitles: true,
                              reservedSize: 38,


                          ),
                        ),
                      ),
                    ),
                    ),
                ),
                Column(
                  children: [
                    SizedBox(
                      height: size.height*0.02,
                    ),
                   /* PieChart(

                      dataMap: dataMap,
                      chartType: ChartType.ring,
                      baseChartColor: Colors.white,
                      colorList: colorList,
                      chartValuesOptions:  const ChartValuesOptions(

                        showChartValuesInPercentage: true,
                      ),
                      totalValue: 100,
                    ),*/
                  ],
                )
              ],
            ),
          ),
      ),
    );
  }
}








