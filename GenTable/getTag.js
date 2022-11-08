

document.querySelector('textarea').textContent = 
document.querySelector('#rb').click()


const tags = document.querySelector('div[style="margin-top: 6px; padding: 4px; border: 1px solid #F1EAE4"]').textContent.match(/[а-яА-Я]{3,}/g);

let requestss = '';

tags.forEach(v => {
    requestss += `INSERT INTO TAG (TAG)
    VALUES 
    ('${v}');
    
    INSERT INTO BOOK_HAVE_TAG(ID_TAG, ID_BOOK)
    VALUES
    ((SELECT ID FROM TAG 
        WHERE TAG = '${v}'),
    (SELECT COUNT(*) FROM BOOK)  );
    
    `
})
console.log(requestss)
