CREATE CONSTRAINT person_name IF NOT exists FOR (person:Person) REQUIRE person.name IS UNIQUE;
CREATE CONSTRAINT political_party_name IF NOT exists FOR (party:Party) REQUIRE party.name IS UNIQUE;
CREATE CONSTRAINT twitter_user_id IF NOT exists FOR (user:TwitterAccount) REQUIRE user.id IS UNIQUE;
CREATE CONSTRAINT twitter_username IF NOT exists FOR (user:TwitterAccount) REQUIRE user.username IS UNIQUE;