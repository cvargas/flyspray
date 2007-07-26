<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>{$title} Flyspray</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" href="styles/setup.css" type="text/css" media="screen" />
</head>
<body>
<div id="center">
  <div id="container">
    <div id="header">
      <div id="logo">
        <h1><a href="{$index}" title="Flyspray - The bug Killer!">Upgrade</a></h1>
      </div><!-- End of logo -->
    </div><!-- End of header -->
    <div id="content">
      <div id="bodyContent">
      <form action="upgrade.php" method="post" onsubmit="document.getElementById('upgradebutton').disabled = true;return true;" >
      <input type="hidden" name="upgrade" value="1" />
        <div class="install">
            <h2>Precondition checks</h2>
            <p>
            Your current version is <strong>{$installed_version}</strong> and the version we can upgrade to is <strong>{$short_version}</strong>.
            <div class="installBlock">
				<table class="formBlock">
				<tr>
					<td valign="top">../{basename(CONFIG_PATH)}</td>
					<td align="left"><b><?php if ($checks['config_writable']): ?><span class="green">writeable</span><?php else: ?><span class="red">not writeable</span><?php endif; ?></b></td>
					<td>&nbsp;</td>
                </tr><tr>
					<td valign="top">Database connection</td>
					<td align="left"><b><?php if ($checks['db_connect']): ?><span class="green">OK</span><?php else: ?><span class="red">Failed</span><?php endif; ?></b></td>
					<td>&nbsp;</td>
				</tr>
				</table>
				<p>
				In order to upgrade Flyspray
				correctly it needs to be able to access and write flyspray.conf.php.
				</p>
			</div>
            <?php if (!$upgrade_possible): ?>
            Apparently, an upgrade is not possible. {$todo}
            <?php else: ?>
            Apparently, an upgrade is possible.
            </p>

            <h2>Precautions</h2>
            <p>Create a backup of your <strong>database</strong> <em>and</em> all Flyspray related <strong>files</strong> before performing the upgrade.</p>

            <?php if (isset($upgrade_options)): ?>
            <h2>Upgrade options</h2>
            <p>{!$upgrade_options}</p>
            <?php endif; ?>

            <h2>Perform Upgrade</h2>
            <p>
              <input name="upgrade" id="upgradebutton" class="button" value="Perform Upgrade > >" type="submit" />
              <?php if (isset($done) && $done == true): ?>
              <span class="green"><strong>Done!</strong></span>
              <?php elseif (isset($done) && $done == false): ?>
              <div id="error"><h3 class="red"><strong>Failed!</strong></h3><p>Details about the error:</p><pre><code>{$errormsg}</code></pre></div>
              <?php else: ?>
              (this may take a while)
              <?php endif; ?>
            </p>
            <?php endif; ?>
        </div><!-- End of install -->
        </form>
        <div class="clr"></div>
      </div><!-- End of bodyContent -->
      <div class="clr"></div>
    </div><!-- End of content -->
    <div id="footer">
      <p>
        Flyspray {$fs->version} [Funiculì, Funiculà]<br />
        Copyright 2004-{date('Y')} &copy; Tony Collins and the Flyspray team.  All rights reserved.
      </p>
    </div><!-- End of footer -->
  </div><!-- End of container -->
</div><!-- End of center -->
</body>
</html>