=== {$proj->prefs['project_title']} ===

<?php foreach($data as $milestone): ?>
{L('roadmapfor')} {$milestone['name']}

{$milestone['percent_complete']}% of {count($milestone['all_tasks'])} {L('tasks')} {L('completed')} <?php
   if(count($milestone['open_tasks'])):
   ?>{count($milestone['open_tasks'])} {L('opentasks')}:<?php
   endif; ?>

<?php if(count($milestone['open_tasks'])): ?>

    <?php foreach($milestone['open_tasks'] as $task):
          if(!$user->can_view_task($task)) continue; ?>
    {$proj->prefs['project_prefix']}#{$task['prefix_id']} - {$task['item_summary']}

    <?php endforeach; ?>

<?php endif; ?>

<?php endforeach; ?>
