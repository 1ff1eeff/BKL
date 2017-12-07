;#RequireAdmin

;Для определения имени полей и кнопок используем "Autoit Window Info x86"
;распологается по адресу C:\Program Files (x86)\AutoIt3\Au3Info.exe
$exeName	= "keygen.exe"
$mainFrame  = "Генератор ключа" ;класс или заголовок окна приложения создающего ключи
$textBox1 	= "[NAME:textBox1]" ;имена текстовых полей ввода
$textBox2 	= "[NAME:textBox2]" ;имена текстовых полей ввода
$genBtnText = "Создать ключ"	;надпись на кнопке генерации ключа
$genBtnName = "[NAME:button1]"	;имя кнопки генерации ключа
$someNumber = "301800" 			;какое-то число
$orgName 	= "Pochtamt" 		;название организации
$keyFile	= "keyfile"			;имя файла с ключом
$archName	= "archKey.exe"		;имя для будущего sfx-архива
$programDir	= "new" ;каталог назначения для архива с ключом

;Скрипт принимает параметры командной строки в формате " -аргумент "значение аргумента" "
;Например строка запуска для значений по умолчанию во время написания скрипта
;Script.exe -exeName keygen.exe -mainFrame "Генератор ключа" -textBox1 [NAME:textBox1] -textBox2 [NAME:textBox2]
;			-genBtnText "Создать ключ" -genBtnName [NAME:button1] -someNumber 301832 -orgName Pochtamt -keyFile keyfile
;			-archName archKey.exe -programDir C:\Users\1ff1e\Desktop\autoit\new

For $i = 1 To $CmdLine[0]
   Switch $CmdLine[$i]
    Case "-exeName"
      $exeName 		= $CmdLine[$i+1]
    Case "-mainFrame"
      $mainFrame 	= $CmdLine[$i+1]
    Case "-textBox1"
      $textBox1 	= $CmdLine[$i+1]
    Case "-textBox2"
      $textBox2 	= $CmdLine[$i+1]
    Case "-genBtnText"
      $genBtnText 	= $CmdLine[$i+1]
    Case "-genBtnName"
      $genBtnName 	= $CmdLine[$i+1]
    Case "-someNumber"
      $someNumber 	= $CmdLine[$i+1]
    Case "-orgName"
      $orgName 		= $CmdLine[$i+1]
    Case "-keyFile"
      $keyFile 		= $CmdLine[$i+1]
    Case "-archName"
      $archName 	= $CmdLine[$i+1]
    Case "-programDir"
      $programDir	= $CmdLine[$i+1]
   EndSwitch
Next

;Запуск генератора - указать имя (и адрес если не в рабочей папке)!
Run($exeName)
   ;Отключаем ввод с клавиатуры и мыши
   BlockInput(1)
   ;Запускаем генератор ключа
   $hWnd = WinWait($mainFrame, "", 1)
   If Not $hWnd Then
	  BlockInput(0)
		 MsgBox(0, 'Внимание!', "Кейген не найден!")
	  Exit
   EndIf
   ;Вводим данные в текстовые поля
   ControlSend($hWnd, "", $textBox1, $someNumber)
   ControlSend($hWnd, "", $textBox2, $orgName)
   ;Жмем генерацию
   ControlClick($hWnd, $genBtnText, $genBtnName)
   ;Закрытие
   WinClose($hWnd)
   ;Создаём sfx-архив
   ;Требуются файлы 7z.sfx и 7za.exe в папке скрипта
   RunWait(@ComSpec & " /c " & "7za.exe a -sfx7z.sfx " & $archName & " " & $keyFile)
   If FileExists($programDir) Then
	  FileCopy($archName, $programDir & "\*.*") ;Копируем полученый архив в папку программы
	  FileDelete ($archName)					;и удаляем его из рабочей папки
	  FileDelete ($keyFile)						;также удаляем файл ключа из рабочей папки
   Else
	  DirCreate($programDir)					;Создаём каталог если его нет по указанному адресу
	  FileCopy($archName, $programDir & "\*.*") ;Копируем полученый архив в папку программы
	  FileDelete ($archName)					;и удаляем его из рабочей папки
	  FileDelete ($keyFile)						;также удаляем файл ключа из рабочей папки
   EndIf

   ;Возвращаем ввод с клавиатуры и мыши(необязательно)
   ;BlockInput(0)
Exit