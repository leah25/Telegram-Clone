import 'package:flutter/material.dart';

circularProgress() {
  return CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade800),
  );
}

linearProgress() {
  return LinearProgressIndicator(
    valueColor: AlwaysStoppedAnimation(Colors.blue.shade800),
  );
}
