<?php

  /********************************************************\
  | Scheduled Jobs (poor man's cron)                       |
  | ~~~~~~~~~~~~~~                                         |
  | This script checks for pending scheduled notifications |
  | and sends them at the right time.                      |
  \********************************************************/

$path = dirname(dirname(__FILE__));
require_once("$path/header.php");
require_once("$path/includes/notify.inc.php");

$notify = new Notifications;
$now = date('U');

$get_reminders = $db->Query("SELECT  r.*, t.*, p.*
                               FROM  {reminders} r
                         INNER JOIN  {users}     u ON u.user_id = r.to_user_id
                         INNER JOIN  {tasks}     t ON r.task_id = t.task_id
                         INNER JOIN  {projects}  p ON t.attached_to_project = p.project_id
                              WHERE  t.is_closed = '0' AND r.start_time < ?
                                                       AND r.last_sent + r.how_often < ?
                           ORDER BY  r.reminder_id", array(time(), time())
                        );

while ($row = $db->FetchRow($get_reminders)) {
   $jabber_users = array();
   $email_users  = array();

   // Get the user's notification type and address
   $get_details  = $db->Query("SELECT  notify_type, jabber_id, email_address
   FROM  {users}
   WHERE  user_id = ?", array($row['to_user_id']));

   while ($subrow = $db->FetchArray($get_details)) {
      if (($fs->prefs['user_notify'] == '1' && $subrow['notify_type'] == '1')
      OR ($fs->prefs['user_notify'] == '2'))
      {
         $email_users[] = $subrow['email_address'];

      }
      elseif (($fs->prefs['user_notify'] == '1' && $subrow['notify_type'] == '2')
      OR ($fs->prefs['user_notify'] == '3'))
      {
         $jabber_users[] = $subrow['jabber_id'];
      }
   }

   $subject = $language['notifyfromfs'];
   $message = $row['reminder_message'];

   // Pass the recipients and message onto the notification function
   $notify->SendEmail($email_users, $subject, $message);
   $notify->StoreJabber($jabber_users, $subject, $message);

   // Update the database with the time sent
   $update_db = $db->Query("UPDATE  {reminders}
                            SET  last_sent = ?
                            WHERE  reminder_id = ?",
   array(time(), $row['reminder_id']));
}

// send those stored notifications
$notify->SendJabber();

?>
<html>
<head>
<title>Scheduled Reminders</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body>
<h1>Scheduled Reminders</h1>
This is a backend script that really isn't meant to be displayed in your browser.
To enable scheduled reminders, you set up some sort of background program to
activate this script regularly.  The unix utility 'cron' can be used in conjunction
with 'wget' to do this.
</body>
</html>
