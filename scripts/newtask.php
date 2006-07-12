<?php

  /********************************************************\
  | Task Creation                                          |
  | ~~~~~~~~~~~~~                                          |
  \********************************************************/

if(!defined('IN_FS')) {
    die('Do not access this file directly.');
}

if (!$user->can_open_task($proj)) {
    $_SESSION['ERROR'] = L('nopermsaddtask');
    Flyspray::Redirect( CreateURL('project', $proj->id) );
}

$userlist = $proj->UserList();

$page->assign('userlist', $userlist);

$page->uses('severity_list', 'priority_list');

$page->setTitle($fs->prefs['page_title'] . $proj->prefs['project_title'] . ': ' . L('newtask'));
$page->pushTpl('newtask.tpl');

?>
