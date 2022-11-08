const oracledb = require('oracledb');
oracledb.outFormat = oracledb.OUT_FORMAT_OBJECT;
oracledb.autoCommit = true;

async function fun() {
    let con;

    try{
        con = await oracledb.getConnection( {
            user        : "TEST",
            password    : "123",
            connectString: "localhost:1522/XEPDB1"
        });

        await con.execute(
            `BEGIN
            DBMS_OUTPUT.ENABLE(NULL);
            :BOOK_ID$ := book_pkg.create_book(
                amount_books  => 1,
                issuer => 'Издательство',
                title => 'Название',
                summary => 'Содержание',
                year_of_publication => 2022,
                age_limit => 5,
                price => 500,
                book_type => 'Книга',
                a_first_names => book_pkg.a_first_name('Мишель', 'Хелен'),
                a_last_names => book_pkg.a_last_name('Бюсси', 'Скейлз'),
                a_father_names => book_pkg.a_father_name(' ', ' '),
                tags => book_pkg.tag('человека', 'Два', 'найти', 'вечный'),
                genres => book_pkg.genre('Религии мира')
                );
            END;`,
            {
                BOOK_ID$: {dir: oracledb.BIND_OUT, type: oracledb.NUMBER}
            }   
        );
        let result;
        do {
        result = await con.execute(
            `BEGIN
            DBMS_OUTPUT.GET_LINE(:ln, :st);
            END;`,
            { ln: { dir: oracledb.BIND_OUT, type: oracledb.STRING, maxSize: 32767 },
            st: { dir: oracledb.BIND_OUT, type: oracledb.NUMBER }
            }
        );
        if (result.outBinds.st === 0)
            console.log(result.outBinds.ln);
        } while (result.outBinds.st === 0);
    
    } catch (err) {
        console.error(err);
        
    }
}
fun();