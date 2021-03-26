## Welcome

This project packages [mantisbt](https://mantisbt.org/), a simple yet powerful task management system, inside a docker image.  
Note that the image doesn't include the database. Please check [mysqlphpadmin-docker](https://github.com/galmiza/mysqlphpadmin-docker) to install [mysql](https://www.mysql.com/) with [phpmyadmin](https://www.phpmyadmin.net/).

It is built directly from Ubuntu and runs mantisbt on nginx.

## Pre-requisites

It is strongly recommanded to use a dedicated database and a dedicated user for the mantisbt application.  
To create a database and a user, run the following sql instructions in a mysql shell or from the phpmyadmin sql web page.

```sql
CREATE DATABASE mantisbt;
CREATE USER 'mantisbt_user'@'%' IDENTIFIED WITH mysql_native_password BY 'mantisbt_user';
GRANT ALL ON mantisbt.* TO 'mantisbt_user'@'%';
GRANT PROCESS ON *.* TO 'mantisbt_user'@'%'; -- to allow mysqldump with the user
FLUSH PRIVILEGES;
```

## Installation

Build the image, run the container and visit http://localhost:8001/ to open the administration interface.

```sh
docker build --rm -t mantisbt .
docker run -d -p 8001:80 --name=myContainer mantisbt
```

Please check the [docker run command documentation](https://docs.docker.com/engine/reference/commandline/run/) for more details about restart policy, volume mounting, etc.  
You can also use network configuration to securely expose mysql or phpmyadmin on internet.

## Configuration

#### Database connection

Connect to the application from the browser and complete the form. Make sure you reuse the database name, database username and database user password your defined earlier.

If the installation is successful, the login page will show up. You can now login with the default credentials: **administrator** / **root**

#### Proxy and email notification

Create an interactive shell on the container

```sh
docker exec -it myContainer /bin/bash
```

Edit the configuration file ...

```sh
vi /var/www/html/mantisbt/config/config_inc.php
```
... and add the following lines.

```php
/*
 * Add this line if you use the application behind a proxy
 * Replace the url by the one used to reach the application
 */
$g_path = isset( $t_url ) ? $t_url : 'https://mantisbt.example.com/';

/*
 * Add these lines to support email notifications
 * The example shows the configuration for Gmail
 */
$g_log_level = LOG_EMAIL | LOG_EMAIL_RECIPIENT;
$g_log_destination = 'file:/var/log/mantisbt.log';
$g_allow_signup  = ON;  //allows the users to sign up for a new account
$g_enable_email_notification = ON; //enables the email messages
$g_phpMailer_method = PHPMAILER_METHOD_SMTP;
$g_smtp_host = 'smtp.gmail.com';
$g_smtp_connection_mode = 'tls';
$g_smtp_port = 587;
$g_smtp_username = 'YOUR_GMAIL_EMAIL'; //replace it with your gmail address
$g_smtp_password = 'YOUR_GMAIL_PASSWORD'; //replace it with your gmail password
$g_administrator_email = 'YOUR_GMAIL_EMAIL'; //this will be your administrator email address
```

Gmail will automatically prevent the application from sending email on your behalf.  
To fix this problem,

* activate "Less Secure Apps" from the Gmail account settings
* visit https://accounts.google.com/b/YOUR_GMAIL_INDEX_IN_BROWSER/DisplayUnlockCaptcha (where YOUR_GMAIL_INDEX_IN_BROWSER is typically 0)

To help investigate email sending issues, you can use the excellent article https://blog.edmdesigner.com/send-email-from-linux-command-line/
