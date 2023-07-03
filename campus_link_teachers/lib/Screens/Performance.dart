import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
      backgroundColor: const Color.fromRGBO(28, 28, 28, 1),
      body: Center(
          child: Container(
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
                          cursorColor: Colors.amber,
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
                                    color: Colors.amber,
                                    size: 18,
                                  ),
                              ),
                              prefixIcon: const Icon(
                                Icons.search_outlined,
                                color: Colors.amber,
                                size: 22,
                              ),
                              label: const Text("Name or Roll Number"),
                              labelStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                              filled: true,
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              fillColor: Colors.black26.withOpacity(0.9),
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
                              backgroundColor: Colors.black,
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
                SizedBox(
                  height: MediaQuery.of(context).size.height*0.6,
                  width: MediaQuery.of(context).size.width*0.6,
                  child: PieChart(
                    PieChartData(
                      startDegreeOffset: -90,
                      sections: [
                        PieChartSectionData(
                          color: Colors.green,
                          title: 'Presents',
                          value: 15,
                          radius: 20,
                          showTitle: true,
                          titleStyle: const TextStyle(color: Colors.amber,fontSize: 18,fontWeight: FontWeight.w700),
                        ),
                        PieChartSectionData(
                          color: Colors.red,
                          title: 'Absent',
                          value: 85,
                          radius: 20,
                          showTitle: true,
                          titleStyle: const TextStyle(color: Colors.amber,fontSize: 18,fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ),
    );
  }
}
