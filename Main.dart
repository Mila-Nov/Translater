import 'package:flutter/material.dart';
import 'dart:async';
void main() {
  runApp(const CatTranslatorApp());
}

class CatTranslatorApp extends StatelessWidget {
  const CatTranslatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const CatTranslatorScreen(),
    );
  }
}

class CatTranslatorScreen extends StatefulWidget {
  const CatTranslatorScreen({super.key});
@override
  State<CatTranslatorScreen> createState()=>_CatTranslatorScreen();}
class _CatTranslatorScreen extends State<CatTranslatorScreen>
{
  
  String StatusText='Нажми кнопку записи';
  String Translate='Перевод здесь';
  // Timer? означает: здесь может лежать таймер,
// а может быть null, если таймер еще не создан.
Timer? timer;

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
      progress = progress + 0.05;
    });

    // Проверяем: дошел ли прогресс до конца.
    if (progress >= 1) {
      // Останавливаем таймер, чтобы он не работал бесконечно.
      timer.cancel();

      // Финальное обновление экрана.
      setState(() {
        // Анализ закончился.
        isAnalyzing = false;

        // Фиксируем прогресс на 100%.
        progress = 1;

        // Показываем финальный статус.
        StatusText = 'Перевод готов';

        // Пока перевод простой. На следующих занятиях
        // мы заменим его на более умный случайный результат.
        Translate = 'Я требую вкусняшку.';
      });
    }
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
                      SizedBox(height: 12),
                      Text(
                        StatusText,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
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
