{!'<?xml version="1.0" ?>'}
<rss version="2.0">
  <channel>
    <title>{$fs->prefs['page_title']}</title>
    <lastBuildDate>{date('r',$most_recent)}</lastBuildDate>
    <description>{$feed_description}</description>
    <link>{$baseurl}</link>
    <?php if($feed_image): ?>
    <image>
      <url>{$feed_image}</url>
      <link>{$baseurl}</link>
      <title>[Logo]</title>
    </image>
    <?php endif;
    foreach($task_details as $row):?>
    <item>
      <title>{$row['project_prefix']}#{$row['prefix_id']}: {$row['item_summary']}</title>
      <author>{$row['real_name']}<?php if ($row['show_contact']): ?> &lt;{$row['email_address']}&gt;<?php endif; ?></author>
      <pubDate>{date('r',intval($row['date_opened']))}</pubDate>
      <description><![CDATA[{!str_replace(chr(13), "<br />", Filters::noXSS(strip_tags($row['detailed_desc'])))}]]></description>
      <link>{CreateURL(array('details', 'task' . $row['task_id']))}</link>
      <guid>{CreateURL(array('details', 'task' . $row['task_id']))}</guid>
    </item>
    <?php endforeach; ?>
  </channel>
</rss>
