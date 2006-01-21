<div id="comments" class="tab">
  <?php foreach($comments as $row): ?>
  <em>
    <a name="comment{$row['comment_id']}" id="comment{$row['comment_id']}"
      href="{CreateURL('details', $task_details['task_id'])}#comment{$row['comment_id']}">
      <img src="{$baseurl}themes/{$proj->prefs['theme_style']}/menu/comment.png"
        title="{$details_text['commentlink']}" alt="" />
    </a>
    {$details_text['commentby']} {!tpl_userlink($row['user_id'])} -
    {formatDate($row['date_added'], true)}
  </em>

  <span class="DoNotPrint">
    <?php if ($user->perms['edit_comments']): ?>
    &mdash;
    <a href="{$baseurl}?do=editcomment&amp;task_id={Get::val('id')}&amp;id={$row['comment_id']}">
      {$details_text['edit']}</a>
    <?php endif; ?>

    <?php if ($user->perms['delete_comments']): ?>
    &mdash;
    <a href="{$baseurl}?do=modify&amp;action=deletecomment&amp;task_id={Get::val('id')}&amp;comment_id={$row['comment_id']}"
      onclick="return confirm('{$details_text['confirmdeletecomment']}');">
      {$details_text['delete']}</a>
    <?php endif ?>
  </span>
  <div class="comment">{!tpl_formatText($row['comment_text'])}</div>

  <?php // XXX the same lives in details.view.tpl, keep in sync
  if ($user->perms['view_attachments'] || $proj->prefs['others_view']):
  foreach ($attachments = $proj->listAttachments($row['comment_id']) as $attachment):
  ?>
  <span class="attachments">
    <a href="{$baseurl}?getfile={$attachment['attachment_id']}" title="{$attachment['file_type']}">
      <?php
      // Let's strip the mimetype to get the icon image name
      list($main) = explode('/', $attachment['file_type']);
      $imgpath = "{$baseurl}themes/{$proj->prefs['theme_style']}/mime/";
      if (file_exists($imgpath.$attachment['file_type'].".png")):
      ?>
      <img src="{$imgpath}{$attachment['file_type']}.png" alt="({$attachment['file_type']})" title="{$attachment['file_type']}" />
      <?php else: ?>
      <img src="{$imgpath}{$main}.png" alt="" title="{$attachment['file_type']}" />
      <?php endif; ?>
      &nbsp;&nbsp;{$attachment['orig_name']}</a>

    <?php if ($user->perms['delete_attachments']): ?>
    &mdash;
    <a href="{$baseurl}?do=modify&amp;action=deleteattachment&amp;id={$attachment['attachment_id']}"
      onclick="return confirm('{$details_text['confirmdeleteattach']}');">
      {$details_text['delete']}</a>
    <?php endif; ?>
  </span>
  <?php endforeach; ?>
  <br />
  <?php elseif (count($attachments)): ?>
  <span class="attachments">{$details_text['attachnoperms']}</span>
  <br />
  <?php endif; ?>
  <?php endforeach; ?>

  <?php if ($user->perms['add_comments'] && !$task_details['is_closed']): ?>
  <form enctype="multipart/form-data" action="{$baseurl}" method="post">
    <div class="admin">
      <input type="hidden" name="do" value="modify" />
      <input type="hidden" name="action" value="addcomment" />
      <input type="hidden" name="task_id" value="{Get::val('id')}" />
      <?php if ($user->perms['create_attachments']): ?>
      <div id="uploadfilebox">
        <span style="display: none"><?php // this span is shown/copied in javascript when adding files ?>
          <input tabindex="5" type="file" size="55" name="userfile[]" />
            <a href="javascript://" tabindex="6" onclick="removeUploadField(this);">{$details_text['remove']}</a><br />
        </span>    
      </div>
      <input id="attachafile" tabindex="7" class="adminbutton" type="button" onclick="addUploadFields()"
        value="{$details_text['uploadafile']}" />
      <input id="attachanotherfile" tabindex="7" style="display: none" class="adminbutton" type="button" onclick="addUploadFields()"
        value="{$details_text['attachanotherfile']}" />
        
      <?php endif; ?>
      <textarea accesskey="r" tabindex="8" id="comment_text" name="comment_text" cols="72" rows="10"></textarea>


      <input tabindex="9" class="adminbutton" type="submit" value="{$details_text['addcomment']}" />
      <?php if (!$watched): ?>
      {!tpl_checkbox('notifyme', false, 'notifyme')} <label class="default" for="notifyme">{$newtask_text['notifyme']}</label>
      <?php endif; ?>
    </div>
  </form>
  <?php endif; ?>
</div>
