import 'package:flutter/material.dart';

class CommonFutureWidget<T> extends StatelessWidget {
  final Future<T> future;
  final Widget Function(T) getContentView;
  const CommonFutureWidget(
      {super.key, required this.future, required this.getContentView});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
        if (snapshot.hasData) {
          return getContentView(snapshot.data!);
        } else if (snapshot.hasError) {
          return Wrap(children: <Widget>[
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text('Error: ${snapshot.error}'),
            ),
          ]);
        } else {
          return Wrap(children: const <Widget>[
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text('Awaiting result...'),
            ),
          ]);
        }
      },
    );
  }
}
