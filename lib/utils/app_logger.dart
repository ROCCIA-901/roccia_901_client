import 'package:logger/logger.dart';

Logger get logger => Log.instance;

class Log extends Logger {
  // 기본 생성자가 생성 되는 것을 방지
  Log._()
      : super(
          // Use the default LogFilter (-> only log in debug mode)
          filter: null,
          // Use the PrettyPrinter to format and print log
          printer: PrettyPrinter(
            methodCount: 2, // Number of method calls to be displayed
            errorMethodCount:
                20, // Number of method calls if stacktrace is provided
            lineLength: 120, // Width of the output
            colors: true, // Colorful log messages
            printEmojis: true, // Print an emoji for each log message
            printTime: false, // Should each log print contain a timestamp
          ),
          // Use the default LogOutput (-> send everything to console)
          output: null,
        );
  static final instance = Log._();
}
