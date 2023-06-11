

DROP TABLE Person CASCADE; 
DROP TABLE Post CASCADE;
DROP TABLE Likes CASCADE;
DROP SEQUENCE Person_seq, likes_seq, post_seq;

CREATE TABLE Person( 
person_id 	DECIMAL(12) NOT NULL, 
first_name 	VARCHAR(32) NOT NULL, 
last_name 	VARCHAR(32) NOT NULL, 
username  	VARCHAR(20) NOT NULL, 
PRIMARY KEY (person_id)); 

CREATE TABLE Post( 
post_id 	DECIMAL(12) NOT NULL, 
person_id 	DECIMAL(12) NOT NULL, 
content  	VARCHAR(255) NOT NULL, 
created_on 	DATE NOT NULL,
summary 	VARCHAR(13) NOT NULL, 
PRIMARY KEY (post_id),
FOREIGN KEY (person_id) REFERENCES Person); 
 
CREATE TABLE Likes ( 
likes_id    DECIMAL(12) NOT NULL, 
person_id 	DECIMAL(12) NOT NULL, 
post_id 	DECIMAL(12) NOT NULL, 
liked_on  	DATE, 
PRIMARY KEY (likes_id), 
FOREIGN KEY (person_id) REFERENCES Person,
FOREIGN KEY (post_id)REFERENCES Post);


CREATE SEQUENCE Person_seq START WITH 1; 
CREATE SEQUENCE Post_seq START WITH 1; 
CREATE SEQUENCE Likes_seq START WITH 1;


--Insert 5 people, 8 posts, 4 likes at minimum. 
INSERT INTO Person VALUES(nextval('person_seq'),'Chrissy','Teigen','@chrissyteigen'); 
INSERT INTO Post VALUES(nextval('post_seq'),currval('person_seq'), 
'I love this makeup, I love this length and I lovvvvvve escape rooms.', CAST('25-SEP-2022' AS DATE), 'I love thi...'); 
INSERT INTO Post VALUES(nextval('post_seq'),currval('person_seq'), 
'At @KrogerWellnessFest today, sharing intel on how to make the most perfect onion rings.', CAST('22-SEP-2022' AS DATE), 'At @Kroger...'); 
INSERT INTO Likes VALUES(nextval('likes_seq'), currval('person_seq'), currval('post_seq'), CAST('29-SEP-2022' AS DATE));
INSERT INTO Person VALUES(nextval('person_seq'),'John','Legend','@johnlegend'); 
INSERT INTO Post VALUES(nextval('post_seq'),currval('person_seq'), 
'I married my Wonder Woman 9 years ago today. Happy Aniversary, my love.', CAST('14-SEP-2022' AS DATE), 'I married ...'); 
INSERT INTO Likes VALUES(nextval('likes_seq'), currval('person_seq'), currval('post_seq'), CAST('20-SEP-2022' AS DATE));
INSERT INTO Person VALUES(nextval('person_seq'),'Kim','Kardashian','@kimkardashian'); 
INSERT INTO Post VALUES(nextval('post_seq'),currval('person_seq'), 
'Coming soon: @skims home accessories', CAST('28-SEP-2022' AS DATE), 'Coming soo...'); 
INSERT INTO Likes VALUES(nextval('likes_seq'), currval('person_seq'), currval('post_seq'), CAST('10-SEP-2022' AS DATE));
INSERT INTO Post VALUES(nextval('post_seq'),currval('person_seq'), 
'<3 a duo', CAST('27-SEP-2022' AS DATE), '<3 a duo...');
INSERT INTO Post VALUES(nextval('post_seq'),currval('person_seq'), 
'CHEETAH GIRL', CAST('27-SEP-2022' AS DATE), 'CHEETAH GI...');
INSERT INTO Person VALUES(nextval('person_seq'),'Kylie','Jenner','@kingKylie'); 
INSERT INTO Post VALUES(nextval('post_seq'),currval('person_seq'), 
'black heart <3', CAST('29-SEP-2022' AS DATE), 'black hear...');
INSERT INTO Post VALUES(nextval('post_seq'),currval('person_seq'), 
'next stop milan please', CAST('26-SEP-2022' AS DATE), 'next stop ...');
INSERT INTO Person VALUES(nextval('person_seq'),'Ariana','Grande','@arianagrande'); 
INSERT INTO Post VALUES(nextval('post_seq'),currval('person_seq'), 
'God is a woman body is now available in stores + online @ultabeauty', CAST('28-AUG-2022' AS DATE), 'God is a w...');
INSERT INTO Likes VALUES(nextval('likes_seq'), currval('person_seq'), currval('post_seq'), CAST('29-JUL-2022' AS DATE));
INSERT INTO Person VALUES(nextval('person_seq'),'Molly','Mae','@molly.mae');
INSERT INTO Post VALUES(nextval('post_seq'),currval('person_seq'), 
'Dreaming (cloud)', CAST('21-SEP-2022' AS DATE), 'Dreaming (...');
INSERT INTO Likes VALUES(nextval('likes_seq'), currval('person_seq'), currval('post_seq'), CAST('01-SEP-2022' AS DATE));

--Get the first order details. 
SELECT * FROM Likes;
SELECT * FROM Person;




CREATE OR REPLACE PROCEDURE Add_Michelle_Stella() 
AS 
$proc$ 
 BEGIN 
   INSERT INTO Person (person_id,first_name,last_name, username) 
   VALUES (nextval('Person_seq'), 'Michelle', 'Stella', '@itsmichelle'); 
 END; 
$proc$ LANGUAGE plpgsql;

CALL Add_michelle_stella();

