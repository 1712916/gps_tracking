import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gps_speed/feature/dangerous_mark/cubit/dangerous_cubit.dart';

class DangerousMarkLayout extends StatefulWidget {
  const DangerousMarkLayout({super.key, required this.child});

  final Widget child;

  @override
  State<DangerousMarkLayout> createState() => _DangerousMarkLayoutState();
}

class _DangerousMarkLayoutState extends State<DangerousMarkLayout> {
  double buttonX = 0;
  double buttonY = 0;
  final buttonWidth = 80.0; // Chiều rộng của button
  final buttonHeight = 80.0; // Chiều cao của

  double get screenWidth => MediaQuery.of(context).size.width;
  double get screenHeight => MediaQuery.of(context).size.height;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    buttonX = screenWidth - 40 - buttonWidth;
    buttonY = (screenHeight - buttonHeight) / 2;
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DangerousCubit, DangerousState>(builder: (context, state) {
      return Stack(
        children: [
          widget.child,
          // if (kDebugMode)
          //   SizedBox(
          //     height: 500,
          //     child: SingleChildScrollView(
          //       child: Column(
          //         children: [
          //           ...state.dangerousLocations.map((e) => ListTile(
          //                 title: Text("lat: ${e.latitude} - long: ${e.longitude}"),
          //                 subtitle: Column(
          //                   children: [
          //                     Text("Info: ${e.addressInfo}"),
          //                     Text("Time: ${e.time}"),
          //                   ],
          //                 ),
          //               )),
          //         ],
          //       ),
          //     ),
          //   ),
          if (state.showMarkButton)
            Positioned(
              left: buttonX,
              top: buttonY,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    buttonX = (buttonX + details.delta.dx).clamp(0.0, screenWidth - 40 - buttonWidth);
                    buttonY = (buttonY + details.delta.dy).clamp(0.0, screenHeight - 40 - buttonHeight);
                  });
                },
                onTap: () async {
                  if (isLoading) {
                    return;
                  }
                  // //show toast: get dangerous location information
                  // Fluttertoast.showToast(
                  //   msg: "Getting dangerous location information",
                  //   toastLength: Toast.LENGTH_SHORT,
                  //   gravity: ToastGravity.CENTER,
                  //   timeInSecForIosWeb: 1,
                  //   backgroundColor: Colors.grey.withOpacity(0.5),
                  //   textColor: Colors.white,
                  //   fontSize: 16.0,
                  // );

                  isLoading = true;
                  setState(() {});

                  await context.read<DangerousCubit>().markAsDangerous();
                  isLoading = false;
                  setState(() {});

                  Fluttertoast.showToast(
                    msg: "Get dangerous location information successfully",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.grey.withOpacity(0.5),
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                },
                onLongPress: () {
                  const snackBar = SnackBar(
                    elevation: 0,
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.transparent,
                    showCloseIcon: false,
                    content: AwesomeSnackbarContent(
                      title: 'Help',
                      message: 'Marked current location as dangerous location',
                      contentType: ContentType.help,
                    ),
                  );

                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      snackBar,
                    );
                },
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Builder(builder: (context) {
                      return CircleAvatar(
                        radius: 80,
                        backgroundColor: Theme.of(context).secondaryHeaderColor,
                        // backgroundColor: Colors.yellow.shade500.withOpacity(0.3),
                        child: Builder(builder: (context) {
                          final color = Colors.red.shade400;

                          if (isLoading) {
                            return SizedBox(
                              child: CircularProgressIndicator(
                                color: color,
                              ),
                            );
                          }
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                color: color,
                                size: 80,
                              ),
                              // const SizedBox(height: 8),
                              Text(
                                'Dangerous',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: color,
                                      fontWeight: FontWeight.bold,
                                      //fontSize: 11,
                                    ),
                              ),
                            ],
                          );
                        }),
                      );
                    }),
                  ),
                ),
              ),
            ),
        ],
      );
    });
  }
}
