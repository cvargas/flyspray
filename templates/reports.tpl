<ul id="submenu">
  <li><a href="#events">{L('events')}</a></li>
  <li><a href="#votes">{L('votes')}</a></li>
</ul>
<div id="events" class="tab">
  <form action="{$baseurl}index.php" method="get">
    <table id="event1">
      <tr>
        <td>{L('Tasks')}</td>
        <td><label class="inline">{!tpl_checkbox('open', (Req::has('open')))}
            {L('opened')}</label></td>
        <td><label class="inline">{!tpl_checkbox('close', (Req::has('close')))}
            {L('closed')}</label></td>
        <td><label class="inline">{!tpl_checkbox('edit', (Req::has('edit')))}
            {L('edited')}</label></td>
      </tr>
      <tr>
        <td></td>
        <td><label class="inline">{!tpl_checkbox('assign', (Req::has('assign')))}
            {L('assigned')}</label></td>
        <td><label class="inline">{!tpl_checkbox('comments', (Req::has('comments')))}
            {L('comments')}</label></td>
        <td><label class="inline">{!tpl_checkbox('attachments', (Req::has('attachments')))}
            {L('attachments')}</label></td>
      </tr>
      <tr>
        <td></td>
        <td><label class="inline">{!tpl_checkbox('related', (Req::has('related')))}
            {L('relatedtasks')}</label></td>
        <td><label class="inline">{!tpl_checkbox('notifications', (Req::has('notifications')))}
            {L('notifications')}</label></td>
        <td><label class="inline">{!tpl_checkbox('reminders', (Req::has('reminders')))}
            {L('reminders')}</label></td>
      </tr>
    </table>
    
    <table>
      <tr>
        <td>
          <input type="radio" id="datewithin" name="date" value="within" <?php if (Req::val('date') == 'within') echo 'checked="checked"';?> />
          <label class="inline" for="datewithin">{L('within')}</label>
        </td>
        <td colspan="6">
          <select onclick="getElementById('datewithin').checked=true" name="within">
          {!tpl_options(array('day' => L('pastday'),
                              'week' => L('pastweek'),
                              'month' => L('pastmonth'),
                              'year' => L('pastyear'),
                              'all' => L('nolimit')), Req::val('within'))}
          </select>
        </td>
      </tr>
      <tr>
        <td>
          <input type="radio" id="datefrom" name="date" value="from" <?php if (Req::val('date') == 'from') echo 'checked="checked"';?> />
          <label class="inline" for="datefrom">{L('from')}</label>
        </td>
        <td onclick="getElementById('datefrom').checked=true">
            {!tpl_datepicker('from', L('selectfromdate'), L('from'))}
          &mdash;
            {!tpl_datepicker('to', L('selecttodate'), L('to'))}
        </td>
      </tr>
      <tr>
        <td>
          <input type="radio" id="dateduein" name="date" value="duein" <?php if (Req::val('date') == 'duein') echo 'checked="checked"';?> />
          <label class="inline" for="dateduein">{L('duein')}</label>
        </td>
        <td colspan="6">
          <select onclick="getElementById('dateduein').checked=true" name="duein">
            {!tpl_options($proj->listVersions(false, 3), Req::val('duein'))}
          </select>
        </td>
      </tr>
    </table>

    <input type="hidden" name="do" value="reports" />
    <button type="submit" name="submit">{L('show')}</button>
  </form>
  
  <?php if($histories): ?>
  <div id="tasklist">
  <table id="tasklist_table">
   <thead>
    <tr>
      <th class="taskid">
        <a href="{CreateURL('reports', null, null, array('sort' => (Req::val('order') == 'id' && $sort == 'DESC') ? 'asc' : 'desc', 'order' => 'id') + $_GET)}">
           {L('id')}
        </a>
      </th>
      <th>{L('summary')}</th>
      <th>
        <a href="{CreateURL('reports', null, null, array('sort' => (Req::val('order') == 'date' && $sort == 'DESC') ? 'asc' : 'desc', 'order' => 'date') + $_GET)}">
          {L('eventdate')}
        </a>
      </th>
      <th>
        <a href="{CreateURL('reports', null, null, array('sort' => (Req::val('order') == 'user' && $sort == 'DESC') ? 'asc' : 'desc', 'order' => 'user') + $_GET)}">
          {L('user')}
        </a>
      </th>
      <th>
        <a href="{CreateURL('reports', null, null, array('sort' => (Req::val('order') == 'type' && $sort == 'DESC') ? 'asc' : 'desc', 'order' => 'type') + $_GET)}">
          {L('event')}
        </a>
      </th>
    </tr>
   </thead>
    <?php foreach ($histories as $history): ?>
    <tr class="severity{$history['task_severity']}" onclick="openTask('{CreateURL('details', $history['task_id'])}')">
      <td>{!tpl_tasklink($history, 'FS#' . $history['task_id'])}</td>
      <td>{!tpl_tasklink($history)}</td>
      <td>{formatDate($history['event_date'], true)}</td>
      <td>{!tpl_userlink($history['user_id'])}</td>
      <td>{!event_description($history)}</td>
    </tr>
    <?php endforeach; ?>
  </table>
  </div>
  <?php endif; ?>
</div>

<div id="votes" class="tab">
    <?php if (!empty($tasks_voted_for)): ?>
        <table><tr><th colspan="2">{!L('votes')}</th><th></th></tr>
        <?php foreach ($tasks_voted_for AS $key => $val): ?>
            <tr>
              <td>
                <a class="DoNotPrint" href="#" onclick="showhidestuff('dropdown{$key}');getVoters('{$key}', '{$baseurl}', 'dropdown{$key}')">
                  <img src="{$baseurl}themes/{$proj->prefs['theme_style']}/dropdown.png" title="{L('showvoters')}" alt="" />
                </a>
              </td>
              <td valign="top">{$val}</td>
              <td>{!tpl_tasklink($key)}
                <div style="visibility:hidden;" id="dropdown{$key}" class="voters"></div>
              </td>
            </tr>
        <?php endforeach; ?>
        </table>
    <?php endif; ?>
</div>
