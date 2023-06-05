import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rotate_it/generic_functions.dart';
import 'package:rotate_it/providers/main_view_model.dart';

import '../main.dart';

class HomePage extends StatelessWidget with GenericFunctions {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final mvm = context.read<MainViewModel>();
    return WillPopScope(
      onWillPop: () async {
        logIfDebug('onWillPop called');
        await mvm.setPageNum(mvm.pageNum - 1);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Selector<MainViewModel, int>(
            selector: (_, mvm) => mvm.pageNum,
            builder: (_, pageNum, __) => Text(
              'Rotate it (Page # ${mvm.pageNum})',
            ),
          ),
        ),
        body: Selector<MainViewModel, List<Item>>(
          selector: (_, mvm) => mvm.data,
          builder: (_, items, __) {
            final screenWidth = MediaQuery.sizeOf(context).width;
            return GridView.builder(
              padding: const EdgeInsets.all(4.0),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: isPortrait ? screenWidth : screenWidth / 3,
                mainAxisExtent: 150.0,
              ),
              itemBuilder: (_, index) {
                return ItemView(items[index]);
              },
              itemCount: items.length,
            );
          },
        ),
      ),
    );
  }
}

class ItemView extends StatelessWidget {
  final Item item;

  BorderRadius get borderRadius => BorderRadius.circular(16.0);

  const ItemView(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    final colorLight = item.color.withOpacity(0.5);
    final circleDimen = isPortrait ? 0.18.sw : 0.06.sw;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
        side: BorderSide(
          width: isPortrait ? 8 : 6,
          color: item.color,
        ),
      ),
      surfaceTintColor: item.color,
      child: InkWell(
        borderRadius: borderRadius,
        highlightColor: colorLight,
        splashColor: colorLight,
        onTap: () async {
          final mvm = context.read<MainViewModel>();
          await mvm.setPageNum(mvm.pageNum + 1);
          if (context.mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
            );
          }
        },
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isPortrait ? 16 : 12),
              child: Container(
                width: circleDimen,
                height: circleDimen,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(36),
                  color: colorLight,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  item.text,
                  style: TextStyle(
                    fontSize: isPortrait ? 16.0 : null,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isPortrait ? 16 : 12),
              child: Container(
                width: circleDimen,
                height: circleDimen,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(36),
                  color: colorLight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
