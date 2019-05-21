#Использовать "..\ГенераторОписаний"
#Использовать "..\Общее"

// Создает генератор для формирования описания расширения
//
// Параметры:
//   Формат - Строка - Формат описания
//   КаталогИсходниковРасширения - Строка - Каталог, в который записываются описания
//
//  Возвращаемое значение:
//   ГенераторРасширения - Объект для формирования описания
//
Функция СоздатьРасширение(Формат, КаталогИсходниковРасширения) Экспорт
	
	Генератор = Новый ГенераторРасширений(Формат, КаталогИсходниковРасширения);

	Возврат Генератор;

КонецФункции

// Создает структуру данных объекта
//
// Параметры:
//   ТипОбъекта - Строка - Тип объекта
//   Наименование - Строка - Имя объекта
//
//  Возвращаемое значение:
//   Структура - Пустышка описания объекта
//
Функция ПолучитьОписаниеОбъекта(ТипОбъекта, Наименование = Неопределено) Экспорт
	
	ОписаниеОбъекта = СтруктурыОписаний.СоздатьОбъект(ТипОбъекта, Наименование);
	
	Возврат ОписаниеОбъекта;
	
КонецФункции