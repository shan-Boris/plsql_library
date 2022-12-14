CREATE TABLE RATING (
    RATING NUMBER(3, 1),
    STIMULATION VARCHAR2(100) DEFAULT NULL
);

CREATE TABLE CLIENT (
    ID INTEGER DEFAULT CLIENT_ID_SEQ.NEXTVAL,
    FIRST_NAME VARCHAR2(50),
    LAST_NAME VARCHAR2(50),
    FATHER_NAME VARCHAR2(50),
    AGE INTEGER,
    EMPLOYEE VARCHAR2(50) DEFAULT NULL,
    RATING NUMBER(3, 1)
);

CREATE TABLE CARD_CHANGE_TIME (
    ID INTEGER,
    CREATE_CARD DATE NOT NULL,
    CHANGE_CARD DATE,
    DELETE_CARD DATE
);

CREATE TABLE LOG_READING_ROOM (
    ID INTEGER DEFAULT LOG_READING_ROOM_ID_SEQ.NEXTVAL,
    ID_CLIENT INTEGER,
    ARRIVE DATE ,
    LEAVING DATE
);

CREATE TABLE PUBLISHER (
    ID INTEGER DEFAULT PUBLISHER_ID_SEQ.NEXTVAL,
    PUBLISHER VARCHAR2(100)
);

CREATE TABLE BOOK_TYPE (
    ID INTEGER DEFAULT BOOK_TYPE_ID_SEQ.NEXTVAL,
    TYPE VARCHAR2(50)
);

CREATE TABLE BOOK (
    ID INTEGER DEFAULT BOOK_ID_SEQ.NEXTVAL,
    TITLE VARCHAR2(300) ,
    SUMMARY VARCHAR2(2000),
    YEAR_OF_PUBLICATION INTEGER,
    AGE_LIMIT INTEGER,
    PRICE NUMBER(8, 2),
    ID_PUBLISHER INTEGER,
    ID_BOOK_TYPE INTEGER
);

CREATE TABLE AMOUNT_OF_BOOK (
    ID_BOOK INTEGER,
    TOTAL INTEGER ,
    STORE INTEGER
);

CREATE TABLE LOG_DELIVERY_RETURN_BOOK (
    ID INTEGER DEFAULT LOG_DELIVERY_RETURN_BOOK_ID_SEQ.NEXTVAL,
    TAKE_BOOK DATE ,
    RETURN_BOOK DATE,
    RATING_BOOK NUMBER(3, 1),
    ID_CLIENT INTEGER,
    ID_BOOK INTEGER
);

CREATE TABLE LOG_ADD_DELETE_BOOK (
    ID INTEGER DEFAULT LOG_ADD_DELETE_BOOK_ID_SEQ.NEXTVAL,
    DATELOG DATE ,
    AMOUNT INTEGER,
    NOTE VARCHAR2(100),
    ID_CLIENT INTEGER,
    ID_BOOK INTEGER,
    ID_PUBLISHER INTEGER
);

CREATE TABLE TAG (
    ID INTEGER DEFAULT TAG_ID_SEQ.NEXTVAL,
    TAG VARCHAR2(50)
);

CREATE TABLE BOOK_HAVE_TAG (
    ID INTEGER DEFAULT BOOK_HAVE_TAG_ID_SEQ.NEXTVAL,
    ID_TAG INTEGER,
    ID_BOOK INTEGER
);

CREATE TABLE AUTHOR (
    ID INTEGER DEFAULT AUTHOR_ID_SEQ.NEXTVAL,
    FIRST_NAME VARCHAR2(50) ,
    LAST_NAME VARCHAR2(50) ,
    FATHER_NAME VARCHAR2(50)
);

CREATE TABLE AUTHOR_WROTE_BOOK (
    ID INTEGER DEFAULT AUTHOR_WROTE_BOOK_ID_SEQ.NEXTVAL,
    ID_AUTHOR INTEGER,
    ID_BOOK INTEGER
);

CREATE TABLE GENRE (
    ID INTEGER DEFAULT GENRE_ID_SEQ.NEXTVAL,
    GENRE VARCHAR2(350)
);

CREATE TABLE BOOK_HAVE_GENRE (
    ID INTEGER DEFAULT BOOK_HAVE_GENRE_ID_SEQ.NEXTVAL,
    ID_GENRE INTEGER,
    ID_BOOK INTEGER
);

CREATE TABLE PREFERENCE (
    ID INTEGER DEFAULT PREFERENCE_ID_SEQ.NEXTVAL,
    ID_GENRE INTEGER,
    ID_CLIENT INTEGER
);