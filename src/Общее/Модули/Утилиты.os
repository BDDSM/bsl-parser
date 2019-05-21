///////////////////////////////////////////////////////////////////
//
// Служебный модуль, содержащий различные вспомогательные методы
//
// (с) BIA Technologies, LLC	
//
///////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////
// Программный интерфейс
///////////////////////////////////////////////////////////////////

// Читает текст из файла
//
// Параметры:
//   ИмяФайла - Строка - Путь к файлу
//
//  Возвращаемое значение:
//   Строка - Содержимое файла
//
Функция ПрочитатьФайл(ИмяФайла) Экспорт

	ТекстовыйДокумент = Новый ТекстовыйДокумент();
	ТекстовыйДокумент.Прочитать(ИмяФайла, КодировкаТекста.UTF8NoBOM);
	СодержимоеФайла = ТекстовыйДокумент.ПолучитьТекст();
	
	Возврат СодержимоеФайла;
	
КонецФункции

// Записывает текст в файл
//
// Параметры:
//   ИмяФайла - Строка - Путь к файлу
//   Текст - Строка - Записываемый текст
//
Процедура ЗаписатьФайл(ИмяФайла, Текст) Экспорт
	
	Запись = Новый ЗаписьТекста(ИмяФайла, КодировкаТекста.UTF8NoBOM);
	Запись.Записать(Текст);
	
	Запись.Закрыть();
	
КонецПроцедуры

// Создает все необходимы каталоги по пути
//
// Параметры:
//   Путь - Строка - Путь к каталогу
//
Процедура СоздатьРекурсивноКаталоги(Путь) Экспорт
	
	Файл = Новый Файл(Путь);
	
	Если НЕ Файл.Существует() Тогда
		
		СоздатьРекурсивноКаталоги(Файл.Путь);
		СоздатьКаталог(Путь);
		
	КонецЕсли;

КонецПроцедуры

// Разбивает строку на подстроки и обрезает пробелы справа и слева
//
// Параметры:
//   Строка - Строка - Обрабатываемая строка
//   Разделитель - Строка - Разделитель подстрок
//
//  Возвращаемое значение:
//   Массив - Коллекция подстрок
//
Функция СтрРазделитьСОбрезкойПробелов(Строка, Разделитель) Экспорт
	
	Результат = Новый Массив();
	
	Для Каждого Стр Из СтрРазделить(Строка, Разделитель) Цикл
		
		Результат.Добавить(СокрЛП(Стр));
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Выполняет проверку содержит ли переменная свойство
//
// Параметры:
//   Переменная - Произвольный - Проверяемый объект
//   Свойство - Строка - Имя свойства объекта
//
//  Возвращаемое значение:
//   Булево - Признак, есть ли свойство у переменной
//
Функция ПеременнаяСодержитСвойство(Переменная, Свойство) Экспорт
	
	Токен = Новый УникальныйИдентификатор();
	
	ПроверочнаяСтруктура = Новый Структура(Свойство, Токен);
	
	ЗаполнитьЗначенияСвойств(ПроверочнаяСтруктура, Переменная);
	
	Возврат ПроверочнаяСтруктура[Свойство] <> Токен;
	
КонецФункции

// Считывает таблицу из файла Markdown
//
// Параметры:
//   Чтение - ЧтениеТекст - Поток чтения
//
//  Возвращаемое значение:
//   ТаблицаЗначений- Считанные данные
//
Функция ПрочитатьТаблицуMarkdown(Чтение) Экспорт
	
	ЗаголовокЗагружен = Ложь;
	ТаблицаДанных = Новый ТаблицаЗначений();

	Строка = Чтение.ПрочитатьСтроку();

	Пока Строка = "" Цикл
		
		Строка = Чтение.ПрочитатьСтроку();
		
	КонецЦикла;
	
	Пока Истина Цикл
		
		Если Строка = Неопределено Тогда
			
			Прервать;
			
		КонецЕсли;
		
		Если НЕ СтрНачинаетсяС(Строка, "|") Тогда
			
			Прервать;
			
		КонецЕсли;
		
		ЧастиСтроки = СтрРазделить(Строка, "|");
		
		Если НЕ ЗаголовокЗагружен Тогда

			Для Инд = 1 По ЧастиСтроки.ВГраница() Цикл

				ТаблицаДанных.Колонки.Добавить(СокрЛП(ЧастиСтроки[Инд]));
				
			КонецЦикла;
			
			ЗаголовокЗагружен = Истина;
			Чтение.ПрочитатьСтроку();
			
		Иначе

			ЧастиСтроки = СтрРазделить(Строка, "|");
			
			СтрокаДанных = ТаблицаДанных.Добавить();

			Для Инд = 1 По ЧастиСтроки.ВГраница() Цикл
				
				СтрокаДанных[Инд - 1] = СокрЛП(ЧастиСтроки[Инд]);
				
			КонецЦикла;
			
		КонецЕсли;
				
		Строка = Чтение.ПрочитатьСтроку();

	КонецЦикла;

	Возврат ТаблицаДанных;

КонецФункции

// Выполняет поиск заголовка по файлу описаний Markdown
//
// Параметры:
//   Чтение - ЧтениеТекст - Поток чтения
//   ТекстЗаголовка - Строка - Текст заголовка
//
//  Возвращаемое значение:
//   Строка - Текст найденного заголовка
//
Функция НайтиСледующийЗаголовокMarkdown(Чтение, ТекстЗаголовка = Неопределено) Экспорт
	
	Если ТекстЗаголовка = Неопределено Тогда
		
		СтрокаПоиска = "#";

	Иначе
		
		СтрокаПоиска = ТекстЗаголовка;
		
	КонецЕсли;
	
	Пока Истина Цикл // Позиционируемся на нужную строку
		
		Строка = Чтение.ПрочитатьСтроку();
		
		Если Строка = Неопределено Тогда
			
			Прервать;
			
		КонецЕсли;
		
		Если СтрНачинаетсяС(Строка, СтрокаПоиска) Тогда
			
			Возврат Строка;
			
		КонецЕсли;

	КонецЦикла;
	
КонецФункции

// Каталог макетов приложения
//
//  Возвращаемое значение:
//   Строка - Путь до макетов
//
Функция КаталогМакеты() Экспорт
	
	Возврат ОбъединитьПути(ТекущийСценарий().Каталог, "..", "..", "Макеты");
	
КонецФункции

///////////////////////////////////////////////////////////////////
// Служебный функционал
///////////////////////////////////////////////////////////////////
