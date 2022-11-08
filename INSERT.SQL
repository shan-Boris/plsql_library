INSERT INTO BOOK_TYPE (
    TYPE
) VALUES (
    'Книга'
);

INSERT INTO BOOK_TYPE (
    TYPE
) VALUES (
    'Журнал'
);

INSERT INTO BOOK_TYPE (
    TYPE
) VALUES (
    'Газета'
);

INSERT INTO PUBLISHER (
    PUBLISHER
) VALUES (
    'Манн'
);

INSERT INTO BOOK (
    TITLE,
    SUMMARY,
    YEAR_OF_PUBLICATION,
    AGE_LIMIT,
    PRICE,
    ID_PUBLISHER,
    ID_BOOK_TYPE
) VALUES (
    'Книга радости. Как быть счастливым в меняющемся мире',
    'Два великих духовных лидера. Пять дней. Один вечный вопрос.В апреле 2015 года два самых радостных человека на свете - лауреаты Нобелевской премии Далай-лама и архиепископ Туту - встретились в Дхарамсале, чтобы отметить восьмидесятый день рождения Его Святейшества, оглянуться на прожитые годы, полные непростых испытаний, и найти ответ на вечный вопрос: как найти радость в жизни, когда нас обуревают повседневные невзгоды - от недовольства дорожными пробками до страха, что мы не сможем обеспечить семью, от злости на тех, кто несправедливо с нами обошелся, до горя утраты любимого человека, от опустошенности, которую приносит тяжелая болезнь, до бездны отчаяния, приходящей со смертью?Диалоги велись в течение недели. Духовные мастера обсуждали препятствия, которые мешают нам радоваться жизни, подробно проговаривали негативные эмоции, их воздействие на человека и...',
    2002,
    13,
    1638,
    ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'Манн' ),
    (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Книга')
);

