<div id="taskdetails">
  <form action="{$baseurl}" method="post">
	 <div>
		<h2 class="summary severity{$task_details['task_severity']}">
		  FS#{$task_details['task_id']} &mdash;
		  <input class="text severity{$task_details['task_severity']}" type="text"
			name="item_summary" size="80" maxlength="100"
			value="{$task_details['item_summary']}" />
		</h2>
		<input type="hidden" name="do" value="modify" />
		<input type="hidden" name="action" value="update" />
		<input type="hidden" name="task_id" value="{Get::val('id')}" />
		<input type="hidden" name="edit_start_time" value="{date('U')}" />

		<div id="fineprint">
		  {L('attachedtoproject')} &mdash;
		  <select name="attached_to_project">
			{!tpl_options($project_list, $proj->id)}
		  </select>
		  <br />
		  {L('openedby')} {!tpl_userlink($task_details['opened_by'])}
		  - {!formatDate($task_details['date_opened'], true)}
		  <?php if ($task_details['last_edited_by']): ?>
		  <br />
		  {L('editedby')}  {!tpl_userlink($task_details['last_edited_by'])}
		  - {formatDate($task_details['last_edited_time'], true)}
		  <?php endif; ?>
		</div>

		<div id="taskfields1">
		  <table class="taskdetails">
			<tr class="tasktype">
			 <td><label for="tasktype">{L('tasktype')}</label></td>
			 <td>
				<select id="tasktype" name="task_type">
				 {!tpl_options($proj->listTaskTypes(), $task_details['task_type'])}
				</select>
			 </td>
			</tr>
			<tr class="category">
			 <td><label for="category">{L('category')}</label></td>
			 <td>
				<select id="category" name="product_category">
				 {!tpl_options($proj->listCatsIn(), $task_details['product_category'])}
				</select>
			 </td>
			</tr>
			<tr class="status">
			 <td><label for="status">{L('status')}</label></td>
			 <td>
				<select id="status" name="item_status">
				 {!tpl_options($proj->listTaskStatuses(), $task_details['item_status'])}
				</select>
			 </td>
			</tr>
			<tr>
			 <td><label>{L('assignedto')}</label></td>
			 <td>
				<a href="#users" id="selectusers" class="button" onclick="showhidestuff('multiuserlist');">{L('selectusers')}</a>
				<input type="hidden" name="old_assigned" value="{$old_assigned}" />
				<div id="multiuserlist">
				 {!tpl_double_select('assigned_to', $userlist, $assigned_users, false, false)}
                 <button type="button" onclick="hidestuff('multiuserlist')">{L('OK')}</button>
				</div>
			 </td>
			</tr>
			<tr class="os">
			 <td><label for="os">{L('operatingsystem')}</label></td>
			 <td>
				<select id="os" name="operating_system">
				 {!tpl_options($proj->listOs(), $task_details['operating_system'])}
				</select>
			 </td>
			</tr>
		  </table>
		</div>

		<div id="taskfields2">
		  <table class="taskdetails">
			<tr class="severity">
			 <td><label for="severity">{L('severity')}</label></td>
			 <td>
				<select id="severity" name="task_severity">
				 {!tpl_options($severity_list, $task_details['task_severity'])}
				</select>
			 </td>
			</tr>
			<tr class="priority">
			 <td><label for="priority">{L('priority')}</label></td>
			 <td>
				<select id="priority" name="task_priority">
				 {!tpl_options($priority_list, $task_details['task_priority'])}
				</select>
			 </td>
			</tr>
			<tr class="reportedver">
			 <td><label for="reportedver">{L('reportedversion')}</label></td>
			 <td>
				<select id="reportedver" name="reportedver">
				{!tpl_options($proj->listVersions(false, 2, $task_details['product_version']), $task_details['product_version'])}
				</select>
			 </td>
			</tr>
			<tr class="dueversion">
			 <td><label for="dueversion">{L('dueinversion')}</label></td>
			 <td>
				<select id="dueversion" name="closedby_version">
				 <option value="0">{L('undecided')}</option>
				 {!tpl_options($proj->listVersions(false, 3), $task_details['closedby_version'])}
				</select>
			 </td>
			</tr>
			<tr class="duedate">
			 <td><label for="duedate">{L('duedate')}</label></td>
			 <td id="duedate">
                {!tpl_datepicker('due_', L('undecided'), '', $task_details['due_date'])}
			 </td>
			</tr>
			<tr class="percent">
			 <td><label for="percent">{L('percentcomplete')}</label></td>
			 <td>
				<select id="percent" name="percent_complete">
				 <?php $arr = array(); for ($i = 0; $i<=100; $i+=10) $arr[$i] = $i.'%'; ?>
				 {!tpl_options($arr, $task_details['percent_complete'])}
				</select>
			 </td>
			</tr>
		  </table>
		</div>

		<div id="taskdetailsfull">
		  <label for="details">{L('details')}</label>
		  <textarea id="details" name="detailed_desc"
			 cols="70" rows="10">{$task_details['detailed_desc']}</textarea><br />
          <?php if ($user->perms['add_comments'] && (!$task_details['is_closed'] || $proj->prefs['comment_closed'])): ?>
              <button type="button" onclick="showstuff('edit_add_comment');this.style.display='none';">{L('addcomment')}</button>
              <div id="edit_add_comment" class="hide">
              <label for="comment_text">{L('comment')}</label>
              <?php if ($user->perms['create_attachments']): ?>
              <div id="uploadfilebox">
                <span style="display: none"><?php // this span is shown/copied in javascript when adding files ?>
                  <input tabindex="5" class="file" type="file" size="55" name="userfile[]" />
                    <a href="javascript://" tabindex="6" onclick="removeUploadField(this);">{L('remove')}</a><br />
                </span>    
              </div>
              <button id="attachafile" tabindex="7" type="button" onclick="addUploadFields()">
                {L('uploadafile')}
              </button>
              <button id="attachanotherfile" tabindex="7" style="display: none" type="button" onclick="addUploadFields()">
                 {L('attachanotherfile')}
              </button>
                
              <?php endif; ?>
              <textarea accesskey="r" tabindex="8" id="comment_text" name="comment_text" cols="72" rows="10"></textarea>
              </div>
          <?php endif; ?>
		  <table class="taskdetails">
			 <tr><td>&nbsp;</td></tr>
			 <tr>
				<td class="buttons">
				  <button type="submit" accesskey="s">{L('savedetails')}</button>
				  <button type="reset">{L('reset')}</button>
				</td>
			 </tr>
		  </table>
		</div>
	 </div>
  </form>
</div>
