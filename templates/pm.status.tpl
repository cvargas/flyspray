<div id="toolbox">
  <h3>{$language['pmtoolbox']} :: {$proj->prefs['project_title']} : {$language['taskstatuses']}</h3>

  <fieldset class="admin">
    <legend>{$language['taskstatuses']}</legend>
    <?php
    $this->assign('list_type', 'status');
    $this->assign('rows', $proj->listTaskStatuses(true));
    $this->display('common.list.tpl');
    ?>
  </fieldset>
</div>
