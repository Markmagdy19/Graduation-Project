import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


import '../generated/l10n.dart';
import '../models/task.dart';
import '../ui/utils/size_config.dart';
import '../ui/utils/theme.dart';

class TaskTile extends StatelessWidget {
  const TaskTile(this.task, {super.key});
  final Task task;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.orientation == Orientation.landscape
          ? SizeConfig.screenWidth / 2
          : SizeConfig.screenWidth,
      margin: EdgeInsets.only(bottom:getProportionateScreenHeight(12) ),
      padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(
              SizeConfig.orientation == Orientation.landscape ? 4 : 20)),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: _getBGClr(task.color),
        ),
        child: Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title!,
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey[300],
                          size: 18,
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Text(
                          '${task.startTime} - ${task.endTime}  ',
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                              color: Colors.grey[200],
                              fontSize: 13,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      task.note!,
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          color: Colors.grey[200],
                          fontSize: 13,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              height: 60,
              width: 0.5,
              color: Colors.grey[300]!.withOpacity(0.8),
            ),
            RotatedBox(
              quarterTurns: 3,
              child: Text(
                task.isCompleted == 0 ? S.of(context).To_Do :  S.of(context).Completed,
                style: GoogleFonts.lato(
                  textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getBGClr(int? color) {
    switch (color) {
      case 0:
        return primaryClr;
      case 1:
        return pinkClr;
      case 2:
        return orangeClr;

      default:
        return primaryClr;
    }
  }
}
