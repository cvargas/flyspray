<?php

  /********************************************************\
  | Task Creation                                          |
  | ~~~~~~~~~~~~~                                          |
  \********************************************************/

if (!$user->can_open_task($proj)) {
    $fs->Redirect( CreateURL('error', null) );
}

$userlist = $proj->UserList();

$page->assign('userlist', $userlist);
$page->assign('assigned_users', array());

$page->uses('severity_list', 'priority_list');

$page->setTitle('Flyspray:: ' . $proj->prefs['project_title'] . ': ' . $language['newtask']);
$page->pushTpl('newtask.tpl');

?>
