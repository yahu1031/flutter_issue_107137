import 'package:at_base2e15/at_base2e15.dart';
import 'package:flutter/material.dart';
import 'package:tabler_icons/tabler_icons.dart';

import '../models/connection.model.dart';
import 'fade_anim.dart';
import 'globals.dart';

class AnimatedConnectionTile extends StatefulWidget {
  const AnimatedConnectionTile({
    Key? key,
    required Connection connection,
    required int index,
    this.onTap,
  })  : _connection = connection,
        _index = index,
        super(key: key);

  final Connection _connection;
  final int _index;
  final GestureTapCallback? onTap;

  @override
  State<AnimatedConnectionTile> createState() => _AnimatedConnectionTileState();
}

class _AnimatedConnectionTileState extends State<AnimatedConnectionTile> {
  bool stared = false;
  @override
  Widget build(BuildContext context) {
    return FadeAnimation(
      delay: widget._index * 0.15,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 2,
                  offset: const Offset(0, 5),
                ),
              ],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    widget._connection.profilePicture?.value!.value == null
                        ? const SizedBox.square(
                            dimension: 50,
                            child: Icon(
                              TablerIcons.user,
                              size: 30,
                            ),
                          )
                        : CircleAvatar(
                            maxRadius: 25,
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.transparent,
                            foregroundImage:
                                widget._connection.profilePicture == null
                                    ? null
                                    : MemoryImage(
                                        Base2e15.decode(
                                          widget._connection.profilePicture!
                                              .value!.value,
                                        ),
                                      ),
                            backgroundImage:
                                widget._connection.profilePicture == null
                                    ? null
                                    : MemoryImage(
                                        Base2e15.decode(
                                          widget._connection.profilePicture!
                                              .value!.value,
                                        ),
                                      ),
                          ),
                    const HSpacer(20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget._connection.tags!['nickName'] ?? '',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          widget._connection.atSign!,
                          style: Theme.of(context).textTheme.caption,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      stared = !stared;
                    });
                  },
                  icon: Icon(
                    stared ? Icons.star : TablerIcons.star, // Icon
                    color: stared ? Colors.orange : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
