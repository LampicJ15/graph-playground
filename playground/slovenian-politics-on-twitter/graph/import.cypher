CALL apoc.import.graphml("file:///playground/slovenian-politics-on-twitter/graph/graph.graphml", {readLabels:true, batchSize:5000});


MATCH (n:TwitterAccount)
SET n.createdAt = datetime(n.createdAt),
n.verified = toBoolean(n.verified),
n.isAccountPrivate = toBoolean(n.isAccountPrivate),
n.tweetCount = toInteger(n.tweetCount),
n.followersCount = toInteger(n.followersCount),
n.followingsCount = toInteger(n.followingsCount);