SELECT * FROM Person;

 
CREATE OR REPLACE PROCEDURE Add_Person(
   first_name_arg IN VARCHAR, 
   last_name_arg IN VARCHAR,
	username_arg IN VARCHAR)  
   LANGUAGE plpgsql 
AS 
$resuableproc$
BEGIN 
   INSERT INTO Person(person_id, first_name, last_name, username) 
   VALUES(nextval('person_seq'), first_name_arg, last_name_arg, username_arg); 
END; 
$resuableproc$;

CALL Add_Person ('Kyle', 'McLester', '@kylito');

SELECT * FROM Person;

--Step 5: Creating Deriving Procedure

CREATE OR REPLACE PROCEDURE Add_Post( 
  p_content IN VARCHAR,
  p_created_on IN DATE)
  LANGUAGE plpgsql 
AS 
$$ 
DECLARE 
  v_summary VARCHAR(13);   --Declare a variable to hold a summary 
BEGIN 
   --Calculate the summary value and put it into the variable. 
   v_summary := SUBSTRING(p_content FROM 1 FOR 10) || '...'; 
    
   --Insert a row with the combined values of the parameters and the variable. 
   INSERT INTO Post (post_id, person_id, content, created_on, summary) 
   VALUES(nextval('post_seq'), currval('person_seq'), p_content, p_created_on, v_summary); 
END; 
$$;  

CALL Add_Post ('Loving the weather in Texas!', CAST('30-SEP-2022' AS DATE));

SELECT * FROM Post;


CREATE OR REPLACE PROCEDURE Add_Like( 
  p_username IN VARCHAR)
  LANGUAGE plpgsql 
AS $$ 
DECLARE 
  v_person_id DECIMAL(12);     
BEGIN 
   SELECT person_id
   INTO   v_person_id
   FROM   Person 
   WHERE  username = p_username; 
    
   INSERT INTO Likes(likes_id, person_id, post_id, liked_on) 
   VALUES(nextval('likes_seq'), v_person_id, currval('post_seq'), CAST(CURRENT_DATE AS DATE)); 
END; 
$$;

CALL Add_Like ('@kingKylie');

SELECT * FROM Likes
JOIN Post ON Post.post_id = Likes.post_id
JOIN Person ON Person.person_id = Likes.person_id;

CREATE OR REPLACE FUNCTION correct_summary_func() 
 RETURNS TRIGGER LANGUAGE plpgsql 
 AS $trigfunc$ 
 BEGIN 
   RAISE EXCEPTION USING MESSAGE = 'Summary is invalid.', 
   ERRCODE = 22000; 
 END; 
 $trigfunc$; 
 
CREATE TRIGGER correct_summary_trg 
BEFORE UPDATE OR INSERT ON Post 
FOR EACH ROW WHEN(NEW.summary != SUBSTRING(NEW.content FROM 1 FOR 10) || '...')
EXECUTE PROCEDURE correct_summary_func(); 

INSERT INTO Post VALUES(nextval('post_seq'),currval('person_seq'), 
'Cannot wait for Luke Colmbs', CAST(CURRENT_DATE AS DATE), 'Cannot...');

INSERT INTO Post VALUES(nextval('post_seq'),currval('person_seq'), 
'Cannot wait for Luke Colmbs', CAST(CURRENT_DATE AS DATE), 'Cannot wai...');

SELECT * FROM Post;


CREATE OR REPLACE FUNCTION block_like_func() 
RETURNS TRIGGER LANGUAGE plpgsql 
AS $$ 
DECLARE 
  	v_created_on DATE; 
BEGIN 
   SELECT Post.created_on 
   INTO   v_created_on 
   FROM   Post  
   WHERE  Post.post_id = NEW.post_id; 
    
   IF NEW.liked_on < v_created_on THEN 
     RAISE EXCEPTION USING MESSAGE = 'Like has been blocked! A post cannot be liked before it was made.', 
     ERRCODE = 22000; 
   END IF; 
   RETURN NEW; 
END; 
$$; 
 
CREATE TRIGGER blocked_like_trg 
BEFORE UPDATE OR INSERT ON Likes 
FOR EACH ROW 
EXECUTE PROCEDURE block_like_func();

INSERT INTO Likes 
VALUES(nextval('likes_seq'), currval('person_seq'), currval('post_seq'), CAST('29-JUL-2022' AS DATE));

INSERT INTO Likes 
VALUES(nextval('likes_seq'), currval('person_seq'), currval('post_seq'), CAST('02-OCT-2022' AS DATE));

INSERT INTO Likes 
VALUES(nextval('likes_seq'), currval('person_seq'), currval('post_seq'), CAST('30-SEP-2022' AS DATE));

SELECT * FROM Likes;

CREATE TABLE Post_Content_History ( 
post_id DECIMAL(12) NOT NULL, 
old_content VARCHAR(255) NOT NULL, 
new_content VARCHAR(255) NOT NULL, 
change_date DATE NOT NULL, 
FOREIGN KEY (post_id) REFERENCES Post(post_id));

 
CREATE OR REPLACE FUNCTION Post_history_func() 
RETURNS TRIGGER LANGUAGE plpgsql 
AS $$ 
BEGIN 
    IF OLD.content <> NEW.content THEN 
        INSERT INTO Post_Content_history(post_id, old_content, new_content, change_date) 
        VALUES(NEW.post_id, OLD.content, NEW.content, CURRENT_DATE); 
    END IF; 
    RETURN NEW; 
END; 
$$; 
 
CREATE TRIGGER Post_history_trg 
BEFORE UPDATE ON Post
FOR EACH ROW 
EXECUTE PROCEDURE Post_history_func(); 

UPDATE Post 
SET content = 'I am happy to be here',
summary = 'I am happy...'
WHERE content = 'CHEETAH GIRL';

SELECT * FROM Post_Content_History;


