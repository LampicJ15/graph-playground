// number of active twitter accounts per party
MATCH (pole)<-[:PART_OF]-(party:Party)<-[:MEMBER_OF]-(person:Person)
OPTIONAL MATCH (person)-[:HAS_ACCOUNT]->(twitter:TwitterAccount)
RETURN  head(labels(pole)) AS pole,
        party.name AS party,
        count(person) AS numberOfPeople,
        count(twitter) AS activeOnTwitter
  ORDER BY activeOnTwitter DESC;

// total number of followers
MATCH (:Person)-[:HAS_ACCOUNT]->(:TwitterAccount)<-[:FOLLOWS]-(follower:TwitterAccount)
RETURN count(distinct follower);

// coalition size
MATCH (:Coalition)<-[:PART_OF]-(:Party)<-[:MEMBER_OF]-(person:Person)
RETURN count(person) AS coalitionSize;

// number of people in the coalition on twitter
MATCH (:Coalition)<-[:PART_OF]-(:Party)<-[:MEMBER_OF]-(:Person)-[:HAS_ACCOUNT]->(twitter:TwitterAccount)
RETURN count(twitter) AS onTwitter;

// percentage of people on twitter in coalition
MATCH (:Coalition)<-[:PART_OF]-(:Party)<-[:MEMBER_OF]-(person:Person)
OPTIONAL MATCH (person)-[:HAS_ACCOUNT]->(twitter:TwitterAccount)
WITH count(person) AS coalitionSize, count(twitter) AS onTwitter
RETURN toString(round(toFloat(onTwitter) / coalitionSize * 100, 2)) + "%";

// coalition reach
MATCH(:Coalition)<-[:PART_OF]-(:Party)<-[:MEMBER_OF]-(:Person)-[:HAS_ACCOUNT]->(:TwitterAccount)
       <-[:FOLLOWS]-(follower:TwitterAccount)
RETURN count(DISTINCT follower) AS reach;

// number of people in the opposition
MATCH (:Opposition)<-[:PART_OF]-(:Party)<-[:MEMBER_OF]-(person:Person)
RETURN count(person) AS oppositionSize;

// number of people in the opposition on Twitter
MATCH (:Opposition)<-[:PART_OF]-(:Party)<-[:MEMBER_OF]-(:Person)-[:HAS_ACCOUNT]->(twitter:TwitterAccount)
RETURN count(twitter) AS onTwitter;

// percentage of people on twitter in opposition
MATCH (:Opposition)<-[:PART_OF]-(:Party)<-[:MEMBER_OF]-(person:Person)
OPTIONAL MATCH (person)-[:HAS_ACCOUNT]->(twitter:TwitterAccount)
WITH count(person) AS coalitionSize, count(twitter) AS onTwitter
RETURN toString(round(toFloat(onTwitter) / coalitionSize * 100, 2)) + "%";

// opposition reach
MATCH(:Opposition)<-[:PART_OF]-(:Party)<-[:MEMBER_OF]-(:Person)-[:HAS_ACCOUNT]->(:TwitterAccount)
       <-[:FOLLOWS]-(follower:TwitterAccount)
RETURN count(DISTINCT follower) AS reach;

// reach per party
MATCH (party:Party)<-[:MEMBER_OF]-(:Person)-[:HAS_ACCOUNT]->(:TwitterAccount)<-[:FOLLOWS]-(follower:TwitterAccount)
RETURN party.name AS party, count(DISTINCT follower) AS reach
  ORDER BY reach DESC;


// users with the highest following
MATCH
  (person:Person)-[:HAS_ACCOUNT]->(account:TwitterAccount)-[follows:FOLLOWS]->(), (person)-[:MEMBER_OF]->(party:Party)
RETURN person.name AS person, party.name AS party, account.username AS twitter, count(follows) AS following
  ORDER BY following DESC;

// users with the highest follower count inside the network
MATCH(person:Person)-[:HAS_ACCOUNT]->(account:TwitterAccount)<-[followed:FOLLOWS]-(:TwitterAccount)<-[:HAS_ACCOUNT]-(),
     (person)-[:MEMBER_OF]->(party:Party)
RETURN person.name AS person, party.name AS party, account.username AS twitter, count(followed) AS followers
  ORDER BY followers DESC;


// how many people users follow both SDS & NSi
MATCH
  (:Party {name: 'SDS'})<-[:MEMBER_OF]-(:Person)-[:HAS_ACCOUNT]->(:TwitterAccount)<-[:FOLLOWS]-(twitter:TwitterAccount)
    -[:FOLLOWS]->(:TwitterAccount)<-[:HAS_ACCOUNT]-(:Person)-[:MEMBER_OF]->(:Party {name: 'NSi'})
RETURN count(DISTINCT twitter);

// how many people users follow both SD & Gibanje Svoboda
MATCH
  (:Party {name: 'SD'})<-[:MEMBER_OF]-(:Person)-[:HAS_ACCOUNT]->(:TwitterAccount)<-[:FOLLOWS]-(twitter:TwitterAccount)
    -[:FOLLOWS]->(:TwitterAccount)<-[:HAS_ACCOUNT]-(:Person)-[:MEMBER_OF]->(:Party {name: 'Svoboda'})
RETURN count(DISTINCT twitter);


// coalition -> opposition
MATCH (:Coalition)<-[:PART_OF]-(:Party)<-[:MEMBER_OF]-(person:Person)-[:HAS_ACCOUNT]->(:TwitterAccount)
        -[:FOLLOWS]->(:TwitterAccount)<-[:HAS_ACCOUNT]-(followedPerson:Person)-[:MEMBER_OF]->(:Party)
        -[:PART_OF]->(:Opposition)
RETURN person.name AS person, collect(DISTINCT followedPerson.name) AS followedOpposition
  ORDER BY size(followedOpposition) DESC;

// opposition -> coalition
MATCH (:Opposition)<-[:PART_OF]-(:Party)<-[:MEMBER_OF]-(person:Person)-[:HAS_ACCOUNT]->(:TwitterAccount)
        -[:FOLLOWS]->(:TwitterAccount)<-[:HAS_ACCOUNT]-(followedPerson:Person)-[:MEMBER_OF]->(:Party)
        -[:PART_OF]->(:Coalition)
RETURN person.name AS person, collect(DISTINCT followedPerson.name) AS followedOpposition
  ORDER BY size(followedOpposition) DESC;

// find shortest path between the 2
MATCH (luka:TwitterAccount {username: 'lukamesec'})
MATCH (janez:TwitterAccount {username: 'jjansasds'})
MATCH p = shortestPath((luka)-[:FOLLOWS*]-(janez))
RETURN p;