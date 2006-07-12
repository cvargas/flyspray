<div id="taskdetails">
  <form action="{$baseurl}" id="taskeditform" enctype="multipart/form-data" method="post">
	 <div>
		<h2 class="summary severity{Req::val('task_severity', $task_details['task_severity'])}">
		  FS#{$task_details['task_id']} &mdash;
		  <input class="text severity{Req::val('task_severity', $task_details['task_severity'])}" type="text"
			name="item_summary" size="80" maxlength="100"
			value="{Req::val('item_summary', $task_details['item_summary'])}" />
		</h2>
		<input type="hidden" name="do" value="modify" />
		<input type="hidden" name="action" value="details.update" />
        <input type="hidden" name="edit" value="1" />
		<input type="hidden" name="task_id" value="{Req::num('id', Req::num('task_id'))}" />
		<input type="hidden" name="edit_start_time" value="{Req::val('edit_start_time', time())}" />

		<div id="fineprint">
		  {L('attachedtoproject')} &mdash;
		  <select name="attached_to_project">
			{!tpl_options($project_list, Req::val('attached_to_project', $proj->id))}
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

		<div id="taskfields">
		  <table class="taskdetails">
			<tr>
			 <td><label for="tasktype">{L('tasktype')}</label></td>
			 <td>
				<select id="tasktype" name="task_type">
				 {!tpl_options($proj->listTaskTypes(), Req::val('task_type', $task_details['task_type']))}
				</select>
			 </td>
			</tr>
			<tr>
			 <td><label for="category">{L('category')}</label></td>
			 <td>
				<select id="category" name="product_category">
				 {!tpl_options($proj->listCategories(), Req::val('product_category', $task_details['product_category']))}
				</select>
			 </td>
			</tr>
			<tr>
			 <td><label for="status">{L('status')}</label></td>
			 <td>
				<select id="status" name="item_status">
				 {!tpl_options($proj->listTaskStatuses(), Req::val('item_status', $task_details['item_status']))}
				</select>
			 </td>
			</tr>
			<tr>
			 <td><label>{L('assignedto')}</label></td>
			 <td>
                <?php if ($user->perms['edit_assignments']): ?>
				<a href="#users" id="selectusers" class="button" onclick="showhidestuff('multiuserlist');">{L('selectusers')}</a>
				<input type="hidden" name="old_assigned" value="{$old_assigned}" />
				<div id="multiuserlist">
				 {!tpl_double_select('assigned_to', $userlist, explode(' ', Req::val('assigned_to', $assigned_users)), false, false)}
                 <button type="button" onclick="hidestuff('multiuserlist')">{L('OK')}</button>
				</div>
                <?php else: ?>
                    <?php if (empty($assigned_users)): ?>
                     {L('noone')}
                     <?php else:
                     foreach ($assigned_users as $userid):
                     ?>
                     {!tpl_userlink($userid)}<br />
                     <?php endforeach;
                     endif; ?>
                <?php endif; ?>
			 </td>
			</tr>
			<tr>
			 <td><label for="os">{L('operatingsystem')}</label></td>
			 <td>
				<select id="os" name="operating_system">
				 {!tpl_options($proj->listOs(), Req::val('operating_system', $task_details['operating_system']))}
				</select>
			 </td>
			</tr>
			<tr>
			 <td><label for="severity">{L('severity')}</label></td>
             <td>
				<select id="severity" name="task_severity">
				 {!tpl_options($severity_list, Req::val('task_severity', $task_details['task_severity']))}
				</select>
			 </td>
			</tr>
			<tr>
			 <td><label for="priority">{L('priority')}</label></td>
			 <td>
				<select id="priority" name="task_priority">
				 {!tpl_options($priority_list, Req::val('task_priority', $task_details['task_priority']))}
				</select>
			 </td>
			</tr>
			<tr>
			 <td><label for="reportedver">{L('reportedversion')}</label></td>
			 <td>
				<select id="reportedver" name="reportedver">
				{!tpl_options($proj->listVersions(false, 2, $task_details['product_version']), Req::val('reportedver', $task_details['product_version']))}
				</select>
			 </td>
			</tr>
			<tr>
			 <td><label for="dueversion">{L('dueinversion')}</label></td>
			 <td>
				<select id="dueversion" name="closedby_version">
				 <option value="0">{L('undecided')}</option>
				 {!tpl_options($proj->listVersions(false, 3), Req::val('closedby_version', $task_details['closedby_version']))}
				</select>
			 </td>
			</tr>
			<tr>
			 <td><label for="duedate">{L('duedate')}</label></td>
			 <td id="duedate">
                {!tpl_datepicker('due_date', '', Req::val('due_date', $task_details['due_date']))}
			 </td>
			</tr>
			<tr>
			 <td><label for="percent">{L('percentcomplete')}</label></td>
			 <td>
				<select id="percent" name="percent_complete">
				 <?php $arr = array(); for ($i = 0; $i<=100; $i+=10) $arr[$i] = $i.'%'; ?>
				 {!tpl_options($arr, Req::val('percent_complete', $task_details['percent_complete']))}
				</select>
			 </td>
			</tr>
            <?php if ($user->can_change_private($task_details)): ?>
            <tr>
              <th id="private">{L('private')}</th>
              <td headers="private">
                {!tpl_checkbox('mark_private', Req::val('mark_private', $task_details['mark_private']))}
              </td>
            </tr>
            <?php endif; ?>
		  </table>
		</div>

		<div id="taskdetailsfull">
          <h3 class="taskdesc">{L('details')}</h3>
        <?php $attachments = $proj->listTaskAttachments($task_details['task_id']);
          $this->display('common.editattachments.tpl', 'attachments', $attachments); ?>
          
          <?php if ($user->perms['create_attachments']): ?>
          <div id="uploadfilebox">
            <span style="display: none"><?php // this span is shown/copied in javascript when adding files ?>
              <input tabindex="5" class="file" type="file" size="55" name="usertaskfile[]" />
                <a href="javascript://" tabindex="6" onclick="removeUploadField(this);">{L('remove')}</a><br />
            </span>    
          </div>
          <button id="uploadfilebox_attachafile" tabindex="7" type="button" onclick="addUploadFields()">
            {L('uploadafile')} ({L('max')} {$fs->max_file_size} {L('MiB')})
          </button>
          <button id="uploadfilebox_attachanotherfile" tabindex="7" style="display: none" type="button" onclick="addUploadFields()">
             {L('attachanotherfile')} ({L('max')} {$fs->max_file_size} {L('MiB')})
          </button>
          <?php endif; ?>
          <?php if (defined('FLYSPRAY_HAS_PREVIEW')): ?>
          <div class="hide preview" id="preview"></div>
          <?php endif; ?>
          {!TextFormatter::textarea('detailed_desc', 10, 70, array('id' => 'details'), Req::val('detailed_desc', $task_details['detailed_desc']))}
          <br />
          <?php if ($user->perms['add_comments'] && (!$task_details['is_closed'] || $proj->prefs['comment_closed'])): ?>
              <button type="button" onclick="showstuff('edit_add_comment');this.style.display='none';">{L('addcomment')}</button>
              <div id="edit_add_comment" class="hide">
              <label for="comment_text">{L('comment')}</label>
              
              <?php if ($user->perms['create_attachments']): ?>
              <div id="uploadfilebox_c">
                <span style="display: none"><?php // this span is shown/copied in javascript when adding files ?>
                  <input tabindex="5" class="file" type="file" size="55" name="userfile[]" />
                    <a href="javascript://" tabindex="6" onclick="removeUploadField(this, 'uploadfilebox_c');">{L('remove')}</a><br />
                </span>    
              </div>
              <button id="uploadfilebox_c_attachafile" tabindex="7" type="button" onclick="addUploadFields('uploadfilebox_c')">
                {L('uploadafile')} ({L('max')} {$fs->max_file_size} {L('MiB')})
              </button>
              <button id="uploadfilebox_c_attachanotherfile" tabindex="7" style="display: none" type="button" onclick="addUploadFields('uploadfilebox_c')">
                 {L('attachanotherfile')} ({L('max')} {$fs->max_file_size} {L('MiB')})
              </button>
              <?php endif; ?>
              
              <textarea accesskey="r" tabindex="8" id="comment_text" name="comment_text" cols="50" rows="10"></textarea>
              </div>
          <?php endif; ?>
		  <p class="buttons">
              <button type="submit" accesskey="s" onclick="return checkok('{$baseurl}javascript/callbacks/checksave.php?time={time()}&amp;taskid={$task_details['task_id']}', '{L('alreadyedited')}', 'taskeditform')">{L('savedetails')}</button>
              <?php if (defined('FLYSPRAY_HAS_PREVIEW')): ?>
              <button tabindex="9" type="button" onclick="showPreview('details', '{$baseurl}', 'preview')">{L('preview')}</button>
              <?php endif; ?>
              <button type="reset">{L('reset')}</button>
          </p>
		</div>
	 </div>
     <div class="clear"></div>
  </form>
</div>
