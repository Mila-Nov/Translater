import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
void main() {
  runApp(const CatTranslatorApp());
}
class User {
  final String login;
  final String password;
//первый и последний раз = final
  //String - наша строка
//конструктор пользователя
  User({
    required this.login,
    required this.password,
    //required - обязательность заполнения
  });
}
class CatTranslatorApp extends StatefulWidget {
  const CatTranslatorApp({super.key});

  @override
 
State<CatTranslatorApp> createState() => _CatTranslatorAppState();
}

class _CatTranslatorAppState extends State<CatTranslatorApp> {
  final List<User> users = [];
  User? currentUser;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: currentUser == null
          ? LoginPage(
              users: users,
              onLogin: (user) {
                setState(() {
                  currentUser = user;
                });
              },
            )
          : CatTranslatorScreen(
              user: currentUser!,
              onLogout: () {
                setState(() {
                  currentUser = null;
                });
              },
            ),
    );
  }
}

class CatTranslatorScreen extends StatefulWidget {
  final User user;
  final VoidCallback onLogout;

  const CatTranslatorScreen({
    super.key,
    required this.user,
    required this.onLogout,
  });
  
@override
  State<CatTranslatorScreen> createState()=>_CatTranslatorScreen();}
class _CatTranslatorScreen extends State<CatTranslatorScreen>
{
  
