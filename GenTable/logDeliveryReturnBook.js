
function random(min, max) {
    return min + Math.ceil(Math.random() * (max - min)) 
}

let req = '';
const ex_onHome = [];
let id_ex;

for(let i = 0; i < 70; i++) {
   const month = random(1, 12),
         day = random(1, 30);
    if(random(0,10) > 3) {
        req += `
    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        RETURN_BOOK, 
        RATING_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/${month}/01', 'yyyy/mm/dd'), 
        TO_DATE('2022/${month}/${day}', 'yyyy/mm/dd'),
        ${random(0, 10)},
        ${random(1, 20)},
        ${random(1, 560)});
    `
    } else {
        while(true) {
            id_ex = random(1, 560)
            if(!ex_onHome.includes(id_ex)) {
                ex_onHome.push(id_ex)
                break
            }
        }
        req += `
    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK, 
        ID_CLIENT, 
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE('2022/${month}/01', 'yyyy/mm/dd'), 
        ${random(1, 20)},
        ${id_ex});
    --меняем местоположение экземпляра
    UPDATE EXEMPLAR
    SET 
        ON_HOME = 1,
        ON_STORE = 0
    WHERE ID = ${id_ex};
`
    }
} 

console.log(req)
