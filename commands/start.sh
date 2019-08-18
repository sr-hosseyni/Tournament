#!/usr/bin/env bash
docker-compose up --remove-orphans -d

echo "Wait for the containers to be available"
while [ "`docker inspect -f {{.State.Running}} api`" != "true" ]; do
    echo '.';
    sleep 0.1;
done;

while [ "`docker inspect -f {{.State.Running}} db`" != "true" ]; do
    echo '.';
    sleep 0.1;
done;

while [ "`docker inspect -f {{.State.Running}} front`" != "true" ]; do
    echo '.';
    sleep 0.1;
done;

while [ "`docker inspect -f {{.State.Running}} admin`" != "true" ]; do
    echo '.';
    sleep 0.1;
done;

printf "\ncontainers are ready\n"

#echo -ne "Wait for the mysql to be available"
#while [ "`docker exec db bash -c 'mysql -u root -e \"show databases;\" 1>/dev/null'`"!="" ];
#do
#    echo -ne '.';
#    sleep 1
#done;
sleep 15
docker exec db bash -c "mysql -u root -e \"CREATE USER 'tournament'@'%' IDENTIFIED BY 'secret'; CREATE DATABASE tournament; GRANT ALL PRIVILEGES ON tournament.* TO 'tournament'@'%';\""
#docker exec db /db/api/init_db.sh


printf "\nmysql is ready\n"

#docker exec api bash -c "/serve.sh tournamnt.dev /api/public"
#docker exec api bash -c "cd /api && php artisan migrate"
docker exec api bash -c "cd /api && php artisan doctrine:schema:create"
docker exec api bash -c "cd /api && php artisan db:seed"

#npm start