-- Ќайти книгу похожую на ранее прочитанную

SELECT DISTINCT 
    C.FIRST_NAME||' '||C.LAST_NAME||' '||C.FATHER_NAME AS CLIENT, 
    B.TITLE AS "ѕќ—Ћ≈ƒЌяя ѕ–ќ„»“јЌЌјя",  
    B2.TITLE AS –≈ ќћ≈Ќƒј÷»я
FROM LOG_DELIVERY_RETURN_BOOK DRB 
    JOIN CLIENT C 
        ON (C.ID = DRB.ID_CLIENT)
    JOIN BOOK B 
        ON (B.ID = DRB.ID_BOOK)
    JOIN BOOK_HAVE_TAG BHT
        ON B.ID = BHT.ID_BOOK,
    BOOK B2
    JOIN BOOK_HAVE_TAG BHT2
        ON B2.ID = BHT2.ID_BOOK
WHERE DRB.TAKE_BOOK = (
                SELECT 
                    MAX(TAKE_BOOK) 
                FROM LOG_DELIVERY_RETURN_BOOK DRB2 
                WHERE DRB.ID_CLIENT = DRB2.ID_CLIENT
                ) 
    AND B.TITLE <> B2.TITLE
    AND C.FIRST_NAME = '»горь' 
    AND C.LAST_NAME = 'ѕетров'
    AND BHT.ID_TAG = BHT2.ID_TAG
GROUP BY C.FIRST_NAME||' '||C.LAST_NAME||' '||C.FATHER_NAME, B.TITLE, B2.TITLE
ORDER BY C.FIRST_NAME||' '||C.LAST_NAME||' '||C.FATHER_NAME
FETCH FIRST 1 ROWS ONLY;
