// class _StackedAvatarsState extends State<StackedAvatars> {
//   @override
//   Widget build(BuildContext context) {
//     return widget.children.isEmpty
//         ? const Center()
//         : Stack(
//             children: widget.children
//                 .asMap()
//                 .map((int index, Widget? child) {
//                   return MapEntry<int, Widget>(
//                     index,
//                     ClipRRect(
//                       borderRadius:
//                           BorderRadius.circular(widget.avatarSize / 2),
//                       child: Container(
//                         decoration: BoxDecoration(
//                           borderRadius:
//                               BorderRadius.circular(widget.avatarSize / 2),
//                         ),
//                         width: widget.avatarSize,
//                         height: widget.avatarSize,
//                         margin: EdgeInsets.only(
//                           left: index * (widget.avatarSize - 10),
//                         ),
//                         child: CircleAvatar(
//                           radius: widget.avatarSize / 2,
//                           child: child ?? const Icon(TablerIcons.user),
//                         ),
//                       ),
//                     ),
//                   );
//                 })
//                 .values
//                 .toList(),
//           );
//   }
// }

import 'dart:math';

import 'package:at_base2e15/at_base2e15.dart';
import 'package:flutter/material.dart';
import 'package:tabler_icons/tabler_icons.dart';

/// Creates an array of circular images stacked over each other
class StackedAvatars extends StatelessWidget {
  /// List of image urls
  final List<String?> imageList;

  /// Image radius for the circular image
  final double? imageRadius;

  /// Count of the number of images to be shown
  final int? imageCount;

  /// Total count will be used to determine the number of circular images
  /// to be shown along with showing the remaining count in an additional
  /// circle
  final int totalCount;

  /// Optional field to set the circular image border width
  final double? imageBorderWidth;

  /// Optional field to set the color of circular image border
  final Color? imageBorderColor;

  /// Optional field to set the color of circular extra count
  final Color? extraCountBorderColor;

  /// The text style to apply if there is any extra count to be shown
  final TextStyle extraCountTextStyle;

  /// Set the background color of the circle
  final Color backgroundColor;

  /// Custom widget list passed to render circular images
  final List<Widget> children;

  /// Radius for the circular image to applied when [children] is passed
  final double? widgetRadius;

  /// Count of the number of widget to be shown as circular images when [children]
  /// is passed
  final int? widgetCount;

  /// Optional field to set the circular border width when [children] is passed
  final double? widgetBorderWidth;

  /// Optional field to set the color of circular border when [children] is passed
  final Color? widgetBorderColor;

  /// To show the remaining count if the provided list size is less than [totalCount]
  final bool showTotalCount;

  /// Creates a image stack widget.
  ///
  /// The [imageList] and [totalCount] parameters are required.
  StackedAvatars({
    Key? key,
    required this.imageList,
    this.imageRadius = 25,
    this.imageCount = 3,
    required this.totalCount,
    this.imageBorderWidth = 2,
    this.imageBorderColor = Colors.transparent,
    this.showTotalCount = true,
    this.extraCountTextStyle = const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w600,
    ),
    this.extraCountBorderColor,
    this.backgroundColor = Colors.white,
  })  : children = <Widget>[],
        widgetBorderColor = imageBorderColor,
        widgetBorderWidth = imageBorderWidth,
        widgetCount = null,
        widgetRadius = imageRadius,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    List<dynamic> items = List<dynamic>.from(imageList)..addAll(children);
    int size =
        min(children.isNotEmpty ? widgetCount! : imageCount!, items.length);
    List<Padding> widgetList = items
        .sublist(0, size)
        .asMap()
        .map((int index, dynamic value) => MapEntry<int, Padding>(
            index,
            Padding(
              padding: EdgeInsets.only(left: 0.7 * imageRadius! * index),
              child: circularItem(value ?? const Icon(TablerIcons.user)),
            )))
        .values
        .toList()
        .reversed
        .toList();

    return Container(
      child: widgetList.isNotEmpty
          ? Stack(
              clipBehavior: Clip.none,
              children: widgetList
                ..add(
                  Padding(
                    padding: EdgeInsets.only(
                        left: widgetList.length >= 3
                            ? 0.7 * imageRadius! * 3
                            : 0),
                    child: showTotalCount && totalCount - widgetList.length > 0
                        ? Container(
                            constraints: BoxConstraints(
                                minWidth: imageRadius! - imageBorderWidth!),
                            padding: const EdgeInsets.all(3),
                            height: (imageRadius! - imageBorderWidth!),
                            width: (imageRadius! - imageBorderWidth!),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    imageRadius! - imageBorderWidth!),
                                border: Border.all(
                                    color: extraCountBorderColor ??
                                        imageBorderColor!,
                                    width: imageBorderWidth!),
                                color: Colors.transparent),
                            child: Center(
                              child: Text(
                                '+${totalCount - widgetList.length}',
                                textAlign: TextAlign.center,
                                style: extraCountTextStyle,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
            )
          : const SizedBox(),
    );
  }

  Widget circularItem(dynamic item) {
    if (item is Widget) {
      return circularWidget(item);
    } else if (item is String) {
      return circularImage(item);
    }
    return Container();
  }

  Container circularWidget(Widget widget) {
    return Container(
      height: widgetRadius,
      width: widgetRadius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor.withOpacity(0.5),
        border: Border.all(
          color: widgetBorderColor ?? imageBorderColor!,
          width: widgetBorderWidth ?? imageBorderWidth!,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widgetRadius ?? imageRadius!),
        child: widget,
      ),
    );
  }

  Widget circularImage(String imageData) {
    return Container(
      height: imageRadius,
      width: imageRadius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor.withOpacity(0.5),
        border: Border.all(
          color: imageBorderColor!,
          width: imageBorderWidth!,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: MemoryImage(Base2e15.decode(imageData)),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
