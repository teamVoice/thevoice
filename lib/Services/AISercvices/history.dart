import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:thevoice2/SystemUiValues.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final List history = Hive.box('History').values.toList();
  final box = Hive.box('History');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SystemUi.systemColor,
      body: CustomScrollView(
        scrollDirection: Axis.vertical,
        slivers: [
          SliverAppBar(
            flexibleSpace: FlexibleSpaceBar(
              background: Container(color: Colors.deepPurple),
              title: Text("History"),
            ),
            pinned: false,
          ),
          history.length == 0
              ? SliverToBoxAdapter(
                  child: Center(
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.hourglass_empty_outlined,
                            size: 100,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "No history found!",
                            style: SystemUi.profilePagePTextStyle,
                          )
                        ],
                      ),
                    ),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                      childCount: history.length, (context, item) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Dismissible(
                        direction: DismissDirection.horizontal,
                        onDismissed: (direction) {
                          history.removeAt(item);
                          Hive.box("History").delete(box.keyAt(item));
                        },
                        key: Key(history[item].toString()),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.deepPurple.shade200,
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  box.keyAt(item).toString(),
                                  style: GoogleFonts.openSans(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  history[item].toString(),
                                  style: GoogleFonts.openSans(fontSize: 16),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                  // child: ListView.builder(
                  //   itemBuilder: (context, item) {
                  //     return Padding(
                  //       padding: const EdgeInsets.all(8.0),
                  //       child: Dismissible(
                  //         direction: DismissDirection.horizontal,
                  //         onDismissed: (direction) {
                  //           history.removeAt(history.length - item);
                  //           Hive.box("responseHistory").delete(history[item]);
                  //         },
                  //         key: Key(history[item].toString()),
                  //         child: Container(
                  //           decoration: BoxDecoration(
                  //               color: Colors.deepPurple.shade200,
                  //               borderRadius: BorderRadius.circular(10)),
                  //           child: Padding(
                  //             padding: const EdgeInsets.all(8.0),
                  //             child: Column(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: [
                  //                 Text(
                  //                   box.keyAt(item).toString(),
                  //                   style: GoogleFonts.openSans(
                  //                       fontSize: 17, fontWeight: FontWeight.w700),
                  //                 ),
                  //                 Text(
                  //                   history[item].toString(),
                  //                   style: GoogleFonts.openSans(fontSize: 16),
                  //                 ),
                  //                 const SizedBox(
                  //                   height: 5,
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     );
                  //     },
                  //     shrinkWrap: true,
                  //     itemCount: history.length,
                  //   ),
                )
        ],
      ),
    );
  }
}