INSERT INTO TAG (
    TAG
) VALUES (
    'человека'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'человека'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'Два'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'Два'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'найти'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'найти'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'вечный'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'вечный'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO GENRE (
    GENRE
) VALUES (
    'Религии мира'
);

INSERT INTO AUTHOR (
    FIRST_NAME,
    LAST_NAME,
    FATHER_NAME
) VALUES (
    'Дуглас',
    'Абрамс',
    'Туту'
);

INSERT INTO BOOK_HAVE_GENRE(
    ID_GENRE,
    ID_BOOK
) VALUES (
    (SELECT ID FROM GENRE WHERE GENRE = 'Религии мира'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AUTHOR_WROTE_BOOK (
    ID_AUTHOR,
    ID_BOOK
) VALUES (
    (SELECT ID FROM AUTHOR WHERE FIRST_NAME = 'Дуглас' AND LAST_NAME = 'Абрамс'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AMOUNT_OF_BOOK (
    ID_BOOK,
    TOTAL,
    STORE
) VALUES (
    (SELECT COUNT(*) FROM BOOK),
    14,
    14
);

-----------------------------------------


INSERT INTO PUBLISHER (
    PUBLISHER
) VALUES (
    'Лабиринт'
);

INSERT INTO BOOK (
    TITLE,
    SUMMARY,
    YEAR_OF_PUBLICATION,
    AGE_LIMIT,
    PRICE,
    ID_PUBLISHER,
    ID_BOOK_TYPE
) VALUES (
    'Приключения Тома Сойера',
    '"Приключения Тома Сойера", одно из самых популярных произведений знаменитого американского писателя Марка Твена, рассказывает о жизни в маленьком городке на Миссисипи в 30-40-х годахХ1Х века. Как признавался сам автор, большинство приключений, описанных в этой книге, происходило на самом деле - с ним самим или его школьными товарищами. И хотя с тех пор прошло уже почти два столетия, проделки Тома по-прежнему вызывают улыбку и сочувствие, причем не только у юных читателей. Недаром Марк Твен заявлял, что своей книгой он хотел бы напомнить взрослым, какими они были когда-то, что думали и чувствовали и какие удивительные события с ними случались.Книга с классическими иллюстрациями Анатолия Иткина.Для детей 8-12 лет.',
    2020,
    3,
    1162,
    ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'Лабиринт' ),
    (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Книга')
);

INSERT INTO TAG (
    TAG
) VALUES (
    'Тома'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'Тома'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'Приключения'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'Приключения'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'самых'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'самых'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'Сойера'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'Сойера'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO GENRE (
    GENRE
) VALUES (
    'Приключения'
);

INSERT INTO GENRE (
    GENRE
) VALUES (
    'Детективы'
);

INSERT INTO AUTHOR (
    FIRST_NAME,
    LAST_NAME,
    FATHER_NAME
) VALUES (
    'Марк',
    'Твен',
    ''
);

INSERT INTO BOOK_HAVE_GENRE(
    ID_GENRE,
    ID_BOOK
) VALUES (
    (SELECT ID FROM GENRE WHERE GENRE = 'Приключения'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO BOOK_HAVE_GENRE(
    ID_GENRE,
    ID_BOOK
) VALUES (
    (SELECT ID FROM GENRE WHERE GENRE = 'Детективы'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AUTHOR_WROTE_BOOK (
    ID_AUTHOR,
    ID_BOOK
) VALUES (
    (SELECT ID FROM AUTHOR WHERE FIRST_NAME = 'Марк' AND LAST_NAME = 'Твен'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AMOUNT_OF_BOOK (
    ID_BOOK,
    TOTAL,
    STORE
) VALUES (
    (SELECT COUNT(*) FROM BOOK),
    4,
    4
);

-----------------------------------------


INSERT INTO PUBLISHER (
    PUBLISHER
) VALUES (
    'Феникс'
);

INSERT INTO BOOK (
    TITLE,
    SUMMARY,
    YEAR_OF_PUBLICATION,
    AGE_LIMIT,
    PRICE,
    ID_PUBLISHER,
    ID_BOOK_TYPE
) VALUES (
    'Урри Вульф и похититель собак. История юного изобретателя',
    'Не обязательно быть взрослым, чтобы совершать открытия. Урри Вульф - мальчик-изобретатель - знает это абсолютно точно. Больше всего на свете Урри мечтает построить скоростной космический корабль, чтобы путь на Луну и обратно занимал не больше часа. А на Луну ему нужно попасть непременно. Ведь там его ждёт папа.Сумеет ли Урри воплотить свою мечту? Или трудности, с которыми он столкнётся, заставят его отступить? Поживём - увидим. А пока ему предстоит помочь приятельнице Фэбби найти пропавшего щенка. Для этой цели Урри создаёт робопса со сверхострым нюхом, микровошь для прослушивания и авточерепаху "ПРЫТЬ", которые помогут отыскать пропажу. Вообще Урри глубоко убеждён, что в скором будущем мир будет заселён роботами. Машины будут лечить людей, защищать Землю от столкновения с метеоритами, а нанороботы бороться с вирусами. Его смелые мысли у одних вызывают смех, у др...',
    2021,
    5,
    633,
    ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'Феникс' ),
    (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Книга')
);

INSERT INTO TAG (
    TAG
) VALUES (
    'Урри'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'Урри'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'больше'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'Луну'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'Луну'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'взрослым'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'взрослым'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AUTHOR (
    FIRST_NAME,
    LAST_NAME,
    FATHER_NAME
) VALUES (
    'Евгения',
    'Высокосная',
    ''
);

INSERT INTO BOOK_HAVE_GENRE(
    ID_GENRE,
    ID_BOOK
) VALUES (
    (SELECT ID FROM GENRE WHERE GENRE = 'Приключения'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO BOOK_HAVE_GENRE(
    ID_GENRE,
    ID_BOOK
) VALUES (
    (SELECT ID FROM GENRE WHERE GENRE = 'Детективы'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AUTHOR_WROTE_BOOK (
    ID_AUTHOR,
    ID_BOOK
) VALUES (
    (SELECT ID FROM AUTHOR WHERE FIRST_NAME = 'Евгения' AND LAST_NAME = 'Высокосная'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AMOUNT_OF_BOOK (
    ID_BOOK,
    TOTAL,
    STORE
) VALUES (
    (SELECT COUNT(*) FROM BOOK),
    6,
    6
);

-----------------------------------------


INSERT INTO PUBLISHER (
    PUBLISHER
) VALUES (
    'Текст'
);

INSERT INTO BOOK (
    TITLE,
    SUMMARY,
    YEAR_OF_PUBLICATION,
    AGE_LIMIT,
    PRICE,
    ID_PUBLISHER,
    ID_BOOK_TYPE
) VALUES (
    '1984',
    'Прошло всего три года после окончания Второй мировой войны, когда Джордж Оруэлл (1903-1950) написал самое знаменитое свое произведение - роман-антиутопию "1984". Многое из того, о чем писал Джордж Оруэлл, покажется вам до безумия знакомым. Некоторые исследователи считают, что ни один западный читатель не постигнет суть "1984" так глубоко, как человек родом из Советского Союза.Война - это мирСвобода - это рабствоНезнание - силаКто управляет прошлым, тот управляет будущим; кто управляет настоящим, тот управляет прошлым. Действительность не есть нечто внешнее. Действительность существует в человеческом сознании и больше нигде.Когда любишь кого-то, ты его любишь, и, если ничего больше не можешь ему дать, ты все-таки даешь ему любовь…Джордж Оруэлл',
    2020,
    14,
    344,
    ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'Текст' ),
    (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Книга')
);

INSERT INTO TAG (
    TAG
) VALUES (
    'управляет'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'управляет'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'Оруэлл'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'Оруэлл'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'прошлым'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'прошлым'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'Действительность'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'Действительность'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO GENRE (
    GENRE
) VALUES (
    'зарубежная проза'
);

INSERT INTO AUTHOR (
    FIRST_NAME,
    LAST_NAME,
    FATHER_NAME
) VALUES (
    'Джордж',
    'Оруэлл',
    ''
);

INSERT INTO BOOK_HAVE_GENRE(
    ID_GENRE,
    ID_BOOK
) VALUES (
    (SELECT ID FROM GENRE WHERE GENRE = 'зарубежная проза'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AUTHOR_WROTE_BOOK (
    ID_AUTHOR,
    ID_BOOK
) VALUES (
    (SELECT ID FROM AUTHOR WHERE FIRST_NAME = 'Джордж' AND LAST_NAME = 'Оруэлл'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AMOUNT_OF_BOOK (
    ID_BOOK,
    TOTAL,
    STORE
) VALUES (
    (SELECT COUNT(*) FROM BOOK),
    24,
    24
);

-----------------------------------------


INSERT INTO PUBLISHER (
    PUBLISHER
) VALUES (
    'Эксмо'
);

INSERT INTO BOOK (
    TITLE,
    SUMMARY,
    YEAR_OF_PUBLICATION,
    AGE_LIMIT,
    PRICE,
    ID_PUBLISHER,
    ID_BOOK_TYPE
) VALUES (
    '1984',
    'Джордж Оруэлл — один из самых читаемых в мире авторов и очень противоречивая персона своего времени. Родился в Бенгалии, учился в Итоне, работал в полиции, на радио и в букинистическом магазине, воевал в Испании и писал книги. Ярый противник коммунизма и защитник демократического социализма, Оруэлл устроил бунт против общества, к которому так стремился, но в котором чувствовал себя абсолютно чужим.  В книге представлены четыре разных произведения Оруэлла: ранние романы «Дни в Бирме» и «Дочь священника», а также принесшие мировую известность сатирическая повесть-притча «Скотный двор» и антиутопия «1984».  Первый роман Оруэлла «Дни в Бирме» основан на его опыте работы в колониальной полиции Бирмы в 1920-е годы и вызвал горячие споры из-за резкого изображения колониального общества. «Дочь священника» знакомит с совершенно иным Оруэллом — мастером психологического ре...',
    2012,
    14,
    844,
    ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'Эксмо' ),
    (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Книга')
);

INSERT INTO TAG (
    TAG
) VALUES (
    'общества'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'общества'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'полиции'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'полиции'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'Оруэлл'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'Оруэлл'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO BOOK_HAVE_GENRE(
    ID_GENRE,
    ID_BOOK
) VALUES (
    (SELECT ID FROM GENRE WHERE GENRE = 'зарубежная проза'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AUTHOR_WROTE_BOOK (
    ID_AUTHOR,
    ID_BOOK
) VALUES (
    (SELECT ID FROM AUTHOR WHERE FIRST_NAME = 'Джордж' AND LAST_NAME = 'Оруэлл'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AMOUNT_OF_BOOK (
    ID_BOOK,
    TOTAL,
    STORE
) VALUES (
    (SELECT COUNT(*) FROM BOOK),
    66,
    66
);

-----------------------------------------


INSERT INTO PUBLISHER (
    PUBLISHER
) VALUES (
    'Антология'
);

INSERT INTO BOOK (
    TITLE,
    SUMMARY,
    YEAR_OF_PUBLICATION,
    AGE_LIMIT,
    PRICE,
    ID_PUBLISHER,
    ID_BOOK_TYPE
) VALUES (
    '1984',
    'Джордж Оруэлл (1903-1950) всем своим творчеством протестовал против тоталитарного общественного устройства. Эта тема в силу исторических причин была актуальна в литературе первой половины XX века, но не утратила своей злободневности и в наши дни. Роман-антиутопия "1984" (1949) рисует тоталитарный Лондон будущего - крупный город Океании, которая находится в беспрерывном состоянии войны с двумя другими мировыми сверхдержавами. В обществе принята жесткая социальная иерархия, большинство граждан живут в нищете и под непрекращающимся контролем Полиции мыслей. Главный герой Уинстон Смит многие годы выдает себя за добропорядочного чиновника, разделяющего общепринятые политические идеалы. Но внезапно вспыхнувшее чувство к коллеге Джулии переворачивает его жизнь: приносит недолгое счастье, но и ставит вне рамок закона.',
    2021,
    14,
    391,
    ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'Антология' ),
    (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Книга')
);

INSERT INTO TAG (
    TAG
) VALUES (
    'Джордж'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'Джордж'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'Оруэлл'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'творчеством'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'творчеством'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'протестовал'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'протестовал'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO BOOK_HAVE_GENRE(
    ID_GENRE,
    ID_BOOK
) VALUES (
    (SELECT ID FROM GENRE WHERE GENRE = 'зарубежная проза'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AUTHOR_WROTE_BOOK (
    ID_AUTHOR,
    ID_BOOK
) VALUES (
    (SELECT ID FROM AUTHOR WHERE FIRST_NAME = 'Джордж' AND LAST_NAME = 'Оруэлл'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AMOUNT_OF_BOOK (
    ID_BOOK,
    TOTAL,
    STORE
) VALUES (
    (SELECT COUNT(*) FROM BOOK),
    33,
    33
);

-----------------------------------------


INSERT INTO PUBLISHER (
    PUBLISHER
) VALUES (
    'Каро'
);

INSERT INTO BOOK (
    TITLE,
    SUMMARY,
    YEAR_OF_PUBLICATION,
    AGE_LIMIT,
    PRICE,
    ID_PUBLISHER,
    ID_BOOK_TYPE
) VALUES (
    '1984',
    'Роман "1984" - вершина творчества Джорджа Оруэлла. В нем показано общество, в котором люди четко разделены на классы: верхний, привилегированный, партийная верхушка; средний, не имеющий права ни на что, находящийся под постоянным прицелом телекамер и подслушивающих устройств, лишенный общения и эмоций, делающий механическую работу по регулярному переписыванию истории, обделенный во всем; низший - как бы пролетариат. В этом обществе искореняется любая мысль; человек живет в страхе наказания, которое неизбежно последует за любую провинность. Такое общество уничтожает в человеке все человеческое. Чтобы человек меньше думал, примитивизируется язык, переписываются книги и газеты, поощряется доносительство, предательство - даже своих близких. Не остается ничего святого и, соответственно, ничего, для чего хотелось бы жить. Этот роман - захватывающее, но страшное повеств...',
    2016,
    14,
    281,
    ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'Каро' ),
    (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Книга')
);

INSERT INTO TAG (
    TAG
) VALUES (
    'человек'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'человек'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'общество'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'общество'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'роман'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'ничего'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'ничего'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO BOOK_HAVE_GENRE(
    ID_GENRE,
    ID_BOOK
) VALUES (
    (SELECT ID FROM GENRE WHERE GENRE = 'зарубежная проза'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AUTHOR_WROTE_BOOK (
    ID_AUTHOR,
    ID_BOOK
) VALUES (
    (SELECT ID FROM AUTHOR WHERE FIRST_NAME = 'Джордж' AND LAST_NAME = 'Оруэлл'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AMOUNT_OF_BOOK (
    ID_BOOK,
    TOTAL,
    STORE
) VALUES (
    (SELECT COUNT(*) FROM BOOK),
    17,
    17
);

-----------------------------------------

INSERT INTO PUBLISHER (
    PUBLISHER
) VALUES (
    'АСТ'
);

INSERT INTO BOOK (
    TITLE,
    SUMMARY,
    YEAR_OF_PUBLICATION,
    AGE_LIMIT,
    PRICE,
    ID_PUBLISHER,
    ID_BOOK_TYPE
) VALUES (
    '1984',
    'Своеобразный антипод второй великой антиутопии XX века - "О дивный новый мир" Олдоса Хаксли. Что, в сущности, страшнее: доведенное до абсурда "общество потребления" - или доведенное до абсолюта "общество идеи"? По Оруэллу, нет и не может быть ничего ужаснее тотальной несвободы...Каждый день Уинстон Смит переписывает историю в соответствии с новой линией Министерства Правды. С каждой ложью, которую он переносит на бумагу, Уинстон всё больше ненавидит Партию, которая не интересуется ничем кроме власти, и которая не терпит инакомыслия. Но чем больше Уинстон старается думать иначе, тем сложнее ему становится избежать ареста, ведь Большой Брат всегда следит за тобой…
',
    2008,
    16,
    269,
    ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'АСТ' ),
    (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Книга')
);

INSERT INTO TAG (
    TAG
) VALUES (
    'Уинстон'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'Уинстон'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'общество'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'больше'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'больше'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'антипод'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'антипод'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO GENRE (
    GENRE
) VALUES (
    'фантастика'
);

INSERT INTO BOOK_HAVE_GENRE(
    ID_GENRE,
    ID_BOOK
) VALUES (
    (SELECT ID FROM GENRE WHERE GENRE = 'фантастика'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AUTHOR_WROTE_BOOK (
    ID_AUTHOR,
    ID_BOOK
) VALUES (
    (SELECT ID FROM AUTHOR WHERE FIRST_NAME = 'Джордж' AND LAST_NAME = 'Оруэлл'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AMOUNT_OF_BOOK (
    ID_BOOK,
    TOTAL,
    STORE
) VALUES (
    (SELECT COUNT(*) FROM BOOK),
    14,
    14
);

-----------------------------------------

INSERT INTO BOOK (
    TITLE,
    SUMMARY,
    YEAR_OF_PUBLICATION,
    AGE_LIMIT,
    PRICE,
    ID_PUBLISHER,
    ID_BOOK_TYPE
) VALUES (
    'Гибель Богов-2. Душа Бога. Том 1',
    'Упорядоченное гибнет. Хаос рвёт его на части, Дальние обращают миры в мёртвые кристаллы. Гремит величайшая из битв, Рагнарёк, где все сражаются против всех в тщетной попытке прожить лишний день. Гибнут герои и защитники, а умершие, напротив, возвращаются к жизни. Из небытия выныривает тень величайшего оружия - трёх магических Мечей, Алмазного, Деревянного и Меча Людей. Только кому они понадобились в дни всеобщей погибели? Кто и зачем собрал в недрах Межреальности немёртвую Армаду? Куда ведёт золотой луч, путь, пройти по которому сможет лишь один? И зачем девочка Рандгрид бьётся изо всех сил с гигантским змеем - ведь в Рагнарёке нельзя победить!Или всё-таки можно?..',
    2020,
    15,
    1450,
    ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'Эксмо' ),
    (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Книга')
);

INSERT INTO TAG (
    TAG
) VALUES (
    'зачем'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'зачем'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'Упорядоченное'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'Упорядоченное'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'Хаос'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'Хаос'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'гибнет'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'гибнет'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AUTHOR (
    FIRST_NAME,
    LAST_NAME,
    FATHER_NAME
) VALUES (
    'Ник',
    'Перумов',
    'Даниилович'
);

INSERT INTO BOOK_HAVE_GENRE(
    ID_GENRE,
    ID_BOOK
) VALUES (
    (SELECT ID FROM GENRE WHERE GENRE = 'фантастика'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AUTHOR_WROTE_BOOK (
    ID_AUTHOR,
    ID_BOOK
) VALUES (
    (SELECT ID FROM AUTHOR WHERE FIRST_NAME = 'Ник' AND LAST_NAME = 'Перумов'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AMOUNT_OF_BOOK (
    ID_BOOK,
    TOTAL,
    STORE
) VALUES (
    (SELECT COUNT(*) FROM BOOK),
    14,
    14
);

-----------------------------------------



INSERT INTO BOOK (
    TITLE,
    SUMMARY,
    YEAR_OF_PUBLICATION,
    AGE_LIMIT,
    PRICE,
    ID_PUBLISHER,
    ID_BOOK_TYPE
) VALUES (
    'Гибель Богов-2. Душа Бога. Том 2',
    'Самое масштабное эпическое полотно в отечественной фантастике. Цикл, ставший классикой русского фэнтези. Один из самых больших литературных русскоязычных фэндомов. Всё это - "Гибель Богов" Ника Перумова! История, начатая больше тридцати лет назад, подошла к своему завершению. Мы узнаем, что случилось со всеми героями саги, смертными и бессмертными, уцелела ли Вселенная Упорядоченного и вышел ли кто-нибудь победителем в схватке вселенских сил.В день, когда заканчиваются все пути, открываются все двери и находятся ответы на все вопросы. В день Рагнарёка, истинной гибели богов.',
    2023,
    14,
    1431,
    ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'Феникс' ),
    (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Книга')
);

INSERT INTO TAG (
    TAG
) VALUES (
    'Богов'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'Богов'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'день'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'день'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'масштабное'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'масштабное'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'Самое'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'Самое'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO GENRE (
    GENRE
) VALUES (
    'Героическое отечественное фэнтези'
);

INSERT INTO BOOK_HAVE_GENRE(
    ID_GENRE,
    ID_BOOK
) VALUES (
    (SELECT ID FROM GENRE WHERE GENRE = 'Героическое отечественное фэнтези'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AUTHOR_WROTE_BOOK (
    ID_AUTHOR,
    ID_BOOK
) VALUES (
    (SELECT ID FROM AUTHOR WHERE FIRST_NAME = 'Ник' AND LAST_NAME = 'Перумов'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AMOUNT_OF_BOOK (
    ID_BOOK,
    TOTAL,
    STORE
) VALUES (
    (SELECT COUNT(*) FROM BOOK),
    10,
    10
);

-----------------------------------------


INSERT INTO PUBLISHER (
    PUBLISHER
) VALUES (
    'Волчок'
);

INSERT INTO BOOK (
    TITLE,
    SUMMARY,
    YEAR_OF_PUBLICATION,
    AGE_LIMIT,
    PRICE,
    ID_PUBLISHER,
    ID_BOOK_TYPE
) VALUES (
    'Каскадерки идут до конца',
    'Девочки такие разные: Кирка занимается спортом, а Варя играет на пианино, Кирка прыгает выше всех и бегает быстрее, зато Варя умеет выдумывать новые интересные слова. Одинаковые у них только причёски и царапины на коленках. Но для дружбы на всю жизнь этого мало. Нужно общее дело, чтоб не расставаться до самой старости! Например, снимать кино. В главной роли, конечно, Кирка - ловкая, смелая, настоящая каскадёрка! А Варя - сценарист и оператор.Но кино приходится забросить, когда с одной из девочек случается беда… а подруга приходит ей на помощь. Нельзя бросать дружбу на полпути. Каскадёрки никогда не сдаются!Анна Анисимова - автор детских книг, лауреат премии Маршака и финалист премии Крапивина. В издательстве "Волчок" выходили её книги "Гутя" и "Кедровый слоник".Для детей среднего школьного возраста.',
    2007,
    3,
    308,
    ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'Волчок' ),
    (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Книга')
);

INSERT INTO TAG (
    TAG
) VALUES (
    'Кирка'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'Кирка'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'Варя'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'Варя'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'кино'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'кино'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'премии'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'премии'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO GENRE (
    GENRE
) VALUES (
    'Повести и рассказы о детях'
);

INSERT INTO AUTHOR (
    FIRST_NAME,
    LAST_NAME,
    FATHER_NAME
) VALUES (
    'Анна',
    'Анисимова',
    'Павловна'
);

INSERT INTO BOOK_HAVE_GENRE(
    ID_GENRE,
    ID_BOOK
) VALUES (
    (SELECT ID FROM GENRE WHERE GENRE = 'Повести и рассказы о детях'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AUTHOR_WROTE_BOOK (
    ID_AUTHOR,
    ID_BOOK
) VALUES (
    (SELECT ID FROM AUTHOR WHERE FIRST_NAME = 'Анна' AND LAST_NAME = 'Анисимова'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AUTHOR_WROTE_BOOK (
    ID_AUTHOR,
    ID_BOOK
) VALUES (
    (SELECT ID FROM AUTHOR WHERE FIRST_NAME = 'Ник' AND LAST_NAME = 'Перумов'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AMOUNT_OF_BOOK (
    ID_BOOK,
    TOTAL,
    STORE
) VALUES (
    (SELECT COUNT(*) FROM BOOK),
    34,
    34
);

-----------------------------------------


INSERT INTO PUBLISHER (
    PUBLISHER
) VALUES (
    'Пять четвертей'
);

INSERT INTO BOOK (
    TITLE,
    SUMMARY,
    YEAR_OF_PUBLICATION,
    AGE_LIMIT,
    PRICE,
    ID_PUBLISHER,
    ID_BOOK_TYPE
) VALUES (
    'Василькин Д. Седьмой отряд',
    'Долгожданные каникулы наконец наступили, и выпускник третьего класса Дима Василькин впервые едет в летний лагерь. Будем откровенны: сама поездка ему была не очень интересна - наш герой просто готовил сюрприз лучшему другу. Как удивился бы Костик, обнаружив, что они проведут лето вместе! Только вот судьба преподносит свои сюрпризы!.. Кажется, каникулы безнадёжно испорчены. Или всё-таки нет?..Виктория Ледерман давно знакома читателям как классик современной детской литературы и лауреат множества премий, среди которых - "Книгуру", Корнейчуковская, Крапивинская, "Алиса", посвящённая памяти Кира Булычёва. Герои книг Виктории Ледерман - мальчишки и девчонки, которые попадают в самые необычайные обстоятельства, позволяющие им не только проверить свою дружбу на прочность, но и лучше узнать себя.Для младшего и среднего школьного возраста.',
    2020,
    3,
    720,
    ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'Пять четвертей' ),
    (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Книга')
);

INSERT INTO TAG (
    TAG
) VALUES (
    'каникулы'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'каникулы'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'Ледерман'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'Ледерман'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'наконец'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'наконец'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'Долгожданные'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'Долгожданные'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AUTHOR (
    FIRST_NAME,
    LAST_NAME,
    FATHER_NAME
) VALUES (
    'Виктория',
    'Ледерман',
    'Валерьевна'
);

INSERT INTO BOOK_HAVE_GENRE(
    ID_GENRE,
    ID_BOOK
) VALUES (
    (SELECT ID FROM GENRE WHERE GENRE = 'Повести и рассказы о детях'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AUTHOR_WROTE_BOOK (
    ID_AUTHOR,
    ID_BOOK
) VALUES (
    (SELECT ID FROM AUTHOR WHERE FIRST_NAME = 'Виктория' AND LAST_NAME = 'Ледерман'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AUTHOR_WROTE_BOOK (
    ID_AUTHOR,
    ID_BOOK
) VALUES (
    (SELECT ID FROM AUTHOR WHERE FIRST_NAME = 'Анна' AND LAST_NAME = 'Анисимова'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AMOUNT_OF_BOOK (
    ID_BOOK,
    TOTAL,
    STORE
) VALUES (
    (SELECT COUNT(*) FROM BOOK),
    14,
    14
);

-----------------------------------------


INSERT INTO PUBLISHER (
    PUBLISHER
) VALUES (
    'XL Media'
);

INSERT INTO BOOK (
    TITLE,
    SUMMARY,
    YEAR_OF_PUBLICATION,
    AGE_LIMIT,
    PRICE,
    ID_PUBLISHER,
    ID_BOOK_TYPE
) VALUES (
    'Проза бродячих псов. Том 1',
    'Мальчика по имени Ацуси Накадзима выгоняют из сиротского приюта, и так он оказывается в Иокогаме без денег и крыши над головой. Ацуси в таком отчаянии, что решается ограбить первого встречного. Однако сердце у него доброе, и вместо ограбления он спасает жизнь тонущему человеку, которого видит в реке. Этим человеком оказывается некто Осаму Дадзай — эксцентричный сотрудник так называемого Вооруженного детективного агентства. В данный момент он и его товарищи ищут загадочного тигра-людоеда, наводящего страх на жителей округи. Ацуси и сам натерпелся от этого тигра, поэтому соглашается помочь Дадзаю в поисках. Вскоре он знакомится с другими сотрудниками агентства, где каждый другого чуднее.',
    2021,
    5,
    628,
    ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'XL Media' ),
    (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Книга')
);

INSERT INTO TAG (
    TAG
) VALUES (
    'Ацуси'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'Ацуси'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'оказывается'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'оказывается'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'агентства'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'агентства'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'имени'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'имени'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO GENRE (
    GENRE
) VALUES (
    'Манга'
);

INSERT INTO AUTHOR (
    FIRST_NAME,
    LAST_NAME,
    FATHER_NAME
) VALUES (
    'Кафка',
    'Асагири',
    'Харукава'
);

INSERT INTO BOOK_HAVE_GENRE(
    ID_GENRE,
    ID_BOOK
) VALUES (
    (SELECT ID FROM GENRE WHERE GENRE = 'Манга'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AUTHOR_WROTE_BOOK (
    ID_AUTHOR,
    ID_BOOK
) VALUES (
    (SELECT ID FROM AUTHOR WHERE FIRST_NAME = 'Кафка' AND LAST_NAME = 'Асагири'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AUTHOR_WROTE_BOOK (
    ID_AUTHOR,
    ID_BOOK
) VALUES (
    (SELECT ID FROM AUTHOR WHERE FIRST_NAME = 'Анна' AND LAST_NAME = 'Анисимова'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AMOUNT_OF_BOOK (
    ID_BOOK,
    TOTAL,
    STORE
) VALUES (
    (SELECT COUNT(*) FROM BOOK),
    55,
    55
);

-----------------------------------------



INSERT INTO BOOK (
    TITLE,
    SUMMARY,
    YEAR_OF_PUBLICATION,
    AGE_LIMIT,
    PRICE,
    ID_PUBLISHER,
    ID_BOOK_TYPE
) VALUES (
    'Проза бродячих псов. Том 2',
    'Кёка Идзуми воспротивилась приказу мафии и едва не погибла по собственной вине. Ацуси Накадзима спас ее да еще тофу накормил - все ради того, чтобы выведать ценные сведения… Только мир и покой продлились недолго: Акутагава разработал коварный план похищения Ацуси. Тем временем перед закованным в цепи Дадзаем предстал бывший товарищ-мафиози, а теперь его недруг - Тюя Накахара. Дадзай Осаму против Тюи Накахары, Рюноскэ Акутагава против Ацуси Накадзимы… К чему приведет крупный конфликт между вооруженными детективами и мафией?',
    2021,
    5,
    628,
    ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'XL Media' ),
    (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Книга')
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'Ацуси'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'Акутагава'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'Акутагава'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'против'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'против'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'Идзуми'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'Идзуми'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO BOOK_HAVE_GENRE(
    ID_GENRE,
    ID_BOOK
) VALUES (
    (SELECT ID FROM GENRE WHERE GENRE = 'Манга'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AUTHOR_WROTE_BOOK (
    ID_AUTHOR,
    ID_BOOK
) VALUES (
    (SELECT ID FROM AUTHOR WHERE FIRST_NAME = 'Кафка' AND LAST_NAME = 'Асагири'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AMOUNT_OF_BOOK (
    ID_BOOK,
    TOTAL,
    STORE
) VALUES (
    (SELECT COUNT(*) FROM BOOK),
    5,
    55
);

-----------------------------------------


INSERT INTO PUBLISHER (
    PUBLISHER
) VALUES (
    'Олимп-Бизнес'
);

INSERT INTO BOOK (
    TITLE,
    SUMMARY,
    YEAR_OF_PUBLICATION,
    AGE_LIMIT,
    PRICE,
    ID_PUBLISHER,
    ID_BOOK_TYPE
) VALUES (
    'Нет, спасибо, я просто смотрю. Как посетителя превратить в покупателя',
    'Гарри Фридман - мастер розничной торговли и обучения в этой области. Книга "Нет, спасибо, я просто смотрю" о розничной торговле. Уникальность Г. Фридмана и его книги заключается именно в непревзойденной способности превращать потенциальных покупателей в тех, кто действительно покупает, а также учить этому других. Используя юмор, сопричастность и свой огромный опыт, он рассказывает о том, как достичь вершин мастерства в обслуживании покупателей и стать самым успешным продавцом. Вы узнаете, как преодолеть сопротивление покупателя, как выяснить, что он хочет, как заставить его сделать не только основную, но и дополнительную покупку. Приемы, описанные в этой книге, позволят вам значительно ускорить продвижение по служебной лестнице.',
    2021,
    3,
    767,
    ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'Олимп-Бизнес' ),
    (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Книга')
);

INSERT INTO TAG (
    TAG
) VALUES (
    'розничной'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'розничной'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'покупателей'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'покупателей'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'Фридман'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'Фридман'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'Гарри'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'Гарри'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO GENRE (
    GENRE
) VALUES (
    'Техники продаж'
);

INSERT INTO AUTHOR (
    FIRST_NAME,
    LAST_NAME,
    FATHER_NAME
) VALUES (
    'Гарри',
    'Фридман',
    'Дж.'
);

INSERT INTO BOOK_HAVE_GENRE(
    ID_GENRE,
    ID_BOOK
) VALUES (
    (SELECT ID FROM GENRE WHERE GENRE = 'Техники продаж'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AUTHOR_WROTE_BOOK (
    ID_AUTHOR,
    ID_BOOK
) VALUES (
    (SELECT ID FROM AUTHOR WHERE FIRST_NAME = 'Гарри' AND LAST_NAME = 'Фридман'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AUTHOR_WROTE_BOOK (
    ID_AUTHOR,
    ID_BOOK
) VALUES (
    (SELECT ID FROM AUTHOR WHERE FIRST_NAME = 'Кафка' AND LAST_NAME = 'Асагири'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AMOUNT_OF_BOOK (
    ID_BOOK,
    TOTAL,
    STORE
) VALUES (
    (SELECT COUNT(*) FROM BOOK),
    5,
    5
);

-----------------------------------------



INSERT INTO BOOK (
    TITLE,
    SUMMARY,
    YEAR_OF_PUBLICATION,
    AGE_LIMIT,
    PRICE,
    ID_PUBLISHER,
    ID_BOOK_TYPE
) VALUES (
    '45 татуировок продавана. Правила для тех, кто продаёт и управляет продажами',
    'О книгеНовые 45 татуировок из продавцового прошлого Максима Батырева - как в роли рядового менеджера по продажам, так и в роли руководителя: успехи, неудачи, выводы из них.Одна из самых непростых и в то же время интересных профессий - это профессия человека, который ежедневно, ежечасно и ежеминутно защищает интересы организации, проводя коммерческие переговоры с её потенциальными заказчиками и будущими партнерами.Максим Батырев уверен: все, чего он достиг в своей профессиональной деятельности, он достиг благодаря работе в продажах. Продажи учат защищать свои интересы, выступать публично, вести переговоры с клиентами, делать своими руками презентации, внятно формулировать свои мысли и многому другому.Продажи делают людей сильными.Если вы научитесь продавать товары с не самой очевидной выгодой на одном из самых высококонкурентных рынков, то вам по плечу будут практ...',
    2021,
    3,
    1461,
    ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'Манн' ),
    (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Книга')
);

INSERT INTO TAG (
    TAG
) VALUES (
    'интересы'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'интересы'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'самых'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'роли'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'роли'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'переговоры'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'переговоры'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AUTHOR (
    FIRST_NAME,
    LAST_NAME,
    FATHER_NAME
) VALUES (
    'Максим',
    'Батырев',
    'Валерьевич'
);

INSERT INTO BOOK_HAVE_GENRE(
    ID_GENRE,
    ID_BOOK
) VALUES (
    (SELECT ID FROM GENRE WHERE GENRE = 'Техники продаж'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AUTHOR_WROTE_BOOK (
    ID_AUTHOR,
    ID_BOOK
) VALUES (
    (SELECT ID FROM AUTHOR WHERE FIRST_NAME = 'Максим' AND LAST_NAME = 'Батырев'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AUTHOR_WROTE_BOOK (
    ID_AUTHOR,
    ID_BOOK
) VALUES (
    (SELECT ID FROM AUTHOR WHERE FIRST_NAME = 'Кафка' AND LAST_NAME = 'Асагири'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AMOUNT_OF_BOOK (
    ID_BOOK,
    TOTAL,
    STORE
) VALUES (
    (SELECT COUNT(*) FROM BOOK),
    124,
    124
);

-----------------------------------------


INSERT INTO PUBLISHER (
    PUBLISHER
) VALUES (
    'Дискурс'
);

INSERT INTO BOOK (
    TITLE,
    SUMMARY,
    YEAR_OF_PUBLICATION,
    AGE_LIMIT,
    PRICE,
    ID_PUBLISHER,
    ID_BOOK_TYPE
) VALUES (
    '11 исследований о жизни на Земле. Рождественские лекции Королевского института Великобритании',
    'Этот сборник лекций Королевского института посвящен исследованиям разнообразных организмов, которые могут приоткрыть тайну возникновения жизни на Земле. Еще сотню лет назад ученые с помощью рисунков пытались воссоздать, как выглядели динозавры, а сегодня представление о вымерших рептилиях кардинально изменилось. Уже в начале прошлого века исследователи предупреждали об угрозе очередного массового вымирания видов. Тогда же была озвучена идея экосистем, в которых органично взаимодействуют различные обитатели нашей планеты: растения, рыбы, животные, насекомые. Они общаются друг с другом и природной средой, посылают сигналы об опасности и умеют защищаться, а некоторые поражают своим пением, как, например, горбатые киты. В XXI веке наука подтверждает: от сложных и хрупких взаимосвязей между животными и растениями во многом зависят и люди.',
    2008,
    0,
    376,
    ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'Дискурс' ),
    (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Книга')
);

INSERT INTO TAG (
    TAG
) VALUES (
    'сборник'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'сборник'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'лекций'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'лекций'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'Королевского'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'Королевского'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'института'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'института'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO GENRE (
    GENRE
) VALUES (
    'Концепции современного естествознания'
);

INSERT INTO AUTHOR (
    FIRST_NAME,
    LAST_NAME,
    FATHER_NAME
) VALUES (
    'Хелен',
    'Скейлз',
    ''
);

INSERT INTO BOOK_HAVE_GENRE(
    ID_GENRE,
    ID_BOOK
) VALUES (
    (SELECT ID FROM GENRE WHERE GENRE = 'Концепции современного естествознания'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AUTHOR_WROTE_BOOK (
    ID_AUTHOR,
    ID_BOOK
) VALUES (
    (SELECT ID FROM AUTHOR WHERE FIRST_NAME = 'Хелен' AND LAST_NAME = 'Скейлз'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AMOUNT_OF_BOOK (
    ID_BOOK,
    TOTAL,
    STORE
) VALUES (
    (SELECT COUNT(*) FROM BOOK),
    44,
    44
);

-----------------------------------------


INSERT INTO PUBLISHER (
    PUBLISHER
) VALUES (
    'Портал'
);

INSERT INTO BOOK (
    TITLE,
    SUMMARY,
    YEAR_OF_PUBLICATION,
    AGE_LIMIT,
    PRICE,
    ID_PUBLISHER,
    ID_BOOK_TYPE
) VALUES (
    'Не приспособлен к жизни. Человеческая эволюция против современного мира',
    'Люди выкованы естественным отбором и отточены эволюцией. Они идеально приспособлены для мира… которого больше не существует. Но почему же так получилось? Разъяснит ситуацию Адам Харт - биолог, профессор Университета Глостершира, популяризатор науки, соавтор научно-популярных фильмов BBC. Мы не адаптированы к сегодняшней жизни по многим причинам. Благодаря этой книге вы не только сможете понять их, узнав больше об истории человечества, генетике, биогеографии, биохимии, половом отборе, психологии, социологии, но и найдете ответы на вопросы: - является ли ожирение, от которого страдают миллионы людей, результатом эволюции или дело в наследственной лени? - почему в высокотехнологичном, безопасном и очень удобном современном мире мы испытываем больше стресса, чем наши первобытные предки? - как повлияют на человечество новые технологии? - и почему, говоря о собственном...',
    2021,
    0,
    616,
    ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'Портал' ),
    (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Книга')
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'больше'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'почему'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'почему'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'выкованы'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'выкованы'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'Люди'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'Люди'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO GENRE (
    GENRE
) VALUES (
    'Другие биологические науки'
);

INSERT INTO AUTHOR (
    FIRST_NAME,
    LAST_NAME,
    FATHER_NAME
) VALUES (
    'Адам',
    'Харт',
    ''
);

INSERT INTO BOOK_HAVE_GENRE(
    ID_GENRE,
    ID_BOOK
) VALUES (
    (SELECT ID FROM GENRE WHERE GENRE = 'Другие биологические науки'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AUTHOR_WROTE_BOOK (
    ID_AUTHOR,
    ID_BOOK
) VALUES (
    (SELECT ID FROM AUTHOR WHERE FIRST_NAME = 'Адам' AND LAST_NAME = 'Харт'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AUTHOR_WROTE_BOOK (
    ID_AUTHOR,
    ID_BOOK
) VALUES (
    (SELECT ID FROM AUTHOR WHERE FIRST_NAME = 'Хелен' AND LAST_NAME = 'Скейлз'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AMOUNT_OF_BOOK (
    ID_BOOK,
    TOTAL,
    STORE
) VALUES (
    (SELECT COUNT(*) FROM BOOK),
    11,
    11
);

-----------------------------------------


INSERT INTO PUBLISHER (
    PUBLISHER
) VALUES (
    'Аркадия'
);

INSERT INTO BOOK (
    TITLE,
    SUMMARY,
    YEAR_OF_PUBLICATION,
    AGE_LIMIT,
    PRICE,
    ID_PUBLISHER,
    ID_BOOK_TYPE
) VALUES (
    'Цветочная сеть',
    'Посреди пекинской зимы, в последние дни правления Дэн Сяопина, сын посла США в Китае найден мертвым: его тело погребено в замерзшем озере.Примерно в то же время на борту корабля с нелегальными мигрантами, дрейфующего у берегов Южной Калифорнии, помощник прокурора Дэвид Старк обнаруживает страшный груз: труп "красного принца" - наследника политической элиты КНР.Власти обеих стран подозревают, что убийства связаны между собой, и соглашаются на беспрецедентный шаг: несмотря на политические разногласия, объединить усилия по расследованию преступлений. Теперь Дэвиду Старку предстоит работать вместе с Лю Хулань - пекинской красной принцессой, инспектором Министерства общественной безопасности.',
    2020,
    18,
    370,
    ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'Аркадия' ),
    (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Книга')
);

INSERT INTO TAG (
    TAG
) VALUES (
    'пекинской'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'пекинской'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'Посреди'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'Посреди'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'последние'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'последние'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'зимы'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'зимы'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AUTHOR (
    FIRST_NAME,
    LAST_NAME,
    FATHER_NAME
) VALUES (
    'Лиза',
    'Си',
    ''
);

INSERT INTO BOOK_HAVE_GENRE(
    ID_GENRE,
    ID_BOOK
) VALUES (
    (SELECT ID FROM GENRE WHERE GENRE = 'Детективы'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AUTHOR_WROTE_BOOK (
    ID_AUTHOR,
    ID_BOOK
) VALUES (
    (SELECT ID FROM AUTHOR WHERE FIRST_NAME = 'Лиза' AND LAST_NAME = 'Си'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AUTHOR_WROTE_BOOK (
    ID_AUTHOR,
    ID_BOOK
) VALUES (
    (SELECT ID FROM AUTHOR WHERE FIRST_NAME = 'Хелен' AND LAST_NAME = 'Скейлз'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AMOUNT_OF_BOOK (
    ID_BOOK,
    TOTAL,
    STORE
) VALUES (
    (SELECT COUNT(*) FROM BOOK),
    16,
    16
);

-----------------------------------------


INSERT INTO PUBLISHER (
    PUBLISHER
) VALUES (
    'Фантом Пресс'
);

INSERT INTO BOOK (
    TITLE,
    SUMMARY,
    YEAR_OF_PUBLICATION,
    AGE_LIMIT,
    PRICE,
    ID_PUBLISHER,
    ID_BOOK_TYPE
) VALUES (
    'Черные кувшинки',
    'Девочка, любящая рисовать, невероятно красивая школьная учительница и старуха, которая видит все... В деревушке Живерни у реки найдено тело ребенка. Лоренс Серенак не так давно выпустился из полицейской школы, и это его первое расследование. Подозреваемых у него хоть отбавляй. Но главное - преступление очень похоже на давнее, случившееся в 1937 году. Может, они как-то связаны? Только старуха с совиным взглядом знает это. Только старуха знает, что история может повториться и девочка, что любит рисовать, и красавица-учительница в огромной опасности..."Черные кувшинки" - один из лучших романов Мишеля Бюсси.',
    2021,
    18,
    728,
    ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'Фантом Пресс' ),
    (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Книга')
);

INSERT INTO TAG (
    TAG
) VALUES (
    'старуха'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'старуха'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'Девочка'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'Девочка'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'знает'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'знает'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'любящая'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'любящая'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AUTHOR (
    FIRST_NAME,
    LAST_NAME,
    FATHER_NAME
) VALUES (
    'Мишель',
    'Бюсси',
    ''
);

INSERT INTO BOOK_HAVE_GENRE(
    ID_GENRE,
    ID_BOOK
) VALUES (
    (SELECT ID FROM GENRE WHERE GENRE = 'Детективы'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AUTHOR_WROTE_BOOK (
    ID_AUTHOR,
    ID_BOOK
) VALUES (
    (SELECT ID FROM AUTHOR WHERE FIRST_NAME = 'Мишель' AND LAST_NAME = 'Бюсси'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AUTHOR_WROTE_BOOK (
    ID_AUTHOR,
    ID_BOOK
) VALUES (
    (SELECT ID FROM AUTHOR WHERE FIRST_NAME = 'Хелен' AND LAST_NAME = 'Скейлз'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AMOUNT_OF_BOOK (
    ID_BOOK,
    TOTAL,
    STORE
) VALUES (
    (SELECT COUNT(*) FROM BOOK),
    14,
    14
);

-----------------------------------------



INSERT INTO BOOK (
    TITLE,
    SUMMARY,
    YEAR_OF_PUBLICATION,
    AGE_LIMIT,
    PRICE,
    ID_PUBLISHER,
    ID_BOOK_TYPE
) VALUES (
    'Клуб убийств по четвергам',
    'О книгеЧетверо престарелых героев...Первое серьезное дело для женщины-полицейского...Жестокое убийство...Добро пожаловать в клуб "Убийства по четвергам"!В доме престарелых, расположенном среди мирных сельских пейзажей, четверо друзей еженедельно встречаются в комнате для отдыха, чтобы обсудить нераскрытые преступления. Они называют себя "Клуб убийств по четвергам". Элизабет, Джойс, Ибрагим и Рон уже разменяли восьмой десяток, но у них все еще есть кое-какие трюки в запасе. Когда местного строителя находят мертвым, а рядом с телом обнаруживается таинственная фотография, "Клуб убийств по четвергам" внезапно получает первое настоящее дело. Вскоре количество трупов начинает расти. Сможет ли наша необычная команда поймать убийцу, пока не стало слишком поздно?Об автореРичард Томас Осман (родился 28 ноября 1970 года) - английский телеведущий, продюсер, комик и писатель, наиболее из...',
    2021,
    18,
    798,
    ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'Манн' ),
    (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Книга')
);

INSERT INTO TAG (
    TAG
) VALUES (
    'клуб'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'клуб'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'четвергам'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'четвергам'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'Первое'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'Первое'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'убийств'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'убийств'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AUTHOR (
    FIRST_NAME,
    LAST_NAME,
    FATHER_NAME
) VALUES (
    'Ричард',
    'Осман',
    'Томас'
);

INSERT INTO BOOK_HAVE_GENRE(
    ID_GENRE,
    ID_BOOK
) VALUES (
    (SELECT ID FROM GENRE WHERE GENRE = 'Детективы'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AUTHOR_WROTE_BOOK (
    ID_AUTHOR,
    ID_BOOK
) VALUES (
    (SELECT ID FROM AUTHOR WHERE FIRST_NAME = 'Ричард' AND LAST_NAME = 'Осман'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AMOUNT_OF_BOOK (
    ID_BOOK,
    TOTAL,
    STORE
) VALUES (
    (SELECT COUNT(*) FROM BOOK),
    44,
    44
);

-----------------------------------------



INSERT INTO BOOK (
    TITLE,
    SUMMARY,
    YEAR_OF_PUBLICATION,
    AGE_LIMIT,
    PRICE,
    ID_PUBLISHER,
    ID_BOOK_TYPE
) VALUES (
    'Красный дракон',
    'Мы все безумцы или, может быть, это мир вокруг нас сошел с ума? Доктор Ганнибал Лектер, легендарный убийца-каннибал, попав за решетку, становится консультантом и союзником ФБР. Несомненно, Ганнибал Лектер - маньяк, но он и философ, и блестящий психиатр. Его мучает скука и отсутствие "интересных" книг в тюремной библиотеке. Зайдя в тупик в расследовании дела серийного убийцы, прозванного Красным Драконом, ФБР обращается к доктору Лектеру. Ведь только маньяк может понять маньяка. И Ганнибал Лектер принимает предложение. Для него важно доказать, что он умнее преступника, которого ищет ФБР.',
    2019,
    14,
    650,
    ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'Эксмо' ),
    (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Книга')
);

INSERT INTO TAG (
    TAG
) VALUES (
    'ФБР'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'ФБР'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'Лектер'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'Лектер'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'Ганнибал'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'Ганнибал'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'маньяк'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'маньяк'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AUTHOR (
    FIRST_NAME,
    LAST_NAME,
    FATHER_NAME
) VALUES (
    'Томас',
    'Харрис',
    'Энтони'
);

INSERT INTO BOOK_HAVE_GENRE(
    ID_GENRE,
    ID_BOOK
) VALUES (
    (SELECT ID FROM GENRE WHERE GENRE = 'Детективы'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AUTHOR_WROTE_BOOK (
    ID_AUTHOR,
    ID_BOOK
) VALUES (
    (SELECT ID FROM AUTHOR WHERE FIRST_NAME = 'Томас' AND LAST_NAME = 'Харрис'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AMOUNT_OF_BOOK (
    ID_BOOK,
    TOTAL,
    STORE
) VALUES (
    (SELECT COUNT(*) FROM BOOK),
    19,
    19
);

-----------------------------------------


INSERT INTO BOOK (
    TITLE,
    SUMMARY,
    YEAR_OF_PUBLICATION,
    AGE_LIMIT,
    PRICE,
    ID_PUBLISHER,
    ID_BOOK_TYPE
) VALUES (
    'Гомункул. Приключения Лэнгдона Сент-Ива',
    'Джеймс Блэйлок, знаменитый американский фантаст и лауреат множества престижных премий, положил начало движению стимпанка в литературе. Его роман "Гомункул" - настоящая жемчужина этого жанра: абсурдистская "черная комедия", в которой атмосфера, обычаи и технологии Викторианской эпохи соседствуют с таинствами древней магии, загадками далекого космоса и захватывающими приключениями в духе Жюля Верна и Герберта Уэллса. "Гомункул" - первое из цикла произведений, повествующих об удивительных похождениях профессора Лэнгдона Сент-Ива, ученого-изобретателя, большого охотника до всяческих диковин и джентльмена до мозга костей. Роман Блэйлока удостоен Премии им. Филипа К. Дика. Впервые на русском языке.',
    2022,
    10,
    827,
    ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'Аркадия' ),
    (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Книга')
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'роман'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'Гомункул'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'Гомункул'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'Блэйлок'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'Блэйлок'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'Джеймс'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'Джеймс'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO GENRE (
    GENRE
) VALUES (
    'Фантастический зарубежный боевик'
);

INSERT INTO AUTHOR (
    FIRST_NAME,
    LAST_NAME,
    FATHER_NAME
) VALUES (
    'Джеймс',
    'Блэйлок',
    ''
);

INSERT INTO BOOK_HAVE_GENRE(
    ID_GENRE,
    ID_BOOK
) VALUES (
    (SELECT ID FROM GENRE WHERE GENRE = 'Фантастический зарубежный боевик'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AUTHOR_WROTE_BOOK (
    ID_AUTHOR,
    ID_BOOK
) VALUES (
    (SELECT ID FROM AUTHOR WHERE FIRST_NAME = 'Джеймс' AND LAST_NAME = 'Блэйлок'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AUTHOR_WROTE_BOOK (
    ID_AUTHOR,
    ID_BOOK
) VALUES (
    (SELECT ID FROM AUTHOR WHERE FIRST_NAME = 'Томас' AND LAST_NAME = 'Харрис'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AMOUNT_OF_BOOK (
    ID_BOOK,
    TOTAL,
    STORE
) VALUES (
    (SELECT COUNT(*) FROM BOOK),
    14,
    14
);

-----------------------------------------


INSERT INTO PUBLISHER (
    PUBLISHER
) VALUES (
    'fanzon'
);

INSERT INTO BOOK (
    TITLE,
    SUMMARY,
    YEAR_OF_PUBLICATION,
    AGE_LIMIT,
    PRICE,
    ID_PUBLISHER,
    ID_BOOK_TYPE
) VALUES (
    'Тень',
    'Финал первой трилогии MATERIA PRIMA. Чем закончится последняя схватка с неумолимым противником?Срок мирного договора между Варшавской республикой, Российской и Германской империями подходит к концу. Новое наступление на Варшаву неминуемо. Лидер Кинжальщиков смертельно болен, и предстоят выборы преемника.Граф Самарин оставил военную карьеру, но теперь вовлечен в придворные интриги. Алхимик Рудницкий берется расследовать ритуальные убийства и, как обычно, разматывает клубок, ведущий к Проклятым.Библейская легенда о нефилимах подтверждается, но Рудницкий и предположить не мог, что это коснется и его лично."Materia Prima по-прежнему один из самых крутых сериалов в польском фэнтези за последние годы, давайте не будем забывать об этом". - taniaksiazka.pl"Действие стремительное, скучать невозможно". - Empic.pl"Это отличная книга, сочетающая в себе фэнтези, исторический ...',
    2021,
    13,
    586,
    ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'fanzon' ),
    (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Книга')
);

INSERT INTO TAG (
    TAG
) VALUES (
    'Рудницкий'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'Рудницкий'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'фэнтези'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'фэнтези'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO GENRE (
    GENRE
) VALUES (
    'Героическое зарубежное фэнтези'
);

INSERT INTO AUTHOR (
    FIRST_NAME,
    LAST_NAME,
    FATHER_NAME
) VALUES (
    'Адам',
    'Пшехшта',
    ''
);

INSERT INTO BOOK_HAVE_GENRE(
    ID_GENRE,
    ID_BOOK
) VALUES (
    (SELECT ID FROM GENRE WHERE GENRE = 'Героическое зарубежное фэнтези'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AUTHOR_WROTE_BOOK (
    ID_AUTHOR,
    ID_BOOK
) VALUES (
    (SELECT ID FROM AUTHOR WHERE FIRST_NAME = 'Адам' AND LAST_NAME = 'Пшехшта'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AUTHOR_WROTE_BOOK (
    ID_AUTHOR,
    ID_BOOK
) VALUES (
    (SELECT ID FROM AUTHOR WHERE FIRST_NAME = 'Томас' AND LAST_NAME = 'Харрис'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AMOUNT_OF_BOOK (
    ID_BOOK,
    TOTAL,
    STORE
) VALUES (
    (SELECT COUNT(*) FROM BOOK),
    22,
    22
);

-----------------------------------------




INSERT INTO BOOK (
    TITLE,
    SUMMARY,
    YEAR_OF_PUBLICATION,
    AGE_LIMIT,
    PRICE,
    ID_PUBLISHER,
    ID_BOOK_TYPE
) VALUES (
    'Час Быка',
    '"В "Часе Быка" я представил планету, на которую переселилась группа землян, они повторяют пионерское завоевание запада Америки, но на гораздо более высокой технической основе. Неимоверно ускоренный рост населения и капиталистическое хозяйствование привели к истощению планеты и массовой смертности от голода и болезней. Государственный строй на ограбленной планете, естественно, должен быть олигархическим. Чтобы построить модель подобного государства, я продолжил в будущее те тенденции гангстерского фашиствующего монополизма, какие зарождаются сейчас в Америке и некоторых других странах, пытающихся сохранить "свободу" частного предпринимательства на густой националистической основе.  Понятно, что не наука и техника отдаленного будущего или странные цивилизации безмерно далеких миров сделались целью моего романа. Люди будущей Земли, выращенные многовековым существова...',
    2022,
    3,
    295,
    ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'Эксмо' ),
    (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Книга')
);

INSERT INTO TAG (
    TAG
) VALUES (
    'основе'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'основе'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'Часе'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'Часе'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'представил'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'представил'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'Быка'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'Быка'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AUTHOR (
    FIRST_NAME,
    LAST_NAME,
    FATHER_NAME
) VALUES (
    'Иван',
    'Ефремов',
    'Антонович'
);

INSERT INTO BOOK_HAVE_GENRE(
    ID_GENRE,
    ID_BOOK
) VALUES (
    (SELECT ID FROM GENRE WHERE GENRE = 'фантастика'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AUTHOR_WROTE_BOOK (
    ID_AUTHOR,
    ID_BOOK
) VALUES (
    (SELECT ID FROM AUTHOR WHERE FIRST_NAME = 'Иван' AND LAST_NAME = 'Ефремов'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AMOUNT_OF_BOOK (
    ID_BOOK,
    TOTAL,
    STORE
) VALUES (
    (SELECT COUNT(*) FROM BOOK),
    14,
    14
);

-----------------------------------------



INSERT INTO BOOK (
    TITLE,
    SUMMARY,
    YEAR_OF_PUBLICATION,
    AGE_LIMIT,
    PRICE,
    ID_PUBLISHER,
    ID_BOOK_TYPE
) VALUES (
    'Понедельник начинается в субботу',
    'В этот том вошел знаменитый роман братьев Стругацких  «Понедельник начинается в субботу» — буквально раздерганная на цитаты история веселых, остроумных сотрудников таинственного института НИИЧАВО, где вполне всерьез занимаются исследованием магии и волшебства.',
    2019,
    10,
    467,
    ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'АСТ' ),
    (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Книга')
);

INSERT INTO TAG (
    TAG
) VALUES (
    'вошел'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'вошел'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'знаменитый'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'знаменитый'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'роман'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'братьев'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'братьев'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AUTHOR (
    FIRST_NAME,
    LAST_NAME,
    FATHER_NAME
) VALUES (
    'Аркадий',
    'Стругацкий',
    'Натанович,'
);

INSERT INTO BOOK_HAVE_GENRE(
    ID_GENRE,
    ID_BOOK
) VALUES (
    (SELECT ID FROM GENRE WHERE GENRE = 'фантастика'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AUTHOR_WROTE_BOOK (
    ID_AUTHOR,
    ID_BOOK
) VALUES (
    (SELECT ID FROM AUTHOR WHERE FIRST_NAME = 'Аркадий' AND LAST_NAME = 'Стругацкий'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AMOUNT_OF_BOOK (
    ID_BOOK,
    TOTAL,
    STORE
) VALUES (
    (SELECT COUNT(*) FROM BOOK),
    74,
    1
);

-----------------------------------------




INSERT INTO BOOK (
    TITLE,
    SUMMARY,
    YEAR_OF_PUBLICATION,
    AGE_LIMIT,
    PRICE,
    ID_PUBLISHER,
    ID_BOOK_TYPE
) VALUES (
    'Париж - всегда отличная идея!',
    'Новый роман автора бестселлеров The New York Times Джен МакКинли "Париж - всегда отличная идея!" назван лучшей книгой лета 2020 по версии Popsugar.Главная героиня книги, Челси, осознает, что последний раз была счастлива, влюблена и наслаждалась жизнью, когда жила год за границей. Вдохновившись теплыми и радостными воспоминаниями, Челси разыскивает Колина в Ирландии, Жан-Клода во Франции и Марчеллино в Италии в надежде, что один из этих трех мужчин, похитивших ее сердце много лет назад, на самом деле и был любовью всей ее жизни. В поисках себя и мужчины свой мечты Челси встречается лицом к лицу со своими страхами, прощается с иллюзиями и наконец находит свою любовь там, где никогда бы не подумала ее искать.',
    2005,
    8,
    845,
    ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'Феникс' ),
    (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Книга')
);

INSERT INTO TAG (
    TAG
) VALUES (
    'Челси'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'Челси'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'Новый'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'Новый'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'автора'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'автора'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'роман'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO GENRE (
    GENRE
) VALUES (
    'Современный сентиментальный роман'
);

INSERT INTO AUTHOR (
    FIRST_NAME,
    LAST_NAME,
    FATHER_NAME
) VALUES (
    'Джен',
    'МакКинли',
    ''
);

INSERT INTO BOOK_HAVE_GENRE(
    ID_GENRE,
    ID_BOOK
) VALUES (
    (SELECT ID FROM GENRE WHERE GENRE = 'Современный сентиментальный роман'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AUTHOR_WROTE_BOOK (
    ID_AUTHOR,
    ID_BOOK
) VALUES (
    (SELECT ID FROM AUTHOR WHERE FIRST_NAME = 'Джен' AND LAST_NAME = 'МакКинли'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AMOUNT_OF_BOOK (
    ID_BOOK,
    TOTAL,
    STORE
) VALUES (
    (SELECT COUNT(*) FROM BOOK),
    14,
    1
);

-----------------------------------------




INSERT INTO BOOK (
    TITLE,
    SUMMARY,
    YEAR_OF_PUBLICATION,
    AGE_LIMIT,
    PRICE,
    ID_PUBLISHER,
    ID_BOOK_TYPE
) VALUES (
    'Все твои совершенства',
    'Любимый автор пользователей TikTok, более 610 миллионов упоминаний. "Трудно признать, что браку пришел конец, когда любовь еще не ушла. Люди привыкли считать, что брак заканчивается только с утратой любви. Когда на место счастья приходит злость.  Но мы с Грэмом не злимся друг на друга. Мы просто стали другими.  Мы с Грэмом так давно смотрим в противоположные стороны, что я даже не могу вспомнить, какие у него глаза, когда он внутри меня.  Зато уверена, что он помнит, как выглядит каждый волосок на моем затылке, когда я отворачиваюсь от него по ночам".  Совершенной любви Куинн и Грэмма угрожает их несовершенный брак.  Они познакомились при сложных обстоятельствах. Драматичное, но красивое начало. Сейчас же близится конец. Что может спасти их отношения?  Куинн уверена, что должна забеременеть. Но ее уверенность становится и тем, что ведет их брак к концу.  Сколько ...',
    2015,
    13,
    600,
    ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'Эксмо' ),
    (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Книга')
);

INSERT INTO TAG (
    TAG
) VALUES (
    'брак'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'брак'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'любви'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'любви'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'уверена'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'уверена'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'Грэмом'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'Грэмом'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AUTHOR (
    FIRST_NAME,
    LAST_NAME,
    FATHER_NAME
) VALUES (
    'Колин',
    'Гувер',
    ''
);

INSERT INTO BOOK_HAVE_GENRE(
    ID_GENRE,
    ID_BOOK
) VALUES (
    (SELECT ID FROM GENRE WHERE GENRE = 'Современный сентиментальный роман'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AUTHOR_WROTE_BOOK (
    ID_AUTHOR,
    ID_BOOK
) VALUES (
    (SELECT ID FROM AUTHOR WHERE FIRST_NAME = 'Колин' AND LAST_NAME = 'Гувер'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AMOUNT_OF_BOOK (
    ID_BOOK,
    TOTAL,
    STORE
) VALUES (
    (SELECT COUNT(*) FROM BOOK),
    64,
    64
);

-----------------------------------------


INSERT INTO PUBLISHER (
    PUBLISHER
) VALUES (
    'Inspiria'
);

INSERT INTO BOOK (
    TITLE,
    SUMMARY,
    YEAR_OF_PUBLICATION,
    AGE_LIMIT,
    PRICE,
    ID_PUBLISHER,
    ID_BOOK_TYPE
) VALUES (
    'Глядя на море',
    'Франсуаза Бурден - одна из ведущих авторов европейского "эмоционального романа".  Во Франции ее книги разошлись общим тиражом более 8 млн экземпляров.  "Le Figaro" охарактеризовала Франсуазу Бурден как одного из шести популярнейших авторов страны.  В мире романы Франсуазы представлены на 15 иностранных языках.     "Трогательный роман, прочно обосновавшийся на вершине книжных рейтингов". - France Info  "Франсуаза Бурден завораживает своим писательским талантом". - L Obs  "Романтичная оптимистка Франсуаза Бурден готова показать нам лучшее в мужчинах". - Le Parisien   Больше всего на свете Матье любит свой успешный книжный магазин, где проводит дни, а порой и ночи. Он все сильнее отдаляется от Тесс, которая, в свою очередь, больше всего на свете любит его.  Действие разворачивается в портовом городе, в Нормандии, где соленый воздух свободы пропитал все улицы. Тесс ...',
    2014,
    3,
    564,
    ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'Inspiria' ),
    (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Книга')
);

INSERT INTO TAG (
    TAG
) VALUES (
    'Бурден'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'Бурден'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'Франсуаза'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'Франсуаза'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'авторов'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'авторов'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'больше'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AUTHOR (
    FIRST_NAME,
    LAST_NAME,
    FATHER_NAME
) VALUES (
    'Франсуаза',
    'Бурден',
    ''
);

INSERT INTO BOOK_HAVE_GENRE(
    ID_GENRE,
    ID_BOOK
) VALUES (
    (SELECT ID FROM GENRE WHERE GENRE = 'Современный сентиментальный роман'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AUTHOR_WROTE_BOOK (
    ID_AUTHOR,
    ID_BOOK
) VALUES (
    (SELECT ID FROM AUTHOR WHERE FIRST_NAME = 'Франсуаза' AND LAST_NAME = 'Бурден'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AMOUNT_OF_BOOK (
    ID_BOOK,
    TOTAL,
    STORE
) VALUES (
    (SELECT COUNT(*) FROM BOOK),
    14,
    1
);

-----------------------------------------



INSERT INTO BOOK (
    TITLE,
    SUMMARY,
    YEAR_OF_PUBLICATION,
    AGE_LIMIT,
    PRICE,
    ID_PUBLISHER,
    ID_BOOK_TYPE
) VALUES (
    'Пандора',
    'Дебютный роман британской писательницы Сьюзен Стокс-Чепмен — идеальное сочетание георгианской Англии и греческой мифологии. Международный бестселлер, права на издание выкуплены в 15 странах.  Лондон, 1799 год. Дора Блейк, начинающая художница-ювелир, живет со своей ручной сорокой в лавке древностей. Ныне место принадлежит ее дяде и находится в упадке, но в былые времена магазинчик родителей Доры был очень известным благодаря широкому ассортименту подлинных произведений искусства. Появление пифоса — загадочной древнегреческой вазы — и скрываемые им секреты меняют жизнь девушки: она видит шанс вернуть магазин и избавиться от гнета дяди. Однако заинтересованных в пифосе оказывается слишком много: кто-то благодаря ему может проложить дорогу в академическое будущее, другой — потешить самолюбие, а третий — сполна удовлетворить жажду денег. Что за тайны скрывает древняя находка и к...',
    2009,
    15,
    796,
    ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'Inspiria' ),
    (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Книга')
);

INSERT INTO TAG (
    TAG
) VALUES (
    'благодаря'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'благодаря'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'Дебютный'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'Дебютный'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'британской'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'британской'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'роман'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'роман'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO GENRE (
    GENRE
) VALUES (
    'Исторический роман'
);

INSERT INTO AUTHOR (
    FIRST_NAME,
    LAST_NAME,
    FATHER_NAME
) VALUES (
    'Сьюзен',
    'Стокс-Чепмен',
    ''
);

INSERT INTO BOOK_HAVE_GENRE(
    ID_GENRE,
    ID_BOOK
) VALUES (
    (SELECT ID FROM GENRE WHERE GENRE = 'Исторический роман'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AUTHOR_WROTE_BOOK (
    ID_AUTHOR,
    ID_BOOK
) VALUES (
    (SELECT ID FROM AUTHOR WHERE FIRST_NAME = 'Сьюзен' AND LAST_NAME = 'Стокс-Чепмен'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AMOUNT_OF_BOOK (
    ID_BOOK,
    TOTAL,
    STORE
) VALUES (
    (SELECT COUNT(*) FROM BOOK),
    14,
    14
);

-----------------------------------------



INSERT INTO BOOK (
    TITLE,
    SUMMARY,
    YEAR_OF_PUBLICATION,
    AGE_LIMIT,
    PRICE,
    ID_PUBLISHER,
    ID_BOOK_TYPE
) VALUES (
    'Шоколад',
    'Сонное спокойствие маленького французского городка нарушено приездом молодой женщины Вианн и ее дочери. Они появились вместе с шумным и ярким карнавальным шествием, а когда карнавал закончился, его светлая радость осталась в глазах Вианн, открывшей здесь свой Шоколадный магазин. Каким-то чудесным образом она узнает о сокровенных желаниях жителей городка и предлагает каждому именно такое шоколадное лакомство, которое заставляет его вновь почувствовать вкус к жизни."Шоколад" - это история о доброте и терпимости, о противостоянии невинных соблазнов и закоснелой праведности. Одноименный голливудский фильм режиссера Лассе Халлстрёма (с Жюльетт Бинош, Джонни Деппом и Джуди Денч в главных ролях) был номинирован на "Оскар" в пяти категориях и на "Золотой глобус" - в четырех.',
    2020,
    15,
    369,
    ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'Эксмо' ),
    (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Книга')
);

INSERT INTO TAG (
    TAG
) VALUES (
    'городка'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'городка'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'Вианн'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'Вианн'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'спокойствие'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'спокойствие'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO TAG (
    TAG
) VALUES (
    'Сонное'
);

INSERT INTO BOOK_HAVE_TAG(
    ID_TAG,
    ID_BOOK
) VALUES (
    (SELECT ID FROM TAG WHERE TAG = 'Сонное'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO GENRE (
    GENRE
) VALUES (
    'Современная зарубежная проза'
);

INSERT INTO AUTHOR (
    FIRST_NAME,
    LAST_NAME,
    FATHER_NAME
) VALUES (
    'Джоанн',
    'Харрис',
    ''
);

INSERT INTO BOOK_HAVE_GENRE(
    ID_GENRE,
    ID_BOOK
) VALUES (
    (SELECT ID FROM GENRE WHERE GENRE = 'Современная зарубежная проза'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AUTHOR_WROTE_BOOK (
    ID_AUTHOR,
    ID_BOOK
) VALUES (
    (SELECT ID FROM AUTHOR WHERE FIRST_NAME = 'Джоанн' AND LAST_NAME = 'Харрис'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AMOUNT_OF_BOOK (
    ID_BOOK,
    TOTAL,
    STORE
) VALUES (
    (SELECT COUNT(*) FROM BOOK),
    12,
    12
);

-----------------------------------------
INSERT INTO BOOK (
    TITLE,
    SUMMARY,
    YEAR_OF_PUBLICATION,
    AGE_LIMIT,
    PRICE,
    ID_PUBLISHER,
    ID_BOOK_TYPE
) VALUES (
    'Игромания',
    'Выпуск 01.19',
    2019,
    3,
    163,
    ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'Манн' ),
    (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Журнал')
);

INSERT INTO GENRE (
    GENRE
) VALUES (
    'Развлекательная литература'
);

INSERT INTO BOOK_HAVE_GENRE(
    ID_GENRE,
    ID_BOOK
) VALUES (
    (SELECT ID FROM GENRE WHERE GENRE = 'Развлекательная литература'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AUTHOR_WROTE_BOOK (
    ID_AUTHOR,
    ID_BOOK
) VALUES (
    (SELECT ID FROM AUTHOR WHERE FIRST_NAME = 'Дуглас' AND LAST_NAME = 'Абрамс'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AMOUNT_OF_BOOK (
    ID_BOOK,
    TOTAL,
    STORE
) VALUES (
    (SELECT COUNT(*) FROM BOOK),
    16,
    16
);

-----------------------------------------
INSERT INTO BOOK (
    TITLE,
    SUMMARY,
    YEAR_OF_PUBLICATION,
    AGE_LIMIT,
    PRICE,
    ID_PUBLISHER,
    ID_BOOK_TYPE
) VALUES (
    'Буревестник',
    'Выпуск 04.14',
    2014,
    3,
    20,
    ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'Манн' ),
    (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Газета')
);

INSERT INTO BOOK_HAVE_GENRE(
    ID_GENRE,
    ID_BOOK
) VALUES (
    (SELECT ID FROM GENRE WHERE GENRE = 'Развлекательная литература'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AUTHOR_WROTE_BOOK (
    ID_AUTHOR,
    ID_BOOK
) VALUES (
    (SELECT ID FROM AUTHOR WHERE FIRST_NAME = 'Дуглас' AND LAST_NAME = 'Абрамс'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AMOUNT_OF_BOOK (
    ID_BOOK,
    TOTAL,
    STORE
) VALUES (
    (SELECT COUNT(*) FROM BOOK),
    16,
    16
);

-----------------------------------------

INSERT INTO RATING (
    RATING
) VALUES (
    0
);

INSERT INTO RATING (
    RATING
) VALUES (
    1
);

INSERT INTO RATING (
    RATING
) VALUES (
    2
);

INSERT INTO RATING (
    RATING
) VALUES (
    3
);

INSERT INTO RATING (
    RATING
) VALUES (
    4
);

INSERT INTO RATING (
    RATING
) VALUES (
    5
);

INSERT INTO RATING (
    RATING
) VALUES (
    6
);

INSERT INTO RATING (
    RATING
) VALUES (
    7
);

INSERT INTO RATING (
    RATING
) VALUES (
    8
);

INSERT INTO RATING (
    RATING
) VALUES (
    9
);

INSERT INTO RATING (
    RATING
) VALUES (
    10
);

INSERT INTO CLIENT (
    FIRST_NAME,
    LAST_NAME,
    FATHER_NAME,
    AGE,
    EMPLOYEE,
    RATING
) VALUES (
    'Дина',
    'Евдокимова',
    'Евсеевна',
    4,
    NULL,
    6
);

-----------------------------------------$

INSERT INTO CLIENT (
    FIRST_NAME,
    LAST_NAME,
    FATHER_NAME,
    AGE,
    EMPLOYEE,
    RATING
) VALUES (
    'Валерия',
    'Фадеева',
    'Михаиловна',
    6,
    NULL,
    7
);

-----------------------------------------$

INSERT INTO CLIENT (
    FIRST_NAME,
    LAST_NAME,
    FATHER_NAME,
    AGE,
    EMPLOYEE,
    RATING
) VALUES (
    'Зара',
    'Елисеева',
    'Тимофеевна',
    8,
    NULL,
    5
);

-----------------------------------------$

INSERT INTO CLIENT (
    FIRST_NAME,
    LAST_NAME,
    FATHER_NAME,
    AGE,
    EMPLOYEE,
    RATING
) VALUES (
    'Полина',
    'Кириллова',
    'Геннадьевна',
    10,
    NULL,
    6
);

-----------------------------------------$

INSERT INTO CLIENT (
    FIRST_NAME,
    LAST_NAME,
    FATHER_NAME,
    AGE,
    EMPLOYEE,
    RATING
) VALUES (
    'Илона',
    'Самойлова',
    'Альвиановна',
    12,
    NULL,
    4
);

-----------------------------------------$

INSERT INTO CLIENT (
    FIRST_NAME,
    LAST_NAME,
    FATHER_NAME,
    AGE,
    EMPLOYEE,
    RATING
) VALUES (
    'Изабелла',
    'Симонова',
    'Натановна',
    14,
    NULL,
    5
);

-----------------------------------------$

INSERT INTO CLIENT (
    FIRST_NAME,
    LAST_NAME,
    FATHER_NAME,
    AGE,
    EMPLOYEE,
    RATING
) VALUES (
    'Северина',
    'Петрова',
    'Даниловна',
    16,
    NULL,
    6
);

-----------------------------------------$

INSERT INTO CLIENT (
    FIRST_NAME,
    LAST_NAME,
    FATHER_NAME,
    AGE,
    EMPLOYEE,
    RATING
) VALUES (
    'Августина',
    'Маслова',
    'Давидовна',
    18,
    NULL,
    7
);

-----------------------------------------$

INSERT INTO CLIENT (
    FIRST_NAME,
    LAST_NAME,
    FATHER_NAME,
    AGE,
    EMPLOYEE,
    RATING
) VALUES (
    'Олеся',
    'Осипова',
    'Альвиановна',
    20,
    'Библиотекарь',
    8
);

-----------------------------------------$

INSERT INTO CLIENT (
    FIRST_NAME,
    LAST_NAME,
    FATHER_NAME,
    AGE,
    EMPLOYEE,
    RATING
) VALUES (
    'Венера',
    'Сазонова',
    'Евгеньевна',
    22,
    NULL,
    5
);

-----------------------------------------$

INSERT INTO CLIENT (
    FIRST_NAME,
    LAST_NAME,
    FATHER_NAME,
    AGE,
    EMPLOYEE,
    RATING
) VALUES (
    'Аверьян',
    'Фокин',
    'Пётрович',
    24,
    'Библиотекарь',
    5
);

-----------------------------------------$

INSERT INTO CLIENT (
    FIRST_NAME,
    LAST_NAME,
    FATHER_NAME,
    AGE,
    EMPLOYEE,
    RATING
) VALUES (
    'Игорь',
    'Петров',
    'Мартынович',
    26,
    NULL,
    0
);

-----------------------------------------$

INSERT INTO CLIENT (
    FIRST_NAME,
    LAST_NAME,
    FATHER_NAME,
    AGE,
    EMPLOYEE,
    RATING
) VALUES (
    'Герман',
    'Гаврилов',
    'Петрович',
    28,
    'Библиотекарь',
    6
);

-----------------------------------------$

INSERT INTO CLIENT (
    FIRST_NAME,
    LAST_NAME,
    FATHER_NAME,
    AGE,
    EMPLOYEE,
    RATING
) VALUES (
    'Василий',
    'Ефимов',
    'Серапионович',
    30,
    NULL,
    0
);

-----------------------------------------$

INSERT INTO CLIENT (
    FIRST_NAME,
    LAST_NAME,
    FATHER_NAME,
    AGE,
    EMPLOYEE,
    RATING
) VALUES (
    'Клим',
    'Рябов',
    'Павлович',
    32,
    'Директор',
    7
);

-----------------------------------------$

INSERT INTO CLIENT (
    FIRST_NAME,
    LAST_NAME,
    FATHER_NAME,
    AGE,
    EMPLOYEE,
    RATING
) VALUES (
    'Лазарь',
    'Маслов',
    'Мартынович',
    34,
    NULL,
    8
);

-----------------------------------------$

INSERT INTO CLIENT (
    FIRST_NAME,
    LAST_NAME,
    FATHER_NAME,
    AGE,
    EMPLOYEE,
    RATING
) VALUES (
    'Богдан',
    'Соколов',
    'Ярославович',
    36,
    'Библиотекарь',
    8
);

-----------------------------------------$

INSERT INTO CLIENT (
    FIRST_NAME,
    LAST_NAME,
    FATHER_NAME,
    AGE,
    EMPLOYEE,
    RATING
) VALUES (
    'Болеслав',
    'Лапин',
    'Леонидович',
    38,
    NULL,
    9
);

-----------------------------------------$

INSERT INTO CLIENT (
    FIRST_NAME,
    LAST_NAME,
    FATHER_NAME,
    AGE,
    EMPLOYEE,
    RATING
) VALUES (
    'Остап',
    'Карпов',
    'Христофорович',
    40,
    NULL,
    9
);

-----------------------------------------$

INSERT INTO CLIENT (
    FIRST_NAME,
    LAST_NAME,
    FATHER_NAME,
    AGE,
    EMPLOYEE,
    RATING
) VALUES (
    'Савелий',
    'Селиверстов',
    'Мэлорович',
    42,
    NULL,
    10
);

-----------------------------------------$


INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/6/01', 'yyyy/mm/dd'),
    4,
    12
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/5/01', 'yyyy/mm/dd'),
    8,
    30
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    RETURN_BOOK,
    RATING_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/5/01', 'yyyy/mm/dd'),
    TO_DATE('2022/5/20', 'yyyy/mm/dd'),
    6,
    9,
    15
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    RETURN_BOOK,
    RATING_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/10/01', 'yyyy/mm/dd'),
    TO_DATE('2022/10/28', 'yyyy/mm/dd'),
    10,
    20,
    31
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    RETURN_BOOK,
    RATING_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/3/01', 'yyyy/mm/dd'),
    TO_DATE('2022/3/27', 'yyyy/mm/dd'),
    2,
    4,
    2
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    RETURN_BOOK,
    RATING_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/10/01', 'yyyy/mm/dd'),
    TO_DATE('2022/10/19', 'yyyy/mm/dd'),
    1,
    10,
    28
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    RETURN_BOOK,
    RATING_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/8/01', 'yyyy/mm/dd'),
    TO_DATE('2022/8/15', 'yyyy/mm/dd'),
    2,
    4,
    33
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    RETURN_BOOK,
    RATING_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/10/01', 'yyyy/mm/dd'),
    TO_DATE('2022/10/21', 'yyyy/mm/dd'),
    4,
    8,
    21
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    RETURN_BOOK,
    RATING_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/5/01', 'yyyy/mm/dd'),
    TO_DATE('2022/5/10', 'yyyy/mm/dd'),
    4,
    5,
    21
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    RETURN_BOOK,
    RATING_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/8/01', 'yyyy/mm/dd'),
    TO_DATE('2022/8/2', 'yyyy/mm/dd'),
    2,
    6,
    10
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/11/01', 'yyyy/mm/dd'),
    15,
    13
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/12/01', 'yyyy/mm/dd'),
    8,
    15
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    RETURN_BOOK,
    RATING_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/9/01', 'yyyy/mm/dd'),
    TO_DATE('2022/9/10', 'yyyy/mm/dd'),
    4,
    17,
    4
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/3/01', 'yyyy/mm/dd'),
    12,
    26
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    RETURN_BOOK,
    RATING_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/2/01', 'yyyy/mm/dd'),
    TO_DATE('2022/2/24', 'yyyy/mm/dd'),
    4,
    19,
    7
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    RETURN_BOOK,
    RATING_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/4/01', 'yyyy/mm/dd'),
    TO_DATE('2022/4/18', 'yyyy/mm/dd'),
    3,
    7,
    30
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    RETURN_BOOK,
    RATING_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/12/01', 'yyyy/mm/dd'),
    TO_DATE('2022/12/27', 'yyyy/mm/dd'),
    9,
    4,
    23
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    RETURN_BOOK,
    RATING_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/11/01', 'yyyy/mm/dd'),
    TO_DATE('2022/11/9', 'yyyy/mm/dd'),
    9,
    8,
    9
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/11/01', 'yyyy/mm/dd'),
    8,
    23
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    RETURN_BOOK,
    RATING_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/9/01', 'yyyy/mm/dd'),
    TO_DATE('2022/9/27', 'yyyy/mm/dd'),
    7,
    17,
    33
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/7/01', 'yyyy/mm/dd'),
    7,
    11
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/5/01', 'yyyy/mm/dd'),
    9,
    7
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    RETURN_BOOK,
    RATING_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/9/01', 'yyyy/mm/dd'),
    TO_DATE('2022/9/15', 'yyyy/mm/dd'),
    10,
    5,
    11
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/12/01', 'yyyy/mm/dd'),
    17,
    13
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    RETURN_BOOK,
    RATING_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/5/01', 'yyyy/mm/dd'),
    TO_DATE('2022/5/21', 'yyyy/mm/dd'),
    2,
    7,
    18
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/10/01', 'yyyy/mm/dd'),
    5,
    22
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    RETURN_BOOK,
    RATING_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/3/01', 'yyyy/mm/dd'),
    TO_DATE('2022/3/2', 'yyyy/mm/dd'),
    4,
    8,
    12
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    RETURN_BOOK,
    RATING_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/5/01', 'yyyy/mm/dd'),
    TO_DATE('2022/5/9', 'yyyy/mm/dd'),
    10,
    13,
    11
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    RETURN_BOOK,
    RATING_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/11/01', 'yyyy/mm/dd'),
    TO_DATE('2022/11/7', 'yyyy/mm/dd'),
    3,
    20,
    12
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    RETURN_BOOK,
    RATING_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/9/01', 'yyyy/mm/dd'),
    TO_DATE('2022/9/27', 'yyyy/mm/dd'),
    9,
    11,
    10
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    RETURN_BOOK,
    RATING_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/8/01', 'yyyy/mm/dd'),
    TO_DATE('2022/8/5', 'yyyy/mm/dd'),
    2,
    5,
    27
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    RETURN_BOOK,
    RATING_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/9/01', 'yyyy/mm/dd'),
    TO_DATE('2022/9/24', 'yyyy/mm/dd'),
    8,
    15,
    22
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/2/01', 'yyyy/mm/dd'),
    10,
    3
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/11/01', 'yyyy/mm/dd'),
    11,
    3
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/10/01', 'yyyy/mm/dd'),
    5,
    15
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    RETURN_BOOK,
    RATING_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/6/01', 'yyyy/mm/dd'),
    TO_DATE('2022/6/13', 'yyyy/mm/dd'),
    10,
    6,
    7
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    RETURN_BOOK,
    RATING_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/8/01', 'yyyy/mm/dd'),
    TO_DATE('2022/8/16', 'yyyy/mm/dd'),
    5,
    10,
    8
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    RETURN_BOOK,
    RATING_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/12/01', 'yyyy/mm/dd'),
    TO_DATE('2022/12/19', 'yyyy/mm/dd'),
    10,
    17,
    8
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    RETURN_BOOK,
    RATING_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/3/01', 'yyyy/mm/dd'),
    TO_DATE('2022/3/16', 'yyyy/mm/dd'),
    5,
    18,
    8
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    RETURN_BOOK,
    RATING_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/7/01', 'yyyy/mm/dd'),
    TO_DATE('2022/7/17', 'yyyy/mm/dd'),
    10,
    16,
    4
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    RETURN_BOOK,
    RATING_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/2/01', 'yyyy/mm/dd'),
    TO_DATE('2022/2/26', 'yyyy/mm/dd'),
    8,
    2,
    32
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    RETURN_BOOK,
    RATING_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/5/01', 'yyyy/mm/dd'),
    TO_DATE('2022/5/7', 'yyyy/mm/dd'),
    3,
    14,
    23
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    RETURN_BOOK,
    RATING_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/9/01', 'yyyy/mm/dd'),
    TO_DATE('2022/9/18', 'yyyy/mm/dd'),
    9,
    7,
    32
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/12/01', 'yyyy/mm/dd'),
    11,
    9
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    RETURN_BOOK,
    RATING_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/3/01', 'yyyy/mm/dd'),
    TO_DATE('2022/3/22', 'yyyy/mm/dd'),
    9,
    7,
    29
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/9/01', 'yyyy/mm/dd'),
    14,
    14
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/3/01', 'yyyy/mm/dd'),
    12,
    21
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    RETURN_BOOK,
    RATING_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/7/01', 'yyyy/mm/dd'),
    TO_DATE('2022/7/12', 'yyyy/mm/dd'),
    2,
    2,
    6
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    RETURN_BOOK,
    RATING_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/8/01', 'yyyy/mm/dd'),
    TO_DATE('2022/8/10', 'yyyy/mm/dd'),
    6,
    2,
    6
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    RETURN_BOOK,
    RATING_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/5/01', 'yyyy/mm/dd'),
    TO_DATE('2022/5/13', 'yyyy/mm/dd'),
    3,
    13,
    24
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    RETURN_BOOK,
    RATING_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/8/01', 'yyyy/mm/dd'),
    TO_DATE('2022/8/3', 'yyyy/mm/dd'),
    5,
    3,
    18
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    RETURN_BOOK,
    RATING_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/9/01', 'yyyy/mm/dd'),
    TO_DATE('2022/9/30', 'yyyy/mm/dd'),
    3,
    13,
    5
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    RETURN_BOOK,
    RATING_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/8/01', 'yyyy/mm/dd'),
    TO_DATE('2022/8/25', 'yyyy/mm/dd'),
    9,
    14,
    3
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/3/01', 'yyyy/mm/dd'),
    13,
    23
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    RETURN_BOOK,
    RATING_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/5/01', 'yyyy/mm/dd'),
    TO_DATE('2022/5/27', 'yyyy/mm/dd'),
    3,
    16,
    33
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/2/01', 'yyyy/mm/dd'),
    3,
    22
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    RETURN_BOOK,
    RATING_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/4/01', 'yyyy/mm/dd'),
    TO_DATE('2022/4/6', 'yyyy/mm/dd'),
    4,
    14,
    4
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/3/01', 'yyyy/mm/dd'),
    14,
    17
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/7/01', 'yyyy/mm/dd'),
    6,
    25
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    RETURN_BOOK,
    RATING_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/12/01', 'yyyy/mm/dd'),
    TO_DATE('2022/12/6', 'yyyy/mm/dd'),
    6,
    6,
    17
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    RETURN_BOOK,
    RATING_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/5/01', 'yyyy/mm/dd'),
    TO_DATE('2022/5/25', 'yyyy/mm/dd'),
    8,
    19,
    25
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    RETURN_BOOK,
    RATING_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/9/01', 'yyyy/mm/dd'),
    TO_DATE('2022/9/10', 'yyyy/mm/dd'),
    5,
    11,
    11
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/3/01', 'yyyy/mm/dd'),
    9,
    8
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    RETURN_BOOK,
    RATING_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/5/01', 'yyyy/mm/dd'),
    TO_DATE('2022/5/26', 'yyyy/mm/dd'),
    4,
    20,
    23
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/8/01', 'yyyy/mm/dd'),
    8,
    9
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    RETURN_BOOK,
    RATING_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/6/01', 'yyyy/mm/dd'),
    TO_DATE('2022/6/23', 'yyyy/mm/dd'),
    7,
    6,
    7
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    RETURN_BOOK,
    RATING_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/8/01', 'yyyy/mm/dd'),
    TO_DATE('2022/8/26', 'yyyy/mm/dd'),
    9,
    6,
    8
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/9/01', 'yyyy/mm/dd'),
    12,
    29
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    RETURN_BOOK,
    RATING_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/2/01', 'yyyy/mm/dd'),
    TO_DATE('2022/2/10', 'yyyy/mm/dd'),
    3,
    18,
    20
);

INSERT INTO LOG_DELIVERY_RETURN_BOOK (
    TAKE_BOOK,
    ID_CLIENT,
    ID_BOOK
) VALUES (
    TO_DATE('2022/5/01', 'yyyy/mm/dd'),
    14,
    6
);


-----------------
INSERT INTO BOOK (
    TITLE,
    SUMMARY,
    YEAR_OF_PUBLICATION,
    AGE_LIMIT,
    PRICE,
    ID_PUBLISHER,
    ID_BOOK_TYPE
) VALUES (
    'Книга тест7',
    'Два великих духовных лидера. Пять дней. Один вечный вопрос.В апреле 2015 года два самых радостных человека на свете - лауреаты Нобелевской премии Далай-лама и архиепископ Туту - встретились в Дхарамсале, чтобы отметить восьмидесятый день рождения Его Святейшества, оглянуться на прожитые годы, полные непростых испытаний, и найти ответ на вечный вопрос: как найти радость в жизни, когда нас обуревают повседневные невзгоды - от недовольства дорожными пробками до страха, что мы не сможем обеспечить семью, от злости на тех, кто несправедливо с нами обошелся, до горя утраты любимого человека, от опустошенности, которую приносит тяжелая болезнь, до бездны отчаяния, приходящей со смертью?Диалоги велись в течение недели. Духовные мастера обсуждали препятствия, которые мешают нам радоваться жизни, подробно проговаривали негативные эмоции, их воздействие на человека и...',
    2022,
    13,
    1638,
    ( SELECT ID FROM PUBLISHER WHERE PUBLISHER = 'Манн' ),
    (SELECT ID FROM BOOK_TYPE WHERE TYPE = 'Книга')
);



INSERT INTO BOOK_HAVE_GENRE(
    ID_GENRE,
    ID_BOOK
) VALUES (
    (SELECT ID FROM GENRE WHERE GENRE = 'Религии мира'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO BOOK_HAVE_GENRE(
    ID_GENRE,
    ID_BOOK
) VALUES (
    (SELECT ID FROM GENRE WHERE GENRE = 'фантастика'),
    (SELECT COUNT(*) FROM BOOK)
);

INSERT INTO AUTHOR_WROTE_BOOK (
    ID_AUTHOR,
    ID_BOOK
) VALUES (
    (SELECT ID FROM AUTHOR WHERE FIRST_NAME = 'Дуглас' AND LAST_NAME = 'Абрамс'),
    (SELECT COUNT(*) FROM BOOK)
);

