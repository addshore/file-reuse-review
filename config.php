<?php
return [
	'debug' => true,
	'swiftmailer.transport' => Swift_SendmailTransport::newInstance('/usr/sbin/sendmail -bs'),
	'feedback_email' => 'tools.file-reuse@tools.wmflabs.org ', // the email address that receives the feedback
];