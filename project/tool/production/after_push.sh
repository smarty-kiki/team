#!/bin/bash

ROOT_DIR="$(cd "$(dirname $0)" && pwd)"/../../..

ln -fs $ROOT_DIR/project/config/production/nginx/team.conf /etc/nginx/sites-enabled/team
/usr/sbin/service nginx reload

/bin/bash $ROOT_DIR/project/tool/dep_build.sh link
/usr/bin/php $ROOT_DIR/public/cli.php migrate:install
/usr/bin/php $ROOT_DIR/public/cli.php migrate

ln -fs $ROOT_DIR/project/config/production/supervisor/team_queue_worker.conf /etc/supervisor/conf.d/team_queue_worker.conf
/usr/bin/supervisorctl update
/usr/bin/supervisorctl restart team_queue_worker:*

chmod 777 /var/www/team/view/blade
rm -rf /var/www/team/view/blade/*.php
