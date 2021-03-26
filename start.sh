#!/bin/bash
service php7.4-fpm start # start fpm
nginx -g "daemon off;" # start nginx