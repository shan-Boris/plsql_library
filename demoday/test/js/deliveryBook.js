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
            :EXEMPLAR_ID := book_pkg.get_book(
                    id_client$ => 7,
                    title$ => 'Приключения Тома Сойера',
                    issuer$ => 'Лабиринт'
                );
            END;`,
            {
                EXEMPLAR_ID: {dir: oracledb.BIND_OUT, type: oracledb.NUMBER}
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