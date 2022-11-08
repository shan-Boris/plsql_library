// WORK FOR https://www.labirint.ru/

function cutStr(str) {
    return str.split(': ')[1]
}

function cutSummary(summary) {
    return summary.length > 900 ? summary.slice(0,887) + '...' :
    summary;
}

const title = cutStr(document.querySelector('h1').textContent);
const SUMMARY = cutSummary(document.querySelector('noindex').textContent);

const YEAR_OF_PUBLICATION = +document.querySelector('.publisher').textContent.slice(-7, -3);
const PUBLISHER = document.querySelector('.publisher').textContent.split(': ')[1].split(',')[0];
const author = cutStr(document.querySelector('.authors').textContent).split(' ');
const firstName = author[1];
const lastName = author[0];
const fatherName = author[2] || '';
const price = +document.querySelector('.buying-pricenew-val-number').textContent;

const genre = document.querySelector('#thermometer-books').lastChild.previousSibling.textContent;

console.log(
`
-----------------------------------------


INSERT INTO PUBLISHER (PUBLISHER)
VALUES
('${PUBLISHER}');

INSERT INTO BOOK (
    TITLE,
    SUMMARY,
    YEAR_OF_PUBLICATION,
    AGE_LIMIT,
    PRICE,
    ID_PUBLISHER,
    ID_BOOK_TYPE
  )
VALUES
(
    '${title}',
    '${SUMMARY}',
    ${YEAR_OF_PUBLICATION},
    3,
    ${price},
    (
    SELECT ID FROM PUBLISHER 
    WHERE PUBLISHER = '${PUBLISHER}'
    ),
    (SELECT ID FROM BOOK_TYPE 
    WHERE TYPE = 'Книга')
    );
    
INSERT INTO GENRE (GENRE)
VALUES
('${genre}');


INSERT INTO AUTHOR (FIRST_NAME, LAST_NAME, FATHER_NAME)
VALUES 
('${firstName}', '${lastName}', '${fatherName}');

INSERT INTO BOOK_HAVE_GENRE(ID_GENRE, ID_BOOK)
VALUES
((SELECT ID FROM GENRE 
    WHERE GENRE = '${genre}'),
(SELECT ID FROM BOOK 
    WHERE ID = (SELECT COUNT(*) FROM BOOK))  );

INSERT INTO AUTHOR_WROTE_BOOK (ID_AUTHOR, ID_BOOK)
VALUES
((SELECT ID FROM AUTHOR 
    WHERE FIRST_NAME = '${firstName}' AND LAST_NAME = '${lastName}'),
(SELECT ID FROM BOOK 
    WHERE ID = (SELECT COUNT(*) FROM BOOK))  );
    `
    
    
      )
    


