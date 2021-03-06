<?php
  /*********************************************************\
  | Show the roadmap                                        |
  | ~~~~~~~~~~~~~~~~~~~                                     |
  \*********************************************************/

if (!defined('IN_FS')) {
    die('Do not access this file directly.');
}

require_once BASEDIR . '/includes/class.svninfo.php';

class FlysprayDoSvnlog extends FlysprayDo
{
    function is_accessible()
    {
        global $proj, $user;

        return (bool) $proj->id && $user->can_view_project($proj->id) && $user->perms('view_svn');
    }

    function is_projectlevel() {
        return true;
    }

    function show()
    {
        global $page, $db, $fs, $proj, $user;

        $page->setTitle($fs->prefs['page_title'] . L('svnlog'));

        // check for last repo update
        $db->setLimit(30);
        $logdb = $db->x->getAll('SELECT content, last_updated, topic FROM {cache}
                                  WHERE type = ? AND project_id = ?
                               ORDER BY last_updated DESC',
                                 null, array('svn', $proj->id));
        $logsvn = array();

        // check if nothing is cached yet oder older than 1 day
        if (!count($logdb) || $logdb[0]['last_updated'] < time() - 60 * 60 * 24) {
            $svninfo = new SVNinfo();
            $svninfo->setRepository($proj->prefs['svn_url'], $proj->prefs['svn_user'], $proj->prefs['svn_password']);

            $currentRevision = $svninfo->getCurrentRevision();
            if (!$currentRevision) {
                FlysprayDo::error(ERROR_INPUT, L('svnnoconnection'));
            }
            // Get last 30 log entries
            $logsvn = $svninfo->getLog( (count($logdb) ? $logdb[0]['topic'] : $currentRevision - 30), $currentRevision);

            $stmt = $db->x->autoPrepare('{cache}', array('type','content', 'topic', 'project_id', 'last_updated'));

            foreach ($logsvn as $log) {
                $stmt->execute(array('svn', serialize($log), $log['version-name'], $proj->id, strtotime($log['date'])));
            }

            $stmt->free();
            // server sends oldest entry first
            $logsvn = array_reverse($logsvn);
        }
        for ($i = 0; $i < count($logdb); ++$i) {
            $logdb[$i] = unserialize($logdb[$i]['content']);
        }

        $svnlog = array_merge($logsvn, $logdb);

        foreach ($svnlog as $key => $log) {
            // Make first line of summary bold
            $svnlog[$key]['comment'] = $page->text->render(trim($svnlog[$key]['comment']), true);
            $svnlog[$key]['comment'] = explode("\n", $svnlog[$key]['comment']);
            $svnlog[$key]['comment'][0] = '<strong>' . $svnlog[$key]['comment'][0] . '</strong>';
            $svnlog[$key]['comment'] = implode("\n", $svnlog[$key]['comment']);
        }

        $page->assign('svnlog', $svnlog);
        $page->pushTpl('svnlog.tpl');
    }
}


?>
