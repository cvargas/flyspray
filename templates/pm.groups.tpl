<div id="toolbox">
  <h3>{$pm_text['pmtoolbox']} :: {$proj->prefs['project_title']} : {$pm_text['groupmanage']}</h3>
  <fieldset class="admin">
    <legend>{$admin_text['usergroups']}</legend>
    <p><a href="{CreateURL('newgroup', $proj->id)}">{$admin_text['newgroup']}</a></p>
    <?php
    $this->display('common.groups.tpl');
    ?>
  </fieldset>
</div>
