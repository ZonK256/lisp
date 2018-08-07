(defun c:zud(/ NR FILE_NAME FILE FONT_SIZE LINE old_cmdecho)
	(setq old_cmdecho (getvar "CMDECHO"))
	(setvar "CMDECHO" 0)	
	(setq NR 1 FONT_SIZE 1.5 LINE "t")
	(princ (strcat "Domyslne wartosci dla: pierwszego punktu <" (rtos NR)  ">, rozmiaru tekstu <" (rtos FONT_SIZE) "> i oznaczenia lacza <" LINE ">. "))
	(setq DEFAULT (getstring "Zachowac domyslne wartosci? <T> [T/N]"))
		(if (or (= DEFAULT "N") (= DEFAULT "n")) 
			(progn
				(initget (+ 8 8 4))
				(setq NR (getint "Podaj numer pierwszego punktu: "))
				(setq FONT_SIZE (getreal "Podaj rozmiar tekstu:"))
				(setq LINE (getstring "Podaj oznaczenie lacza:"))			
			)
		)
	(setq FILE_NAME (getfiled "Wpisz nazwe pliku" "" "txt;csv;xls" 1))
	(if (= NR nil) (setq NR 1))
	(if (= FONT_SIZE nil) (setq FONT_SIZE 3))
	(if (= LINE "") (setq LINE "t"))	
	(setq FILE (open FILE_NAME "A"))
	(setq I 0)
	(write-line (strcat "Nr  Y 		X" ) FILE)
	(while
		(setq MARK_POINT (getpoint (strcat "Wskaz punkt " (rtos NR 2 0)) ))
		(setq COORD_Y (RTOS (cadr MARK_POINT) 2 2))
		(setq COORD_X (RTOS (car MARK_POINT) 2 2))
		(setq COORDS
			(if (< NR 10) 
			(strcat (rtos NR)".  " COORD_Y ",  " COORD_X " 	" LINE )
			(strcat (rtos NR) ". " COORD_Y ",  " COORD_X " 	" LINE )
			)
		)
		(write-line COORDS FILE)
		(DRAW_GUIDE)
		(setq NR (1+ NR))
		(setq I (1+ I))
	)
	(close FILE)
	(setvar "CMDECHO" old_cmdecho)
(EXIT)
)

(defun DRAW_TEXT (/ mark_text p)
	(setq mark_text (strcat (rtos NR 2 0) LINE))
	(command "_layer" "_m" "zud-nr" "_c" "7" "" "")
	(command "_text" MARK_POINT FONT_SIZE "0" mark_text)
	(setq p MARK_POINT)
	(command "_textmask" p "")
)	

(defun EXIT ()
(princ (strcat "\nKoniec, wskazano punktow: " (rtos I)) )
(princ)
)

(defun DRAW_GUIDE (/ d p1 p2 p3)
	(command "_layer" "_m" "zud-linie" "_c" "7" "" "")
	(setq d  (* 2 FONT_SIZE))
	(setq p1 MARK_POINT)
	(setq p2 (getpoint p1 "Wskaz koniec linii pomocniczej:"))
	(if (> (car p1) (car p2) )
		(progn
				(setq p3 (polar p2 pi d))
				(setq MARK_POINT (list (+ (car p3)(/ d 5)) (cadr p3)  ))
		)
		(progn
				(setq p3 (polar p2 0 d))
				(setq MARK_POINT (list (- (car p3)(/ d 1.1)) (cadr p3)  ))
		)
	)
	(command "_line" p1 p2 "")
	(command "_line" p2 p3 "")
	(DRAW_TEXT)
	;(command "group" "create" "*" "" g1 g2 "")
)


;|
TODO
>>>	 text background
>>>	 file append
>	 guide grouping
>		


(defun DRAW_POINT (/)d ang_90 ang_270 p1 p2 p3 p4)
	(command "_layer" "_m" "zud-pk" "_c" "7" "" "")
	(setq d (/ FONT_SIZE 3))
	(setq ang_90 (/ pi 2))
	(setq ang_270 (* 3 ang_90))
	(setq p1 (polar MARK_POINT ang_90 d))
	(setq p2 (polar MARK_POINT ang_270 d))
	(setq p3 (polar MARK_POINT 0 d))
	(setq p4 (polar MARK_POINT pi d))
	(command "_osmode" "0" "")
	(command "_line" p1 p2 "")
	(command "_line" p3 p4 "")
)
|;
(princ (strcat "ZUD") ) 