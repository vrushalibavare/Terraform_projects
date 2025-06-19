#Curl commands to use HTTP API methods

curl \
 -X PUT \
 -H "Content-Type: application/json" \
 -d '{"year": "2014", "title": "TOPGUN"}' \
 ${INVOKE_URL}/topmovies

curl \
 -X PUT \
 -H "Content-Type: application/json" \
 -d '{"year": "2013", "title": "The Amazing Spider"}' \
 ${INVOKE_URL}/topmovies

curl -X DELETE ${INVOKE_URL}/topmovies/2013
