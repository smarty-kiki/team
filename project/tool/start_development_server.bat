@echo off
set LAST_DIR=%cd%
cd /d %~dp0

set ROOT_DIR=%cd%\..\..

call dep_build.bat

docker run --rm -ti -p 80:80 -p 8080:8080 -p 3306:3306 --name team ^
    -v %ROOT_DIR%/:/var/www/team ^
    -v %ROOT_DIR%/project/config/development/nginx/team.conf:/etc/nginx/sites-enabled/default ^
    -v %ROOT_DIR%/project/config/development/supervisor/team_queue_worker.conf:/etc/supervisor/conf.d/team_queue_worker.conf ^
    -v %ROOT_DIR%/project/config/development/supervisor/queue_job_watch.conf:/etc/supervisor/conf.d/queue_job_watch.conf ^
    -e PRJ_HOME=/var/www/team ^
    -e ENV=development ^
    -e TIMEZONE=Asia/Shanghai ^
    -e AFTER_START_SHELL=/var/www/team/project/tool/development/after_env_start.sh ^
registry.cn-shenzhen.aliyuncs.com/smarty/debian_php_dev_env start

cd %LAST_DIR%