  String StatusText='Нажми кнопку записи';
  String Translate='Перевод здесь';
  // Timer? означает: здесь может лежать таймер,
// а может быть null, если таймер еще не создан.
Timer? timer;
// Создаем генератор случайных чисел.
// Он будет помогать делать волну живой и непредсказуемой.
final Random random = Random();
// detectedMood - настроение, которое "нашел ИИ".
// Сначала настроение неизвестно, потому что анализ еще не запускали.
String detectedMood = 'неизвестно';

// detectedTone - тон кошачьего звука.
// Например: низкий, средний, высокий.
String detectedTone = 'неизвестно';

// detectedVolume - громкость звука.
// Например: тихий, обычный, громкий.
String detectedVolume = 'неизвестно';
 List<String>history = [];
// confidence - уверенность "ИИ" в процентах.
// int значит целое число.
int confidence = 0;
  List<String> moods = ['сонная','голодная','игривая','сердитая'];
  List<String> tones = ['тёплый','дружелюбный','холодный'];
  List<String> volumes = ['громкий','тихий','обычный'];
  Map<String,List<String>> translationsByMood = {
    'сонная': [
    'Не трогай меня, я почти сплю.',
    'Я проснулась только чтобы напомнить, что я главная.',
    'Сделай потише, у меня важный сон.',
  ],
'голодная': [
    'Моя миска выглядит подозрительно пустой.',
    'Человек, пора открыть пакетик с кормом.',
    'Я не драматизирую. Я действительно голодная.',
  ],

  'игривая': [
    'Давай играть прямо сейчас.',
    'Я спрятала энергию в лапах.',
    'Беги за игрушкой, человек.',
  ],
 'сердитая': [
    'Я сейчас не в настроении для переговоров.',
    'Отойди на безопасное расстояние.',
    'Это моя территория. И диван тоже мой.',
  ],
  };
// wave - список высот столбиков звуковой волны.
// List<double> значит: список чисел с дробной частью.
// List.generate создает список автоматически.
// 18 - количество столбиков.
// (index) => 20 значит: каждый столбик сначала высотой 20.
List<double> wave = List.generate(18, (index) => 20);
// isAnalyzing показывает, идет ли сейчас анализ.
// false - анализ не идет.
// true - анализ идет.
bool isAnalyzing = false;

// progress - прогресс анализа.
// 0 означает 0%, 1 означает 100%.
double progress = 0;
  void startRecording(){
    setState((){
      StatusText='Слушаю';
   Translate='Анализирую'; 
       isAnalyzing = true;
      progress = 0;
    });
  
  // Timer.periodic запускает код снова и снова.
  // Здесь код будет запускаться каждые 200 миллисекунд.
  timer = Timer.periodic(const Duration(milliseconds: 200), (Timer timer) {
    // Каждый "тик" таймера обновляет экран.
    setState(() {
      // Увеличиваем прогресс на 0.05.
      // Если было 0.20, станет 0.25.
      progress = progress + 0.05;// Пересоздаем список высот для волны.
  // Каждый раз получаются новые случайные высоты,
  // поэтому столбики будто двигаются.
  wave = List.generate(22, (index) {
    // random.nextInt(70) дает случайное целое число от 0 до 69.
    // 12 + ... нужно, чтобы столбик никогда не был совсем нулевым.
    // toDouble() превращает целое число в double,
    // потому что высота AnimatedContainer ожидает double.
    return 12 + random.nextInt(70).toDouble();
    });
});
    // Проверяем: дошел ли прогресс до конца.
    if (progress >= 1) {
      // Останавливаем таймер, чтобы он не работал бесконечно.
      timer.cancel();
finishAnalysis();
    }
  });
}
  // finishAnalysis запускается, когда прогресс дошел до конца.
// Эта функция делает финальный "AI-результат".
void finishAnalysis() {
  // Выбираем случайное настроение из списка moods.
  final String mood = moods[random.nextInt(moods.length)];

  // Выбираем случайный тон из списка tones.
  final String tone = tones[random.nextInt(tones.length)];

  // Выбираем случайную громкость из списка volumes.
  final String volume = volumes[random.nextInt(volumes.length)];

  // Берем список переводов, подходящий под выбранное настроение.
  // Например, если mood = 'голодная',
  // то possibleTranslations будет списком голодных переводов.
  final List<String> possibleTranslations = translationsByMood[mood]!;

  // Выбираем один случайный перевод из подходящего списка.
  final String finalTranslation =
      possibleTranslations[random.nextInt(possibleTranslations.length)];
 String historyItem = 'перевод - $finalTranslation Настроение☺️ - $mood громкость - $volume тон - $tone';
  // Обновляем экран финальными результатами анализа.
  setState(() {
    // Анализ больше не идет.
    isAnalyzing = false;

    // Прогресс полный.
    progress = 1;
history.insert(0,historyItem);
    // Статус под кошкой.
    StatusText = 'Перевод готов';

    // Показываем найденное настроение.
    detectedMood = mood;

    // Показываем найденный тон.
    detectedTone = tone;

    // Показываем найденную громкость.
    detectedVolume = volume;

    // Уверенность будет от 82 до 98.
    // random.nextInt(17) дает число от 0 до 16.
    // 82 + это число = 82...98.
    confidence = 82 + random.nextInt(17);

    // Показываем финальный перевод.
    Translate = finalTranslation;
  });
}
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F3EA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 8),
                const Text(
                  'Переводчик с языка животных',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                const Text(
                  'прототип перевода кошачьей речи',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child:  Column(
                    children: [
                      Text(
                        '🐱',
                        style: TextStyle(fontSize: 76),
                      ),
                      SizedBox(
  height: 86,

  // Row ставит столбики в ряд слева направо.
  child: Row(
    // Центрируем волну по горизонтали.
    mainAxisAlignment: MainAxisAlignment.center,

    // Центрируем столбики по вертикали внутри области высотой 86.
    crossAxisAlignment: CrossAxisAlignment.center,

    // wave.map берет каждую высоту из списка wave
    // и превращает ее в AnimatedContainer.
    children: wave.map((height) {
      // Один столбик звуковой волны.
      return AnimatedContainer(
        // Длительность анимации изменения высоты.
        // Благодаря этому столбик меняется плавно, а не резко.
        duration: const Duration(milliseconds: 160),

        // Ширина одного столбика.
        width: 7,

        // Высота столбика приходит из списка wave.
        height: height,

        // Отступы слева и справа между столбиками.
        margin: const EdgeInsets.symmetric(horizontal: 3),

        // Внешний вид столбика.
        decoration: BoxDecoration(
          // Если идет анализ, волна синяя.
          // Если анализ не идет, волна фиолетовая.
          color: isAnalyzing
              ? const Color(0xFF5B8CFF)
              : const Color(0xFF7A5CFF),

          // Скругляем столбики, чтобы они были похожи на аудио-волну.
          borderRadius: BorderRadius.circular(20),
        ),
      );
    // map возвращает Iterable, а Row нужны children в виде List.
    // Поэтому в конце пишем .toList().
    }).toList(),
  ),
),
                      SizedBox(height: 12),
                      Text(
                        StatusText,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      LinearProgressIndicator (
                      value:progress,
                        minHeight:8,
                        borderRadius:BorderRadius.circular(20)
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: startRecording,
                    child: const Text('Записать мяу'),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                children:[
                  Expanded(
                  child:InfoBox(
                  title:'настроение',
                    value:detectedMood
                  ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                  child:InfoBox(
                  title:'громкость',
                    value:detectedVolume
                  ),
                  ),
                ],
                ),
                                const SizedBox(height: 18),
                Row(
                children:[
                  Expanded(
                  child:InfoBox(
                  title:'тон',
                    value:detectedTone
                  ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                  child:InfoBox(
                  title:'уверенность',
                    value: '$confidence%',
                  ),
                  ),
                ],
                ),
                const SizedBox(height: 18),
                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(minHeight: 150),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFF202124),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child:  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Перевод',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        Translate,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                       OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HistoryPage(history: history),
                        ),
                      );
                    },
                    icon: const Icon(Icons.history),
                    label: const Text('История'),
                  ),
                    ],
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
// InfoBox - наш собственный виджет.
// Он нужен, чтобы не писать четыре одинаковые карточки вручную.
class InfoBox extends StatelessWidget {
  // Конструктор InfoBox.
  // Чтобы создать карточку, нужно передать title и value.
  const InfoBox({
    super.key,

    // required значит: это обязательный параметр.
    // Без title карточку создать нельзя.
    required this.title,

    // value тоже обязателен.
    required this.value,
  });

  // title - маленький заголовок карточки.
  // Например: "Настроение".
  final String title;

  // value - главное значение карточки.
  // Например: "голодная".
  final String value;

  @override
  Widget build(BuildContext context) {
    // Возвращаем белую карточку.
    return Container(
      // Внутренние отступы карточки.
      padding: const EdgeInsets.all(14),

      // Внешний вид карточки.
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),

      // Внутри карточки два текста сверху вниз.
      child: Column(
        // Прижимаем тексты к левому краю.
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Маленький серый заголовок.
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
            ),
          ),

          // Отступ между заголовком и значением.
          const SizedBox(height: 6),

          // Главное значение карточки.
          Text(
            value,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
class HistoryPage extends StatelessWidget{
  
  final List< String > history;
  const HistoryPage({
    super.key,
    required this.history,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('История переводов 📜'),
      ),
      body: history.isEmpty
          ? const Center(
              child: Text(
                'История пока пустая',
                style: TextStyle(fontSize: 22),
              ),
            )
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.star),
                  title: Text(history[index]),
                );
              },
            ),
    );
  }
}
