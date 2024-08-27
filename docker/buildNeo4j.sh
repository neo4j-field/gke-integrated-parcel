# build statement
NEO="5.23.0"
docker  buildx build --platform linux/arm64,linux/amd64  --build-arg=NEO=$NEO\
 --build-arg=GDS=$GDS --build-arg=BLOOM=$BLOOM\
 --tag davidlrosenblum/neo4jprdtgds:${NEO}-enterprise --push neo4j_products_copy/. 